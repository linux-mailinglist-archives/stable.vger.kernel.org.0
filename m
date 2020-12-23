Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E262E1D0A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgLWOLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:11:52 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:36895 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728866AbgLWOLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:11:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6684995D;
        Wed, 23 Dec 2020 09:10:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:10:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rVImb5
        FHQorbSfG0WL0EmT16odMkqxnrCE20CSB1O8U=; b=ofaP7l1aG4aZI2z+S6+uCF
        d2bJSPNcTX+ocVmm+9wyfq3Uhms89969FnW0+fN1sCNmM029M74hOwsS+hA9t/wL
        MEwfM5HThFx4F8XHDSVlc+EHd0AEolnGa1GVhp/5NY2mCsF3JUnPT+riSQ1idZBI
        zJpuuM22pzzOGPM6yns7hdd3mntx0X7FknrG9N4QChmjoYT3o7UD/1TV3ZoiHlsz
        qXUkI7QtNmWvsMjifweM51cIjZsq0YEtIBtShAtZYYPRBjP5swqesWGbooLbiadv
        FkADexhddGUWQtePS6+w4vo35BrXem++vPIE5WWYvnM8yqgPMn6VVZ/nKYusxDOA
        ==
X-ME-Sender: <xms:5U_jX7Pj2Pt8hTIEuqkx4GmOanoykBTe0o_KbqmVYrFNTt-tYNsCNg>
    <xme:5U_jX1_h5YLuYj1tTtjTD6wV7Y3HjzaGdhikTqinWF9xXkHAicijgddvpF1gWluIv
    GHZyDGwzfdhMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:5U_jX6SnUGEehOm_9QCWoqmG_XGCPw9VL6zYfItGaKGf_BAV_mj4Ag>
    <xmx:5U_jX_skCO5tV1rlebrtwTKwB2Lg0QCiUi10q5HkKoTOYgbLC1dbQQ>
    <xmx:5U_jXzcFWaj_VaS2vBNiaffUnxb7JNIc8hx6qC_NAIJ-YO0V8wG66A>
    <xmx:5k_jXxpBG6pj8BhivoBF44HT5P7UqWOorTD7KFpcK4odsXBFsOeE0uRuNaQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7685B108005B;
        Wed, 23 Dec 2020 09:10:45 -0500 (EST)
Subject: FAILED: patch "[PATCH] fscrypt: remove kernel-internal constants from UAPI header" failed to apply to 5.4-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:11:57 +0100
Message-ID: <16087327178741@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 3ceb6543e9cf6ed87cc1fbc6f23ca2db903564cd Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Fri, 23 Oct 2020 17:51:31 -0700
Subject: [PATCH] fscrypt: remove kernel-internal constants from UAPI header

There isn't really any valid reason to use __FSCRYPT_MODE_MAX or
FSCRYPT_POLICY_FLAGS_VALID in a userspace program.  These constants are
only meant to be used by the kernel internally, and they are defined in
the UAPI header next to the mode numbers and flags only so that kernel
developers don't forget to update them when adding new modes or flags.

In https://lkml.kernel.org/r/20201005074133.1958633-2-satyat@google.com
there was an example of someone wanting to use __FSCRYPT_MODE_MAX in a
user program, and it was wrong because the program would have broken if
__FSCRYPT_MODE_MAX were ever increased.  So having this definition
available is harmful.  FSCRYPT_POLICY_FLAGS_VALID has the same problem.

So, remove these definitions from the UAPI header.  Replace
FSCRYPT_POLICY_FLAGS_VALID with just listing the valid flags explicitly
in the one kernel function that needs it.  Move __FSCRYPT_MODE_MAX to
fscrypt_private.h, remove the double underscores (which were only
present to discourage use by userspace), and add a BUILD_BUG_ON() and
comments to (hopefully) ensure it is kept in sync.

Keep the old name FS_POLICY_FLAGS_VALID, since it's been around for
longer and there's a greater chance that removing it would break source
compatibility with some program.  Indeed, mtd-utils is using it in
an #ifdef, and removing it would introduce compiler warnings (about
FS_POLICY_FLAGS_PAD_* being redefined) into the mtd-utils build.
However, reduce its value to 0x07 so that it only includes the flags
with old names (the ones present before Linux 5.4), and try to make it
clear that it's now "frozen" and no new flags should be added to it.

