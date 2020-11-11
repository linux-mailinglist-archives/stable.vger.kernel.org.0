Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831752AF3E7
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 15:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgKKOlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 09:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgKKOlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 09:41:36 -0500
X-Greylist: delayed 324 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 11 Nov 2020 06:41:36 PST
Received: from mx.mylinuxtime.de (mx.mylinuxtime.de [IPv6:2a01:4f8:13a:16c2::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD93AC0613D1
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 06:41:36 -0800 (PST)
Received: from leda (p200300cf2f10ac00625718fffe7f1598.dip0.t-ipconnect.de [IPv6:2003:cf:2f10:ac00:6257:18ff:fe7f:1598])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.mylinuxtime.de (Postfix) with ESMTPSA id B2CEC14D698;
        Wed, 11 Nov 2020 15:36:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eworm.de; s=mail;
        t=1605105368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BKxaBuc3J5CoFYWDsacAntre/4hucpszjqohrCjvMR0=;
        b=NkfX7BSOw9O5p/ROHBAA4i06H+Tud3ncmZNqZo0TnzwC7wFjnhqUNxlFOuYgJlzhEIoSSW
        vBA0TRYQb5YwN02I6hz3yPrCt8yHUMVKM7ECQ0QbZYyeLDpjQ/3xQcAznGuMqfxk5KlNCl
        GeWpf4HHwgOycb6n6mQ+3j4BX0T1O4g=
Date:   Wed, 11 Nov 2020 15:36:04 +0100
From:   Christian Hesse <list@eworm.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 5.9.8
Message-ID: <20201111153604.6a4fb08c@leda>
In-Reply-To: <1605041246232108@kroah.com>
References: <1605041246232108@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Face: %O:rCSk<c"<MpJ:yn<>HSKf7^4uF|FD$9$I0}g$nbnS1{DYPvs#:,~e`).mzj\$P9]V!WCveE/XdbL,L!{)6v%x4<jA|JaB-SKm74~Wa1m;|\QFlOg>\Bt!b#{;dS&h"7l=ow'^({02!2%XOugod|u*mYBVm-OS:VpZ"ZrRA4[Q&zye,^j;ftj!Hxx\1@;LM)Pz)|B%1#sfF;s;,N?*K*^)
Face:   iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAGFBMVEUZFRFENy6KVTKEd23CiGHeqofJvrX4+vdHgItOAAAACXBIWXMAAA3XAAAN1wFCKJt4AAACUklEQVQ4y2VUTZeqMAxNxXG2Io5uGd64L35unbF9ax0b3OLxgFs4PcLff0lBHeb1QIq5uelNCEJNq/TIFGyeC+iugH0WJr+B1MvzWASpuP4CYHOB0VfoDdddwA7OIFQIEHjXDiCtV5e9QX0WMu8AG0mB7g7WP4GqeqVdsi4vv/5kFBvaF/zD7zDquL4DxbrDGDyAsgNYOsJOYzth4Q9ZF6iLV+6TLAT1pi2kuvgAtZxSjoG8cL+8vIn251uoe1OOEWwbIPU04gHsmMsoxyyhYsD2FdIigF1yxaVbBuSOCAlCoX324I7wNMhrO1bhOLsRoA6DC6wQ5eQiSG5BiWQfM4gN+uItQTRDMaJUhVbGyKWCuaaUGSVFVKpl4PdoDn3yY8J+YxQxyhlHfoYOyPgyDcO+cSQK6Bvabjcy2nwRo3pxgA8jslnCuYw23ESOzHAPYwo4ITNQMaOO+RGPEGhSlPEZBh2jmBEjQ5cKbxmr0ruAe/WCriUxW76I8T3h7vqY5VR5wXLdERodg2rHEzdxxk5KpXTL4FwnarvndKM5/MWDY5CuBBdQ+3/0ivsUJHicuHd+Xh3jOdBL+FjSGq4SPCwco+orpWlERRTNo7BHCvbNXFVSIQMp+P5QsIL9upmr8kMTUOfxEHoanwzKRcNAe76WbjBwex/RkdHu48xT5YqP70DaMOhBcTHmAVDxLaBdle93oJy1QKFUh2GXT4am+YH/GGel1CeI98GdMXsytjCKIq/9cMrlgxFCROv+3/BU1fijNpcVD6DxE8VfLBaxUGr1D5usgDYdjwiPAAAAAElFTkSuQmCC
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+y0TKh8XEh5h5qBoGSonJA/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Authentication-Results: mx.mylinuxtime.de;
        auth=pass smtp.auth=mail@eworm.de smtp.mailfrom=list@eworm.de
X-Rspamd-Server: mx
X-Spam-Status: No, score=-6.52
X-Stat-Signature: ugmtes5xsa8aebysfngbkjchx6ki44ej
X-Rspamd-Queue-Id: B2CEC14D698
X-Spamd-Result: default: False [-6.52 / 15.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_HAM_LONG(-3.08)[-1.026];
         MIME_GOOD(-0.20)[multipart/signed,text/plain];
         DKIM_SIGNED(0.00)[];
         NEURAL_HAM_SHORT(-0.75)[-0.745];
         RCPT_COUNT_SEVEN(0.00)[7];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+,1:+,2:~];
         MID_RHS_NOT_FQDN(0.50)[];
         ASN(0.00)[asn:3320, ipnet:2003::/19, country:DE];
         BAYES_HAM(-3.00)[99.99%]
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/+y0TKh8XEh5h5qBoGSonJA/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Greg Kroah-Hartman <gregkh@linuxfoundation.org> on Tue, 2020/11/10 21:56:
> I'm announcing the release of the 5.9.8 kernel.

This is not yet linked on kernel.org - same goes for lts version 5.4.77.
I guess this is not by intention, no?
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH"
"CX:;",b;for(a/*    Best regards             my address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*    Chris            cc -ox -xc - && ./x    */b/42*2-3)*42);}

--Sig_/+y0TKh8XEh5h5qBoGSonJA/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXHmveYAHrRp+prOviUUh18yA9HYFAl+r9tQACgkQiUUh18yA
9HYZIAf+N33UNVl56xErSj7Gi9w60FbswyhwUB7KP+tP8PWFzkzGu7JjFn4pIGjp
7kfj59I5Ijhmtka8/x2R1XWu9S8mlppha3dzyQPG9ZtmISufvLMIBARC03Nwu5i/
we6XpmqeYOtDzhcrR7DX3xEY1gbuxWRnl28sQ3vFIsWuy+hbUG3mxrG9O4A0RnNG
4AnSk6pSq7SKOnWyvA5bOaNPQpChhrWOvowCncCOGShqD+WqAc3ZO5nCprTqRwNH
2lt4o/HEFcIUflj169NZo551tzz5FAa2EfT6QM41sffTzcNv+ttL4FAd8XZ7QY1g
81J+UUVf9i/w421Y72y0BIYHImgMGg==
=VxMw
-----END PGP SIGNATURE-----

--Sig_/+y0TKh8XEh5h5qBoGSonJA/--
