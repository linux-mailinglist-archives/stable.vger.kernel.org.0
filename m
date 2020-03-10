Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B57F17F5DC
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgCJLNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:13:14 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41137 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbgCJLNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 07:13:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A9D421CFD;
        Tue, 10 Mar 2020 07:13:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 10 Mar 2020 07:13:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yZAhX2
        OJyzHcBxGI7Ys4Q/Wj09z3CorH/8U7VMi14oc=; b=0SJz3TR6qGtL/1amQ9h+29
        EpvbBB2OTUTFHBn+nyBUjlYx6Fmk/C8vr8FVEv4x9C6W5zT0RWJPcJWz+ohjSE2k
        8ekffIZ//8zRb8Pym5Unf6YV+0Olg7U2gpoqb67RZt/DVhPz3EUy/JCrLCo3nhOF
        EIbpcTDrkh+6U4+fI9pDV0rXQmSasOaHCggFpsw5eb8FKfBe6cGeEqoBJPnE8vNe
        M5t91TmnbKLIJD4PJyBkU4zOq0o1peyHcQ+53lkw3BKAFPdzZsyBBKPa/b0NJkR9
        pZ2HVgG+UgxQ9H4Rmo1Lt25f/k9lVDoupdA22Sn25rUh0Y4KXwGPYiNSBaUGHoYw
        ==
X-ME-Sender: <xms:SHZnXtXOICOOO8AdJnSNMk25geCSryxVOUMUnCG9xZo_eIGe7gSPFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:SHZnXt6cBAw94kwZ3ghgB8m2t3iTgrsXc3lK6_aEnIR6Mp5HeZ7AQA>
    <xmx:SHZnXhAiGWExZr7aSzGXK6iUGQkecaiNN7AYkj0Gksq1oxgJjGyfaQ>
    <xmx:SHZnXq-SP_2kTHKCQZ11J9p4pqz72Rv9quq1VQkFFsFcRGPtzb8ocA>
    <xmx:SXZnXmk8XPTxURAajvwnUddMc7wKseP1m2QRo9opMXzHYvNeVIrWxg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4ECAB30614FA;
        Tue, 10 Mar 2020 07:13:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] efi/x86: Align GUIDs to their size in the mixed mode runtime" failed to apply to 4.14-stable tree
To:     ardb@kernel.org, hdegoede@redhat.com, mingo@kernel.org,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 12:13:10 +0100
Message-ID: <158383879067214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 63056e8b5ebf41d52170e9f5ba1fc83d1855278c Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 21 Feb 2020 09:48:46 +0100
Subject: [PATCH] efi/x86: Align GUIDs to their size in the mixed mode runtime
 wrapper

Hans reports that his mixed mode systems running v5.6-rc1 kernels hit
the WARN_ON() in virt_to_phys_or_null_size(), caused by the fact that
efi_guid_t objects on the vmap'ed stack happen to be misaligned with
respect to their sizes. As a quick (i.e., backportable) fix, copy GUID
pointer arguments to the local stack into a buffer that is naturally
aligned to its size, so that it is guaranteed to cover only one
physical page.

Note that on x86, we cannot rely on the stack pointer being aligned
the way the compiler expects, so we need to allocate an 8-byte aligned
buffer of sufficient size, and copy the GUID into that buffer at an
offset that is aligned to 16 bytes.

Fixes: f6697df36bdf0bf7 ("x86/efi: Prevent mixed mode boot corruption with CONFIG_VMAP_STACK=y")
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Cc: linux-efi@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200221084849.26878-2-ardb@kernel.org

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index fa8506e76bbe..543edfdcd1b9 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -658,6 +658,8 @@ static efi_status_t
 efi_thunk_get_variable(efi_char16_t *name, efi_guid_t *vendor,
 		       u32 *attr, unsigned long *data_size, void *data)
 {
+	u8 buf[24] __aligned(8);
+	efi_guid_t *vnd = PTR_ALIGN((efi_guid_t *)buf, sizeof(*vnd));
 	efi_status_t status;
 	u32 phys_name, phys_vendor, phys_attr;
 	u32 phys_data_size, phys_data;
@@ -665,8 +667,10 @@ efi_thunk_get_variable(efi_char16_t *name, efi_guid_t *vendor,
 
 	spin_lock_irqsave(&efi_runtime_lock, flags);
 
+	*vnd = *vendor;
+
 	phys_data_size = virt_to_phys_or_null(data_size);
-	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_vendor = virt_to_phys_or_null(vnd);
 	phys_name = virt_to_phys_or_null_size(name, efi_name_size(name));
 	phys_attr = virt_to_phys_or_null(attr);
 	phys_data = virt_to_phys_or_null_size(data, *data_size);
@@ -683,14 +687,18 @@ static efi_status_t
 efi_thunk_set_variable(efi_char16_t *name, efi_guid_t *vendor,
 		       u32 attr, unsigned long data_size, void *data)
 {
+	u8 buf[24] __aligned(8);
+	efi_guid_t *vnd = PTR_ALIGN((efi_guid_t *)buf, sizeof(*vnd));
 	u32 phys_name, phys_vendor, phys_data;
 	efi_status_t status;
 	unsigned long flags;
 
 	spin_lock_irqsave(&efi_runtime_lock, flags);
 
+	*vnd = *vendor;
+
 	phys_name = virt_to_phys_or_null_size(name, efi_name_size(name));
-	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_vendor = virt_to_phys_or_null(vnd);
 	phys_data = virt_to_phys_or_null_size(data, data_size);
 
 	/* If data_size is > sizeof(u32) we've got problems */
@@ -707,6 +715,8 @@ efi_thunk_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
 				   u32 attr, unsigned long data_size,
 				   void *data)
 {
+	u8 buf[24] __aligned(8);
+	efi_guid_t *vnd = PTR_ALIGN((efi_guid_t *)buf, sizeof(*vnd));
 	u32 phys_name, phys_vendor, phys_data;
 	efi_status_t status;
 	unsigned long flags;
@@ -714,8 +724,10 @@ efi_thunk_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
 	if (!spin_trylock_irqsave(&efi_runtime_lock, flags))
 		return EFI_NOT_READY;
 
+	*vnd = *vendor;
+
 	phys_name = virt_to_phys_or_null_size(name, efi_name_size(name));
-	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_vendor = virt_to_phys_or_null(vnd);
 	phys_data = virt_to_phys_or_null_size(data, data_size);
 
 	/* If data_size is > sizeof(u32) we've got problems */
@@ -732,14 +744,18 @@ efi_thunk_get_next_variable(unsigned long *name_size,
 			    efi_char16_t *name,
 			    efi_guid_t *vendor)
 {
+	u8 buf[24] __aligned(8);
+	efi_guid_t *vnd = PTR_ALIGN((efi_guid_t *)buf, sizeof(*vnd));
 	efi_status_t status;
 	u32 phys_name_size, phys_name, phys_vendor;
 	unsigned long flags;
 
 	spin_lock_irqsave(&efi_runtime_lock, flags);
 
+	*vnd = *vendor;
+
 	phys_name_size = virt_to_phys_or_null(name_size);
-	phys_vendor = virt_to_phys_or_null(vendor);
+	phys_vendor = virt_to_phys_or_null(vnd);
 	phys_name = virt_to_phys_or_null_size(name, *name_size);
 
 	status = efi_thunk(get_next_variable, phys_name_size,
@@ -747,6 +763,7 @@ efi_thunk_get_next_variable(unsigned long *name_size,
 
 	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 
+	*vendor = *vnd;
 	return status;
 }
 

