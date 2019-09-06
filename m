Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECEFAB9CD
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388926AbfIFNwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:52:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39300 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732267AbfIFNwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 09:52:04 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 89A0081F91; Fri,  6 Sep 2019 15:51:47 +0200 (CEST)
Date:   Fri, 6 Sep 2019 15:52:00 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Adrian Vladu <avladu@cloudbasesolutions.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Alessandro Pilotti <apilotti@cloudbasesolutions.com>
Subject: Re: [PATCH 4.19 24/93] tools: hv: fixed Python pep8/flake8 warnings
 for lsvmbus
Message-ID: <20190906135200.GA28960@amd>
References: <20190904175302.845828956@linuxfoundation.org>
 <20190904175305.424737415@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20190904175305.424737415@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Fixed pep8/flake8 python style code for lsvmbus tool.
>=20
> The TAB indentation was on purpose ignored (pep8 rule W191) to make
> sure the code is complying with the Linux code guideline.
> The following command doe not show any warnings now:
> pep8 --ignore=3DW191 lsvmbus
> flake8 --ignore=3DW191 lsvmbus

Well, this cleans up indentation. I'd call it cleanup, not a bugfix,
and really not a fix for serious bug.

Plus, it is quite big.

Best regards,
									Pavel

> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: Alessandro Pilotti <apilotti@cloudbasesolutions.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/hv/lsvmbus | 75 +++++++++++++++++++++++++++---------------------
>  1 file changed, 42 insertions(+), 33 deletions(-)
>=20
> diff --git a/tools/hv/lsvmbus b/tools/hv/lsvmbus
> index 55e7374bade0d..099f2c44dbed2 100644
> --- a/tools/hv/lsvmbus
> +++ b/tools/hv/lsvmbus
> @@ -4,10 +4,10 @@
>  import os
>  from optparse import OptionParser
> =20
> +help_msg =3D "print verbose messages. Try -vv, -vvv for  more verbose me=
ssages"
>  parser =3D OptionParser()
> -parser.add_option("-v", "--verbose", dest=3D"verbose",
> -		   help=3D"print verbose messages. Try -vv, -vvv for \
> -			more verbose messages", action=3D"count")
> +parser.add_option(
> +	"-v", "--verbose", dest=3D"verbose", help=3Dhelp_msg, action=3D"count")
> =20
>  (options, args) =3D parser.parse_args()
> =20
> @@ -21,27 +21,28 @@ if not os.path.isdir(vmbus_sys_path):
>  	exit(-1)
> =20
>  vmbus_dev_dict =3D {
> -	'{0e0b6031-5213-4934-818b-38d90ced39db}' : '[Operating system shutdown]=
',
> -	'{9527e630-d0ae-497b-adce-e80ab0175caf}' : '[Time Synchronization]',
> -	'{57164f39-9115-4e78-ab55-382f3bd5422d}' : '[Heartbeat]',
> -	'{a9a0f4e7-5a45-4d96-b827-8a841e8c03e6}' : '[Data Exchange]',
> -	'{35fa2e29-ea23-4236-96ae-3a6ebacba440}' : '[Backup (volume checkpoint)=
]',
> -	'{34d14be3-dee4-41c8-9ae7-6b174977c192}' : '[Guest services]',
> -	'{525074dc-8985-46e2-8057-a307dc18a502}' : '[Dynamic Memory]',
> -	'{cfa8b69e-5b4a-4cc0-b98b-8ba1a1f3f95a}' : 'Synthetic mouse',
> -	'{f912ad6d-2b17-48ea-bd65-f927a61c7684}' : 'Synthetic keyboard',
> -	'{da0a7802-e377-4aac-8e77-0558eb1073f8}' : 'Synthetic framebuffer adapt=
er',
> -	'{f8615163-df3e-46c5-913f-f2d2f965ed0e}' : 'Synthetic network adapter',
> -	'{32412632-86cb-44a2-9b5c-50d1417354f5}' : 'Synthetic IDE Controller',
> -	'{ba6163d9-04a1-4d29-b605-72e2ffb1dc7f}' : 'Synthetic SCSI Controller',
> -	'{2f9bcc4a-0069-4af3-b76b-6fd0be528cda}' : 'Synthetic fiber channel ada=
pter',
> -	'{8c2eaf3d-32a7-4b09-ab99-bd1f1c86b501}' : 'Synthetic RDMA adapter',
> -	'{44c4f61d-4444-4400-9d52-802e27ede19f}' : 'PCI Express pass-through',
> -	'{276aacf4-ac15-426c-98dd-7521ad3f01fe}' : '[Reserved system device]',
> -	'{f8e65716-3cb3-4a06-9a60-1889c5cccab5}' : '[Reserved system device]',
> -	'{3375baf4-9e15-4b30-b765-67acb10d607b}' : '[Reserved system device]',
> +	'{0e0b6031-5213-4934-818b-38d90ced39db}': '[Operating system shutdown]',
> +	'{9527e630-d0ae-497b-adce-e80ab0175caf}': '[Time Synchronization]',
> +	'{57164f39-9115-4e78-ab55-382f3bd5422d}': '[Heartbeat]',
> +	'{a9a0f4e7-5a45-4d96-b827-8a841e8c03e6}': '[Data Exchange]',
> +	'{35fa2e29-ea23-4236-96ae-3a6ebacba440}': '[Backup (volume checkpoint)]=
',
> +	'{34d14be3-dee4-41c8-9ae7-6b174977c192}': '[Guest services]',
> +	'{525074dc-8985-46e2-8057-a307dc18a502}': '[Dynamic Memory]',
> +	'{cfa8b69e-5b4a-4cc0-b98b-8ba1a1f3f95a}': 'Synthetic mouse',
> +	'{f912ad6d-2b17-48ea-bd65-f927a61c7684}': 'Synthetic keyboard',
> +	'{da0a7802-e377-4aac-8e77-0558eb1073f8}': 'Synthetic framebuffer adapte=
r',
> +	'{f8615163-df3e-46c5-913f-f2d2f965ed0e}': 'Synthetic network adapter',
> +	'{32412632-86cb-44a2-9b5c-50d1417354f5}': 'Synthetic IDE Controller',
> +	'{ba6163d9-04a1-4d29-b605-72e2ffb1dc7f}': 'Synthetic SCSI Controller',
> +	'{2f9bcc4a-0069-4af3-b76b-6fd0be528cda}': 'Synthetic fiber channel adap=
ter',
> +	'{8c2eaf3d-32a7-4b09-ab99-bd1f1c86b501}': 'Synthetic RDMA adapter',
> +	'{44c4f61d-4444-4400-9d52-802e27ede19f}': 'PCI Express pass-through',
> +	'{276aacf4-ac15-426c-98dd-7521ad3f01fe}': '[Reserved system device]',
> +	'{f8e65716-3cb3-4a06-9a60-1889c5cccab5}': '[Reserved system device]',
> +	'{3375baf4-9e15-4b30-b765-67acb10d607b}': '[Reserved system device]',
>  }
> =20
> +
>  def get_vmbus_dev_attr(dev_name, attr):
>  	try:
>  		f =3D open('%s/%s/%s' % (vmbus_sys_path, dev_name, attr), 'r')
> @@ -52,6 +53,7 @@ def get_vmbus_dev_attr(dev_name, attr):
> =20
>  	return lines
> =20
> +
>  class VMBus_Dev:
>  	pass
> =20
> @@ -66,12 +68,13 @@ for f in os.listdir(vmbus_sys_path):
> =20
>  	chn_vp_mapping =3D get_vmbus_dev_attr(f, 'channel_vp_mapping')
>  	chn_vp_mapping =3D [c.strip() for c in chn_vp_mapping]
> -	chn_vp_mapping =3D sorted(chn_vp_mapping,
> -		key =3D lambda c : int(c.split(':')[0]))
> +	chn_vp_mapping =3D sorted(
> +		chn_vp_mapping, key=3Dlambda c: int(c.split(':')[0]))
> =20
> -	chn_vp_mapping =3D ['\tRel_ID=3D%s, target_cpu=3D%s' %
> -				(c.split(':')[0], c.split(':')[1])
> -					for c in chn_vp_mapping]
> +	chn_vp_mapping =3D [
> +		'\tRel_ID=3D%s, target_cpu=3D%s' %
> +		(c.split(':')[0], c.split(':')[1]) for c in chn_vp_mapping
> +	]
>  	d =3D VMBus_Dev()
>  	d.sysfs_path =3D '%s/%s' % (vmbus_sys_path, f)
>  	d.vmbus_id =3D vmbus_id
> @@ -85,7 +88,7 @@ for f in os.listdir(vmbus_sys_path):
>  	vmbus_dev_list.append(d)
> =20
> =20
> -vmbus_dev_list  =3D sorted(vmbus_dev_list, key =3D lambda d : int(d.vmbu=
s_id))
> +vmbus_dev_list =3D sorted(vmbus_dev_list, key=3Dlambda d: int(d.vmbus_id=
))
> =20
>  format0 =3D '%2s: %s'
>  format1 =3D '%2s: Class_ID =3D %s - %s\n%s'
> @@ -95,9 +98,15 @@ for d in vmbus_dev_list:
>  	if verbose =3D=3D 0:
>  		print(('VMBUS ID ' + format0) % (d.vmbus_id, d.dev_desc))
>  	elif verbose =3D=3D 1:
> -		print (('VMBUS ID ' + format1) %	\
> -			(d.vmbus_id, d.class_id, d.dev_desc, d.chn_vp_mapping))
> +		print(
> +			('VMBUS ID ' + format1) %
> +			(d.vmbus_id, d.class_id, d.dev_desc, d.chn_vp_mapping)
> +		)
>  	else:
> -		print (('VMBUS ID ' + format2) % \
> -			(d.vmbus_id, d.class_id, d.dev_desc, \
> -			d.device_id, d.sysfs_path, d.chn_vp_mapping))
> +		print(
> +			('VMBUS ID ' + format2) %
> +			(
> +				d.vmbus_id, d.class_id, d.dev_desc,
> +				d.device_id, d.sysfs_path, d.chn_vp_mapping
> +			)
> +		)

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1yZIAACgkQMOfwapXb+vKRZgCgv7hOELh9L9IvJUxr7pww6Ul1
P/AAoLPZYvve9KhXSmAWVDRALx1kD7Wu
=RiG+
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
