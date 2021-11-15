Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FDF45196C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 00:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhKOXTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 18:19:43 -0500
Received: from mail-dm3nam07on2080.outbound.protection.outlook.com ([40.107.95.80]:39521
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243887AbhKOXOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 18:14:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKJmKfCemROh/UDp0Gup5VLRXs0vsrmPbfOfpVblUcSfgXQqGYi2KSBPg0BDPMIg759tgwwKCfcpsMNlgRBCBqN60c6IcTYatN6FarA6OkDhfqqLzBU7B7G7GxslHlV/aF0BxtrAhqWKsAG42x4D1W0ZvQ+kwDcYCcgETBghvUhDWWdYxU04hQes/azN3rQzMZtiX9BqY852ZaoNfS2wmiJQzCMGCcM9ZYVhxQwUMNdG8sqQaqObW3vqEGCvmC4LvyIBL3bzKWY6PYrADQanfU4WHlfVWiMyvPAhK0a/LxgGEfsH03DX0G06RNTeeM37OYOKpsZXR2rRwhgvW4o+aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yf67nU13k/0OpAKTbW6EYjgq6OX7l8a8ZIT8sEVt0DI=;
 b=DdNkOwQlMKYMXHvYmKddysZPpR4TZvGI2MuyrViD/LDH5s6U+gs6Ia1sH5A6zwnfIwoqoUBYg038g0P+pHZHFH+IfhjnCMcuGp69pKVgUyw3VV+A6kliWPobhVy8dFeaqwseJq71cfIoFdp6XQ8WS0jdJiJWUO39E0SerzEQxRvc6uw0+ZmS95giH26Qgd4Z16iqsJz9wgq0gZX/Bc7qhzYGHM9Qmv//3PGUMpiapn3ZVxCY8+a+MZJ0rH73wc3sqpz2sFYJ/nVBrVvxJcPTx+3aDw5yL9dvAju5N4UyzR2Wcujz6ROAG/5aJcujyKTjRiiB6D8gzJmJiN6UxuEw3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yf67nU13k/0OpAKTbW6EYjgq6OX7l8a8ZIT8sEVt0DI=;
 b=NpWHRxirQ8cwtT+Is0ZknF8gP3JOBCCTLfgcs/217UiSdpYzYG+H5ZvwcPAOOJXX6q31Xs2R9VCGgpwifbTIkj5ByDdKCWhKk7/F1hNesmPT6mgE6q9Oxu/QRXYi7VqZizVmBb9wTgU5TPjZ2/iPtsb+wqucRB5d6WCmQgjcUZE=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MWHPR05MB2912.namprd05.prod.outlook.com (2603:10b6:300:5e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.16; Mon, 15 Nov
 2021 23:11:45 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc%4]) with mapi id 15.20.4713.019; Mon, 15 Nov 2021
 23:11:44 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     Michal Hocko <mhocko@suse.com>
CC:     Dennis Zhou <dennis@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Thread-Topic: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Thread-Index: AQHX1OJIWPaykZv/p0er2gRbWiPNoav64CoAgAABpgCAACaDAIAFMc8AgAQ2uwCAAAZtAIAAH/AAgACrTgA=
Date:   Mon, 15 Nov 2021 23:11:44 +0000
Message-ID: <ABEDED57-93A9-4601-8EB6-2FF348A0E0BB@vmware.com>
References: <20211108205031.UxDPHBZWa%akpm@linux-foundation.org>
 <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
 <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
 <YYpTy9eXZucxuRO/@dhcp22.suse.cz> <YY6wZMcx/BeddUnH@fedora>
 <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
 <B8B7E3FA-6EAB-46B7-95EB-5A31395C8ADE@vmware.com>
 <YZJZes9Gz9fe7bCC@dhcp22.suse.cz>
