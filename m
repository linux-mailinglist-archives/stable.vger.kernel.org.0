Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76A152C391
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 21:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241945AbiERTfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 15:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241933AbiERTft (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 15:35:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46310B08
        for <stable@vger.kernel.org>; Wed, 18 May 2022 12:35:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LW0wriFKk+4xgGIbxRD0PHsuD1wfghfgrG8Sg8K2jpHCLGat3BTD1KqQVcBAh/PYTbGGx1+fsGZFdDr41Hg9b+ka9SlVqJ8kRQu6TSFvn2rdiNfPcB5VHqqvndhrxw62lxsHrDp/+RKqPg0KEfGCzUyrgC3Yw82PcJqOCzScKpdCDCPKhzdqMuBZAXUAlQVZmrEEiA5g83R3fR2ZVYh6OryhxNS2LyrmO5oBG6pG49jTByB6vef9/pQiWQKcWjvpS2BnrWLsTs3yb4KqtfXIh2YRXnvFfYrDMLdksbi/FeNN9gLghJjphAQyi+E7j8D7kMLwvwKRdyMGvLGBWAQqvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwAmrKVh96839KSpsLYt+OF2HHA9LBCmskhYt1Lh4sQ=;
 b=DcVuwAneAREzTEIRI2y+EnIlfeYHhK4El8rSlx/hQ84sVaCdWRvdA75OCcvhNW7qnmJ8albnlAppm5HRK08zHua0wmdIga7bGiHZFKQw9j5gRaARiSP8ErQBsBn/zR7T1tLYPlyr1YZsWoP32NSBx7GMWIHVNoCfqjAtChQ7fzTr8VbLhYxYXlLaE4gzBokUs+lJi1CE0WrmJxGu0DbDe2m53oMYTc5qiQjruV92yF+y6e2QMcjqcGNbvfBEf1mDUEI0zPgWW2wAnuuAgk4n3CHPG++6JxkTpkGfs2Jl7P89vRTFoPqjJGK/acHPFdnVoXAPChyUjQaU4uMTCgW14g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwAmrKVh96839KSpsLYt+OF2HHA9LBCmskhYt1Lh4sQ=;
 b=Un9MPOM2WYyFraQvBiHcqMo4E+i+W6fDxsgwiS8Bn/TTkzJaiC9bbaeQTqjvM/1tttja4kVDPu5tbs7hCh/an8VrWdOGV8OaKeBuXZeye5BtparYzyBvYdr4Qp+A4R3nzWzTJeH6VEZzVSMnG+ijxleWGo9pLpK8Eza0wztRQ/8=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN0PR12MB5883.namprd12.prod.outlook.com (2603:10b6:208:37b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 19:35:41 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db%6]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 19:35:41 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: MMIO support for I2C-PIIX4 and SP5100-TCO
Thread-Topic: MMIO support for I2C-PIIX4 and SP5100-TCO
Thread-Index: Adhq4reH43WetIzZR5SToc8Xvr1SIwACk4AAAAATSMA=
Date:   Wed, 18 May 2022 19:35:41 +0000
Message-ID: <MN0PR12MB6101658686E4C29D64920E3FE2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <MN0PR12MB610150AC5F1E15D6A67AC352E2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
 <YoVIJB/d8Ei3iJiE@kroah.com>
In-Reply-To: <YoVIJB/d8Ei3iJiE@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-05-18T19:27:35Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=aafd7242-de84-4bae-8a32-5e70366ed548;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-05-18T19:35:39Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 6b9c2ad1-a595-4083-bd37-6bdd5ce00327
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e78fcf5-9141-44e2-0a8a-08da390597e1
x-ms-traffictypediagnostic: MN0PR12MB5883:EE_
x-microsoft-antispam-prvs: <MN0PR12MB5883F6587C67EB1CA286A469E2D19@MN0PR12MB5883.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 88GWc7Oa35TetUU0RHYA9hKOczndImRLOwZzqEtgbIbVHKkxOI+uKG1b6UwXqfdjy0LQBYvmcfEYUsodyjm35JZHY/r3PgDirjlEpzlrkre11Ugpovhaj8RdF2qSvtHIjeFk7k7Ees0YBuLzIoPDVs1NIEyYaQEl9cwLE6BEPYwU9a2nRB58S7jfCU4MGia4zVDjPv/257hYfJgH48TFzHZlIkfPCj9WsbNRJARddqHe6AH/j5KpS5XDahY4u3+GpBZN5ocShqYNXehTcfxbGDJXkWCt4sEkLrE4L7PexhLyof18w4gVAPi3YmGbT0OPwVXN3XtE3s9XuiCHoaaRdUx/cU6q4c3qomXo/f7jp5jb1LXNN36z2fadJX2Vp4bzjQh2Isj8+r+kKyuYgxdtTA8EdzqjpQQLD0IDuTbBb1yw4rHKM7Obj+dGvJnc0wgTvT1m7dtF8ExwBCqrThrZIDN0JjdAcJu5UyU7C5gtI3YoNlrfaR+eNgMes50zYZ4RJA4LEfiMxgn/MzEW9xRnvI9uQSdabttofDSHJxxzPbdx6KVuzX/XuTO9auEqj1FsOGYTzlJQ9hU6124FAr4/f/z+JCX1ueWKfG9vy7uuSYybGeo/sVJisrfQGrH/+jrXztzGzZGdEyQTKBz2aNepyS3wm5SZ6h4XfKhSL+1q/4qUnVQG29YdptDeTmClGGub7BA8MxzIwoKi14XjNXfxRT2bYmmQ0wIHtEQyRStvJfge6qcSW0xcp5txeM+V5g2l/yEVaH3yEUQcu9Ncy7K4JHQFrLWfnGclA0YDbbeDD1c8KueQ4P/O1q/yQk4q6F/xLw6CYQ0f9LTXvG2MxxGyZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(122000001)(4326008)(86362001)(66446008)(66946007)(64756008)(66476007)(38100700002)(186003)(8676002)(2906002)(9686003)(53546011)(66556008)(76116006)(5660300002)(6506007)(7696005)(83380400001)(508600001)(55016003)(966005)(71200400001)(52536014)(8936002)(316002)(6916009)(45080400002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jbOYnkHGp0FRK4I6dbr+/PfHVAANR3iabEF5ztTKX8U7ViseHdja5o8F1BYV?=
 =?us-ascii?Q?t2pDWKd3V4Y5+yTdamVbTqyR2mSADcxX0GQ1UV4EirkrbPAQRzL88Z0DZ8Gp?=
 =?us-ascii?Q?TC5zgmklS/xaEsXBiCDcjPGoV8eR2QreqSH1QJjOYWEEhf15lZbQX+07NxWN?=
 =?us-ascii?Q?qii6zFG2WYDAR2Q1KTpQrtjQti5vhcLjqUwMyp3aleNQwptuqpKoAGaHlXbu?=
 =?us-ascii?Q?pFPCwTOOrhBqWlrrdgHj+9HDUz6koetYp38r/WQA3kbjQ7NcEpd38oUxkyq3?=
 =?us-ascii?Q?Vq/ucOiUGVW5f9MY3ib+5iBg8Z+mxEMacjf682gzXFRg2NOml8uYubhP9yRr?=
 =?us-ascii?Q?LSDFfysrUB9UXvoQXzRXNgaHcgDz8Pt2dTW+2tUwlFtg8bJ2hRqfMfBj9+dm?=
 =?us-ascii?Q?G4oUulj7j7HdQlsnHR8CPU7KgkjJeUOnY11nuEczSipsmZxiZW6oxfSsOT3/?=
 =?us-ascii?Q?565xz8ihkny9mC/OokWkukxtOsMZOZgfryeDXFFVVqakC1445qtKA0Z5B47l?=
 =?us-ascii?Q?fBewjkZAZs89Fyx8/zVY5fWi3vKm7/eDgKaolzZ1S6m3eMkFmZc43qIuCtfO?=
 =?us-ascii?Q?GHCYwJB+4OsdTeL5X+Fjq0+HJ9i9zCrAoIk0il8SPZRr/gMyask1DM33i1m3?=
 =?us-ascii?Q?WyJ6Ck7kXOJxmwOWPTFdPP1/8KuRlDF1JOum8mn37p9e403g031vqniiB8Ke?=
 =?us-ascii?Q?cC5jL3x79jHQuAtamwzOpGiYQFrUSnFUAxXQl30ryz3nNY9r0W0zE94VI0Re?=
 =?us-ascii?Q?vuHA1vq4fL410pZXBr6vllKH8/LMPlTlGF6FFh88j0a8Ts07BZ9+wlkiLNaT?=
 =?us-ascii?Q?UjdSB9qov3J36NsqplbFanBfdiVMasNlQranjq0//0MQq5CRIge20t/2v6pT?=
 =?us-ascii?Q?JWp2vFF2+yS/NDLFxUrArwmosV++W4AYAau5Hjru6aQrZMBPh9k3NNnjTD8s?=
 =?us-ascii?Q?Qgh4mItQC8JxdOBnweCxd5ZuQvWXd6gLsdE6fzsRGAZcUbWKQ9tIRJIb9E6i?=
 =?us-ascii?Q?edywOksBWVddG0xtlINAxXBPVwTYrmPihXrkicpAwK5I6es52WkuEd9qEx1R?=
 =?us-ascii?Q?srnOiAMfepY5tYdXyyKYkWrH2COBp1DOtWOpd9mOPonvF9Zvx2N2GGTgHF4u?=
 =?us-ascii?Q?yhOpzXFXmF/XLXUaxtIZFm5sC/H01D3OjpkVpqOx4Ygc/22js+Z7Rnj6C5WS?=
 =?us-ascii?Q?vQ8+S5bsnwYjW4/kNu/wHYBxwxKUAf8pp8aFgNYzmYIbQ3QfvzAb82n3cCMR?=
 =?us-ascii?Q?norwu4s+R6a9t28Md4kxGiNkS1GsG6b74apNwRC0O2wffK7hpXsXPNulAiIn?=
 =?us-ascii?Q?f8cz/TQv1bWFdQDMWUe+5S0FkBvzT0DPmCv2iMJ8uls/82XwgFfIYq3dxEYq?=
 =?us-ascii?Q?rZA3aGd17Q515FDuJgB01kzfo40oml+seYJoq1gvNrSNwdNiMCzPVodWDCLl?=
 =?us-ascii?Q?9+pgGY6sBfBP5bA2wSpFV5s6ER9SC0nbgEL8ESTlYn1UCLmu7/Qv3vs5Djst?=
 =?us-ascii?Q?TsHW/dADm4X3M0XdHI6oy9Qfn1K8FJeUhitgbENakPw3lKb1J5ieuf8ymqlZ?=
 =?us-ascii?Q?c/rqCxQi1e8G5MP+GHzuT6bycSA5ixThf7Cmq5tk+zYWjVljRGgGlXHjNiFS?=
 =?us-ascii?Q?Jy2ml9WJn+3o7tmHTa36RozZfsP5N5NHZoVnGdt69XfUtV3ZjvI49TZNN4vb?=
 =?us-ascii?Q?+0tCCnrp6Te/osR/OX1pfScwM9D+FGJxTq3a4QH8zlFnXHI4FgcThP+L6A7v?=
 =?us-ascii?Q?t9etwhmBv0fliQJAMmShmN0Zu6z6PS6I4xXmBkOcL25IhPkkiaf+fdaiHVWK?=
x-ms-exchange-antispam-messagedata-1: 9q5r5a4HFrkIEA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e78fcf5-9141-44e2-0a8a-08da390597e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 19:35:41.1917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TqwimpXkbiI5/2yumQGv4BpTtA/nqTaxOrxHiCClDO84cB9wAH6Zfod5+yAl82reZSA+wIrSk6yDk2St/NQxaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5883
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
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, May 18, 2022 14:25
> To: Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: stable@vger.kernel.org
> Subject: Re: MMIO support for I2C-PIIX4 and SP5100-TCO
>=20
> On Wed, May 18, 2022 at 06:49:59PM +0000, Limonciello, Mario wrote:
> > [Public]
> >
> > Hi,
> >
> > Some users have complained that i2c the controller doesn't work on newe=
r
> designs.  This is because the system can be configured by an OEM to not
> allow access to the I2C controller registers via legacy methods and inste=
ad
> requires MMIO.
> >
> > Some bug reports collecting this problem (which have had duplicates
> brought in)
> >
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> b.com%2FCalcProgrammer1%2FOpenRGB%2F-
> %2Fissues%2F1984&amp;data=3D05%7C01%7CMario.Limonciello%40amd.com
> %7C5c8827b7f53e479d364108da39042a91%7C3dd8961fe4884e608e11a82d994
> e183d%7C0%7C0%7C637884987298944924%7CUnknown%7CTWFpbGZsb3d8
> eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> D%7C3000%7C%7C%7C&amp;sdata=3DJQrvW5I0iSF14zm64ijMegqFSX6YTF1p6Y
> c8mub7DgI%3D&amp;reserved=3D0
> >
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbugs
> .launchpad.net%2Famd%2F%2Bbug%2F1950062&amp;data=3D05%7C01%7CMa
> rio.Limonciello%40amd.com%7C5c8827b7f53e479d364108da39042a91%7C3dd
> 8961fe4884e608e11a82d994e183d%7C0%7C0%7C637884987298944924%7CUn
> known%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6
> Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3Dz3Ba6AfJE41z
> cZfpTd1Fkp5jg1sKPEMHy%2BWDIgCv6tE%3D&amp;reserved=3D0
> >
> > These commits that have landed into 5.18 fix this issue both for i2c-pi=
ix4
> and for sp5100-tco (which suffers the same fate).
> >
> > Would you take them back to stable 5.15.y and 5.17.y?  The series comes
> back cleanly to both.
> >
> > 27c196c7b73c kernel/resource: Introduce request_mem_region_muxed()
> > 93102cb44978 i2c: piix4: Replace hardcoded memory map size with a
> #define
> > a3325d225b00 i2c: piix4: Move port I/O region request/release code into
> functions
> > 0a59a24e14e9 i2c: piix4: Move SMBus controller base address detect into
> function
> > fbafbd51bff5 i2c: piix4: Move SMBus port selection into function
> > 7c148722d074 i2c: piix4: Add EFCH MMIO support to region request and
> release
> > 46967bc1ee93 i2c: piix4: Add EFCH MMIO support to SMBus base address
> detect
> > 381a3083c674 i2c: piix4: Add EFCH MMIO support for SMBus port select
> > 6cf72f41808a i2c: piix4: Enable EFCH MMIO for Family 17h+
> > abd71a948f7a Watchdog: sp5100_tco: Move timer initialization into
> function
> > 1f182aca2300 Watchdog: sp5100_tco: Refactor MMIO base address
> initialization
> > 0578fff4aae5 Watchdog: sp5100_tco: Add initialization using EFCH MMIO
> > 826270373f17 Watchdog: sp5100_tco: Enable Family 17h+ CPUs
>=20
> What is the overall diffstat of all of these commits applied? =20

$ git diff --stat linux-5.15.y HEAD^
 drivers/i2c/busses/i2c-piix4.c | 213 +++++++++++++++++++++++++++++++++++++=
++++++++++++++++++++++++-----------------
 drivers/watchdog/sp5100_tco.c  | 318 +++++++++++++++++++++++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++---------------------------------=
-----
 drivers/watchdog/sp5100_tco.h  |   6 +++
 include/linux/ioport.h         |   2 +
 4 files changed, 390 insertions(+), 149 deletions(-)

> And why
> can't people with newer hardware just use 5.18 and newer releases like
> they do for other more complex hardware additions?
>=20

I think that argument is fine for not taking it to 5.17.y as 5.18 is right =
around the
corner.  I do think there is a strong case for 5.15.y though for a few reas=
ons:

1) The same problem happens on client (Ryzen) and server (EPYC).  Most peop=
le
will otherwise stick to the LTS kernel for the stability purposes.

2) The affected hardware here isn't new hardware, it's just a solution to a=
n old
problem.  For client chips I2C not working means common things like the I2C
trackpads won't work if they are on such a system.   Also rarer things like=
 RGB
lighting (which was the OpenRGB bug I linked) don't work.

Not having the watchdog timer hardware working is probably more important f=
or
the server chips though.
