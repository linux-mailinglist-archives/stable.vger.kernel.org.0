Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D243C5D61
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 15:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhGLNjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 09:39:19 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47952 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhGLNjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 09:39:19 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 36E7B1FF97;
        Mon, 12 Jul 2021 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626096990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c121DcGcsc7I9RCEYhP5bdY8+eTj/ROF7fShMNIZZOw=;
        b=F2WicKGd4kvT5ApSt4QnaUweC5Js8lkeQMDvW3C9MCs7OjisOlCBBuZrEJ6Azqk3vt/s1+
        XafktJT8Ah+L/0LCUoDdPz9dVOxNeWh6G9gTvq9saRc8t7E4uc2B2fyRsMKyMe8NbNmIuH
        xgD0kvEC9Y7rRkZVDpIEBg5f8z5IkRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626096990;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c121DcGcsc7I9RCEYhP5bdY8+eTj/ROF7fShMNIZZOw=;
        b=pE+eCNXdqyTIy1eF6+2M6gTjuHCX3QxTelbDWgjSLplsSMG/VOBpbEtQhPWBP9X4WN75KD
        qPLrEAOKjyrfhUAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EA11613BAE;
        Mon, 12 Jul 2021 13:36:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /1chOF1F7GDragAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Mon, 12 Jul 2021 13:36:29 +0000
Subject: Re: [PATCH 01/12] drm/mgag200: Select clock in PLL update functions
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     daniel@ffwll.ch, airlied@redhat.com,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        emil.velikov@collabora.com, John.p.donnelly@oracle.com,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20210705124515.27253-1-tzimmermann@suse.de>
 <20210705124515.27253-2-tzimmermann@suse.de> <YOiaX7UJ9Ka5xTM2@ravnborg.org>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <31e6618d-9048-84c6-b933-79ce2de11e81@suse.de>
Date:   Mon, 12 Jul 2021 15:36:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOiaX7UJ9Ka5xTM2@ravnborg.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KF6OmBbEdqcvAb3vTfkgpEi58GLVWUPxR"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KF6OmBbEdqcvAb3vTfkgpEi58GLVWUPxR
Content-Type: multipart/mixed; boundary="H0WR0MKrgkiFmk1UZM3cZ6d0twLQ7IxnI";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: daniel@ffwll.ch, airlied@redhat.com, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, emil.velikov@collabora.com, John.p.donnelly@oracle.com,
 dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Message-ID: <31e6618d-9048-84c6-b933-79ce2de11e81@suse.de>
Subject: Re: [PATCH 01/12] drm/mgag200: Select clock in PLL update functions
References: <20210705124515.27253-1-tzimmermann@suse.de>
 <20210705124515.27253-2-tzimmermann@suse.de> <YOiaX7UJ9Ka5xTM2@ravnborg.org>
In-Reply-To: <YOiaX7UJ9Ka5xTM2@ravnborg.org>

--H0WR0MKrgkiFmk1UZM3cZ6d0twLQ7IxnI
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 09.07.21 um 20:50 schrieb Sam Ravnborg:
> Hi Thomas,
>=20
> On Mon, Jul 05, 2021 at 02:45:04PM +0200, Thomas Zimmermann wrote:
>> Put the clock-selection code into each of the PLL-update functions to
>> make them select the correct pixel clock.
>>
>> The pixel clock for video output was not actually set before programmi=
ng
>> the clock's values. It worked because the device had the correct clock=

>> pre-set.
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Fixes: db05f8d3dc87 ("drm/mgag200: Split MISC register update into PLL=
 selection, SYNC and I/O")
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Cc: Emil Velikov <emil.velikov@collabora.com>
>> Cc: Dave Airlie <airlied@redhat.com>
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: <stable@vger.kernel.org> # v5.9+
>> ---
>>   drivers/gpu/drm/mgag200/mgag200_mode.c | 47 ++++++++++++++++++++----=
--
>>   1 file changed, 37 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/=
mgag200/mgag200_mode.c
>> index 3b3059f471c2..482843ebb69f 100644
>> --- a/drivers/gpu/drm/mgag200/mgag200_mode.c
>> +++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
>> @@ -130,6 +130,7 @@ static int mgag200_g200_set_plls(struct mga_device=
 *mdev, long clock)
>>   	long ref_clk =3D mdev->model.g200.ref_clk;
>>   	long p_clk_min =3D mdev->model.g200.pclk_min;
>>   	long p_clk_max =3D  mdev->model.g200.pclk_max;
>> +	u8 misc;
>>  =20
>>   	if (clock > p_clk_max) {
>>   		drm_err(dev, "Pixel Clock %ld too high\n", clock);
>> @@ -174,6 +175,11 @@ static int mgag200_g200_set_plls(struct mga_devic=
e *mdev, long clock)
>>   	drm_dbg_kms(dev, "clock: %ld vco: %ld m: %d n: %d p: %d s: %d\n",
>>   		    clock, f_vco, m, n, p, s);
>>  =20
>> +	misc =3D RREG8(MGA_MISC_IN);
>> +	misc &=3D ~MGAREG_MISC_CLK_SEL_MASK;
>> +	misc |=3D MGAREG_MISC_CLK_SEL_MGA_MSK;
>> +	WREG8(MGA_MISC_OUT, misc);
>=20
> This chunk is repeated a number of times.
> Any good reason why this is not a small helper?

Good point. I'll make a helper from this.

Best regards
Thomas

>=20
> 	Sam
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--H0WR0MKrgkiFmk1UZM3cZ6d0twLQ7IxnI--

--KF6OmBbEdqcvAb3vTfkgpEi58GLVWUPxR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmDsRV0FAwAAAAAACgkQlh/E3EQov+D3
pg//WPPjCIdR6R8QaZZheflZVwPVLfIobUGa9f96S9SVzXJnpPdpgeOV9I8RjXZ6cVBa2PTVyC10
UppiAgq+6gjwCoPBjQqNIDtusNmTM8LlyICRfi+xQMreUqdFMME5WVJiuBQ25MVTvDs/j3hEjYTA
Qj4myqrIGV2/LryyZihn/f6Zl4y6gG1LY95lYQSWNknP4yIjmqfC0DqPqt9mjQ7NZTjuLqS9ecL6
q5r/8MgoXu2FD753ElMvnWZ7IAa6CSFEvC8G8NKm7vs6JH1QkPfRzxYIARxrM7dTO4Q0VmE8quVM
isZc+WvLZr5NrzhY7PMYuIaWIdwI0ZgcKTW4dp6YEzHAzb3nsa9kk0+CHufuBEBI5FoFyFOoZ1HR
De/UBwcSVWixlYFafF+mIX8ddKl35tuOLGovKtr/SnFIsasBt9pxIQjwJqoYdHpyX5+0bvXCjkDv
UN6G5/xxNp7GhGYFptePmS1fTSc6Lb4QircML0hSCDTeHehojtRI5xZwBuyPk3MqQkp+cqeubQ1o
X8jx0wBedlJeDW9BiE6oe2np2SNILjrL7aREBAyDbpj531OJuz+xGIjvTmsh48RdLemX3jkM4Azv
L8FfV/PZQ3ovPLkeD1Hh6lAWBlOmtDy5jm4abbIfjrZJkW0ajydPlxsq97Eu7ZtkurBadSRh4bET
jsA=
=vlp8
-----END PGP SIGNATURE-----

--KF6OmBbEdqcvAb3vTfkgpEi58GLVWUPxR--
