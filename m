Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69216ACB43
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 09:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfIHHFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 03:05:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49998 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfIHHFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 03:05:41 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i6rGV-0006T8-Kv
        for stable@vger.kernel.org; Sun, 08 Sep 2019 09:05:39 +0200
Date:   Sun, 8 Sep 2019 09:05:34 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     stable@vger.kernel.org
Subject: Re: Linux 5.3-rc7 (fwd)
Message-ID: <alpine.DEB.2.21.1909080903450.1944@nanos.tec.linutronix.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


950b07c14e8c ("Revert "x86/apic: Include the LDR when clearing out APIC registers"")

in Linus tree needs to go back into stable as the reverted commit
558682b52919 ("x86/apic: Include the LDR when clearing out APIC registers")
hit stable trees.

Thanks,

	tglx

---------- Forwarded message ----------
Date: Sat, 7 Sep 2019 14:13:22 -0700
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
    Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
    Bandan Das <bsd@redhat.com>
Subject: Re: Linux 5.3-rc7

On Sat, Sep 7, 2019 at 1:44 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> That's what I just replied to Chris. Can you do it right away or should I queue it up?

Done.

Thanks,
          Linus
