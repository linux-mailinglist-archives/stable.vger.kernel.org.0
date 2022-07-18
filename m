Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E6557883E
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 19:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbiGRRWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 13:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234709AbiGRRWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 13:22:23 -0400
X-Greylist: delayed 122 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jul 2022 10:22:22 PDT
Received: from esa1.hc3370-68.iphmx.com (esa1.hc3370-68.iphmx.com [216.71.145.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A33420BD0
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 10:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1658164942;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Qs3GrY8kD4WV+FrdVaLMPZAGu+Ks7N/ybW1voeRL56s=;
  b=PxIDIAO9xPLZ4HkQnH9G+09NvjVa5qBpJPczzclCCVTbyu9IYSMjSFvS
   io6tBdmjxWZYloEDSGSozAHFLJ6qnXtcjb6yHzQ8G2MX4Bl95ZpjvXuXy
   Si3Y1s2JInu6uup/xsjTTr+0u+zKi5Mvdf+qBJ9UM7UCKwAJrGmclzxDW
   I=;
X-IronPort-RemoteIP: 104.47.55.101
X-IronPort-MID: 76490153
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:ASICJ6tRiION0VBg6W1kh8heiefnVFJeMUV32f8akzHdYApBsoF/q
 tZmKWrVPa2Ja2Wnftp2ao6zo00C6sLQytJrSAFo+XwyEiJH+JbJXdiXEBz9bniYRiHhoOOLz
 Cm8hv3odp1coqr0/0/1WlTZhSAgk/vOHtIQMcacUghpXwhoVSw9vhxqnu89k+ZAjMOwRgiAo
 rsemeWGULOe82MyYzh8B56r8ks15qyt4WNA5zTSWNgQ1LPgvyhNZH4gDfnZw0vQGuF8AuO8T
 uDf+7C1lkuxE8AFU47Nfh7TKyXmc5aKVeS8oiM+t5uK23CukhcawKcjXMfwXG8M49m/c3Kd/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTGCFcpqHLWyKE/hlgMK05FY043exLIWgXz
 qE3GjA3SB3ftbiI7ovuH4GAhux7RCXqFKU2nyg4iBTmV7MhS52FRLjW79hF2jt2ntpJAfvVe
 8seb3xocQjEZBpMfFwQDfrSns/x3iW5L2Ie9Q/T/PJui4TQ5FUZPLzFGdzZYNGVA+5SmV6Vv
 Dnu9GXlGBAKcteYzFJp91rz2LOexXqmA+r+EpWA7r0ynGDIwlZCUi1JWFexmuiL116hDoc3x
 0s8v3BGQbIJ3FSmUtTnTTW5pnCetxIRUtYWFPc1gCmH0oLP/h2UQGQJJhZKYcctvdU6QhQh3
 1mOmdLiDDgpu7qQIVqZ97GJvXaxNDITIGsqeyAJV00G7sPlrYV1iQjAJv5nEaionpj4FzDY3
 T+Htm49iq8VgMpN0L+0lXjX02yEpZXTSAMxoALNUQqN5xl1bqamapau5Fyd6uxPRK6FQV2Rl
 HwFndWC9ucIDIHLmCHlaOoXEb6q596BMTvBkVBoAp8t/iis/HjleppfiBliI113O8IIYhftY
 UnOqUZf44JVMHK2bKhxJYWrBKwCyanmCMTNTPfZZdkLf4M3cgKblAlsfUmR2mrqnWAvnLs5N
 JPddtyjZV4BFa1tyDeeWegQy/koyzo4yGeVQor0pylLypKbbX+RDLIaal2Ha7lh6Lve+V2Mt
 dFCK8GN1hNTFvXkZTXa+pISKlZMKmUnAZfxqIpccevrzhdaJVzNwsT5mdsJE7GJVYwM/gsU1
 hlRgnNl9Wc=
IronPort-HdrOrdr: A9a23:ft4etq24XYRmJ1W/f7kGjgqjBRFyeYIsimQD101hICG9Lfb0qy
 n+pp4mPEHP4wr5AEtQ4uxpOMG7MBDhHQYc2/hdAV7QZnidhILOFvAv0WKC+UyrJ8SazIJgPM
 hbAs9D4bHLbGSSyPyKmDVQcOxQj+VvkprY49s2pk0FJW4FV0gj1XYBNu/xKDwVeOAyP+tcKH
 Pq3Lsjm9PPQxQqR/X+IkNAc/nIptXNmp6jSwUBHQQb5A6Hii7twKLmEjCDty1uEg9n8PMHyy
 zoggb57qKsv7WQ0RnHzVLe6JxQhZ/I1sZDPsqRkcIYQw+cyjpAJb4RGIFqjgpF5d1H22xa1O
 UkZC1QePib3kmhPF1dZyGdnTUIngxeskMKgmXo/EcL6faJOA7STfAxy76xOyGplXbJ9rtHod
 129nPcuJxNARzamiPho9DOShFxj0Kx5WEviOgJkhVkIMIjgZJq3PsiFXluYeE9NTO/7JpiHP
 hlDcna6voTeVSGb2rBtm0qxNC3RHw8EhqPX0BH46WuonNrtWE8y1FdyN0Un38G+p54Q55Y5/
 7cOqAtkL1VVMcZYa90Ge9ES8qqDW7GRw7KLQupUBzaPbBCP2iIp4/84b0z6u3vcJsUzIEqkJ
 CES19cvX5aQTObNSRP5uw/zvngehTMYd228LAu23FQgMyOeJP7dSueVVspj8ys5/0CH8yzYY
 fABK5r
X-IronPort-AV: E=Sophos;i="5.92,281,1650945600"; 
   d="scan'208";a="76490153"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jul 2022 13:19:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQCdHoETfUK8sNVpGIe+0uBvDTh1HXh5diYii3tnl8AaemFE9GYYR2+NBdDMWxXDmtdfcPZxJX+lf+CAVM1xuLdbEVjv4izTlsVyIYRui1/2S2fg0dV+vUa4Zvdzs+YKmCQIxxitZNXCFU5LJKW/YXP1ScDZKDN29FF7DyHUHuHr9ChZwhcTu9T8BenPur0C+1UV5G5g2r7XmWJzbtG9RPTORz8SvDd6M/qtwr7CfT/T+mkLGGNDCfFA3S6M2TsaoMaZDfRG+VmKwJ3pb9FyJmcgHGuG/2vxdri4e3UInctqX0UmWeSXEGiF2kwPD0zp9jm/zB46DRRL45PuSWbF5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qs3GrY8kD4WV+FrdVaLMPZAGu+Ks7N/ybW1voeRL56s=;
 b=eCp1LlCXdTff6pg6RT/ZucDCIFXZvGvNNFZQuIA5uo3KP2khMjnCplH3+fFfqqbTNAjyYxcsFNnvbwYoSbSAERbJ/tb/7V8fuB/QbK1UURUX91+Ht+5VHzTNKFQ/AMJ093mfRfqiQKCcgFwa/+/L/7eBOTqB0r0C8x3eAMARb63YyecgZ+980qPwax2R719ImY4hRc6/Shc1jNUK3UFhy9dk4nzgbVxvxejI47Vl9lYuLAz7sG2kix2Z6mgkekSNEy/nSk2P5lWazNIU/muQhTL0iIvJrEGvPClqcKLsloOaCBfIsvTW29obPqHokHkimYsTNWd6hsm3sXuyYcr+oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qs3GrY8kD4WV+FrdVaLMPZAGu+Ks7N/ybW1voeRL56s=;
 b=Upghy5P5i5lwqHADsKLJTbp4f1J9C+QTZCCSPtz2dQlqqk0KIccwPCJGP5Y3WPlxItk9hBLjKpTagdWtIkAzbeRxZTAUoNRuM3Bv2pw6gzwMWXfj5e1/op9CCHPhYHbkraKqBX56lP/eA/Bpjo67PGOldQzGWjMSbnA9Xgv+LtI=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by CO1PR03MB5777.namprd03.prod.outlook.com (2603:10b6:303:9c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Mon, 18 Jul
 2022 17:19:14 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::bd46:feab:b3:4a5c]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::bd46:feab:b3:4a5c%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 17:19:14 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@suse.de>
CC:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
Thread-Topic: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
Thread-Index: AQHYmptdJOyHoRHpekSyZwzh1olqAa2EUZqAgAAC1YCAAAtbAA==
Date:   Mon, 18 Jul 2022 17:19:14 +0000
Message-ID: <7c23621b-66fc-eb35-c329-bb947798016a@citrix.com>
References: <20220715194550.793957-1-cascardo@canonical.com>
 <YtVG8VBmFikS6GMn@worktop.programming.kicks-ass.net>
 <YtWKK2ZLib1R7itI@zn.tnic>
 <YtWMiyem8+N4vbKE@worktop.programming.kicks-ass.net>
In-Reply-To: <YtWMiyem8+N4vbKE@worktop.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09edd191-75ec-4c68-099c-08da68e1a383
x-ms-traffictypediagnostic: CO1PR03MB5777:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +0DFuLqNGFPAsEoYvaWWIg8uR2I7izyRa37SdBud4vXMZDov3gbnCKh1TgYOb9ZyFcNpYVCXYrqXlIGQyoGvlSENIc6BlA9+lZEIAkhZ4R6eZl9Z+rqvkZ2ArJEB9VXGs+POZ+86oGy2rsRE/CL2QDVsWT106Xh1EcuZLxWcJKzxx7qEMVt2DRcHqBvZuRzF29OZNjHd7KOutf+527vBhBTdI1FFYSgg/wMkVwskicOAwbMtZzgDha8O2MdJLG7Ayi128SfHhxaEIcWokQzLESJ7lRPNaZWxHVw+J9l1QTsrEH5iBA2lwJaZaFL0CsUULYjktqjEf6Nvq3abGEK0bJJTySQZFbNlbCaxm64JtOTZnC/mkmZKWN/Asjy4lL0qBuLveWruyunHj9u6wI7+Ot+6481yKPP8gUmSfE1lnn/hMggtCtlElv8AKXlD2KUgeGvb+VOUlB8W6QZBmb3aFSfACFiUSy9Xi+6wiB3IhorWOBIxQqGy9R+2c4nXV4UMEVASTlPuRj4x0NRrzebgrAQjoIhgb4O1z/pQeTrB3USJE/9AMAZh+AQP4QxO97GW1r1OoYQkbA+r4qqJemy7edHhICLwDrxmr11aZqHkP1Hde5p8YaBQ07qUhn1butBrHs2Ip9tomhKQli9cctp66CGSo6N4WsR2GgaaRxhqcBIJSf+QIFjH5GO8PkwKrbkLKNreJC86K0awx+oA6IC0ERcP5j0mMkLqZ6r8uJXXACX0rRUGwUtaXhH0U5yQUF3S9F/ZeOgCc2rDXx338iI1xflZNcRCkKcVDXrNRufaaQUjBUGULbeEsc+W3QdObOF5DKkO5zHdY16aJTUeBxa6j46qTwQbYOo/JbbG0cWVsLKGSZV2iSJdfndXa032o0VDSqa1p5DYrU3t5fsV3kD6dci5U/ZaoW3I6GSEH19RjOc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(186003)(83380400001)(82960400001)(66574015)(122000001)(38100700002)(38070700005)(41300700001)(6506007)(6512007)(8936002)(54906003)(110136005)(53546011)(86362001)(36756003)(26005)(71200400001)(478600001)(2616005)(6486002)(2906002)(66446008)(64756008)(66476007)(4326008)(66556008)(76116006)(66946007)(8676002)(5660300002)(7416002)(31696002)(31686004)(316002)(91956017)(41403002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFZXU2czanB3R1Z2bVVEU1gySmFnRGNFNjRhMThpZjVudkNlTFpBOXlseXkz?=
 =?utf-8?B?cjQ4WW5yU0twUXNSNTNxVlBacGE3YWNiZVFGcFY5ZVRUTExCZGgybnRtTSs0?=
 =?utf-8?B?WDBnWmI3ZGRkeVJUdXVzNFNDYWNkajNwdXJ1RXBIT2lCeHhmd1U0Mzc4OWJX?=
 =?utf-8?B?bkJGS0xUdm5qaFVvRThPeDA4RzFvVW1INTY5MnRMWWpEdHBRb3JoaWc4a2g0?=
 =?utf-8?B?Zm1UQlBQVUFtSmRtUURGWVBYTHhMWjMzb0Z4QldJRUNZSE9JY2NiaDE0bUNO?=
 =?utf-8?B?dk9Rc0hjc29qUVZ6eUhUVXBEUXFLczVtZVY2N3BWVjArTmg2dXJOUUVNam1W?=
 =?utf-8?B?eFdNUDE3M3BBdHFWMHlReWVoK1YxMFE5ZTBNb2NUTWxhc0xaK2NoblE0TlVx?=
 =?utf-8?B?WHF5RzJ3Wm5sWWt2OTJ6S0ozeVRTdVp3TXFNUkxBWE9rNTVOOUp1R29BUEtZ?=
 =?utf-8?B?MmloUlo0TVZuMEQ2QUNZZWRYTkdTNHBrWWhtejR6VGRDU2xiRjRQQlZLRC9v?=
 =?utf-8?B?ZkxCNHBJQjZNcXg5V1p1VlFhZlJVWUlPaVM5L0F4bXBYMnpqeVJEU1VWSWxw?=
 =?utf-8?B?TVk3K0s0b1doanIya3I0d0xqTDBvbEJXbXJqNS9ROU5LaHk1SFpoTzJxelhJ?=
 =?utf-8?B?MG1ld2RYdThBUCsrMTR3ZHBSTW5MdGJxMDljcERtaVdUT1c0c3FBbm9saWx3?=
 =?utf-8?B?ZHNYUGlpejZmY2o1a3NJOUpHbTcreWY2cmdxL1E1UlJnVHBPYVZHKy9pc0Fi?=
 =?utf-8?B?UmtTa2RKd1o3alkyUjVnckY5clZkUy84TTM4QmpjSVR4bjNHNXNvd1JaRzVX?=
 =?utf-8?B?TDl1K0g5enJ5UDNmczI2L2RkRFdMR1RGK3RYSzYrR0FTdUlDR0daVUFCQ0xw?=
 =?utf-8?B?dTR2NStMZ1UzYmhkdFEvRXdsZUVqQ293ck9md0VvbTE1b21nYXpwaytKMTZP?=
 =?utf-8?B?WWlyL3kxM2RTMWxHNWpTakwwZDhuZzJBL2h2OXpsWXJrYk9ldmRmQ3NTQnZO?=
 =?utf-8?B?eXpxZUUyZTFHbjFRZnAxZE5KdUFkRVFXWmkzMXMrNm4zcFczMG54SnJtYUR3?=
 =?utf-8?B?bVlBV2NZTzQ2TFN2cnhzQzVtelpuVnpzVU95SHlKUFJBaW1RS0RDY2pVdlBi?=
 =?utf-8?B?ZFBTR3dvbWFnOHlDc05wa1NFMEZtZGNyajl5VnZNMzMxTzhzRWk4b3Y1c3VU?=
 =?utf-8?B?SkxCZVdEdVk3dEsyYWpIdjVLYjc0YndwaWVGVGp3WjRvSnc1ZnplalM4UEtF?=
 =?utf-8?B?TzJ2ZThueVFwbGVaN0h4OXJCZndVWDRMSEhvMHk3OHNSanZIQ3BMN0FFTEFu?=
 =?utf-8?B?YmF6MkxQVVNVUEhLQjJubHJwSFFwcDVtSXBsTkNwTEtpeHdzcXhFMDBCRmVN?=
 =?utf-8?B?RUxhY1ZLVHhtd3RVaFFsdUs3VjV6d1BNelFCYlhrR0lFUmsrMG0vcUpya1Er?=
 =?utf-8?B?SURJN1hzZmRmS1Q3Q3JTekRUSFZlSE8vS05COHA1VGl2b2ExWUpNMFlVTmha?=
 =?utf-8?B?U0ZlcC83L0NkZVRpTTN6dzNqYVZPcTVoaUpnZTB0anhpeHdjalBYMnovdzVV?=
 =?utf-8?B?b24wVlBlOEd6Yng1MlhGVitydG1SUjBYMmYrNHV2UGtlUUE2dGhIK0FWcjYv?=
 =?utf-8?B?MDFvT3JrSk1KbmMyN0h2NVdtQWdkUU5EUW84NXJrU3dHVkVEcW1pdlZhT1Ar?=
 =?utf-8?B?SDlZTzk5SnBDbVREazVBN2kxSFJxWC9mWlpoK200dmpEQ2g3N1RyK1BjRFRa?=
 =?utf-8?B?K0VuOHZKd3hrOUtjeEUxYTJYUjgxQUlYWkRnUHRvY1Y3am9MV1hoNHYrSHhN?=
 =?utf-8?B?RUF3YmF5Z0xWVDRqbnZsODh2L2ZMdnkyTFZyVDBBbkptN0YreGlZR0E4SWNS?=
 =?utf-8?B?VlRSeithT3U0TzlmWmZnM0ROWlN6T3lsMklKdnMvekU0a2puNE1pSzR3QXlR?=
 =?utf-8?B?eE0xNmY1UmowSW5YNTdhbVA3M0FiM0UrbGtPQ2JpajJIblAxWkRMbEhPd2wx?=
 =?utf-8?B?NnNRUE5DK0NQU1NjcnlvQjlWSXVzWXE3UkhQdnVVUm43WDZHVW5WNHMxa2xD?=
 =?utf-8?B?U0c4NjI4R1ZNZlIzcGlyZ3BBdXhLYmpMSVdhZGVOWjZLRmxIRlpYTDg2dTVs?=
 =?utf-8?B?dHMxYjBPbC8raEZBYU44RDFxYWUrOEx0eDhFMjVMTDZ4TGplbEx3SmJDa0pH?=
 =?utf-8?B?MVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69842B7888B9AC489F6AED3D08E8AF86@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09edd191-75ec-4c68-099c-08da68e1a383
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 17:19:14.6081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VWl0qQWqeCx34qPYVGl6LO15FRoejkL4Mm2ed0OjAf1p2SZHhV3GGTSjsddWwtshCy+lLu8PZODGmChkAhH6ZHhiF8V5M0gQd1ejjHtOMpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR03MB5777
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTgvMDcvMjAyMiAxNzozOCwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+IE9uIE1vbiwgSnVs
IDE4LCAyMDIyIGF0IDA2OjI4OjI3UE0gKzAyMDAsIEJvcmlzbGF2IFBldGtvdiB3cm90ZToNCj4+
IE9uIE1vbiwgSnVsIDE4LCAyMDIyIGF0IDAxOjQxOjM3UE0gKzAyMDAsIFBldGVyIFppamxzdHJh
IHdyb3RlOg0KPj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9ub3NwZWMtYnJh
bmNoLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9ub3NwZWMtYnJhbmNoLmgNCj4+PiBpbmRleCAx
MGEzYmZjMWViMjMuLmY5MzRkY2RiN2MwZCAxMDA2NDQNCj4+PiAtLS0gYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9ub3NwZWMtYnJhbmNoLmgNCj4+PiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9u
b3NwZWMtYnJhbmNoLmgNCj4+PiBAQCAtMjk3LDYgKzI5Nyw4IEBAIGRvIHsJCQkJCQkJCQlcDQo+
Pj4gIAlhbHRlcm5hdGl2ZV9tc3Jfd3JpdGUoTVNSX0lBMzJfU1BFQ19DVFJMLAkJCVwNCj4+PiAg
CQkJICAgICAgc3BlY19jdHJsX2N1cnJlbnQoKSB8IFNQRUNfQ1RSTF9JQlJTLAlcDQo+Pj4gIAkJ
CSAgICAgIFg4Nl9GRUFUVVJFX1VTRV9JQlJTX0ZXKTsJCQlcDQo+Pj4gKwlhbHRuZXJhdGl2ZV9t
c3Jfd3JpdGUoTVNSX0lBMzJfUFJFRF9DTUQsIFBSRURfQ01EX0lCUEIsCQlcDQo+Pj4gKwkJCSAg
ICAgIFg4Nl9GRUFUVVJFX1VTRV9JQlBCX0ZXKTsJCQlcDQo+Pj4gIH0gd2hpbGUgKDApDQo+PiBT
byBJJ20gYmVpbmcgdG9sZCB3ZSBuZWVkIHRvIHVudHJhaW4gb24gcmV0dXJuIGZyb20gRUZJIHRv
IHByb3RlY3QgdGhlDQo+PiBrZXJuZWwgZnJvbSBpdC4gT250b3Agb2YgeW91cnMuDQo+IEkgZG9u
J3QgdGhpbmsgdGhlcmUncyBhbnkgY3JlZGlibGUgd2F5IHdlIGNhbiBwcm90ZWN0IGFnYWluc3Qg
RUZJIHRha2luZw0KPiBvdmVyIHRoZSBzeXN0ZW0gaWYgaXQgd2FudHMgdG8uIEl0IHJ1bnMgYXQg
Q1BMMCBhbmQgaGFzIGFjY2VzcyB0byB0aGUNCj4gZGlyZWN0IG1hcC4gSWYgRUZJIHdhbnRzIGl0
IGNhbiB0YWtlIG92ZXIgdGhlIHN5c3RlbSB3aXRob3V0IHRyeWluZy4NCg0KSSBkb24ndCB0aGlu
ayBhbiB1bnRyYWluIGlzIG5lZWRlZCBlaXRoZXIuwqAgRUZJIFJTIGNhbiBkbyBhbnl0aGluZyBp
dA0Kd2FudHMsIGFyY2hpdGVjdHVyYWxseSBzcGVha2luZywgc28gdGhlIG9ubHkgdGhyZWF0IGlz
IGl0IGFjdGluZyBhcyBhDQpjb25mdXNlZCBkZXB1dHkuDQoNClRoZSBJQlBCIG9uIHRoZSB3YXkg
aW4gbWl0aWdhdGVzIGFueSBCVEMgYXR0YWNrcyBhZ2FpbnN0IEVGSS1SUy4NCg0KVGhlICJzYWZl
IiBCVEIgZW50cnkgY2FuIGJlIGV2aWN0ZWQgZHVlIHRvIGNvbXBldGl0aW9uIG9yIGFuIGFsaWFz
LCBib3RoDQppbiBrZXJuZWwgY29kZSBvciBFRkkgY29kZSwgYnV0IG5laXRoZXIgb2YgdGhlc2Ug
Y29udGV4dHMgd2lsbCBiZQ0KZGVsaWJlcmF0ZWx5IGNyZWF0aW5nIGEgbWFsaWNpb3VzIGVudHJ5
Lg0KDQp+QW5kcmV3DQo=