In-Reply-To: <YZJZes9Gz9fe7bCC@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd3f982e-8cfb-448c-bfe5-08d9a88d4ada
x-ms-traffictypediagnostic: MWHPR05MB2912:
x-microsoft-antispam-prvs: <MWHPR05MB291229AD0383FCB620E9027FD5989@MWHPR05MB2912.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oaGzQadzjs7U7VirW8gDnYs09zDcMLi1QGobnNKS8pdbm8tjPryC4wSEyrrMu0afWR7U8SOleQ2EhOqBJ/Pl3uwBIA66qRPdcTINYd6wAkzVaevZAU3J7sNQIEJ2/GLEMQ8YE+wsMFGtm573XXM9b+oNoE4dL/9Exf0D3GSvRBjPUzyCrjvVdILDUCl3AJg0Gthyj7MsLEIm5eB3idTnhHpnAbL6YdaulJmQLC3fdnVrQrxIRo+fRbHhKhL53Dr6tend5cylUpqi6vKHPnJBTpzLPch6mt+5zmv9+NErdaK7Xsx4qdfaX5I1lYikHaKcWtuKd0fmml9WsViEUFLVDY7tJ4Z3k6VLH+8FuDq/yw2CaLWD6/q94Iz94lZWu0tYqKFWM6MOq4s5IXABgHcZGtPbSGjNDNdlrAG7w20KiYdkGTU++VJuiEQB/TwLFHqYRLoFFRKgiYy818+ayEEUIiQb7WVFA0RxRdOw3lrVkfYi9Ai67cY0wu5qc0w12CirymkUreobXVss1ly7tXDPSPrda35Z3QjAMgb4uvHX/lS0aJRLiHevXaE/q0AqkcIduiCDBuQBR7lhllU/hJd0pe/MOyrED2TcebdyhHMqBQ1t6jwfaySX2K93Ljyp3RDSH+phSuMs7TOpIDQdpHINctA64TKevCN7JemOwKtTrrSjkrAThz8K954juxxlFihwjFxfThDfjxjfgt24kd7y/BEfyv4KHUR0l4irQY8yQa/65zunIV3QUxT2yyravRic
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(316002)(4326008)(6486002)(5660300002)(186003)(54906003)(6512007)(36756003)(2616005)(6916009)(33656002)(71200400001)(2906002)(26005)(66946007)(66556008)(66476007)(66446008)(86362001)(8936002)(122000001)(8676002)(38100700002)(53546011)(6506007)(99936003)(83380400001)(38070700005)(64756008)(91956017)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDBPVFVOV25WSzBWVWlTbXo4ZkFBMFRQVEVOTjg0RDd4dFFxVWlJTE85SUlo?=
 =?utf-8?B?MVlPRFBMTmhDNGZtcm5XZm5ta3diUlcxSnFReUF2bVV4WFN0YkVPcUlNbjc4?=
 =?utf-8?B?ZWwrUWFUcC8xRDZYcm0zelEzUEJheFNtaWE0VEhNRHdKZ05MTDRlY1hTNFIv?=
 =?utf-8?B?WCs1aXpvV0Q1eGxyRUM0OVFqazZUajc1NGZ2L2VKcXZob1YwZGVYK280L0JF?=
 =?utf-8?B?WVhOeExyeW5uT1k0Vkdob0NBaGc4aldRY1Z5cHpGMTlqZ3l3dEczLzJnQVVK?=
 =?utf-8?B?cVV3M09BcTJubUxTbFJ6N0xhT0MvNWlvV2RJTnFicUdyOHFCT0sxNm9vS1hN?=
 =?utf-8?B?blFxa0oxWTZXRlpabmFSMUl5d0lqR0lRK2Jtemk1ZmlRVy9NYVVQamdscG4v?=
 =?utf-8?B?VGJQMGVSYjR1Ri9YSEJocTJ1NTEwQWFFdURoNDZ1dTRVVnEwMXhWOWRMYndQ?=
 =?utf-8?B?Vzc5bkJlS3RRZlV4aExhTDgyeEE1Ti9Kekk1WDI5cEl4TUdpUHpYNEJmVzN1?=
 =?utf-8?B?QzFDSWJsS0ZPYTIwam13RjQ2M1ljQWEwYkQ1WHlFbzlBL1VMaHRJNHAxWVZj?=
 =?utf-8?B?NnNyNzBEaHlSNDAvUFk3V2pUNnZtaXVKZm52QVhGa1RWVkl3M245NmxSU1JD?=
 =?utf-8?B?NlBPZG5zVldCZDd6QSt3dDlLTlVKUm9WQnpUKzZYWWFWTUdJcFlrYXJSOGMx?=
 =?utf-8?B?MlBTeFA2a284b0UzRzRMVXJ6RlNsSEVCVlFYdE1ubEx2aGhFQWxvVXFrbTlm?=
 =?utf-8?B?MUxJTnZwd0ZJc3A5WFJ5RWNWSlNhQUVjQ1VQcHpCN0pPbFlvZ1lVV2JuMkZF?=
 =?utf-8?B?Y3FvLzRpck1oUFFrU1Q3NDVod21RZkE1QzhCWTBGTXF5M2NwbStpUy9xbG81?=
 =?utf-8?B?WjYxTGtweGllZStTT01jaytlcmJlRXNUUmhHTnN3K1BpN3J2ekhlOGdib2dn?=
 =?utf-8?B?dXA1RlV2MGZSMGZlaXljWVN3SEtkS3VEOXZBYVAzbW1FaHdEY2dVNDRqNHhC?=
 =?utf-8?B?RXBTVUFPRkJuZG5ZYUxPMm9HK0ROMVlIR0QrQmlDZkJRZU5rYVRkVkpWL3hl?=
 =?utf-8?B?YzZ2bVU5VGRXY1lwR1k4OUNNMW0vNnZodWo2RkZSWFlOQ3FEeTZRS2RUSlhY?=
 =?utf-8?B?T0ZJU1JSL0hWQTdYYUttYUFNazFQbndjWWJZY005dnVUbFVjL2NCZ2NhOEg3?=
 =?utf-8?B?bUZ6Wk1VaXJMbS9IdkRoVEd4UHFHcndGaGxDSWxKMVh1bHVwbVM5UjhscDVU?=
 =?utf-8?B?bnlVTUpuYWFTWU50TDhLbGRTcmJNWFUydkw5SHVDTjdFa0xhaVl3WElGd0VU?=
 =?utf-8?B?UEpFZEg0RzFPU0xiS3lRSm1IZkV5ZmRNMmtOdU5hUURHaUJrR0MwS2s5QnFw?=
 =?utf-8?B?Rkh1amJrb3NBckE2SzR6U2JGTkJFTGxHSTBkd1FaS0pZMFpvU0hUOEtoZ0xl?=
 =?utf-8?B?SENjS1o4bXYyN0NneHE3dnk4QWNONmswdm9JYi9vUTkvYTJpMW52cmJlSkhP?=
 =?utf-8?B?Q2lMVE51Z0xXYWQzUlE2S1hWSGIwaHBTTURiOUw4Q01HQkg3ZGRxRHZuQTVI?=
 =?utf-8?B?UytBdjRmc1dwb1B0MVB1aE9kZVk4ZEtLa2IzbWJFbXdsMGpibVhRaHNqVEZq?=
 =?utf-8?B?NUdVL3YreEVhK2dYUzNrTkd6ZVM2Z3B0cFZ1ZVY2U2pXbXMrRm54NnhmaDJ5?=
 =?utf-8?B?a3l6V2VpaU12bmE0U2phc1JOeW1WZytjVVJjUis4WVJZN2VVY0lPdlZqUmdt?=
 =?utf-8?B?ajIrV1VhVnF2ckFkQzVZeHlNQ3ltYUFKcmlPek10NlpVSmhGWVJmd1VVUjdH?=
 =?utf-8?B?cVlGWUtZQW5lMDZQY2xseXNJSk9TRjNaYUxaTUc2V0djdVROazR4bDU5Z09K?=
 =?utf-8?B?TW56Ny9jdnJ6aVRDSFF2LzZ2cUhrcTlRL2hITi9sd243YTQyTEduN0FXam8v?=
 =?utf-8?B?MHg2OXVWN0FoUzgwK3ErNTJUbllYMHFLMXFCMzZYcmY1WjV0NExwU1VkN3ox?=
 =?utf-8?B?bld2azAwTUxCMUFEaXJ5U2toeDdjeGFLUFhXd3F0OWk1bU1JeG9sK0ZKOUZW?=
 =?utf-8?B?OFkwR3pyb3hiUEhtUTJiMWVUVWE1TS9Wc25Pbzk0cngyNHhpRkttYU9uMUNO?=
 =?utf-8?B?SjZWYlM2NXBqL0xLYmJab3ZMUDVKSzNjVGdSOFRHelR0c24vTVBQNkQ1TWRB?=
 =?utf-8?Q?hgfM74nnuMSYS8XPZ7gXwvk=3D?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_17253C17-922B-47FE-9B99-8091489708FA";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd3f982e-8cfb-448c-bfe5-08d9a88d4ada
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 23:11:44.5493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aDb/nNFxk2uvF3qYAyZ3mdJCbaHREfDih7oxG8YVa8oHOJ5tIQmk/ndY6xMt9zfEBmY2A4fOov1R4IscepQsIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2912
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_17253C17-922B-47FE-9B99-8091489708FA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Nov 15, 2021, at 4:58 AM, Michal Hocko <mhocko@suse.com> wrote:
>=20
> On Mon 15-11-21 11:04:16, Alexey Makhalov wrote:
>> Hi Michal,
>>=20
>>>=20
>>> I have asked several times for details about the specific setup that =
has
>>> led to the reported crash. Without much success so far. Reproduction
>>> steps would be the first step. That would allow somebody to work on =
this
>>> at least if Alexey doesn't have time to dive into this deeper.
>>>=20
>>=20
>> I didn=E2=80=99t know that repro steps are still not clear.
>>=20
>> To reproduce the panic you need to have a system, where you can hot =
add
>> the CPU that belongs to memoryless NUMA node which is not present and =
onlined
>> yet. In other words, by hot adding CPU, you will add both CPU and =
NUMA node
>> at the same time.
>=20
> There seems to be something different in your setup because memory =
less
> nodes have reportedly worked on x86. I suspect something must be
> different in your setup. Maybe it is that you are adding a cpu that is
> outside of possible cpus intialized during boot time. Those should =
have
> their nodes initialized properly - at least per init_cpu_to_node. Your
> report doesn't really explain how the cpu is hotadded. Maybe you are
> trying to do something that has never been supported on x86.
Memoryless nodes are supported by x86. But hot add of such nodes not =
quite
done.

