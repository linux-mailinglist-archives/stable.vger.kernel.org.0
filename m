Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066145E9E74
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 11:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiIZJ6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 05:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbiIZJ6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 05:58:30 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD7B27DCA
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 02:58:27 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id e14-20020a6b500e000000b006a13488a320so3501683iob.12
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 02:58:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=2v4T9fKm8Z7Mnb05z3XQgMJ7qJs9SdjBzkbVdbXKpQyed4+MfkmxOPw1KxuyK2lcDI
         iWlke5twbLi874BhdwWqIPyFak+cYmgYrV9QFa/7aENywm5dcPqCdJ9LU7sXVJwWBlyQ
         zoGTSAhWFH7E0W4AzEzSCOErbzzcv9nctGlsIuHKse5ElnMSpTXqN8XUEbnMajfiAD2K
         b8QmjDVTWdd7CoiMq4fYZrwJmR+k44yXWPvpB8py7/P/0mZKmjfL+lmWn2KiCvpVDdM7
         XPLWDhP7IEvXOJhOg4vTMGroLFfmINL8U7N11GK2I902b/Z1qJ5D11qP7rtC5PD17MNR
         VLag==
X-Gm-Message-State: ACrzQf2KNLppUD66woNJB57ezdeMLOKMG6t2z+3LSrSHFIOJ+daz5UCT
        4H1yL67nMmCn4gaFfWT77NKeOEg2uGP0zRr+XS0/z+Kl2PDx
X-Google-Smtp-Source: AMsMyM6LCArOmFmUUaFfdBA1XVhSSnXiqjvnEu32K9QrU3KieOaTBem27PPdtM9KYQcH4LfEltpYqyHGPm3CpFkye2VXhn/U4r2G
MIME-Version: 1.0
X-Received: by 2002:a6b:5f0b:0:b0:69e:dbfb:2db8 with SMTP id
 t11-20020a6b5f0b000000b0069edbfb2db8mr8664108iob.73.1664186307190; Mon, 26
 Sep 2022 02:58:27 -0700 (PDT)
Date:   Mon, 26 Sep 2022 02:58:27 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae283205e99191ca@google.com>
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
