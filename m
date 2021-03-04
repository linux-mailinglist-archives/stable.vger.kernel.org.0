Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A4A32CF6E
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 10:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhCDJPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 04:15:16 -0500
Received: from mout.gmx.net ([212.227.15.18]:47865 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237660AbhCDJOo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 04:14:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614849177;
        bh=8xkDQhRbXDIKJkE9Bu6qvOnT1kfHnnGbUW0lasJbK3c=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=LKiK4UOcGmShqNWnqOzj4DGO3nTjVijTy3a9iBz1nKgaWJooD69Iq0hOagixMggA5
         9rwIuFZbtD47WPygBjJh3jCbJxtBIPuwzl6xztH588kNm50qHdzr3T21/DZj6JgOZ8
         Bp84cBMUd6hpRS+/iEY3U81BR5ZN3OPtPE1Ni+2c=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([185.191.219.128]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M8ygO-1lNo2p0cMg-0069ef; Thu, 04
 Mar 2021 10:12:57 +0100
Message-ID: <5d9c74ad033e898111e5a1e931b266912487b595.camel@gmx.de>
Subject: Re: futex breakage in 4.9 stable branch
From:   Mike Galbraith <efault@gmx.de>
To:     Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, lwn@lwn.net,
        jslaby@suse.cz, Thomas Gleixner <tglx@linutronix.de>
Date:   Thu, 04 Mar 2021 10:12:56 +0100
In-Reply-To: <YD0kkNH+I4xyoTwy@decadent.org.uk>
References: <161408880177110@kroah.com>
         <66826ac72356b00814f51487dd1008298e52ed9b.camel@decadent.org.uk>
         <YDygp3WYafzcgt+s@kroah.com> <YD0kkNH+I4xyoTwy@decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tHbckRnynUxA5tqlBOhhA8J+V8zcD7voddSk2nnY5g12A5gfcXR
 xB2kMnVWoC+V6O1v/QQEQumneEZad+s5XI52VP/x4N+qx/g56VA8wvZTSoVD6l6Pe0E9hzK
 I77CCtITR/f0TFO+yf6GvVYYf2OQJ2sBjdpXEgVt4gP7yZqozuDad+cS+h/IKDRvdeQNEfC
 kKXutpND0XaP7uyAjjxlw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:spPeGLxciHw=:gJdpKxnMrESlWJPgp6zWwC
 nPZznwT6nkxC97k4X20aqId1yPggsjzIvnvS4qKlKRAxFh23kh0PMELNPoP1Wq/dFS2+S5ldG
 96PUWBkih2/ds+03cLCB7WkPDTfvdZj2qlla79Njfzy9czmGGrcD3/u1gAb79GD70G4mqoh9/
 S+3NG7qsHYzP+YXHwa/qBGfIojibQMc8mmWOg2R5edbaUHpsdGQiulMFL75lt0KgVbV1zzyGR
 KUcmW7m6gsSyaIXQmUdNZoVOzmp19HnAf5Jt/Gk335Huj/H3aPOpFwt+CemW8/hNO/4XLzWWT
 0jGc1gs1IAg9SCrwjLY63g3iCkenqesZ24dHfYgKiozK44gQQHPuDThikHhmGESwWfH0ZBYkz
 TnTRg5Fff7Owc+W42mBsnjd+PJ22zrgjvbZwuEly8iFEXXNaLAbtiIzACvlaV02kfBoqJSXZL
 aiqMxTeDMDs3UQBeddl3jpq4MSplmwX2dxgm5WKrBbJ/I2gbcpNjj8sOI+9rSzcaUqR1rd139
 f/8C/DqE8vAVJcQ8T9afiyCGyNYg3La2pPk6AZBFOI1tB3qs3LyjOQ8tnmdJ2OYm5yF7wZiXw
 ReUa/HvyuX8s7Uwis4Anyb3Y6C802c/a6GQ6G/ZIk8GnPjDEutSIIAdkWXSXDhUnKO77DUXoZ
 6z8uxf0o0wMgzy5CHIqyoNXsOmhVtqvuQsWiBDW9W//CU+57CGnzpQEqdDHG3mPGNX3/Yb+1Y
 LCS5LQanjd4RI2+9egsmJTmNCPb/80wRsY6U1k4dbAOwO+q4SyL7GaerzFUh43B3Hr4i0Agh0
 mytJFykGdnDAwFaP5f/10vABy48fQzMmalQqyy7MJNbBI5yhy7TczNQCD7V5mUY1SVJgCh8jD
 VJ0lrNWo/tl9ZV1oJTTw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-03-01 at 18:29 +0100, Ben Hutchings wrote:
> On Mon, Mar 01, 2021 at 09:07:03AM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Mar 01, 2021 at 01:13:08AM +0100, Ben Hutchings wrote:
> > > On Tue, 2021-02-23 at 15:00 +0100, Greg Kroah-Hartman wrote:
> > > > I'm announcing the release of the 4.9.258 kernel.
> > > >
> > > > All users of the 4.9 kernel series must upgrade.
> > > >
> > > > The updated 4.9.y git tree can be found at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable.git linux-4.9.y
> > > > and can be browsed at the normal kernel.org git web browser:
> > > >
> > >
> > > The backported futex fixes are still incomplete/broken in this versi=
on.
> > > If I enable lockdep and run the futex self-tests (from 5.10):
> > >
> > > - on 4.9.246, they pass with no lockdep output
> > > - on 4.9.257 and 4.9.258, they pass but futex_requeue_pi trigers a
> > >   lockdep splat
> > >
> > > I have a local branch that essentially updates futex and rtmutex in
> > > 4.9-stable to match 4.14-stable.  With this, the tests pass and lock=
dep
> > > is happy.
> > >
> > > Unfortunately, that branch has about another 60 commits.
>
> I have now rebased that on top of 4.9.258, and there are "only" 39
> commits.
>
> > > Further, the
> > > more we change futex in 4.9, the more difficult it is going to be to
> > > update the 4.9-rt branch.  But I don't see any better option availab=
le
> > > at the moment.
> > >
> > > Thoughts?
> >
> > There were some posted futex fixes for 4.9 (and 4.4) on the stable lis=
t
> > that I have not gotten to yet.
> >
> > Hopefully after these are merged (this week), these issues will be
> > resolved.
>
> I'm afraid they are not sufficient.
>
> > If not, then yes, they need to be fixed and any help you can provide
> > would be appreciated.
> >
> > As for "difficulty", yes, it's rough, but the changes backported were
> > required, for obvious reasons :(
>
> I had another look at the locking bug and I was able to make a series
> of 7 commits (on top of the 2 already queued) that is sufficient to
> make lockdep happy.  But I am not very confident that there won't be
> other regressions.  I'll send that over shortly.

This is all I had to do to make 4.4-stable a happy camper again.

futex: fix 4.4-stable 34c8e1c2c025 backport inspired lockdep complaint

1. 34c8e1c2c025 "futex: Provide and use pi_state_update_owner()" was backp=
orted
to stable, leading to the therein assertion that pi_state->pi_mutex.wait_l=
ock
be held triggering in 4.4-stable.  Fixing that leads to lockdep moan part =
2.

2: b4abf91047cf "rtmutex: Make wait_lock irq safe" is absent in 4.4-stable=
, but
wake_futex_pi() nonetheless managed to acquire an unbalanced raw_spin_lock=
()
raw_spin_inlock_irq() pair, which inspires lockdep to moan after aforement=
ioned
assert has been appeased.

With this applied, futex tests pass, and no longer inspire lockdep gripeag=
e.

Not-Signed-off-by: Mike Galbraith <efault@gmx.de>
=2D--
 kernel/futex.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

=2D-- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -874,8 +874,12 @@ static void free_pi_state(struct futex_p
 	 * and has cleaned up the pi_state already
 	 */
 	if (pi_state->owner) {
+		unsigned long flags;
+
+		raw_spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
 		pi_state_update_owner(pi_state, NULL);
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
+		raw_spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);
 	}

 	if (current->pi_state_cache)
@@ -1406,7 +1410,7 @@ static int wake_futex_pi(u32 __user *uad
 	if (pi_state->owner !=3D current)
 		return -EINVAL;

-	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 	new_owner =3D rt_mutex_next_owner(&pi_state->pi_mutex);

 	/*

