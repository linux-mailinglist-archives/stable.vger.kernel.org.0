Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8507327175
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 08:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhB1Hmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 02:42:40 -0500
Received: from mail-eopbgr1310117.outbound.protection.outlook.com ([40.107.131.117]:3200
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229941AbhB1Hmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Feb 2021 02:42:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqXKJHb/AKBgzdhYWrQaANpDNGpWOlW0hCppojAwCDcLuG2DTPnwbGjNC4tD5pDOkkbojgM10RiEFA228x1O/DDS/3HE3tasEjukZQ8rutCRWVv0PlXEHpQAYnDJu0ZuWJksh/82c8HIBUH+dNNbavRV51qfdcJy2Y9ifnjau92KwNtdc0qC3S2yACjaSljU2NwQyUhOLdbO0Z6jAS2rZIy3LYyHXgjdjy2+sWD6tztk+N1B30/gLAdiZCQygCTR1ixyzM96dR+xxcECkXECIrfFjlZDkoWBqr3QS3KHszlMeoQMD/PwQiFOwJWgKC26rH2wS27ITvoGwmOrncZgfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HbWNB4HHT/e+pHWmlbmdg9xBQLk+mNUr21HedsgmTN8=;
 b=E4RJVSqGZxFEG9OIQy+F8KJ6ALt0WySa7NS56EnSLSaQ/+P7Em4TUyGHTEh8KL0+XgApTHBEMiXPoAuZesEQMH9kLh2zUIW1m435nnhRTxRfrO20Rn1zMfMZI0IAZ/EwNJpzTmQwTtoVsXtBY/NQGSna0YK/p2WX0XtkKrlDC6i+1ailn8nJE5e/M11OZD4rs8+XvD3KVvDXCsT3gxMTUqAbjBYXskuhTb+V7RoJxqNmedq3DF96aDkpZ4QUp6cD4qQdQytkAp9bVft24XBg3e+9SdDZdKx1XQSFB83zz596UFLkaeDrlZ/e8rH62z9FOTs2Gth62YTCVMcdPccObA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HbWNB4HHT/e+pHWmlbmdg9xBQLk+mNUr21HedsgmTN8=;
 b=WkcvHXl2asR4Pcf//QMMnBG29//YHPUgOav2XGy9k3EIxkFoaEkFjD6X+AZspOxnaUDqeQ6DEap1rHItMHelJB2PY/SC5Xm90j3MSq0y+lxMomRe72E/C5FNzWmgOVVlKLFT0LkwaLKSaY2Fxr1LlvGFkvT7elXQ/QDc6gI1/nk=
Authentication-Results: flygoat.com; dkim=none (message not signed)
 header.d=none;flygoat.com; dmarc=none action=none header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (20.180.89.13) by
 HK0PR04MB2370.apcprd04.prod.outlook.com (52.133.147.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.23; Sun, 28 Feb 2021 07:41:02 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c%6]) with mapi id 15.20.3890.028; Sun, 28 Feb 2021
 07:41:02 +0000
From:   <yunqiang.su@cipunited.com>
To:     "'Maciej W. Rozycki'" <macro@orcam.me.uk>,
        "'YunQiang Su'" <wzssyqa@gmail.com>
Cc:     "'Thomas Bogendoerfer'" <tsbogend@alpha.franken.de>,
        "'Jiaxun Yang'" <jiaxun.yang@flygoat.com>,
        "'linux-mips'" <linux-mips@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20210222034342.13136-1-yunqiang.su@cipunited.com> <CAKcpw6UgEUUCG2=9E9KFpTYF23fWshdcFtmB_O+YT0xEoS3swA@mail.gmail.com> <alpine.DEB.2.21.2102280217220.44210@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2102280217220.44210@angie.orcam.me.uk>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D:_=5BPATCH_v4=5D_MIPS:_introduce_c?=
        =?utf-8?Q?onfig_option_to_force_use_FR=3D0_f?=
        =?utf-8?Q?or_FPXX_binary?=
