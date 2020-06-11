Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009F61F6E04
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 21:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgFKTeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 15:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgFKTeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 15:34:09 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763D2C08C5C1;
        Thu, 11 Jun 2020 12:34:09 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jjSxi-0004gl-GP; Thu, 11 Jun 2020 21:34:06 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id BB375100F18; Thu, 11 Jun 2020 21:34:05 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Mark Salyzyn <salyzyn@android.com>, linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Chiawei Wang <chiaweiwang@google.com>,
        Mark Salyzyn <salyzyn@android.com>, stable@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH] lib/vdso: use CLOCK_REALTIME_COARSE for time()
In-Reply-To: <20200611155804.65204-1-salyzyn@android.com>
References: <20200611155804.65204-1-salyzyn@android.com>
Date:   Thu, 11 Jun 2020 21:34:05 +0200
Message-ID: <878sgt1jo2.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mark Salyzyn <salyzyn@android.com> writes:
> From: Chiawei Wang <chiaweiwang@google.com>
>
> CLOCK_REALTIME in vdso data won't be updated if
> __arch_use_vsyscall() returns false.

Errm!

# git grep __arch_use_vsyscall
#

Aside of that update_vsyscall() updates CLOCK_REALTIME data
unconditionally. No idea what this patch is solving.

> Cc: stable@vger.kernel.org # 5.4+

This # 5.4+ is pointless. You really want to add a fixes tag which pin
points the commit which introduced the wreckage.

But thats moot as this is not fixing anything not even in 5.4.

I assume this was developed against some Frankenkernel which has a messy
backport or a snapshot of some development version of that vdso stuff.

Not that I want to know, but please make sure that something you send my
way makes sense on sane kernels.

Oh well.

Thanks,

        tglx
