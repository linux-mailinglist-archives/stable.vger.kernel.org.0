Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E105B7ECD
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 04:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiINCDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 22:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiINCDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 22:03:40 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86959F58F
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 19:03:38 -0700 (PDT)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28E0g1jD018666;
        Wed, 14 Sep 2022 02:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=QolIqiX374QmbN5oEoOW2FkwkMUgvkr+QZk1PmONZrM=;
 b=neNT0qUkK6Emg/TDZXPATuJMitI4pB9BqNUhvtYef5KHA991no+3tH3mnTUIiqRXa6VP
 8MpMF8zGXsDyxyK4oTk16uLdaAoMhvjNvGo9dLWix/J1DsR5hHD+bkDSexkKHOWkaoRx
 OwpC1f1cSxVg7H7mkMdvUb2q2OY0bLleGrqbb3FPmvoMWLBZrbEzjkFGat9MSG6R3CBV
 yAKhX7upt3AqED3LRiIKb6AUXlcWUMv9SPBSX1UwTSGTZmeUN+AmICehkzbl4HesW2Zs
 46VZO4dLkXvpCzhKeXDzXv6I4wgIsXFWtFE3/v5IgDj2zOOlnOU7zbzIBiUIXEnzPw43 6g== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jjy008x1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 02:03:35 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28E23YHH027253
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 02:03:34 GMT
Received: from jackp-linux.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 13 Sep 2022 19:03:34 -0700
From:   Jack Pham <quic_jackp@quicinc.com>
To:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Colin Ian King <colin.king@canonical.com>,
        Jack Pham <quic_jackp@quicinc.com>
Subject: [PATCH 5.15 1/2] usb: gadget: f_uac2: clean up some inconsistent indenting
Date:   Tue, 13 Sep 2022 19:03:12 -0700
Message-ID: <20220914020313.3187-1-quic_jackp@quicinc.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: vmhofl1kauUbQc4mk5rWiFouq7K3KT86
X-Proofpoint-ORIG-GUID: vmhofl1kauUbQc4mk5rWiFouq7K3KT86
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_12,2022-09-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 spamscore=0 clxscore=1011 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=994
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209140008
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 18d6b39ee8959c6e513750879b52fd215533cc87 upstream.

There are bunch of statements where the indentation is not correct,
clean these up.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210902224758.57600-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jack Pham <quic_jackp@quicinc.com>
---
 drivers/usb/gadget/function/f_uac2.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 5226a47b68fd..4072cde4f0c9 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -760,15 +760,15 @@ static void setup_headers(struct f_uac2_opts *opts,
 		headers[i++] = USBDHDR(&out_clk_src_desc);
 		headers[i++] = USBDHDR(&usb_out_it_desc);
 
-    if (FUOUT_EN(opts))
-      headers[i++] = USBDHDR(out_feature_unit_desc);
-  }
+		if (FUOUT_EN(opts))
+			headers[i++] = USBDHDR(out_feature_unit_desc);
+	}
 
 	if (EPIN_EN(opts)) {
 		headers[i++] = USBDHDR(&io_in_it_desc);
 
-    if (FUIN_EN(opts))
-      headers[i++] = USBDHDR(in_feature_unit_desc);
+		if (FUIN_EN(opts))
+			headers[i++] = USBDHDR(in_feature_unit_desc);
 
 		headers[i++] = USBDHDR(&usb_in_ot_desc);
 	}
@@ -776,10 +776,10 @@ static void setup_headers(struct f_uac2_opts *opts,
 	if (EPOUT_EN(opts))
 		headers[i++] = USBDHDR(&io_out_ot_desc);
 
-  if (FUOUT_EN(opts) || FUIN_EN(opts))
-      headers[i++] = USBDHDR(ep_int_desc);
+	if (FUOUT_EN(opts) || FUIN_EN(opts))
+		headers[i++] = USBDHDR(ep_int_desc);
 
-  if (EPOUT_EN(opts)) {
+	if (EPOUT_EN(opts)) {
 		headers[i++] = USBDHDR(&std_as_out_if0_desc);
 		headers[i++] = USBDHDR(&std_as_out_if1_desc);
 		headers[i++] = USBDHDR(&as_out_hdr_desc);
-- 
2.24.0

