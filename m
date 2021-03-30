Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C59334DF3F
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 05:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhC3DYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 23:24:42 -0400
Received: from mail-eopbgr1310121.outbound.protection.outlook.com ([40.107.131.121]:61856
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231150AbhC3DYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 23:24:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5ep3V4ieymAQxh6WyFdrh+5UjyIOZjRt2vB66KvsVmDd6HzZaOr2zzn0gTyJ+1whN3BLEDc0qpZg+NdAw3AVtvSB7eSaU8nDHhTI+VtXMC02/+D2ZZ3bHYACoqc2UM29shkx+P5K8MEvlmL+NFP7Otjbc7fa1HyzGRfOFtn7jvj/QJfjf1bNKvltmWUdpcYQQMRCvjSxnh4kZYo5LaZRSv192z3UsZ/s5KkrVDnIC2wgtGXrtcrfULul0opv6vN0ToIjSQ9CQjmIynAK7pA8usUvv/oz5fZdxfNC3ekuZ0tP6WRjZhzLCVOvjxIy0y73aw4w6Jfxcrk3wyS4x4wog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtiPxAvXFjQ06WXTgu65Tn3JxH1BZRcQtlxTD0pRvjY=;
 b=fGQO3JPNebA7zW3eplWSmq8WbFQIc/T8HIKRNsSANLFQS6s2N0BRL4BNvFM50+pyFn2OP+U19aVLVcxlx1Mv1rQG+LLlcSJELYPO2kophnY86NOzbI7VdPNnmdogcDInHAyCNxALMQY2B+8aK/xMgI061i6dm6ZJkQA7N+8UaEu0bOTXRNQIi2GGO+cB9Jn9+6Il03qfmD7OhQEQBAA/KAMcEwkOgc7B2PUf5MhgNH27Z8oaJ1jICZ7UqKSz9uKt/sdrX5EyaM0gYxrzUOXNga3v5g1+OPkz2WsW7AWhrkqBpxXMiDwzYUrFN6Phu2lPlK8eGgbffGMu/4kWUtW6fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtiPxAvXFjQ06WXTgu65Tn3JxH1BZRcQtlxTD0pRvjY=;
 b=g0zJV48K2AQqNukxK3uYEiGKU/ybFhLORkaBnIjR3AqflCqBliimfXttEq34uYyQR5zpllOUNqeuhIMCvAiyzLopQ/TgSdg1JeTxWxvneK7VadQy7pYwf7c+JaDFCaR9YQ3dgLtjx4IdCLZvtl8VTWdArF7C9wXsb+q04dGN9yc=
Authentication-Results: amsat.org; dkim=none (message not signed)
 header.d=none;amsat.org; dmarc=none action=none header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK0PR04MB2916.apcprd04.prod.outlook.com (2603:1096:203:5f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:24:17 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::353c:dd6f:35c8:bcff]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::353c:dd6f:35c8:bcff%6]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:24:16 +0000
From:   <yunqiang.su@cipunited.com>
To:     "'Maciej W. Rozycki'" <macro@orcam.me.uk>
Cc:     "'YunQiang Su'" <wzssyqa@gmail.com>,
        "'Thomas Bogendoerfer'" <tsbogend@alpha.franken.de>,
        "'linux-mips'" <linux-mips@vger.kernel.org>,
        "'Jiaxun Yang'" <jiaxun.yang@flygoat.com>,
        =?gb2312?B?J1BoaWxpcHBlIE1hdGhpZXUtRGF1ZKimJw==?= <f4bug@amsat.org>,
        <stable@vger.kernel.org>
References: <20210312104859.16337-1-yunqiang.su@cipunited.com> <20210315145850.GA12494@alpha.franken.de> <alpine.DEB.2.21.2103172345020.21463@angie.orcam.me.uk> <CAKcpw6UwYXYMCGw1C+nrRQLcqouxXCgdkDLZfK4fNFz+nVwZiQ@mail.gmail.com> <alpine.DEB.2.21.2103191500040.21463@angie.orcam.me.uk> <000b01d71eb6$0c210250$246306f0$@cipunited.com> <alpine.DEB.2.21.2103291246290.18977@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2103291246290.18977@angie.orcam.me.uk>
Subject: =?gb2312?B?u9i4tDogu9i4tDogW1BBVENIIHY3IFJFU0VORF0gTUlQUzogZm9yYw==?=
        =?gb2312?B?ZSB1c2UgRlI9MCBvciBGUkUgZm9yIEZQWFggYmluYXJpZXM=?=
