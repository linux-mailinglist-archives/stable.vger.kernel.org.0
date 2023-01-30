Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BD1680A65
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 11:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbjA3KG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 05:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236324AbjA3KGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 05:06:53 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DAD30B3C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 02:06:44 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id v6-20020a056e0213c600b00310f8577354so1128631ilj.9
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 02:06:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHBorJxtb8OOdvReJ/cspDu7cb80E+hJP4zqgvf9eJU=;
        b=DLvYM6ZvN12KjMJTgxuPBC0BKi14LCzJBBRqX2bDsA7TE+9xpw8hv9jXOBdGoabE24
         Pmm9a3+fjo1wEaleNfSe7WYrtC5xwwy/NmTVjJKvXa6HoymNlOs9ZNYGrSdDhiHOAiem
         kggzkYki7j+9X/3xIDoH2yMZHIyDzhVDZzpn+wu+fNJHYikhu5OPbyufq1Q0sAimCQGx
         +wJMMCDtUJkdAr4FPbWnfVZEQoHk1nymcfhBrdPG3owye0T7baeMCCC+H6cFLOP3oEo0
         HFXv54kcMgp05MszaW1DEo4MiV6Lb5uJ0EzAvYZw+YqHF63yXEzy25WfIusDZOba8Yt+
         thWw==
X-Gm-Message-State: AO0yUKVp6WBcCA2ZuKhSpzjpvNoIN0ppKEhjZSj8hFgXMX+FSfXQTUqt
        eY23PM72sBW//0f7opPCGCKud6rmvVZYSdaUPzu9qjGoyAwv
X-Google-Smtp-Source: AK7set8QVvDE6Gzy4hHO8QvS/BqWwaHgQl6GdJ1EY5X9b6fjYAZywnh0zbGaU9rQ7PgnFR/LWwXICJmwpBQa4CnRQVXqL3xblwvl
MIME-Version: 1.0
X-Received: by 2002:a92:b512:0:b0:311:136:7727 with SMTP id
 f18-20020a92b512000000b0031101367727mr114568ile.112.1675073203474; Mon, 30
 Jan 2023 02:06:43 -0800 (PST)
Date:   Mon, 30 Jan 2023 02:06:43 -0800
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000441c7d05f3785ff7@google.com>
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
