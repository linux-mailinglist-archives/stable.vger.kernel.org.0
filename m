Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1A6E5929
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 10:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfJZIB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 04:01:26 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:59145 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbfJZIBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Oct 2019 04:01:25 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 76241314D;
        Sat, 26 Oct 2019 04:01:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 26 Oct 2019 04:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=2
        9/bBfyGHh4fPY7SMXOWPjlR9THfnhOTupfJzSrSY64=; b=P13AVXalslaW7PsN0
        7WeGlWicPr7J3eQu1hxABvB4HVoDfzTyh345M98dG8LAT8qeQa/AJ3t86QR/a1lV
        kUuGAi5TswwYyRzWEdx4GjM7gL9jedQvb+V0HUADbT+VLjY76wXuFdkIO/kGqPVc
        V2chNHzeE7mlIKm1z9/bQD4+zBBuGep4n3wHRN5NE/CVr4TxAFkNESF5kjMhv8Dg
        5WoKwnij4zt8MiftBIMBL8pRSDcxGewQy6//B24KMYxAls+H6x3wwqn4P/cjZLoe
        R9QXjiKJk6D/keTz6d5F4YNqnUYtHt1dIeXE9RAMyj2NWTYMgxtAaROxoD2jHtPc
        eoiVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=29/bBfyGHh4fPY7SMXOWPjlR9THfnhOTupfJzSrSY
        64=; b=NK3Q5g5dJz3hM3La0EPTqwjrMUh/+OrRKBK788vknaabwB/zFxjqB2czl
        8cewhVcXRx6wuNTySQfnRTuKGuRl0Sebw2lZECnxSb3znqpp5kYdFnaauwmY5AZ0
        4ENNg7ua+N1wq/LV5of6InedRY8PEp10LjFu0u5ft1XC1/yzdkMRpgVPH8xbJloH
        M6X7rItB5XCAOv3HZF3QJCD0nFi3V0RxHPw4dsPcJDbtWEhykS4YTKCaxlKmxNRF
        ohhEH/zRjRkn5aipOVI4RyxKEY6LC9sJgw/NCWieX2hi1qYhgRdW5K8yXcscJSLl
        +n3/vBaCW+09O0/r4fVmAz7f87bMw==
X-ME-Sender: <xms:U_2zXaxslSNO9hjUBs2zCbcXvy1Imr8FfasEH5poE_roVkn7beINWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleeggdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeelrddvtdehrddufe
    efrdefkeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:U_2zXRBDiwb10Ze0f24C2yjRdpOgWybFkxE3cW-9XAMx_4DxQ9bb1A>
    <xmx:U_2zXVrYgCa-K_mfi-b-h84k2A2TKfJApNAnCEKy-nbpI13-OvGCWw>
    <xmx:U_2zXfRKkKCS7qp9zSeLYtoZaOioJZ61TDMAld9n-_xqCFgffYTSag>
    <xmx:VP2zXXJYONjEQZ8bxPki0ElK6tKDl3P7ukVkLawvp95bNKay_VMV3Q>
Received: from localhost (unknown [89.205.133.38])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11FFD80059;
        Sat, 26 Oct 2019 04:01:23 -0400 (EDT)
Date:   Sat, 26 Oct 2019 10:01:21 +0200
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH for-stable-4.14 42/48] arm64: Always enable spectre-v2
 vulnerability detection
Message-ID: <20191026080121.GB554748@kroah.com>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
 <20191024124833.4158-43-ard.biesheuvel@linaro.org>
 <b41df418-2e09-ac29-92cd-3910f0c05c50@arm.com>
 <CAKv+Gu8zW08_TKgvU4yHh=8E4_cnhx7iLoeOrYfmoy4m7ofwsA@mail.gmail.com>
 <20191025152534.GF31224@sasha-vm>
 <CAKv+Gu9_BtF2Zd9=9_wDukwKinmSMwes5R7Eu9jx315PQFk8dA@mail.gmail.com>
 <CAKv+Gu-2LXayWyP=3Eur_toGo4xqhENWeK6n+TCDcEy8xrKmXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKv+Gu-2LXayWyP=3Eur_toGo4xqhENWeK6n+TCDcEy8xrKmXQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 25, 2019 at 05:39:44PM +0200, Ard Biesheuvel wrote:
