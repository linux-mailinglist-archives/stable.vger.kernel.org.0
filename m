Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3A9343612
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 01:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCVAzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Mar 2021 20:55:37 -0400
Received: from mail-eopbgr1300124.outbound.protection.outlook.com ([40.107.130.124]:25440
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230001AbhCVAze (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Mar 2021 20:55:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCmr9ZS0jgjVv9RX4C6Xc1bC7swCZl7wdM8G81yfeRAdc+Td8CUPjR23UhojB4//rDBSlNPG/YEQ+TR7z6yYF618z4LMPvX6huBMZmyTRSxbaaUGYWLnROikGTS1EH/ar5EqosoMQ/mHQ+cOf0yRV6BiZQoLPt7uNIPNgJFKkHxOjCRaxI3tvWCuWxdZXaxTHvnd50o2JtJ8d3RdMuI7oZa0b4a/+dnpQFTzuoK8ge3VIG3JjVLnBiMxENIcL400V+o4mEQZz3JSb4eU4jaiM46OLPjcXHA4I49SFxWyj7veaXk9BQAgGFW8R7pwHoUWZCPGA3Q3FJaI6K6DDxJ4zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylEAasjvnkUjymXl0vF2y4HDesuWLdjwi1xZ2XpCH0o=;
 b=POAhYTVdjA+/czHk+APUuewPrSJrHGK05ZJ12fZEKboPncprxo1RXRYy4b0PSCJbCPnxfa3NSXcLe7A8TjH2piE/A/lFsdgyLJwJoF5sYYjd0R/im7Xnnogx+LZ+X9kXBYiVwjRe/bMnwJEZtnv+ENxVRhMRnrq3ii10/dl5IGOng/T/OB8J/1bixlCPr1cYY9QsFNGsi/Nnkvg32qUor3E2z6IySy9yFDNZ/8JSnm5/3pQq1EBlKO0iuaNYcHR3mM/8X6pfQMu47vnkmt/MaaqneCegK9uR8LZTELeOLm/3Lx9jo7e0DCIFpYDV9k3QaYXOdk1gB+ZIizSozMQrAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylEAasjvnkUjymXl0vF2y4HDesuWLdjwi1xZ2XpCH0o=;
 b=PQ18ACpkmn3EOixoKn+D8260qhFmbMBUC+MoLfha41agzN3qgw4Ay/MomQp8VMk1/MiB+tILcuYqpX/nBlKAQD2KS77QFx2ihdevXP6oz0SMfyOR6oQJ3XxhqWjociv4ouJpatpaVq9so+NsGlGLauUztkQVJMEwO/1KS1AT+5g=
Authentication-Results: amsat.org; dkim=none (message not signed)
 header.d=none;amsat.org; dmarc=none action=none header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK2PR04MB3684.apcprd04.prod.outlook.com (2603:1096:202:30::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 00:55:23 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::152f:4f26:f6d1:2d6f]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::152f:4f26:f6d1:2d6f%3]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 00:55:23 +0000
From:   <yunqiang.su@cipunited.com>
To:     "'Maciej W. Rozycki'" <macro@orcam.me.uk>,
        "'YunQiang Su'" <wzssyqa@gmail.com>
Cc:     "'Thomas Bogendoerfer'" <tsbogend@alpha.franken.de>,
        "'linux-mips'" <linux-mips@vger.kernel.org>,
        "'Jiaxun Yang'" <jiaxun.yang@flygoat.com>,
        =?gb2312?B?J1BoaWxpcHBlIE1hdGhpZXUtRGF1ZKimJw==?= <f4bug@amsat.org>,
        <stable@vger.kernel.org>
References: <20210312104859.16337-1-yunqiang.su@cipunited.com> <20210315145850.GA12494@alpha.franken.de> <alpine.DEB.2.21.2103172345020.21463@angie.orcam.me.uk> <CAKcpw6UwYXYMCGw1C+nrRQLcqouxXCgdkDLZfK4fNFz+nVwZiQ@mail.gmail.com> <alpine.DEB.2.21.2103191500040.21463@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2103191500040.21463@angie.orcam.me.uk>
Subject: =?gb2312?B?u9i4tDogW1BBVENIIHY3IFJFU0VORF0gTUlQUzogZm9yY2UgdXNlIA==?=
        =?gb2312?B?RlI9MCBvciBGUkUgZm9yIEZQWFggYmluYXJpZXM=?=
Date:   Mon, 22 Mar 2021 08:55:24 +0800
Message-ID: <000b01d71eb6$0c210250$246306f0$@cipunited.com>
Content-Type: text/plain;
        charset="gb2312"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIk9SY/T9d9O9e0uLaCv11/zhEJnQHLL8NTAcVjVVUCG3CY6ANy9em1qaqJBwA=
Content-Language: zh-cn
X-Originating-IP: [43.231.187.68]
X-ClientProxiedBy: HK2PR03CA0046.apcprd03.prod.outlook.com
 (2603:1096:202:17::16) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from PCYSU01 (43.231.187.68) by HK2PR03CA0046.apcprd03.prod.outlook.com (2603:1096:202:17::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Mon, 22 Mar 2021 00:55:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee915953-d74c-49b0-a1f8-08d8eccd2c7c
X-MS-TrafficTypeDiagnostic: HK2PR04MB3684:
X-Microsoft-Antispam-PRVS: <HK2PR04MB36842FBC588C821DC8DE622EF2659@HK2PR04MB3684.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EJjdZ44+56DBloOl0sEPnLokSEOc+oogT7spdTZlNaXnpyseTgwmhuKnMNGGBbwb8V5RpZtV8UWxpFd/6tZJipVjIOjO+smg4390UxLjMwqkvkbc6bNSAmDoXGDbxViiD0IL/7KCEmt3k8VwFM2IHH5j74bwwrnTzUpcVfrUP3fEfejfWB13vLUAS+Nm6JiedgLN5j/p3YFxUDFuQl4Zp2r2UpJhNYWSahmrQPbMcYMLXLGh4FtZ2Cfig5pXl3s3pwn21b6jWuLZ5XkmOZIBiUxF/P5Tnpz+W5ZQywMWilyLqlAqSCW9QUZPYUdjfgXbvyyQlIZ6vzPE1LULNWsMGSxfRkDm8AWz3HnRfkgVhdiz8gvjOaauBEKfvfrfUVU1iU9Vsjn9GNnoqzj+DEGZGG5pg4WZSybZOy7CfQGaMIWA3+YmsWUYO9g2RxB92BHZUkqFXaXO0dDF1Cfl7jzwpnoOTITclLKxsh2cJIlBbNE1y50h8MFh1ivlDa8ZAdy03GWoFOjmlybt7iCAjGu6UMnPlBT9o5z/5eTt3wzby6fr94THxPggqX7YR2cwBUqw0PJWZAoi0rZIzQnljoAFXVW05UhxGSrbUZMAFYJzq98jivWOvpLEU0TPf8HM8++ZDoFq1TJ0QAnAp099l0SWZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(39830400003)(376002)(2906002)(38100700001)(2876002)(26005)(110136005)(316002)(44736005)(54906003)(52116002)(186003)(5660300002)(16526019)(6486002)(6496006)(4326008)(36756003)(8936002)(66946007)(66556008)(66476007)(86362001)(478600001)(2616005)(956004)(83380400001)(224303003)(1420700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?gb2312?B?aS9mbXNjTjlSRjFKUmR3UnF0c3diQlpHN01FREpQSmxHNmQ5NUlsR1RWbUlU?=
 =?gb2312?B?VHJLYUhCZjQ2Ykg5VGNuVTRWaUdIMU9IdDdrNXFRUkljbEtPZ0VkRWZVNnpQ?=
 =?gb2312?B?QnQ2dkhSdjdpdWxyQVFmRHhQVHpDdFozVkczdnlOVXRNV0VNdHA3aDVCcDdD?=
 =?gb2312?B?N2FkTDR0OFZwRUF5M0FoMHBxV0JwdWFlRWxxZ3V4bW96Y2k3ejdxWk1lWGtH?=
 =?gb2312?B?ZnRrMzBUeWIveWdCY0xUWkw5RTZES2JNdVFSN200UG5pQ0dRd0xqS3lNSXY2?=
 =?gb2312?B?RmM4bjhJT2VYYU91Rm1oSnVtUGlHbDZ4T0UrVUs5NFVHbDB1Rjlnc3liK1A2?=
 =?gb2312?B?UWlzZjdZNXp6dTVrRUNzR3RGL3grUzlDcmY5ejRKRWZDWklBMDYxVWFvbFdk?=
 =?gb2312?B?OHdOVzVPV0RrRXdxR281aHc2T21aZkgzUm80V1ZuK0tIcys1bitOdW95QUcv?=
 =?gb2312?B?Qlpvdk92WFZxNHhUb05Hb05jWGlYK0I3ODFoTjB2cnFxbHR4bHpSRlZaR25r?=
 =?gb2312?B?emlkbm5JQlFwQ2hhd2hoN0kzWXlYYVU5QkEzcGNJTVh3OExaa0dVbnNsWlJo?=
 =?gb2312?B?M2ZRcEF0Ym5nQW9mQ3ZmY2FqVXFhR01RSFd5cTE4Z2phWlNaeURDOXZjTWh4?=
 =?gb2312?B?Ylo3L0NLMzIwZEw3cDJiRk1jTk1GNnlib0x4SjZQbXZEd1VMYjlScVlMM1F0?=
 =?gb2312?B?aWw4UElCQThldWgzamp3VER3NG0yM0REckxjejRFOW5IUFlseSt2dU85L2FZ?=
 =?gb2312?B?ckpvWnNMTlBVNzhsN0VVR09vNTJBSGQ3SDQvdUZ1OXg5TG9ZTDUyVStWQWF6?=
 =?gb2312?B?dlF6eHVxNDJJam9QbGpYMDZPYmRVMysyM1lGQVFnUGxkaXMzbFFnakdwNkFF?=
 =?gb2312?B?WElZK2ZNOVdWUjJ2WG5LdUd6ZUpIc25CcDh0WThPdXFmczJRaWlnSUdJdW5G?=
 =?gb2312?B?dDVtZU0zY0RVVXcxMC9SZDFhN3EvUXJWQS9rYTZvNHo4dFl4Q2hjVk1hMzVW?=
 =?gb2312?B?TnhzWFpQdGFhR3NvK3ZOZWxMeFZwd0lmbW9JQncxWHBsV0phalNKanB6T2xK?=
 =?gb2312?B?RUtWcHlGRENNM3dzc2JMM3BqUjVXenVzYSt6N3B5VmlJQ2dyTXE1VjZ1RXhH?=
 =?gb2312?B?UnVHMU9UYVl5LzlQbXRpczlxRFhNb3lBRURwRldWTTNmYXdHR1FCcUpWdTQ2?=
 =?gb2312?B?Q2FyMlQzVU9kV3FzTDVaRUJiY05Oc3VzanNaQ0h6NWRHc2VxN082KzE0UTBv?=
 =?gb2312?B?cE5pZ0JYc3ZBb2tDbm5SeXMyblZTZEZROXNZMU4xOXRoTFBTMm5sSlZvbHZF?=
 =?gb2312?B?NFNuKzMwc3ZoWVVNSlpuKzNwTHI4Q3YvOGV4T2c3Q0sveVJZZU5QZlljMDBs?=
 =?gb2312?B?NjEyOFZycGZkOFZTTlR2TUJUck9kYmI1WVhEb1JTbmhUVXFIRjMraVRBWjQv?=
 =?gb2312?B?U09la25CNHduaHEvSWtCczFlV1l0TmcxY01nUU40Vjhtdmkva0dVY3d3eTJo?=
 =?gb2312?B?RXIrczNkYk4rZGJhR1hQSlpKclV5UytNN1VJY3RSMUNwUzZ4Q01qYmlTbGc0?=
 =?gb2312?B?bGZ6MkZ2eVJRY2VJdnEzR0VSTjEzbDFGcFVkdTZCcG40Zm9KbVFEZnhjTDRj?=
 =?gb2312?B?Nzlqa2I2YUxDTWVuVTIxenQ1T0VQc1ZvYmdTaXZrSUpBS2pVdXh2d2IyUVV4?=
 =?gb2312?B?cWcwVldCUUxFKzZ3R3NWZkNIZENYRFVxVERZZUtiY3pYK21xT1NhUDA3dE15?=
 =?gb2312?Q?WfkU3DGzoPdEO4Bp1E1F1JAEb1dLBlCk+YgP4Wv?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee915953-d74c-49b0-a1f8-08d8eccd2c7c
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 00:55:23.5046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Qmmat0bWnlGPWLbGjZ5W+/HFWmdXIQSxhQDDtgPB/jnxTqxAcfxX0NUfhwAvgOsDuN4yZVcA3dB6ihCllKxPFw1DSoasJlFcZs0fgIFn5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR04MB3684
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----=D3=CA=BC=FE=D4=AD=BC=FE-----
> =B7=A2=BC=FE=C8=CB: Maciej W. Rozycki <macro@orcam.me.uk>
> =B7=A2=CB=CD=CA=B1=BC=E4: 2021=C4=EA3=D4=C219=C8=D5 22:32
> =CA=D5=BC=FE=C8=CB: YunQiang Su <wzssyqa@gmail.com>
> =B3=AD=CB=CD: Thomas Bogendoerfer <tsbogend@alpha.franken.de>; YunQiang S=
u
> <yunqiang.su@cipunited.com>; linux-mips <linux-mips@vger.kernel.org>;
> Jiaxun Yang <jiaxun.yang@flygoat.com>; Philippe Mathieu-Daud=A8=A6
> <f4bug@amsat.org>; stable@vger.kernel.org
> =D6=F7=CC=E2: Re: [PATCH v7 RESEND] MIPS: force use FR=3D0 or FRE for FPX=
X binaries
>=20
> On Fri, 19 Mar 2021, YunQiang Su wrote:
>=20
> > The bad news is  that (Google's) Go has no runtime.
>=20
>  Dynamic shared objects (libraries) were invented in early 1990s for two
> reasons:
>=20
> 1. To limit the use of virtual memory.  Memory conservation may not be as
>    important nowadays in many applications where vast amounts of RAM are
>    available, though of course this does not apply everywhere, and still
>    it has to be weighed up whether any waste of resources is justified an=
d
>    compensated by a gain elsewhere.
>=20
> 2. To make it easy to replace a piece of code shared among many programs,
>    so that you don't have to relink them all (or recompile if sources are
>    available) when say an issue is found or a feature is added that is
>    transparent to applications (for instance a new protocol or a better
>    algorithm).  This still stands very much nowadays.
>=20
> People went through great efforts to support shared libraries, sacrificed
> performance for it even back then when the computing power was much
> lower than nowadays.  Support was implemented in Linux for the a.out
> binary format even, despite the need to go through horrible hoops to get
a.out
> shared libraries built.  Some COFF environments were adapted for shared
> library support too.
>=20
>  I don't know why Google choose not to have their runtime support library
> (the Go library) as a dynamic shared object 20-something years on, but it
> comes at a price.  So you either have to relink (recompile) all the
affected
> applications like in the old days or find a feasible workaround.
>=20

I also have no idea why (even hate).
While there do be some program languages created in recently years, prefer
static link.

>  As I noted in the discussion the use of FR=3D0 would be acceptable for F=
PXX
> binaries as far as I am concerned for R2 through R5, but not the FRE mode
for
> R6.

There will no FPXX for r6. All of (if not mistake) R6 O32 is FP64.
FRE here is only for compatible with pre-R6 objects.

I will send a V8 to switch r6 back.=20

>=20
>   Maciej

