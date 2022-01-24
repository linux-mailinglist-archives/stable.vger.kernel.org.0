Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4987B4984BA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241129AbiAXQ1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:27:23 -0500
Received: from mx-out.tlen.pl ([193.222.135.175]:17307 "EHLO mx-out.tlen.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241118AbiAXQ1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 11:27:22 -0500
Received: (wp-smtpd smtp.tlen.pl 33203 invoked from network); 24 Jan 2022 17:27:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1643041639; bh=R4CZm3Rxp1TxQjSL4R5Z53tyENlRsfUkyNCS+bPfpOI=;
          h=Subject:To:Cc:From;
          b=uVE1IyRPXooU8vkSFr8eJ/jcNeatyckOuzgiMKmO/QX5B4AMzCSCfYV7qzKxRMjeg
           9RvRGl1fyPhcje40ZU29zUXbOnUkNyqx9OhN07yg+p0vNdA//BzYvBl/iBucNQ9Ltq
           KzTq4ByfqEFbmWBW5sAmolRCSdt3w4/WHYrg369w=
Received: from aafh166.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.137.166])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <gregkh@linuxfoundation.org>; 24 Jan 2022 17:27:19 +0100
Message-ID: <23a5748e-55ca-69af-c9ff-d68a413a331d@o2.pl>
Date:   Mon, 24 Jan 2022 17:27:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: FAILED: patch "[PATCH] rtc: mc146818-lib: fix RTC presence check"
 failed to apply to 5.16-stable tree
Content-Language: en-GB
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     a.zummo@towertech.it, alexandre.belloni@bootlin.com,
        tglx@linutronix.de, stable@vger.kernel.org
References: <164302970310788@kroah.com>
 <df1a2547-c863-f416-58c9-4f64cce1f522@o2.pl> <Ye69PKB2V/R/NxN8@kroah.com>
From:   =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>
In-Reply-To: <Ye69PKB2V/R/NxN8@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: f3cd4a24654ae1dce453c63e93482415
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 000000A [cSOk]                               
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W dniu 24.01.2022 o 15:52, Greg KH pisze:
> On Mon, Jan 24, 2022 at 03:45:30PM +0100, Mateusz Jończyk wrote:
>> W dniu 24.01.2022 o 14:08, gregkh@linuxfoundation.org pisze:
>>> The patch below does not apply to the 5.16-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>>
>>> thanks,
>>>
>>> greg k-h
>> Wait, this patch was not intended for submission into stable yet, at least not in this form.
>> Why did it end up in the stable queue?
> Because it was marked with a "Fixes:" tag and I reviewed it and it
> looked like it actually fixed an issue.
>
> Is this not the case?

Yes, that's correct. But I'm afraid that this patch will cause regressions on some systems.
(Mr Alexandre Belloni said something similar of my series). So I'd like to wait till at least Linux 5.17 (final) is
released to see if it causes any trouble.

>> The return values from mc146818_get_time() changed in between,
>> so it is natural that it does not apply.
>>
>> See
>> commit d35786b3a28dee20 ("rtc: mc146818-lib: change return values of mc146818_get_time()")
> Ok, so will a working backport be sent sometime in the future?
> thanks,
>
> greg k-h

Greetings,

Mateusz

