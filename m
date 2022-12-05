Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3162364264E
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 11:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiLEKDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 05:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiLEKDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 05:03:39 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC43CF6
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 02:03:38 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id i11-20020a056e02152b00b00303642498daso1465732ilu.5
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 02:03:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=B370jMWeMmvW1FbB9DpLwbodUBRZ24q75TlDY4DYg0gjV7d3VwRiMcvAIzXbqMLF9T
         JjYlAkOJ3YgDF6hWCbXq4w2H2XFASPfXZjXdjy5dQjC64+vx/rZwOWoov+yz9ImRqSvE
         zo4KN/tEcvddTaUJCn/v7d0/IW8oRYSqMEpeE9I1GjfKaSJmIgk63mrr2gIX+desSLLa
         8GJNbzzM8TfXOnkMs+PqDdsqoyvLbAUHgsjDSOuukBU3ettfvWSJKJnw3Ge08w1LYk8g
         M0qKysRS/2gg/TUjV9Fewu0sAZDQFhbbmjx8UEpxlhgzrXx2ztQ1Z+1/lvc0x1/SPk7K
         EudQ==
X-Gm-Message-State: ANoB5pl7C8wfpi+gkcWjEeGiJkFrmmZTKwILswGi8TcWi7xTsYM0OJ1c
        4JmzDTh54KH9IWxKvLNwml1rxbo9sZWaU7gzRlSaBnt3JwQQ
X-Google-Smtp-Source: AA0mqf6A9nhl03BO/uU380Ihl2+zu7W4+sPhFjI9s4qoei5e3boHFr9wue4FtJCqu+xvEjayVYISuxBkecYYw099cK+iDcEU+dyN
MIME-Version: 1.0
X-Received: by 2002:a02:ac92:0:b0:38a:219a:d627 with SMTP id
 x18-20020a02ac92000000b0038a219ad627mr5844842jan.174.1670234618187; Mon, 05
 Dec 2022 02:03:38 -0800 (PST)
Date:   Mon, 05 Dec 2022 02:03:38 -0800
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001bd6ea05ef11cd1c@google.com>
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
Until then the bug is still considered open and
new crashes with the same signature are ignored.
