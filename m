Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2AB60C143
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 03:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiJYBoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 21:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiJYBnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 21:43:50 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD975927A;
        Mon, 24 Oct 2022 18:28:12 -0700 (PDT)
Received: from pps.filterd (m0098572.ppops.net [127.0.0.1])
        by mx0b-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OLNx5i007175;
        Mon, 24 Oct 2022 18:28:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 in-reply-to : references : from : subject : to : cc; s=pfptdkimsnps;
 bh=uYUGAVAa1Q97ISEtrVzAlQ5It6B9/TBGz8KCxuZyLj4=;
 b=fA/GTWMHO4AfAE2m5rr/4zJo7+cwECURbYfHN8KOF0U8b0jgiQpohUoQOU9inyITL0kp
 MPvBmpArWT582OKUpEk3xInv76Yu8IFjkMDZBPCf16bX5nxnxV8rQRDnU55oLoJZpl76
 i38QLizwSQtM8VUPCB+RyMIvoiWeFa/LTynNiMXa7Qm0DiMFBxhtjLz1Bs/LTrPnrl+5
 wn1DiiaEJbi5AaxXG78bNjHTYLMluZ8b7xIAIPevXB9AVsGu3TH7PzcaZ8lh1eAaUOWv
 9ToL08YCsiTZeGlIF+N7clTLTmFFMthkVUG/69PVn90J8sjd9IG3DN3V3VpLtZ38tOKr bQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0b-00230701.pphosted.com (PPS) with ESMTPS id 3kcf5gbp4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 18:28:00 -0700
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 89453C00F4;
        Tue, 25 Oct 2022 01:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666661279; bh=DIoEktsoB9CAMG7gYxfrV0/WknKZPtxZ+gnVC0x+7Gs=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=kkNAYFGoWZTh8I3n+vTErXBYpPO+Q7cD9GH8Jjdaj2V9gILXUOHndLrrc28xZh4A3
         oRZ0W7B4CBaWbYVnxLrQHCMeZfIUj5zVJtsnYsg/wkgq5MqUa/IQjw22klcVP/qCRq
         4eMHi0uA4kng8vORwFSlp0dBPFhPAJO6tYzEBVLAzYKhT5Rmdj4QJel4+AYAUvBmWq
         ZosNULxUUE7N8Mr7w+1l6+7CRlyGbkGU+SGQNqqgOu8VwpGQWT8y6l2Z0uYNmgjS5I
         7bQBO3+0N/yvuJxDyJex1x0828GtUpmbDRdVa9Ga5loZnjuWlHWYqe7kC4lBDKJMil
         dQ2iyui7Wwb6w==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 2ADBFA00AF;
        Tue, 25 Oct 2022 01:27:57 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 24 Oct 2022 18:27:57 -0700
Date:   Mon, 24 Oct 2022 18:27:57 -0700
Message-Id: <699a342b618611be834b06d9d64abae7d01486cd.1666661013.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
References: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2 1/2] usb: dwc3: gadget: Stop processing more requests on IMI
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Jeff Vanhoof <jdv1029@gmail.com>,
        Dan Vacura <w36195@motorola.com>
X-Proofpoint-ORIG-GUID: KG1nHHNMpO7k3_znj41QVbPRssSuUmdY
X-Proofpoint-GUID: KG1nHHNMpO7k3_znj41QVbPRssSuUmdY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_09,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxlogscore=716 lowpriorityscore=0 phishscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 priorityscore=1501 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210250006
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When servicing a transfer completion event, the dwc3 driver will reclaim
TRBs of started requests up to the request associated with the interrupt
event. Currently we don't check for interrupt due to missed isoc, and
the driver may attempt to reclaim TRBs beyond the associated event. This
causes invalid memory access when the hardware still owns the TRB. If
there's a missed isoc TRB with IMI (interrupt on missed isoc), make sure
to stop servicing further.

Note that only the last TRB of chained TRBs has its status updated with
missed isoc.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable@vger.kernel.org
Reported-by: Jeff Vanhoof <jdv1029@gmail.com>
Reported-by: Dan Vacura <w36195@motorola.com>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 Changes in v2:
 - No need to check for CHN=0 since only the last TRB has its status
   updated to missed isoc

 drivers/usb/dwc3/gadget.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index dd8ecbe61bec..230b3c660054 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3248,6 +3248,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
+	if ((trb->ctrl & DWC3_TRB_CTRL_ISP_IMI) &&
+	    DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
+		return 1;
+
 	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
 	    (trb->ctrl & DWC3_TRB_CTRL_LST))
 		return 1;
-- 
2.28.0

