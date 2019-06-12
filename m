Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34970422AC
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 12:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408914AbfFLKis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 06:38:48 -0400
Received: from mout.web.de ([212.227.17.12]:35415 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407474AbfFLKis (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 06:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1560335920;
        bh=w7Zapu97qEenwfGP8VjODN6jV86L8V7ffF+//76IatM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=pkZ3HlONe4+40eHueQucv6Xeqc1A/rYbNkDUO3XhfCvN/rCGD8DODqaj7aT2ayAzG
         SKgDsJ/kn16PZRo9/AWahOg2zy5pLqDUyJj9rVQNFzGF4vzA8U3A44+GJaZMGawj0r
         7hih7dCuoPuVICCCQnKvH6N+wEDl4DSUjGGGcMhQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.15.237.104]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MZlZK-1hwOLh1sdC-00LXk3; Wed, 12
 Jun 2019 12:38:39 +0200
Subject: Re: [PATCH] Revert "usb: core: remove local_irq_save() around
 ->complete() handler"
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190531215340.24539-1-smoch@web.de>
 <20190531220535.GA16603@kroah.com>
 <6c03445c-3607-9f33-afee-94613f8d6978@web.de>
 <20190601105008.zfqrtu6krw4mhisb@linutronix.de>
 <20190601110247.v4lzwvqhuwrjrotb@linutronix.de>
From:   Soeren Moch <smoch@web.de>
Message-ID: <fb64b378-57a1-19f4-0fd2-1689fc3d8540@web.de>
Date:   Wed, 12 Jun 2019 12:38:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190601110247.v4lzwvqhuwrjrotb@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ITNzeUPAh3LVNjomSsgP/7ESekNXFtNIcYrM8VUzfhsiM22HdCO
 CWmklggNCUM0Uf4ZW2ZKTToWeTInSyP6JbGKafvWIP6EWHdDZ71Pic8v2sQXSlSz0jBYdKl
 SGZjq3HugqgJi0zhQl0zw3gbMgJkoqf1rUw4h/RS4cNzv4oVRvhzG6IYNcFsJbSKrM9sDd2
 GexEeIchvU8IqpVb1PH6Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mKTjyQwiRoo=:jxymFFKr2qEOQchX/kGA8F
 3Vb44yIm2uxAibNMScG0Q39c+yZMRO6Ly82yoN7ZYkQUTw1ddGd0AOeD1R93IgHeBuA3LPpy2
 S3iibh9PXMiC6laGMQJwPtB+A8OSQ/+H0w/IoxCB7NP8tocZP/qSvTcismqjjnagJi1npxKuM
 1iNNDnt66/53JrWALQqNghnE8FJKBojKSkjHkGzlcL3nAhjwCdshD5J1fnd0uYqsxZIcUPIh4
 cW8KC0rxuNegknB+zqQ6pSqfGO/jV8HKJhYJ2vgvMVVmhIBb2emrR0IZVUT02TwxDebHRlDC/
 GTVLvx2Fi2PVW6EZ5CQUAhHbdNGLU6uzkl41o9TiiukD7TtubMMD8sraRwHT3t3bb6GhDeOjw
 OplazHsqxLjy0BLOD+mHKUTVhGvjtWrE4YKBzLnYowpcI/gkuNGgx5tbUQRnPmyKDLKy0Cxjg
 IbZr5ePmwgpPQWMc0mbUf5zp2pmDOYlqrjD+D2CJUKBAnfKotceym9fPSx5lXW8RRU3uXczmN
 LK9bSO2wcomdNUp+YB/wGDVc/c6hrHMAymlMNYQ5FZCVgQtJ7y5YgWN8hj/dufE/b3qsDM01f
 /s1Bsh3WM3EWSyytA1I9Qqap9KUnV+lpV1nAdGfYsDmkx1QOjZ6lrvV1SBW/wfGQvpCHPnxMT
 mUmx6LBPAAK2SS/6jNghnknFFXKCIwmDTvQUVOf5K5wP/piVV4sjyqWRV6O3stnyOPxcsuuyx
 VvaasqNBwSmDoO3o9SMlaYIMrtZso+46ZshdYIByDkmxlioKlNylR3ClB5F0mYQeCYrFe02uk
 /ji5C80f7yyJKg5Ul0cAYhNCv9PjD+K1rxsmPewnnISdhDP8DZ60omTmzmeOaeib16XBiym4o
 t2g62ePBcjlcdTYku3h6tYD0oslZl7BdCDEN1sdEmMbrinwVU1BYZ9ahU9PiMufHEmiZEGg54
 VFcLhy9Yh5+ruw1LmrwvUJsa/Gpq+JbVYvzfhZJyiv/SARdiciy9NAssRSZdLhEe2WT6KEX1e
 5A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 01.06.19 13:02, Sebastian Andrzej Siewior wrote:
> On 2019-06-01 12:50:08 [+0200], To Soeren Moch wrote:
>> I will look into this.
>
> nothing obvious. If there is really blocken lock, could you please
> enable lockdep
> |CONFIG_LOCK_DEBUGGING_SUPPORT=3Dy
> |CONFIG_PROVE_LOCKING=3Dy
> |# CONFIG_LOCK_STAT is not set
> |CONFIG_DEBUG_RT_MUTEXES=3Dy
> |CONFIG_DEBUG_SPINLOCK=3Dy
> |CONFIG_DEBUG_MUTEXES=3Dy
> |CONFIG_DEBUG_WW_MUTEX_SLOWPATH=3Dy
> |CONFIG_DEBUG_RWSEMS=3Dy
> |CONFIG_DEBUG_LOCK_ALLOC=3Dy
> |CONFIG_LOCKDEP=3Dy
> |# CONFIG_DEBUG_LOCKDEP is not set
> |CONFIG_DEBUG_ATOMIC_SLEEP=3Dy
>
> and send me the splat that lockdep will report?
>

Nothing interesting:

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 5.1.0 (root@matrix) (gcc version 7.4.0
(Debian 7.4.0-6)) #6 SMP PREEMPT Wed Jun 12 11:28:41 CEST 2019
[    0.000000] CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7),
cr=3D10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
instruction cache
[    0.000000] OF: fdt: Machine model: TBS2910 Matrix ARM mini PC
...
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000] rcu:     RCU lockdep checking is enabled.
...
[    0.003546] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.003657] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003713] ... MAX_LOCK_DEPTH:          48
[    0.003767] ... MAX_LOCKDEP_KEYS:        8191
[    0.003821] ... CLASSHASH_SIZE:          4096
[    0.003876] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.003931] ... MAX_LOCKDEP_CHAINS:      65536
[    0.003986] ... CHAINHASH_SIZE:          32768
[    0.004042]  memory used by lock dependency info: 5243 kB

Nothing else.

When stopping hostapd after it hangs:
[  903.504475] ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue
14 failed to flush

Soeren
