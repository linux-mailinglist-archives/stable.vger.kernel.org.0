Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D143C85E3
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 16:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbhGNOTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 10:19:05 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:51003 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239505AbhGNOTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 10:19:04 -0400
Received: by mail-io1-f72.google.com with SMTP id x3-20020a5e83030000b029050f93606dd4so1279673iom.17
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 07:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=o7vzzn8Fdqo6mJv/pLO3d3/VK2CXYs/bZovvWQfPikg=;
        b=Ofc92/1b74MSZUvLnIo1d7ie7Sa7sp8s87ZlEx0m1qqF9zF1uNhq10Z8NQtzE+tGqX
         vtYtX45jczcXFb4E+u24lJI8x7X7JT2t2vFft+KG/mM+4Wi/BgH0EizNVu02inYwCAo4
         rx3RKkwCPXit2sC7rEw5Gu4Pc2G7YG2ybC7COqYyX3BUkvZTL/cChawbaVJ45ZIKWyWl
         kAF7UStS5xT3VJcg3XnGYQn5iPYftmpT+2Dp+bSU+uSn9fA7GZkDzGXX2i7rUm/PROtq
         bYzft4scZkE0sROmWcBImguoWxFoGk2FQANrN5uSLspFoPVNbhgEZ7wriDEfHMDylsJh
         qR2w==
X-Gm-Message-State: AOAM530khbHOQn06OxXlwZifgKdikepUWWBYQbeymXOaF7YEnuAc9f4T
        QoE71hsZDHBfyBCaBRxnqgbXvVeCrHJ1R5m4y6bQJ2afi8+F
X-Google-Smtp-Source: ABdhPJyn5tnlHP/kmIUxY05yxnh++4KY2h8hZkCs4WMGvpSLvMoszqGmE7eJ+eEIVEap1ROsNTlb3lNO/a43b+1kLs7gtu5pRZC4
MIME-Version: 1.0
X-Received: by 2002:a92:d3d1:: with SMTP id c17mr6620254ilh.86.1626272172775;
 Wed, 14 Jul 2021 07:16:12 -0700 (PDT)
Date:   Wed, 14 Jul 2021 07:16:12 -0700
In-Reply-To: <20210714135756.ammzl2vfiepzg3ve@wittgenstein>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002aa03b05c715ff73@google.com>
Subject: Re: [syzbot] KASAN: null-ptr-deref Read in filp_close (2)
From:   syzbot <syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com>
To:     brauner@kernel.org, christian.brauner@ubuntu.com,
        dvyukov@google.com, gregkh@linuxfoundation.org,
        gscrivan@redhat.com, hch@lst.de, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable-commits@vger.kernel.org,
        stable@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com

Tested on:

commit:         595fac5c cgroup: verify that source is a string
git tree:       https://gitlab.com/brauner/linux.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=20276914ec6ad813
dashboard link: https://syzkaller.appspot.com/bug?extid=283ce5a46486d6acdbaf
compiler:       

Note: testing is done by a robot and is best-effort only.
