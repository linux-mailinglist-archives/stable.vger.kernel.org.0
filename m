Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93B660C145
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 03:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiJYBoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 21:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiJYBnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 21:43:51 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD135A83B;
        Mon, 24 Oct 2022 18:28:14 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OLNnHF020951;
        Mon, 24 Oct 2022 18:28:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 in-reply-to : references : from : subject : to : cc; s=pfptdkimsnps;
 bh=j8u7odBZ81mHIRZo/nAx2BOvHTuFJvY2SBxLiVE7XW8=;
 b=g2djoElJlr2d635rDaxqamCOxBkKnJGFu+eLVDCALgsXZDpqeYebIJTXgpgygQ5ct3lA
 UIMoC0ugzgJThANzZNhDRShdO5vUTYJNpo5rc4XlXkXzWrhWW+Mji7iYi0zzPo6VO5O3
 uiKVZP1DkBCq2Hqpl2LeUc/cm8/EK9sHaPqSeOBU/MYQ9z+tL8xt1J8K1QvVXbRKhVT/
 lX99fcU1zm9SUwW5EHhaPqgGTMDC9bfKRem2jKoTzUoZ4SUsG3WZKSaQdvpX9MAL+57F
 tE28VNuEVfem01f7DgEwH/9S/0ZSRh+TCQdfRZfyTnWR/6lQYa5ZmY2zccWy6yKlP8hW ig== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kcfhp3nx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 18:28:07 -0700
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1A1E24014E;
        Tue, 25 Oct 2022 01:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666661286; bh=7+buHRxrH15h1LLhl9qL95HI2i43zo5YDGWA6OAiTaw=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=HXITD/Jxu8NQ+daO8CGFXMgYzvy8C/QqSbQkjKw/FetR+uPnCNX7ydyvDE4AjWHDF
         3bI4qBQLQruMLNRmaGvXUXYImD1L1RklDVNFlMKYaiZ9BMxVdExNqcpU2IPfkGHRNp
         sNqSPM4RTap9nVp4meQyY1IJKSMrj2yAlU+aaXeWWVPM/H+zlTHDBXl8u7+Dyn+oi7
         b5tlH1oC88X/H24YL4hhzmowAIOBKPBgF6GSfFc80Ofw+cUNpj5yC7kcIstlxQpemm
         89nt1j3VfomsAq9lMbJGO73ul/maJHbX94ACpzUslJR8tqUvqGun+D9NyOQyZypyFz
         Ow9+h3a22HXGA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id A0F2CA007F;
        Tue, 25 Oct 2022 01:28:04 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 24 Oct 2022 18:28:04 -0700
Date:   Mon, 24 Oct 2022 18:28:04 -0700
Message-Id: <453f4dc3189eb855e31768d5caa6bfc7f4bf5074.1666661013.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
References: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2 2/2] usb: dwc3: gadget: Don't set IMI for no_interrupt
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Jeff Vanhoof <jdv1029@gmail.com>,
        Dan Vacura <w36195@motorola.com>
X-Proofpoint-GUID: vmE0e8uHF1a0MSEG2IkviMt6huOWc_kJ
X-Proofpoint-ORIG-GUID: vmE0e8uHF1a0MSEG2IkviMt6huOWc_kJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_09,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxlogscore=655 malwarescore=0 clxscore=1015 impostorscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210250007
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The gadget driver may have a certain expectation of how the request
completion flow should be from to its configuration. Make sure the
controller driver respect that. That is, don't set IMI (Interrupt on
Missed Isoc) when usb_request->no_interrupt is set.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 Changes in v2:
 - None

 drivers/usb/dwc3/gadget.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 230b3c660054..702bdf42ad2f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1292,8 +1292,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
 		}
 
-		/* always enable Interrupt on Missed ISOC */
-		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
+		if (!req->request.no_interrupt)
+			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
 		break;
 
 	case USB_ENDPOINT_XFER_BULK:
-- 
2.28.0

