Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FEB32BC0D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382967AbhCCNjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:39:17 -0500
Received: from mail-eopbgr1310092.outbound.protection.outlook.com ([40.107.131.92]:39646
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232398AbhCCCC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 21:02:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrSqNw36yLChMdOJop2KpQuli8dDECo++S7eqhK3ehmomKPWF1NKMHVtgh8w+koyBTdlpbQe6PtIkKxvfi3el4zNcWvOhwIOvrwDrDO6gogq5GU8SFPYuELGl069U3rlnCWW3ut1VhIymi2ZZiaT+CjELgdL/AkzjT1dXImpV2EvgPZYp9BId0Xg/yhFtaRrOzr2d5cjlFL9LSHuL+yaQP9mWaI0fyd8VutbowRLkCYoYZ+SBEHVo7xpf3jwxW2ZzYuOLdEf+mf7MdhBv2Gv3eyXQG5m0SrmU9KF+Z+2hLNeNRN9urjXH4dJx3aE8+qetUp0tmgS8nEvSFgr3cGiOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70j74iaqtfBnsWF2pz6jtkreCM7K3pzhtTzj7BaYgzs=;
 b=m4CZQrp59ZmpUqKCFbph6gxcDh4oLqq7vdXru9+/XURjtt+MYjviMHhKLET9EccmeEXH2pvn2K0boT4cofcMGhJCA5ID8T3+fddaoQv1v+J62y9JJFtr8NicZ0Q3YpjbDgyNo311T1WYZIlp6+SW9O5A5MBawKriC5YS+tVcSORRig8mUM3RrWqCwt0OyqoA/yCFm/perffh/X+NO2bqWdODpAui4O+0/X0Vf6F3DXMAGqxnr2X6uZPYAX2bADh31AMBjanH6eSl6Wno0Aiob2NUL4q/0QagA+rHTIEqwEnmAQ/n86Q/w1HQdzNKElibdSpuV1t8VH5txiefNM2JtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cipunited.com; dmarc=pass action=none
 header.from=cipunited.com; dkim=pass header.d=cipunited.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cipunited.onmicrosoft.com; s=selector1-cipunited-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70j74iaqtfBnsWF2pz6jtkreCM7K3pzhtTzj7BaYgzs=;
 b=SkbqnXA2Wvn41HQzxV1F0O8n1YYuGKRYq5mdUNSbq46aRJxVZtgbFYB/hCbH0R11zkXuFSgdoAHQGZ9zKQacrUXLZQ0pKzqL3Sdsdi54wHeslLAqVhM9Tj4W4dUP4LTSZqi5Gd9To04Mw5GKw//+dKPOagzPV8qbiTm9dEfrYD0=
Authentication-Results: flygoat.com; dkim=none (message not signed)
 header.d=none;flygoat.com; dmarc=none action=none header.from=cipunited.com;
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com (2603:1096:203:d5::13)
 by HK0PR04MB2915.apcprd04.prod.outlook.com (2603:1096:203:5a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28; Wed, 3 Mar
 2021 02:00:03 +0000
Received: from HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c]) by HKAPR04MB3956.apcprd04.prod.outlook.com
 ([fe80::b5d5:d70f:ed37:984c%6]) with mapi id 15.20.3890.030; Wed, 3 Mar 2021
 02:00:03 +0000
From:   <yunqiang.su@cipunited.com>
To:     "'Maciej W. Rozycki'" <macro@orcam.me.uk>
Cc:     <tsbogend@alpha.franken.de>, <jiaxun.yang@flygoat.com>,
        <linux-mips@vger.kernel.org>, <stable@vger.kernel.org>
References: <20210302022907.1835-1-yunqiang.su@cipunited.com> <alpine.DEB.2.21.2103021645120.19637@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2103021645120.19637@angie.orcam.me.uk>
Subject: =?gb2312?B?u9i4tDogW1BBVENIIHY2XSBNSVBTOiBmb3JjZSB1c2UgRlI9MCBmbw==?=
        =?gb2312?B?ciBGUFhYIGJpbmFyeQ==?=
