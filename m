Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE1030CFD9
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 00:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbhBBXZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 18:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhBBXZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 18:25:47 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9A9C06174A
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 15:25:07 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 190so3937325wmz.0
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 15:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RrUjhWfYwNOpNJHxlGtQqTLTLwqa+l5bBOzma2RnQfg=;
        b=HXZyHYR34Gnrk0YAc+Tar6930V22b8wIsa41YuOhIRUUiMrKB9d1nrqueZGH83t+WK
         +QEp96cH08yqLpiGS89+A46bX5xnZVNWQ4G6iREjgwgrEzL+6oa8kLp78VQfnU/35qQK
         Ckf9Nj2PlFi8Y0Y4uSiD3y7PrAT8Z5OiTI6MsA9hfJ8+VFBNRWM3okihjwqRPj1zWBKL
         I6uXNdBnEMhxaHeJ0s/WlZw+mjt63PojywlblT6R0OMNOQqqEae4eUV8uTXsm25EBo9y
         brzhJpbtUEpVRdWOJwMf0Fgn1z+cHaYLwWNpUo+cvNEHgC2fJSA23BgErQQFeFKWpDPF
         swdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RrUjhWfYwNOpNJHxlGtQqTLTLwqa+l5bBOzma2RnQfg=;
        b=maGJcuXqRwTT9Jn6Hw6+k9bt+HMLUGUavd1KdM0AtzWw4dLXU6ahv/ZMPCCexNIa8v
         mO8xCDEzu0mhYQP3jdCp8RIt+5yWlIFnJ6IRp8XfKfGPOx76Mda7syLpfA9QXL0cgqae
         QQ+VqPCGYVur1B+wEufc//ebgsDm1XnY/jp86XMz+TBSXqba2tY/cLAYy3EmmqEMfQR0
         EMx8JtcbbxioOddRjh7aADrV2HwS5YxpfSCorajFPYPsuAHFdQ8LZ8hMdqWlgi2j4VZP
         gfKNBONZ1oliVu7Wk31wapvZy9pQYuqJ+rSTJiB5ASHB1dmc3lhhRD/64AFf4iBrJ5VU
         jwOw==
X-Gm-Message-State: AOAM531kOIYtFO4lXGRB8PzC/AglRd1o3T5y/Lak2qiZGOmtDsx6/NFO
        UE//CxzwQzOTOqT0IUeaOOc=
X-Google-Smtp-Source: ABdhPJxYeAgVzp8HZ2yWRCKQ/yCWzoT9zPrl8w9BoNH/ZRiZIHZr+ps62IGsZtkwOP5rhKMkCIO51Q==
X-Received: by 2002:a7b:cf33:: with SMTP id m19mr276627wmg.53.1612308306102;
        Tue, 02 Feb 2021 15:25:06 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id r11sm119987wmh.9.2021.02.02.15.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 15:25:05 -0800 (PST)
Date:   Tue, 2 Feb 2021 23:25:03 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     edumazet@google.com, cong.wang@bytedance.com, kuba@kernel.org,
        syzkaller@googlegroups.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net_sched: reject silly cell_log in
 qdisc_get_rtab()" failed to apply to 4.14-stable tree
Message-ID: <YBnfTyUpzZ+MgLbb@debian>
References: <161158786343227@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PRP30923w51d79dF"
Content-Disposition: inline
In-Reply-To: <161158786343227@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PRP30923w51d79dF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 25, 2021 at 04:17:43PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.9-stable and 4.4-stable.


--
Regards
Sudip

--PRP30923w51d79dF
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-net_sched-reject-silly-cell_log-in-qdisc_get_rtab.patch"

From 379f27a43fd7278d5e38e40d94605e79033564f9 Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 14 Jan 2021 08:06:37 -0800
Subject: [PATCH] net_sched: reject silly cell_log in qdisc_get_rtab()

commit e4bedf48aaa5552bc1f49703abd17606e7e6e82a upstream

iproute2 probably never goes beyond 8 for the cell exponent,
but stick to the max shift exponent for signed 32bit.

UBSAN reported:
UBSAN: shift-out-of-bounds in net/sched/sch_api.c:389:22
shift exponent 130 is too large for 32-bit type 'int'
CPU: 1 PID: 8450 Comm: syz-executor586 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x183/0x22e lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:148 [inline]
 __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
 __detect_linklayer+0x2a9/0x330 net/sched/sch_api.c:389
 qdisc_get_rtab+0x2b5/0x410 net/sched/sch_api.c:435
 cbq_init+0x28f/0x12c0 net/sched/sch_cbq.c:1180
 qdisc_create+0x801/0x1470 net/sched/sch_api.c:1246
 tc_modify_qdisc+0x9e3/0x1fc0 net/sched/sch_api.c:1662
 rtnetlink_rcv_msg+0xb1d/0xe60 net/core/rtnetlink.c:5564
 netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xaa6/0xe90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x5a2/0x900 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x319/0x400 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/20210114160637.1660597-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 net/sched/sch_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 296e95f72eb1..acdcc7d98da0 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -397,7 +397,8 @@ struct qdisc_rate_table *qdisc_get_rtab(struct tc_ratespec *r,
 {
 	struct qdisc_rate_table *rtab;
 
-	if (tab == NULL || r->rate == 0 || r->cell_log == 0 ||
+	if (tab == NULL || r->rate == 0 ||
+	    r->cell_log == 0 || r->cell_log >= 32 ||
 	    nla_len(tab) != TC_RTAB_SIZE)
 		return NULL;
 
-- 
2.29.2


--PRP30923w51d79dF--