Date:   Sun, 28 Feb 2021 15:40:59 +0800
Message-ID: <000501d70da5$0ffd6a70$2ff83f50$@cipunited.com>
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHVs9luv6asI/vaDlRWq6e8G4YQSwH08poxAlShgyiqTZTjQA==
Content-Language: zh-cn
X-Originating-IP: [103.125.232.133]
X-ClientProxiedBy: HK2PR02CA0187.apcprd02.prod.outlook.com
 (2603:1096:201:21::23) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from PCYSU01 (103.125.232.133) by HK2PR02CA0187.apcprd02.prod.outlook.com (2603:1096:201:21::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Sun, 28 Feb 2021 07:41:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb81434f-7009-4196-aa45-08d8dbbc326c
X-MS-TrafficTypeDiagnostic: HK0PR04MB2370:
X-MS-Exchange-MinimumUrlDomainAge: debian.org#8026
X-Microsoft-Antispam-PRVS: <HK0PR04MB2370235B65D0673191DD5DD5F29B9@HK0PR04MB2370.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D9MEe9qaXxYgJT4VkdlldNfwr982HZyM/qnxwsj9uhG/vFmGm9Vn8ITqYfEjvuVZpfge1pv6E0LNmsq4CejgnLrLlDuqyzWRq8KWCYPmZb/DqXB2ZkhB4RUzG9jCDTZ7Q/Pzf3uOnVYyu3M65A5FZhTylWc6L+7MaIfTO6B5No0oUub3jlbIjiyGXS28taliaaVKEh1df6CHX8U8Dj1WHiahi4Db7ZfoTH/yZFnU2pYPocO2oGekQTYtPZuWRUJ8NxE0QaTrsmBG6cR0G7wWbTqN3WaiRf0o55hTBi2yMr/3bbbvWlqFLiB8vZ3FJnRyB9YAe/dLunT/+Xszw+QXCC+o+AANyeHrkjMZt/PA8Ib7OAB+wEp3I6ifLxfFE/cuVsZTTx1knDMXMjpFoLfN0zonP3LW6vNZmchMut3YjVkLaayoSMxR/vYoTn3YX0LSWe4IS0ot+0CXGoS5EH5s0yckAmq91g4SB6WJedCnpXBmdJmxS5TdYuUMayq7IndqwpbgEk8l21GfE8hX1AXJEWLcHmF4ScMhrCflajwXCwEm/vyu5AuIqdROLy/6zwQbYKFhVH06yrVGfmcNLTmDKV+EwYi0NIr04QsnsZ4EVRM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(376002)(366004)(44736005)(52116002)(4326008)(6496006)(1420700001)(36756003)(2876002)(316002)(83380400001)(86362001)(186003)(6486002)(26005)(54906003)(478600001)(110136005)(66476007)(66556008)(66946007)(8936002)(16526019)(966005)(2616005)(224303003)(956004)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V0dkSDFTNHZwQysvMzBmbDU5U0paSVd4Q0xVTmdKcmJ0OXp5bXNGVGp0NEEw?=
 =?utf-8?B?OUhMYUR1V3BiNFpGMEdQZ1JLNXFwT2JQc3hKOHhkVWxzdE1XZFZXL01XK3Nt?=
 =?utf-8?B?WjJUdnlTVm9xUmY0U2RmVDN4MTRXU2VDbVFUTW83NDh3S0syV3ltNVNnUTdW?=
 =?utf-8?B?SUNVR1ljUFRGODdlZWMvdElqVEdYR0tkZGl3YlBUOG1DT3ZMS0lvT2ZVVTBU?=
 =?utf-8?B?RjZGbjIvdHEvSmVHcXplTzNWYTNjaEpkOXFzLy9NbDkxbHVKdXlmM2g5Qkox?=
 =?utf-8?B?UGtKNmc5VExlbFdPNEMvbVVIa0U1M0JSOG55cUxmOGRHUTI5WUc3RjVVRDQ4?=
 =?utf-8?B?VkluVHNVMkdueG81djVOWDZwV1N2OHdYUEdhOHhzbFR5S3p6eGQ3UFhNdDhI?=
 =?utf-8?B?cTljOHcranRLa1hJbjB1SGdHNzhBOWVGRGhKYkVnWm1NS1dWRHBDRitIWEMr?=
 =?utf-8?B?SVNnZWpBdmJIWHJkMDY1N044RVByTVFYSFJqUk5wK25ka0JvaXg3aFFZTE0z?=
 =?utf-8?B?Z0dvOE94ZVp4LzJvdExMQzJkaHgvVWZqa2VEQllhNEZzc1BuWFp2MnRBczVs?=
 =?utf-8?B?TlROTXhCUW5LdnB6ZXdVanF5UWJCSGJHSzgzSitwOGw3eTNJNWNVRWRFK0h5?=
 =?utf-8?B?SStobXE1SHZCNFVKZnRob09iTVlnT05ON1pKb1JsUzA1ZStMaUNxS2ZFdHpY?=
 =?utf-8?B?Yk93L2kvdXFscXd3Y1V0ak1HSmtMTDVjcTdnOUpZRmRMRmdpMThiRkUvR3I5?=
 =?utf-8?B?YnYyVndiZ2srNkoxTENybXBCT0NQeUR0eDlzUWZVQmtSM1pUQjF1RlcwM3RR?=
 =?utf-8?B?bG1PUkU1Rzd5MVRacUE2NmtEZjdmQWwzZStmVTZpR1BDUHNTdkYrczBmSEhq?=
 =?utf-8?B?cEp4bjYxY0I1amxHNnNuN1I3Q0tMZ2cvZUdPZ2ZhcTZ6L1lUZXVoekFzaU5I?=
 =?utf-8?B?ODdZdEJJaXdCTnpzbmFlMnRpbkZEaEpUbGUybm1ZY3NlcWllQUN3eVZEcm0y?=
 =?utf-8?B?aGxqNWVsajhnK05CcVFkWENlYUtYR0o4bTBhdEhDSTFhUERBcWtNVWRkTzJL?=
 =?utf-8?B?SGpQalZiOGg4TWdBUEZyQ1dldFZSSjVJdkQyNWZKWWpTUWlTTWtZZHNlNUhH?=
 =?utf-8?B?THBETEl6NDgzUnFwd3gza1p4RGhtWlEyRFpWeW1iOGlhTFdOTDQwTmhNQStI?=
 =?utf-8?B?TU05cEEzMVh6bGNEbU1vSk15czNYZXdRN0ZxSEFSOWZ0N250Y291ZFROQ2FO?=
 =?utf-8?B?RzZuWGRMdjZraVhPYzArVlBLU0ljN1I0bUV4R1lvM3k3TU1neXlncVRkaDc4?=
 =?utf-8?B?VjAyN3psS2tUZXY0c3dvZlBNNjVhVnlGdDI3RDhuN0JZTVlCYTFQVXlMUVRS?=
 =?utf-8?B?T2c1S1dDNWRYV2RRQ2xPS2E4bHRrSkZ5SFRoVWpXMlpMbnd1N3JGKzlsb1VF?=
 =?utf-8?B?MklySU1ZZlptbkxtQnJMQjhjazVKc1l0TEpVOUwvVzE1ck43a1BTcEJvZnZC?=
 =?utf-8?B?VXV1UUF2Z0c0RjVkK0xNampuUk5XeGZGQ1pVWUV3R1JMNjVxY25NQ3Q5azJS?=
 =?utf-8?B?ZUJJdU1PQ2I1ZGxQc1N0Zmk2UU9XbEpzUXVhbkNhdERWcDNFL0RmMWtSQTN5?=
 =?utf-8?B?Rk9vUUE2NStINWZ4aTV3NFdHSkgzQmNNQlRjYU4yVzQ4MDR0TmhXenc0c3Iz?=
 =?utf-8?B?U1FWUUZCSGIyUDNZUXREdTZVQzFGTElTamdmZFd3aFRsQlRsK2ZDbWtWVUtq?=
 =?utf-8?Q?xfhWo18gKs7QcO0uUIjxkQjATB+X+hp0ueMlrQJ?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb81434f-7009-4196-aa45-08d8dbbc326c
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2021 07:41:02.1571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UICdPHsO30L+ioEHpt67nn3O57zDw5K2fL9TiX3qb1vVpLkBCF2/GNzAw7zR4zh7depAuNlGyOgeSHCODp2yEs7+i/Xu5EIJIP9+I+bTxNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR04MB2370
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Maciej W. Rozycki <macro@orcam.me.uk>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2021=E5=B9=B42=E6=9C=8828=E6=97=A5 =
9:48
> =E6=94=B6=E4=BB=B6=E4=BA=BA: YunQiang Su <wzssyqa@gmail.com>
> =E6=8A=84=E9=80=81: YunQiang Su <yunqiang.su@cipunited.com>; Thomas Bogen=
doerfer
> <tsbogend@alpha.franken.de>; Jiaxun Yang <jiaxun.yang@flygoat.com>;
> linux-mips <linux-mips@vger.kernel.org>; stable@vger.kernel.org
> =E4=B8=BB=E9=A2=98: Re: [PATCH v4] MIPS: introduce config option to force=
 use FR=3D0 for FPXX
> binary
>=20
> On Tue, 23 Feb 2021, YunQiang Su wrote:
>=20
> > YunQiang Su <yunqiang.su@cipunited.com> =E4=BA=8E2021=E5=B9=B42=E6=9C=
=8822=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8A
> =E5=8D=8811:45=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > some binary, for example the output of golang, may be mark as FPXX,
> > > while in fact they are still FP32.
> > >
> > > Since FPXX binary can work with both FR=3D1 and FR=3D0, we introduce =
a
> > > config option CONFIG_MIPS_O32_FPXX_USE_FR0 to force it to use FR=3D0
> here.
> >
> > As the diffination, .gnu.attribution 4,0 is the same as no
> > .gnu.attribution section.
> > Its meaning is that the binary has no float operation at all.
>=20
>  Nope, quoting include/elf/mips.h from GNU binutils:
>=20
>   /* Not tagged or not using any ABIs affected by the differences.  */
>   Val_GNU_MIPS_ABI_FP_ANY =3D 0,
>=20
> which means that the object file *either* does not use FP *or* has not be=
en
> tagged at all, as the GNU linker does not tell these two cases apart inte=
rnally
> (yes, quite useless semantics, but there you go; I think the enumeration
> constant of 0 shouldn't have been chosen for any explicit tag, or possibl=
y for
> double float instead, so this is an ABI design mistake).
>=20
>  Any object produced before mid 2007, specifically this GNU binutils
> commit:
>=20
> commit 2cf19d5cb991a88bdc71d0852de8206d9510678f
> Author: Joseph Myers <joseph@codesourcery.com>
> Date:   Fri Jun 29 16:41:32 2007 +0000
>=20
> will not have been tagged for FP use and therefore the traditional MIPS/L=
inux
> psABI of double float has to be assumed.
>=20
>  This is also the correct interpretation for objects produced by Golang, =
which I
> have concluded are actually just fine according to the traditional psABI
> definition.  It looks to me like the bug is solely in the linker, due to =
this weird
> interpretation quoted above and unforeseen consequences for FPXX links
> invented much later.
>=20

Yes. This a bug of linker, and we should fix it.
While for pre-existing binaries, we need a solution to make it workable, es=
pecially for the
generic Linux distributions, just like Debian.

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D962485

>  Yes, the two cases (not tagged vs tagged as 0) ought to be told apart an=
d I
> outlined a solution (needed for different reasons, but with the same
> motivation) for the GNU linker in the course of the discussion around NaN
> interlinking design, but that has never materialised before I effectively=
 left the
> MIPS world, only remaining active in a limited manner for legacy MIPS
> platforms (that is ISAs I-IV).
>=20
>   Maciej

