Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6777F1DDA52
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 00:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgEUWhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 18:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730041AbgEUWhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 18:37:13 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6950BC061A0E;
        Thu, 21 May 2020 15:37:12 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p21so3986109pgm.13;
        Thu, 21 May 2020 15:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=TktCfpoBbx+hVhPvUuOvC8+LEOokXPFcjtfYJHpMmyQ=;
        b=clFpUR4QFpgUXPI/RwMWQMZnnrzHFpns0B8J52y64rbvUjWx2KnLfgk320LTgFxRNg
         ldqrwHujWTWGmaqxZqAcgx991c9BMXScbOIpCYsS0u3ZN0jya7pWeTzb0AmNT/Ry5YwV
         XsZU3ktbtbCUXNYU2SbIfK0bZT1kBzBZQgOf73/p0zH2XUoUYtbU+Gs/MGctNb3DIMBv
         QXpXO8hUBabWtfOA1FAA66Hw/i0mph1X21ggdUxXvVawgtQb13ds3M2wiH6DvicyTLUr
         R+mrztCwfPK3QWTped17xkijVCc3qqUwakcIMZsDaO3YFj9XOrVSXxmF/mWeikN+6iKT
         H86Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=TktCfpoBbx+hVhPvUuOvC8+LEOokXPFcjtfYJHpMmyQ=;
        b=m41Kac983DpW1Zl4wMGTUyS/SYR6tOWHWZI0FiJKnheoHP+U17FiqUC6fSGNlUlD36
         Qft34V4auLG6cxQjL1GRW4g0vhWFAzLwbP4WqnTb+HkTzr9Fs3I9betVUUJ2iNr4yu7k
         PO/QBgnwXibUd1KKL7+k2yXhwL4VIt9UwRrx8g+FceDVgRBUo8UMW6MWSXeAGY5pV0Uu
         ZqqQVvXrsIRusVO1LvVaXP7Tp/+MCr0NS5YNietDTSXBFjkFVQaPkCEVGdl7I4N8KnPw
         KQKWIh1zmYlUywyt52z7vH/uVSIc7fOxzVdPiOamvfMGhZJGtc/4Egm1yEHU8oUMmdeq
         OIXw==
X-Gm-Message-State: AOAM531372NCeCPfJnrwOFnDO5m4eo10aQE747pbZ09XCkQqSbL6mNh7
        0wP2WB2E8DU2vtzcIe5dbbNk7RbX
X-Google-Smtp-Source: ABdhPJznF0BLEkgcfpANehGvF7sOyENswfBQXCsJn7jwooLrcb712CJFFx85gVSfH6zV7ydll/uQkA==
X-Received: by 2002:a63:4b42:: with SMTP id k2mr10279390pgl.288.1590100631989;
        Thu, 21 May 2020 15:37:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a2sm5282183pfl.12.2020.05.21.15.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 15:37:11 -0700 (PDT)
Subject: Re: [PATCH 3.16 00/99] 3.16.84-rc1 review
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
References: <lsq.1589984008.673931885@decadent.org.uk>
 <68f801f8-ceb2-13cf-ad29-b6404e2f1142@roeck-us.net>
 <c01feeb17ecceeca18c852008bf0227079fbb38a.camel@decadent.org.uk>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAlVcphcFCRmg06EACgkQyx8mb86fmYFg0RAA
 nzXJzuPkLJaOmSIzPAqqnutACchT/meCOgMEpS5oLf6xn5ySZkl23OxuhpMZTVX+49c9pvBx
 hpvl5bCWFu5qC1jC2eWRYU+aZZE4sxMaAGeWenQJsiG9lP8wkfCJP3ockNu0ZXXAXwIbY1O1
 c+l11zQkZw89zNgWgKobKzrDMBFOYtAh0pAInZ9TSn7oA4Ctejouo5wUugmk8MrDtUVXmEA9
 7f9fgKYSwl/H7dfKKsS1bDOpyJlqhEAH94BHJdK/b1tzwJCFAXFhMlmlbYEk8kWjcxQgDWMu
 GAthQzSuAyhqyZwFcOlMCNbAcTSQawSo3B9yM9mHJne5RrAbVz4TWLnEaX8gA5xK3uCNCeyI
 sqYuzA4OzcMwnnTASvzsGZoYHTFP3DQwf2nzxD6yBGCfwNGIYfS0i8YN8XcBgEcDFMWpOQhT
 Pu3HeztMnF3HXrc0t7e5rDW9zCh3k2PA6D2NV4fews9KDFhLlTfCVzf0PS1dRVVWM+4jVl6l
 HRIAgWp+2/f8dx5vPc4Ycp4IsZN0l1h9uT7qm1KTwz+sSl1zOqKD/BpfGNZfLRRxrXthvvY8
 BltcuZ4+PGFTcRkMytUbMDFMF9Cjd2W9dXD35PEtvj8wnEyzIos8bbgtLrGTv/SYhmPpahJA
 l8hPhYvmAvpOmusUUyB30StsHIU2LLccUPPOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAlVcpi8FCRmg08MACgkQyx8mb86fmYHNRQ/+
 J0OZsBYP4leJvQF8lx9zif+v4ZY/6C9tTcUv/KNAE5leyrD4IKbnV4PnbrVhjq861it/zRQW
 cFpWQszZyWRwNPWUUz7ejmm9lAwPbr8xWT4qMSA43VKQ7ZCeTQJ4TC8kjqtcbw41SjkjrcTG
 wF52zFO4bOWyovVAPncvV9eGA/vtnd3xEZXQiSt91kBSqK28yjxAqK/c3G6i7IX2rg6pzgqh
 hiH3/1qM2M/LSuqAv0Rwrt/k+pZXE+B4Ud42hwmMr0TfhNxG+X7YKvjKC+SjPjqp0CaztQ0H
 nsDLSLElVROxCd9m8CAUuHplgmR3seYCOrT4jriMFBtKNPtj2EE4DNV4s7k0Zy+6iRQ8G8ng
 QjsSqYJx8iAR8JRB7Gm2rQOMv8lSRdjva++GT0VLXtHULdlzg8VjDnFZ3lfz5PWEOeIMk7Rj
 trjv82EZtrhLuLjHRCaG50OOm0hwPSk1J64R8O3HjSLdertmw7eyAYOo4RuWJguYMg5DRnBk
 WkRwrSuCn7UG+qVWZeKEsFKFOkynOs3pVbcbq1pxbhk3TRWCGRU5JolI4ohy/7JV1TVbjiDI
 HP/aVnm6NC8of26P40Pg8EdAhajZnHHjA7FrJXsy3cyIGqvg9os4rNkUWmrCfLLsZDHD8FnU
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <c170c353-9fe1-a849-d062-74e42f22661c@roeck-us.net>
Date:   Thu, 21 May 2020 15:37:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c01feeb17ecceeca18c852008bf0227079fbb38a.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GmOKe0I7Sad2AhT2MdbMs9szPM7R4ehsv"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GmOKe0I7Sad2AhT2MdbMs9szPM7R4ehsv
Content-Type: multipart/mixed; boundary="SfMyJKx4IM0AropXdq0yIzE68nTZZynQ7"

