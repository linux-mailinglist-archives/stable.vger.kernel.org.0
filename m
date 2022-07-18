Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7914F577F16
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 11:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbiGRJzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 05:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiGRJzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 05:55:19 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E8B19C29
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 02:55:19 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id 11-20020a056e0216cb00b002dc7bfe6ad0so7238467ilx.9
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 02:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=ZEAaeB3AginX1NKli88CHDmdwhP1TVnQf/8Ue0THaSOuDtxu23st0eldx8mOKRAyps
         d/0HmgkR1W3VbN/gG90lVOv6nbAGFQVKdqniUuYImt5bVRqEA7gSuPFCdKTMnQd5VGIX
         DeCBytC5zJ1J8M05QNRy2yY8V1ju4kyiLv8pG5JOJi1CNzB1pgqlMNZZYSrJz/wgZpbD
         vj356+OLCSMJ3uFsiG3K67gbrTkbnU9Fgbj7uLnd6OAAoQgeWlwxRH4Uzy8WQDx/eFWL
         hzhk0H5iq44SQfX4L8zOJDM0PwkQY5shj1wZl6MIQ+pPoatBztIfFWxlZx2zznriEPPc
         XS7A==
X-Gm-Message-State: AJIora/oX9MrximIeQI9WZe6+crpar+CTrxd0Ax10KMagxYSshWU6exj
        XB7tSLWmSZRfSOGDYMa1CWVmV0IZfjfGcWmA8aaKqux0XrGT
X-Google-Smtp-Source: AGRyM1tjOLfBvvm7nGTYCcVlW2HANOvFx8kR+Gn8j61DGN7YaKfh74Nt6ZRq1hi82IY4dVO7cApfVF28nSoYzuFHZ/AVd95wggA5
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1407:b0:67b:c2ca:f8ef with SMTP id
 t7-20020a056602140700b0067bc2caf8efmr12012882iov.38.1658138118388; Mon, 18
 Jul 2022 02:55:18 -0700 (PDT)
Date:   Mon, 18 Jul 2022 02:55:18 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008901a605e4115d97@google.com>
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
