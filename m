Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E81E149E
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 10:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390367AbfJWIsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 04:48:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48168 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390314AbfJWIsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 04:48:19 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iNCJQ-0005pZ-KC; Wed, 23 Oct 2019 10:48:12 +0200
Date:   Wed, 23 Oct 2019 10:48:11 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Huacai Chen <chenhc@lemote.com>
cc:     Andy Lutomirski <luto@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 110/110] lib/vdso: Improve do_hres() and update vdso data
 unconditionally
In-Reply-To: <CAAhV-H4PEcCgOBL8ksjc+4LC9VPoCRBMtuGEK6ckmdJYXjdcSg@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1910231037500.2308@nanos.tec.linutronix.de>
References: <1571662320-1280-1-git-send-email-chenhc@lemote.com> <alpine.DEB.2.21.1910211648200.1904@nanos.tec.linutronix.de> <alpine.DEB.2.21.1910211658040.1904@nanos.tec.linutronix.de> <CAAhV-H4PEcCgOBL8ksjc+4LC9VPoCRBMtuGEK6ckmdJYXjdcSg@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 22 Oct 2019, Huacai Chen wrote:

  https://people.kernel.org/tglx/notes-about-netiquette

Look for Toppost
 
> If we use (s64)cycles < 0, then how to solve the problem that a 64bit
> counter become negative?

I doubt that you will be able to observe that. A 64bit value becomes
negative after 1<<63 cycles, i.e. at 1GHz thats 292 years of uptime.

What's your problem?

Thanks,

	tglx
