Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C410069423E
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 11:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjBMKHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 05:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjBMKHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 05:07:31 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE6ADBDD
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 02:07:29 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id 9-20020a056e0220c900b0030f1b0dfa9dso9051818ilq.4
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 02:07:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHBorJxtb8OOdvReJ/cspDu7cb80E+hJP4zqgvf9eJU=;
        b=c7kMpj05/XhPr6STpNXTW77PhGJoGZ0HYZwdbyoNh2BMxZX95SP2L631igRHaUwEx0
         0xKYkdy/cZrYas+mZm0k257zWrW+dKZV7aSVvmCYb9Ma3+SAKFkSLJkW8etXgvNGViQP
         rr02kcktP0i0VgR9xTejGmoJbfwN5ueNkawf8i5PymYmfVqSS5JAGRE5c0kf5dn34/Qn
         b6FvhuyLog4DajymF73oSR45dUDAugbqfrAkiXCumXu8MGPihl9MJXnxWOmtI4U1Gj5H
         2f+sKoRY9ZPMHHYQ8b9bejkAFE6Oljn5sKGWKQx9Os1S6MODzYVsMY0ADPtGB7h1UWVz
         edSA==
X-Gm-Message-State: AO0yUKXApIo+zUVD+bV0k3jK/Sep8+JQGziO3DnntPIEI/fpQhuOAj2I
        CvIT6T0PsTkEYITCbCNZJlxs+GWP+SthipOou7yyVXpfa9N2
X-Google-Smtp-Source: AK7set+1zNVr8o2nj/umsTq2MSUxT+uwUFhErqQ89XND3OWGaYEsKtjlinyVLzMfHvhdQTrdc2u9qIlH4UfDrjptuhJVAoRIXO4U
MIME-Version: 1.0
X-Received: by 2002:a5e:a90f:0:b0:71b:df97:1d95 with SMTP id
 c15-20020a5ea90f000000b0071bdf971d95mr11408959iod.80.1676282849081; Mon, 13
 Feb 2023 02:07:29 -0800 (PST)
Date:   Mon, 13 Feb 2023 02:07:29 -0800
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c33f7305f4920330@google.com>
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
