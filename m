Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D6520C0AB
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 12:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgF0KUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jun 2020 06:20:06 -0400
Received: from rin.romanrm.net ([51.158.148.128]:54094 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgF0KUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Jun 2020 06:20:06 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Jun 2020 06:20:03 EDT
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 91C8E42D;
        Sat, 27 Jun 2020 10:13:28 +0000 (UTC)
Date:   Sat, 27 Jun 2020 15:13:28 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Gabriel C <nix.or.die@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        angrypenguinpoland@gmail.com, Qiujun Huang <hqjagain@gmail.com>,
        ath9k-devel@qca.qualcomm.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k broken [was: Linux 5.7.3]
Message-ID: <20200627151328.1611acbc@natsu>
In-Reply-To: <b7993e83-1df7-0c93-f6dd-dba9dc10e27a@kernel.org>
References: <1592410366125160@kroah.com>
        <CAEJqkgjV8p6LtBV8YUGbNb0vYzKOQt4-AMAvYw5mzFr3eicyTg@mail.gmail.com>
        <b7993e83-1df7-0c93-f6dd-dba9dc10e27a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Jun 2020 06:57:13 +0200
Jiri Slaby <jirislaby@kernel.org> wrote:

> I fail to see how the commit could cause an issue like this. Is this
> really reproducibly broken with the commit and irreproducible without
> it? As it looks like a USB/wiring problem:
> usb 1-2: USB disconnect, device number 2
> ath: phy0: Reading Magic # failed
> ath: phy0: Unable to initialize hardware; initialization status: -5
> ...
> usb 1-2: device descriptor read/64, error -110
> usb 1-2: device descriptor read/64, error -71
> 
> Ccing ath9k maintainers too.

Note that this has been previously reported in:
https://bugzilla.kernel.org/show_bug.cgi?id=208251
and confirmed by several people on various stable series and the mainline that
the referenced commit is indeed causing the problem.

I don't get the "device descriptor read" errors though, my dmesg is posted on
the bug report, it just says "ath9k_htc: Failed to initialize the device".

> > I don't have so much info about the HW, besides a dmesg showing the
> > phy breaking.
> > I also added the reporter to CC too.
> > 
> > https://gist.github.com/AngryPenguinPL/1e545f0da3c2339e443b9e5044fcccea
> > 
> > If you need more info, please let me know and I'll try my best to get
> > it as fast as possible for you.

-- 
With respect,
Roman
