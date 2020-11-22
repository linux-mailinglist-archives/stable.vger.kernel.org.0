Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F79D2BC431
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 06:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgKVFsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 00:48:05 -0500
Received: from sonic303-20.consmr.mail.ne1.yahoo.com ([66.163.188.146]:40778
        "EHLO sonic303-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726461AbgKVFsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 00:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1606024083; bh=YfdJmkgyAelV91TRnp6plxiix9tzbdDcoL6irU7Kg4w=; h=Date:From:Reply-To:Subject:References:From:Subject; b=MgaohE9WMs9Xk6L0HkyqT9cikZ+qO76ukuklE7zjD7YMrb5LjqFREtDDhf9AMQRsaujgyMSEteJc88QSK2/3NpUi0aCzxXR+rPkQ/oC6wDDd+OHIc6TUWX0sMJjJOMxux2S3CPOohiBxyIbtypW15vzEcLTw/LxV/iRTvIhX+do1FmPhVfQfOMDPXoI7P1C7l+py6GJN6XxdGbDjlTMvYpisXEXy72eif4kiZ2LXVDxhso74SyPbLmmSlhcex0XUkMQDMqsKrz8K3LqapYneVT/4sQoCWNEDcIncEQqQX3ieJxHMu4iva4KOf5k2nUlyb4EdX7FPrfyHjDEEslr0xQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1606024083; bh=KZFdSigA8PiN9N4ON1cfj4325/aYaEPhMonpsQxJRTK=; h=Date:From:Subject:From:Subject; b=V9+kNzm0GbVwR3UF1FwwYl/GnDiCUl//wXfB9ZY/SEWb8vbSqSKZN7ewndO5Rb0PW98nXt5wLki4wayZuBZFKUNGp8DT5BK+RXKuy4Xj+9H7eH3UOoTqZZkz2zXfmLWO0CCEu3QqkSaROnFQQiAo23vD9Aj8fE+HpRl9QM8xvtsCRtiVyD52OvFPIOuqjIaN/sHOMrwgFDFNgu6KwvSSu2jSOI//laddYd/iA/8X9R0T0+vbM0BvuQSKXsGV+esxR9usmTN0/tVrjTu2wgvTBp7rUHDL9sxuBgjOEBtrn6Cwpxzu1LcBwJI9jsl4vsJrWnOilKBatFSdKyDjKpte+w==
X-YMail-OSG: 3lcoaDQVM1nsY_pwJB.HaZo.9Yn2hM6joXXXxT1yOzRNaDRu58wXkuhAXlPmqIA
 DEL2rr5GsXbV3vh0j9odHjTUnWmF.A8bO_IC68lZaKWXok7XArRWp8Kr9Pgb6YP0dWyqQtjomVtS
 4SYbQCAi9o5YhmTwrdwQ9vtwdgVYsIrExEHtbaXfruSCO9W.lTS4E1J1NkEBdZlfWj.3EZfA.KD8
 Y_P2U1FTawWhLFL1oAB2uNC6mmJj7Qb8p3b96geCHjS0LJPNnjPZ89qkAHsgrr9wvvovL0dTa0o9
 oBCc5GqC6PbpGBhuQQU8Tyv_c4EEsk9J6VyoJcFsdFKkL2pRGik6tIUeofkNaJ38y19ouux.52DN
 lE6nZ__5Jpb_ENt1fPv_X4.O.KwArnv9NJrqXkIfPzJ4ayKSd1vj0AG40rHI0pKZPnJg3qoxRb.s
 rJtlD1FULte9_lITRm3VV9F5t2YyFQrmFidPxdvUjpfL1YVpAD.7D1Pgpv6CsYytsO9OasBQ6iok
 WzjbjZFh0IOWOPBZEmWNImpT_uirvyMq02ikLDq.GGh5UpPT3COx3PXmqN488d2R9ejju26f.ddy
 iMUgNz8u9bo2BiLiHHA.wKoWrAFc_7qZkSZ31cyzS5kmiY3Nhq4ONvYvbfkwTcIyxvHX3sr5DEvC
 C3fhRnQAjv6QDu7q3Dj8n4o3.4YK4LNx6mgQUd._neqoe6lT3R0WB7CnRhr8V_vGoAMXpLbFhPjv
 GAuT7mwNSeZwchjjK9Ho9ecoDVqWcN3o.2gGB6m6mXGTDniuem4_6aanm0UAPQL5HSbgrpew7BVc
 Mu8LaR4WyoydjlsdMsmDTkgGizPZm2Tlpk3Gnf8ApUqMTTs94KSj11UvEP1rUym61ANqfV3l3HoL
 CmLc4HMJLIR0uS7bQ4ijxzwaziRbX0Zx06s9Mye53_va.mXajpDVMRJla5bLlmSOjl1tsARlu0ST
 8_k8SzOb0J6wB5pV5hgItYC9e3rLOx52tHyyaIxOOxaDBrqx4lc9BXlpJ99zYPDff2dHGsvkLHGf
 bLkkqSJhYMhTQyEKC6CVl4.dmKcPLsvHY7tGt0Eak4zmy9XOmYaABNFYTlYqPr6JklFtcHdRDJD_
 bB4bARH_LNuuMt7dOcgcEAtoYOKjjYLtwAffxpaWHzfDQQoWVDyLn7R7EgDEQNtrdcSoiGGOcDQn
 gsA8nLZrUI7vwwY8q9TKOf0IuOXZ9Zk33pLsVrZ0TjDEnJwbU4GHh6Y3SNUdMwxRclGIukPOmGh8
 jxzq5kk_JxZhPWXMzlF81goAbl6uaAJWz6m6GURJXOeV1Bb3XS332vwiTCGwml4SWsSFZGfdYNz2
 YEEzSIQ1QgJFcqpPnXl4d6RKghSK8omXTImfNRcPyse04rJubbXx1XWxXOgQftaAX8SU5ChLlJNg
 kG6nHZlQprB_0_OcStsm8H3_V3z.YGOxsiUS9y_L.UUjLs9RHayg.MsfTgKQJdVYerxqbVUpUeu4
 gQmNNQmdegV7yV0quNMAcwjN.Jcb9VTp.6YxpDXx_r5Ikko9XwFLI4RRJrMxuLifGHRw4qTjkdnw
 UiO6SbdIqA1ji3QOwwKVLecJchrb3rewaYnhZ3j63csPCIpZSlXYTf.gczRCQ3DSkjsf9kinso0S
 .baALEPCgKz2qolitmWJ8G0.rmzfuet6MWifEebwwI0MXeVYeXQNIhigZbhZGJF9aCp.Et50G0Lk
 bV.3hzWpDQFHweH2P5Ida375x0yFlIO9GaPed._pbMsP8ss9KAA1LZrbbAw3yADmRLzM6YW1TbbG
 xCBnUfCagdnN67y.nLIe3TUyQURRiL5y8PitC_4E44ZYI8dxxa56fxo1M.bg_HnXeIiaVUmo6Uoo
 OscYXRcsT.hD4Xile1jolmfhAz3lZlKEGl8UsUpZHnXGxKlAlL2HEGdO.EzfmghzmXVdybSxFL.B
 OkdCzOYtAj9LVw.zWnWUZE5pr_1StofU.4TdYuWMTLLsWBezBETemQ5CP5cGyuhP0dt8rnSl3Z_2
 NSl3xtrJ8s7TqVK2gCoIohYCjnsnPw078AlJh8_WRxx.uhP5MLl3SX_2YUyT24_E9fGcav.QU4_q
 vfjF2JERZb2EZdbKC3C1ePaKlK9uCjy2M65G9cm7C.GgEShq6UOTbCOZPqEo_jb.hklvOMlHVOwU
 QacTKCzG5Om1C7uuT1YEhQLKxRbXQ0QMXQfoZ4i63SIMs1xm0sBggDhUA02CPre1fQOUBboF_ZJm
 joavMbPwdjL0FRiHGEoa_cNyEwgxTRLc031UTZyxHRivIJep4RZFHDuMj1jlLBy.EVIixbEP9SO3
 H6e8E2P47Z.E_rgxYqGFex1abStPJvj9kNnBFVmyzaMIAhO5s78XOYLHYusB1YF_0vzNQbPVHoJk
 5r0Ih6QdNcdG_ZPDLa09ywHCwS8KMIrYcKyu6JA6HKXe0yuwZ4767FgKL.5WJJ4cK7o6A3mQlPtC
 pdj_QRxXI7dyNZz90gRNmPBRFWDK2SRPvNRI.KjPRngfYaj5zG6tGdgf1utx47dIrCKQ96DohQnp
 atHBF0fMWA6nWDQKlpB6GcIinhu2fQyJ3KgS9sBNXi5l47zTy_XYtR2_HJEUtnRH5DrOSkB65omZ
 N36_OXDazprmO4dCEb6IE9rmaOLwaJzWcLItnHbtc_ITRUEMsQtW_K9oqjGiLldKr7OIbEzZ.2y5
 S1oqa92h9SoxBMfSoiN1k4Tkf4PEkYDgM7dv4lnnekeeuDfYuBHKN32yPgbyh6MpqVNCQvYbfD0B
 XzQtZvTI5cNXKn2ssxRMjPI2pU6vwkoHDXSJ8qLXwRBZNgfzBltmOR8yWRfoSfzvupiVsOdNjr6C
 r0Ja3RB1.c1bGPmJHZgLlu0Nh41XrXbvqB91v46SNIM_kX8wubFd9k4It_3bazj54OSyA0faDZ2R
 MsGsZDPAx9Yy7xT1F73QDvzdp68DB.A2lflrMAk4jc6XiouPNh5WE9f_HQzVGfKwiiRrEaQ01gx1
 I7izGq.AKORLh7WVYOLgLUu8Dj7W7f0r47Udn5C6mzsNpsDAF28B0WATFMpyb.DTm1obz9OBGnv_
 .OpdN1gsjNL2Y4mmVOioFOXIymJ2.i8V2xv7u3EoyrhDxc_nJFS.7srvmmrzabhLGGEl7bZGrt.h
 UrVaKxLN2jPhWopUwH5zOfAXtJ8SxkXSb5BOSMq0VBthV5Ov4AIypiOzWpjZxyb0JmWDeQWsvbQi
 avQqeP92_nrjIQMAFkUUJdN2YZuVYZJ0X6.1tDeuPVBRhNr8qlrgkJIkR0X3K7xdyQoxE3W3yess
 h4h.xVH19rsqHHY0M2BlDG.kPhhjlSGlIQVwr.PXvmcRIIxQhmtIW0aYvTNWfQr5XJfzSZyo-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Sun, 22 Nov 2020 05:48:03 +0000
Date:   Sun, 22 Nov 2020 05:48:02 +0000 (UTC)
From:   "Mr.Mohammed Emdad" <mohammeddrashok@gmail.com>
Reply-To: mohammedemdadmohammedemdad77@gmail.com
Message-ID: <743596736.350084.1606024082648@mail.yahoo.com>
Subject: URGENT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <743596736.350084.1606024082648.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.17111 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.66 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,


My name is Mr.Mohammed Emdad, I am working with one of the prime bank in Bu=
rkina Faso. Here in this bank there is existed dormant account for many yea=
rs, which belong to one of our late foreign customer. The amount in this ac=
count stands at $13,500,000.00 (Thirteen Million FiveHundred Thousand USA D=
ollars).

I need a foreign account where the bank will transfer this fund. I know you=
 would be surprised to read this message, especially from someone relativel=
y unknown to you But do not worry yourself so much.This is a genuine, risk =
free and legal business transaction. I am aware of the unsafe nature of the=
 internet, and was compelled to use this medium due to the nature of this p=
roject.

There is no risk involved; the transaction will be executed under a legitim=
ate arrangement that will protect you from any breach of law. It is better =
that we claim the money, than allowing the bank directors to take it, they =
are rich already. I am not a greedy person, Let me know your mind on this a=
nd please do treat this information highly confidential. I will review furt=
her information=E2=80=99s / details to you as soon as i receive your positi=
ve reply.

If you are really sure of your integrity, trust worthy and confidentiality,=
 kindly get back to me urgently.

Note you might receive this message in your inbox or spam or junk folder, d=
epends on your web host or server network.

Best regards,

I wait for your positive response.

Mr. Mohammed Emdad
