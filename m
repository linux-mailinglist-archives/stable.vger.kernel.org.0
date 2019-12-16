Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A64121EEA
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 00:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfLPXYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 18:24:30 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46393 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbfLPXYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 18:24:30 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so9253976wrl.13
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 15:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=dCuNDEuwYXHI6iUTnkZPyqasI67XDiAGXPkutofwkIY=;
        b=FJGdhqKA1t8o2nR+Mc4e7mUslbtAc36ahx0/AKiSR1hkipDNx3wJQsE+wl8JkZWuHr
         TNRfryzJkDppj9a6lXfwS+Duje02oY6bZg3O8SWbBFAKKGHLXaJT3i/bUdAVzE7S2Do8
         9mf1TpRcsnniH4LXG7p3+v5FXAGkaGB+SZ/LwufooCSRZmjfoNHBGGrgzTqP0OmMQHSv
         Rxm1E/45mrO2QhU6hcMC+pFrZKg04+ReUzvL0FCQ/B/tNw2YmUAiunrg0OJ9LFiI/2B7
         X3++zVPK3Xqn+6yXC6A8DlMgr2oyeZiCM0xtkZBqYm0e53IKX3X+PVgQRtuG6m9x3BpH
         qeIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=dCuNDEuwYXHI6iUTnkZPyqasI67XDiAGXPkutofwkIY=;
        b=Burg9O1i3fueHuUynARkqYxJx7I21Kot/ZpNcHeR8k3MXug+WxMDmok3wXPIYmBlmN
         3tgM1hhBedm0s1lIRcfmGDYEBujzUyHAHHZjtS/tvULVjRcK/ziD0vaYsUunIdISX+C+
         n3DolyNXP9VdV2QYBU7doFY7PqMO5CBi0oP/DJkGT5kfH2ytWqVZ1oiv1vSu1Q6jPJST
         uciWXE/ZusVghcXcZrkL1GDT2WJ8AGAyEZecSmYxRKfJBmR97p/+AFoXYA+dcU5SVlT5
         2dbFd8JOWAG58yyRHqVWFE2jGlVq6tHOU9ZLHSZ2oqXKMumlEpORx8Ruj4XnTO8aLZE3
         KAuQ==
X-Gm-Message-State: APjAAAV8MHA9OwAevF6F7GmLVsqj5+f4ircHIA1pBXzC1xj2EFCtcPIg
        zutRHqKIeG7l7dDb3yyYx2Z4TSkp
X-Google-Smtp-Source: APXvYqzr9nZd2LE0ky6Gb8UR/84DVNygpuMAk70Ji49/gvo14edzg7ASLYoSO8xa2KsPK474EwQoFg==
X-Received: by 2002:adf:f8c4:: with SMTP id f4mr32456120wrq.243.1576538667312;
        Mon, 16 Dec 2019 15:24:27 -0800 (PST)
Received: from [192.168.43.97] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id q6sm24617343wrx.72.2019.12.16.15.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 15:24:26 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] io_uring: allow unbreakable links" failed
 to apply to 5.4-stable tree
To:     Jens Axboe <axboe@kernel.dk>, gregkh@linuxfoundation.org,
        carter.li@eoitek.com
Cc:     stable@vger.kernel.org
References: <15764077414946@kroah.com>
 <6f68d1db-127c-522e-dd83-8a0d6c2529fd@kernel.dk>
 <0f17474e-a0db-1d23-f0d0-38a199cc7e1f@gmail.com>
 <30a14598-5aa1-c250-4450-3bcd2dded933@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <f0ddbc16-5229-32dc-6beb-633ad8d90084@gmail.com>
Date:   Tue, 17 Dec 2019 02:23:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <30a14598-5aa1-c250-4450-3bcd2dded933@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="d4SvQZejZwrbGtycOklDjKBX6HUtnO9Xi"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--d4SvQZejZwrbGtycOklDjKBX6HUtnO9Xi
Content-Type: multipart/mixed; boundary="bljQfmWfPleim4thvX47qDUus6fJT566T";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, gregkh@linuxfoundation.org,
 carter.li@eoitek.com
