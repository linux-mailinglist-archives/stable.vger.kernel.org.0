Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8486509C1
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 11:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiLSKEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 05:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLSKEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 05:04:32 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87DB2DF4
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 02:04:31 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id h11-20020a6b7a0b000000b006e0004fc167so3836216iom.5
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 02:04:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eyU2aTqJrEienAovyYz9d8BtwNn+WYphP8UJdFWjqvw=;
        b=nHDjDs1EX7js12qlj1fljAl1eJ361O6GxtEW0k7jB/4cKvCgXOBFUbCdzDBr4TrrI0
         20bNES/YXgeQmD0Liatqmncf/jGXrxSx1Af1JGE8ZnMAsbjRZXFCeyCjElmMX3N15T9Q
         Nlqh+SF86bnV2NrkIIzXoNGhMnf/4rItMicHCcmpWK6CZ0H43ngk8j2LFDeLgPzlJz4U
         KJqFYnZj1UTO6rJDlCaOShZW7VTQyt6MQrfqHaFnZN4aBsMs4tESDNRl66Dj2SII4RLE
         g80zQd20rhGAN5ybzisf2GI7rSFHmBpO1Sf99UUkDyvmZY8YhagKrgRSH/t18F+r0yR7
         HLyw==
X-Gm-Message-State: ANoB5pn99ad/B6HqvGJJcel9ByH/05FceH+jHV5ckZszyBhKQ95QQ8Ig
        /VlgTdooUlL+OKAgJJBeNdNPXXP5mYTseS7pSB7uSQO1fKCw
X-Google-Smtp-Source: AA0mqf59Vv/cxyI3zDwpIJ7v3WG0pccDSkld2sIjZgSJZzD2DTs3ssqktEYjfqDBM9eGMQ/fdZ///hGWO63SchopcMxN/THnH7fo
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:14a:b0:303:f9f:74cb with SMTP id
 j10-20020a056e02014a00b003030f9f74cbmr25665155ilr.167.1671444271272; Mon, 19
 Dec 2022 02:04:31 -0800 (PST)
Date:   Mon, 19 Dec 2022 02:04:31 -0800
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d1f3105f02b729c@google.com>
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
But I can't find it in any tested tree for more than 90 days.
Is it a correct commit? Please update it by replying:
#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with the same signature are ignored.

Dashboard link: https://syzkaller.appspot.com/bug?extid=5f229e48cccc804062c0
