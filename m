Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6AC65E997
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 12:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjAELN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 06:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjAELNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 06:13:24 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0984FDFB2;
        Thu,  5 Jan 2023 03:13:21 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7CAB65C0217;
        Thu,  5 Jan 2023 06:13:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 05 Jan 2023 06:13:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1672917200; x=1673003600; bh=MlE9dXjnxE
        uaB1SpiJoDafHMm0b0Dvnr1NzJJpalc+A=; b=DS6GAtox3oYuPPb0fM0VAZK5E+
        qMJhSUZgmOrcvzaTyO9Cvrr5NXgoTqhhm9wVDxDqJAvnOVvnsheqQnLK8M9awhE6
        qwC3FZJRwkZqMCIQLPr46CDdYlC15uqCjoOqOJcHKcdg3wQinYeHhDB5OLzmllD/
        RQ6bHIz7qDoMEH7wfPtM2NA+JfLEqq+1H0a3ns0Xq2RSz0nUmtDaWa2j+APKoIrz
        KAYFOaTXukAXOGbdi9TSGlbV/52gvTlVS6w40BxOZCiIQ3YSsM1NwWBYOjOkjciT
        wA5kUR9nxNob7WNyVy/JB6Bf8mLvJEor+AzX+4mAFtofote2XjHiPR60Bxkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1672917200; x=1673003600; bh=MlE9dXjnxEuaB1SpiJoDafHMm0b0
        Dvnr1NzJJpalc+A=; b=k1IqUz3mSg66Q2RSeyGw3slzqtXbeujKO96OFZbHxGdT
        dx4jvjMl0enM43DWZMBqABabmq4+H1/91HAHDDb/DEgs78z+5om6niRHhE4FAmOQ
        srakdaZKYJl6NfD6WlI8+EiamDd/acwt67Tpy+xbgUshOIF5CryPV+WeZUGWBfnW
        3aQ8q98pe5gkSzbSiV2GmbfMQ3XWsS6uUUCxsqd0JhfFP1x+nOicVVnehyE1MiBs
        xPCaO1wE3H2cnwtRU2O5XuSSphRL0mALnYlGXhI0S/KeLe+KhSj8DPjmWnDb7Qr6
        Uli/HSduaGlf8uU3VYEVnJkCh9aX+O3MkqbdCyVGSw==
X-ME-Sender: <xms:0LC2YzAzh0KAuS0oXRyh6IKvMr0lGCAlomzImqUajgF_XoDJAvmT5Q>
    <xme:0LC2Y5gHxOPEr0BAMFn70AXsgki19h6nJfv79JZW9q58mIUhk3cS25zh8l8q7ACYu
    0AXtp8gdQMqRQ>
X-ME-Received: <xmr:0LC2Y-kjyuBq28LrP_aWp5lDtKNGBX89yPsLkn-1k_gW674xzBfeWFV7IoHpL_d5_XI4N3OX3ch1sKrpNK2oNY3mR6Zt7CG1JVojTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrjeekgddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0LC2Y1wMBMCWM0g7TCejyh4_E2TNEMckO_t1T4PokK6d0nrY1xpobw>
    <xmx:0LC2Y4Sv583gAeBvmqEpu7GrvtYccgEhBOLqdC7rMXHxTTxK-xD1Ng>
    <xmx:0LC2Y4bv7JkeuagZSY2_meViFXWcNI-GFaeqmjwxo7C72TiaZ3JW2Q>
    <xmx:0LC2Y5LkRe3rMWCHNRS_W_QftJYvBnmcFcoHXiSrfrpDEIHiEthr7A>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Jan 2023 06:13:19 -0500 (EST)
Date:   Thu, 5 Jan 2023 12:13:16 +0100
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, Lee Jones <lee@kernel.org>,
        stable@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        catalin.marinas@arm.com, Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/2] arm64: efi: Execute runtime services from a
 dedicated stack
Message-ID: <Y7awzMZs51t2/34D@kroah.com>
References: <20221205201210.463781-1-ardb@kernel.org>
 <20221205201210.463781-2-ardb@kernel.org>
 <Y7VXg5MCRyAJFmus@google.com>
 <CAMj1kXEYDHuRmUPvdMVj1H1fLoOKcr+qG6NDpufxwJa57jsWdg@mail.gmail.com>
 <Y7WloqaytMnC8ZIC@FVFF77S0Q05N>
 <CAMj1kXEaX_3yFT_GFruXbQj9gfDShH4arPjTQBqokKAGusi_Fw@mail.gmail.com>
 <Y7WpsPDF+7fux8l3@FVFF77S0Q05N>
 <CAMj1kXGQW5Nj81rjDu_bGM6M3tWUaFwgBSxpCWbgJ+JBUPuJJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGQW5Nj81rjDu_bGM6M3tWUaFwgBSxpCWbgJ+JBUPuJJw@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 05:32:18PM +0100, Ard Biesheuvel wrote:
