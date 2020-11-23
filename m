Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46BE2C0274
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgKWJpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:45:02 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:60219 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbgKWJpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 04:45:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 9726AFAA;
        Mon, 23 Nov 2020 04:45:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:45:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lNbw7w
        Ic9gjut+fzpm4HTq0u+mzZkxIKlq2e54uicYk=; b=Y9MMDbhCucrzIfJqhOnxYY
        XWh0aHg7J/MIqu2J/gUN36TTBLLva/Cnw3I9lFA9I+2SMyfKYw3FNd3s1gXPaQiA
        7ToqrEAT/oQtJU+kRosdPFnoH6lkvqZBLSRE9c37BPfNb2n1tUnYvu253F/BTLHk
        7ZYdb0n/O7OUaRwKnc6HJzAcNulml0XUbVDRPEoDj6Y6Q/usQd18ReXSFbpijZXK
        RgswXYIKf5nEzpUqmUR4FLaOEVXD4a7DYuaWpcf9qi7yv7uUPCPtKWb+1Og5LiJS
        A2detc9M3+VQZEwZwXnw0/z42yLQThmJdM3+9cuG932wnBDa8DyLOs9mk3n5jhoQ
        ==
X-ME-Sender: <xms:nIS7X2z-F077yozsIrVJKyG_PM8P-r6aq_pMIlYVCsOYjpcKNb37SA>
    <xme:nIS7XyR4UkpPx1nDi738GkeUnIgU-xeP23LeBfXmmiIEwOSc9o9VR18NmQAMzubCK
    C7XOo5Z0ZUmDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:nIS7X4XXna21SHOSF7ume6FYZxnI42Pfx0jOqhiYNdVNI3pfJzc3uw>
    <xmx:nIS7X8itVQXJtTqI6ExVfziOHrgki8bbE_r9cjYxBLXInGkpBexuJw>
    <xmx:nIS7X4ByQCBOtbwj9Li1MzkcEtHZaWz4CpHhuIsXGp8HVXIlktArYw>
    <xmx:nIS7XzqAulNnHqVFwVEunjVWC-K9eaYnCFjzIWYql1wQKe6Qia3OESAC82o>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D32B43064AB5;
        Mon, 23 Nov 2020 04:44:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/microcode/intel: Check patch signature before saving" failed to apply to 4.9-stable tree
To:     yu.c.chen@intel.com, bp@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 10:46:03 +0100
Message-ID: <16061247634917@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1a371e67dc77125736cc56d3a0893f06b75855b6 Mon Sep 17 00:00:00 2001
From: Chen Yu <yu.c.chen@intel.com>
Date: Fri, 13 Nov 2020 09:59:23 +0800
Subject: [PATCH] x86/microcode/intel: Check patch signature before saving
 microcode for early loading

Currently, scan_microcode() leverages microcode_matches() to check
if the microcode matches the CPU by comparing the family and model.
However, the processor stepping and flags of the microcode signature
should also be considered when saving a microcode patch for early
update.

Use find_matching_signature() in scan_microcode() and get rid of the
now-unused microcode_matches() which is a good cleanup in itself.

Complete the verification of the patch being saved for early loading in
save_microcode_patch() directly. This needs to be done there too because
save_mc_for_early() will call save_microcode_patch() too.

The second reason why this needs to be done is because the loader still
tries to support, at least hypothetically, mixed-steppings systems and
thus adds all patches to the cache that belong to the same CPU model
albeit with different steppings.

For example:

  microcode: CPU: sig=0x906ec, pf=0x2, rev=0xd6
  microcode: mc_saved[0]: sig=0x906e9, pf=0x2a, rev=0xd6, total size=0x19400, date = 2020-04-23
  microcode: mc_saved[1]: sig=0x906ea, pf=0x22, rev=0xd6, total size=0x19000, date = 2020-04-27
  microcode: mc_saved[2]: sig=0x906eb, pf=0x2, rev=0xd6, total size=0x19400, date = 2020-04-23
  microcode: mc_saved[3]: sig=0x906ec, pf=0x22, rev=0xd6, total size=0x19000, date = 2020-04-27
  microcode: mc_saved[4]: sig=0x906ed, pf=0x22, rev=0xd6, total size=0x19400, date = 2020-04-23

The patch which is being saved for early loading, however, can only be
the one which fits the CPU this runs on so do the signature verification
before saving.

 [ bp: Do signature verification in save_microcode_patch()
       and rewrite commit message. ]

