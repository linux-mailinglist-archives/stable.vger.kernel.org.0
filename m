Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452F260C067
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 03:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJYBFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 21:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiJYBEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 21:04:50 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D10544CF5;
        Mon, 24 Oct 2022 17:08:02 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OLNuvt031877;
        Mon, 24 Oct 2022 17:07:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 in-reply-to : references : from : subject : to : cc; s=pfptdkimsnps;
 bh=8Z8o/vi528Sv9lp6aYDwYrqYLg5AITl8XsRnzx6g8Nk=;
 b=DyvKERdRCfMZX+Iv2esYiRZQw6qjTElcUpZnIg/QpiYkLxpRwDLGjbD8BlW7NcMzgpa1
 hry/NquLvRfv42iZUpVvRdf/rSg4/h7/JsZH2NC4sC/w4txj6IXK7pV2oN/Woaedg9np
 hbpF/nbfsW7RRgvAu881ZjpZP4PTAc4pDesczKbqwNwfbb4o1TqWsbQZYgkLALeNhzA4
 X+kI5UV+SQi8h59w3pY5UR0PWLYpuEfVBkuJ5/vDILOwE1eCjmWiz7B/YETcbUwPcW8W
 hR6zLfcN16XhSl+ubFA8TspWh3wcrPRhd2zgcj+E4V//HpTIAwDklu5IFgztyFMCWbIH IQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kcfevub0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 17:07:51 -0700
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6100F400E5;
        Tue, 25 Oct 2022 00:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666656470; bh=Vy8uQ9J+WzPZ/Icyh8gFvx4DwbJZYwxrG4j9NhBTTE8=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=Q5is4hhq3eQFvTGcbOF/rIUdfv6sL5c/YwAQJla1RS0nfaC6UVav/TphnaWwWjWFS
         yN5vt5mpeAZfqP0VxHWbZSf1gK6DCWN32jHExFcxoHjhtTb5a8zK1Qvq+g9O9B5OzB
         2aVh3S/m/K2GBTdMxWc9YikW97FRRv3lAodU+HVQlv26B4ZQYY6Le5ev++6HWRbyzG
         4TNoV9pmzKN7NPAe9MqTP5E088rlABuVbfbL5nXGtitJgcqXWqL8pc8rf8asxwbq1H
         e0hmuhl4i/F6a9yh6RhJSl4o+p3YzEIiLD6GWpdjAxK+/cQ93x2OqfZS5oGv1b7r5S
         Lmc0J304PLzqw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id C555FA0078;
        Tue, 25 Oct 2022 00:07:48 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 24 Oct 2022 17:07:48 -0700
Date:   Mon, 24 Oct 2022 17:07:48 -0700
Message-Id: <147a17132f498ebe196accb2aab2068ed7a8e696.1666654589.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1666654589.git.Thinh.Nguyen@synopsys.com>
References: <cover.1666654589.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 2/2] usb: dwc3: gadget: Don't set IMI for no_interrupt
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Jeff Vanhoof <jdv1029@gmail.com>,
        Dan Vacura <w36195@motorola.com>
X-Proofpoint-ORIG-GUID: Yz_icPVi2bI-soMK1EIEodw5O9jDE9VU
X-Proofpoint-GUID: Yz_icPVi2bI-soMK1EIEodw5O9jDE9VU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_07,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 phishscore=0 mlxlogscore=635 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210240143
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
 drivers/usb/dwc3/gadget.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5f321aa205be..92fb2f14850b 100644
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

