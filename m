Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498432E6BEE
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgL1Wzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729438AbgL1UmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:42:12 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48BDC061793;
        Mon, 28 Dec 2020 12:41:31 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id d203so12670657oia.0;
        Mon, 28 Dec 2020 12:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=8TtPh3kxQMMdTUXv5QBSr4ZIMcMzV+MdW+h+TpWT5gs=;
        b=lx9GOWEZ0gOpcdB82/K+qzRqIGfjX81DW7I1TVTD8R2OcvYn8nERibmCucvS8i7/U4
         t8PUW5EQt0Qppu+CGMWkoJIWDC7YDQGqoTuy4D5e9omR1pPqfH/7CPqMXiPodFyGcH4a
         3+GsRD0PhS3XZQLkfIK9GwDt5WDZOyy9SqqvsD1nbkCMhHdDGKZVEI+mjeDIN2VDsrl5
         3mxjfCkCGtMkxwTTjWAp2MLJqfQngVoyAx0XZyhkK9fCpiO3IOWMMkR8GgJON7EUTdQg
         llP0w8mddsc0U2UySebOwPGnIb8QniLE/PQeJ+sJSMWxPXw2SiHR4qxzzhaE76eS+4Nf
         kYgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=8TtPh3kxQMMdTUXv5QBSr4ZIMcMzV+MdW+h+TpWT5gs=;
        b=TSfBpZcdkc4qiKH3YTIvlDDL1xTrg9KpbAe+rRB1jCE985P3puBmTY6dy2jjTcvvrH
         riDUQRLadvoNBMlP5VpCNCpsFBkHG4AVaeH15bYJA9UJ5KYy4OZVHk0HxUzxlYABlpXO
         +RRkHG2M8ruBGWHGMS+hi5Lr+IpYWWPJS7b/Q7R4Z8jQVYUL5WSxs545ImyJwpCukrNs
         DYSM59hfDqNdhsyoVq2DDYXlsObSXObf+jX0YaaLqptw2pbvbG5xvlVaIy41Ca5imUKm
         1WL8FolSjVCwUZGZxaziCpsKl6IbIECI1dsVTJxZPFouMsGJ9+qj7xmn9eh9BXURXqsm
         dRfg==
X-Gm-Message-State: AOAM5308m8cIho3xZChh3iqKYMMdsfGvxz2H2iORc/LgHpOTDON5iEZk
        nrRqfvqyppJ0wjtxbfdrIVe4/tppf6k=
X-Google-Smtp-Source: ABdhPJzFttKtxsaYBe0Ecy0txuAtgl8tTWgsgWOepEiUobWs7SGtsB4ULTfyyJapxCgjvDNdd0+m7w==
X-Received: by 2002:aca:ac82:: with SMTP id v124mr479168oie.56.1609188091110;
        Mon, 28 Dec 2020 12:41:31 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c18sm9200182oib.31.2020.12.28.12.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 12:41:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
To:     Pavel Machek <pavel@denx.de>,
        Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20201223150515.553836647@linuxfoundation.org>
 <1b12b1311e5f0ff7e96d444bf258facc6b0c6ae4.camel@rajagiritech.edu.in>
 <X+dRkTq+T+A6nWPz@kroah.com>
 <58d01e9ee69b4fe51d75bcecdf12db219d261ff1.camel@rajagiritech.edu.in>
 <X+iwvG2d0QfPl+mc@kroah.com>
 <c7688d9a00a510975f115305a9e8d245a4403773.camel@rajagiritech.edu.in>
 <20201228095040.GA11960@amd>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <356ddc03-038e-71b6-8134-5b41f090d448@roeck-us.net>
Date:   Mon, 28 Dec 2020 12:41:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201228095040.GA11960@amd>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PeR3P71jsL3DqMYXWZJ7g053PQGUGgV0Y"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PeR3P71jsL3DqMYXWZJ7g053PQGUGgV0Y
Content-Type: multipart/mixed; boundary="IpdvjqVHbDNaN2gfvoZ6ivWT94zUZOBuj"

