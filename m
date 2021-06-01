Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5233979E0
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 20:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhFASQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 14:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231331AbhFASQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 14:16:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAF11610A1;
        Tue,  1 Jun 2021 18:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622571315;
        bh=eH51gUmCR87CUmVIzIHyz6hLOig7zvitBhRJKUphFhs=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=TSYyBdvohQCf6pxJEosZQDdtcW3N4LFRJ97NfxJkpzWLC7dWSpmOBrr0DO3/ujWdw
         vB+6mtTcITefbF38/rsckGCCXOb7tUn8OwprKXRpAgo6z3/0MqPYEEAxHcPOxet6Vx
         lXAUeMaMlGX3+rBp+RR7o1roYmrvemOc2V2r13TsZFI0lpE9BhY5Y3RG0zN1ZoyXez
         1wd6YceR4PTRsYZ2nf0YEoKJwzTrTMy4ko7ny0IeqL+6EnWbEp3SAArF7tcBvhv350
         QgNyZpOPMRAkQXssfd2SjjLM5IGK+JTPDjYW4Lfiab2rmzQlWBvFAHKxU8CqXxeNh0
         SWfaYSfUZ1FSQ==
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailauth.nyi.internal (Postfix) with ESMTP id B615C27C0054;
        Tue,  1 Jun 2021 14:15:13 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute2.internal (MEProxy); Tue, 01 Jun 2021 14:15:13 -0400
X-ME-Sender: <xms:MHm2YKSI46VZpNtDyIjbyGSkdBgWqQC44Kt3uvWNJFj4LkCY6hwqOA>
    <xme:MHm2YPyhyoV9P1A4IOupQc9K52222sHV1XHGvAXuBTsLndyFd0h4ZBHM3SoQp1MwI
    mn9FYRj7xeXt18nTEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdelhedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    nhguhicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenuc
    ggtffrrghtthgvrhhnpedvleehjeejvefhuddtgeegffdtjedtffegveethedvgfejieev
    ieeufeevuedvteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedu
    keehieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinh
    hugidrlhhuthhordhush
X-ME-Proxy: <xmx:MHm2YH24f9hrzsgBe7hqklgSjOBIsJUuKD3nP_YcbBurP8v35iiN_g>
    <xmx:MHm2YGBHQawZOv0bLvwS-e8VEvpcY9m-k32Hd7xhGS6WhpJp-wC6Zw>
    <xmx:MHm2YDhor0at4zzewE17zpaZy5kTfqWvbUGNYLbezWQabKzspExdsQ>
    <xmx:MXm2YGtEOqP18fOQD2zPL6-UKMe14kmX4Ag0L8WaAofy0q0RobWrLto7r30>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id CBA2051C0060; Tue,  1 Jun 2021 14:15:12 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-519-g27a961944e-fm-20210531.001-g27a96194
Mime-Version: 1.0
Message-Id: <f3448b39-ebd5-42a7-ac01-7fdf84bacbe9@www.fastmail.com>
In-Reply-To: <aef37213-8bf1-ff89-9b41-417dcdfbe713@intel.com>
References: <878s3u34iy.ffs@nanos.tec.linutronix.de>
 <603011b5-9479-3aac-78ee-74b9b5a5ef7c@kernel.org>
 <aef37213-8bf1-ff89-9b41-417dcdfbe713@intel.com>
Date:   Tue, 01 Jun 2021 11:14:49 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Dave Hansen" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Cc:     stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 3/5] x86/fpu: Clean up the fpu__clear() variants
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Tue, Jun 1, 2021, at 11:06 AM, Dave Hansen wrote:
> On to patch 3:
>=20
> > fpu__clear_all() and fpu__clear_user_states() share an implementatio=
n,
> > and the resulting code is almost unreadable.  Clean it up.
>=20
> Could we flesh this changelog out a bit?  I basically write these in t=
he
> process of understanding what the patch does, so this is less of "your=

> changelog needs help" and more of, "here's some more detail if you wan=
t it":
>=20
> fpu__clear() currently resets both register state and kernel XSAVE
> buffer state.  It has two modes: one for all state (supervisor and use=
r)
> and another for user state only.  fpu__clear_all() uses the "all state=
"
> (user_only=3D0) mode, while a number of signal paths use the user_only=
=3D1 mode.
>=20
> Make fpu__clear() work only for user state (user_only=3D1) and remove =
the
> "all state" (user_only=3D0) code.  Rename it to match so it can be use=
d by
> the signal paths.
>=20
> Replace the "all state" (user_only=3D0) fpu__clear() functionality.  U=
se
> the TIF_NEED_FPU_LOAD functionality instead of making any actual
> hardware registers changes in this path.

