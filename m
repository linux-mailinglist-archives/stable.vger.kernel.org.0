Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801C9530CD3
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 12:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiEWJwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 05:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbiEWJwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 05:52:16 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D262033E3F
        for <stable@vger.kernel.org>; Mon, 23 May 2022 02:52:14 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id x1-20020a056e020f0100b002c98fce9c13so8495610ilj.3
        for <stable@vger.kernel.org>; Mon, 23 May 2022 02:52:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=ydz6L+0Y8lB5apEl8e5uk4RAwpFR4je+lyva8JbwKWAzCqAo8blX5c4i+JRFxZVL6A
         IjuRcDsezAo1QEFV55Dp9RJfmT+ZazkK06iMUXwL0wjj8yQdN7xekAlsaK4oFDzhKhoN
         20tLw5tHjBUFRUWKAiNwpkUGK96uaTHiJ0ScTr6CSGJg9SUTpj/scgSCkEg0YNYQMqWp
         yAKlVotBzJ/UQrC3P0Bfd9eVMa36nwnLlgDG+XVT0FSwfYAuE55Qpk5TF+9Ko5jZpeSy
         wZnWL2a4CSUxPAnCXSpwjdARp61bTvi3ClgYF5WX1XBvBDmPIe9GDBh6Q6au3D9dFMBK
         dqQA==
X-Gm-Message-State: AOAM530fVshi7mzEb7rZo61Gq9yjIL52G4j2L0hd2ZOYC6jLX2z87+FX
        45AeRZ6xpaRaJta4raa5IHOgUN6oG8l6o2Swm06U7UAU9qp4
X-Google-Smtp-Source: ABdhPJyBawQvEWj+lTvgzmvc4lAf6KnVY19vIJFpJz7USDyprdxNu8Vi1MmNjhxvac1AWz6gU1x4Q9cbsnNbmF4BtY1R8C9sXxo+
MIME-Version: 1.0
X-Received: by 2002:a05:6638:218b:b0:32e:9612:109e with SMTP id
 s11-20020a056638218b00b0032e9612109emr8554181jaj.192.1653299534264; Mon, 23
 May 2022 02:52:14 -0700 (PDT)
Date:   Mon, 23 May 2022 02:52:14 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000727d7305dfaacb8d@google.com>
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
