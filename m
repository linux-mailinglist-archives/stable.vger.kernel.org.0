Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6D95EB095
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 20:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiIZS4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 14:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiIZS4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 14:56:31 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6041659E1;
        Mon, 26 Sep 2022 11:56:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnRg06zHwq4LaZjpFGPuZlwE3vrj6hAm/pCQwdrAL+3iRaZIkYasE5lia8TAAJAK3LyaZlgBPMqw18d1oiLdkB7V3wcYNFZOJndXIi/WBYVfQ08rwj6UEg5bKQHRgTlIz8POVvGxGV/HWPqypGhpZJTMMqo0DRf5rVU40O6Gn8S+enHC6MAYE8o4gpIncdDnRGhb/zoSVdv4lKxz5ttm0tV/VUfnIK+lTcqYFdAkpM3f0Z+7tvWxyCZaaGbJ+walohqQ8Gm5hBLxTk0HmoHI/4rFrKGyFwrvtETJXY3lRkr4byNdBWQWc3GGz8ATyjrYmSF70Slk32TRumGqcoKyJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lc05/qMeY3a/IRGHNCPTDSza+m+H9ny3+Z0pNqJfnxg=;
 b=bNzsHnnfI4Z/j2OIVSEJW78p9WyZWS18vErCpvXNYoOtN8CcxsZ9tFCOa6YSMNHo5UrFK160UN5+Mulh+cGq292HAlJrcmC9TCfKpw2U6Ka1zNCKEkbd0kz6EXEh688weSKDnE9x4rsOGYcPVLoL++vQWdr7KLrmmnW2hOFtWvK4oW3AevtxaOow11jxwXfeSf8WE1u5WX+N50/n6w9BFD4vM3RcUhLsNxpbsw/ozvs7tIS87NqkUFHnsA0oWCiY+q8+s8VcfW+WWflgdzJpLimqQo9s30+PyO96/VBx92cYww1daT173u5uWRFMLk0a/mDrWcUIqgN5+VUALqrqaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lc05/qMeY3a/IRGHNCPTDSza+m+H9ny3+Z0pNqJfnxg=;
 b=P7lv5f2FKVx69jvihK4cFpL7UAheN1TpDlZv+MJKsBP/otAeeamSQEproT+knJDKYibWmmmHJvzlX3CAzFVP1xboTob+n4CO0liHB1Hj7EN2FBqdYHWkD1atTxA9RRoEgRHXM9Bic2NgKzAwSH+8Xw7KSeo4hzruiCxEwLVzFLQ=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DS7PR12MB6006.namprd12.prod.outlook.com (2603:10b6:8:7d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Mon, 26 Sep
 2022 18:56:28 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%8]) with mapi id 15.20.5654.024; Mon, 26 Sep 2022
 18:56:27 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jaap Berkhout <j.j.berkhout@staalenberk.nl>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: RE: [PATCH] libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and
 BDR-205
Thread-Topic: [PATCH] libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and
 BDR-205
