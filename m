Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE7E676D3A
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjAVNso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjAVNsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:48:42 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1C194;
        Sun, 22 Jan 2023 05:48:41 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C691F5C00C4;
        Sun, 22 Jan 2023 08:48:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 22 Jan 2023 08:48:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1674395318; x=1674481718; bh=G6Tmbr8jJi
        ekEMSLf/7eP5hUcSQKeQ34idx3MZC2d/w=; b=JYFfCQrKisVdRrPZz7Kyk8Z9yk
        qT/7HN/eqwv4s7gE/7/CiUmyysAMGuqcnuLZ9nuEng/dhu6IC9llA4Sh4+WZdgT7
        CXwC5Rp1lChn260SLl20zjMOF0q4bmy2+sQIuNY4iWwaS/FCEHVuXdbR1wO0eRJ1
        DrAMzQ8LyJCbE2ygvsqNLNEF+hB3wM+l97h7YjbMpjVDxCCvZtDmo5c5Yw6SNtss
        NoqIH4iRQiNn72wuHDBi/aBgzWEJnVgJbHDQvu9G4x9tpFvMSzPRi+lgU4SSAZ3Q
        PLxztj3qBDBrOL9G1sFeK+QLCXAaL4BJwv2ugoh0pLQ1SSxdeIJPCKYm48lQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674395318; x=1674481718; bh=G6Tmbr8jJiekEMSLf/7eP5hUcSQK
        eQ34idx3MZC2d/w=; b=MAUx8A7xuxLYgp9LNcxbtmHGGTweeXjmydnOoS8HcubH
        LqJR6zyObcHVBEt0UpvFFqNCcItb5tSdU7NarBPb5eMEJKb1w7wBWCV8/+e0z+Pu
        MJv0+QIoAFcCa4aTkoXcDiNR0zo+mWu7wdsXWaJM7pJNNShzucAd8QxRL0Q1XyD4
        m8GEQYDWCIG41Gy5fYCvnRvRKu8nCfUrmuDhM/eZTUys+HGUvdY+4PGzQPz4/yf5
        rzlETK0yH33QGLTI7c+Tm2bprCk4J8pkLDkd0EJ7Z4qJWWrG10JTfHsaVxTaeuO1
        Rte1XQg4v8P4iu41L4YMJZRWVaepkxSC7TA+SmUTmA==
X-ME-Sender: <xms:tT7NY4sE4-6GMvRycXhOf02oL1J66vVQINLLH9cbaApuKxGvc4wcdA>
    <xme:tT7NY1ft165cJhIVtcYMQ-fubScYJFQ5G_MlrifM7Q7J0yk_VgoYQnHd9JVNLSCnH
    pf0AI_mi_XF0w>
X-ME-Received: <xmr:tT7NYzyQwKaoJX8VdRTshwWF9myo8SN0NzxbWaLKqEOm1c_gAE7P9e9uAE1CPbuwqtaBC-XsWjQW4ghtSvEaHl99DiquLwP1AyD3qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudduiedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:tj7NY7O9xkW747HILDuyo3n99y8HNK9yd8-NnifdaCOCnyG2E2SIdw>
    <xmx:tj7NY49bVZsJwuV_-z4ycotgl2VSrW7xFVh3_Jn7zgdsvJulrTworg>
    <xmx:tj7NYzUSVb6GdpQEjFtkWU-9YInNN_C8-J4Z93j0o-SW1KBCozhcPw>
    <xmx:tj7NY71XnIDfUxdogv8fv2tq5kA3-8qz1SgA1zdD-SLE_spPH3x7Bw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 22 Jan 2023 08:48:37 -0500 (EST)
Date:   Sun, 22 Jan 2023 14:48:35 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, catalin.marinas@arm.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/2] arm64: efi: Execute runtime services from a
 dedicated stack
Message-ID: <Y80+s+A5O3x8Rh7c@kroah.com>
References: <20221205201210.463781-1-ardb@kernel.org>
 <20221205201210.463781-2-ardb@kernel.org>
 <Y7VXg5MCRyAJFmus@google.com>
 <CAMj1kXEYDHuRmUPvdMVj1H1fLoOKcr+qG6NDpufxwJa57jsWdg@mail.gmail.com>
 <Y7WloqaytMnC8ZIC@FVFF77S0Q05N>
 <CAMj1kXEaX_3yFT_GFruXbQj9gfDShH4arPjTQBqokKAGusi_Fw@mail.gmail.com>
 <Y7WpsPDF+7fux8l3@FVFF77S0Q05N>
 <CAMj1kXGQW5Nj81rjDu_bGM6M3tWUaFwgBSxpCWbgJ+JBUPuJJw@mail.gmail.com>
 <Y7awzMZs51t2/34D@kroah.com>
 <Y8bTM3cbL3x9nhKa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8bTM3cbL3x9nhKa@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 04:56:19PM +0000, Lee Jones wrote:
