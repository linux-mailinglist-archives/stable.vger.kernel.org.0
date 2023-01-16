Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3FE66BB33
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 11:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjAPKG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 05:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjAPKGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 05:06:03 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFCD1C32C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 02:05:39 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id d24-20020a5d9bd8000000b006ee2ddf6d77so17325300ion.6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 02:05:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHBorJxtb8OOdvReJ/cspDu7cb80E+hJP4zqgvf9eJU=;
        b=Ca7zuz3Jc6qSUnGjvY7isCUkDLZp4a43bTrYSuMokO7490wJizSPVwjRLnRWwKAt0w
         yvbaxWdU2+FSbJXYqoOXSU+9UxSOA4FCsxVNkQYW+sVtniOYeTCM/W/tC8P9BRbdHLQ3
         BnNUB8G+c2N6z0lviG3EYn+kjjdiPrjpnd/1bWcBWUNQsKxXdBnOVlZvYSexzxsW/Ka+
         KT/crww7xQzMLq2St/3Xc7ZQihZ/uWMogSDj6WkGoaj/xxkgt9fCDp1FV7Z0yMok1Bim
         cdZPWJ6RY3bUIoR8IvOvBubAF4ZF3Xy+X0nnnyXJWXww0QYVKLKBR6QZZmw2GuckfV/D
         CWHA==
X-Gm-Message-State: AFqh2kqnya+bCHNnwoiUlMx16k8FjGovCGclEdHvcU0MZmNiqMB0naIl
        3Zd/9r3R0edNwH4sTsqBEYHlgV/kikyCOAInIgqWs304i3r4
X-Google-Smtp-Source: AMrXdXuMP+pXnU29vioyn5DTxncoDXWP/ebGCT1OI1VyV4CErkZ7/qWNWt3CVaWvm9lE1o9ahTrKqTXpaELpCWNw9DQog1XK4YTq
MIME-Version: 1.0
X-Received: by 2002:a02:cc28:0:b0:3a1:50fe:b95f with SMTP id
 o8-20020a02cc28000000b003a150feb95fmr803468jap.57.1673863538798; Mon, 16 Jan
 2023 02:05:38 -0800 (PST)
Date:   Mon, 16 Jan 2023 02:05:38 -0800
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a1f99705f25eb92f@google.com>
Subject: Re: KASAN: use-after-free Read in tc_chain_fill_node
From:   syzbot <syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org, jiri@mellanox.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        stable-commits@vger.kernel.org, stable@vger.kernel.org,
        syzkaller-lts-bugs@googlegroups.com, vladbu@mellanox.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This bug is marked as fixed by commit:
net: core: netlink: add helper refcount dec and lock function
net: sched: add helper function to take reference to Qdisc
net: sched: extend Qdisc with rcu
net: sched: rename qdisc_destroy() to qdisc_put()
net: sched: use Qdisc rcu API instead of relying on rtnl lock

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Linux 4.19
Dashboard link: https://syzkaller.appspot.com/bug?extid=5f229e48cccc804062c0

---
[1] I expect the commit to be present in:

1. linux-4.19.y branch of
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
