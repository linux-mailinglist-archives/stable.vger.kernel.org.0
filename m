Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CDE5F9C52
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 11:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiJJJ7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 05:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiJJJ7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 05:59:32 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6886361703
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 02:59:30 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id s3-20020a5eaa03000000b006bbdfc81c6fso2753821ioe.4
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 02:59:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=eVF/GKaOl/76CsQFuvrLEXYDRpAFQXvFla+Cjm53PfUzp9uHbEqMxHQaVALfp9mvNb
         0d2h0PM+SBqoo+s+vnYUBnB3yfpNlU/lAM8jnvJpFcCXXcilLYmUY7gJutjPFoWiY6lk
         reTm3TahHYWJi0xw6BiZfAV0/zYZDBx+JW0qGmff4ZbFvAn9FS0xet9SYpstf45Ctk2m
         ONtqe8PUzN1RoKopMLVm8oI/7/WQiQ+DTffxQI2z4RRCprMzGzAwmxCT9n+AjLRFb2wV
         TY+nrSqs7kxHunCZtglUKwBtoHtxSpT2YFnCPN4opgsK3V90ccVjFRSkM+ScbYsD4OXm
         /ASQ==
X-Gm-Message-State: ACrzQf3YbyaP1GDdd63EvfV430Ln8ltrybshaUg+Lgjd4gTNiJxnfkoe
        6aiS0Y0p/xa5gC8PWztdU5i21raP67/xLBuyn9qg/1yqhELi
X-Google-Smtp-Source: AMsMyM4yrhDnAJ+RQ4M/4ccm9QtbXKSwTqDl6yjCMHTveuHcHQ+jdCXpVDG7RmOV5kTWEmw7usIes59PTlTl8S9qk3pZnc2CJ3k0
MIME-Version: 1.0
X-Received: by 2002:a05:6602:c9:b0:6a1:4e25:8b0b with SMTP id
 z9-20020a05660200c900b006a14e258b0bmr8074876ioe.188.1665395969843; Mon, 10
 Oct 2022 02:59:29 -0700 (PDT)
Date:   Mon, 10 Oct 2022 02:59:29 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003166d005eaab3790@google.com>
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