> On Fri, 25 Oct 2019 at 17:28, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > On Fri, 25 Oct 2019 at 17:25, Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > On Thu, Oct 24, 2019 at 04:37:12PM +0200, Ard Biesheuvel wrote:
> > > >On Thu, 24 Oct 2019 at 16:34, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > > >>
> > > >> Hi,
> > > >>
> > > >> On 10/24/19 1:48 PM, Ard Biesheuvel wrote:
> > > >> > From: Jeremy Linton <jeremy.linton@arm.com>
> > > >> >
> > > >> > [ Upstream commit 8c1e3d2bb44cbb998cb28ff9a18f105fee7f1eb3 ]
> > > >> >
> > > >> > Ensure we are always able to detect whether or not the CPU is affected
> > > >> > by Spectre-v2, so that we can later advertise this to userspace.
> > > >> >
> > > >> > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > > >> > Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> > > >> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > >> > Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
> > > >> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > > >> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > >> > ---
> > > >> >  arch/arm64/kernel/cpu_errata.c | 15 ++++++++-------
> > > >> >  1 file changed, 8 insertions(+), 7 deletions(-)
> > > >> >
> > > >> > diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> > > >> > index bf6d8aa9b45a..647c533cfd90 100644
> > > >> > --- a/arch/arm64/kernel/cpu_errata.c
> > > >> > +++ b/arch/arm64/kernel/cpu_errata.c
> > > >> > @@ -76,7 +76,6 @@ cpu_enable_trap_ctr_access(const struct arm64_cpu_capabilities *__unused)
> > > >> >       config_sctlr_el1(SCTLR_EL1_UCT, 0);
> > > >> >  }
> > > >> >
> > > >> > -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> > > >> >  #include <asm/mmu_context.h>
> > > >> >  #include <asm/cacheflush.h>
> > > >> >
> > > >> > @@ -217,11 +216,11 @@ static int detect_harden_bp_fw(void)
> > > >> >           ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
> > > >> >               cb = qcom_link_stack_sanitization;
> > > >> >
> > > >> > -     install_bp_hardening_cb(cb, smccc_start, smccc_end);
> > > >> > +     if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR))
> > > >> > +             install_bp_hardening_cb(cb, smccc_start, smccc_end);
> > > >> >
> > > >> >       return 1;
> > > >> >  }
> > > >> > -#endif       /* CONFIG_HARDEN_BRANCH_PREDICTOR */
> > > >> >
> > > >> >  DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
> > > >> >
> > > >> > @@ -457,7 +456,6 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
> > > >> >       .type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,                 \
> > > >> >       CAP_MIDR_RANGE_LIST(midr_list)
> > > >> >
> > > >> > -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> > > >> >  /*
> > > >> >   * List of CPUs that do not need any Spectre-v2 mitigation at all.
> > > >> >   */
> > > >> > @@ -489,6 +487,12 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
> > > >> >       if (!need_wa)
> > > >> >               return false;
> > > >> >
> > > >> > +     if (!IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR)) {
> > > >> > +             pr_warn_once("spectrev2 mitigation disabled by kernel configuration\n");
> > > >> > +             __hardenbp_enab = false;
> > > >>
> > > >> This breaks when building, because __hardenbp_enab is declared in the next patch:
> > > >>
> > > >> $ make -j32 defconfig && make -j32
> > > >>
> > > >> [..]
> > > >> arch/arm64/kernel/cpu_errata.c: In function ‘check_branch_predictor’:
> > > >> arch/arm64/kernel/cpu_errata.c:492:3: error: ‘__hardenbp_enab’ undeclared (first
> > > >> use in this function)
> > > >>    __hardenbp_enab = false;
> > > >>    ^~~~~~~~~~~~~~~
> > > >> arch/arm64/kernel/cpu_errata.c:492:3: note: each undeclared identifier is reported
> > > >> only once for each function it appears in
> > > >> make[1]: *** [scripts/Makefile.build:326: arch/arm64/kernel/cpu_errata.o] Error 1
> > > >> make[1]: *** Waiting for unfinished jobs....
> > > >>
> > > >
> > > >Indeed, but as discussed, this matches the state of both mainline and
> > > >v4.19, which carry these patches in the same [wrong] order as well.
> > > >
> > > >Greg should confirm, but as I understand it, it is preferred to be
> > > >bug-compatible with mainline rather than fixing problems when spotting
> > > >them while doing the backport.
> > >
> > > Is it just patch ordering? If so I'd rather fix it, there's no reason to
> > > carry this issue into the stable trees.
> > >
> > > We reserve "bug compatibility" for functional issues that are not yet
> > > fixed upstream, it doesn't seem to be the case here.
> > >
> >
> > The patches don't apply cleanly in the opposite order.
> 
> What we could do is squash the two patches together. That way, we
> avoid the breakage without having to modify the patches in order to be
> able to apply them.

No, don't do that.  Just take all of the needed commits.
