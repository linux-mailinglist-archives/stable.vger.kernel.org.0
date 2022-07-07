Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382B856ADC1
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 23:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236810AbiGGVg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 17:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236313AbiGGVgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 17:36:25 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D070380;
        Thu,  7 Jul 2022 14:36:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tf0P2CZb+FIZ49QYRqYve+y2YEWIfK1ClMoHbciRbq9nT8h0wHxcIcilVTffMAnvW5xl87V1LpugGuDDYIt9dFf/aclRBXrWmzvUt4V79NFoHge9xWZ1EWhes6M2xVOVyHEk8VJGgwEV4Y0JihqmefU5Kq3wi1nOWwQZwh9a8gp5CyjkYWC/qEsEWBbxoPGb5aCLCR+gopVJemrauFMMvqLAzlUFYyYbpyMxX8p2CI9jIlUy2qYPTokXqhl0dc48xU+v9hBgY0fHYN+xhQ1MOZfSrjZGC9x/vIFddHr88Pr8Z/G6/HJhv56AWxHkcS1k6Yviv24fE3d0KUjBwwamMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyDHCLQV+2xBiz1vom6KZzM5P12UNu16eGgXfOQsbD0=;
 b=YcAwHQ3lZ64bK74JtgI/wFVocCud/fmosOyRDe1rqTDkSG3FgXJNFr19Xbnh/1MeuBCHL6tVS13xcYyXNrv0xFUWLSqD3x1otyTNNFlzH4IksgUoui4Pwm81PZfBqprDj1M6uWych4yY/VDflJts0zv9UfylP8cJN1aURzNcpliaKpWvy5/fahLqshcQNLDtlteYBVP8mc5d0bhcfjfoODY41Rp48u/LdcRX1t40Yri7FpDQNEC6NagLELNJtIrbSsa+CN40S/NQlTtkxP5gR9di4IUTqBdzrEggXhtQln55tU5qJtxohMgrxbaguBlJiFjkUKo409BaSVc8ivvk5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyDHCLQV+2xBiz1vom6KZzM5P12UNu16eGgXfOQsbD0=;
 b=bgr3EQkFjudHMH1gcy3XJjr9DRwF1sKGPmMv6MvtULz0nYfMO4aGZgkIA3isAQa347V+eNJACHijdBcDuccfIdhoFb8jlQkGn6u+mAPDxBCFCBTB0xIOkSlRUbQsoDKUqhslpuI0ZQ7nN4Tn9KaqNxawWQ9SgzFw3rSH5yEACZQ=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN2PR12MB4342.namprd12.prod.outlook.com (2603:10b6:208:264::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 7 Jul
 2022 21:36:22 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598%5]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 21:36:22 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Tom Crossland <tomc@fortu.net>, Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Huang, Ray" <Ray.Huang@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 5.17 42/43] Revert "ACPI: Pass the same
 capabilities to the _OSC regardless of the query flag"
Thread-Topic: [PATCH AUTOSEL 5.17 42/43] Revert "ACPI: Pass the same
 capabilities to the _OSC regardless of the query flag"
Thread-Index: AQHYQpXKqDZmoY/ha0SX34ykqN32Na10DIKAgAABciA=
Date:   Thu, 7 Jul 2022 21:36:22 +0000
Message-ID: <MN0PR12MB6101729CF68952653E8F55EFE2839@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20220328111828.1554086-1-sashal@kernel.org>
 <20220328111828.1554086-42-sashal@kernel.org>
 <872f2a21-7bf7-0cc3-298f-f817429f6997@fortu.net>
