<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="path" value="${pageContext.request.contextPath }"/>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
<section>
<form id="payEndFrm" action="${path}/market/purchaseGoodEnd.do">
 <input type="hidden"  name="member_id" class="form-control" value="${loginMember.member_id}" readonly>
 <input type="hidden"  name="ordererName" class="form-control" value="${order.ordererName}" readonly>
 <input type="hidden"  name="ordererEmail" class="form-control" value="${order.ordererEmail}" readonly>
 <input type="hidden"  name="ordererPhone" class="form-control" value="${order.ordererPhone}" readonly>
 <input type="hidden"  name="receiverName" class="form-control" value="${order.receiverName}" readonly>
 <input type="hidden"  name="receiverAddress" class="form-control" value="${order.receiverAddress}" readonly>
 <input type="hidden"  name="receiverPhone" class="form-control" value="${order.receiverPhone}" readonly>
 <input type="hidden"  id="totalOp" name="totalOrderPrice" class="form-control" value="${order.totalOrderPrice}" readonly>
 
 <input type="hidden"  name="goodsNo" class="form-control" value="${orderDetail.goodsNo}" readonly>
 <input type="hidden"  name="goodsName" class="form-control" value="${orderDetail.goodsName}" readonly>
 <input type="hidden"  name="orderColor" class="form-control" value="${orderDetail.orderColor}" readonly>
 <input type="hidden"  name="orderSize" class="form-control" value="${orderDetail.orderSize}" readonly>
 <input type="hidden"  name="mbtiLogo" class="form-control" value="${orderDetail.mbtiLogo}" readonly>
 <input type="hidden"  name="orderCount" class="form-control" value="${orderDetail.orderCount}" readonly>
 <input type="hidden"  name="orderPrice" class="form-control" value="${orderDetail.orderPrice}" readonly>
</form>

<script>
$(function(){
    var IMP = window.IMP; // 생략가능
    IMP.init('imp56220496'); // 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
    var msg;
    
    IMP.request_pay({
        pg : 'kakaopay',
        pay_method : 'card',
        merchant_uid : 'merchant_' + new Date().getTime(),
        name : '주문명:결제테스트',
        amount : $("input[name=totalOrderPrice]").val(), //판매 가격
        buyer_email : 'iamport@siot.do',
        buyer_name : '구매자이름',
        buyer_tel : '010-1234-5678',
        buyer_addr : '서울특별시 강남구 삼성동',
        buyer_postcode : '123-456'
        //m_redirect_url : 'http://www.naver.com'
    }, function(rsp) {
        if ( rsp.success ) {
            //[1] 서버단에서 결제정보 조회를 위해 jQuery ajax로 imp_uid 전달하기
            jQuery.ajax({
                url: "/payments/complete", //cross-domain error가 발생하지 않도록 주의해주세요
                type: 'POST',
                dataType: 'json',
                data: {
                    imp_uid : rsp.imp_uid
                    //기타 필요한 데이터가 있으면 추가 전달
                }
            }).done(function(data) {
                //[2] 서버에서 REST API로 결제정보확인 및 서비스루틴이 정상적인 경우
                if ( everythings_fine ) {
                    msg = '결제가 완료되었습니다.';
                    msg += '\n고유ID : ' + rsp.imp_uid;
                    msg += '\n상점 거래ID : ' + rsp.merchant_uid;
                    msg += '\결제 금액 : ' + rsp.paid_amount;
                    msg += '카드 승인번호 : ' + rsp.apply_num;
                    
                    alert(msg);
                } else {
                    //[3] 아직 제대로 결제가 되지 않았습니다.
                    //[4] 결제된 금액이 요청한 금액과 달라 결제를 자동취소처리하였습니다.
                }
            });
            //성공시 이동할 페이지
        <%--    location.href='<%=request.getContextPath()%>/order/paySuccess?msg='+msg; --%>
        $('#payEndFrm').submit();
   /*      location.href="${path}/market/pay."; */
        } else {
            msg = '결제에 실패하였습니다.';
            msg += '에러내용 : ' + rsp.error_msg;
            //실패시 이동할 페이지
            location.href="<%=request.getContextPath()%>/order/payFail";
            alert(msg);
        }
    });
    
});


</script>


</section>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>