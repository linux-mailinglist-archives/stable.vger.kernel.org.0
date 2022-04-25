Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7876150DD2A
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 11:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240369AbiDYJx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 05:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239899AbiDYJx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 05:53:26 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6383EBBB
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 02:50:16 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id q6-20020a056e0215c600b002c2c4091914so5834899ilu.14
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 02:50:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=kE0oBqj61QCQGSIJy09DObxFE3MyU7DlMrqvbNYeyo/cc7i0nT9kxVw66x8ywx82xm
         F+0SFc96CYgUp1mE4zdcnJV70CJg4YDwhSVJISF6RFCHIsaUVtuhwvkVBxa8xUn8xjKK
         I8+oPKaNwY+MCdjCLNQUlye65JVYJPIV66TTnM+TIxHMpo+z7SNhAyte0u37ZqUvnpGd
         2z1YN9lgPKhmJd+xEaggxa4bakBHO5YqMpnLZ5JoKJq5xVCc3B1b1GEN1Fk2sVnLYggx
         SSCoXzPJFYVIt723PnrLvaThKA7boU01O02K/aVLDQRS0SNfhf23R+XwADXw5CNJz63R
         x9ZQ==
X-Gm-Message-State: AOAM530GIZdmDb7cyXQBoiEEpBtLuDCXzVtx8HzNFRwv2JeOCW0liYCl
        ZlRkhEnRT1SSF3q2cIHwnSHJtzKKr31ILR+v4Hwt7pR27Lyu
X-Google-Smtp-Source: ABdhPJxsnwec4qGQ3iLqyhhN2fhXLxrey6xzMvtkmdOoNXX3lAAYt4RpxgKTopWG4cnjRkENFohSS1FyKXcLwAdKrc+jdVS1o4Dc
MIME-Version: 1.0
X-Received: by 2002:a05:6638:22d2:b0:32a:934e:8a62 with SMTP id
 j18-20020a05663822d200b0032a934e8a62mr7212999jat.138.1650880216395; Mon, 25
 Apr 2022 02:50:16 -0700 (PDT)
Date:   Mon, 25 Apr 2022 02:50:16 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd782c05dd77804f@google.com>
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
