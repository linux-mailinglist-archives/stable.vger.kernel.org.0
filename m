Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21451586728
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 11:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiHAJ4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 05:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiHAJ4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 05:56:24 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F172E2D1FD
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 02:56:23 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id p123-20020a6bbf81000000b00674f66cf13aso3526953iof.23
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 02:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=4iawnRZzhlZfjHdML8QiPuJtbJtEkD0bOgZViAb00ye+n5nrYrdLhTylsixXrtZ1Ok
         AnhXHdiUYdBo8QmqTDsT2fcDOmFxCzk/rk/06XVY/jCaEdel0TgqRR2ZkefGLpCe1xU5
         KSrO4SYiwzVIUTFVVbM+5T5sxzIPRvu3HAgBu7L7B2jZ/vsBt1FP0IyV2CNz169P4dU5
         YboUOwK54FHsQ2Un5litokruMbLMrXgMnamu8HfTfTEZTYJFrmfD/34rSebQvc0wJyfK
         nKoVruEHos8wujuXcM07t80P350yIlGbp2tNAlWEbR9MYk2Equ9yymHQ2vK3XwR1gELX
         otng==
X-Gm-Message-State: AJIora8Spdvlblvr2MwDPy5oe+0gxCVttWTjkTZpZsWGuhjHZJ6oXldE
        YA5TQZuNcYbrNv/qmFyKDyHGULxu5sVDSke/Y9wcpL+6i94W
X-Google-Smtp-Source: AGRyM1uAv384XmYFLje5oK1UbKPaO9DcSJodVy0T7Oavv/IaWgl4yFi49IoDV4lBszGsWPPz5Qxd9PUDRLeL11k9ouC4lDqFTIgs
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3e12:b0:33f:2c4f:a2af with SMTP id
 co18-20020a0566383e1200b0033f2c4fa2afmr6013533jab.97.1659347783075; Mon, 01
 Aug 2022 02:56:23 -0700 (PDT)
Date:   Mon, 01 Aug 2022 02:56:23 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b4cd505e52b03db@google.com>
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
