Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18CDB7976
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 14:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731905AbfISMcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 08:32:03 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:42763 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfISMcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 08:32:03 -0400
Received: by mail-io1-f71.google.com with SMTP id x9so4966162ior.9
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 05:32:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xRvATBd4vJz/ca0H8KHxwpk25gX5YP7T2VKX90zZjjY=;
        b=bn55qU2b+O12gYrTGT8oKMJ/h5VgulIxa7BEnHPM2aLDRXaESODigbgzzcDbgwwybj
         bu0Gjds0XrU8Jj1EzjZCZJC5gXD74h2bR6A7AAAvi7SIZmQwZFmmyka1C04kNwSkHk81
         PMz6Juo8CedcM7em/2WgGQSi89KEOfvcfdS3sXXODN0pVh62M0UNu/+9c67bhwt5Z9Ph
         0kowJOpbKbRrJjaGJ7WI1tv8LYmEswR5cv7PG5SXMlnLmWFCYy2EL8JlDMoAL2pVi6h+
         VYFsvMSp5MLY4MVFcUGi/Ljm8It3+5cYTgf1swA8TgL4TjYaEoosTPbUFZjVaBlxZIwf
         gIFg==
X-Gm-Message-State: APjAAAU7a1EDIYMkyYVgvUQgrmzTpDjOnH5Zfla0ax8Mc79pCvqsb2Bo
        MkjknS5IRbOkJQcjVdthDz6RTsQfobsyGW8NlIUlSUI+22kV
X-Google-Smtp-Source: APXvYqznsY295KYp6iVKDsqG6sE+Z6Mre4W0acF8SRnsbhhSSg0DoispESLcXcx0yTSMXL8rH7pjSRc8Sz/uxP6+Ti76M+HxxP4c
MIME-Version: 1.0
X-Received: by 2002:a6b:b8c3:: with SMTP id i186mr12174261iof.194.1568896320918;
 Thu, 19 Sep 2019 05:32:00 -0700 (PDT)
Date:   Thu, 19 Sep 2019 05:32:00 -0700
In-Reply-To: <20190919121234.30620-1-johan@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e5e3c40592e723c4@google.com>
Subject: Re: KASAN: use-after-free Read in atusb_disconnect
From:   syzbot <syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        johan@kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com

Tested on:

commit:         f0df5c1b usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c6633fa4ed00be5
dashboard link: https://syzkaller.appspot.com/bug?extid=f4509a9138a1472e7e80
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10f3ebb5600000

Note: testing is done by a robot and is best-effort only.
