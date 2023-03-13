Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4189A6B7369
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 11:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCMKIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 06:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCMKIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 06:08:49 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4361D90B
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 03:08:46 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id w8-20020a92db48000000b00322124084f3so6215502ilq.3
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 03:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678702125;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHBorJxtb8OOdvReJ/cspDu7cb80E+hJP4zqgvf9eJU=;
        b=coIEtNOOXDnqZ+7mnFY681wHl3ISS7Vi2LRigUAJhBk2HF5/5HGXs3J0HJxtebVnkz
         nMT3G5N6gwNgE82l/s40eKi6ZKxHMnxuB5Cj4L78t9I4l6USEVh+BX5mrtg+kYnYkOW4
         733D92mgqFWEciqeBgGTc+lsy4yXIzZID2MRNvOmBDKtJ5cbKnRdW/2HP17PcYa5r6Qp
         IilGu09fPtKp1i9fSv4DPjhuhdYW2Qhf9iDbarMsGmzrZgK2EkhRHIX7AW/+f3N+kfwZ
         bebXxWKnOKC0td6FQviLvEBkb8VPUERC6p0K6nEFnUwrOoOLccPe6ntKoua1uzLlhmdA
         6n+Q==
X-Gm-Message-State: AO0yUKUYeYmx0jw2nLcsKSBM58SD+sk/uG7nXlqIUXhUis5yfpuyoTyW
        T+JFQm5/a9yFYqLM6AiavYEuZWxxZJLI/8jLTKTPtyYfsdy7
X-Google-Smtp-Source: AK7set+QLDBL3HM2GBIs0e2NeRlDnUS0rfKdZOzo9gAKT9ZVnKKI1esGDLvqOQF/cRIKXfYMHsRJd9ExkoVPPoGSDD/SkQXWcfvo
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:10c3:b0:315:34c0:d463 with SMTP id
 s3-20020a056e0210c300b0031534c0d463mr15438778ilj.3.1678702125656; Mon, 13 Mar
 2023 03:08:45 -0700 (PDT)
Date:   Mon, 13 Mar 2023 03:08:45 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e231fc05f6c54bf3@google.com>
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