I=E2=80=99ll steal some of this.

>=20
> >  arch/x86/kernel/fpu/core.c | 63 +++++++++++++++++++++++++----------=
---
> >  1 file changed, 42 insertions(+), 21 deletions(-)
> >=20
> > diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c=

> > index 571220ac8bea..a01cbb6a08bb 100644
> > --- a/arch/x86/kernel/fpu/core.c
> > +++ b/arch/x86/kernel/fpu/core.c
> > @@ -354,45 +354,66 @@ static inline void copy_init_fpstate_to_fpregs=
(u64 features_mask)
> >  }
> > =20
> >  /*
> > - * Clear the FPU state back to init state.
> > - *
> > - * Called by sys_execve(), by the signal handler code and by variou=
s
> > - * error paths.
> > + * Reset current's user FPU states to the init states.  current's s=
upervisor
> > + * states, if any, are not modified by this function.  The XSTATE h=
eader
> > + * in memory is assumed to be intact when this is called.
> >   */
> > -static void fpu__clear(struct fpu *fpu, bool user_only)
> > +void fpu__clear_user_states(struct fpu *fpu)
> >  {
> >         WARN_ON_FPU(fpu !=3D &current->thread.fpu);
> > =20
> >         if (!static_cpu_has(X86_FEATURE_FPU)) {
> > -               fpu__drop(fpu);
> > -               fpu__initialize(fpu);
> > +               fpu__clear_all(fpu);
> >                 return;
> >         }
> > =20
> >         fpregs_lock();
> > =20
> > -       if (user_only) {
> > -               if (!fpregs_state_valid(fpu, smp_processor_id()) &&
> > -                   xfeatures_mask_supervisor())
> > -                       copy_kernel_to_xregs(&fpu->state.xsave,
> > -                                            xfeatures_mask_supervis=
or());
> > -               copy_init_fpstate_to_fpregs(xfeatures_mask_user());
> > -       } else {
> > -               copy_init_fpstate_to_fpregs(xfeatures_mask_all);
> > -       }
> > +       /*
> > +        * Ensure that current's supervisor states are loaded into
> > +        * their corresponding registers.
> > +        */
> > +       if (!fpregs_state_valid(fpu, smp_processor_id()) &&
> > +           xfeatures_mask_supervisor())
> > +               copy_kernel_to_xregs(&fpu->state.xsave,
> > +                                    xfeatures_mask_supervisor());
> > =20
> > +       /*
> > +        * Reset user states in registers.
> > +        */
> > +       copy_init_fpstate_to_fpregs(xfeatures_mask_user());
> > +
> > +       /*
> > +        * Now all FPU registers have their desired values.  Inform =
the
> > +        * FPU state machine that current's FPU registers are in the=

> > +        * hardware registers.
> > +        */
> >         fpregs_mark_activate();
> > +      =20
> >         fpregs_unlock();
> >  }
> > =20
> > -void fpu__clear_user_states(struct fpu *fpu)
> > -{
> > -       fpu__clear(fpu, true);
> > -}
> > +/*
> > + * Reset current's FPU registers (user and supervisor) to their INI=
T values.
> > + * This is used by execve(); out of an abundance of caution, it com=
pletely
> > + * wipes and resets the XSTATE buffer in memory.
> > + *
> > + * Note that XSAVE (unlike XSAVES) expects the XSTATE buffer in mem=
ory to
> > + * be valid, so there are certain forms of corruption of the XSTATE=
 buffer
> > + * in memory that would survive initializing the FPU registers and =
XSAVEing
> > + * them to memory.
> > + *
> > + * This does not change the actual hardware registers; when fpu__cl=
ear_all()
> > + * returns, TIF_NEED_FPU_LOAD will be set, and a subsequent exit to=
 user mode
> > + * will reload the hardware registers from memory.
> > + */
> >  void fpu__clear_all(struct fpu *fpu)
> >  {
> > -       fpu__clear(fpu, false);
> > +       fpregs_lock();
> > +       fpu__drop(fpu);
> > +       fpu__initialize(fpu);
> > +       fpregs_unlock();
> >  }
>=20
> Nit: Could we move the detailed comments about TIF_NEED_FPU_LOAD right=

> next to the fpu__initialize() call?  It would make it painfully obviou=
s
> which call is responsible.  The naming isn't super helpful here.
>=20

Hmm. I was actually thinking of open-coding it all.  fpu__initialize() a=
nd fpu__drop() have very few callers, and I=E2=80=99m not even convinced=
 that the other callers are calling them for a valid reason.