In-Reply-To: <872f2a21-7bf7-0cc3-298f-f817429f6997@fortu.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-07-07T21:36:09Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=617df13c-c6e6-4a13-b8ca-16edd70e8ec5;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-07-07T21:36:20Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 6914765a-9782-4dbb-9fcc-8b90f1ee8740
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc212039-61dd-482f-5703-08da6060bc71
x-ms-traffictypediagnostic: MN2PR12MB4342:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a71K2qofVxjXK4h40lbM8+WDXzddYY/E9RKZ1R0T7hJoJHn4XREvP1EKkRYdteUuqD0JItKLeFmV8+7mVpaowHOdDaIxYdkwmybl/oz++1INerkG/xlmd0691WTQG8hVlAfPg0rQkkWjqv6yCJeCCbn6SYeVR9w+MMBk2ZbFbAzjm/U5f2kL3atcki+fZkI/nBWHZ11xb4ivomn1B6mWOAOACGXCzzOhdd/Gz4Ju/8UoVT2Qd7YnyCCyD5oyU9ohfL6qd74Eqxl90Goptyvl1ZjlE09ZUjQPasOc0c4aM57lQIxM+/gFHKyOU00V6wAM2Fw9AwPXJc8TdWgazlw5J2tqxf4sHKu/t0iid056JiOZT6BrVcK9hfhUnSFbaKQgJnbe6ZuYjVfjpK+Ux8h0hfXKnlva19NwXyxm+h5opshZ8Nvf4wWDLautJuLlS7YOMWlvU2Cu89OvadF5AUvXHCBdWlOIUZhA2eDGBDbQgI1t0l4p5HcBmJMyt10qNuxZWMDR4rjR4UQ0I6kW+TAfF+2ohglJAsSeOYhhInNy5LBMMmVTbAkOpim7v9pcFEzoV1k2IzHr3dLN000ZQ0DLPmghVf/tuWxyy72FXERPiUliMcmt6K5xnkbKlE+xKHr9T6nETHXfhOubbm8aoyOk3MHI8oOMiCIxvqM7eKcvPrKVaGxCiHXdt85TZbIP4/3tV2ySbzjqNGSlCBAUSMZk53EtVhj1D1AjucO4zhAPCsh/+XMLT7amwKq7G86fbOcuM0wXZ9lnvaS8niJa88f1HsdJytBMcUUNe7/itu/AUs2YzKzCCsgGw1pDZcrMzAEKDDbvmG1xtFpSmi13fhCaBi6PQ4XeTL7ATIg9VBDZHZ77W4eAlrk5jHVHQZleCVQaP3L1qaPNxEns/qbURtSlmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(41300700001)(54906003)(53546011)(38100700002)(316002)(2906002)(55016003)(7696005)(6506007)(66556008)(66946007)(110136005)(52536014)(86362001)(66446008)(478600001)(45080400002)(5660300002)(83380400001)(66476007)(4326008)(64756008)(8676002)(186003)(38070700005)(8936002)(26005)(966005)(33656002)(122000001)(76116006)(9686003)(71200400001)(26953001)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?fgVwDR8VDRnSz/onc3ny1f4H8DXjfawhsV04BNXlwbpE6gMoo/hW53PqQx?=
 =?iso-8859-1?Q?U3pN0Xc5CCxiVoAiCeUBijji6GQ42WP7+5b3Gy0J9hiXTD5ijMAPZzNvLu?=
 =?iso-8859-1?Q?5ChptZ+VHU+uiEn8BnI+Bdt28mW1WKLnYE5eefOhXTsIbZxsSWJUp9S6rE?=
 =?iso-8859-1?Q?UnFDJ+/Ky9T9j8Q0HejA7fqUOMvMgwRUGCReJUfjSRwbRVwDreCyYjx44a?=
 =?iso-8859-1?Q?S03GAurDnuenuYDc3441BMjxXzPsw6BhW1SF2Oki9lFXtWUXNcSAhPNFmX?=
 =?iso-8859-1?Q?nk4RTP1ENqaQonpcceXaRLSkRCsIROUBGQMFN++WFcN4a9e3hrYrwH9vQr?=
 =?iso-8859-1?Q?trnUAH8ALtyOwb5xd/BSRentuAOMAd/X5GPZD0dqIKC5qfXFiTSd8bIKwX?=
 =?iso-8859-1?Q?JZeLeONVyvn3kmC0jwH86MMQk4AnrjFtHrnchRPsu4660QI0Bs9sPluvsP?=
 =?iso-8859-1?Q?wuP2tQmqHstEDyjp4qj/d1IBIxrUBn/LoodvSE73bXKAcKSjdYoYC5TLIC?=
 =?iso-8859-1?Q?1isqAGo6GNQ6hx3iOi7ZiA/I4WnZjT4Kj9vyMHHmw4wd9pMIwXAWDK5N0I?=
 =?iso-8859-1?Q?ulDUlLmOSbkHVwI1IxR/QJl54ziFuSySMaspLtWpJGu7AS+1S2NXvZ6SMO?=
 =?iso-8859-1?Q?eyEokbIgPvabUHgRjCtRivZzUrm4oJ/WASO2nEsocoOaXURM0zk7V7Gr4v?=
 =?iso-8859-1?Q?FYzYw54w/sEykAZAI9xrf2XAZEFMD6BD5+5Vmt2vKGeTQC8PhCkHiCtyOp?=
 =?iso-8859-1?Q?vcu5gVhZkoeKe3EGAbIkjlcpITin3FIY8K1gQjD5a4PxlO53KzHqFQAE47?=
 =?iso-8859-1?Q?4mcq4tJjHiKpRlUtkr0wcVVhXg0N+Hby4i3AKdqtqXRpru/3dRkLwFAZkX?=
 =?iso-8859-1?Q?oV2bk1hW+98DCLYm8vdzcbeaAlQhY/EkWGjwZKKGlsOI5bJlS532iu6sDl?=
 =?iso-8859-1?Q?9Kh6E1o/frMqCH8QYPNMB7YKorKwrhJXcjcF0HB/fNSllXb04rPJQCFyXl?=
 =?iso-8859-1?Q?QNuYD8BiOQund/Tl9jyGo8WAEA7DJv//sE+fWcYTeA5gDLA4OVqAQUnEKR?=
 =?iso-8859-1?Q?UDHQcciOyHmvXmfZ9qa7uj/MXHMY7dly9n9CwdH04gj3SP/07LyQyQEe+h?=
 =?iso-8859-1?Q?hMTm3ACeP+SHTmoRlD0Q6AAFttLPyP2sQ9CAj5S1Hr40x101Gah0Gjd+s5?=
 =?iso-8859-1?Q?8SzmF0ug5tpn/V8MMXoQaWZ04CviDxG0vxbFDnRpoNlmDzoJE9I6oWijYs?=
 =?iso-8859-1?Q?PhGGc0y8Vr5VpQs+s37p40QvV71RY5VVHDW8+3roM1pW4SrLVgtpGoMBDh?=
 =?iso-8859-1?Q?evU5LWJc0X1epB4iUQeTbLGs1zQbLy82QNXmhe/x6warvny/RAx8wRDszN?=
 =?iso-8859-1?Q?fwAFcKQGgOJRk+emgAG+jd4ULbSOPCwV/jHl67NUhSvgcnYduqUrmOQ1JF?=
 =?iso-8859-1?Q?eBvnOwvDgI5c1yNSnlK2BHKgQkRBadfhrz2bFO5Ry6ljme7Laig9wwlHXI?=
 =?iso-8859-1?Q?EfJE+nHdkGh6Em1cE3D/iQ4jflLIY+HFj+FLkpYBcZT5vezkOsIDjpueyc?=
 =?iso-8859-1?Q?bs4P1n0qrvYq450/KslxWU0Bl+cZjzK1TSAbZqKhmdKYkJDJ6SXfJaEZjc?=
 =?iso-8859-1?Q?RAIw6HoND49wE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc212039-61dd-482f-5703-08da6060bc71
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 21:36:22.0704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n74F8qqbOs2hXPfbQi6HdwhwWP35iwgtu5RWKMOvfOpunOWfeBxI/DJZ7ys3iYOuCxCZ1Ksrf+c5pQP99r0/8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]



