Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D7852C2B8
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 20:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241623AbiERSuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 14:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241599AbiERSuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 14:50:03 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2063.outbound.protection.outlook.com [40.107.100.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B882CE13
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:50:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xou1y54r596QQLUiWbmsR3GjSEr10bYwltYfaO8wfNZ0JvAWLZ7GEG6ksebcQV6KH6pb+8azO9YYRQJpCfb/MaVoIbNZvE3mQKrCxLakqvoNQnGJZi1ZZGvLa1hxAxDgPVJybbe7x+o3W70mJsG7vHqNFnXtO4roHy2SkoD4o/nMoqZZ7bGJNfNr/+kUFPcd18BkNMv1P3IU2ur5VoQObtKebZcUZY+wDWc9owy6Bybft+LTiBDal9TLioOf3mTvprdhNtw7jjsBlPk5CoDTsGywtzz5ZiShdnCUpmQBDulVogRCP6t4bCiatoqu1emIctAdhJZb+nlkFIfA6pSa2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xw/J3TGV3TLTzPROJWPFms7RHdAY+WhMrtcgKhJEUfU=;
 b=f2wf5U6r+/VdoAoCqGhgvvtgvok1ZK852IlgmFuFA0pFCRcAQtmhFgFWZw1nohm+xOHo433nOz3JBy2ExUqEwILfp87mgNhyTIX/G7UUnNEdKjoPYnnAq0MBXf7awy/dVSs1N5dpiW4OdUlQrJny7ETJQZl/PxCG5va0VbnkGxlwci/dFC/xyHvuKh+sKC9X/FPcYte+sh9B1SD0ho7zWwzCdMVdY1Q6NXPnXvGnUAUR52Q7slSpbnrSzI/sY2wRb4djhLRgpYMGSoWdQ4dDdt0grgktF94+RPw8N4/2oCe6ldL+iLipLLPvEyEsMCeX/N2S8ML/3SNacWKbBkPNuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xw/J3TGV3TLTzPROJWPFms7RHdAY+WhMrtcgKhJEUfU=;
 b=uTDwnda8pJLrNiaAvfEZWnX9NVzoDHzLHKFyi2mvu7KhBPq54InP+QfqEE7wqPAXP+HmYYqw3FrmTLL8Qrr6EN7AGq6LNUCInDFO6nO3pQwcb88Ay5dZ5eXdTWOc7xhQ0mQykg33PpG1q58SNCK3PqxbDBOZZtot0WiwjZnnt6A=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CH2PR12MB3701.namprd12.prod.outlook.com (2603:10b6:610:23::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 18:49:59 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db%6]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 18:49:59 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: MMIO support for I2C-PIIX4 and SP5100-TCO
Thread-Topic: MMIO support for I2C-PIIX4 and SP5100-TCO
Thread-Index: Adhq4reH43WetIzZR5SToc8Xvr1SIw==
Date:   Wed, 18 May 2022 18:49:59 +0000
Message-ID: <MN0PR12MB610150AC5F1E15D6A67AC352E2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-05-18T18:15:51Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=88492cdf-dd84-409a-9ae2-79abc770ef15;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-05-18T18:49:58Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 31c4448f-5d14-4a4b-8e4f-4341dff39688
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81577ccf-e91d-412a-2cc2-08da38ff35ed
x-ms-traffictypediagnostic: CH2PR12MB3701:EE_
x-microsoft-antispam-prvs: <CH2PR12MB37013B289EBFD678FA227CB6E2D19@CH2PR12MB3701.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vEIiTfVPR1gR1PvKm8LbiTLmvFdi1isube0QOxlyNa/eOdipGEEgLOfeHi2Rn37mtBsVhdvXf0RVdNVRnIL7MsqYQHL6lkl/UWjO1aSxm2zr1b5pkQadyakDMMWT/f1eLg9ZoyETMMz7ZFpuGglY+uV/CYbms728rrOvgQGn25NfZr1GWpiE/NmSM3Yfg3us4c8jrx4IxNnclc2bKuZVrxPKojzyGg+nvA1NHmN3f23nrTXk3REhyb2wfUkkWamtVsGm1hmkoCi5tlxUF1fiiyDnHbBsxbMOQV7K7/ptF0Vuq4sZycLnwLJUZUnfG2uBmT3X1NdLGMVmofPmqIqFbrOBMAfurEIQiZJgw2zzQJem8PJIEqAgba0UGZDO+NQCfXJzym1wmoWx15srwxsRD1UzyV5Cdh0zpec4TFPa5khn25QDm4ZRq6BQE0mkds5eSffWeHCBmuJgY0FusLbJ/85JZXSHpi5XTdrnHwIzeTCAfuY99sdV/pv0j1/rcwp0jat0DQtSy8WCrlQi7+WhGB3HdLNkOxEA2CSj2EEU/cwkxDToAMMJiURS2tM1aa0rYc9IkEhDVtVb5SdzUnvN0Btq4GXrL8/xZjMWMW9rPNYxAy5+IaZ4/dN2elDdrfhIh8O4bCHviIuZlWR6VQuOTLhSjYOueKPG1/NOo4brfXmTKImVvoW4BTUDMGPV6Ag8KImJymZMhWaVboZfIBILUk0E0rxTJ7d4vwKzmANrODGEu4WmDsd36F9Fzk2ViM3LnEQCY2almo/FVA1AiNzKjxUCk8JdrTVbYCKd9lxWlxI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(52536014)(122000001)(55016003)(71200400001)(86362001)(316002)(9686003)(7696005)(966005)(38070700005)(33656002)(5660300002)(508600001)(38100700002)(66556008)(66446008)(6506007)(66946007)(66476007)(64756008)(8676002)(76116006)(6916009)(2906002)(83380400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pyjVVG0oIzS5K+C3BuDjrFNeGCd22f7mIxb4E/4KReaqXHOtNElC2IZ0Q3WI?=
 =?us-ascii?Q?GsqeDvNQvbHYo5Ybj262dA5onMzecLwAf1FXK5JVa2GpesrcvzuslD3y1vVj?=
 =?us-ascii?Q?hMny35mOMirbYArcaQPRAMAQncKdZOOSuwXoNqerNj+c05KuzV3OwkHgQkGE?=
 =?us-ascii?Q?uyfoF62Kw4JMPLmm35p7jUTL2BAot3TXa9eq5NrFvhonRMKp+6W5MbCGUIXc?=
 =?us-ascii?Q?WL4as8LeNiO7sA1mQppZYHz5c+WsknaP8pgkZoOflQ9hueXCprhJA0PLSA/S?=
 =?us-ascii?Q?qj7GugqcWdhsUai3d8M0fh/D1aadn2zLE7LXrxAvzhMyjPWwlqR9HpMeDLsI?=
 =?us-ascii?Q?2vlxDe7m4SDQWPRR42TZKCViL199PbRLA+9j0cR8VfmxZqG6LvNuP6foGotJ?=
 =?us-ascii?Q?qQ6cvcwcYk0RDzfv3PMasL1yG1VQ7ujchcA9iH8QyIbq1gxtQeMO/nQsFgX3?=
 =?us-ascii?Q?zct3iKOy3fEpRGPBjRIKN7XYcY6OgB5k6uui06MJRhhXJ11bw00yMaeuaarC?=
 =?us-ascii?Q?IAL6p47IMbCM5B3kUB+nuwZpvpW2huIg6lVA27wnadMNfxhk4xs3xK9gW/r9?=
 =?us-ascii?Q?bXpdE6vTwGkeHp0l/zreKP/78ps8987zIc8fdqDJchftp+7zboJYzd5V7R+P?=
 =?us-ascii?Q?Awm4v9y6ybaIyPSQIXrNwZyTEd13VAcwx4z1XXtRrHmlUPo5XjtedSqcm2rB?=
 =?us-ascii?Q?4VnCqxF8C724OluICeVE5187RwJO299j7n0Tk36PWWlQsi5Jp4H4dGnEDxfq?=
 =?us-ascii?Q?q6yrRKYcpbaDHEiAF7vRcszoVXiFXDl3Hv+qMTjWMgGE3pVebyapq5+BdNAZ?=
 =?us-ascii?Q?1xIlk02ujFSI+OBTQSAg+Z4+TZXmpwY62yDVdLYqK4nPWp2GUlF9/3qSJh2l?=
 =?us-ascii?Q?gtnbcb7iA2VYOHmlOQAUDRn7j1xlMTe3JpRxafUwf896FjwmUXlWwYK1BdqZ?=
 =?us-ascii?Q?QexjE+rb5tqTGuSzR20DH2O1o5g5Vx6wjFjLugoQZTL9oECWyKVMHjlFURfU?=
 =?us-ascii?Q?mAR9HIbqGwW492c1cCMQKBzVMNSHbQ40Io1GK8Lvt92fMs0BoH1jiqlpYTRN?=
 =?us-ascii?Q?9NyEf+2mkro+Hf4EJ4C2gvDY2rXP5Rwyq7iJ7h9M9Qz5NdOby3zdbiRhsMxA?=
 =?us-ascii?Q?p8D9LDzuFUKWyXwQcUYXhfrfT2ANLCiv7kZf0iGOEspykOceH/6lZz5RrXu1?=
 =?us-ascii?Q?2G+M8kUEDRiNRzIerJ4elnT1Xo32VJoYyvUT1TSqDXcj2jil/+M240nbEKoz?=
 =?us-ascii?Q?6k1zF0F+c5y8eMKjEvs+kIweilgSGcTb7zThH5Efm3TV05zg88FrlcVYBLAj?=
 =?us-ascii?Q?WMoW3ZeNthGaPJHj4q5ZK7AG48+tNuzqwwDzcXaBvlNHVuUrgtU2/jGWg5Dq?=
 =?us-ascii?Q?pUsEOqnrIEmd8mN9QcaiIKFUAwSyk5M9xbPqYptlfx6vBnjTgCfYrApnSXr9?=
 =?us-ascii?Q?TJrhJjHqnVMStovKJJcBwWJJEoaBTM7oSitD53kZEeZb+6THEFv+mn/d1OkD?=
 =?us-ascii?Q?kGMbpgI1OHc35OCRlhAYhEHctgh2axsmXIcK3vUElduTscQcsLD8+7Pp8TOH?=
 =?us-ascii?Q?TH5xkD6VXhcMjcndiwiMOqxWxGx14MxgNPCBF7sKfQgi3ecDSoqyyLxpkVbL?=
 =?us-ascii?Q?nJg2IbEwGTCzXFyKTOMIwR5by9Hn4kfXP6xvLy5CVrhg8bkRQBLo3fVCdDxT?=
 =?us-ascii?Q?YZkrDJ2u9QDo/OYChKv3xGbeYrZIaLIEGrnbHH+V+VurLks8hDPM/oVGa3Bo?=
 =?us-ascii?Q?R+dhLXQePGzR48xtMnutNiCNdKiNH7HV1VcLxbrB663JxGVrSZM3eJlI0tlh?=
x-ms-exchange-antispam-messagedata-1: 4ROY3JPcpyZXvA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81577ccf-e91d-412a-2cc2-08da38ff35ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 18:49:59.8531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v7YbTAy470RSbj21NU4ikj/szrNF80RM3wvtbQ+DGdSKK57z3qY8X8909hZbgwqa2qpTOQwNgNvcWP5BJ8Zxkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3701
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

Hi,

Some users have complained that i2c the controller doesn't work on newer de=
signs.  This is because the system can be configured by an OEM to not allow=
 access to the I2C controller registers via legacy methods and instead requ=
ires MMIO.

Some bug reports collecting this problem (which have had duplicates brought=
 in)
https://gitlab.com/CalcProgrammer1/OpenRGB/-/issues/1984
https://bugs.launchpad.net/amd/+bug/1950062

These commits that have landed into 5.18 fix this issue both for i2c-piix4 =
and for sp5100-tco (which suffers the same fate).

Would you take them back to stable 5.15.y and 5.17.y?  The series comes bac=
k cleanly to both.

27c196c7b73c kernel/resource: Introduce request_mem_region_muxed()
93102cb44978 i2c: piix4: Replace hardcoded memory map size with a #define
a3325d225b00 i2c: piix4: Move port I/O region request/release code into fun=
ctions
0a59a24e14e9 i2c: piix4: Move SMBus controller base address detect into fun=
ction
fbafbd51bff5 i2c: piix4: Move SMBus port selection into function
7c148722d074 i2c: piix4: Add EFCH MMIO support to region request and releas=
e
46967bc1ee93 i2c: piix4: Add EFCH MMIO support to SMBus base address detect
381a3083c674 i2c: piix4: Add EFCH MMIO support for SMBus port select
6cf72f41808a i2c: piix4: Enable EFCH MMIO for Family 17h+
abd71a948f7a Watchdog: sp5100_tco: Move timer initialization into function
1f182aca2300 Watchdog: sp5100_tco: Refactor MMIO base address initializatio=
n
0578fff4aae5 Watchdog: sp5100_tco: Add initialization using EFCH MMIO
826270373f17 Watchdog: sp5100_tco: Enable Family 17h+ CPUs

Thanks,=
