Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C77E4D7EF3
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 10:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbiCNJsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 05:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237875AbiCNJsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 05:48:22 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124A53FBC8
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 02:47:13 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id x6-20020a923006000000b002bea39c3974so8838196ile.12
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 02:47:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=sVvRetvU66viZg03zt42J481swUWQOVgkFgrLPfYY/8=;
        b=tFiLCCVJLMklkKBz45Je2sna5cjCZ2wdl7M0hDNBDzxxGsAm0o/eoe9HXQ8CkMvELY
         4nuFouIm023GnEhG9LuelABFEi2vv1xiyVFLUZJ9RmWxRs26HwCoSUvRUcQdbCZALTSU
         z94uEpzE2LzHBj2O583QCpY8UYpQrGiCEMyPca2ESLB6HUwcpOlWQPunanrk9NEtJ7QP
         3NZqUfX4CJc6lEeNhk/EhJtpTl3oFpDiPDsnTawOxA3uUFlVZxq7912OiF75Jbbmjf9v
         d+KU7niMlP5OXpfJQvzHy61l+ILspAenjtg2ZQHdimfF/Y/kL+eiDZ6m9nOEbbYjLbAB
         MctA==
X-Gm-Message-State: AOAM532/Thf0zElfQ0gaV1TlwnoVKJyHNxkqdiJ8oJXwZPkP3WrRJwlY
        AO0mgRZn5+jB/muE/v35aQz5kiSGNO+Kuw/TQyTG3E0ViPvN
X-Google-Smtp-Source: ABdhPJwIqosa++Lmj+wLGtk5dmKbazucL5r6bCr45MbIstqic01FiTP0+c2nazdzGji8OxC7EAX156qmBK9C+3+aOmLLvJpHvkGY
MIME-Version: 1.0
X-Received: by 2002:a05:6638:34ac:b0:31a:8f1:e4f1 with SMTP id
 t44-20020a05663834ac00b0031a08f1e4f1mr3121597jal.75.1647251232496; Mon, 14
 Mar 2022 02:47:12 -0700 (PDT)
Date:   Mon, 14 Mar 2022 02:47:12 -0700
In-Reply-To: <000000000000b960c00594598949@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000091a0ff05da2a904f@google.com>
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
