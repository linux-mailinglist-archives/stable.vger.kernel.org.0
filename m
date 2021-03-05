Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077AA32DFFE
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 04:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCEDQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 22:16:40 -0500
Received: from mout.gmx.net ([212.227.15.18]:38791 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhCEDQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 22:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614914197;
        bh=EyO2MLJy+UEyFFXZd1BKN81H9cefZhxcDa8jzGc8Csc=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=llvE6FolwBHs8cWn3sSXFlFjDEFffr3Wsoyjrhlie8wyyxERT3vLwxMYiAXoPl5DJ
         egx0oKpuMNOwmPaCtbFA6s8OPL1kd/peGxRbjkB98yMF1+GHcDC0BJB4xmPf/HJ1ov
         v1xvYwXC4VsHVl6RuNS2Ujf1qKrmm71rOmNTT7pY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([185.146.51.102]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MGyxN-1lVTDq1b2h-00E32e; Fri, 05
 Mar 2021 04:16:37 +0100
Message-ID: <4dac43f81dc390faa6e62de39ade373851dd6b84.camel@gmx.de>
Subject: Re: Linux 5.10.20
From:   Mike Galbraith <efault@gmx.de>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Date:   Fri, 05 Mar 2021 04:16:36 +0100
In-Reply-To: <1614855672230162@kroah.com>
References: <1614855672230162@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kpG/H6B3pjheTv0it6l0jO8/dVy5wkiKML+X6xy9XOj6qBpAdaL
 H2fbGU1P+zNehy6iJ+Cf4Hk1AYz56+S21rDdt5S+loUpkbGLL8BoFh7tFnCKwUPlNsATBwk
 ADCzCQAj70J1lqgziUu2vF8H1dFVssabjaLSrYPFYPIwj4CC/T9TrS6tlT45Y5DnCGwKZUN
 qoAwnBT0judPEBtNi5AVg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gAnKazO1G08=:xAIDrwXpacsqWMQPawO8mG
 pvxQTdmp9OtAxKwllPh6w9G9lSEEY650G/ffLXwqL+W17ZZoFjq8YDf7DPTHeCPGn8ti+cTfQ
 k3EuYtYKuINT7mjqsTKQXC4xoQTIBAt+QsP37PaOM/wCycFtFlCOcUHAGfDWDqcRkTAZu2HVu
 apfZdnOB8yFkF3Ae9MrcRuY/mkCcsAfI52ayZiI2UX3I1z+YTFTYErX5oCJoVckQbTpy3MoSn
 waX678T7cNMCMgbJEKCwQEmuamDv1F7oFY8y51We09biuUOMKLrjeShFYHlELKQOxgii/vVWe
 o/QCK+ITOv3Jr7xHushAW32HzFoKuB76PIDDnAz0FP05n1MI6jJ392wqPlziWh0uPWNDGKh+K
 QRW7ccLZsQ1/oSyajO/VFSl0tICFOq/ukOQMaLl9n17uBy0nWX17bSMnuCVvUiyrHLfzyGUny
 VOUkZf3A3NrdD9WwWi8dP/4RM0teXsL5xmnD5SaV3TvUn2kiy2cneqTj3afsh0lcf2lzhgTaZ
 E3mfWr4s8K1bYm041r6g7rV6ngckgul1Mb55muC5s5ntaXyKKvuPlzI4ScnTunnCjov2Ran5n
 k8b+pdPg2qYG8Z/XO5fmyPN/GaDfzYahiZ6p7Y/hVoDhQxJMC17rQ2JT3KCLeQIA8JHHylho2
 dAgSQ/XgvvTAvYkHvpLGobM65OyCVrmWOWBWR+ONMYhtRHNrnW6c051cc5ZyggDaHqd+uUDkn
 8nPqn1PDSMzkC6m88Knn0KqvqZ+UPKSAPKcNh1SC/KomKaKCAU7L26KD2vPlrlaPFaCiEX79j
 ySzLjYvmk1UISR3MmrtiP6hdkX004jaEMGV216M2dcpYCy3qbipSLyjQfH+bla1JaWMNY3vLT
 dXACjKw41eWI4yHWsSMw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Damn, I forgot all about this, and it has now has spread.

f92bac3b141b8 kernel/printk/printk_safe.c (Sergey Senozhatsky 2016-12-27 2=
3:16:05 +0900 267) void printk_safe_flush_on_panic(void)
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 268) {
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 269)    /*
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 270)     * Make sure that we could access the main ring buff=
er.
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 271)     * Do not risk a double release when more CPUs are u=
p.
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 272)     */
554755be08fba kernel/printk/printk_safe.c (Sergey Senozhatsky 2018-05-30 1=
6:03:50 +0900 273)    if (raw_spin_is_locked(&logbuf_lock)) {
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 274)            if (num_online_cpus() > 1)
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 275)                    return;
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 276)
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 277)            debug_locks_off();
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 278)            raw_spin_lock_init(&logbuf_lock);
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 279)    }
cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 1=
7:00:42 -0700 280)
eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 1=
1:48:23 +0800 281)    if (raw_spin_is_locked(&safe_read_lock)) {
eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 1=
1:48:23 +0800 282)            if (num_online_cpus() > 1)
eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 1=
1:48:23 +0800 283)                    return;
eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 1=
1:48:23 +0800 284)
eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 1=
1:48:23 +0800 285)            debug_locks_off();
eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 1=
1:48:23 +0800 286)            raw_spin_lock_init(&safe_read_lock);
eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 1=
1:48:23 +0800 287)    }
eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 1=
1:48:23 +0800 288)

eb9036b4cf4c0 =3D=3D 8a8109f303e2 upstream, and accidentally duplicated
most of printk_safe_flush_on_panic().

	-Mike