Date:   Tue, 30 Mar 2021 11:24:13 +0800
Message-ID: <000101d72514$29c2b9c0$7d482d40$@cipunited.com>
Content-Type: text/plain;
        charset="gb2312"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIk9SY/T9d9O9e0uLaCv11/zhEJnQHLL8NTAcVjVVUCG3CY6ANy9em1AhoubCcB6wzLcKmXGzEg
Content-Language: zh-cn
X-Originating-IP: [103.125.232.133]
X-ClientProxiedBy: HK0PR03CA0107.apcprd03.prod.outlook.com
 (2603:1096:203:b0::23) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from PCYSU01 (103.125.232.133) by HK0PR03CA0107.apcprd03.prod.outlook.com (2603:1096:203:b0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:24:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19a1fa7d-2ae4-4410-3e99-08d8f32b4c40
X-MS-TrafficTypeDiagnostic: HK0PR04MB2916:
X-Microsoft-Antispam-PRVS: <HK0PR04MB29166EE9D714EEAF2C8DEEDAF27D9@HK0PR04MB2916.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hUPjt8IcdcC1pIG5WfsCffU6P+NkyzrkbAxPaiLqRn23sT0s1v9MIGvikcCB0Ouj8pdE2yETDgODNUqA+4OnbuE91C/09Iq4ryl4HHqiXYWAjjuGDZ7EtMUQYXxeXdhqf8yfRr06Cn2vGvOL/PqSudSYE1RGLgoqPnp5DrLeBNakmNHyCR+p3VtlHOlECfAoI6Z1Yn/b9hr4PIs0BZiTVAhe5K6YBoS67E/9ZvDgUhJLTmFAYIO7kzRwr5bxRV2DtJ6CvPAbhheZp4ScMFJqRFKcZbFQvhiR2mU8jOJewRkw+EVHU9b7ZYkJN6acGdmpyI9SEbcolc5s6DSkPoe2VD4B426WGfSw9kltMSTbblFKLHOGm6PJGSerSQceb2DVsxXgxRybRgzDYDWfIZ5LsPx8lXPLWIz5PBWx+EBfAO0U4FVSjaQOygyrWOcGgyKtR1X2hwqDZjw4IFgKRAcyC6e8Zt5EB0UCgRlOzhhgPgcqkgL30euOSMKOOuy27bqxe7sp40Br1OaN+OUYJ47Ym3rUEgE0tyPmQT4PnFYUvB2lePy7xsb8q6HvMVmaWnbZrAsz4u7Rg3L5ui79vSXrQbH0Gk3Q6eckDa1mSQB2uZNZMD4Fwj/Z6JV+jZYXi0zSjUOcxCjwr+x9d+GULdpeYvGpvK0C3tMps+1g+QUzVR8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39830400003)(346002)(136003)(396003)(478600001)(5660300002)(1420700001)(956004)(6486002)(224303003)(316002)(52116002)(2616005)(66476007)(8936002)(2876002)(2906002)(4326008)(66946007)(86362001)(6496006)(26005)(186003)(83380400001)(38100700001)(16526019)(44736005)(6916009)(66556008)(54906003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?gb2312?B?Uml0cjZSeGF0a1ZPVzZSUHZBQklxdE9PYnZzTDNzWUZKY3p3VlR4akJLdkZh?=
 =?gb2312?B?MDJIM21uM3RvSUlEZXUrbnd6NkZKSGFJY09JQXdPNDliWlJLVzhpS0gzS2Vs?=
 =?gb2312?B?bzhIUTRvVHlZc25hU09JbGpDYjAvNkVBTDZCZkRzckc1d3lDUi9xbVJ3eis1?=
 =?gb2312?B?SGtDVStITDl6aXp1VDNuVXFSNDV5aGRRVFZjVGwxTjFSWXRFR0hEUHlHcE95?=
 =?gb2312?B?V0ZlMG9ZcXJIMTkyYUc4MXRUZWQzRnppeGRjSzJzbW5JN0xlOUZXcEo1VzJn?=
 =?gb2312?B?ZXBQSkxOV3RET09sWjZWVk4rUTFMWUZNY1AvT2hUQmZud2dHaWxFcW00cUtx?=
 =?gb2312?B?bGlLdExvc1FoSDVuTG8wYlRBOStpRGU2cVdQZzR4QUdnRHF0YjhPM09BNVMw?=
 =?gb2312?B?a1BLR0NYRXZXUUt5S0ZlNmNuM0hoclkzUlkrVG9pcjd6OCtGRnlzUUh0VHFH?=
 =?gb2312?B?cjFkSENzcVloVVpnZ0wyRllXS0pNZU82dHFuVGt0YVhTbkt5NzE2dGkvTFE2?=
 =?gb2312?B?SnBRN0RYZUhSQlIxM0ZRNG5PZE9DSTZkWERQYkR1eFFteTBrVWd2Sk0rdGtL?=
 =?gb2312?B?RmN3TXBUVG9uVjczY1RLQk5UV0VaN2ZKT2p0TTdubzBXSEczQWJOZDZyelVw?=
 =?gb2312?B?dlptKzdxVHN0cjgrTW55SmgxMGNnMk5INVpXZlJPM0F0ay9rbEdPWnVDemNv?=
 =?gb2312?B?bXpLTUFKakgzZ01KTG0wVzlZMHpwWFRwYXRNMEFnSjZDcDZXanVNN0lycTQx?=
 =?gb2312?B?YU8reVFScjB2aUhkS1cxRTdmT1VGNzA2d2dSYkQ4UmNPTFFLa3c1TlpzeDht?=
 =?gb2312?B?ZTlnTHBJc3JZdVhmak03Z3h3VW52VjhsQ3JHQnM1ZnZ6ZGZKTEhpaVNaZ2tW?=
 =?gb2312?B?SVVHWkd2T3NNWWxMYlZoaWhjelJwLzE1WnAvdlNWTHd1MHpXUmxKUnVLdEpC?=
 =?gb2312?B?NVJQRURhSEVsWmVRdTNGNzVVb2I3bWx2dTQ4NlcwNkIvNTl3ZEtoOHlyZkl5?=
 =?gb2312?B?OStodFZhZTZWUXBwTUpJNCsycUZ3NXluZzhGbzkrT1phcit3ZGxTZWpsSnZ5?=
 =?gb2312?B?cTg0NDVydTQzdG95QUtpd2g5UVVOY2xJSTRiSXF5TlVodXl5a1VWdnpDUkNK?=
 =?gb2312?B?ZGt6TWZOSE1rQk5QdE01SkNlWDVMSW40ZjQyQmgyc1VGVitteGpyMmNBNGFy?=
 =?gb2312?B?cXIwODBKTWkvV3F3TFhCc3F3MVVOOWFycU5JeTRrYncxR2MvSkVzRXVNY0RE?=
 =?gb2312?B?RDVaZVExOGJrN3BCamhkdXBzMlhDTDdsME1kcHMxTW0xbkRRUEgvek81c0Jv?=
 =?gb2312?B?Q1MveUt2WjZ0Z1lDc1hheUl2UXE4NnBHZlpyZmNMajNQWWRtb2R0Rklka29k?=
 =?gb2312?B?eElZWkRyQkxLRmpMN3U5dWszTEd5NlZETkQxRWtXbW9wUWFpM0QvNTgzOEdE?=
 =?gb2312?B?enZBVEFTam15OHZwQ3pDbFFhYy9UM0d2ZUhyM3g1ajZEQlFxWmF4VVBxWEdM?=
 =?gb2312?B?emduNnM0L3hod1h5SCttREx0Qm9Gek02WW9uZzdZemJzU3hGZWZSRDgzbUgy?=
 =?gb2312?B?N2hFVmZTZDlTdjg5cUp4a2hCUW9WRmt0ZElQWk1GeGFIcW9qejJIOFF5RkVa?=
 =?gb2312?B?S01GRUl6Y1lidTEzWjl6N1Y2VEVFZmVidEZyUFhVWUpkb2N0dkJaOEw0c291?=
 =?gb2312?B?ai9ta2Z5eGxURUc2TzAvWEtlZVJSRlpsQUdPa2lGck1XVEF4YVdFNUs0eCt6?=
 =?gb2312?Q?sbpaf1cSGSk2+PBsmLgo37faF09NWvXzikwf96l?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a1fa7d-2ae4-4410-3e99-08d8f32b4c40
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:24:16.7141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OSrUT8kQxySI9qs2ILTyf6pyTUh4SIxbDIuZ9aNKG+qLF/0dunstMFBgZ5go58lQ8h/uoL5JqSf697XDtSdTkPkDr+DhdeBlfnx1XGBDbnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR04MB2916
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----=D3=CA=BC=FE=D4=AD=BC=FE-----
> =B7=A2=BC=FE=C8=CB: Maciej W. Rozycki <macro@orcam.me.uk>
> =B7=A2=CB=CD=CA=B1=BC=E4: 2021=C4=EA3=D4=C229=C8=D5 23:06
> =CA=D5=BC=FE=C8=CB: yunqiang.su@cipunited.com
> =B3=AD=CB=CD: 'YunQiang Su' <wzssyqa@gmail.com>; 'Thomas Bogendoerfer'
> <tsbogend@alpha.franken.de>; 'linux-mips' <linux-mips@vger.kernel.org>;
> 'Jiaxun Yang' <jiaxun.yang@flygoat.com>; 'Philippe Mathieu-Daud=A8=A6'
> <f4bug@amsat.org>; stable@vger.kernel.org
> =D6=F7=CC=E2: Re: =BB=D8=B8=B4: [PATCH v7 RESEND] MIPS: force use FR=3D0 =
or FRE for FPXX
> binaries
>=20
> On Mon, 22 Mar 2021, yunqiang.su@cipunited.com wrote:
>=20
> > >  I don't know why Google choose not to have their runtime support
> > > library (the Go library) as a dynamic shared object 20-something
> > > years on, but it comes at a price.  So you either have to relink
> > > (recompile) all the
> > affected
> > > applications like in the old days or find a feasible workaround.
> > >
> >
> > I also have no idea why (even hate).
> > While there do be some program languages created in recently years,
> > prefer static link.
>=20
>  Hmm, lost wisdom, or an orchestrated effort?  Or a false illusion that
since
> we're virtually fully open source now, we can always rebuild the world?
Well,
> indeed this is technically possible, but whether it is feasible is anothe=
r
matter.
> Your case serves as a counterexample.
>=20
> > >  As I noted in the discussion the use of FR=3D0 would be acceptable
> > > for FPXX binaries as far as I am concerned for R2 through R5, but
> > > not the FRE mode
> > for
> > > R6.
> >
> > There will no FPXX for r6. All of (if not mistake) R6 O32 is FP64.
> > FRE here is only for compatible with pre-R6 objects.
>=20
>  That doesn't seem like a good choice to me.
>=20
>  While R6 programs are indeed best built as FP64, libraries are best buil=
t
as
> FPXX, so that users can link or load with whatever binary modules they
have,
> including pre-R6 ones.  As much as we may dislike it sources will not
always
> be available or rebuilding them may be beyond the capabilities of whoever
> has the binaries, so I think the system should be as permissive as
possible.
> So you may end up with running code that is largely R6 (libraries), and
partly
> pre-R6 (application code) that ends up linked as FPXX.
>=20

Yes. It is the situation we talk about R6 in early days.
While after some talk, we decide to figure out pure R6 systems.

And I agree with your concern, since the Android is such an example:
   64bit is R6, and 32bit is R2.
So, the compatible of R2 object on R6 CPU is some important.=20

>  And the kernel has to support it in the best way possible too and avoid
slow
> emulation where not necessary e.g. in R6 libm code used in the FPXX
> arrangement, which the FRE mode will inevitably lead to.
>=20

Yes.=20

>   Maciej

