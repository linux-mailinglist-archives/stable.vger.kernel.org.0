Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DE624F315
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 09:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHXH0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 03:26:00 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:49447 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbgHXH0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 03:26:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C237E19413EA;
        Mon, 24 Aug 2020 03:25:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 24 Aug 2020 03:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gx7gzT
        u4ug7VfhBuVNoF/7AOEL9SN0yzbUrvtSY+bYc=; b=QBFJ+7sRDDMdnDo1a8a77b
        BtzKxsMFQDiBO8pAq47J4VVoIDk1sODQ+V1AQJzyIUugzmZVEXQUvivm1K/TLGY8
        lF6dBNeqUovGJGVaZwOyWN9VL57jF1FkJ8Ol6rzqnI49RW2zRHFnuYUKHyKirq/6
        KYmPAwja9eVVcIljKKPPWQIcknizA+xsZeT0CUa3H580EZuUo7vh8dUAUOjlmH0N
        uTP37Eoi2lKlVVG4GvSmfgubc9v2VwM7KYrk3uYj7a1MqimCrUS9TSE3YAjDzIXu
        +FZ6TZoidDlgwAYg0Fjf5p1l9u9+XXsXAci7fOMde1nc5tdSmafaaiixxMaL4gHA
        ==
X-ME-Sender: <xms:hmtDX-W9J1A_aitzjF0cwYdRKhSwI_uIbL4eX8L-8GOKkW0toKRoBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddujedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:hmtDX6m0mcKpzlgBKS_nPUclwaOA-KS2mggUPH3N1Z9aoipBW_bXhg>
    <xmx:hmtDXyYa7gSple-QcUv8pXUNj3IT1UizlUX699751vNjXqaKpc7vgA>
    <xmx:hmtDX1WyylglHur1Iu0dParXvxEIFMji-h-N6ICYe9ZlEARYQneM1g>
    <xmx:hmtDX_sVug6RlQh3j9fAeokbaORiosQ3eVPbjb47e8G1HiL8-mpnkw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C5D730600B1;
        Mon, 24 Aug 2020 03:25:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] EDAC/{i7core,sb,pnd2,skx}: Fix error event severity" failed to apply to 5.4-stable tree
To:     tony.luck@intel.com, bp@suse.de, gabriele.paoloni@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Aug 2020 09:26:17 +0200
Message-ID: <1598253977209162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 45bc6098a3e279d8e391d22428396687562797e2 Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Tue, 7 Jul 2020 12:43:24 -0700
Subject: [PATCH] EDAC/{i7core,sb,pnd2,skx}: Fix error event severity

IA32_MCG_STATUS.RIPV indicates whether the return RIP value pushed onto
the stack as part of machine check delivery is valid or not.

Various drivers copied a code fragment that uses the RIPV bit to
determine the severity of the error as either HW_EVENT_ERR_UNCORRECTED
or HW_EVENT_ERR_FATAL, but this check is reversed (marking errors where
RIPV is set as "FATAL").

Reverse the tests so that the error is marked fatal when RIPV is not set.

Reported-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200707194324.14884-1-tony.luck@intel.com

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 5860ca41185c..2acd9f9284a2 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1710,9 +1710,9 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 	if (uncorrected_error) {
 		core_err_cnt = 1;
 		if (ripv)
-			tp_event = HW_EVENT_ERR_FATAL;
-		else
 			tp_event = HW_EVENT_ERR_UNCORRECTED;
+		else
+			tp_event = HW_EVENT_ERR_FATAL;
 	} else {
 		tp_event = HW_EVENT_ERR_CORRECTED;
 	}
diff --git a/drivers/edac/pnd2_edac.c b/drivers/edac/pnd2_edac.c
index fd363746f5b0..b8fc4b84fd86 100644
--- a/drivers/edac/pnd2_edac.c
+++ b/drivers/edac/pnd2_edac.c
@@ -1155,7 +1155,7 @@ static void pnd2_mce_output_error(struct mem_ctl_info *mci, const struct mce *m,
 	u32 optypenum = GET_BITFIELD(m->status, 4, 6);
 	int rc;
 
-	tp_event = uc_err ? (ripv ? HW_EVENT_ERR_FATAL : HW_EVENT_ERR_UNCORRECTED) :
+	tp_event = uc_err ? (ripv ? HW_EVENT_ERR_UNCORRECTED : HW_EVENT_ERR_FATAL) :
 						 HW_EVENT_ERR_CORRECTED;
 
 	/*
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index d414698ca324..c5ab634cb6a4 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -2982,9 +2982,9 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	if (uncorrected_error) {
 		core_err_cnt = 1;
 		if (ripv) {
-			tp_event = HW_EVENT_ERR_FATAL;
-		} else {
 			tp_event = HW_EVENT_ERR_UNCORRECTED;
+		} else {
+			tp_event = HW_EVENT_ERR_FATAL;
 		}
 	} else {
 		tp_event = HW_EVENT_ERR_CORRECTED;
diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 6d8d6dc626bf..2b4ce8e5ac2f 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -493,9 +493,9 @@ static void skx_mce_output_error(struct mem_ctl_info *mci,
 	if (uncorrected_error) {
 		core_err_cnt = 1;
 		if (ripv) {
-			tp_event = HW_EVENT_ERR_FATAL;
-		} else {
 			tp_event = HW_EVENT_ERR_UNCORRECTED;
+		} else {
+			tp_event = HW_EVENT_ERR_FATAL;
 		}
 	} else {
 		tp_event = HW_EVENT_ERR_CORRECTED;

