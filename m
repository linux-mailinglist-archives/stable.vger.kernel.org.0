Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB59A61EFD2
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 11:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiKGKBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 05:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiKGKBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 05:01:37 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AF812D00
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 02:01:36 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id o10-20020a056e02102a00b003006328df7bso8270971ilj.17
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 02:01:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=vX8jxALfrmGSTdYBQUOc+vffT0LKmnydhyPwqxY8Ir4HWhL5y+CdxOsmO8zSEydHUG
         aj/30HkodXxa5N5BbTGNJlkPSs5fIChTKL9CgdZ9IzTncHgxn/igBMXm3hsm79TcAF52
         LWj2ua19c6J8Q/124qB0OXvxj8irTs0XXKgj8pfmHawWyTK/YWpVL8Fl+zvVAXj+bFfT
         nnWyPTQcmFcq1XTlU9CrJ7FYW32o5yPRCo7aR+KDPiesBRHxc1iuaGtaYMr+84xIrwA9
         HBksPi7sMAfEGWnRYbkN7TU0uuoh/XfPCgvacKcKfnuFPKRWtBUDUYHWuqk92VM34+48
         BREA==
X-Gm-Message-State: ACrzQf2vT8n43RADdFFMEKXtX8At17Y1KIgoPA/KJNO9ifgrCf0EYy/4
        kySxnUpmpJ6cjZULFTV2PcXCNxpL6kCp3MsJH8uJIlxF4WxG
X-Google-Smtp-Source: AMsMyM4bdaS7YynhSN14HbxQ/Wme4D1BCDuJeSMTQ2aReeng3UX2J1E3m9kfrtv8IDzU8lNVM0y/7zZ1mvV5UidtjmeoaePQzMEb
MIME-Version: 1.0
X-Received: by 2002:a92:c910:0:b0:300:bfb8:65fa with SMTP id
 t16-20020a92c910000000b00300bfb865famr19947042ilp.276.1667815296058; Mon, 07
 Nov 2022 02:01:36 -0800 (PST)
Date:   Mon, 07 Nov 2022 02:01:36 -0800
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000045cc5205ecde82a7@google.com>
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