Date:   Wed, 3 Mar 2021 10:00:00 +0800
Message-ID: <000701d70fd0$ecbb21a0$c63164e0$@cipunited.com>
Content-Type: text/plain;
        charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFc3TirHHapM3NboiGq8Vd1cyrtKAJU+sYAq1M28xA=
Content-Language: zh-cn
X-Originating-IP: [103.125.232.133]
X-ClientProxiedBy: HK2PR03CA0058.apcprd03.prod.outlook.com
 (2603:1096:202:17::28) To HKAPR04MB3956.apcprd04.prod.outlook.com
 (2603:1096:203:d5::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from PCYSU01 (103.125.232.133) by HK2PR03CA0058.apcprd03.prod.outlook.com (2603:1096:202:17::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.10 via Frontend Transport; Wed, 3 Mar 2021 02:00:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d9195f1-dbb8-4408-bb04-08d8dde80f34
X-MS-TrafficTypeDiagnostic: HK0PR04MB2915:
X-Microsoft-Antispam-PRVS: <HK0PR04MB29152847E9903ECD32A7656AF2989@HK0PR04MB2915.apcprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VwN5K65tgIWXmxZQOBDVl+oZmofwBQmx95IY6QGdz5w57rhoNGKeXgdck2Dhg5cn9bzkVca+HWAURzznB+6EF9y+SGuIoaY2fAWbsHlVroSc/fGqpvvHv75933Xjg1Wdds34aF+jK1J6TjPhrNNzKnoQ+rkDo+K1tz1tWgpFfXt/PEwi4NyKRNeRw3JP5mhUgqV7rOL9KNtWXluFvyAblXkCr07wL+jJ6RU87KcSE+kJK1CXnn0Hrm71ydg1Vbk6RipKN5kLKOtH5fBUKvbwJAj8DMeJramB+I5qF89MX0dOfM5tGPC6kwcAljqI0otJEdlil/aTUjcCB75LdVcYecjej9+cAAxiXlXsFs94saGSTt4oVUPue7zJ1V90TyWiIGiWrF3YDXbR5rWz8wXdx/v6h2/WZX7pUW5+rndMLbqQs490idjQ6pnpIJmhealVW7o9ZO2b00qZb/+36P57+CKb8MPvCm00zoj7MsX/pv90NEal44EZBE4Murh4i2vRG2WvpOaOY/XjsYbEZ4bs2fzTsjQEmWKlSRKcoTEK4LdVwbFRupkH1HNJTOGBXk9h2jKpC4zeQ/8+H1x9lIufAJQgXdOoo8II8QLa8h/b0as=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR04MB3956.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(366004)(396003)(346002)(376002)(6486002)(6496006)(1420700001)(956004)(52116002)(26005)(86362001)(4326008)(83380400001)(66946007)(186003)(5660300002)(66556008)(316002)(2616005)(8936002)(224303003)(2876002)(44736005)(36756003)(66476007)(478600001)(54906003)(2906002)(16526019)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?gb2312?B?TEhNMFhPbW9mTVJ4NHF6QVFsQ3FSWXpjTlpPM2dTOGJnT2dLVW5xZFlhNEVr?=
 =?gb2312?B?MUpJM1VSQ3FIZm9MaUZwUHNMOThIaExZUUZhem0rdDlOUzZsNEVvVmxLK3U5?=
 =?gb2312?B?YkpNekJxdFh2Zm84Q2RGMm5XVWt3QmsrZWliWjJiQXp4MWJCaWJIVWpTWXky?=
 =?gb2312?B?elpkRUo0cElhZHo5ZmJ1bWJJcjdlWXE0T0F4eUxkQm9kb3Y5MXA1T2VZSnZB?=
 =?gb2312?B?MGtMWldhZm8xSnZOdUx4ZnU5bWtEdnFXNGl3RzVmV3V5eHFqSjAxQ2ZwclRp?=
 =?gb2312?B?WmRtK1Bjdkl1UWg3UFhDcE1BekZndHdrbzB4MlRyY0RJU3k0SjlIWmhoY2VS?=
 =?gb2312?B?TTBJZ0lEY3psWFdJUWhpdklxWjZYS1pTdm93a0J6OGc2Q0J5aXp0ano4S3Zh?=
 =?gb2312?B?ZmpwRW1FcjR3aUVnUTJSNlFvWDgzenh1a01aL01uTFplaTN0WTV1QzVsdXBa?=
 =?gb2312?B?RTNGVFVjT1c5ajZhVzhmOTBCU2hINnI0cEcxclVlR05seSs2ckJ5eklHS0pk?=
 =?gb2312?B?TjU1QWVDT2ljUHJrSG9ib2VVU1JFeVdpWVA4Z3ViblZaMnpVMXFUemdPQUN2?=
 =?gb2312?B?dHUxWGRrS1YvS1NGSTBCZXB6WER0ZzRLWnlLZ3VQWDh6M3lWVnlSNW1UZ253?=
 =?gb2312?B?N0xXdUFkY21WdFprWmlsZnU0OUVzNSsvRW5TM1FBZlFYZFVBR0dVQUJLN2do?=
 =?gb2312?B?S0dlOHpJUytVOTF1RXhSWmh4a3IrbUR2VXhjQjhBU1hJejVkQ0hNREp0VWll?=
 =?gb2312?B?MFhCTXBzL2VyVmprd1plbHJDY0svd0tYcDJGbWNrdWgrQWxRWnFNalRKZEFm?=
 =?gb2312?B?aStuMGlDOFdBU0N0TWlaeVJLd1dCdERmSEh2a3hCR2Uzb2JGVGdpV2JLZjBu?=
 =?gb2312?B?eXd3QTZkVzU0VXg0V2RIRVFzTlVvMEJqOVNBWnIySE9WYXhJTWRCcWpoMzk4?=
 =?gb2312?B?c2I3S1c4T3JDUE5qL1JTVFNmQjNLVVkwVkpFZERoRlJyWU4xSmNobVJ1aEdk?=
 =?gb2312?B?dlp2V2N3V2N1WnAxb0ErbmZEVlFVaXdTQkh1WHJlQlJaWjNjdFNMc1I5a1NQ?=
 =?gb2312?B?TXNqM1V1LzlOUmFMeUNMQnJOcysyVzV5ZHJWZVBkSjFQUUZOMkVrMkNSWkk4?=
 =?gb2312?B?UG9DQ2w0ZmVhYk1lcC9hVDJkQU96c0ljYURKSDZjc2UxQmlYYUxqWEFuMWtM?=
 =?gb2312?B?WjA2M3QvaUlTcGxNNElBTUVBZW94UzhvQWM1bXpTMmZpMElMWEZHZEFkNUx2?=
 =?gb2312?B?RWE3ejVocDFMWlZtVVhOR1p3M0xQN0VlYnI3Z0gxc09Nb3J1WG50SWpzV0Mz?=
 =?gb2312?B?UnN2c2kzMXcybjVjbDFPN2hCMWNHeVh2U2dvWEFXazhVOGpEK1d2dDA1NGtQ?=
 =?gb2312?B?U3JueEhNNllabEt0Ym5CWFl1U1hTdzdzMng1YnZtQTR0SEtndXJyWjBvR0NN?=
 =?gb2312?B?UEhwOENRc2Q3WUJVOUU4VGgyWlVwUldtVnJFM2FWQzE1TjlERzBNMHRscmxC?=
 =?gb2312?B?YzFoL2hLcy9LUG9OR3VSNFZlWVRya0twU1k0WUIvT1JZSUU2cCs3cGpULzJI?=
 =?gb2312?B?VmhsbTRwMytvVE1TcjhSc3NoRmc5ZUNlQTFmb2o4Ujd2aC96WktHOENhTTUz?=
 =?gb2312?B?NUcyODc1eTJFQmlaOG1qaVhhUWllWDNuTWVMSE1ERkkzNHRiQldyL3ptbTc5?=
 =?gb2312?B?Nnh1OHZ1SXRqbTZNVURNajZkMlIzQTIzTjdUU2dOUXA4MHByNm9HRkRveFBR?=
 =?gb2312?Q?HK+Z7GDnvpi5e2C27yaGrbPLngVcm5e7q1eA5Ko?=
X-OriginatorOrg: cipunited.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d9195f1-dbb8-4408-bb04-08d8dde80f34
X-MS-Exchange-CrossTenant-AuthSource: HKAPR04MB3956.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 02:00:03.3784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e31cf5b5-ee69-4d5f-9c69-edeeda2458c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +JM7YHQAKAIde17iUcgyLEbQKFzAs9xoEeW3Xxq15VLQkCa5rVIDpUebsqTd09y9TnwJrIKBzauLHwy9NllcfwRKRINGklOAXs9+fSm1KOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR04MB2915
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Tue, 2 Mar 2021, YunQiang Su wrote:
> 
> > The MIPS FPU may have 2 mode:
> >   FR=0: MIPS I style, odd-FPR can only be single,
> >         and even-FPR can be double.
> 
>  Depending on the ISA level FR=0 may or may not allow single arithmetic
with
> odd-numbered FPRs.  Compare the FP64A ABI.
> 
> >   FR=1: all 32 FPR can be double.
> 
>  I think it's best to describe the FR=0 mode as one where the FP registers
are
> 32-bit and the FR=1 mode as one where the FP registers are 64-bit (this
mode
> is also needed for the paired-single format).  See:
> 
> <https://dmz-portal.mips.com/wiki/MIPS_O32_ABI_-_FR0_and_FR1_Interlin
> king#1._Introduction>
> 

Thank you. I will update it.

> > The binary may have 3 mode:
> >   FP32: can only work with FR=0 mode
> >   FPXX: can work with both FR=0 and FR=1 mode.
> >   FP64: can only work with FR=1 mode
> >
> > Some binary, for example the output of golang, may be mark as FPXX,
> > while in fact they are FP32.
> >
> > Currently, FR=1 mode is used for all FPXX binary, it makes some wrong
> > behivour of the binaries. Since FPXX binary can work with both FR=1
> > and FR=0, we force it to use FR=0.
> 
>  I think you need to document here what we discussed, that is the linker
bug
> exposed in the context of FPXX annotation by legacy modules that lack FP
> mode annotation, which is the underlying problem.

I will do it.

> 
> > v5->v6:
> > 	Rollback to V3, aka remove config option.
> 
>  You can't reuse v3 as it stands because it breaks R6 as we previously
> discussed.  You need to tell R6 and earlier ISAs apart and set the FR bit
> accordingly.
> 

It won't break r6, as all of r6 binary is FP64, and on r6
   `frdefault' is always false, and `fr1' is always true.
It won't trigger this mode switch.

Oh, you are right, there may be a case that to run legacy app on r6 CPU.
For this case, on r6, we need to set the CPU to FRE mode.

>  It would be more proper I suppose if we actually checked at the boot time
> whether the bit is writable, just like we handle NAN2008, but I don't see
it as
> a prerequisite for this workaround since we currently don't do this either
(it
> would also be good to check if the FP emulation code gets the read-only FR
bit
> right for R6 for FPU-less operation).
> 

Check writable is not needed here.

>  Also you need to put the history in the comment section and not the
commit
> description, so that the change can be directly applied and does not have
to
> be hand-edited by the maintainer.  You don't want to overload him with
> mechanical work.
> 

Ok, I will add more comment.

>   Maciej