> -----Original Message-----
> From: Tom Crossland <tomc@fortu.net>
> Sent: Thursday, July 7, 2022 16:31
> To: Sasha Levin <sashal@kernel.org>; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>; Limonciello, Mario
> <Mario.Limonciello@amd.com>; Huang, Ray <Ray.Huang@amd.com>; Mika
> Westerberg <mika.westerberg@linux.intel.com>; rafael@kernel.org; linux-
> acpi@vger.kernel.org
> Subject: Re: [PATCH AUTOSEL 5.17 42/43] Revert "ACPI: Pass the same
> capabilities to the _OSC regardless of the query flag"
>=20
> Hi, I'm observing the issue described here which I think is due to a
> recent regression:
>=20
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithu=
b.c
> om%2Fintel%2Flinux-intel-
> lts%2Fissues%2F22&amp;data=3D05%7C01%7CMario.Limonciello%40amd.com%7
> C77419b612f9540e333ff08da606002ee%7C3dd8961fe4884e608e11a82d994e18
> 3d%7C0%7C0%7C637928263354159054%7CUnknown%7CTWFpbGZsb3d8eyJWI
> joiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C300
> 0%7C%7C%7C&amp;sdata=3DX%2FEAU9GbRD%2FfYxCMUmnWI1cJ8dk8sICk0iYu
> %2BKGqtl4%3D&amp;reserved=3D0
>=20
> sudo dmesg -t -l err
>=20
> ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC],
> AE_NOT_FOUND (20211217/psargs-330)
> ACPI Error: Aborting method \_PR.PR01._CPC due to previous error
> (AE_NOT_FOUND) (20211217/psparse-529)
> ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC],
> AE_NOT_FOUND (20211217/psargs-330)
> ACPI Error: Aborting method \_PR.PR02._CPC due to previous error
> (AE_NOT_FOUND) (20211217/psparse-529)
> ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC],
> AE_NOT_FOUND (20211217/psargs-330)
> ACPI Error: Aborting method \_PR.PR03._CPC due to previous error
> (AE_NOT_FOUND) (20211217/psparse-529)
>=20
> System:
>  =A0 Kernel: 5.18.9-arch1-1 arch: x86_64 bits: 64 compiler: gcc v: 12.1.0
>  =A0=A0=A0 parameters: initrd=3D\intel-ucode.img initrd=3D\initramfs-linu=
x.img
>  =A0=A0=A0 root=3Dxxx intel_iommu=3Don iommu=3Dpt
>  =A0Machine:
>  =A0 Type: Desktop Mobo: Intel model: NUC7i5BNB v: J31144-304 serial: <fi=
lter>
>  =A0=A0=A0 UEFI: Intel v: BNKBL357.86A.0088.2022.0125.1102 date: 01/25/20=
22
>=20
> I hope this is the correct forum to report the issue. Apologies if not.
>=20

