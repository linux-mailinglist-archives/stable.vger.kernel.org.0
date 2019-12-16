Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC74121C69
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 23:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfLPWHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 17:07:35 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52073 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfLPWHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 17:07:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id d73so946572wmd.1
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 14:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Il+myLvb6tAwYo2oCOH77gfHzJyW/U20C/+OblRhMLI=;
        b=tkJS9+S4ZkKYGRYr5Z6GY8Qn7M5bq1FWudxj8fSohMHUQ+992z9L/Ee4gqMrsmHBJU
         pVrK6VXBDUcOvKewurZO/ag9Au6htk8xnQ7+gseDag//S8WslOmERVZz7mP93l+WF7GO
         Jl4AlqnnixlCzurj671AJoP2Kdh676j4E6yysB0TKRXbkgr89eeTmPleIIuQkaj0xA5O
         SHUFAsPjiRKzjfAAagNQWBPaxVMiJA54iQgXJO9OlKDZYy12r+FvEH5fAsopELqzy82p
         FNZQcGg44/YbrWFJHbsL2CFtTf/qzl3WM60vWdUaq1GZ6UjWBw9Mt6hGaUBnWlaQQQGE
         AmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=Il+myLvb6tAwYo2oCOH77gfHzJyW/U20C/+OblRhMLI=;
        b=MgusiXq3mmS+ydobRTRqqdXZmuC5p6pte38hqHjI/AJEm/E1R4u/Rhy1s1usYm9Kiz
         VpciWzTI6k7cwNA4QRTXOr35KAupaRymalbA2nSjeP5XuuR0RaV7kSRQvW6hczqzJe4c
         5xUhWkfEJUR5bs3JMSry60Qrb2rgRFzgKzoUzczBqZGQ2xdndEoWlxxPNphZ2ugU6MJM
         5JjgBXpJpvV/JXCiW46+xNu4D3xxiJU4Sq7NP3mkZUqqhLLbZQ2nLndiapgqR8eP5j3+
         +yzcRObxGGakUJw+mT89IVhf4owI+oqtWcq/cyzFjJm+jZx6jcox2d8eocvn7LvESoUJ
         ZRyQ==
X-Gm-Message-State: APjAAAWyzvWY6v3yLRl6xbzEMPsw96azSK+d9xet5Cxbl+VqZ0BHZDOA
        bDnDqyBOa7wLpl8eFIg8LzHTsZSC
X-Google-Smtp-Source: APXvYqxSBqZ2ZZn4Zr6ezc5dd5jojUWvwTaM4ouv24hMSp3UQq3gRtcXRbh9LbDrmvWff4+85Vfehg==
X-Received: by 2002:a1c:a9c6:: with SMTP id s189mr1303536wme.151.1576534052021;
        Mon, 16 Dec 2019 14:07:32 -0800 (PST)
Received: from [192.168.43.152] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id i8sm23167949wro.47.2019.12.16.14.07.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 14:07:31 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, gregkh@linuxfoundation.org,
        carter.li@eoitek.com
Cc:     stable@vger.kernel.org
References: <15764077414946@kroah.com>
 <6f68d1db-127c-522e-dd83-8a0d6c2529fd@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: FAILED: patch "[PATCH] io_uring: allow unbreakable links" failed
 to apply to 5.4-stable tree
Message-ID: <0f17474e-a0db-1d23-f0d0-38a199cc7e1f@gmail.com>
Date:   Tue, 17 Dec 2019 01:07:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6f68d1db-127c-522e-dd83-8a0d6c2529fd@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IE8wQcQX1AXrP295CQnYJdnSOB2m5Y0Rm"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IE8wQcQX1AXrP295CQnYJdnSOB2m5Y0Rm
Content-Type: multipart/mixed; boundary="71Uk65ZFt72VpX96Vdmd0Oir6YeJM0A7F";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, gregkh@linuxfoundation.org,
 carter.li@eoitek.com
Cc: stable@vger.kernel.org
Message-ID: <0f17474e-a0db-1d23-f0d0-38a199cc7e1f@gmail.com>
Subject: Re: FAILED: patch "[PATCH] io_uring: allow unbreakable links" failed
 to apply to 5.4-stable tree
References: <15764077414946@kroah.com>
 <6f68d1db-127c-522e-dd83-8a0d6c2529fd@kernel.dk>
In-Reply-To: <6f68d1db-127c-522e-dd83-8a0d6c2529fd@kernel.dk>

--71Uk65ZFt72VpX96Vdmd0Oir6YeJM0A7F
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 16/12/2019 01:13, Jens Axboe wrote:
> On 12/15/19 4:02 AM, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.4-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commi=
t
>> id to <stable@vger.kernel.org>.
>=20
> Might just be better to drop this from the 5.4 pile, unless Pavel
> is motivated to backport it. Even if it throws a lot of rejects, most
> of the hunks are trivial. Only one that requires a bit of thinking is
> the one that deals with link issue.
>=20
I can, but do we want to backport new features? It may add new bugs, that=

completely betrays the idea. Anyway, let me know if it has to be done.

--=20
Pavel Begunkov


--71Uk65ZFt72VpX96Vdmd0Oir6YeJM0A7F--

--IE8wQcQX1AXrP295CQnYJdnSOB2m5Y0Rm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl34AAwACgkQWt5b1Glr
+6U5RQ//RuTwzXuXkMWNz5XEJ65W4JUd9cvZNQtxtL6OUO17igRGk/CI0Kb/0MwL
wQQ4PJqnbamXuMDeTynO9Ghtb9v9c1u229UQ3w5V713s/asAs7z63WfDrC5e7POX
+dwXUSmoOAP0T9fQ8dl1ayy4o5i3AlvEb7KcvyHNpUeflDIIkDsWddQAzDLEgrtX
kMnD2bjIt8LF/uVEnunHcXgvd/NdPOius5mQTVg9ZglMjf5NmWM93WnSTIec1E3z
z5HHCWm0Ib84zRpkCQyNOuCPdSJ46p3E8gCtxR5/iuyMNNfvK9Sd2Yub84z2MEfd
x1GaceF9ELVjZhsdpImx7BxBl1pBLMYesafdlDf/JxI2/RQ+HOFYuVSrCMQFf/fs
DtuL2Qnu78DFJUgsvriKq/x9o6BoDqJpliwx3nLgVd05y76bh8LdMG58HVixMW7B
GWIWRfpCON5SnjMX3Px3qhYkIwihCdvtZx6gVBAdC3oJ1DLzEXPa82KmyeAty8Lz
aITe/c0p+9yxlPYNGnJoqHw8NCtlv9ynSstH131H2gJ3mAA/liccN531WqKE2atB
/5ETWD+3m5TKFIQiDAFK3qBZqPL1OOrlFoC3CtJrrHWdkMk0PVaDWBOWosNZy8Zh
tcUjjElBvjKDEBP+QdRBeOmAmBxVRw3naZS4T3IpZj9kEsEK6KM=
=l2I1
-----END PGP SIGNATURE-----

--IE8wQcQX1AXrP295CQnYJdnSOB2m5Y0Rm--
