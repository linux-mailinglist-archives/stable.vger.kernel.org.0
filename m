Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640B82E1D54
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgLWOP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:15:58 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52395 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728251AbgLWOP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:15:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B31961B84;
        Wed, 23 Dec 2020 09:14:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:14:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=c3AB0p
        u6KyKMQP9/Ay4E7G7lSfsePFy4FqJy2+9R0dw=; b=Kg2UNA3HxTpPy0h8DR0oIz
        qjHnrazG+72rf7mBZS+ky7TE38bCnYCEoA24h5UtmPwGlewT5SICvWVocpoB8Ut4
        NR1UJWq5yHTsdFl2JCNrZQg/3GBlsh0if+I1ewypvPA/h6OaSjxL07yB761BrSFA
        Jt2AgGBCDGUmkHh9JmE95Gcdpx8Iy4/tbw8u8zel5+SbwdZwKGcIHwm3zW4rrRWP
        9xfPvZ0p+o9imNNy7h+2FNDk35+UakFYMsDH7465+4mwE+u0CiZc3kgzgcn5/e8+
        4NmZnKFfnrD5FAIyDs4crmCTXrrF2xFAFVPsuCsrkXLfU3zsXHZyZTQ4JH6uQ9JA
        ==
X-ME-Sender: <xms:vlDjX0DV4WyVnfS_VI91nwq0wRbasPJe6Njbw3sSrxg_Z4tqjW_CBw>
    <xme:vlDjX2hotaBAKvzfGCt4ubraczlerXPvC0MQffY_R4GMaR_K3zKrSldVHxuR3CMQP
    Rioijg8O0YqDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:vlDjX3k8S9DwVwBqRwtKupYtD-aDQGerX3VFQvVmMrWFIWc_hMTlsg>
    <xmx:vlDjX6zhzDpfOIc-0G1kKrErmZbRNJqWTU2pnF48vN3ieB54kDPdwA>
    <xmx:vlDjX5Ri0IoR3NEGpsDGQuynC1lrA8ChTFerKFL0Yvr4k4PR85kb2Q>
    <xmx:vlDjX0NAB4KQNJQOabo72bddHLYcQGcJ-ZLbPrzUxI5QaL5E9PzoGrxtclw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0954424005A;
        Wed, 23 Dec 2020 09:14:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: prevent creating duplicate encrypted filenames" failed to apply to 4.14-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:15:31 +0100
Message-ID: <1608732931198113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

