Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB214A64CE
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 20:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239230AbiBATSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 14:18:35 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55528 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242332AbiBATSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 14:18:34 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E747A1C0B87; Tue,  1 Feb 2022 20:18:32 +0100 (CET)
Date:   Tue, 1 Feb 2022 20:18:32 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Chao Yu <chao@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 4.19 026/239] f2fs: fix to do sanity check in is_alive()
Message-ID: <20220201191832.GA31656@duo.ucw.cz>
References: <20220124183943.102762895@linuxfoundation.org>
 <20220124183943.957395248@linuxfoundation.org>
 <20220124203637.GA19321@duo.ucw.cz>
 <3c56cf70-2557-2e9c-4694-588ddaa91220@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <3c56cf70-2557-2e9c-4694-588ddaa91220@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Oops, you're right, my bad.
>=20
> >=20
> > > +++ b/fs/f2fs/gc.c
> > > @@ -589,6 +589,9 @@ static bool is_alive(struct f2fs_sb_info
> > >   		set_sbi_flag(sbi, SBI_NEED_FSCK);
> > >   	}
> > > +	if (f2fs_check_nid_range(sbi, dni->ino))
> > > +		return false;
> > > +
> > >   	*nofs =3D ofs_of_node(node_page);
> > >   	source_blkaddr =3D datablock_addr(NULL, node_page, ofs_in_node);
> > >   	f2fs_put_page(node_page, 1);
> >=20
> > AFAICT f2fs_put_page() needs to be done in the error path, too.
> >=20
> > (Problem seems to exist in mainline, too).
> >=20
> > Something like this?
>=20
> Could you please send a formal patch to f2fs mailing list for better revi=
ew?
>=20
> Anyway, thanks a lot for the report and the patch!

I'm quite busy with other reviews at the moment. If you could submit a
patch, it would be great, otherwise I'll get to it .. sometime.

Best regards,
									Pavel
								=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYfmHiAAKCRAw5/Bqldv6
8gqBAKCzx9+iaqnam0vtEa5jjogELrBkrACfTwbdMHwN/ug6LYXW4jTOVvhcWbo=
=a5iK
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