Thread-Index: AQHY0dcgm/L2xMbUg0yw4FSft6eyK63yDz1A
Date:   Mon, 26 Sep 2022 18:56:27 +0000
Message-ID: <MN0PR12MB61013BB7AAD6ED1FBA63C269E2529@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20220926183718.480950-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220926183718.480950-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-09-26T18:54:54Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=5202eeca-bdc7-4a56-9b6d-b69c2604a2e2;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-09-26T18:56:26Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 771a66db-73bd-47f7-add2-a1c3087a6d87
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|DS7PR12MB6006:EE_
x-ms-office365-filtering-correlation-id: f448d21d-b0e1-4f18-5efc-08da9ff0d14c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BgQVQotWLf/+zn5z0ukQ52o/uo5tsaxcDx+71vangIq6Y6o76YHztQtDcNFatgdJiBBLhJvNQ2nXALy++S+/CHLsx/SDP9058y8DSR5YreJz4uIh0fyECFaxq6Kg/EDU4BgTaiRW6UM4+Q9zKsrH5IvxNRpg4QftrhsnNDk4KGTi3qu6MP1+nCvcKE7DlebwmzFG6L7A92WKAB5crSQeUSIGiFUzwh97Y+/Qqu8ztHmqqZYr4b3ZlDcG/S8IeT+Gujlj+i9Ior6d3bhQKHIXYVmxSHWEx3l62Xsrr3rurKNEzcq4fBQJYLmcgy7i2EBRjzzwm92TVLr6dn+4zatFXSj9E5DljsCOebPUdVKoFnCrKVS70uKHek0NnjcjA8R5qK3PovDxc3+0rho9FHIHnKqmrI7S3LUV+45IqP6gP4G/XvOQFo/2wF3Jt043OkJlx9zvKj0fXfEZ11Iv117s7uUHPCjcx/Lt2Nenw9xf3jTrT5DmR3AkFvMWwshr7t/JtGcqlq3oG2+jtqvYTHb/uklShYd5I7XwGuxvdn6COJDs+MZea21nUVD21ZU62SkiR5UneIFpwyWS3SvSDBqgRkfelBZ3qjS1odMxey5nmn6ldhjP9Z13PUq92B9nrd95qLTzJC4ptU71quDZQTkxDG0NQ5EGXlwrfywgdcrJAPoGYNTni1dVph8qtobpR87ud19roe7paQxw+I0+64o4t6rFFmJgVrGqtOjrm+AIqkl63JFpKVIiv1SZ4I5xE90i3ZZT7fmIyJGvHgPxgaH1Ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199015)(55016003)(8676002)(8936002)(53546011)(7696005)(6506007)(2906002)(86362001)(186003)(5660300002)(9686003)(26005)(52536014)(76116006)(66446008)(64756008)(66476007)(66556008)(4326008)(66946007)(41300700001)(33656002)(83380400001)(38100700002)(122000001)(71200400001)(38070700005)(478600001)(110136005)(316002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IfZUJjNSFwp18um1Dkwl6ea2rtnNJ2DluIjoZG4XsbSfVMrYYt/KRdySdJfu?=
 =?us-ascii?Q?P5+A0+VWo+onZO2LmNSwCNCa6QwwCmzZR3yydjuzNgfO5Mzt01b6xkAmdGlu?=
 =?us-ascii?Q?5Va91/RKWKrAhscjn2HoMbKZxuz5663p//pcLLbNqNu5U6mBZDbuPXJGy9It?=
 =?us-ascii?Q?g/S9wNoNLwXzk63sguqYQGdPFtU+wpQxYB4POgJ7svrRnS7KmO2NauZQ17PZ?=
 =?us-ascii?Q?uxEC0GwjND32j50oisuvdrIUOEdaJz4SiZV8WWBRnQRir6ppzmIgj33NckG8?=
 =?us-ascii?Q?gejaskNjNKIP6ZR4qzKm0293Q7foHlrPfkV+nDDwN2Ll99CjY86X1nfY/hTR?=
 =?us-ascii?Q?naFdT/NpSG92wpo0Yu5xDJNkaxyQDf8lwqSOvaos5K7zptHfDYZRpisQDny0?=
 =?us-ascii?Q?R1W8zaBNkXbHpomQ0U1DA6g8oNhXbWS/XhHslUgVszFdq/L8SvUKDR40ijRb?=
 =?us-ascii?Q?jyquvZaCnT+u/wddarqmcCgp3dic5WmOShyC/3kaTW8Qq6yE6PDPIV8IP7ZQ?=
 =?us-ascii?Q?n14rmANO4Hw94WtwjArXRMS/XDLWNd+TXTv+OaEqdRrJ8rgXVCylqX/6t9ud?=
 =?us-ascii?Q?fq2L7zpWQ8OyEFtGOChxu/XFNMzyoql4NgPdpuftLTKYaw0A/91f+qv6t9g3?=
 =?us-ascii?Q?icVh1RLls5fKX1Sdz1Ih1bqJLsscSUU2tS5GH78ilKixc3RWaaVufoJ0/xgL?=
 =?us-ascii?Q?gUgXI1e4sjeGLeR/lwUoBm4hnW5uTGNseHq/KYv8x3tKHkErQpj9+NZ3JY2e?=
 =?us-ascii?Q?VV+jQoHhdVeGKhQwu9jTuF54d7ZEczJ4kWsdB2KoGmuMXjsMXkD7281nSsZg?=
 =?us-ascii?Q?Mj5IsFdMKMVctjGY6FMpZK30BXfPuYHxTEKKOmJ7La9I0+ZCsYMJVLcejqLQ?=
 =?us-ascii?Q?5IbjPEHkEaeO8XG4LCzqbAYH6UEgLh6obhgiOoGdpMO7L3xtn3T4SIS7htqf?=
 =?us-ascii?Q?NmjR/WebNTJSxDw/lKwUXgwXkbfZ7OD8qmYInEal00SBfPMCzQs1jSfLRiha?=
 =?us-ascii?Q?dgckfsT8FUyi8DyfWGKH/iMS6xflNcsJNIBg8VuyHqAM9S9HJEu+mWGRJIDp?=
 =?us-ascii?Q?kivEkwnyFHiCpOH5oF4aIGCo5vktoF3Ng+gOY8WeEj1tduv3bWt+rMbodITv?=
 =?us-ascii?Q?UNsto02ggUVG/emRfg/D+37quMv7o+UoDyGLfcomhnKfWF+JJ/OA/lMHwrav?=
 =?us-ascii?Q?jG9lLopKltlp+qtWLc5BkB5MRWEonmJ9UQQcli4WjgrOzFtl3nEnIZmgPeHD?=
 =?us-ascii?Q?n2JKkEOdd9kj++/ApocgeWIVZhhZM+DUQkljm3FGfVE9o3Y2blftIbbvSqKg?=
 =?us-ascii?Q?KP2ANyxKoPgn1+eG3HAf1tJrd1V49bSw3IwXFB7SGY2VZvQjMpNK+/dMSF3S?=
 =?us-ascii?Q?W7tqTpQMn56Vt+FfXRCa3TUeX8oeClwkhQKbvusORyKw6u8QfovzWdTHRjlS?=
 =?us-ascii?Q?iUzL7dLkIzuq7oo8HIVXBJy1YV+R7F77yeRFnbupMb8EzyQFV/zFVx36wEGY?=
 =?us-ascii?Q?WdFveFE8W1gPyVmaFd3PvXQCviZqVN1QU96h8mvcxk5Md0q6bAD+nZlap9Pc?=
 =?us-ascii?Q?CRrv43WWZov1bXL+NmQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f448d21d-b0e1-4f18-5efc-08da9ff0d14c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 18:56:27.8445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: snLdFlTvwfx1ikK83Ri/0xlIiZxKJSWUOseJeymEsP2k6PPSrT4Ys1+uIen9cfca+HmLWQfG/tKdf8ReQ/+yWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6006
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



> -----Original Message-----
> From: Niklas Cassel <Niklas.Cassel@wdc.com>
> Sent: Monday, September 26, 2022 13:38
> To: Damien Le Moal <damien.lemoal@opensource.wdc.com>; Limonciello,
> Mario <Mario.Limonciello@amd.com>
> Cc: Niklas Cassel <Niklas.Cassel@wdc.com>; stable@vger.kernel.org; Jaap
> Berkhout <j.j.berkhout@staalenberk.nl>; linux-ide@vger.kernel.org
> Subject: [PATCH] libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M
> and BDR-205
>=20
> From: Niklas Cassel <niklas.cassel@wdc.com>
>=20
> Commit 1527f69204fe ("ata: ahci: Add Green Sardine vendor ID as
> board_ahci_mobile") added an explicit entry for AMD Green Sardine
> AHCI controller using the board_ahci_mobile configuration (this
> configuration has later been renamed to board_ahci_low_power).
>=20
> The board_ahci_low_power configuration enables support for low power
> modes.
>=20
> This explicit entry takes precedence over the generic AHCI controller
> entry, which does not enable support for low power modes.
>=20
> Therefore, when commit 1527f69204fe ("ata: ahci: Add Green Sardine
> vendor ID as board_ahci_mobile") was backported to stable kernels,
> it make some Pioneer optical drives, which was working perfectly fine
> before the commit was backported, stop working.
>=20
> The real problem is that the Pioneer optical drives do not handle low
> power modes correctly. If these optical drives would have been tested
> on another AHCI controller using the board_ahci_low_power configuration,
> this issue would have been detected earlier.
>=20
> Unfortunately, the board_ahci_low_power configuration is only used in
> less than 15% of the total AHCI controller entries, so many devices
> have never been tested with an AHCI controller with low power modes.
>=20
> Fixes: 1527f69204fe ("ata: ahci: Add Green Sardine vendor ID as
> board_ahci_mobile")
> Cc: stable@vger.kernel.org
> Reported-by: Jaap Berkhout <j.j.berkhout@staalenberk.nl>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

Thanks!

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>

Since Damien was still intending to modify the default policy so that LPM
applies everywhere I feel like more of this is going to show up.  Should we
consider to maybe keep all CD/DVD/BD devices excluded from LPM?

> ---
>  drivers/ata/libata-core.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 826d41f341e4..c9a9aa607b62 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -3988,6 +3988,10 @@ static const struct ata_blacklist_entry
> ata_device_blacklist [] =3D {
>  	{ "PIONEER DVD-RW  DVR-212D",	NULL,
> 	ATA_HORKAGE_NOSETXFER },
>  	{ "PIONEER DVD-RW  DVR-216D",	NULL,
> 	ATA_HORKAGE_NOSETXFER },
>=20
> +	/* These specific Pioneer models have LPM issues */
> +	{ "PIONEER BD-RW   BDR-207M",	NULL,
> 	ATA_HORKAGE_NOLPM },
> +	{ "PIONEER BD-RW   BDR-205",	NULL,	ATA_HORKAGE_NOLPM },
> +
>  	/* Crucial BX100 SSD 500GB has broken LPM support */
>  	{ "CT500BX100SSD1",		NULL,	ATA_HORKAGE_NOLPM },
>=20
> --
> 2.37.3
