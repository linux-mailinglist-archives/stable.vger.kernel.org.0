Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953BB51F931
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiEIKDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbiEIJ4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 05:56:35 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637E82250E
        for <stable@vger.kernel.org>; Mon,  9 May 2022 02:52:41 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id t1-20020a056602140100b0065393cc1dc3so9618248iov.5
        for <stable@vger.kernel.org>; Mon, 09 May 2022 02:52:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=3alpnO2I0h2a+B6ipNCEg022X7zXT7DCtS+A/Mr1hZQUTNBTyl8UZqb5FPAm1JGVsq
         CitpGorDZVb0apj1pzVRh38sjQ7mQnm0Gz1DahOqW028zMw2J2YRDPlczUpcMLLmXw2q
         TzthjSbPJt4SvkyTT4TjfYHF4Rr44WH2zWcktcmEnTVueEas2ezqaD0eiqcqLUmm9RqK
         GxDxnaO8ZgikVw4v9M570ul/D8GSbMBKhgKnkcaScfmhNtpAIVNIeAGsSk0pNgiuGLsR
         ZGGnA1xSJbZJp+J2RkDte5GCiTQbjoIJfxn/aGj21FVYNVVjjGwzL4Oeyzb/ggYzd4Wv
         n06g==
X-Gm-Message-State: AOAM532xkUixQwMwveB1+FJZY45froCkFPnPJmQJrC4a9mruoV6uJ3FM
        gaCeK62lN/X/G61NKPdSFibkDLt2qwsgveo+mO9hppBA1/nw
X-Google-Smtp-Source: ABdhPJwC5VBYSGI1OjMKdjkjOz+1Jf91KSyPmT4fLRxn5GNtpWlrQsK1xGMcgqF/AQB1egQn9AWvukxzu2EVwgWTWtrdUyckeO2k
MIME-Version: 1.0
X-Received: by 2002:a92:bf06:0:b0:2c9:b21d:6db7 with SMTP id
 z6-20020a92bf06000000b002c9b21d6db7mr6241391ilh.222.1652089884479; Mon, 09
 May 2022 02:51:24 -0700 (PDT)
Date:   Mon, 09 May 2022 02:51:24 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b3983c05de912629@google.com>
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
