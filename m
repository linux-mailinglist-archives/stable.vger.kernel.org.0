Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0780C1358CC
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 13:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730751AbgAIMEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 07:04:53 -0500
Received: from mx.mylinuxtime.de ([195.201.174.144]:54520 "EHLO
        mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbgAIMEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 07:04:51 -0500
Received: from leda (unknown [87.190.244.126])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.mylinuxtime.de (Postfix) with ESMTPSA id D8FAC161CD;
        Thu,  9 Jan 2020 12:57:16 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mx.mylinuxtime.de D8FAC161CD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=eworm.de; s=mail;
        t=1578571037; bh=yDW5OXfsyfPA2O+R/QtY0RW4PXky6Q2CoezhkgVRdAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Mxrbs8CfKRJNzqcU/5JHpeHKuF9e3M9IKFY1zW0GX9fAsb+BFC1o/nLrT2GlHKe1H
         BIRfadgVIoqlYdhXx5mpQ0/ligSDI2MitUkXBLVDMKS4gmhbveg2ujvOH+7pqW7Mij
         1PR202lOkzfCkAGhRa1nhk4jG8QjnzMVXl8mLfQ4=
Date:   Thu, 9 Jan 2020 12:57:11 +0100
From:   Christian Hesse <list@eworm.de>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     StableKernel <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: What happend to 5.4.9??? Kernel.org showing 5.4.10!!
Message-ID: <20200109125711.26b31965@leda>
In-Reply-To: <20200109114330.GC19235@Gentoo>
References: <20200109114330.GC19235@Gentoo>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Face: %O:rCSk<c"<MpJ:yn<>HSKf7^4uF|FD$9$I0}g$nbnS1{DYPvs#:,~e`).mzj\$P9]V!WCveE/XdbL,L!{)6v%x4<jA|JaB-SKm74~Wa1m;|\QFlOg>\Bt!b#{;dS&h"7l=ow'^({02!2%XOugod|u*mYBVm-OS:VpZ"ZrRA4[Q&zye,^j;ftj!Hxx\1@;LM)Pz)|B%1#sfF;s;,N?*K*^)
Face:   iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAGFBMVEUZFRFENy6KVTKEd23CiGHeqofJvrX4+vdHgItOAAAACXBIWXMAAA3XAAAN1wFCKJt4AAACUklEQVQ4y2VUTZeqMAxNxXG2Io5uGd64L35unbF9ax0b3OLxgFs4PcLff0lBHeb1QIq5uelNCEJNq/TIFGyeC+iugH0WJr+B1MvzWASpuP4CYHOB0VfoDdddwA7OIFQIEHjXDiCtV5e9QX0WMu8AG0mB7g7WP4GqeqVdsi4vv/5kFBvaF/zD7zDquL4DxbrDGDyAsgNYOsJOYzth4Q9ZF6iLV+6TLAT1pi2kuvgAtZxSjoG8cL+8vIn251uoe1OOEWwbIPU04gHsmMsoxyyhYsD2FdIigF1yxaVbBuSOCAlCoX324I7wNMhrO1bhOLsRoA6DC6wQ5eQiSG5BiWQfM4gN+uItQTRDMaJUhVbGyKWCuaaUGSVFVKpl4PdoDn3yY8J+YxQxyhlHfoYOyPgyDcO+cSQK6Bvabjcy2nwRo3pxgA8jslnCuYw23ESOzHAPYwo4ITNQMaOO+RGPEGhSlPEZBh2jmBEjQ5cKbxmr0ruAe/WCriUxW76I8T3h7vqY5VR5wXLdERodg2rHEzdxxk5KpXTL4FwnarvndKM5/MWDY5CuBBdQ+3/0ivsUJHicuHd+Xh3jOdBL+FjSGq4SPCwco+orpWlERRTNo7BHCvbNXFVSIQMp+P5QsIL9upmr8kMTUOfxEHoanwzKRcNAe76WbjBwex/RkdHu48xT5YqP70DaMOhBcTHmAVDxLaBdle93oJy1QKFUh2GXT4am+YH/GGel1CeI98GdMXsytjCKIq/9cMrlgxFCROv+3/BU1fijNpcVD6DxE8VfLBaxUGr1D5usgDYdjwiPAAAAAElFTkSuQmCC
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2dGIV2c6u+ANjJGMtiP.9jX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Authentication-Results: mx.mylinuxtime.de;
        auth=pass smtp.auth=mail@eworm.de smtp.mailfrom=list@eworm.de
X-Rspamd-Server: mx
X-Spam-Status: No, score=-4.39
X-Stat-Signature: pdrbf1o7khm7y1zxqh34t1k518w8h68h
X-Rspamd-Queue-Id: D8FAC161CD
X-Spamd-Result: default: False [-4.39 / 15.00];
         ARC_NA(0.00)[];
         BAYES_SPAM(0.29)[69.85%];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[4];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         MIME_GOOD(-0.20)[multipart/signed,text/plain];
         TO_DN_SOME(0.00)[];
         NEURAL_HAM(-2.98)[-0.992,0];
         SUBJECT_ENDS_EXCLAIM(0.00)[];
         SIGNED_PGP(-2.00)[];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MID_RHS_NOT_FQDN(0.50)[];
         MIME_TRACE(0.00)[0:+,1:+,2:~];
         ASN(0.00)[asn:3320, ipnet:87.128.0.0/10, country:DE];
         SUBJECT_HAS_QUESTION(0.00)[]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/2dGIV2c6u+ANjJGMtiP.9jX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Bhaskar Chowdhury <unixbhaskar@gmail.com> on Thu, 2020/01/09 17:13:
> I am wondering, it might be lack of morning coffee for Greg  :)=20

Just see what's in git:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=3Dl=
inux-5.4.y

Version 5.4.9 suffered a crash on powerpc. Not sure if coffee could have
prevented. :-p
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH"
"CX:;",b;for(a/*    Best regards             my address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*    Chris            cc -ox -xc - && ./x    */b/42*2-3)*42);}

--Sig_/2dGIV2c6u+ANjJGMtiP.9jX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXHmveYAHrRp+prOviUUh18yA9HYFAl4XFRcACgkQiUUh18yA
9HaOzgf/UQ3ItscDbzDqpZ9TTHCJafCB+Qox6x8emjr5LO0GZV5Nv4z1qpTPh8U9
UkVr47YrP70SX6YlQT1Mnua8zuK9zkIyNnGVkC//4b8DDnPHexURSfk8rj1iijah
G3SCUi//Ar58Fs4nERF6VNfise0bOAehW9ZH6t1YGqUmjQDImDCy8+NSD82Kyb5U
Wdc+eYCaORMIBwnac3sn0grpP1F2XPb2T4DypTpn6m9VnJP6rfHT0TmbDjKEIyAg
9vbJG7hosEEGgi/7/wuMxwZ6dOPt9IZv3I2bbpPKmI00LRgy8Vfshke9bWhNRRam
fgZPOfVkxTSveDVlrx2Oj0wuRZL6ww==
=Mn31
-----END PGP SIGNATURE-----

--Sig_/2dGIV2c6u+ANjJGMtiP.9jX--