> On Thu, 05 Jan 2023, Greg KH wrote:
> 
> > On Wed, Jan 04, 2023 at 05:32:18PM +0100, Ard Biesheuvel wrote:
> > > On Wed, 4 Jan 2023 at 17:30, Mark Rutland <mark.rutland@arm.com> wrote:
> > > >
> > > > On Wed, Jan 04, 2023 at 05:15:34PM +0100, Ard Biesheuvel wrote:
> > > > > On Wed, 4 Jan 2023 at 17:13, Mark Rutland <mark.rutland@arm.com> wrote:
> > > > > >
> > > > > > On Wed, Jan 04, 2023 at 02:56:19PM +0100, Ard Biesheuvel wrote:
> > > > > > > On Wed, 4 Jan 2023 at 11:40, Lee Jones <lee@kernel.org> wrote:
> > > > > > > >
> > > > > > > > On Mon, 05 Dec 2022, Ard Biesheuvel wrote:
> > > > > > > >
> > > > > > > > > With the introduction of PRMT in the ACPI subsystem, the EFI rts
> > > > > > > > > workqueue is no longer the only caller of efi_call_virt_pointer() in the
> > > > > > > > > kernel. This means the EFI runtime services lock is no longer sufficient
> > > > > > > > > to manage concurrent calls into firmware, but also that firmware calls
> > > > > > > > > may occur that are not marshalled via the workqueue mechanism, but
> > > > > > > > > originate directly from the caller context.
> > > > > > > > >
> > > > > > > > > For added robustness, and to ensure that the runtime services have 8 KiB
> > > > > > > > > of stack space available as per the EFI spec, introduce a spinlock
> > > > > > > > > protected EFI runtime stack of 8 KiB, where the spinlock also ensures
> > > > > > > > > serialization between the EFI rts workqueue (which itself serializes EFI
> > > > > > > > > runtime calls) and other callers of efi_call_virt_pointer().
> > > > > > > > >
> > > > > > > > > While at it, use the stack pivot to avoid reloading the shadow call
> > > > > > > > > stack pointer from the ordinary stack, as doing so could produce a
> > > > > > > > > gadget to defeat it.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > > > > > > ---
> > > > > > > > >  arch/arm64/include/asm/efi.h       |  3 +++
> > > > > > > > >  arch/arm64/kernel/efi-rt-wrapper.S | 13 +++++++++-
> > > > > > > > >  arch/arm64/kernel/efi.c            | 25 ++++++++++++++++++++
> > > > > > > > >  3 files changed, 40 insertions(+), 1 deletion(-)
> > > > > > > >
> > > > > > > > Could we have this in Stable please?
> > > > > > > >
> > > > > > > > Upstream commit: ff7a167961d1b ("arm64: efi: Execute runtime services from a dedicated stack")
> > > > > > > >
> > > > > > > > Ard, do we need Patch 2 as well, or can this be applied on its own?
> > > > > > > >
> > > > > > >
> > > > > > > Thanks for the reminder.
> > > > > > >
> > > > > > > Only patch #1 is needed. It should be applied to v5.10 and later.
> > > > > >
> > > > > > Hold on, why did this go into mainline when I had an outstanding comment w.r.t.
> > > > > > the stack unwinder?
> > > > > >
> > > > > > From your last reply to me there I was expecting a respin with that fixed.
> > > > > >
> > > > >
> > > > > Apologies for the confusion.
> > > > >
> > > > > I have a patch for this queued up, but AIUI, that cannot be merged all
> > > > > the way back to v5.10, so these need to remain separate changes in any
> > > > > case.
> > > > >
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=c2530a04a73e6b75ed71ed14d09d7b42d6300013
> > > >
> > > > Ah, ok, thanks for the pointer!
> > > >
> > > > I'm a little uneasy here, still.
> > > >
> > > > By backporting this we're also backporting the new breakage of the stack
> > > > unwinder, and the minimal change for backports would be to add the lock and not
> > > > the new stack (which was added for additinoal robustness, not to fix the bug
> > > > the lock fixes).
> > > >
> > > > I do appreciate that the additional stack is likely more useful than the
> > > > occasional diagnostic output from the kernel, but it does seem like this has
> > > > traded off one bug for another, and I'm just a little annoyed because I pointed
> > > > that out before the first pull request was made.
> > > >
> > > > I do know that this isn't malicious, and I'm not trying to start a fight, but
> > > > now we have to consider whether we want/need to backport a stack unwinder fix
> > > > to account for this, and we hadn't had that discussion before.
> > > >
> > > 
> > > In that case, let's drop these backports for the time being, and
> > > collaborate on a solution that works for all of us.
> > > 
> > > Greg, could you please drop these again? Thanks.
> > 
> > Dropped now from all queues, thanks.
> 
> Now in Mainline as:
> 
>   18bba1843fc7f efi: rt-wrapper: Add missing include
>   ff7a167961d1b arm64: efi: Execute runtime services from a dedicated stack
> 
> Would you be kind enough to re-collect them please?

Now queued up for 5.10.y and newer.

greg k-h
