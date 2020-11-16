Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40172B513E
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 20:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgKPTea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 14:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgKPTea (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 14:34:30 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845DFC0613CF
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 11:34:29 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id r17so20079910wrw.1
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 11:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8Twv8sQxesA6eUUbQLLoY6w7/6fvL5FmwFAqfIvL57Q=;
        b=X8akAms2lbUZYsndmxwI66B76QKQhT9YvKEB62tgbF7GSUOUBs8N4h0JLqOzgsoSU8
         zSW/qgx5+OMbrLN2pRAiGXnzhC8o65j7HQIXCF9QWvOicz8kl6+6u4wX0nHXKUb15QLO
         YL2DSb7KH70PeEb/wVVBhwVWHBA9DuIpJfSc6RnZud+8GUDIr4ownAuhDN4nsJd5iISS
         xRDIPCmZonj+TLlARUmMOSB7oN4R2XDe/F1D/1q3jNNr0XT8HdyVZfyq/e0GKMeuKD5L
         BKC0Z5jW4ptxA+ru/7Grjxx3131xqHG017bcchoe65/MG/xEPoesGwfq7UgOiHvdff6f
         8V+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8Twv8sQxesA6eUUbQLLoY6w7/6fvL5FmwFAqfIvL57Q=;
        b=naaDFgshNSaRX4tETA3Ik5VV8B99Ml0fj6SYB4hZBeXaIYpxFTS9rX/G9BzjDXhDaY
         rnLY+mEkSa3LDa3Zj3O7R3JjEEvd2g9MGqZ9mSlLR91vq+CyAaYXWBQAEj2NyHDE+4Uh
         mFKp2eJaKJ5uoWM6fEWVEgVgZ+FOyTQp1DSHJLLHf5phCvfO56xX223engxOMgsxvkFY
         8q/NQOKnAdiLcJe1Po5Az44tduO6xuY4PoSkR9KRx/eS12Hev3+u5tbtrrmPXZmE0XkY
         s555pZQMrOLU9vGya8+K2DjCqu2uxEtVJzrM8VrP63Oe37BICfoUziqy7408aGYVGhbd
         BM2A==
X-Gm-Message-State: AOAM532P3VpdS7ZMEP71PoDU2ZN/+DwTz5Ln+EOZP6i5x2WLvnV9jfXY
        b0ghIP55QcqxjlFs4q1lazA=
X-Google-Smtp-Source: ABdhPJw0OcpFeBiP3buM2PJQeD/KA61tFcr7PydXsnGpd/ZOWXyEOCUf2b4NHFBYFFU5Woq7WK/9VA==
X-Received: by 2002:adf:e950:: with SMTP id m16mr22586994wrn.0.1605555268290;
        Mon, 16 Nov 2020 11:34:28 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id p4sm24390303wrm.51.2020.11.16.11.34.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Nov 2020 11:34:27 -0800 (PST)
Date:   Mon, 16 Nov 2020 19:34:25 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ebiggers@google.com, jack@suse.cz, tytso@mit.edu,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ext4: fix leaking sysfs kobject after
 failed mount" failed to apply to 4.9-stable tree
Message-ID: <20201116193425.nf77zcflt2zzzb62@debian>
References: <160441916384118@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d4w3sw45pwathi3h"
Content-Disposition: inline
In-Reply-To: <160441916384118@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--d4w3sw45pwathi3h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Tue, Nov 03, 2020 at 04:59:23PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. This will apply to both v4.9.y and v4.4.y.

--
Regards
Sudip

--d4w3sw45pwathi3h
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-fix-leaking-sysfs-kobject-after-failed-mount.patch"

From 4be70a405c3a30c8602ea7a6c58b31f905e34106 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 22 Sep 2020 09:24:56 -0700
Subject: [PATCH] ext4: fix leaking sysfs kobject after failed mount

commit cb8d53d2c97369029cc638c9274ac7be0a316c75 upstream

ext4_unregister_sysfs() only deletes the kobject.  The reference to it
needs to be put separately, like ext4_put_super() does.

This addresses the syzbot report
"memory leak in kobject_set_name_vargs (3)"
(https://syzkaller.appspot.com/bug?extid=9f864abad79fae7c17e1).

Reported-by: syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com
Fixes: 72ba74508b28 ("ext4: release sysfs kobject when failing to enable quotas on mount")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20200922162456.93657-1-ebiggers@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 00391db0064b..84d28d3efc60 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4336,6 +4336,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_QUOTA
 failed_mount8:
 	ext4_unregister_sysfs(sb);
+	kobject_put(&sbi->s_kobj);
 #endif
 failed_mount7:
 	ext4_unregister_li_request(sb);
-- 
2.11.0


--d4w3sw45pwathi3h--
