Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA1460C064
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 03:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJYBF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 21:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiJYBEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 21:04:45 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF41CCD5CE;
        Mon, 24 Oct 2022 17:07:54 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OLNjek020894;
        Mon, 24 Oct 2022 17:07:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 in-reply-to : references : from : subject : to : cc; s=pfptdkimsnps;
 bh=EYvCLwXE7N8UHyBMWu0cT95qCOy0mP8syxq25Uj065Y=;
 b=TGKNpLh8LSNmCimiTh98K6rRM9hVe9QDx1zlLLhhLk8m10m6iPOUfNB9JjB7NGIrhXf8
 6gzQj08R6A+Y8aUWcGv1yH6x5bJDO9C/ECnMXyMiCywPNdx3ViS2TIiRYpLlZF5JeIKU
 4IyC9Llm+ytZoqEFRJYQ4MHjPRxn7Bs6OVv0jDJYhGYZlXrW9dg9Ho2rZX2jgjcfgr30
 EWxeFlsO7IOyieu2od12TEICyIAY/TStZzyGTHFRIPe9Dx/CRg0scFVLV1EQ8Z08vzla
 YxLuNktPNj+QgyLzbWYAxl5xFu/v/YPHjqA81yYKTwwLa8eIze4oIw3SFI1QPLamjdpo aQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kcfhp3cm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 17:07:44 -0700
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AD0FBC00F4;
        Tue, 25 Oct 2022 00:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666656463; bh=yBAdBjNf0E8zEWDgkgWHccmD+knvyVpZE05CLrwllCM=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=gYFqARox4iAPjaSSR5yeDwotj7y8UNBmSerbWuf7wdJw8f/5lf4aTbn+oUWDWPwVY
         0Kz0oqaxQredd6AraEbZNTL4OrrRc4aY3JCoCBi6px5UfCuoJ24HfEJ2ZN+vOCbgVp
         IlOhN7iTEy2FMMzaxAgNTByMEzGTzUU1hWYbvnWikjfjnYZQ5h0eNm5macdbiUIqKU
         Pn9Eb0KN5KzH7JQ54zuyP8SmpMnMywNzhdFE4objyB28Eovg8dT4t8Z9I0s/LCMZju
         2D+GuPOBL2PVK6gFRO4Hy8d8NVksMqyeM4DMtlUJiqZG34CDqHd2KX5d5PKhgHzzZK
         X7+IpbHnkf5yA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 54A3FA0065;
        Tue, 25 Oct 2022 00:07:42 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 24 Oct 2022 17:07:42 -0700
Date:   Mon, 24 Oct 2022 17:07:42 -0700
Message-Id: <5a1dbf32f400c7dc2256dd9a8245f4b9a291201c.1666654589.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1666654589.git.Thinh.Nguyen@synopsys.com>
References: <cover.1666654589.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 1/2] usb: dwc3: gadget: Stop processing more requests on IMI
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Jeff Vanhoof <jdv1029@gmail.com>,
        Dan Vacura <w36195@motorola.com>
X-Proofpoint-GUID: GLHIER7qClTfsNOKBw05lZmmTBscfrDx
X-Proofpoint-ORIG-GUID: GLHIER7qClTfsNOKBw05lZmmTBscfrDx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_08,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxlogscore=721 malwarescore=0 clxscore=1015 impostorscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240144
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
missed isoc. So we only need to check for the status of TRB with CHN=0.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable@vger.kernel.org
Reported-by: Jeff Vanhoof <jdv1029@gmail.com>
Reported-by: Dan Vacura <w36195@motorola.com>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index dd8ecbe61bec..5f321aa205be 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3248,6 +3248,11 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
+	if ((trb->ctrl & DWC3_TRB_CTRL_ISP_IMI) &&
+	    !(trb->ctrl & DWC3_TRB_CTRL_CHN) &&
+	    DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
+		return 1;
+
 	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
 	    (trb->ctrl & DWC3_TRB_CTRL_LST))
 		return 1;
-- 
2.28.0

