Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520174FB83E
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 11:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344861AbiDKJwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 05:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344815AbiDKJwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 05:52:00 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24009419B0
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 02:49:16 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id y19-20020a056e02119300b002c2d3ef05bfso10228340ili.18
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 02:49:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=3/OXRGO/p3xh1kYi3VQksBy21aG4n4poLN4RDTkYV9KEWuBSU7Jbeou2nD+b6dz840
         0sdPgC8CYMNE5FjDYjSDuLqD5HileReJRznv0nd1vrvUCb26uYBsNE/ByN8rpWv0uLW2
         27aSAeMXZ+ao9AP6eJ03byPo9Touv1yg71Sk8GO73WkxU15hD6MOwxVki3/jtbicwilQ
         uRj16bt7dWD3ix6O3S+u9YvuxK1LdHMFraGt7xF97MVCLBRVTQ5gJfdGVn3R36VjbH5G
         UjdMalD9mLnvgS/ZBb21IDwo8d856cDdypxO9YXaynpU1A0cNyax5UoFRmTYvilhzEmQ
         PFYw==
X-Gm-Message-State: AOAM5338x0vz00iK+IXZEtnK9H/oMBiv0ox4dy/pjc8BhNNUiqKjeLFh
        nwqWzK35OOWAy2q3E85qFM8VxCkhTU5O/qiq0y8KcqD62gHL
X-Google-Smtp-Source: ABdhPJya+VGlIXK8Qv5D3MtuNX7CtfRMHKNRzDlkUEXSiGRhE7Fv5uA9ytXlTU+u8AOfkoYFNe1JP+P7URjn2RXgsxZkCB59PiCe
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12e7:b0:2ca:b32b:f011 with SMTP id
 l7-20020a056e0212e700b002cab32bf011mr1680425iln.284.1649670555093; Mon, 11
 Apr 2022 02:49:15 -0700 (PDT)
Date:   Mon, 11 Apr 2022 02:49:15 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ed28805dc5ddb07@google.com>
Subject: Re: KASAN: use-after-free Read in tc_chain_fill_node
From:   syzbot <syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org, jiri@mellanox.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        stable-commits@vger.kernel.org, stable@vger.kernel.org,
        syzkaller-lts-bugs@googlegroups.com, vladbu@mellanox.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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