--IpdvjqVHbDNaN2gfvoZ6ivWT94zUZOBuj
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/28/20 1:50 AM, Pavel Machek wrote:
> Hi!
>=20
>>>>>>> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.3-rc1.gz
>>>>>>> or in the git tree and branch at:
>>>>>>> =A0=A0=A0=A0=A0=A0=A0=A0git://git.kernel.org/pub/scm/linux/kernel=
/git/stable/
>>>>>>> linu
>>>>>>> x-
>>>>>>> stable-rc.git linux-5.10.y
>>>>>>> and the diffstat can be found below.
>>>>>>>
>>>>>>> thanks,
>>>>>>>
>>>>>>> greg k-h
>>>>>>
>>>>>> hello ,
>>>>>> Compiled and booted 5.10.3-rc1+.
>>>>>>
>>>>>> dmesg -l err gives...
>>>>>> --------------x-------------x------------------->
>>>>>> =A0=A0 43.190922] Bluetooth: hci0: don't support firmware rome
>>>>>> 0x31010100
>>>>>> --------------x---------------x----------------->
>>>>>>
>>>>>> My Bluetooth is Off.
>>>>>
>>>>> Is this a new warning?=A0 Does it show up on 5.10.2?
>>>>>
>>>>>> Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
>>>>>
>>>>> thanks for testing?
>>>>>
>>>>> greg k-h
>>>>
>>>> this does not show up in 5.10.2-rc1+
>>>
>>> Odd.=A0 Can you run 'git bisect' to find the offending commit?
>>>
>>> Does this same error message show up in Linus's git tree?
>=20
>> i will try to do "git bisect" .  i saw this error in linus's  tree.
>=20
> The bug is in -stable, too, so it is probably easiest to do bisect on
> -stable tree. IIRC there's less then few hundred commits, so it should
> be feasible to do bisection by hand if you are not familiar with git
> bisect.
>=20

My wild guess would be commit b260e4a68853 ("Bluetooth: Fix slab-out-of-b=
ounds
read in hci_le_direct_adv_report_evt()"), but I don't see what might be w=
rong
with it unless some BT device sends a bad report which used to be accepte=
d
but is now silently ignored.

Guenter


--IpdvjqVHbDNaN2gfvoZ6ivWT94zUZOBuj--

--PeR3P71jsL3DqMYXWZJ7g053PQGUGgV0Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEiHPvMQj9QTOCiqgVyx8mb86fmYEFAl/qQvcACgkQyx8mb86f
mYEWrw//c7B1i+fj8/qiO4hoSdF0nCU8Q9/w/6b9hzk6MSAHusOsaiOWlALQ2yP7
e3+6eu/CeM8jwUBArzfVc3t4tra+02jkYEjao3PGOrzNeHoVflZV9faXUuv9d/8q
oE8gKb2wOMtPJWiFf14R4nias4kgbxGH+J05ebClIx2UB6+2HYAkdR6qQPluWiwv
V9cMANG3IkrEHlt7msuzm4waEPAKvvJ9kcv+H6/9CFhoH3ZOZfcT9B4o/I8bDmpu
F72Asrxq82Q5cQDDbwzU6HIDZko2ct8gtCQiKQyX9qYA9yxTVg3FxPloHpr9AocX
3z0VmPyWB+9grXu3a5K1ZPms6msDhlnK1bIbF8vh181T7ReobTWRErIS7pfyKW3B
NaV0OJ7G2wY8s93XZV322hVoihAGLX3Wby2FjoAOTZRnknj0oQw3X59/GsH4e9WE
ZyGfUYS7scMR7WqNOE1ADJDGS41Kk9kGk62ANYFcrkC8CNyzx39Bc0kYE6ifqFHe
Bva3Ti9KcOf1XYklnbS80YRU9kd4mtt2ddeAib/C+EgJq3DQXuFryTu9yyAYkUH9
Gc4MGPCa9q9uAe2pQ9M4MtIuEGb7JozqcuWMR/VKB9ZBkhCzkxLmxzjMGHY8llRU
IvRaiKpninjCvhB83XnkZoXz3E8CVP8Pa2mAAcusHttySVPMeTM=
=MqLb
-----END PGP SIGNATURE-----

--PeR3P71jsL3DqMYXWZJ7g053PQGUGgV0Y--
