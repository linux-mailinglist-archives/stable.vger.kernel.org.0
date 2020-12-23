Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E8E2E1D4E
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgLWOPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:15:38 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:38401 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728705AbgLWOPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:15:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C260D1B90;
        Wed, 23 Dec 2020 09:14:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:14:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=krVOI2
        GL2kqLUhHamH5ADwR+T/S34A6htu5XOC/fj6E=; b=cHYCBrkk3sr4F7EJlmNQxV
        EHlm04d2aVBlNnSb0wy3v4kzWsIDXbZ26QgRD1V1Sqft5ErdN00cpIAfWHDCN2M3
        Ekvp61VcaBhVHeLAyXRWX/RkCP35P9s8RS/XgzyKxlCvHsmIXyv+X+yrh1MdAZqs
        rYBlbL6VLUO1w9hzI6BQDSA0WNIoOh58LY98b0pvfZprF+cWYWr8S5HSupdZsvpu
        vEluge9/tQ6k5jsqRsfrwJDBI6CZBiYZmifzVpZIejn4xHZ8pJcq1+kyzjDRHdUr
        xcwP31HB50gB2zl3bn/LyzFcHjFH7GyI8YznGTECdg60KHe6vmRuUhfO6JV/NaRw
        ==
X-ME-Sender: <xms:wlDjX0BQXFv9DCqWBYaIJw3a6vl7WHboDODU4vbyzouW83KbsFPkrA>
    <xme:wlDjX2jHXZnozeKskmMzVpKNyAxzwQnaxMOac5ccLS-_mQGRNMcxvO1zRvGKWLOsE
    FuFWLxyzcn-UA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedutdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:wlDjX3mvVYmyWPkOa04rHvzQe_rdj7lLToWr-Dhg2CnUuk37g33-Ig>
    <xmx:wlDjX6zYkWvV2lL19uviL38UZ1XOY3G41tJ4qofeHZijy66arM-ApA>
    <xmx:wlDjX5SNl_g_O8D994F_Ro-vD-dhpuCDKB7xwSMbEamaoJYdPW8tOA>
    <xmx:wlDjX0N_vN2q-3gr_B_2kf6fFjiE8-8S1oahPcehnP6wwJa3SzUgTo0ZdfI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11EAA108005C;
        Wed, 23 Dec 2020 09:14:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: prevent creating duplicate encrypted filenames" failed to apply to 4.19-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:15:32 +0100
Message-ID: <160873293245217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 75d18cd1868c2aee43553723872c35d7908f240f Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 17 Nov 2020 23:56:06 -0800
Subject: [PATCH] ext4: prevent creating duplicate encrypted filenames

As described in "fscrypt: add fscrypt_is_nokey_name()", it's possible to
create a duplicate filename in an encrypted directory by creating a file
concurrently with adding the directory's encryption key.

Fix this bug on ext4 by rejecting no-key dentries in ext4_add_entry().

Note that the duplicate check in ext4_find_dest_de() sometimes prevented
this bug.  However in many cases it didn't, since ext4_find_dest_de()
doesn't examine every dentry.

Fixes: 4461471107b7 ("ext4 crypto: enable filename encryption")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201118075609.120337-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 33509266f5a0..793fc7db9d28 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2195,6 +2195,9 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	if (!dentry->d_name.len)
 		return -EINVAL;
 
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
+
 #ifdef CONFIG_UNICODE
 	if (sb_has_strict_encoding(sb) && IS_CASEFOLDED(dir) &&
 	    sb->s_encoding && utf8_validate(sb->s_encoding, &dentry->d_name))