Cc: stable@vger.kernel.org
Message-ID: <f0ddbc16-5229-32dc-6beb-633ad8d90084@gmail.com>
Subject: Re: FAILED: patch "[PATCH] io_uring: allow unbreakable links" failed
 to apply to 5.4-stable tree
References: <15764077414946@kroah.com>
 <6f68d1db-127c-522e-dd83-8a0d6c2529fd@kernel.dk>
 <0f17474e-a0db-1d23-f0d0-38a199cc7e1f@gmail.com>
 <30a14598-5aa1-c250-4450-3bcd2dded933@kernel.dk>
In-Reply-To: <30a14598-5aa1-c250-4450-3bcd2dded933@kernel.dk>

--bljQfmWfPleim4thvX47qDUus6fJT566T
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 17/12/2019 01:11, Jens Axboe wrote:
> On 12/16/19 3:07 PM, Pavel Begunkov wrote:
>> On 16/12/2019 01:13, Jens Axboe wrote:
>>> On 12/15/19 4:02 AM, gregkh@linuxfoundation.org wrote:
>>>>
>>>> The patch below does not apply to the 5.4-stable tree.
>>>> If someone wants it applied there, or to any other stable or longter=
m
>>>> tree, then please email the backport, including the original git com=
mit
>>>> id to <stable@vger.kernel.org>.
>>>
>>> Might just be better to drop this from the 5.4 pile, unless Pavel
>>> is motivated to backport it. Even if it throws a lot of rejects, most=

>>> of the hunks are trivial. Only one that requires a bit of thinking is=

>>> the one that deals with link issue.
>>>
>> I can, but do we want to backport new features? It may add new bugs, t=
hat
>> completely betrays the idea. Anyway, let me know if it has to be done.=

>=20
> It's not about backporting a feature, it's about backporting the same
> behavior to 5.4. We don't have links in 5.3 and earlier, and would be
> nice to have the same in 5.4 and later. But it's not a huge deal for
> this one...
>=20

I see. I'll rebase it then

--=20
Pavel Begunkov


--bljQfmWfPleim4thvX47qDUus6fJT566T--

--d4SvQZejZwrbGtycOklDjKBX6HUtnO9Xi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl34EhMACgkQWt5b1Glr
+6X5XBAAss2bl1Vm3J1NjnWFbisvcNBKG/C8QYXi1TebkTvc0ofnIRnnRM6snJHC
ei8/08Fs0iIbEWVZfrqhxu9RSd2LEGj241G0a4ByC+HRyVNFislPvPa8GW5PEyiK
oTGoExaOU6FPwnJgW1onXM5tp0Xncnx0g+17ZjQjvKwU20yWo2QuWC0An6DBgGpv
ZXRmRXYdhrCBzVQqtHQhoFWnoPx2BGyROZeqPQdanyjEYo5WXZTsiZ0J1nAXl3Fb
UUDYahiRacoI6jJtrIb3inA/g0rRtuWQyOCV34JRbvJrzQEj3KnzwxYVHv/vwMtN
XldKz8hcyPCFSRPtSwMG/JUpYCi4nyM7ALAfjdRslaraiXmCXRf9jsMjVf3UDdl/
YMBY9FJu6xe3+nlO/M6vdbng/CJ0J8ioDV/QcTS4KlZo0jAfIAXcCOKYcL2T0MvB
3y+/ABlHufuby17bmVy+LESfaZlfV7gk5d/0knOHg7bJBa7iAvywMAGySgGBCZ0p
6itQRRh6e8NLAsI/nOulKcgbuqwpL1bUkHaB3/aH8ffa01ktYM3OnyhU+veYF62o
WJmic8D7T+j3SPUFFjbTLKVt7R38vCYwMn7EuTFvGHllxb7PTWSKibpOqdxSTq4k
EENQHcLhM+BctyMq+YvtSaoFj8rfgW1B8jrnWcbdZpB5nv2/HXo=
=yz9V
-----END PGP SIGNATURE-----

--d4SvQZejZwrbGtycOklDjKBX6HUtnO9Xi--
