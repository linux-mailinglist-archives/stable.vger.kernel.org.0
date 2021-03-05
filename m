Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9247832E265
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCEGlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:41:44 -0500
Received: from mout.gmx.net ([212.227.17.20]:37411 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhCEGlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 01:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614926486;
        bh=uvyntPQe0rM/QK0mx6XdzEiiS2cXUSE5h0HymC3l5Fw=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=lXBXMTQd2N6JWk/8U+26SelEnC1YGzbRuthAvi6cUJPQ2YqP9mQ4Z6jL5N50qU5Z7
         Zpj+qL7jgcSCvKCQRuGPAidGtL5gnwjv6KctIHbM9M3GjEZXzFMJ5obA63NuzSL5di
         XzE/Di39GusAg8MXX7Bcy7QshD/ga1cBqMv0tJt4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([185.146.51.102]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MGhuU-1lVpX20sp0-00DpA2; Fri, 05
 Mar 2021 07:41:26 +0100
Message-ID: <e9e640eafff2ba78c2f3df31f755f03776460743.camel@gmx.de>
Subject: Re: futex breakage in 4.9 stable branch
From:   Mike Galbraith <efault@gmx.de>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, lwn@lwn.net,
        jslaby@suse.cz
Date:   Fri, 05 Mar 2021 07:41:24 +0100
In-Reply-To: <87r1ku69j1.fsf@nanos.tec.linutronix.de>
References: <161408880177110@kroah.com>
         <66826ac72356b00814f51487dd1008298e52ed9b.camel@decadent.org.uk>
         <YDygp3WYafzcgt+s@kroah.com> <YD0kkNH+I4xyoTwy@decadent.org.uk>
         <5d9c74ad033e898111e5a1e931b266912487b595.camel@gmx.de>
         <87r1ku69j1.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:juaffjWbqJRWHG9vYtbsPPiDw0uEhDEXvyNmnnQOe6XcDxjXmEw
 Z47trwQuQ3eZ/6skFnuU0kUypJ0BgcjRhgLVJknuAotceFKXIrNn4B9hT7pfbfNT3gyELGa
 NxQqn4x30taVzgc8LWT5tLXvCueJ7Yyb0nu/bbcwqNwPo6JbOhdb83icwKtseu54lmEzoLZ
 +uMxmBxbtDMYpPaJoUGAA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:S4zss2J53+o=:Jcs2Pykp4qw6triwgepWYE
 Pzj5dpj+FWjtJ+0K++E5bHNcZqrmgLo+rmUyFW47YbUE96KgucSdepHbXsizf8WzJ2Z2DlVOy
 FTa/w2RhztxSiMVYfPM+i9fmJuSXZTPFYri3qIwe9yJX8GtLTt7hK+QI1xWwQIrUhSvCVLHR6
 JGBm2Ekz0jlpiFx6bhj0rtimnpzYJufxvHup3OSts5lqo5ThjlRt8es+iXT0Fvxa2wU6alST9
 WwCAKr5weAnfuDXfULPlS5Sp4PY1yC7j2Vd7OokufXIQ6upzEbbUuhWhWrL1WqGgEI+iut3cv
 saArZv7KKakFmVmjb29VQ4h/EGKwiyfaZF5zWArrdLSV2QMnS+PsQJIDihDW911mMrQzbPZ67
 PJdJgFTZT/umTSu8XuI68MknKLziD9z1hRLSydXva9k5ef/VW651VfRVaEHZQWyEF/uk03OkD
 vybSPNO8y7YouDnRlroKgjlKyOlp2YFsnvuvjOwQjDG0b8k6KENkmd9CWsG/N2mMa0WweSCtX
 wvHZQ1jJAmW2nQFa2AIGBR7tzOZsYrJGbinWJqRryq7j9orNUkGpYkvXMtYwZlMmwl9aUimgM
 UDBBZirUUgnBqmJ5mqihgluvIZLvH3SU9RAeJOXj79EGZNO7+uu/i9zosBP355oAzIui0engT
 yC7Udmh13baiFCQdzYM2BWPkVujCzOiNFMgT03tBayr90eDG/e9SIpe10QLniIRI8l4/DPhJd
 qlrd6JuTkmJf7BKOJ1zt9lSrha6enJDo5ohQprFRMqGKSx//qnNVaBapFurM2khtrSUReLNxk
 KC99wJ3yk2XVJ87c4kgUYScpXq1mz0cuVjingytNEe+CVJ4GehkqG4Iv/q08qnZJE9Uiv+Vy6
 LDPiQzavQE4+yTOEBGgQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-03-04 at 19:47 +0100, Thomas Gleixner wrote:
> On Thu, Mar 04 2021 at 10:12, Mike Galbraith wrote:
> > On Mon, 2021-03-01 at 18:29 +0100, Ben Hutchings wrote:
> >
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -874,8 +874,12 @@ static void free_pi_state(struct futex_p
> >  	 * and has cleaned up the pi_state already
> >  	 */
> >  	if (pi_state->owner) {
> > +		unsigned long flags;
> > +
> > +		raw_spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
> >  		pi_state_update_owner(pi_state, NULL);
> >  		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
> > +             raw_spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock=
, flags);
>
> This hunk is missing in 4.9 as well.
>
> >  	}
> >
> >  	if (current->pi_state_cache)
> > @@ -1406,7 +1410,7 @@ static int wake_futex_pi(u32 __user *uad
> >  	if (pi_state->owner !=3D current)
> >  		return -EINVAL;
> >
> > -	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
> > +	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
> >  	new_owner =3D rt_mutex_next_owner(&pi_state->pi_mutex);
> >
> >  	/*
>
> That looks correct.

Thanks for the eyeballs.  FWIW, updated 4.4.259-rt214 on top of that is
a happy camper as well.

	-Mike

