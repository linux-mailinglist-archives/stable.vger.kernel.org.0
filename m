Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62805397A10
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 20:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhFAS1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 14:27:33 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34780 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbhFAS1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 14:27:32 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622571950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=beT8fC3oUsFqWxn/mmXGhmMNMZgYwXE45W+eS01Tt+Y=;
        b=EL47N+oYsaCffcQ9lZiBl5C60FkCqyNxKLxHTh7V4GiWdyBUF/NkXFAhb4tajJtFkLrMsi
        muMIqkzoJrue/a1ZNJWFgI6oUFtun1FbajRwAytgwh77X1UsaxUamVxdff/vuXQ3UIwvRB
        CZBflGfZz48/Km6YTcnvGhP1pVYBorl8QV9dp26rsYUHA9Mko2efoEbMSMYaT4cRAQ5mRl
        OJOpERgvx/UqN50BJef9jJ7w9ql2RzeW+k8e5XiyLm8Esd5cCALOF6iQ+h0NSO24/mHmhe
        9qhbdB5cAzK5T3GewIhy2gOdqEOXmk80MeeTf0hn04gVHVnhZ4EZPCgzpgs8Bg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622571950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=beT8fC3oUsFqWxn/mmXGhmMNMZgYwXE45W+eS01Tt+Y=;
        b=ySL75CJyQLoX9PFwq8v0eTao2lQTNaVmkc3mWsZrnbuYavTN4fSJehZe1kp5VXBR0f5Cvq
        /MvbLaQBqzBYKSBA==
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Cc:     stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 3/5] x86/fpu: Clean up the fpu__clear() variants
In-Reply-To: <aef37213-8bf1-ff89-9b41-417dcdfbe713@intel.com>
References: <878s3u34iy.ffs@nanos.tec.linutronix.de> <603011b5-9479-3aac-78ee-74b9b5a5ef7c@kernel.org> <aef37213-8bf1-ff89-9b41-417dcdfbe713@intel.com>
Date:   Tue, 01 Jun 2021 20:25:49 +0200
Message-ID: <87zgw91lxu.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01 2021 at 11:06, Dave Hansen wrote:
> On to patch 3:
>
> Nit: Could we move the detailed comments about TIF_NEED_FPU_LOAD right
> next to the fpu__initialize() call?  It would make it painfully obvious
> which call is responsible.  The naming isn't super helpful here.

I've done that and picked up your changelog improvements. I did some
other tweaks myself during the day when I had a few cycles.

Here is my current pile which is based on Andy's.

     https://tglx.de/~tglx/patches.tar

Need to vanish for an hour. Can work on it afterwards again.

Thanks,

        Thomas
