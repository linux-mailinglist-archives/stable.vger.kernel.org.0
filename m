Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40F76A3F30
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 11:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjB0KIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 05:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjB0KIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 05:08:36 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94C24EC9
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 02:08:35 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id z6-20020a056602080600b007407df88db0so3714859iow.23
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 02:08:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHBorJxtb8OOdvReJ/cspDu7cb80E+hJP4zqgvf9eJU=;
        b=kiJM/Qm7L/4fjGh08lSnd4pVj/qtSVEmikC2Y+8oONe2dai7cNldM3lBhVp0N1hy2b
         +f3PBAno+WfVcv5RPhMBiNgdutIhCZOLa6pimP1INA1nFBELvsmB6LqGLgouJlEmMYyu
         uBVRdVLrCwjuFf1e+Ajk2POlChjYJv2kwZJP+OBfYdiCyaMvHrkoU1UdI+S0m62DcJ4e
         2Jd21GIlLapYjUuehbpDHd8XyXLrgomvpuwPUK2XHwGx0sKA1FT5s1v7wHYo2YehLDZp
         YN3QtOsIlNBExO9ajaxtq8s4TNY8XwdOreQ1U1Ca3XIBqPeb3he3pcBO9LWYxAX7Q5FL
         QtEQ==
X-Gm-Message-State: AO0yUKV9OrkaORQULV90fmlO+axgBpCiGq8yZnXIfKsuZwf3v+lU0w4V
        inoDdY7sn8FjP0ycj/XJ53jVBmG4yGc2b4urRQGLK52Uneo9
X-Google-Smtp-Source: AK7set9XQOjnaY+h0KPoKF8yzSMNDRjBgH9I4koeZnVndKXg0GN9QwyrO+eJsiVC+58G+gFmqP7opHmTZ+1yfcagTkYNKJus8QSw
MIME-Version: 1.0
X-Received: by 2002:a02:2907:0:b0:3eb:fd40:78be with SMTP id
 p7-20020a022907000000b003ebfd4078bemr2564199jap.3.1677492515115; Mon, 27 Feb
 2023 02:08:35 -0800 (PST)
Date:   Mon, 27 Feb 2023 02:08:35 -0800
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007a186e05f5aba972@google.com>
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
