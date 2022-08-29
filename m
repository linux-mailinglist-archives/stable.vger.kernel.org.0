Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2B95A4692
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 11:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiH2J51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 05:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiH2J50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 05:57:26 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2A55EDD5
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 02:57:25 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id h8-20020a92c268000000b002e95299cff0so5637435ild.23
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 02:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=dEE5+4wQvQxHD1mQRkdtgUZgbp04K8eeXsProkV9T4BBnEGj/ycTP1leoDQzkKvcbV
         BOfIelH+dLvZl+pPLKhFF+Zs6+2i2E76VXane5QhC2lpapjfIoMgy9D4czwJHUeQ7m6W
         kVPdDPPdGr/Ol4Waa6dP9oMkqaOfEIhlPhQHhvjEpTqg8LYlquknLcidRtIN+v3/9TuN
         C7v1mwu5NyHjfcYbNDc0q8kEh0nTr1V3JkKCif+8ig0edw/9X9nXNqisG4sWNVnXk3AU
         EQhI8bXX/asyHIZ6WjJdsA2ZgNk2ojCbQWtRpN+Cp2ThP8pPF9kto1WnMHzIL4Fq0Mn3
         d3Tw==
X-Gm-Message-State: ACgBeo3hVJdS8WG1JCZdfmApdZsm9LOp5VCK5z40wiIMZ7wkoMh+PjBl
        PQdNy6SOGa3WXZ9NPtt9Vd9gPzGg73qntFfzPtaZolPXJtPf
X-Google-Smtp-Source: AA6agR4047SUJ1BLtOuBVO5UEYKaNvW+AYfU2ca+vudLKRQqkT0iYQAwoPhxw+l2bKYQdrlt0TJE9b8wp2UaQpbPo9e6zD+ZnsF5
MIME-Version: 1.0
X-Received: by 2002:a05:6638:dc4:b0:349:f86d:d29a with SMTP id
 m4-20020a0566380dc400b00349f86dd29amr10201198jaj.256.1661767044603; Mon, 29
 Aug 2022 02:57:24 -0700 (PDT)
Date:   Mon, 29 Aug 2022 02:57:24 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064a39405e75e4aca@google.com>
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
