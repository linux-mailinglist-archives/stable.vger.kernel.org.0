Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5301218D0
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfLPSqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:46:36 -0500
Received: from mout.gmx.net ([212.227.15.19]:53821 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbfLPR4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:56:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1576518964;
        bh=CAK+937vMJ7Ul1L0L0cRsieV0URSjAloZ41FxESMYZg=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=JffkAK1tV2BmEBhNaIPc4vAg6igCT7DVh2lVhf8TVpHgSNU/3O83zV/s7OOF/wA/n
         d7ey00CzlVsbZRoFDpsN9KLDfOqR15mOfQQa6/wvO+etKanIz3EyZybKUjeoe+onCm
         9gnq6ewgl1vR0GEARXVdPJ34hWuCcI0lR7nuEsE8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.176] ([37.4.249.154]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M6lpM-1id5NS0toc-008KWy; Mon, 16
 Dec 2019 18:56:04 +0100
Subject: Re: [PATCH AUTOSEL 5.4 133/350] Bluetooth: hci_bcm: Fix RTS handling
 during startup
To:     Greg KH <greg@kroah.com>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-bluetooth@vger.kernel.org
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-94-sashal@kernel.org>
 <20191216131512.c5x5ltndmdambdf4@core.my.home>
 <20191216132750.GA1646935@kroah.com>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <9ea6af63-0133-284c-98a4-57d19c60d497@gmx.net>
Date:   Mon, 16 Dec 2019 18:56:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191216132750.GA1646935@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:1NGjEk2kmw7CCqJGd+/tmrSULyEcRMlyxmyL9HTkLzxJ3t5WPre
 h29L1kDiUcoAc5deXTwJbbDpbzsQPQziJ7QNj4jGfnaeGOyK4xzLxQS0A427fUgQqNIDH8w
 qAP3Cw8J8T5ge2H2PDtTALHSY5uvcc6ePf+5gfwGd02xgCd1rDtq0pWE96dhiygulNxnJne
 ssp/U87lfc9blvIt6MBNQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KLJednpRabg=:T5c7YPDR4wYazTXu2MmIJe
 E+SqqfXyXnnDSPNkA/jBrVz/6+pOP+KcGfJdYeVPqa++qTH7k+ZmQtauFTjtT9w6y3jBrrP47
 /+hHD7VfuluBjr7b+87e/E2Q9yGJ5Jdi1xdGyiey46Rcv2GMDOlXHe8p3C+XzYgMZCanN5kXo
 WrYwgrEld69IcwI4cH6MV6R3qxoc40R9Ln39OkKAruN83IR8nPD3qxkgY5Yj2vdavAxwpeLkw
 QVeaZqXGy45BFMuOpdIq9qM3E0VNQtyXPgnNxiDwlRokbsoUxDxSqv6nyFoIbaY9w9SOEnkeG
 ONsxrqDHtoEs99GsE99PAMVAx5BpLwXd7sIVYgcEnM+F7rLDxMFpVdd4HeaPC0NC/0e1P3+or
 9kh8U5gTXb5LmdO68Df/n56tsYn0p3xc7+prnFmhgrCSJiGqtTcC5xCFfT37x8uwK98Wywx9f
 73b/wouir1NnWZaGFxzZ4iiVgGr21LJmv03o8l0PIItmiVqdIYLjxX6uGRdKag6ngtqTMK5ZA
 SJOnU62Qj0/dSjF5FJTbiBgiKEZz20+Rv2jgGWv8e2MQ5Z2g9EjAbnUUUnG9eh1DSqeWM81eg
 0H2qN9KOc9sZ5W1aBOF8yl4U+NGvUnML5M0CYyuKtjU7feU36iv4KpcGabwf08gDX8aYm0yF2
 O0Umcm9UI77hQdMX5sSjDw9scrTiUttl3+sCm3McXQmImJ8k9HVqcqw2yVzkjzoAhJoMIsI1I
 A541DuPLICSFzevgpLHvvYXNbLJHoQdg8JHIrRiF48jTkc9B67J/L8riFGI+3ws6sOXPkBozZ
 CFKighY8lG5zAhqwR/Fi0FpHh82wyucb8n8GmPX/LiBoIZpYvH68rNeDrKIGOfzkNVii0KzFW
 Ibe3wPSVc+My842xtPbxHGuoQlVidb8kB1QV/Rf2L91ida6ML2fLc9Ki/o3BdSTxJL6IpSyT1
 z3NIGVSmWWzmoUlvOQl8+onDyW8ZfM9K0TnvaHcAffIugHIBIxwFvPzvuBj6IAlG/1rU4VyF1
 hUDaaVc/z4Z7WlIjScmpKUDAbqbFuX0wcORDT98xhYGwhRoQxCZ+mCPT9o1lQqSsxO/dMm4uB
 2Td8XkjsXjT+xASgxnuSaNHSu+Ttw1a5LbPoONwfn6B7jCmWH154P/V+pNDLRDkSHm5xSWEN+
 dZiDgZUD8PMq1ugPPIb1O1S3NrlXZOQ4DTfcE7WgV3XwkLiwL34LFHDaqDkwMXl0ko0tCCqlF
 0KdG0l9dQUSgpPj0kemw3NcWpYRIUYR88g58tgK7Kaz4YuPFyKczGMUShQ6c=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 16.12.19 um 14:27 schrieb Greg KH:
> On Mon, Dec 16, 2019 at 02:15:12PM +0100, Ond=C5=99ej Jirman wrote:
>> Hi,
>>
>> On Tue, Dec 10, 2019 at 04:03:58PM -0500, Sasha Levin wrote:
>>> From: Stefan Wahren <wahrenst@gmx.net>
>>>
>>> [ Upstream commit 3347a80965b38f096b1d6f995c00c9c9e53d4b8b ]
>>>
>>> The RPi 4 uses the hardware handshake lines for CYW43455, but the chip
>>> doesn't react to HCI requests during DT probe. The reason is the inpro=
per
>>> handling of the RTS line during startup. According to the startup
>>> signaling sequence in the CYW43455 datasheet, the hosts RTS line must
>>> be driven after BT_REG_ON and BT_HOST_WAKE.
>>>
>>> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
>>> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  drivers/bluetooth/hci_bcm.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
>>> index 7646636f2d183..0f73f6a686cb7 100644
>>> --- a/drivers/bluetooth/hci_bcm.c
>>> +++ b/drivers/bluetooth/hci_bcm.c
>>> @@ -445,9 +445,11 @@ static int bcm_open(struct hci_uart *hu)
>>>
>>>  out:
>>>  	if (bcm->dev) {
>>> +		hci_uart_set_flow_control(hu, true);
>>>  		hu->init_speed =3D bcm->dev->init_speed;
>>>  		hu->oper_speed =3D bcm->dev->oper_speed;
>>>  		err =3D bcm_gpio_set_power(bcm->dev, true);
>>> +		hci_uart_set_flow_control(hu, false);
>>>  		if (err)
>>>  			goto err_unset_hu;
>>>  	}
>> This causes bluetooth breakage (degraded bluetooth performance, due to =
failure to
>> switch to higher baudrate) for Orange Pi 3 board:
>>
>> [    3.839134] Bluetooth: hci0: command 0xfc18 tx timeout
>> [   11.999136] Bluetooth: hci0: BCM: failed to write update baudrate (-=
110)
>> [   12.004613] Bluetooth: hci0: Failed to set baudrate
>> [   12.123187] Bluetooth: hci0: BCM: chip id 130
>> [   12.128398] Bluetooth: hci0: BCM: features 0x0f
>> [   12.154686] Bluetooth: hci0: BCM4345C5
>> [   12.157165] Bluetooth: hci0: BCM4345C5 (003.006.006) build 0000
>> [   15.343684] Bluetooth: hci0: BCM4345C5 (003.006.006) build 0038
>>
>> I suggest not pushing this to stable.
> Is it being fixed in Linus's tree?

No, because this mail was the first bug report.

But i agree with Ond=C5=99ej to not push it into stable.

Stefan

>
> thanks,
>
> greg k-h
