Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C21D3628DE
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 21:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbhDPTtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 15:49:49 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:56146 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239187AbhDPTtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 15:49:49 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 91F55408D0;
        Fri, 16 Apr 2021 19:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618602564; bh=G8WgnoQa5k2MmpiEzheXUM5Sx8p7XFAqltz3BMUamEQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=kPK4GumiNRi/XZhIJQWj8Uza/nj9Ed3HJvTFbnXhQDd9C5oyJDSIQSHRvlQU26f2D
         zLGkmmTa74WZTyK22vXnJycZVVfgBLPUwuTE9F0qrMFMahh/BmejWv65NTFzr6O058
         gYClebAa+6mAyYqVufJfkT1hb96dO/bKqe0/0Swx5ddpWqFBoy8fCGfnF4CG2GJLPY
         Gf2mMwiDPyGMMHbewF1hxkYxbVD+1rJWRW9E+sOg1pe0LTUC+++Gg8MmfMw3DiqqZM
         5WNgbaqseKygrmUK6MqzHOfXIVaam37SI7OMIlvCz2PbizGhqDDW/drlg8TgXFYtSJ
         4tTGBPxnrA/0Q==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 97EE9A00A9;
        Fri, 16 Apr 2021 19:49:22 +0000 (UTC)
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04lp2055.outbound.protection.outlook.com [104.47.45.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 3A6318018C;
        Fri, 16 Apr 2021 19:49:20 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="DEk027dH";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bU3hlXaisfOInc8Q38fr8mGoA1zTMptPyq25pbKv34T9nf5K8C7P3bGon0n70FMZNbC2RXcVgJuBWldJEYQX3jYy6Hgoj2yWfsdoVq6wW8rKhQsJOFqTYlg5q32TJsmgf3P1BjCvSZzPuechhZngYe6FBonRbifqZ/Q7dJIEwAnhPljO8VQ9KnY4fOhmrUnMdyM9zdvAUZcS1kRiQMiCkK3hiMmTN1pDS4vMYEJdTmTaG2qvW2DA2W0W+boZffi4tI8MvOXaPLwzW+i3XF3ZH1Flkti/cJtcKox1yf976MdcaQ7v9y+HTrOOwEN500DZLiKGlsDEkHi+MCcsyb8kXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8WgnoQa5k2MmpiEzheXUM5Sx8p7XFAqltz3BMUamEQ=;
 b=Kw/KnsUKfEODQasFJln5mQKdg/rlXE70NunQ4VlqAJlaNYahRiCz4ngExf/XMbTVjxNN6Z1/6K8b89d2EZBClxEaiWNqp92bnzBPLK9b5XzOFd0CHwSTjIbdwVxVL6Ned4gKtRkvOl3JztdRQerao1mCfKt0TfaW6JI4LEHJc+zWYwvAeyk2XGu8WN/kdVDhlHAJgon3nFHhUYee3ZFv6A4SmsGFnJGfSAyi7xdpl+4qUwcFITQniHQXvK2u34czpJo/4W7glKODjLpLUoq463q3MWKrm/Xvde8ejZ+YgT40UJWULKqjjEee3obPFmDupjbcqOEAjDuZTmtv19F84Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8WgnoQa5k2MmpiEzheXUM5Sx8p7XFAqltz3BMUamEQ=;
 b=DEk027dHZQQWIqkNgkz8Sj3FmkPZewFspmCWiCniHVMABHaSw2L+Rdj6YuR7gbWRhq9Aka23F87LP0LDkumnvpHmvFsFgMMEnw/2h2ofW6Akl8CA6K5GMeC6ZaXocwr25AwbScxi4X/e5Y9GnomgKT1++X7lpy+z8By31GTw9OQ=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 19:49:19 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c%6]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 19:49:19 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     John Stultz <john.stultz@linaro.org>,
        Felipe Balbi <balbi@kernel.org>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