--SfMyJKx4IM0AropXdq0yIzE68nTZZynQ7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/21/20 1:20 PM, Ben Hutchings wrote:
> On Wed, 2020-05-20 at 14:23 -0700, Guenter Roeck wrote:
>> On 5/20/20 7:13 AM, Ben Hutchings wrote:
>>> This is the start of the stable review cycle for the 3.16.84 release.=

>>> There are 99 patches in this series, which will be posted as response=
s
>>> to this one.  If anyone has any issues with these being applied, plea=
se
>>> let me know.
>>>
>>> Responses should be made by Fri May 22 20:00:00 UTC 2020.
>>> Anything received after that time might be too late.
>>>
>> Build results:
>> 	total: 135 pass: 135 fail: 0
>> Qemu test results:
>> 	total: 230 pass: 227 fail: 3
>> Failed tests:
>> 	arm:cubieboard:multi_v7_defconfig:mem512:sun4i-a10-cubieboard:initrd
>> 	arm:cubieboard:multi_v7_defconfig:usb:mem512:sun4i-a10-cubieboard:roo=
tfs
>> 	arm:cubieboard:multi_v7_defconfig:sata:mem512:sun4i-a10-cubieboard:ro=
otfs
>>
>> The arm tests fail due to a compile error.
>>
>> drivers/clk/tegra/clk-tegra-periph.c:524:65: error: 'CLK_IS_CRITICAL' =
undeclared here (not in a function); did you mean 'CLK_IS_BASIC'?
>=20
> I already looked at your first test results and dropped the patch that
> uses CLK_IS_CRITICAL, so there's something else going wrong there...
>=20

Ah yes. Sorry, I didn't notice that there was a rebuild.

Images are fine; the three failing tests should not have been
tested in the first place (they never did, but I didn't update
the blacklist when I increased the qemu memory size to 512MB).

Guenter


--SfMyJKx4IM0AropXdq0yIzE68nTZZynQ7--

--GmOKe0I7Sad2AhT2MdbMs9szPM7R4ehsv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEiHPvMQj9QTOCiqgVyx8mb86fmYEFAl7HApUACgkQyx8mb86f
mYGQ1g//WufCdPUeddeTyQe87fYE6zp5K2GeKQ+MG9sjVbdMqRomasBthntNEtVE
aFll9DjGFUpUd+x875yF3MH8YSXCReIIqh1dkZ+7fjPy4xBgYjN9MOnGjXTCKPAe
nJ6IhKfm1p3L5X8Isz1WRz3WoC3FaJU2AqQ8K7ZQgyxy6k9/xcga6mN71ww757/B
s/BiXpO2hutFrNl1k/5b3+6gXFHzm9NnmvZ7PleafO8zbR6VzFFQK75hvbsO16bJ
UQLYISXqrPSlmxpdpQKQHj4InmVfTp2PKmPaAAvksrsWyBJsBGOBXdUcT3t8UjFK
VKUvNA8+T2+oRpZCdCb2yG8OsAVYTQk81hAz+XKV8mHqGkFGK8PChzJOB04Hd9K1
M4GklbNhi8egK748PPrngCghnwJrDvBDWMtzMIU3zmZuFrcjjyh64fE7RrAq9wR3
7bvR9YAvGuUYTg4G/YftTdqT7wCDhA/lxpQ2pZuWsI8Q8uzT9RVPs+bkBw3rF+mU
ZvsEkYTXC8X0i1CNUEFWDL/2+mrdPGWk0ZxIZ0xSNapHuaGkEvR3h3ocyTpczyCk
0oSwbspbiG46YmCKxvt5td8G6nTWvFIdrfvXd+TDARMAOvOj/ORDj9dzMlV1wIrF
5MSe5r0AsqYyLYnLIls0kBGRvefjk1rtOYl3j70k30UQocfPA78=
=Ke5d
-----END PGP SIGNATURE-----

--GmOKe0I7Sad2AhT2MdbMs9szPM7R4ehsv--
