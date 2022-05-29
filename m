Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B24653717E
	for <lists+stable@lfdr.de>; Sun, 29 May 2022 17:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiE2PTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 May 2022 11:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiE2PTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 May 2022 11:19:12 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4243D37A9A
        for <stable@vger.kernel.org>; Sun, 29 May 2022 08:19:11 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id a3-20020a924443000000b002d1bc79da14so6671039ilm.15
        for <stable@vger.kernel.org>; Sun, 29 May 2022 08:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=SZmS5uKU15BCKA3xunshV88b8on4gSZULFNjwvNdemI=;
        b=D6IiFYDaHEtTF8Q9zMx6OHq5stYepVGeTk5ukl4k4LRu+z70gUT4fFb/YPsbY4aban
         4rr41Macop5OR2WzXsUaHFskkln4MK9HU8hirxoaYLMga4mVnznBi2Zbp4yKaa+xw0HN
         C63OtnCz609BwrHO1CBf/f6pMl1d2KBPSDuurtwo0mYZ6tuQDxi5GOnsIJO7+jrA7ryb
         WAOPKt0/ImM3BM0xiFjWbQER8IEDrQlVj2uy5eX0vxqjBbFUAXKqj00Dudh/HuE1OPss
         yquTuo8tXdQigFcGOHL3G7sKMvT+wfK/89hk0rrO2KThgnx5Cn4AzVP18AeClnLNqVaV
         /caw==
X-Gm-Message-State: AOAM530hOKjFzpaEDMGV2hQTS5JrE1Mo1aYSXJX3Oo6nTXWvZdqgDOEq
        YCd7SCjLFtIKCjLBwukCDVGZXLpc1sb5hzQSdIIk2NFfGDIb
X-Google-Smtp-Source: ABdhPJwlYN42ZL1pvPqEpBU1WbtFr0aNM3OMOKhi8hrqi7/cZGR/Q651zjP/5LyvBJoFvErgOOfHFuHrw0gzkMgRGqoIO3OJAl9G
MIME-Version: 1.0
X-Received: by 2002:a05:6638:24cf:b0:32e:d03e:3185 with SMTP id
 y15-20020a05663824cf00b0032ed03e3185mr17548073jat.99.1653837549180; Sun, 29
 May 2022 08:19:09 -0700 (PDT)
Date:   Sun, 29 May 2022 08:19:09 -0700
In-Reply-To: <YpNrSABPtB5eDC+m@rowland.harvard.edu>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a29e3905e0280faa@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in driver_register
From:   syzbot <syzbot+dc7c3ca638e773db07f6@syzkaller.appspotmail.com>
To:     Julia.Lawall@inria.fr, andreyknvl@gmail.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, jannh@google.com,
        jj251510319013@gmail.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, rafael@kernel.org, sashal@kernel.org,
        schspa@gmail.com, stable@vger.kernel.org,
        stern@rowland.harvard.edu, syzkaller-bugs@googlegroups.com
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

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+dc7c3ca638e773db07f6@syzkaller.appspotmail.com

Tested on:

commit:         97fa5887 USB: new quirk for Dell Gen 2 devices
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=5a0efc262ca60947
dashboard link: https://syzkaller.appspot.com/bug?extid=dc7c3ca638e773db07f6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1224de7bf00000

Note: testing is done by a robot and is best-effort only.