Fixes: ec400ddeff20 ("x86/microcode_intel_early.c: Early update ucode on Intel's CPU")
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208535
Link: https://lkml.kernel.org/r/20201113015923.13960-1-yu.c.chen@intel.com

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 6a99535d7f37..7e8e07bddd5f 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -100,53 +100,6 @@ static int has_newer_microcode(void *mc, unsigned int csig, int cpf, int new_rev
 	return find_matching_signature(mc, csig, cpf);
 }
 
-/*
- * Given CPU signature and a microcode patch, this function finds if the
- * microcode patch has matching family and model with the CPU.
- *
- * %true - if there's a match
- * %false - otherwise
- */
-static bool microcode_matches(struct microcode_header_intel *mc_header,
-			      unsigned long sig)
-{
-	unsigned long total_size = get_totalsize(mc_header);
-	unsigned long data_size = get_datasize(mc_header);
-	struct extended_sigtable *ext_header;
-	unsigned int fam_ucode, model_ucode;
-	struct extended_signature *ext_sig;
-	unsigned int fam, model;
-	int ext_sigcount, i;
-
-	fam   = x86_family(sig);
-	model = x86_model(sig);
-
-	fam_ucode   = x86_family(mc_header->sig);
-	model_ucode = x86_model(mc_header->sig);
-
-	if (fam == fam_ucode && model == model_ucode)
-		return true;
-
-	/* Look for ext. headers: */
-	if (total_size <= data_size + MC_HEADER_SIZE)
-		return false;
-
-	ext_header   = (void *) mc_header + data_size + MC_HEADER_SIZE;
-	ext_sig      = (void *)ext_header + EXT_HEADER_SIZE;
-	ext_sigcount = ext_header->count;
-
-	for (i = 0; i < ext_sigcount; i++) {
-		fam_ucode   = x86_family(ext_sig->sig);
-		model_ucode = x86_model(ext_sig->sig);
-
-		if (fam == fam_ucode && model == model_ucode)
-			return true;
-
-		ext_sig++;
-	}
-	return false;
-}
-
 static struct ucode_patch *memdup_patch(void *data, unsigned int size)
 {
 	struct ucode_patch *p;
@@ -164,7 +117,7 @@ static struct ucode_patch *memdup_patch(void *data, unsigned int size)
 	return p;
 }
 
-static void save_microcode_patch(void *data, unsigned int size)
+static void save_microcode_patch(struct ucode_cpu_info *uci, void *data, unsigned int size)
 {
 	struct microcode_header_intel *mc_hdr, *mc_saved_hdr;
 	struct ucode_patch *iter, *tmp, *p = NULL;
@@ -210,6 +163,9 @@ static void save_microcode_patch(void *data, unsigned int size)
 	if (!p)
 		return;
 
+	if (!find_matching_signature(p->data, uci->cpu_sig.sig, uci->cpu_sig.pf))
+		return;
+
 	/*
 	 * Save for early loading. On 32-bit, that needs to be a physical
 	 * address as the APs are running from physical addresses, before
@@ -344,13 +300,14 @@ scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
 
 		size -= mc_size;
 
-		if (!microcode_matches(mc_header, uci->cpu_sig.sig)) {
+		if (!find_matching_signature(data, uci->cpu_sig.sig,
+					     uci->cpu_sig.pf)) {
 			data += mc_size;
 			continue;
 		}
 
 		if (save) {
-			save_microcode_patch(data, mc_size);
+			save_microcode_patch(uci, data, mc_size);
 			goto next;
 		}
 
@@ -483,14 +440,14 @@ static void show_saved_mc(void)
  * Save this microcode patch. It will be loaded early when a CPU is
  * hot-added or resumes.
  */
-static void save_mc_for_early(u8 *mc, unsigned int size)
+static void save_mc_for_early(struct ucode_cpu_info *uci, u8 *mc, unsigned int size)
 {
 	/* Synchronization during CPU hotplug. */
 	static DEFINE_MUTEX(x86_cpu_microcode_mutex);
 
 	mutex_lock(&x86_cpu_microcode_mutex);
 
-	save_microcode_patch(mc, size);
+	save_microcode_patch(uci, mc, size);
 	show_saved_mc();
 
 	mutex_unlock(&x86_cpu_microcode_mutex);
@@ -935,7 +892,7 @@ static enum ucode_state generic_load_microcode(int cpu, struct iov_iter *iter)
 	 * permanent memory. So it will be loaded early when a CPU is hot added
 	 * or resumes.
 	 */
-	save_mc_for_early(new_mc, new_mc_size);
+	save_mc_for_early(uci, new_mc, new_mc_size);
 
 	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
 		 cpu, new_rev, uci->cpu_sig.rev);