This is the fix for it:

https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git/commit/=
?h=3Dlinux-next&id=3D7feec7430edddb87c24b0a86b08a03d0b496a755


> On 28/03/2022 13.18, Sasha Levin wrote:
> > From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> >
> > [ Upstream commit 2ca8e6285250c07a2e5a22ecbfd59b5a4ef73484 ]
> >
> > Revert commit 159d8c274fd9 ("ACPI: Pass the same capabilities to the
> > _OSC regardless of the query flag") which caused legitimate usage
> > scenarios (when the platform firmware does not want the OS to control
> > certain platform features controlled by the system bus scope _OSC) to
> > break and was misguided by some misleading language in the _OSC
> > definition in the ACPI specification (in particular, Section 6.2.11.1.3
> > "Sequence of _OSC Calls" that contradicts other perts of the _OSC
> > definition).
> >
> > Link:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.=
ker
> nel.org%2Flinux-
> acpi%2FCAJZ5v0iStA0JmO0H3z%2BVgQsVuQONVjKPpw0F5HKfiq%3DGb6B5yw%
> 40mail.gmail.com&amp;data=3D05%7C01%7CMario.Limonciello%40amd.com%7C
> 77419b612f9540e333ff08da606002ee%7C3dd8961fe4884e608e11a82d994e183
> d%7C0%7C0%7C637928263354159054%7CUnknown%7CTWFpbGZsb3d8eyJWIj
> oiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C300
> 0%7C%7C%7C&amp;sdata=3DTe3BK%2B0q2QmrqqoG5mbV%2FNguoMgiwzILNHl
> %2BhUMLFlY%3D&amp;reserved=3D0
> > Reported-by: Mario Limonciello <Mario.Limonciello@amd.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Tested-by: Mario Limonciello <mario.limonciello@amd.com>
> > Acked-by: Huang Rui <ray.huang@amd.com>
> > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/acpi/bus.c | 27 +++++++++++++++++++--------
> >   1 file changed, 19 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> > index 07f604832fd6..079b952ab59f 100644
> > --- a/drivers/acpi/bus.c
> > +++ b/drivers/acpi/bus.c
> > @@ -332,21 +332,32 @@ static void
> acpi_bus_osc_negotiate_platform_control(void)
> >   	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
> >   		return;
> >
> > -	kfree(context.ret.pointer);
> > +	capbuf_ret =3D context.ret.pointer;
> > +	if (context.ret.length <=3D OSC_SUPPORT_DWORD) {
> > +		kfree(context.ret.pointer);
> > +		return;
> > +	}
> >
> > -	/* Now run _OSC again with query flag clear */
> > +	/*
> > +	 * Now run _OSC again with query flag clear and with the caps
> > +	 * supported by both the OS and the platform.
> > +	 */
> >   	capbuf[OSC_QUERY_DWORD] =3D 0;
> > +	capbuf[OSC_SUPPORT_DWORD] =3D
> capbuf_ret[OSC_SUPPORT_DWORD];
> > +	kfree(context.ret.pointer);
> >
> >   	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
> >   		return;
> >
> >   	capbuf_ret =3D context.ret.pointer;
> > -	osc_sb_apei_support_acked =3D
> > -		capbuf_ret[OSC_SUPPORT_DWORD] &
> OSC_SB_APEI_SUPPORT;
> > -	osc_pc_lpi_support_confirmed =3D
> > -		capbuf_ret[OSC_SUPPORT_DWORD] &
> OSC_SB_PCLPI_SUPPORT;
> > -	osc_sb_native_usb4_support_confirmed =3D
> > -		capbuf_ret[OSC_SUPPORT_DWORD] &
> OSC_SB_NATIVE_USB4_SUPPORT;
> > +	if (context.ret.length > OSC_SUPPORT_DWORD) {
> > +		osc_sb_apei_support_acked =3D
> > +			capbuf_ret[OSC_SUPPORT_DWORD] &
> OSC_SB_APEI_SUPPORT;
> > +		osc_pc_lpi_support_confirmed =3D
> > +			capbuf_ret[OSC_SUPPORT_DWORD] &
> OSC_SB_PCLPI_SUPPORT;
> > +		osc_sb_native_usb4_support_confirmed =3D
> > +			capbuf_ret[OSC_SUPPORT_DWORD] &
> OSC_SB_NATIVE_USB4_SUPPORT;
> > +	}
> >
> >   	kfree(context.ret.pointer);
> >   }
