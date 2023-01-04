Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D1865DD12
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 20:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240204AbjADTrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 14:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240263AbjADTrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 14:47:03 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084B013CE0
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 11:47:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LW29IrWESV2ovjaPMBwW6gDDHJ3MUHsxWbwk9TLF7nZFuPB56PXBqVD56+wxLL36gY6CVp90TGv70uXN7ysCR1FVPh8RTZ8CE98csy39m21RAKjExZ7sxPsjfa8T3BrbYnzD0NILRF6gg8kQtD/7CLjBwQNWp6GA8K4UkvOKwniB0mXabc+ow4OuhKN456pcN5a9YDAx99G1AwHMMqL/y/aU4sW6HJ/wNtNMewyL76lxSJghRxb+dur1UhRu7C5wNh6WSxuWCB9OELAFp03MBnFDiWT6lREVw4WCstF4cKRWpajN5BA4nWKYhssYfyWyL4JjgJJX16eBA3bocTJY3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yG36xSm9GQqWUxvWLoNmSFzjXs3cBsvBkDD1AwdSEKY=;
 b=oIOhBMSyd5NqG5lLlswZH7wi9sggOJ33XR1iVFlaWfT97zrP3y95VVwczUVWaYtY1gPEEeF4gnMaVCzB9RsrIsj7GBW3geTDTofqBATcAIo/SZ5mLC3T5DRSLjX38nXOnLTxDbxuSEKuM7Pd5CqKsCN1ZKt6vD+5eNMDMKeDf3HjPBqax8/gfV7it0zc9WNlAbimbKjSNwev56bEvt3QyrkfRU8oiPeAVUTmNFlypvg6S6J/V/FP25Hzmxy5N5uUingamrAbnuTGRdrSk9X5lieEG9NxvqBSr3/XkeOW5EJZXXn6V8iWOl81UJajIISQIRQkFObyA8L9MfwMVGQbRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yG36xSm9GQqWUxvWLoNmSFzjXs3cBsvBkDD1AwdSEKY=;
 b=X05TVO4BY6vAJULTbXgYecbbGOoxq/lrCHBMB1ai/UU6wH7dZOEfM1zgPc45RV88mDrOZirpzn9Hrxc7J3LlCMj8xh3srreFjJgK2yKBVDhMX19PXqepZ4rVr0O9Yd0W1YBgMAEXHZ8Uo1vmiiqw/4IZcM0TR8R1wMRUtAfyxeI=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by IA1PR12MB6458.namprd12.prod.outlook.com (2603:10b6:208:3aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 19:46:58 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a%6]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 19:46:58 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Backport using Microsoft GUID for s2idle on AMD
