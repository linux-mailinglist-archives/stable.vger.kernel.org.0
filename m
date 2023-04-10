Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8956DC597
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 12:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjDJKLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 06:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjDJKKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 06:10:54 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E1755BB
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 03:10:41 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id 188-20020a6b15c5000000b007590817bcfbso3317610iov.12
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 03:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681121440; x=1683713440;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHBorJxtb8OOdvReJ/cspDu7cb80E+hJP4zqgvf9eJU=;
        b=ak5Fqs+Rl953qiK6kce/UCKaKPf69F/L9oEKIAbZ8VLRYyg0rzKk9yOq3epsCiDqil
         CYpDvgXoxvDfb1Pjo4U+AzHs7jo/c/PSEnUH+v3OLytNeoL2fjOcAhi9Y1XQiGcGg+92
         kjei1FVJvefy2LTrhoeOE86B6/7sjgra5LDHax9hjjckMT9R0K1PfiZ+JVqPsM3vytQ3
         9ac1R1LR+o1Etp6DBRVeiRXoPxH6j7nTKJspr7FC6Hm2wEbWFCd8Z80WuBVoHSZ/d4HA
         5oxdiERAQopJA9lMm/cNCLu26UX6dZmtfMTtFnLE0XN3KiYVn883JfBfhQV3C+MpZKjd
         2g3A==
X-Gm-Message-State: AAQBX9cd1VYm5V6Td5mor+ckh9N1VqZvreQ7js0t4M3EGdCdlgSE1Efl
        p/8DBK1FkXYUaTZLLjr5DvZDN4rWc1PiPD+Q33aZi6NQj0nW
X-Google-Smtp-Source: AKy350Zmp2aeEbwge0kATF5oNqo1FQmMX43uL8O6Y1RqmEKNvHCVH7mJqHmQw9HQHeNL8hzsOx+eKH+Ib/K2sXknju9i1pqOSmyh
MIME-Version: 1.0
X-Received: by 2002:a92:c7cf:0:b0:326:534c:9d47 with SMTP id
 g15-20020a92c7cf000000b00326534c9d47mr5418050ilk.0.1681121440676; Mon, 10 Apr
 2023 03:10:40 -0700 (PDT)
Date:   Mon, 10 Apr 2023 03:10:40 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004bc18c05f8f896be@google.com>
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