>=20
> It would be really great if you can provide more information in the
> original email thread. E.g. boot time messges and then more details
> about the hotplug operation as well (e.g. which cpu, the node
> association, how it is injected to the guest etc.).
>=20
I=E2=80=99ll provide more information in the main thread.



Regards,
=E2=80=94Alexey

--Apple-Mail=_17253C17-922B-47FE-9B99-8091489708FA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEQe6bu7hIFElmsM7CGW4w8WwwaSUFAmGS6S8ACgkQGW4w8Www
aSXetQ/+PThbZZNiK7Yn9v7Tgc8pS1HiraJ6iph92TDHHOJRTPamEa/ojF2qI+h5
w910OGgDuH3PpHeC7kkWo59V8pUDCS+W8tplZaK36vjR0lJIV2vv145xOiJNaElA
Ff2nB1oNpqwsiyhUNNZ44W+e5uP8v3Mxtd1JDIxVoKs9UWXHRLPbG9MX+mDiU8RB
i4BLn9l31nfJ0Nwjo3IhfvdDYYyeAm1fM2jjn1p27JkGh5BfkHKVs6AGvQHQqIwD
nidVZPM3BM3f7QTfM299jKw0y11MC2mrR9PR+ti30mbCvQuYdppGcBXLEp/iSQQk
X7Y/Hs1ePVK+SMtxoA3ZJKs4MD1/DQi2oV8yllEHN/iE05cxPUGJ5OwnJg8evEvg
b33aJEo9Mbdtn4U5pnz267/eXcLoWjseJ2xX6fhH48b4y2a9MPp1CGNyZnXza99Y
patBCzNpN+hqopNWC3z9H1MgCi/fahkutYF0P/v6y3umCcm6F4LjUeo1rpZgOrAh
TH4TcHxwEksk3Jt+ddj8Q0qF0O0QI98Z+I8TbEJm3D8tDh5VYaRPAXZuzSGNKYNH
4pTFF10sYY8Jc5amC1Rnv0KUHS8BHYngPX2PHcVmiyxnP6V3zV2VnSUxuzXphldK
ZaAX4O7BZg85i4qDTkC9E9xoUsGAD/Sbh/CkmgDnargsdsDQNfY=
=z1E1
-----END PGP SIGNATURE-----

--Apple-Mail=_17253C17-922B-47FE-9B99-8091489708FA--
