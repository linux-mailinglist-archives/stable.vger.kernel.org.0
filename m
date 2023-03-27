Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30F26CA0E5
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 12:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbjC0KJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 06:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbjC0KJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 06:09:34 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD8A49EC
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 03:09:31 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id i189-20020a6b3bc6000000b00758a1ed99c2so5215374ioa.1
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 03:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679911771;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHBorJxtb8OOdvReJ/cspDu7cb80E+hJP4zqgvf9eJU=;
        b=RqO4BVSTybd2r+Exnvnt5W0KGnAqmhAiWaqrOuqv9XeiTA1jlLFOQXBm4frmZSYLu/
         JTrgE7GZJREbtwYiTLW1lhfp9o2RsHCjUzqnkQorIchSjf6ar77a5NdN8O8NAagljbev
         kkVOdeO3+qWjQ0+nJZoXzK1VTRfOtgRpbzSd+rNc9wSURmZaxlU7sDB4v4CBH9e20HWY
         0yrIyPnLoqaeVsJ2kc+f84Lxq2oNpFNa9Gmw4abvysTBxceEIuQgyl5KK2sF8JTyuJ74
         E6HSX/OA6yl50jg7gjgKS2XUv8Jko0yVLslBEuFJR4+Oz/lX5pJa2vgLTrPmaF0AsQtb
         uBMg==
X-Gm-Message-State: AO0yUKXdK7XbHxR8g+DZQp1La9n4e66CQ0cAAoAOthlIVRJibpVKUqDS
        lpHj4FJaeRVS7jKuVpPR+tv1nUxw4UP56Hxnt0BEcy9SF76N
X-Google-Smtp-Source: AK7set94qle40IVKT8HROF2uZ0z0n5y6wUU4wDEytmeH7Pf86Jjg8zVGiG0Vhl3sG8+rZLmBNG5ULa1hyl/H7iZYcDNfryCHzKN8
MIME-Version: 1.0
X-Received: by 2002:a5e:c810:0:b0:752:f092:3ddd with SMTP id
 y16-20020a5ec810000000b00752f0923dddmr4052990iol.1.1679911771094; Mon, 27 Mar
 2023 03:09:31 -0700 (PDT)
Date:   Mon, 27 Mar 2023 03:09:31 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005ecaa405f7def0ad@google.com>
Subject: Re: KASAN: use-after-free Read in tc_chain_fill_node
From:   syzbot <syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org, jiri@mellanox.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        stable-commits@vger.kernel.org, stable@vger.kernel.org,
        syzkaller-lts-bugs@googlegroups.com, vladbu@mellanox.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
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
