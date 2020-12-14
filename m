Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27752DA145
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 21:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502878AbgLNUPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 15:15:14 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:43815 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503093AbgLNUMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 15:12:44 -0500
Received: by mail-il1-f198.google.com with SMTP id p6so14524839ils.10
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 12:12:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=qwOdLt+7OtBCq8ntrHqjxb5zguAuKgGyZJXiIAiKLL8=;
        b=INCzgsrJShMtBm4Hn7rHLb61J423v3KUSggjR9oexCD3s58Q2K5hduEESyhMZsBnkF
         A0J86nvzmnmgNLZSEJeNHkYmwZgfrOCRGIrrnw4ELH4illGa58b7hdMj3ULUyZbhpynJ
         o7i2hsjSdFYmiQonarnzQEjNGfPj44QKr34Z04i2my+7bJF2zymC1U8f8ydSHLeuVvI5
         ovKbYwEX8JKSsfY5gnImURmKOhnm2SPqqMOeXiVBboeE+TrE/u+tVFxsfd5s4CguSpwU
         Z+U4jZ0cuTzGfiPSwgHiufaZsBQowAFx0FjIYNZXvOYB1gnholDeda29yLRZ+VIMBdZJ
         2gew==
X-Gm-Message-State: AOAM532XytPFwpfVQWZ0SNU/XT1aTxSiA93nnPv6XNH7MspojkYci/gM
        AklzqrCM3IB29H06P+i6VEdlXqcovrviV6WirEaL8opruQWl
X-Google-Smtp-Source: ABdhPJxGk6qAN5y8QjwxmUH3VlUQvFFxBo49Eb4LJWyrkVn0YnMAjOK56iPxkABY0ATpU1RkoIaq5zvsHOalHb71CYGDQ0WV6ub+
MIME-Version: 1.0
X-Received: by 2002:a92:9a58:: with SMTP id t85mr38019496ili.172.1607976723542;
 Mon, 14 Dec 2020 12:12:03 -0800 (PST)
Date:   Mon, 14 Dec 2020 12:12:03 -0800
In-Reply-To: <X9eB5ZZMq6q5j4eW@localhost>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000069fb4f05b6724198@google.com>
Subject: Re: WARNING in yurex_write/usb_submit_urb
From:   syzbot <syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, gregkh@linuxfoundation.org,
        johan@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com

Tested on:

commit:         a256e240 usb: phy: convert comma to semicolon
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
kernel config:  https://syzkaller.appspot.com/x/.config?x=4536e7f93c2bc8e9
dashboard link: https://syzkaller.appspot.com/bug?extid=e87ebe0f7913f71f2ea5
compiler:       gcc (GCC) 10.1.0-syz 20200507
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11a9f703500000

Note: testing is done by a robot and is best-effort only.
