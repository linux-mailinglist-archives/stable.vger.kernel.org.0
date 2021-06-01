Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC953397CF2
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 01:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbhFAXSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 19:18:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35922 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbhFAXSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 19:18:44 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622589421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/44AR8mjIUV3tLcVwN8xAuhMe9t5vedqW7xRfS+McJY=;
        b=mr9rQavio7tkiKtQC5xR15NW3UL3XwtjRXydESh7Ji6StuG1dkejl4XNIyli2i0SWcfDca
        IeL4skpkzoA6iZxh/a0JLLtlMlfTvV1anyoq6xcqroske97Z2VthG1atGVeKuRcXnjDm87
        bRnd++B16OEUp0MvdlfW2dWyIrc49bl/IX5DDlT9VGkJwlinkH2ikahrwzjCnBuhK3USog
        wGxlnwUq/k9PEvl62DgLaoBiKCqKAJ5ih8Ckbvgke6D9/ivsGDTMFPckEfujDncmsr+56o
        HOfBdEFas3HzqRtRG2GvSqYuRkm3hxWSdzVVwAhI9AoY92okv2d3cXJgwuZHvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622589421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/44AR8mjIUV3tLcVwN8xAuhMe9t5vedqW7xRfS+McJY=;
        b=hxBRQBSsizaBFRB3GB8/up+MWimjEHpvB3Qc1HJPnjZQJ13ZSd7W/7ea2OhYPmt9HaQFjq
        +wV9K/1nxnHCXSBg==
To:     Andy Lutomirski <luto@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>, stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Subject: Re: [RFC v2 1/2] x86/fpu: Fix state corruption in __fpu__restore_sig()
In-Reply-To: <878s3u34iy.ffs@nanos.tec.linutronix.de>
References: <878s3u34iy.ffs@nanos.tec.linutronix.de>
Date:   Wed, 02 Jun 2021 01:17:01 +0200
Message-ID: <87pmx518gi.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01 2021 at 00:46, Thomas Gleixner wrote:
> I'm too tired now to test the xstateregs_set() muck, but if you want to
> have a look:
>
>      https://tglx.de/~tglx/patches.tar

And of course the last patch in that series was f*cked up by me. Working
set with all updates included is available at the URL above.

Thanks,

        tglx
