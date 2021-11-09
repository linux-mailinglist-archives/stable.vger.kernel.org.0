Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5A644AFDC
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 15:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhKIPBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 10:01:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234250AbhKIPA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 10:00:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5561F61211;
        Tue,  9 Nov 2021 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636469890;
        bh=+9UT4JjEfvmDWmb+FT+mdfKzE0MepG7Qp1SoI0567aU=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=tES8zGCsmzJ78bp2AWpu3CbxhGHSYr+TrJEUdu/i/tstneuZIWFWNEHn0zduEzbSr
         cSj2Xc5xlNuC9prdBemJI63dbh+TdKLce8FGfubFxkx3cTR5yLDu5iQjTHYurbqZ7r
         Nnvr3gT5Wonwi8vC8gjoeI13e67rydusl0dKmTZvKbM8wtiMcwLXPUDHNwL3Baugfk
         AZExFuFAppcrPuRVSb8D9e6f4S7p5XnQXeZUQFQjiB/5at3+2iRyePPL1ktO8TQCmO
         bKs0St3v3cDm3lQYkcIRIwGvA2GyLM8Ftiji1+gXIkHGXvMIptKMW3Fb/vKxBz66x4
         VSpSRBvQuNGCA==
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailauth.nyi.internal (Postfix) with ESMTP id 3D00D27C0054;
        Tue,  9 Nov 2021 09:58:08 -0500 (EST)
Received: from imap48 ([10.202.2.98])
  by compute4.internal (MEProxy); Tue, 09 Nov 2021 09:58:08 -0500
X-ME-Sender: <xms:f4yKYUXKr4-CT8beC1A5iT6grcp995HCA47W30aSNpR62p8ERrUx_w>
    <xme:f4yKYYiepNPxP1ASrcrrpr1VvfbSlyN7seq0cR1dPR5kXzHFCJh2ribvqCjqap0RD
    qmZtA6tZ7crxELWvfo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudeggdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedftehnugih
    ucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnheptdfhheettddvtedvtedugfeuuefhtddugedvleevleefvdetleffgfef
    vdekgeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudekheei
    fedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuhigrd
    hluhhtohdruhhs
X-ME-Proxy: <xmx:f4yKYVSlCrrEAdVakqANq050XSTUaKW3gOiCZ2T5xhCkWhlVIm9WKA>
    <xmx:f4yKYbHJLMpqr9AxNJh1-vIZp9-Pb6J8uXsuCNKvYLSYTd8doVLcwg>
    <xmx:f4yKYdnvcc6uundS8jT1bKtoOgeQvlLPNaENjuu4DqYxjeqFsuNJ9A>
    <xmx:gIyKYaTAIK2SgkeWwfD-3HB9hv9Zp6bdUDiE7T0tJ5KXHNkFJvsY6A>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C523321E0429; Tue,  9 Nov 2021 09:58:07 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1371-g2296cc3491-fm-20211109.003-g2296cc34
Mime-Version: 1.0
Message-Id: <649f4de7-3c91-4974-9af7-d981a2bf6224@www.fastmail.com>
In-Reply-To: <CADyq12whSxPdJhf4qg_w-7YXgEKWx4SDHByNBNZbfWDOeEY-8w@mail.gmail.com>
References: <CADyq12yY25-LS8cV5LY-C=6_0HLPVZbSJCKtCDJm+wyHQSeVTg@mail.gmail.com>
 <cb682c8a-255e-28e5-d4e0-0981c2ab6ffd@intel.com>
 <85925a39-37c3-a79a-a084-51f2f291ca9c@intel.com>
 <CADyq12y0o=Y1MOMe7pCghy2ZEV2Y0Dd7jm5e=3o2N4-i088MWw@mail.gmail.com>
 <472b8dbf-2c55-98c9-39ad-2db32a649a20@intel.com>
 <CADyq12whSxPdJhf4qg_w-7YXgEKWx4SDHByNBNZbfWDOeEY-8w@mail.gmail.com>
Date:   Tue, 09 Nov 2021 06:57:47 -0800
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Brian Geffon" <bgeffon@google.com>,
        "Dave Hansen" <dave.hansen@intel.com>
Cc:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Guenter Roeck" <groeck@google.com>,
        "Borislav Petkov" <bp@suse.de>, stable@vger.kernel.org,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: XSAVE / RDPKRU on Intel 11th Gen Core CPUs
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Tue, Nov 9, 2021, at 5:43 AM, Brian Geffon wrote:
> Hi Dave,
>
> On Tue, Nov 9, 2021 at 1:49 AM Dave Hansen <dave.hansen@intel.com> wrote:
>> Well, gosh, it's making it back to the software init value.  If you do:
>>
>>         echo 0x15555554 > /sys/kernel/debug/x86/init_pkru
>>
>> do you end up with 0x15555554 as the value?
>
> What's interesting is that writing to init_pkru fails with -EINVAL for me,
> and I've traced it down to get_xsave_addr() returning NULL on the following
> check:
>
>   /*
>   * This assumes the last 'xsave*' instruction to
>   * have requested that 'xfeature_nr' be saved.
>   * If it did not, we might be seeing and old value
>   * of the field in the buffer.
>   *
>   * This can happen because the last 'xsave' did not
>   * request that this feature be saved (unlikely)
>   * or because the "init optimization" caused it
>   * to not be saved.
>   */
>   if (!(xsave->header.xfeatures & BIT_ULL(xfeature_nr)))
>      return NULL;

Here's an excerpt from an old email that I, perhaps unwisely, sent to Dave but not to a public list:

static inline void write_pkru(u32 pkru)
{
        struct pkru_state *pk;

        if (!boot_cpu_has(X86_FEATURE_OSPKE))
                return;

        pk = get_xsave_addr(&current->thread.fpu.state.xsave,
XFEATURE_PKRU);

        /*
         * The PKRU value in xstate needs to be in sync with the value
that is
         * written to the CPU. The FPU restore on return to userland would
         * otherwise load the previous value again.
         */
        fpregs_lock();
        if (pk)
                pk->pkru = pkru;

^^^
else we just write to the PKRU register but leave XINUSE[PKRU] clear on
return to usermode?  That seems... unwise.

        __write_pkru(pkru);
        fpregs_unlock();
}

I bet you're hitting exactly this bug.  The fix ended up being a whole series of patches, but the gist of it is that the write_pkru() slow path needs to set the xfeature bit in the xsave buffer and then do the write.  It should be possible to make a little patch to do just this in a couple lines of code.
