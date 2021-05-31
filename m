Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4753E39685F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 21:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhEaTcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 15:32:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230308AbhEaTcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 15:32:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 581F9611CA;
        Mon, 31 May 2021 19:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622489451;
        bh=+Xa/mUULT45XAb8V1mCc5ppcSk4L9xFWlVukaW6HlW0=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=ZaQ4jV5hLmg1V6iFbgsYzVW6DS4IUC576mGQ3j7A1PG0NMZyR1w6+BJDMkspnxDrN
         NyOg0BSquTxWzOGul7pgwMp4avAON01b2F2mw6iRE/sVZKmBvjltMnbN+DJ8JksbZI
         NNCUrkH58C0pHOSGu0iP7tByXPBuJmrwgJC6mRqRQObBlgyUqRugQav4qjAp8t7YUs
         4MAbcdsVHk0+CUgx5CphdPVJP2xiXOTWHWA9rolJz+zRZJEm0OH4EX61QVBwyo1Xpx
         yNW1OKg7GfFqAwz+lUmt0pq0JbARuwWaeEyZCWSAyJbDLGvfCV8FGxGdC10MVsgctd
         Rj8eXRRG9Zr6Q==
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailauth.nyi.internal (Postfix) with ESMTP id 6776127C0054;
        Mon, 31 May 2021 15:30:50 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute2.internal (MEProxy); Mon, 31 May 2021 15:30:50 -0400
X-ME-Sender: <xms:aTm1YH7M2GMheZ_9b12B8frP82yctRyxAO2YCIlDUgVuazxPFm9CTg>
    <xme:aTm1YM5hJluhL7EZl2Fy2Dw22n_ENufrhKvcG8XyzH44hJcmZOKyRgq52b9CwXm3s
    jaqr_BstR9fj16nKFE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdelfedgudegtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    nhguhicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenuc
    ggtffrrghtthgvrhhnpedvleehjeejvefhuddtgeegffdtjedtffegveethedvgfejieev
    ieeufeevuedvteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedu
    keehieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinh
    hugidrlhhuthhordhush
X-ME-Proxy: <xmx:aTm1YOcQfxASbiKxGNOndboPG0HJJ391ueck49aUwV1RjxXSSY7nKg>
    <xmx:aTm1YIIoIVsdd9YCTK9g2jkNQoaDFmcR524ZJI1_hJmzKxmnR9eugg>
    <xmx:aTm1YLLPnudnhIv_j4y1x7_xKf1FFoqbTfZQpvztHGGOBIl3aQwRzQ>
    <xmx:ajm1YCVh_c0PhwAVCrDIvvXImPBtDsvCyU8zwoLYJs-Pxav2G_EU8LxVdf4>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B8EF751C0060; Mon, 31 May 2021 15:30:48 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-519-g27a961944e-fm-20210531.001-g27a96194
Mime-Version: 1.0
Message-Id: <71af931b-4328-44b9-8b03-7c155ee8b2d2@www.fastmail.com>
In-Reply-To: <87fsy24tqt.ffs@nanos.tec.linutronix.de>
References: <cover.1622351443.git.luto@kernel.org>
 <b69df1e42d1235996682178013f61d4120b3b361.1622351443.git.luto@kernel.org>
 <871r9n5iit.ffs@nanos.tec.linutronix.de>
 <87fsy24tqt.ffs@nanos.tec.linutronix.de>
Date:   Mon, 31 May 2021 12:30:28 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Cc:     "Dave Hansen" <dave.hansen@intel.com>, stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Subject: =?UTF-8?Q?Re:_[RFC_v2_1/2]_x86/fpu:_Fix_state_corruption_in_=5F=5Ffpu=5F?=
 =?UTF-8?Q?=5Frestore=5Fsig()?=
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Mon, May 31, 2021, at 11:56 AM, Thomas Gleixner wrote:
> On Mon, May 31 2021 at 12:01, Thomas Gleixner wrote:
>=20
> > On Sat, May 29 2021 at 22:12, Andy Lutomirski wrote:
> >>  /*
> >> - * Clear the FPU state back to init state.
> >> - *
> >> - * Called by sys_execve(), by the signal handler code and by vario=
us
> >> - * error paths.
> >> + * Reset current's user FPU states to the init states.  The caller=
 promises
> >> + * that current's supervisor states (in memory or CPU regs as appr=
opriate)
> >> + * as well as the XSAVE header in memory are intact.
> >>   */
> >> -static void fpu__clear(struct fpu *fpu, bool user_only)
> >> +void fpu__clear_user_states(struct fpu *fpu)
> >>  {
> >>  	WARN_ON_FPU(fpu !=3D &current->thread.fpu);
> >> =20
> >>  	if (!static_cpu_has(X86_FEATURE_FPU)) {
> >
> > This can only be safely called if XSAVES is available. So this check=
 is
> > bogus as it actually should check for !XSAVES. And if at all it shou=
ld
> > be:
> >
> >    if (WARN_ON_ONCE(!XSAVES))
> >       ....
> >
> > This is exactly the stuff which causes subtle problems down the road=
.
> >
> > I have no idea why you are insisting on having this conditional at t=
he
> > call site. It's just an invitation for trouble because someone finds=

> > this function and calls it unconditionally. And he will miss the
> > 'promise' part in the comment as I did.
>=20
> And of course there is:
>=20
> __fpu__restore_sig()
>=20
> 	if (!buf) {
>                 fpu__clear_user_states(fpu);
>                 return 0;
>         }
>=20
> and
>=20
> handle_signal()
>=20
>    if (!failed)
>       fpu__clear_user_states(fpu);

This looks okay.

Really there are two callers of fpu__clear_all() that are special:

execve:  Just in case some part of the xstate buffer mode that=E2=80=99s=
 supposed to be invariant got corrupted or in case there is some side ch=
annel that can leak the INIT-but-not-zeroed contents of a state to user =
code, we should really wipe the memory completely across privilege bound=
aries.

__fpu__restore_sig: the utterly daft copy from user space needs special =
recovery.

Maybe the right solution is to rename it. Instead of fpu__clear_all(), h=
ow about fpu__wipe_and_reset()?

>=20
> which invoke that function unconditionally.
>=20
> Thanks,
>=20
>         tglx
>=20
