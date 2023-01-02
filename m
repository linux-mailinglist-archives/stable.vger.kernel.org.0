Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D2065AF44
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 11:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjABKFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 05:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjABKFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 05:05:38 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF1810E1
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 02:05:37 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id e9-20020a056e020b2900b003036757d5caso17656183ilu.10
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 02:05:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHBorJxtb8OOdvReJ/cspDu7cb80E+hJP4zqgvf9eJU=;
        b=IOrNd/xk2CtT6G7eUXyEYISHoN0Nb93rIyJCs4d6wKFsJZODx+pSccYb2QXH2TSAnM
         EbCtJ6vaud0shio7SB069pLX4l+xg/b0ew3ECl+Yuho53fJcSQxo749mxe6bS+b5c/Ui
         fFZwf6BkXojWA55EQcdw89C+NMlPzv0vbthyPEB18qK0o1lXjEztYE7xUvYE5uf5TTMN
         EvSHgZucTeJjRk3r6SdV/eeeUkcoDhsH6bj8uL+FcV3CKlopqUTWd38mtdD6n43qEpOU
         vo2d2HP63Y6e20JikFwgmhaaY9fI4jyZ7iO1D8HvIZGM4FkHD6hWxaNfOZD3FJ1BTIL0
         tT2A==
X-Gm-Message-State: AFqh2kqyX8iF8rkQ107h8FQVAVfTWjvai8iI+4bsR5PWejorD4tvjnK5
        I/1Z4LWksJ7xEXSDD4SacY1WdFBx0KxWsrwe35NvKbV3iD5G
X-Google-Smtp-Source: AMrXdXtGyw3nbnlxQMy03Ht58G3Pnx4/xwyCQj9bpHFLTgL8L7Sl67FCdqX7wDWZHJGjdBj1jl1QzHd9obMxMiJCG0w0qALpLIrM
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ee:b0:30c:baf:6dee with SMTP id
 l14-20020a056e0212ee00b0030c0baf6deemr1846953iln.232.1672653936706; Mon, 02
 Jan 2023 02:05:36 -0800 (PST)
Date:   Mon, 02 Jan 2023 02:05:36 -0800
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000baca7d05f14517e5@google.com>
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
