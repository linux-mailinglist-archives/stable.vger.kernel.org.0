Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5FCBF351D
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 17:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbfKGQyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 11:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729656AbfKGQyb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 11:54:31 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F0152077C;
        Thu,  7 Nov 2019 16:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573145670;
        bh=NrSOsZi6jOLY0S57+WA9Ehj9OOtiUIdgVBK+A6ZRj3o=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=hEaP66T1mEMsezjd0r96IK5fJi75C6B9dAaG3QoHBGcUpcikelUP+gNZ0a/ebtezC
         pXWhKJGx0w7dCtlJKbGf7h0iS47Ta8tZwZKvXWr/9GpltnxQdT4Ch7TZyy1WXiXot/
         8YS2SFlvkOOF4o8RfFAVuf07+NXVNIxo1pEfwt8A=
Subject: Re: KASAN: use-after-free Read in vhci_hub_control
To:     syzbot <syzbot+600b03e0cf1b73bb23c4@syzkaller.appspotmail.com>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        sudipm.mukherjee@gmail.com, syzkaller-bugs@googlegroups.com,
        valentina.manea.m@gmail.com, shuah <shuah@kernel.org>
References: <000000000000c460630596c1d40d@google.com>
From:   shuah <shuah@kernel.org>
Message-ID: <e312222f-d24e-ad18-1801-e266d6497a6a@kernel.org>
Date:   Thu, 7 Nov 2019 09:54:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <000000000000c460630596c1d40d@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/7/19 6:42 AM, syzbot wrote:
> syzbot suspects this bug was fixed by commit:
> 
> commit 81f7567c51ad97668d1c3a48e8ecc482e64d4161
> Author: Shuah Khan (Samsung OSG) <shuah@kernel.org>
> Date:   Fri Oct 5 22:17:44 2018 +0000
> 
>      usb: usbip: Fix BUG: KASAN: slab-out-of-bounds in vhci_hub_control()
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14046c2c600000
> start commit:   420f51f4 Merge tag 'arm64-fixes' of 
> git://git.kernel.org/p..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=531a917630d2a492
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=600b03e0cf1b73bb23c4
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1116710a400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119be4ea400000
> 
> If the result looks correct, please mark the bug fixed by replying with:
> 
> #syz fix: usb: usbip: Fix BUG: KASAN: slab-out-of-bounds in 
> vhci_hub_control()
> 
> For information about bisection process see: 
> https://goo.gl/tpsmEJ#bisection
> 

#syz fix: usb: usbip: Fix BUG: KASAN: slab-out-of-bounds in 
vhci_hub_control()
