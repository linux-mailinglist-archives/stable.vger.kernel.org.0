Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5BF6D8A6A
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 00:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjDEWN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 18:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDEWN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 18:13:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61975269
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 15:13:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0NuxWCdG9NTGq/RqU0IaU/WszOA7rPXt8novdFP5t2wFW7NcCQFywMzZWOYbROck2fT/LSR6REK+XKQeMw48GJH4GgOaZocT317naKqaN5bP8NfWAhJWzXMBxVM0xBw+YYRNemJKxUovcAyQaZ83YESdVb71LF0uyLrpSEXtKTA4YvWYf1lkj1leQ3iZCJBe/ZKG39Cyv9Vcm/QBAZJa7ynH9rjhhSZfB9N3yj2dPYcFpnRkiThKgktCQXs2vou0jUvXwJe1gQRCvpGQAExibNp1mVnFVJQit0HL8ObajSRvndcrd4hegH64mVxmZmwQuVgGcHwth8fr92+nnYhdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4lyGJJ9ron/dM4Q66CI+CnvjV3onKbFtph8IwdHCC0=;
 b=kf24y+30geaf7Qgvwa/9GrR8qy9ANtMUViLgBC2VLYgxFMM6m+m5M/I+Qvkd8L9/OrCQlHpv4qjTo3mRA6PvYfLqN048WO7/i5CGa2O+KCkQI1A6yK9swlkUjTH6p1aqbM4+lCYS23sv1nXd7lif0zN+uIkrmdLXRwK5DsjBdL9+N1OLmPdMouOT9OO/m2dJJTmDbe5/VcEeES+G2Cdmp3VJYYlVIv8JTmJjwizOlLxqGYtHfCkLy4ZtFKTO1sGZNKxKTqF6grhTCwpizvqCb1hluriIg9N9Mttt/zUd1YJljJc6GeBhqxiTgg3CfZxNUCASxosrPnC2kCq4QqPJpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4lyGJJ9ron/dM4Q66CI+CnvjV3onKbFtph8IwdHCC0=;
 b=XvyMDwAEnAhv+gl8e3Ws0wYtyXRb5MYWCNiQXqMJ4k9Ty4+CHvfrfX5wdNpOHtCeTxLmEvWY+B6pB3A93RMS+j8yP1y/EYh8CEDYmpsEiESFRHulpm/TGDEGmnsFfVq6CutYy1iFAJ1SyWtPYvg5cCoWo4i0BsSOoCgXoBhVkPY=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB7720.namprd12.prod.outlook.com (2603:10b6:8:100::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 22:13:54 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6254.028; Wed, 5 Apr 2023
 22:13:54 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: MST Unplugged during suspend
Thread-Topic: MST Unplugged during suspend
Thread-Index: AdloC5Wq6KZZr5CKTk2V4Vd11yOgxQ==
Date:   Wed, 5 Apr 2023 22:13:54 +0000
Message-ID: <MN0PR12MB6101092DDDD6B1BEF8AF271DE2909@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-05T22:13:52Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=531b5547-0e0c-4fac-8c88-6683619ae3f8;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-04-05T22:13:52Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 0dc19a59-b35a-428b-bb4d-a1a4aab3dc59
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|DM4PR12MB7720:EE_
x-ms-office365-filtering-correlation-id: d02130a8-2019-40a5-ae17-08db36230b3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7U/GelqZb7Zls2U/DcAFSKgt7QyJmuZqcukTiL7zVwMSLIs0GZHRvefrvFHLUiPajtaaXnCJG3R4TL5NF/E8fekplyn0xV02zb6LcN54O8HqPbgV6KCvfaoq753cOSP9l61uHYbWVOn6Ylh7Rp6TumYjo1BZQ9u6TUsI1/hqZX4Vny+BQ1+rPq/c7NVlPGsagih01mOpzjkP6ID443xMUBl5nhlkuWUoJp0Bo1IKVREbJvUaS0surSu+6Db2EeyH1Hi0CM5ID6AfYYjB1xBnkr/p9zNIKttiFfo7xdFaL4tRMx8OHIjH2GzeSwB61jXp/gMPiY14e0rhbJov3r7eawaOcvsKme78xCCdGD/M+Z4yw7g8bD59jXWds+MHOuzMuKGeRrf4SmtXBbIk+bG5EZbhZLWm0zYH9DTSuA2PFwLjoEUXek2DIuRnPrNj+rNiIKgqoMZLfAdPyaD1sTcHD2RR2fsHLoornDx74bj6v/LuDravEzwNY44nM+c6Km7mG0A02MTo3A6wh3uHtdr6f/Z+X0n66GS8CFY6svqe4zeAQQ9YYiCVO1iHiylGzeNA9uyPbIAgFvAniOdDoPcLaPFhV6EK2mkfge1dMGBBuG3uyM/1+AYyR+H05+AmplEn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199021)(8676002)(64756008)(478600001)(83380400001)(316002)(8936002)(33656002)(66946007)(55016003)(86362001)(6506007)(66556008)(26005)(9686003)(76116006)(71200400001)(7696005)(66446008)(52536014)(66476007)(5660300002)(3480700007)(186003)(41300700001)(6916009)(38070700005)(2906002)(4744005)(38100700002)(15650500001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lHbVz95U2mMwDaYrAgO4D5dtzmhAHx11wXCAX5f6U7T1rCqnKT38xH86XViR?=
 =?us-ascii?Q?zoA8j6g+V1dX0H5g3JElax0TyycjNkxG/p0UF1PrKI/tlRWmR4WJyoFdE4Z+?=
 =?us-ascii?Q?OToQjR8o9uN/EPRo5iAgrB1FUGWKB8Qon0dlov0Senmd5Wl0iGovEkwg0Dnt?=
 =?us-ascii?Q?M5R3DlD4h8+vtbUsQBgI2wH8hmuFLsXwrdAGnZKi+ZaKI4kM7aY6Km/Bv5yX?=
 =?us-ascii?Q?z5VbeWq/iW15xZNdEre66TLiiDnFtGr+f1koSQf03BDODc7tvSurXucQyWz7?=
 =?us-ascii?Q?dRImT25i5aFcq5BgFKiH9DyccslYdyhITzepbsOOWFrMiPtI+q2UdN7ZHzlv?=
 =?us-ascii?Q?+uQSVPDUiSf0vDzW1xm45b3tXqR841oVZCzlChpO12UT3ymiBGZwXL/eqKyQ?=
 =?us-ascii?Q?SoiVMaObA/9o9akv01F0pI18UooQ/qlO79TC3McYVMj90KLrYagEDuhNG38W?=
 =?us-ascii?Q?a+n29fndcCw8+hGjOphLy9KlnOLqW6s9zRni4Pd9eBtx6Y+lu04q2gHC/vZi?=
 =?us-ascii?Q?DqoIqXqPJpPL6nAyNI/4FxOrWdSu16/UXHlb89GW2YtUnb+1UpH9yK/uwn1k?=
 =?us-ascii?Q?wCbXfJbivEdb4pReD58rBqbD1kMN0Pr1xE8LnD6LMcAVFV/4TO8DaEaBOBMH?=
 =?us-ascii?Q?RSQU1Thgt4SPA3CBQXHYRy1lAma+rCYPtBHijRtxba4ivMhuMm2vf+mIu0t/?=
 =?us-ascii?Q?4L4hIx+hbUPIJAnGWfriuRo6GW53wFshy2bhXg+aMx9QFO7FLYr3I/4I+hpQ?=
 =?us-ascii?Q?ni5Vbl7RCSqOw6UXysvONQd4sYTYN2tLa+B/GXJc6kOO1YTt12fC+S0RoK1v?=
 =?us-ascii?Q?IuSlkC5ZfyVKP2FNjfgaETJhsF+sowB2sXGpAAja7p/eaUu8EBocRCVZqXxi?=
 =?us-ascii?Q?IQUv8OEfU6TXJN6oBxgkpPtGFa4bTCeJhWSZS4Z8+/rGrX6NwnKdzt+YdYEv?=
 =?us-ascii?Q?1W+QQbFllLPtz0EgvOBdfYS4IMQHStjMIUen5yViEiHFSGdrDQvw2o/HD2Uo?=
 =?us-ascii?Q?BlX+E6WI5+SPeNZEIHvcyPFjZxcEDsSSl4PWNsam6gSyd/Do9baINuWb5pM5?=
 =?us-ascii?Q?ZZLV+/npv5rzVm4+1aR2mbrNjKOg2rne3ipV5aUWy9J10+HO7oHGpisrxkP6?=
 =?us-ascii?Q?tyx4tiaDMdbLpRtK926nPZskPVsv5oeT/opSV2peIfRJawma128ZsRMquqNc?=
 =?us-ascii?Q?8VbLW/J+MTp4anVWukuKbJZsJupysUWfORkapcTHoXR2qe5SqtR6tdLFRa0M?=
 =?us-ascii?Q?cqQy0TOF1pNTD59UKzrGmbfqcpVwIXdF2twWTKKonqP94d9DlJNscNy3WoED?=
 =?us-ascii?Q?eKB+ar+mruOOUdyUS/uaVP9Asng9fEmXpSiqvkbEZ7l9X8ovJ9C37Bos7i1j?=
 =?us-ascii?Q?hrAhpvUnQlFpfjJYTYEdxdYeCC4PTIqmaZmq1cjSupfhJ2kSpEJ9PO6W9flz?=
 =?us-ascii?Q?rPwoQr/35GgiSZAbda81opDWCB5I21zPDX3UFy2k0j1oBSBq5GkRNnuy0UMH?=
 =?us-ascii?Q?sNv9cjLFO0jt53hXkp6EYbD6l49nYWA93BmwGI+i17Mq51oTuvQwR20jM6/3?=
 =?us-ascii?Q?U4obAkch+qBt4BKqYw8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d02130a8-2019-40a5-ae17-08db36230b3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 22:13:54.3088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2+b+wKUiKk/ibu94idKpCZm53hCF7DmznDCd2kfz4eoqweOilDndxKc/MyG03xcNNuATkcoW+NKsKPE71PcWQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7720
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

There is a bug present in 6.2.y and 6.1.y where if a dock that supports MST=
 is unplugged during suspend it's not possible to get MST working after res=
ume.  This is because the cleanup/error path doesn't actually clear the MST=
 tree.

It's fixed in 6.3 with:

3f6752b4de41 ("drm/amd/display: Clear MST topology if it fails to resume")

Can this please be backported to 6.2.y and 6.1.y?

Thanks,=