Fixes: 2336d0deb2d4 ("fscrypt: use FSCRYPT_ prefix for uapi constants")
Cc: <stable@vger.kernel.org> # v5.4+
Link: https://lore.kernel.org/r/20201024005132.495952-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 4f5806a3b73d..322ecae9a758 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -25,6 +25,9 @@
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
+/* Keep this in sync with include/uapi/linux/fscrypt.h */
+#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_ADIANTUM
+
 struct fscrypt_context_v1 {
 	u8 version; /* FSCRYPT_CONTEXT_V1 */
 	u8 contents_encryption_mode;
@@ -491,9 +494,9 @@ struct fscrypt_master_key {
 	 * Per-mode encryption keys for the various types of encryption policies
 	 * that use them.  Allocated and derived on-demand.
 	 */
-	struct fscrypt_prepared_key mk_direct_keys[__FSCRYPT_MODE_MAX + 1];
-	struct fscrypt_prepared_key mk_iv_ino_lblk_64_keys[__FSCRYPT_MODE_MAX + 1];
-	struct fscrypt_prepared_key mk_iv_ino_lblk_32_keys[__FSCRYPT_MODE_MAX + 1];
+	struct fscrypt_prepared_key mk_direct_keys[FSCRYPT_MODE_MAX + 1];
+	struct fscrypt_prepared_key mk_iv_ino_lblk_64_keys[FSCRYPT_MODE_MAX + 1];
+	struct fscrypt_prepared_key mk_iv_ino_lblk_32_keys[FSCRYPT_MODE_MAX + 1];
 
 	/* Hash key for inode numbers.  Initialized only when needed. */
 	siphash_key_t		mk_ino_hash_key;
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 53cc552a7b8f..d7ec52cb3d9a 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -44,7 +44,7 @@ static void free_master_key(struct fscrypt_master_key *mk)
 
 	wipe_master_key_secret(&mk->mk_secret);
 
-	for (i = 0; i <= __FSCRYPT_MODE_MAX; i++) {
+	for (i = 0; i <= FSCRYPT_MODE_MAX; i++) {
 		fscrypt_destroy_prepared_key(&mk->mk_direct_keys[i]);
 		fscrypt_destroy_prepared_key(&mk->mk_iv_ino_lblk_64_keys[i]);
 		fscrypt_destroy_prepared_key(&mk->mk_iv_ino_lblk_32_keys[i]);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index d595abb8ef90..31fb08d94f87 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -56,6 +56,8 @@ static struct fscrypt_mode *
 select_encryption_mode(const union fscrypt_policy *policy,
 		       const struct inode *inode)
 {
+	BUILD_BUG_ON(ARRAY_SIZE(fscrypt_modes) != FSCRYPT_MODE_MAX + 1);
+
 	if (S_ISREG(inode->i_mode))
 		return &fscrypt_modes[fscrypt_policy_contents_mode(policy)];
 
@@ -168,7 +170,7 @@ static int setup_per_mode_enc_key(struct fscrypt_info *ci,
 	unsigned int hkdf_infolen = 0;
 	int err;
 
-	if (WARN_ON(mode_num > __FSCRYPT_MODE_MAX))
+	if (WARN_ON(mode_num > FSCRYPT_MODE_MAX))
 		return -EINVAL;
 
 	prep_key = &keys[mode_num];
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 4441d9944b9e..faa0f21daa68 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -175,7 +175,10 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 		return false;
 	}
 
-	if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID) {
+	if (policy->flags & ~(FSCRYPT_POLICY_FLAGS_PAD_MASK |
+			      FSCRYPT_POLICY_FLAG_DIRECT_KEY |
+			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
+			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
 		fscrypt_warn(inode, "Unsupported encryption flags (0x%02x)",
 			     policy->flags);
 		return false;
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index e5de60336938..9f4428be3e36 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -20,7 +20,6 @@
 #define FSCRYPT_POLICY_FLAG_DIRECT_KEY		0x04
 #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64	0x08
 #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32	0x10
-#define FSCRYPT_POLICY_FLAGS_VALID		0x1F
 
 /* Encryption algorithms */
 #define FSCRYPT_MODE_AES_256_XTS		1
@@ -28,7 +27,7 @@
 #define FSCRYPT_MODE_AES_128_CBC		5
 #define FSCRYPT_MODE_AES_128_CTS		6
 #define FSCRYPT_MODE_ADIANTUM			9
-#define __FSCRYPT_MODE_MAX			9
+/* If adding a mode number > 9, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
@@ -177,7 +176,7 @@ struct fscrypt_get_key_status_arg {
 #define FS_POLICY_FLAGS_PAD_32		FSCRYPT_POLICY_FLAGS_PAD_32
 #define FS_POLICY_FLAGS_PAD_MASK	FSCRYPT_POLICY_FLAGS_PAD_MASK
 #define FS_POLICY_FLAG_DIRECT_KEY	FSCRYPT_POLICY_FLAG_DIRECT_KEY
-#define FS_POLICY_FLAGS_VALID		FSCRYPT_POLICY_FLAGS_VALID
+#define FS_POLICY_FLAGS_VALID		0x07	/* contains old flags only */
 #define FS_ENCRYPTION_MODE_INVALID	0	/* never used */
 #define FS_ENCRYPTION_MODE_AES_256_XTS	FSCRYPT_MODE_AES_256_XTS
 #define FS_ENCRYPTION_MODE_AES_256_GCM	2	/* never used */

