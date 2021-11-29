Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9F7460F9E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhK2Hyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:54:36 -0500
Received: from mail-ma1ind01olkn0167.outbound.protection.outlook.com ([104.47.100.167]:10284
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229624AbhK2Hwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 02:52:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hf/8HMZNhuJz5wDDRBeR4opZQY2zNltFQbfjpU3AyJ5r06/8hoHLOFYIpw2dzp4hM1Ey7CRi6Zsi4ojuIMyktQ41tymia3nuy0RWhSTCqKwcOJjq0taxyahrWmHWLiyKTNgtUj8LR/PIc1CBNu5XH1McPuRIkyRhAQrm8kHhuQ3YAo8AxeLAb/KnJk/mLv2Fsr31drDClqnywHg3cJHYllx6NvpO5m0Gx4XMBvA8Pz1Y3F37163QqzAK6MiZFPjNicMFjhID2V+ctWM5WracU7Ke3lGqzVrSTMztLTwOtFubXgydqvmKALCBFMvRBWQyuKy2b6asd34xLOs4wET6ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PIz1dHsgknGz7pkd9xkrUnSidmpaIkEOlZbE8hv5Wkw=;
 b=GrvimHZy8gzD4nMC5qZZfkw3hN6tTKAaLbc+TXPYdWrzZUe21J9DmeoeREbOAJMg5xEWv3+hSK9Cul3Gd+R6Moh3i0l7kO4gf5ZsdWwV+TfRmWi/NfVwXzOIzfN0dTLde86YChoEqw9mu3rmHsol56qHXR5kGGj4O/Q3KPWBUaHh6zC8urhv/l8FNJQf+rOA1om/g15Troh/8zvZvETE2FLaifj4rZqHS9a58uGX5KSbp5wJFF6Ll1GVGVVhkvwvr3m0lv69dum5vchW4ANznx021Mo01Kgr2PltmfX/QwDvK15LSb73U2S/OuiJNrpmtCzSSnBpz7IfqkuhRsp3hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIz1dHsgknGz7pkd9xkrUnSidmpaIkEOlZbE8hv5Wkw=;
 b=m51j58KTKnHqAIXar83yRIDIAscwh64DYSz0DZfwrY3qnP21xYOn/H/qJ/AOZD4pZtLbv56OLA8dVE62uH9jknaKhtR9HzwdSFLupYtmmbxDj89+CKaqeZ17n3Bg6gJqdLxlMpjgfmSNuDHApsF6RvE9l6BD7jaGzqFJNFVY9JOuyauGZGduHGzgdTzlN62Y0+aKrbPFQGMZyG0a9Sh5kQSI3cdlK+0wJpbQPuNImGH9AKVh7X9F2NDnPxiRV1dBzGHmjQhLSxfFMc5QGhNVi7dVno0PHo2SH4XAoQU3cqf76R4C/DrGG0CXh2x67EFQqf0fDQILhYVdcR3CoE9M2g==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB5288.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:5c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Mon, 29 Nov
 2021 07:49:13 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 07:49:13 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Marcel Holtmann <marcel@holtmann.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Topic: [PATCH v2 1/6] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX5PSvcRAyqYFrr0SCfZKaU4VbFqwaINCAgAAAdgA=
Date:   Mon, 29 Nov 2021 07:49:13 +0000
Message-ID: <0814932C-9A2A-4483-B1EE-DE33E86D537C@live.com>
References: <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com> <YaSCJg+Xkyx8w2M1@kroah.com>
 <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com> <YaSFk4uY9bs8kEI3@kroah.com>
In-Reply-To: <YaSFk4uY9bs8kEI3@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [mRU9vQo9cKpo1AkuAxIfyuhEsTSZuofxr7nskouHvXTBPmrzTOhsXrHarwCpzyEO]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5306b9e8-cdb9-464d-2298-08d9b30cbc81
x-ms-traffictypediagnostic: PN2PR01MB5288:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VVT3U5CSAtqodEk24y1eKm1OZFHHBsZXCSXl9uo9dwtSB78mm+/tMY5t+/7xcDZhAw3aVqvwvBeRPNREuee28qNhqbTYMfVkyoQYL0ZNtt0NQhbumKR0vnwykNqYnL2WKx2AEG9ezUDbMYLygCoj3Adafpho91ZDiluaCIZCc8uJ0uRFcnU6dc8GQ6OyDLX2gL77ErmEcDq1MAsmzlQTPCnfIxTDZ8Nlo5tFShICO4jAW7+oHq3wyB0vS0cezGqQY/vpYk7Zt4S+Uy70Vr8hvasy/U0sC35xn0ht8AKl8rYB7bY8Wy6sb6XDsDP+zsD7XTJ7GdiE7CZVap5S68R/ASoTHXmOrw5i3lTrnIMLdsiZ2cHiYxYCGnWvAWnIbLkZG7lF6tH5aUtqB6SNVaAC98jV7UtV5gtGnYLt1lm20Zk+Y3aejzWxu4vidiL1qmR6WLlaPoKQ609rGmEijuJkyqqB/ofr6MJ3HD1aSnpAvYbG2WoTWLvlRs0/zxYTdvT89m+OIyUUDW8XG71Yyhku5Cow1SQQPDfkYcwSp0pW/3uGMyg3y4N2fNSWU1Xbrkc8+BoB0lA/oq5RiVjny9wIfg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: yLCpz/yY1mhXUxaVtnsR5MX7STvoG1s2oKfsZLoPNKSFb+h4ggHlN+yttyDWvFtrqMfqwFp3eCNywrbu4ToQUBPBqBjoGdu2An2QJ76Mus6lyRWAUjIBV+Qvg9XuMp32obg6vUtmjbL1IHpwg93CsBJqiWAjqSFAGeqaKV8Enfwnbl5HwR7snB+wl9S12GTR2ma8uJoaPuChY9TgCdT1Wp1azDC6tEejdxGXk/Vaa6hAivGjoe5oM4hvbSR2M5JVR0x1eHBMbOx3wD8FZtR/FdahXHEDLEKIy1KPuCgsoBnzdCuoiSqa8wb4IzxLmTQcRKMQVx7+G3uLrAeyn8KMHBHw/jYaWCadfBa6/BnQtkc/3bF/uWsVFXnSnBzMyYtri6XWIyEXPURkeDmKu7c0WtfkPVJD9zHMIafpqClwn9pM75xiVH1dekVn+8+4uC2qSQiNrj2QbK4dNu7bvNSoFPEqvx84kclTxbgfrNSPMaWXQAx4yrDY7TgNJp5G/IgRlIdHJR9vjGuwCLmi85AoDGKBLlGG/8xb5Mx/TK7AVXohagrjv3rsKwfPnrBiGRkxvBpzV8Xebvi9QOhFgavyzaoZ0Xt08TpuHoAq9swPwhIj1MVEGs7xcEWYxOd1IWswH4DV6pUqsbU7fV9EeGXjz3+j7JDQZG/ZggovGkRhJ39rYkAKhwsXXcCrAlzJRFxBDnecKCK/AUvslYl89fm5gY4jqPCXfFt/5dX6SyQUCVZXTWLepftD8mDfRRAniipAZYlIQjTljjIBPc5C3uPNhg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FD1BD3E89D341E4B8540B3F002F51676@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5306b9e8-cdb9-464d-2298-08d9b30cbc81
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 07:49:13.2458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB5288
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 29-Nov-2021, at 1:17 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Mon, Nov 29, 2021 at 07:42:39AM +0000, Aditya Garg wrote:
>> From: Aditya Garg <gargaditya08@live.com>
>>=20
>> Some devices have a bug causing them to not work if they query LE tx pow=
er on startup. Thus we add a=20
>> quirk in order to not query it and default min/max tx power values to HC=
I_TX_POWER_INVALID.
>>=20
>> v2: Wrap the changeling at 72 columns, correct email and remove tested b=
y.
>=20
> These lines are not wrapped at 72 columns :(
If I am not wrong, you mean that there should be 72 characters in one line =
right?
>=20
> Also the changes line goes below the --- line, as documented in the
> kernel documentation on how to submit a patch.
>=20
> thanks,
>=20
> greg k-h