Thread-Topic: Backport using Microsoft GUID for s2idle on AMD
Thread-Index: Adkgc66AuUVmBddpSsSMQMkAUqCRYQ==
Date:   Wed, 4 Jan 2023 19:46:58 +0000
Message-ID: <MN0PR12MB61015DB3D6EDBFD841157918E2F59@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-01-04T19:44:27Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=310eee92-6633-4cf5-8b09-c64c049098fd;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-01-04T19:46:57Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 40f36978-68b8-429f-8427-6de09e8ef517
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|IA1PR12MB6458:EE_
x-ms-office365-filtering-correlation-id: faffb5e7-dbbb-4315-3c40-08daee8c7122
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LFJ9e+JOpfjBYWIs1+7AiRhYPWMDqWJTiCl0ez08CdIk2kBdYonX2fusW3L97uMixBzq6u/u22T5yWKkr/lHpAyEf84425tC1PF5nCi9hi1bzOS/zHvbC1/XGJA7XJHooa8Qas7M/YmjTVGKKUY8ge7i9HYrBMy70T+ZV+h3lXxZa8q7mA4qRxDM9oYK+xwhUIonVqBolihgCkTz4B5bA2xLUJjoyz9MM8/L4MveCmXw8z4yoR6kjiaEO/cN1kg4FPXtpFQX6xrtk7Ux30J588Ex7ypo0KzFWgXcaT9es7z+51UiU333qCGCEikK+jJCjWxngrZjywMM9PH1mXMlc+8Ul9zmao0GR9Cvo5ihdW+YtlaKPb+IHOYmnm1h2q7nem0cuDunaxqx/nzok9NUtHrA8dtYSjORWN/AuXnDX+FGMia48YjNKcX1dhXVe3AL2a2VFby+eySPFIAlryyM/FGnJDVyAOqexrsgwwCRFSO5lTyRaCB9jYll3jZU85Wyp4YmWlO+2RJyO/wxNTk2jpFvp9RqDrgJiv58hyjcHS6HzHzl7o3KKH7KPLRo+OQbOvsmAHrYY8j4ZTiZ94xbqp2BtOuUC0/9a/QZYSj+iTNQEjA3SqddGDV6bPNnDo5w7+kvEXS6CWvihGiI5U4gEH5hNfElqUtilaHHxIhef2dRnXLqVxUXnIY9bnUKIEmOEITUY1Qvi8A8+zsqk+dZAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(47530400004)(451199015)(122000001)(6916009)(55016003)(38100700002)(38070700005)(33656002)(86362001)(6506007)(7696005)(316002)(66946007)(66556008)(478600001)(64756008)(66476007)(76116006)(186003)(9686003)(71200400001)(26005)(45080400002)(8676002)(2906002)(66446008)(52536014)(8936002)(41300700001)(83380400001)(5660300002)(52230400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LQbubv0ygzSoekgUFmHPAwMU5MhtyDeljBW5I1jr7p7rurvhVUKZoNp5DyJv?=
 =?us-ascii?Q?jqbSgCS8WyGKgENqRmAHBAf2ag0aigbWWxzVhycPteBOSLBgH7wdwfkXWVhh?=
 =?us-ascii?Q?jOIV24pf2uFgE+YLXZPDTNuKw332X5ZK9WHyadWodFcTNawF/cjhdvmjeOQ5?=
 =?us-ascii?Q?orUtXSZ3pSAXT1RkGCpaohXUgF2fUxb4hVqecQ6aZDKMsixzeifbzxzv+nl6?=
 =?us-ascii?Q?SGp2QfKbQsl5qCjhqaYGN6XTGI3DJ/oTXMR50sY4oCgW/mxpnGC1TyEiSirD?=
 =?us-ascii?Q?bjPXX8xS6g/t8SMUa52RZN/t2iZ3yANgCtoKb+3PpINMZ+g0/u9SdOQezQhE?=
 =?us-ascii?Q?FmkSq1P6I7wT61tl7mv9GxgQnqu1RJylCIdDjUEuy18hG1696C74ekmGj0or?=
 =?us-ascii?Q?XHH2FAAXQdIKLVQl4vkM4lJ+LLZAZoxN1sWNuLGpGQFWK2+dZ46o4g4wMr/B?=
 =?us-ascii?Q?QprgNhDC3RYoWbqgkqKq9bsegmXKZ9BR7j9F+5vdZBH9t9L/OZJ+UoRkpGg8?=
 =?us-ascii?Q?ehCV9ouDFGx5OP305AfudWuMAFTeYKOnAJEJbjXJ/ZV6pkAs/s9Io/tc1OBv?=
 =?us-ascii?Q?SBs1BGOWoC/JUqfZYCrGTRB5ElJLNkIONUzDWGzzVP/Mc1Lxj1+KhcjJQgiS?=
 =?us-ascii?Q?bfveGrC3/hCx2HzDDWKbTEVDd5POTzACh/ztg7Pb/9MmFUH1pAC5NbJnhb5P?=
 =?us-ascii?Q?aJHIPpPgn82j88SINdrLA6EKazhah2rN1sF+JwLqir7wYf62GKiMdMy4SjjM?=
 =?us-ascii?Q?CPULL5ziMuww2FiOcTz7nRsB4ipjkYMTe384k+6U9LRXqDwoeyBrdUuwYUS/?=
 =?us-ascii?Q?ToDmVnIexHj48a/0N3H69GD77TJyxhd22WT2v9FHLhfX3nmkrbnbj3tIzk3s?=
 =?us-ascii?Q?dI/lAUE6oi0F34WWVDlZvidtelRoWkgbKlHIuWsPz8qaIVk6raMdka4YdLWi?=
 =?us-ascii?Q?jOSoY1Nz/KEU33tUMXz+cwiJUO3FKAapcajadLd0EmzSxPEMTnRdGxrev0Bp?=
 =?us-ascii?Q?Icc3QqENZPayLkvi3IHJeJNDycjBJslRtxhusmfpCnFGZxQwLiEqzk4wCD89?=
 =?us-ascii?Q?q/jEsNysi68n1cl2Gkui1QBDTa9bsG8gVVhymwh1+qm5qgh+bzavCpc7UMk/?=
 =?us-ascii?Q?T9cS5ThAi2GXkMKRd6SKJbvI4mpPC+Gy1nqgjwVr3d2Q4DFV+k05G3Q1zSX1?=
 =?us-ascii?Q?j+VPdQmlT6mKE5g0RqlDMddIgC/32aKA4KeTCQ3EkWZ5IduCXQF3rxDoIkQ+?=
 =?us-ascii?Q?YxZXjUiJDUoq45B97sLVZ69/kc7sYWhKIvQFmBG4ganTPplm2a+//n8uUs79?=
 =?us-ascii?Q?iDUapcG2gtHIeqIkMu65hF7r+TLBMLipuOngVz7NTSXLYIBZPUrhoEXGSVtd?=
 =?us-ascii?Q?FQ0oeO+xbYC5fmkxbP+7d60/uts49nInFq2SElsXana6LVpBSNOqTgSDFEWD?=
 =?us-ascii?Q?WVNMJ/xwGDr1FjnR5OPGAXPJdyZVJ4LCeEqTtK8siN5bTK/Bp+fl9Bm0PynS?=
 =?us-ascii?Q?zb27eqZxrKdWDDTNMFyMocMw9yhUFCKAIjlL9M9kVT4TONdJs7lEsK1eAYp9?=
 =?us-ascii?Q?OMRoGQ3URGpNYS6Fn7g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faffb5e7-dbbb-4315-3c40-08daee8c7122
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2023 19:46:58.6935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3yOPMJqSdxJMZNeeukCzzzpbwLFSEi2/ZZ/2+vRak7Dtm/kQ8dnXtYmTJ6rAd0E15bDOn27TIve8jlV66u9tdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6458
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

At *least* 9 models of laptops across manufacturers have problems with susp=
end that are root caused
to the firmware not properly implementing an AMD specific codepath, but tha=
t did implement a
Microsoft specific one properly. To fix the suspend issues on Linux, a numb=
er of commits have been
worked out over the last few kernel releases. =20

We have eventually landed at we're going to just use the Microsoft codepath=
 in Linux.
All the patches to accomplish this are now landed in 6.2-rc1, and also in 6=
.1.3.

Now that have this all working satisfactorily I'd like to bring those fixes=
 into 6.0.y and 5.15.y as well.

Here is the series of commits for 6.0.y:

100a57379380 ACPI: x86: s2idle: Move _HID handling for AMD systems into str=
uctures
fd894f05cf30 ACPI: x86: s2idle: If a new AMD _HID is missing assume Rembran=
dt
a0bc002393d4 ACPI: x86: s2idle: Add module parameter to prefer Microsoft GU=
ID
d0f61e89f08d ACPI: x86: s2idle: Add a quirk for ASUS TUF Gaming A17 FA707RE
ddeea2c3cb88 ACPI: x86: s2idle: Add a quirk for ASUS ROG Zephyrus G14
888ca9c7955e ACPI: x86: s2idle: Add a quirk for Lenovo Slim 7 Pro 14ARH7
631b54519e8e ACPI: x86: s2idle: Add a quirk for ASUSTeK COMPUTER INC. ROG F=
low X13
39f81776c680 ACPI: x86: s2idle: Fix a NULL pointer dereference
54bd1e548701 ACPI: x86: s2idle: Add another ID to s2idle_dmi_table
577821f756cf ACPI: x86: s2idle: Force AMD GUID/_REV 2 on HP Elitebook 865
e6d180a35bc0 ACPI: x86: s2idle: Stop using AMD specific codepath for Rembra=
ndt+

Here is the series of commits for 5.15.y:

ed470febf837 ACPI: PM: s2idle: Add support for upcoming AMD uPEP HID AMDI00=
8
1a2dcab517cb ACPI: PM: s2idle: Use LPS0 idle if ACPI_FADT_LOW_POWER_S0 is u=
nset
100a57379380 ACPI: x86: s2idle: Move _HID handling for AMD systems into str=
uctures
fd894f05cf30 ACPI: x86: s2idle: If a new AMD _HID is missing assume Rembran=
dt
a0bc002393d4 ACPI: x86: s2idle: Add module parameter to prefer Microsoft GU=
ID
d0f61e89f08d ACPI: x86: s2idle: Add a quirk for ASUS TUF Gaming A17 FA707RE
ddeea2c3cb88 ACPI: x86: s2idle: Add a quirk for ASUS ROG Zephyrus G14
888ca9c7955e ACPI: x86: s2idle: Add a quirk for Lenovo Slim 7 Pro 14ARH7
631b54519e8e ACPI: x86: s2idle: Add a quirk for ASUSTeK COMPUTER INC. ROG F=
low X13
39f81776c680 ACPI: x86: s2idle: Fix a NULL pointer dereference
54bd1e548701 ACPI: x86: s2idle: Add another ID to s2idle_dmi_table
577821f756cf ACPI: x86: s2idle: Force AMD GUID/_REV 2 on HP Elitebook 865
e6d180a35bc0 ACPI: x86: s2idle: Stop using AMD specific codepath for Rembra=
ndt+

Can you please backport these for a future stable release?

Much appreciated,=