Thread-Topic: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
Thread-Index: AQHXMkWV7LsE5m94VkyJIYRuvRhHs6q29zcAgACUfoCAAALsAA==
Date:   Fri, 16 Apr 2021 19:49:19 +0000
Message-ID: <2a990344-8d57-2ab5-b5c5-3e6b43698f93@synopsys.com>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <87zgxymrph.fsf@kernel.org>
 <CALAqxLUQn+m_JsjVrMSDc+Z=Ezo3jDD1e22ey7SZsruoEfQLjg@mail.gmail.com>
In-Reply-To: <CALAqxLUQn+m_JsjVrMSDc+Z=Ezo3jDD1e22ey7SZsruoEfQLjg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcb30663-2a82-44e9-e285-08d90110b99d
x-ms-traffictypediagnostic: BYAPR12MB4791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB47918EC1760A1FF6AAE9F8C6AA4C9@BYAPR12MB4791.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ou/wDPK9HrR3v36VqQxc27+5v5lyseZFKdpMzbUFoxF3wQICn1bEHd5MEy4cWIbzQhAJ8h1hvreBOE1aRHygR682NjDkNHrgvpI361sadg6Uq+MMkgqBKQMQJczP8/CdMyYpb2PB08fbZy5g6LCkdva/jQO380tI0B19R9+ye3dc7GvoH0l40jhO3VxDSyZjCI5sCl61zwe0jX16268eVhAvMF/yqGWmZ3xS5rv6fOVTlH0mrIdZRg4hvNzk6c22VPSJzL1gCT7BxmMIDoKWp1CRmW5A9i38+/5F/VeG3AriByco1aEYSOiGOf4oNspETPeG0dYe/EGXIzYQ9XfjX9J7I7bKTdGTdF0ZPqXxncJLxjNRm63/Hq3UNDAdEEFtGoOO3Z0ooLJL3rybY84h3ml7Kq436MRTAh1jg/jn1ptw6gaOlycKZIpF2g4A+HvoNswcn0fM6doMipZbPl2F8VziHcd8DcdZ6ca3MwTLB5z8ht4cmd3yogF9QZSUIKIb/4BB/mLXClmshLIQKr6OteUgJxpWwuB7uvtr6fjXkayDwz8LPJXir9Z/wR1V23Awd+1eqJIol6ATlaRZEmhJomtaUaPFReK6Q8IB9SMEUxcT1tfT08euSUp+PqW30cS35jA1PMNA20oboWdxN/5bNECjja8+IKiah+4m5zoPuIngz0eU+ShBddDnFUbyNDrdSAREYm91ZgxW3j72h32QRtvkjnK3RgSSvVqWrAGdAigXGB47ViBBCrlDIAu5vrPxIS2EvSWoEXWiq42wgR2nrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(346002)(376002)(39860400002)(53546011)(2616005)(122000001)(2906002)(64756008)(31686004)(66476007)(5660300002)(6506007)(66556008)(66446008)(38100700002)(76116006)(36756003)(6486002)(86362001)(83380400001)(71200400001)(8676002)(316002)(6512007)(54906003)(8936002)(4326008)(966005)(186003)(110136005)(31696002)(66946007)(26005)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bUc1MUcyMVZpeDRxOW9UL2hrME91VHZmUVRQSjdmSmdwbFBmbHNOSysydjdC?=
 =?utf-8?B?c2pBSjJJM1l0Sy9yNzNsTVBLdDVmMjRxRFFlSTlVcUxIOEN4RlM3ekVFRnp6?=
 =?utf-8?B?SkI1dk5DRnRWM3ovWVNMWUVrVE1pYWhybHgzYjFYRGlPMlFOajcrTWFKWCts?=
 =?utf-8?B?cjBpMG1XdnE3LzQwakp0Y1RiVW9EWjVLOWpmWmFjYmlPSW5zbFlzbnorWFJG?=
 =?utf-8?B?NVJaeVQzOXB4RWJmV0NzU0sxa2I3WTdJK0haVE84WGt2NGFJN0gwMzZNRUVl?=
 =?utf-8?B?cC9QZkcyQWFiWUhpSERWeGdYc3M0U2x2ckU5WlZ3eG1ySThneFgzUWNGUW1M?=
 =?utf-8?B?a1JRckY4TmN3bmE1akk0YS9QT0ZEZlFkb3NQcmdoTGdDZDVNZlV4ZU5oZzJu?=
 =?utf-8?B?TVREd2t3WWd6MFRETm96TzNzWXdFUnQzZ25CN1hxMVVNbmM3S0UrOExYbjdi?=
 =?utf-8?B?MFp3bjZQRnA3dGVodVZIQkhYSmdnSENyc0VqVkY1aWhFNjdHNUJjSGgzQ29B?=
 =?utf-8?B?eWEyZlhHdlNZblhsQk5RRFY1MG55TUlOMGtRT29PSUovOXJ6MGJrMXZFcnRI?=
 =?utf-8?B?L2paSktXd3V3bU1JY05sNWlydWxwRzAySkNlcU05L2FuVTVvZXdGSFlhSG0v?=
 =?utf-8?B?WnkxK1pEZFpUcW9NOEluKzFqYUZIeUpSbHo4MWRTaVh2SDhwazlnaGtZeXQ2?=
 =?utf-8?B?TW00dFhaOExrWHNxM1V1YS8ySDB0akx2Y0VJQkQ1QUJ6SkVNVHBoejdzT3FN?=
 =?utf-8?B?UGQ1RDBQeU5NU0NFS1NGWThPbzhYK210UERrUWFNQVNpdDVtY3Z4ZUdGTjVE?=
 =?utf-8?B?REpwOFNYcTNKZ1Y4OHFWL3FNNGR6Ujc5SmdwTFNYMnVLT3UrZjhKVnJ2OERM?=
 =?utf-8?B?eHA0YlVsMXB2V3NmeGpzN2wzQUJJeW1VSXFRNzhCK3pXalN4UzBXTW9pQjZP?=
 =?utf-8?B?dVNiZ05Td1dKSzUwckxSNitUOWVtOGNaelhLYjNiWDl2ZkV1UmxzVWNQeS9Q?=
 =?utf-8?B?dHZKTHN4TUYxQVIydmxVaU5BMnYyU3oyUlhtZFJsYi94Zm95M0hDV2lwTWRl?=
 =?utf-8?B?UnR6YjJxQ3dMSXhRR2ZsMlF3NnE5cHVyMlpFYkRoR1BpMEV4QXV4RzF0SlN4?=
 =?utf-8?B?aVM2Zi9QaGZ0bHdhWTdERHZFT2JEWGxiUCtXaC9ERXhvQk5QWEVMQjVYcGdO?=
 =?utf-8?B?NGhzUUxlRWF4eXlXU09aMEM1YmlXT0RkblFqdnYzSEtVN2twOEczV21GR1dD?=
 =?utf-8?B?TjF4S0s4VyswZkZhc093NXRNejdBRXlGZ2I3ejJnM01OU0k2N2h0QUN6QTVK?=
 =?utf-8?B?UlNYUEdjdm9LcmlONzRFZ1VWMFBRTStaNHJiZnN2eVhWZFlNb0VlU0dLRjRx?=
 =?utf-8?B?bTJPZFJhbW54V0FtWXd3LzhyUG5tTFFlUjFjclVGQVgybGxUcmVVbGdXMzE3?=
 =?utf-8?B?ZXBXOXIrVGJjSFFxbFB0UWU3UHJVNjlHRjRDaDl2NFgyVHJsczEwVkEybU1R?=
 =?utf-8?B?SFdXOWprWDMybjFWMmR5SFU0MmltSFV3WWF0TUVOSW4vVVEwZkM0MVpkWWNR?=
 =?utf-8?B?ZTNDb1NWVXRvUkEzNVI1SEljM0poYkdTZUpWOU9VOTdTOEY3R0JBdWZFQ1lC?=
 =?utf-8?B?Vm9MVUtSU2VpQXo3bStaNWdSM3R5NU5pb3RPSGhDM0JvWHZSbVNkNEEvSXgv?=
 =?utf-8?B?bTlUbXZrN0JZVjcrYzJpdjZYemZNSHFmbzY1SFZEZVo3RXFpYWNyNHR1d2Fk?=
 =?utf-8?Q?L5RDyPaN/+Ymj74mNTfoVSrpVCrkoNCsigd9ii6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <77099DE37C0B5142A313F105E987EC40@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb30663-2a82-44e9-e285-08d90110b99d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2021 19:49:19.2663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yfq4FmoxHLK57ILEAMlx/YQ4cH2kb9yi8xaSv//R28ufqmm1YiW83mPx7tkS7cEloYs8x/xXwEP5AvgVRLFpKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4791
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sm9obiBTdHVsdHogd3JvdGU6DQo+IE9uIEZyaSwgQXByIDE2LCAyMDIxIGF0IDM6NDcgQU0gRmVs
aXBlIEJhbGJpIDxiYWxiaUBrZXJuZWwub3JnPiB3cm90ZToNCj4+DQo+Pg0KPj4gSGksDQo+Pg0K
Pj4gVGhpbmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29tPiB3cml0ZXM6DQo+Pg0K
Pj4+IEZyb206IFl1IENoZW4gPGNoZW55dTU2QGh1YXdlaS5jb20+DQo+Pj4gRnJvbTogSm9obiBT
dHVsdHogPGpvaG4uc3R1bHR6QGxpbmFyby5vcmc+DQo+Pj4NCj4+PiBBY2NvcmRpbmcgdG8gdGhl
IHByb2dyYW1taW5nIGd1aWRlLCB0byBzd2l0Y2ggbW9kZSBmb3IgRFJEIGNvbnRyb2xsZXIsDQo+
Pj4gdGhlIGRyaXZlciBuZWVkcyB0byBkbyB0aGUgZm9sbG93aW5nLg0KPj4+DQo+Pj4gVG8gc3dp
dGNoIGZyb20gZGV2aWNlIHRvIGhvc3Q6DQo+Pj4gMS4gUmVzZXQgY29udHJvbGxlciB3aXRoIEdD
VEwuQ29yZVNvZnRSZXNldA0KPj4+IDIuIFNldCBHQ1RMLlBydENhcERpcihob3N0IG1vZGUpDQo+
Pj4gMy4gUmVzZXQgdGhlIGhvc3Qgd2l0aCBVU0JDTUQuSENSRVNFVA0KPj4+IDQuIFRoZW4gZm9s
bG93IHVwIHdpdGggdGhlIGluaXRpYWxpemluZyBob3N0IHJlZ2lzdGVycyBzZXF1ZW5jZQ0KPj4+
DQo+Pj4gVG8gc3dpdGNoIGZyb20gaG9zdCB0byBkZXZpY2U6DQo+Pj4gMS4gUmVzZXQgY29udHJv
bGxlciB3aXRoIEdDVEwuQ29yZVNvZnRSZXNldA0KPj4+IDIuIFNldCBHQ1RMLlBydENhcERpcihk
ZXZpY2UgbW9kZSkNCj4+PiAzLiBSZXNldCB0aGUgZGV2aWNlIHdpdGggRENUTC5DU2Z0UnN0DQo+
Pj4gNC4gVGhlbiBmb2xsb3cgdXAgd2l0aCB0aGUgaW5pdGlhbGl6aW5nIHJlZ2lzdGVycyBzZXF1
ZW5jZQ0KPj4+DQo+Pj4gQ3VycmVudGx5IHdlJ3JlIG1pc3Npbmcgc3RlcCAxKSB0byBkbyBHQ1RM
LkNvcmVTb2Z0UmVzZXQgYW5kIHN0ZXAgMykgb2YNCj4+PiBzd2l0Y2hpbmcgZnJvbSBob3N0IHRv
IGRldmljZS4gSm9obiBTdHVsdCByZXBvcnRlZCBhIGxvY2t1cCBpc3N1ZSBzZWVuDQo+Pj4gd2l0
aCBIaUtleTk2MCBwbGF0Zm9ybSB3aXRob3V0IHRoZXNlIHN0ZXBzWzFdLiBTaW1pbGFyIGlzc3Vl
IGlzIG9ic2VydmVkDQo+Pj4gd2l0aCBGZXJyeSdzIHRlc3RpbmcgcGxhdGZvcm1bMl0uDQo+Pj4N
Cj4+PiBTbywgYXBwbHkgdGhlIHJlcXVpcmVkIHN0ZXBzIGFsb25nIHdpdGggc29tZSBmaXhlcyB0
byBZdSBDaGVuJ3MgYW5kIEpvaG4NCj4+PiBTdHVsdHoncyB2ZXJzaW9uLiBUaGUgbWFpbiBmaXhl
cyB0byB0aGVpciB2ZXJzaW9ucyBhcmUgdGhlIG1pc3Npbmcgd2FpdA0KPj4+IGZvciBjbG9ja3Mg
c3luY2hyb25pemF0aW9uIGJlZm9yZSBjbGVhcmluZyBHQ1RMLkNvcmVTb2Z0UmVzZXQgYW5kIG9u
bHkNCj4+PiBhcHBseSBEQ1RMLkNTZnRSc3Qgd2hlbiBzd2l0Y2hpbmcgZnJvbSBob3N0IHRvIGRl
dmljZS4NCj4+Pg0KPj4+IFsxXSBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGludXgtdXNiLzIwMjEwMTA4MDE1MTE1LjI3OTIwLTEtam9obi5zdHVs
dHpAbGluYXJvLm9yZy9fXzshIUE0RjJSOUdfcGchTDRUTGIyNU5rcTBERjJxckNQV1cxM1BVcTRp
ZGhEbjVRU1poZ3ZuVkF5N3dKaVlGT1NTb3VTcHR3bzluT3pJZFBENGokIA0KPj4+IFsyXSBodHRw
czovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtdXNi
LzBiYTdhNmJhLWU2YTctOWNkNC0wNjk1LTY0ZmM5MjdlMDFmMUBnbWFpbC5jb20vX187ISFBNEYy
UjlHX3BnIUw0VExiMjVOa3EwREYycXJDUFdXMTNQVXE0aWRoRG41UVNaaGd2blZBeTd3SmlZRk9T
U291U3B0d285bk8yMVZUOHE3JCANCj4+Pg0KPj4+IENjOiBBbmR5IFNoZXZjaGVua28gPGFuZHku
c2hldmNoZW5rb0BnbWFpbC5jb20+DQo+Pj4gQ2M6IEZlcnJ5IFRvdGggPGZudG90aEBnbWFpbC5j
b20+DQo+Pj4gQ2M6IFdlc2xleSBDaGVuZyA8d2NoZW5nQGNvZGVhdXJvcmEub3JnPg0KPj4+IENj
OiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4+PiBGaXhlczogNDFjZTE0NTZlMWRiICgidXNi
OiBkd2MzOiBjb3JlOiBtYWtlIGR3YzNfc2V0X21vZGUoKSB3b3JrIHByb3Blcmx5IikNCj4+PiBT
aWduZWQtb2ZmLWJ5OiBZdSBDaGVuIDxjaGVueXU1NkBodWF3ZWkuY29tPg0KPj4+IFNpZ25lZC1v
ZmYtYnk6IEpvaG4gU3R1bHR6IDxqb2huLnN0dWx0ekBsaW5hcm8ub3JnPg0KPj4+IFNpZ25lZC1v
ZmYtYnk6IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVuQHN5bm9wc3lzLmNvbT4NCj4+DQo+PiBJ
IHN0aWxsIGhhdmUgY29uY2VybnMgYWJvdXQgdGhlIHNvZnQgcmVzZXQsIGJ1dCBJIHdvbid0IGJs
b2NrIHlvdSBndXlzDQo+PiBmcm9tIGZpeGluZyBIaWtleSdzIHByb2JsZW0gOi0pDQo+Pg0KPj4g
VGhlIG9ubHkgdGhpbmcgSSB3b3VsZCBsaWtlIHRvIGNvbmZpcm0gaXMgdGhhdCB0aGlzIGhhcyBi
ZWVuIHZlcmlmaWVkDQo+PiB3aXRoIGh1bmRyZWRzIG9mIHN3YXBzIGhhcHBlbmluZyBhcyBxdWlj
a2x5IGFzIHBvc3NpYmxlLiBEV0MzIHNob3VsZA0KPj4gc3RpbGwgYmUgZnVuY3Rpb25hbCBhZnRl
ciBzZXZlcmFsIGh1bmRyZWQgc3dhcHMuDQo+Pg0KPj4gQ2FuIHNvbWVvbmUgY29uZmlybSB0aGlz
IGlzIHRoZSBjYXNlPyAoSSdtIGFzc3VtaW5nIHRoaXMgY2FuIGJlDQo+PiBzY3JpcHRlZCkNCj4g
DQo+IEkgdW5mb3J0dW5hdGVseSBkb24ndCBoYXZlIGFuIGVhc3kgd2F5IHRvIGF1dG9tYXRlIHRo
ZSBzd2l0Y2hpbmcgcmlnaHQNCj4gb2ZmLiBCdXQgSSdsbCB0cnkgdG8gaGFjayB1cCB0aGUgbXV4
IHN3aXRjaCBkcml2ZXIgdG8gcHJvdmlkZSBhbg0KPiBpbnRlcmZhY2Ugd2UgY2FuIHNjcmlwdCBh
Z2FpbnN0Lg0KPiANCg0KRllJLCB5b3UgY2FuIGRvIHRoZSBmb2xsb3dpbmc6DQoNCjEpIEVuYWJs
ZSAidXNiLXJvbGUtc3dpdGNoIiBEVCBwcm9wZXJ0eSBpZiBub3QgYWxyZWFkeSBkb25lIHNvDQoy
KSBBZGQgdXNlcnNwYWNlIGNvbnRyb2w6DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9kd2Mz
L2RyZC5jIGIvZHJpdmVycy91c2IvZHdjMy9kcmQuYw0KaW5kZXggZTJiNjhiYjc3MGQxLi5iMjAz
ZTNkODcyOTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2RyZC5jDQorKysgYi9kcml2
ZXJzL3VzYi9kd2MzL2RyZC5jDQpAQCAtNTU1LDYgKzU1NSw3IEBAIHN0YXRpYyBpbnQgZHdjM19z
ZXR1cF9yb2xlX3N3aXRjaChzdHJ1Y3QgZHdjMyAqZHdjKQ0KICAgICAgICAgICAgICAgIG1vZGUg
PSBEV0MzX0dDVExfUFJUQ0FQX0RFVklDRTsNCiAgICAgICAgfQ0KIA0KKyAgICAgICBkd2MzX3Jv
bGVfc3dpdGNoLmFsbG93X3VzZXJzcGFjZV9jb250cm9sID0gdHJ1ZTsNCiAgICAgICAgZHdjM19y
b2xlX3N3aXRjaC5md25vZGUgPSBkZXZfZndub2RlKGR3Yy0+ZGV2KTsNCiAgICAgICAgZHdjM19y
b2xlX3N3aXRjaC5zZXQgPSBkd2MzX3VzYl9yb2xlX3N3aXRjaF9zZXQ7DQogICAgICAgIGR3YzNf
cm9sZV9zd2l0Y2guZ2V0ID0gZHdjM191c2Jfcm9sZV9zd2l0Y2hfZ2V0Ow0KDQozKSBXcml0ZSBh
IHNjcmlwdCB0byBkbyB0aGUgZm9sbG93aW5nOg0KDQojIGVjaG8gaG9zdCA+IC9zeXMvY2xhc3Mv
dXNiX3JvbGUvPFVEQz4vcm9sZQ0KDQphbmQNCg0KIyBlY2hvIGRldmljZSA+IC9zeXMvY2xhc3Mv
dXNiX3JvbGUvPFVEQz4vcm9sZQ0KDQpCUiwNClRoaW5oDQo=
