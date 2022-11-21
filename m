Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AA3631DA0
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 11:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiKUKCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 05:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiKUKCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 05:02:41 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46177EA2
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 02:02:33 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id s1-20020a056e021a0100b003026adad6a9so8359755ild.18
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 02:02:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=Rl4fQyALLipsZv+ZuCJbnBirkaIr6ggRyk1yjTj3fEuwY3gn3Z8DIksdwrM1g+bvYG
         lhU+SdYfJjVmFSlRu8J2X8chK3D2jqpawD01avbL7R4iz0TXWa6m+kQhXZK9s0PfaAZ7
         iNyXc7UZx1x/spJyRVU0dJhMY7+oEGcNFfPXwmUjT+BcM5XNrgzZWexIIF36dlXWAMq9
         IZ0tnVQ2HADCLHgtQnZ4xcxJkCQ+rMJgSGe0qx+VT4vroDXMpcgP1gkH7D1fDc5rVfdn
         Sr/jMm8JuXBeOw+5lYaHMRihLLnygdnqaSDfnFCk+0qecr1HHf/dOxNvqaXdxyvVskwE
         q1Jg==
X-Gm-Message-State: ANoB5pkbHTXGPhTeTdsR14Q2scll3mPIwfYTGpT61n9p+zrp5hBk4fMb
        7xrnmjahwGhr9/ywUmMfZDa6by6HTnlke0MnYa2I2qpNPxrY
X-Google-Smtp-Source: AA0mqf4DXRUTk1M2JEFw1hVVO6Pm/Mk0WsH+TOGiQM6G5JfdjVdUgYVOruJip3nXvQmtYRnvb9aGnLOqzpzDUaSvI0ItIaKgDNYY
MIME-Version: 1.0
X-Received: by 2002:a92:dd0e:0:b0:300:b9c4:8c1 with SMTP id
 n14-20020a92dd0e000000b00300b9c408c1mr1764432ilm.124.1669024953189; Mon, 21
 Nov 2022 02:02:33 -0800 (PST)
Date:   Mon, 21 Nov 2022 02:02:33 -0800
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000074cd1505edf82717@google.com>
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
