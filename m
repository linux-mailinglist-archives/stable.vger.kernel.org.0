Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1B51E10A8
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 16:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390877AbgEYOiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 10:38:09 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:54965 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgEYOiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 10:38:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 11C581942447;
        Mon, 25 May 2020 10:38:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 May 2020 10:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dis9e7
        uAhgAzqFeb41tGIbgB5FM8yiIllfiK2l1vFjg=; b=bzlV16kkCO4BxkVHKzrOFE
        k2myg9cV4pfbPQJ7x4NfRJHPN6ujWkxNMaVnFwzm8faHsAF/Ny/DnevqL3BbnbK3
        SMzPP+pqTVNOtI0VapgJshnkM9zZeQrPKAsrq1l8rtQwiU6x+wGVfkljyWbu2zQb
        O1u2o6jxZCENIFLKTUXxCF0qxIRZC5nA4JI/kHX9R5eNTjHtpmvadlH5Gr7hjvud
        E+M9wJJTi77pjDN4+iteLG5V0UC+MUZdTxV2sRc4ou/eLgYrw9fQd+sdVsH5oFy3
        f5NF5ceJaWl1201vmALcxwlwfS6GFCa+1/lWhf/8Cwb7ji9vN0U+YwCqTpolp4sA
        ==
X-ME-Sender: <xms:T9jLXjuJIckfrbKKeJa_UvTFTmshZ9uOMOxlF8OGE8_wCxm4fmOGZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepueekgfelvdfhieelleekvddtieekgfduhffhhfevve
    efuddviefghfehgeefvdffnecuffhomhgrihhnpehrvgguhhgrthdrtghomhdpkhgvrhhn
    vghlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:T9jLXkeM7LgLkDmZbKwOv7oCeKaoXz7RkZXSoPhq1A7gqvEIqI9jWw>
    <xmx:T9jLXmzckx08Iq6Hp8upK5_24DrLSswYIMJlX4BIwclBcPKRdkJuoA>
    <xmx:T9jLXiNOcZD-3rxI6DwXjLYDUXRqN-nSBTRoItXbIhRFUaVAtWL4Zw>
    <xmx:UNjLXlIRm-sV0fGZfz3GA-znGx-y2o4whz6n15JVZsU_9E5KNBRvCA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9FFFE328005E;
        Mon, 25 May 2020 10:38:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tpm: check event log version before reading final events" failed to apply to 5.4-stable tree
To:     loic.yhuel@gmail.com, ardb@kernel.org, javierm@redhat.com,
        jsnitsel@redhat.com, mjg59@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 16:38:06 +0200
Message-ID: <1590417486228242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From b4f1874c62168159fdb419ced4afc77c1b51c475 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Lo=C3=AFc=20Yhuel?= <loic.yhuel@gmail.com>
Date: Tue, 12 May 2020 06:01:13 +0200
Subject: [PATCH] tpm: check event log version before reading final events
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This fixes the boot issues since 5.3 on several Dell models when the TPM
is enabled. Depending on the exact grub binary, booting the kernel would
freeze early, or just report an error parsing the final events log.

We get an event log in the SHA-1 format, which doesn't have a
tcg_efi_specid_event_head in the first event, and there is a final events
table which doesn't match the crypto agile format.
__calc_tpm2_event_size reads bad "count" and "efispecid->num_algs", and
either fails, or loops long enough for the machine to be appear frozen.

So we now only parse the final events table, which is per the spec always
supposed to be in the crypto agile format, when we got a event log in this
format.

Fixes: c46f3405692de ("tpm: Reserve the TPM final events table")
Fixes: 166a2809d65b2 ("tpm: Don't duplicate events from the final event log in the TCG2 log")
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1779611
Signed-off-by: Loïc Yhuel <loic.yhuel@gmail.com>
Link: https://lore.kernel.org/r/20200512040113.277768-1-loic.yhuel@gmail.com
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Matthew Garrett <mjg59@google.com>
[ardb: warn when final events table is missing or in the wrong format]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
index 1d59e103a2e3..e9a684637b70 100644
--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -54,7 +54,7 @@ void efi_retrieve_tpm2_eventlog(void)
 	efi_status_t status;
 	efi_physical_addr_t log_location = 0, log_last_entry = 0;
 	struct linux_efi_tpm_eventlog *log_tbl = NULL;
-	struct efi_tcg2_final_events_table *final_events_table;
+	struct efi_tcg2_final_events_table *final_events_table = NULL;
 	unsigned long first_entry_addr, last_entry_addr;
 	size_t log_size, last_entry_size;
 	efi_bool_t truncated;
@@ -127,7 +127,8 @@ void efi_retrieve_tpm2_eventlog(void)
 	 * Figure out whether any events have already been logged to the
 	 * final events structure, and if so how much space they take up
 	 */
-	final_events_table = get_efi_config_table(LINUX_EFI_TPM_FINAL_LOG_GUID);
+	if (version == EFI_TCG2_EVENT_LOG_FORMAT_TCG_2)
+		final_events_table = get_efi_config_table(LINUX_EFI_TPM_FINAL_LOG_GUID);
 	if (final_events_table && final_events_table->nr_events) {
 		struct tcg_pcr_event2_head *header;
 		int offset;
diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index 31f9f0e369b9..0543fbf60222 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -62,8 +62,11 @@ int __init efi_tpm_eventlog_init(void)
 	tbl_size = sizeof(*log_tbl) + log_tbl->size;
 	memblock_reserve(efi.tpm_log, tbl_size);
 
-	if (efi.tpm_final_log == EFI_INVALID_TABLE_ADDR)
+	if (efi.tpm_final_log == EFI_INVALID_TABLE_ADDR ||
+	    log_tbl->version != EFI_TCG2_EVENT_LOG_FORMAT_TCG_2) {
+		pr_warn(FW_BUG "TPM Final Events table missing or invalid\n");
 		goto out;
+	}
 
 	final_tbl = early_memremap(efi.tpm_final_log, sizeof(*final_tbl));
 

