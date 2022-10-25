Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74D460D6D0
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiJYWKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiJYWKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:10:30 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0668C5246D;
        Tue, 25 Oct 2022 15:10:26 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJs0Wx024247;
        Tue, 25 Oct 2022 15:10:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 in-reply-to : references : from : subject : to : cc; s=pfptdkimsnps;
 bh=9CxM6aupASiANSUzbXZW9Uqgerx2QRzkhLVc8bI/5LQ=;
 b=YDBvTLm2gfifXfoBY+Lq0FYMBLEziIo1snRCfdWwJ5wCWoPJ4be/4Zr7fEcfvdl/sWZ/
 vaBRIJ8+xqpz46gOQPVb/CfBXsLOsF9Vb0dZNKOOSe1uTcfpqWf7yrDTrtOfu5SGioBh
 MkQeT0s3WLQtU5NioWDVQtMGcbzZEypk3FSUJmJjlyYCez0xiQUDxhH3qrT42W5OVhhl
 v+ax+8M6SPEpOcB2KOCiEaTTGMoAAnWTey2y5tD9AZOPB1UUbu3dXZuKokjRNOBle//g
 HCVhwo7ZQsXOJmU030vXrL2wyN6j4eZfxKjax2LMKmM03OzlWoh3qPjZPt+uy3UsPX3y Jw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kcfs7hhs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 15:10:22 -0700
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B7B32C0108;
        Tue, 25 Oct 2022 22:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666735821; bh=tLoqdZUGbh7sY7UVZKCMuJJOgURuE/GMoTIszsAyKFo=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=Oyhxm9PJpEG29s7XLJY1vLNgh97jaod/ukjypRq/+SDPP/sAm8I4MdCdisBh6UdwZ
         46B9nSrej0l24somXfKmfWGbEMebRalFqvvv4ewiNVEF2XrO+7rrD70m/BYrFrZCNt
         Ms1kQN/CWyqt77UnU2Y9ZbqlavLw3ZeUte2srv3aVHNWZHbuFEdeZUe+gTEju6Bmpb
         dAMaNUPBCJeyrnaii/D9wszdYyM+HXtEBI6WJa75mK877g0yebV4JDOgxwHWgHsO1y
         CRRWYj2RCqrLGCgIMUka1hdWe2odI9w4wN8l+50ijo4CeYpu2xuZwQLKuEQPENqgTC
         vtouU2vQL6/4Q==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 816DEA00B2;
        Tue, 25 Oct 2022 22:10:20 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Tue, 25 Oct 2022 15:10:20 -0700
Date:   Tue, 25 Oct 2022 15:10:20 -0700
Message-Id: <ced336c84434571340c07994e3667a0ee284fefe.1666735451.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1666735451.git.Thinh.Nguyen@synopsys.com>
References: <cover.1666735451.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v3 2/2] usb: dwc3: gadget: Don't set IMI for no_interrupt
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
X-Proofpoint-GUID: KfuK_iYSS4NJeIK0ylf0SzwvFwDcYB_F
X-Proofpoint-ORIG-GUID: KfuK_iYSS4NJeIK0ylf0SzwvFwDcYB_F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_13,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0
 adultscore=0 mlxlogscore=655 spamscore=0 clxscore=1015 suspectscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210250123
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
Missed Isoc) when usb_request->no_interrupt is set. Also, the driver
should only set IMI to the last TRB of a chain.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 Changes in v3:
 - Set IMI to only the last TRB of a chain
 Changes in v2:
 - None

 drivers/usb/dwc3/gadget.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 230b3c660054..5fe2d136dff5 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1292,8 +1292,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
 		}
 
-		/* always enable Interrupt on Missed ISOC */
-		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
+		if (!no_interrupt && !chain)
+			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
 		break;
 
 	case USB_ENDPOINT_XFER_BULK:
-- 
2.28.0

