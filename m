Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E21B5E8F49
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 20:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiIXSW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 14:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiIXSWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 14:22:35 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B84A83060;
        Sat, 24 Sep 2022 11:21:37 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8362A1C0003; Sat, 24 Sep 2022 20:21:24 +0200 (CEST)
Date:   Sat, 24 Sep 2022 20:21:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Joe Perches <joe@perches.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz, Jason Wang <wangborong@cdjrlc.com>
Subject: stable-kernel-rules need updating? Re: Linux 4.14.294
Message-ID: <20220924182124.GA19210@duo.ucw.cz>
References: <1663669061118192@kroah.com>
 <1663669061138255@kroah.com>
 <e9863ed5576cb93a6fd9b59cd19be9b71fda597d.camel@perches.com>
 <445878e0-d8c9-558f-73b7-8d39fa1a5cde@gmail.com>
 <YywGcg/Qgf8B8wEj@kroah.com>
 <e4852207ed36662a7c53e36fbbc31a71c5a3396e.camel@perches.com>
 <Yywdpyn814NkBJY8@kroah.com>
 <c4f2d581ef0cbb84c4ad3b244863fc4b7d48fd2f.camel@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <c4f2d581ef0cbb84c4ad3b244863fc4b7d48fd2f.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > > > > @@ -118,7 +118,7 @@ struct report_list {
> > > > > > >   * @multi_packet_cnt:	Count of fragmented packet count
> > > > > > >   *
> > > > > > >   * This structure is used to store completion flags and per =
client data like
> > > > > > > - * like report description, number of HID devices etc.
> > > > > > > + * report description, number of HID devices etc.
> > > > > > >   */
> > > > > > >  struct ishtp_cl_data {
> > > > > > >  	/* completion flags */
> > > > > >=20
> > > > > > Needless backporting of typo fixes reduces confidence in the
> > > > > > backport process.
> > > > > >=20
> > > > >=20
> > > > > The upstream commit 94553f8a218540 ("HID: ishtp-hid-clientHID: is=
htp-hid-client:
> > > > > Fix comment typo") didn't Cc: stable, but got AUTOSELed [1].
> > > > >=20
> > > > > I think we should only AUTOSEL patches that have explicit Cc: sta=
ble.
> > > >=20
> > > > That's not how AUTOSEL works or why it is there at all, sorry.
> > >=20
> > > Perhaps not, but why is AUTOSEL choosing this and why is
> > > this being applied without apparent human review?
> >=20
> > We always appreciate more review, and welcome it.  Sometimes things slip
> > by us as well, like it did for this one.  The changelog makes it look
> > like a real fix that is needed.
>=20
> What part of:
>=20
> --------------------------
> commit 94553f8a218540d676efbf3f7827ed493d1057cf
> Author: Jason Wang <wangborong@cdjrlc.com>
> Date:   Thu Aug 4 08:58:14 2022 +0800
>=20
>     HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo

>     The double `like' is duplicated in the comment, remove one.
>    =20
>     Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
>     Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> --------------------------
>=20
> makes it seem like a candidate for backporting?
>=20
> Perhaps the eagerness to backport is simply too high.

Eagerness to backport is too high, yes. In this case, I guess "Fix" is
what triggered AUTOSEL.

We (as in CIP project) review patches going to stable, and review some
at AUTOSEL phase.

OTOH ammount of "too trivial" patches in AUTOSEL and -stable is quite
high. I tried to report some, but it did not appear stable team is
willing to drop patches just because they are "too trivial".

[Plus there's worse stuff in stable, like known-broken patch being
applied then reverted, because that apparently makes it easier for
some scripts.]

To make problem worse, sometimes "too trivial" patch is prerequisite
for some other patch; but there's no marking making it easy to
identify such stuff.

Basically... stable-kernel-rules.rst "needs some updating", or some
explanation that people can not expect patches in -stable to follow
them.

# Rules on what kind of patches are accepted, and which ones are not, into =
the
# "-stable" tree:
#=20
#  - It must be obviously correct and tested.

Known-bad patches are applied and reverted.

#  - It cannot be bigger than 100 lines, with context.

Way bigger patches are often seen.

#  - It must fix only one thing.

If upstream patch fixes 3 things and does 5 cleanups, stable accepts that.

#  - It must fix a real bug that bothers people (not a, "This could be a
#    problem..." type thing).

Patches where changelog says bug is theoretical are often taken. Can
get examples if neccessary.

#  - It must fix a problem that causes a build error (but not for things
#    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
#    security issue, or some "oh, that's not good" issue.  In short, someth=
ing
#    critical.

All kind of bugs are fair game. For example, tweaks to remove noise printks=
=2E=20

#  - It cannot contain any "trivial" fixes in it (spelling changes,
#    whitespace cleanups, etc).

This is not enforced, nor it can be enforced easily.

#  - It or an equivalent fix must already exist in Linus' tree (upstream).

This is the only real rule for the -stable tree.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYy9KpAAKCRAw5/Bqldv6
8nOzAKDE4BJtKx/ZtriF48Ra0vWc3vnVXwCdE+OD7JbbBRAYPuBmz0dkpv4tOvM=
=LmP0
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
