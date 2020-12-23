Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC622E1D40
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgLWOPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:15:15 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:38121 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728771AbgLWOPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:15:15 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0D4791B8E;
        Wed, 23 Dec 2020 09:14:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:14:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=y2wAZy
        nEDQ/0sp505hHX+RZ+cytraRpGCeV3sJfNiow=; b=h4IZrmju+sd9Qi9uCFZGF1
        f1wUBChdPW3uh8kd2KELSjsvuq6WZ71Z37vPXXlW3JZxnp7DsxI9v0piIAj0j157
        Yggs1tE1r6E4wkFvnPpeMk3CWaTPMtIuBC9Dml1afYhOOOcyxvFvLNdV9QHJjfpa
        tFPj8m2ulqTonuWmLJdpq+WLmQP1fJfKCwnWh4vLB0jc20rEP/tFco0iquqMwN5E
        T/6V4jVi97SdgiJr2iAdN3/IdwAjDzM/k5ApHQEawb43tUfgKZ5khKPCfkDMggmV
        iDICvWAGlMeFbuwAJLkdzPuDZa+aK3bHDr/K2WsJ4kqqDya+y7E9/8zARfJzbAdQ
        ==
X-ME-Sender: <xms:uVDjX9pGifzObWvqbb2ihuNy19jTpav5p6NntYXzOBoVwPPnrm72dw>
    <xme:uVDjX_mHiKE84_3Bbc2yKQjCy9ov0lPMFsIejhp_sJwAdfxRX5EKJzwmo2YDd7Bet
    xK1_S-OGFPdpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:uVDjX3GQ_FkfUoqr3_V-1mZinguXizCvzktsn07BEOuQgCuCPyX31Q>
    <xmx:uVDjXwrzJSLdAVblqq8ppudd_4otO6x4TWLkcBwkbY-KgOTc9qKo8Q>
    <xmx:uVDjX76Aumr5Xe65RGodMzCqbuUgiSuBmfTtTZErhCoRCC9tdLvAHA>
    <xmx:uVDjX-xLr87ab34plDstqiQAPtfgToimI4lLeTGa43BIfaSPfpkbYckOC0A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5E64F108005C;
        Wed, 23 Dec 2020 09:14:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: prevent creating duplicate encrypted filenames" failed to apply to 5.4-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:15:29 +0100
Message-ID: <1608732929128237@kroah.com>
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