> On Wed, 4 Jan 2023 at 17:30, Mark Rutland <mark.rutland@arm.com> wrote:
> >
> > On Wed, Jan 04, 2023 at 05:15:34PM +0100, Ard Biesheuvel wrote:
> > > On Wed, 4 Jan 2023 at 17:13, Mark Rutland <mark.rutland@arm.com> wrote:
> > > >
> > > > On Wed, Jan 04, 2023 at 02:56:19PM +0100, Ard Biesheuvel wrote:
> > > > > On Wed, 4 Jan 2023 at 11:40, Lee Jones <lee@kernel.org> wrote:
> > > > > >
> > > > > > On Mon, 05 Dec 2022, Ard Biesheuvel wrote:
> > > > > >
> > > > > > > With the introduction of PRMT in the ACPI subsystem, the EFI rts
> > > > > > > workqueue is no longer the only caller of efi_call_virt_pointer() in the
> > > > > > > kernel. This means the EFI runtime services lock is no longer sufficient
> > > > > > > to manage concurrent calls into firmware, but also that firmware calls
> > > > > > > may occur that are not marshalled via the workqueue mechanism, but
> > > > > > > originate directly from the caller context.
> > > > > > >
> > > > > > > For added robustness, and to ensure that the runtime services have 8 KiB
> > > > > > > of stack space available as per the EFI spec, introduce a spinlock
> > > > > > > protected EFI runtime stack of 8 KiB, where the spinlock also ensures
> > > > > > > serialization between the EFI rts workqueue (which itself serializes EFI
> > > > > > > runtime calls) and other callers of efi_call_virt_pointer().
> > > > > > >
> > > > > > > While at it, use the stack pivot to avoid reloading the shadow call
> > > > > > > stack pointer from the ordinary stack, as doing so could produce a
> > > > > > > gadget to defeat it.
> > > > > > >
> > > > > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > > > > ---
> > > > > > >  arch/arm64/include/asm/efi.h       |  3 +++
> > > > > > >  arch/arm64/kernel/efi-rt-wrapper.S | 13 +++++++++-
> > > > > > >  arch/arm64/kernel/efi.c            | 25 ++++++++++++++++++++
> > > > > > >  3 files changed, 40 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > Could we have this in Stable please?
> > > > > >
> > > > > > Upstream commit: ff7a167961d1b ("arm64: efi: Execute runtime services from a dedicated stack")
> > > > > >
> > > > > > Ard, do we need Patch 2 as well, or can this be applied on its own?
> > > > > >
> > > > >
> > > > > Thanks for the reminder.
> > > > >
> > > > > Only patch #1 is needed. It should be applied to v5.10 and later.
> > > >
> > > > Hold on, why did this go into mainline when I had an outstanding comment w.r.t.
> > > > the stack unwinder?
> > > >
> > > > From your last reply to me there I was expecting a respin with that fixed.
> > > >
> > >
> > > Apologies for the confusion.
> > >
> > > I have a patch for this queued up, but AIUI, that cannot be merged all
> > > the way back to v5.10, so these need to remain separate changes in any
> > > case.
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=c2530a04a73e6b75ed71ed14d09d7b42d6300013
> >
> > Ah, ok, thanks for the pointer!
> >
> > I'm a little uneasy here, still.
> >
> > By backporting this we're also backporting the new breakage of the stack
> > unwinder, and the minimal change for backports would be to add the lock and not
> > the new stack (which was added for additinoal robustness, not to fix the bug
> > the lock fixes).
> >
> > I do appreciate that the additional stack is likely more useful than the
> > occasional diagnostic output from the kernel, but it does seem like this has
> > traded off one bug for another, and I'm just a little annoyed because I pointed
> > that out before the first pull request was made.
> >
> > I do know that this isn't malicious, and I'm not trying to start a fight, but
> > now we have to consider whether we want/need to backport a stack unwinder fix
> > to account for this, and we hadn't had that discussion before.
> >
> 
> In that case, let's drop these backports for the time being, and
> collaborate on a solution that works for all of us.
> 
> Greg, could you please drop these again? Thanks.

Dropped now from all queues, thanks.

greg k-h
