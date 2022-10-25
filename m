Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D559E60D6D2
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiJYWKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiJYWKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:10:30 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CB450535;
        Tue, 25 Oct 2022 15:10:26 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJrCIb010417;
        Tue, 25 Oct 2022 15:10:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 in-reply-to : references : from : subject : to : cc; s=pfptdkimsnps;
 bh=1Vt3493KlvxfCtybA4JwALtCS1zopsH6rNx4Jlf/tPw=;
 b=rXmK6eXIFQb4Bm3bja+nHAqaqMP1kEguHvX5pu4Wz3b76+BIQKhLS/INip7Fml0zSGXN
 09SxMWHk1zPX1ab4fwtxu92t7g9D/IKfLqRyl7Vz0yYkBxOU2QYqiLNzg9xTuaiArvbG
 khYVStN0RdRwjROZ9kWJHp4SzSSyCosWnzTfeAqiAoLmYBO7cn0z4VB5DSv39ILwFUgM
 CgU9D/x8V9MJgQse+atthhIyqLEhEfuUG847BggHs5OjWyBYVhqmX+S1gitPcS+Xpjr4
 2j+MBtvNgmeQU+9fKZoN3GNA3HhO2wxfUI7iV0Mv1b9cR/JJ/Rj1cf5g0PMY8X0KgScH sg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3kcfew1eky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 15:10:16 -0700
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A0115C0108;
        Tue, 25 Oct 2022 22:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666735815; bh=Iq4psRf65CIu18SkCW0AONTQsp9VKEJl9RRQ5R43fJw=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=Fhhb+nsVK9FhNnh+Rst9xwz1Y1dP0QUA6vsmSsgBhcTjtc6V6JRoXHRYsCoefNweL
         3/1wzmNYooAxIIe4dTAKte+4q40sNXDIEg9Z8Wd410BSbnYYtVPR77Lj+qD7FzJN3/
         7npqhCvwooFQABqCVLXzO5wBhzzAkRJ255vZ5DJcPdPk7a4GRqwZ9x3YBf+L1a0Qd3
         u+rlzCqDIKLVorxuQfkk25SR+Za9NxvVdfBVdTxBCTGtUwIP3FkfoFSte3Bn+49Via
         /nKuDQ1MTPT0CPrOL4aRQFrmi364QwqSJTnLvr7K9j8GWiaHcv1w0ERJ21UfpYg1MD
         HXSOC1N61VeGw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 44C7BA00A8;
        Tue, 25 Oct 2022 22:10:14 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Tue, 25 Oct 2022 15:10:14 -0700
Date:   Tue, 25 Oct 2022 15:10:14 -0700
Message-Id: <b29acbeab531b666095dfdafd8cb5c7654fbb3e1.1666735451.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1666735451.git.Thinh.Nguyen@synopsys.com>
References: <cover.1666735451.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v3 1/2] usb: dwc3: gadget: Stop processing more requests on IMI
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Jeff Vanhoof <jdv1029@gmail.com>,
        Dan Vacura <w36195@motorola.com>
X-Proofpoint-ORIG-GUID: xEWqHykhVxtFJhueR3Hx8oRaXUUFICIb
X-Proofpoint-GUID: xEWqHykhVxtFJhueR3Hx8oRaXUUFICIb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_13,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 phishscore=0 mlxlogscore=733 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210250123
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
 Changes in v3:
 - None
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

