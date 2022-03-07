Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EB44D07CC
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 20:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbiCGThD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 14:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiCGThC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 14:37:02 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A209888ED;
        Mon,  7 Mar 2022 11:36:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtJJfjWzz3LoxNrPfri25A4yDIv3KAwEtL3ZAsSHQwlQkeoZx5PHCqCx+9p3Do7XeXVQhJo8hlcYa9E68Zl6xBDfzeHGPB7cW8ohwhThdr8mwDVv5oqnqNtOBj8GOuruUBbtrv8B9Pr7eu0dDMduXJtKf/8BnwAt5DogD2EEvjRSC23Zf0meef7BPxTBgF7ARDMmHFTBFDtrtjAVM9wH0mL5Y2O84pCYWIn3Ur7yEeeUgcTuVbHUYTBC1Hq5GP6rVM0EWJs08DSgp469nLCLtxZYVyz6qcJapBNEEUwoyqIY/xKjjPxyJZwBSDk0iiUdUhezmhirp9t7MwXH8kopDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICtm1KQRGYQV0/g30745fg/1fFVvU4fjSUIMPswmH2g=;
 b=blqDpr7Zxem4usaXAW6YFjEDVCtPKOrNruU5ldUMym6BlR6k+CCnm+z0+2+GV925llDRc/gdYpFrV6kzjA2HKbUU2tLy2Suj/VjAx1/lYZQ+FqsnkrHNumGnATdeAxMHvEIVke6ZU8CEUZh1OM6P/wbozUrpOeAtKPY9kUgvPAHkb1t0xrIZhgyZbqN0M/TG/3Kl/kYSsQZoOwCEMFdCf3qeVrtraxTGZj/CWN/jsb7RQA9/QAuDOnktekNWh/x2t/55oRaJUQ49fu/gPT8pq+EZUerjm0d/SX1BkO+2q5zoKAecSJRoXEZVYp41kzXzpNhuP2m2xVBne03k5fW83A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICtm1KQRGYQV0/g30745fg/1fFVvU4fjSUIMPswmH2g=;
 b=ndv8xSGWB/BYqX4BJJNDgCxXIaNBIb2EqKDAAupV+IX1WrBmw+3oIuks98UIDzaKjTB/Pu85/d2mUwdbv0bRowllQv21OVrIhb3JLSZM6EhqbN/jl2lLgXlFW02N/S5cp5K5S/P8Bzi+oiN1HDTjlVMMh+XuXfV4b5OcPjFbwE4=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by SJ0PR12MB5488.namprd12.prod.outlook.com (2603:10b6:a03:3ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Mon, 7 Mar
 2022 19:35:58 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::2877:73e4:31e7:cecf]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::2877:73e4:31e7:cecf%7]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 19:35:58 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Wu, Hersen" <hersenxs.wu@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Gutierrez, Agustin" <Agustin.Gutierrez@amd.com>,
        "Wheeler, Daniel" <Daniel.Wheeler@amd.com>,
        "Zhuo, Qingqing (Lillian)" <Qingqing.Zhuo@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.15 100/262] drm/amd/display: move FPU associated DSC
 code to DML folder
Thread-Topic: [PATCH 5.15 100/262] drm/amd/display: move FPU associated DSC
 code to DML folder
Thread-Index: AQHYMgdOSuVNXIR9nku4dCgcxKRASqy0KkvQgAABjICAACTPQA==
Date:   Mon, 7 Mar 2022 19:35:58 +0000
Message-ID: <BL1PR12MB51448DB8070078EF3E4F4708F7089@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20220307091702.378509770@linuxfoundation.org>
 <20220307091705.301226097@linuxfoundation.org>
 <BL1PR12MB5144BBA7ACECD892E9DE088AF7089@BL1PR12MB5144.namprd12.prod.outlook.com>
 <YiY/YaU7YdGZQ4B0@kroah.com>
In-Reply-To: <YiY/YaU7YdGZQ4B0@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-03-07T19:35:27Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=3d150e31-ed8a-4dc0-abf5-61caf1ae6715;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-03-07T19:35:54Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 1b616442-f824-4b29-a60d-efa317173e98
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ba49633-d67a-4a3d-ea56-08da0071b464
x-ms-traffictypediagnostic: SJ0PR12MB5488:EE_
x-microsoft-antispam-prvs: <SJ0PR12MB548880CB5226C42B88CA3F21F7089@SJ0PR12MB5488.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aL0y4ZO0u6IpfjNBNf4uK1TrY5Ufy8SflJIgJrceNm7GjIi+ZcGzPXIwjF16HXLhDBnOpXHwavhtrHem6RjOtS00da0wchPLUHozJ/dgqjwnaCxAuz8RB0EMRno3Owru4iAd4YAZEHEVirmINnDgUGvIOS4v3BN2FgW2z4ZezIVdiGawvRy4BFrcev8bId+Hgjzw7R8ybTg6vQsJ+g1HdjlOgLjS4uI0HNmDtPsSp9/qmpTUAmTiC/xu6ob749+/pOOhwV8kGZ7AQRjJEC2PeB4rwWxDF9NbT0Aj7YcgD+RFexwy7Y0w17Sv6uTDGiiUlh+szBRMbrV907uRmsPbEYssSHgwmMbinV9freUehGNZCv4x3zNH2alM9PbuuUePCWYwEJ9RaeLCkzSjlLMWJIWaqDsFra/K1V9l8Ueq2SYBTTZw0iT648gRANI4+Naqzxm0dcN4VDuiEy/m8K3wE69HI2sgSRGoEWQv50C05L/+mYoNOmICrhHJ/Nq1HFwydBA2W+VzTD3h0KvuXlr2L4UDAUAZ2lmrRId2WNC/Vm+7R+7oFyv7qADFh5ttiM2osT0vG7aUXveTXtph30y0M8ZGrNYTnvkaxHNBe2kyrjhZGUm96i8ORKEhy4BKVRXHzT4ZAK0fH31+YD5iCll+CSO+yAZpXP8Cftxd6YH+yyTfp7IpdlVfcMCTrQfrHkNxFPtA5cCFqF0TdzfXcHWuKEpLSxVIhP8d7qU/5Cyr65oSFVZhdyEqUNcK6zCJBC3qp+T2DsRN+GZst73NiZkP1fPmtKu7ZkTRKfyoFefgmjs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66446008)(66476007)(64756008)(66556008)(66946007)(4326008)(8676002)(186003)(26005)(83380400001)(86362001)(122000001)(2906002)(38100700002)(5660300002)(38070700005)(55016003)(52536014)(8936002)(966005)(6506007)(6916009)(7696005)(54906003)(45080400002)(508600001)(71200400001)(76116006)(9686003)(33656002)(316002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?v45jKhIM26/9M3EaDsGcuQlYYtpklbi2GhXyB+H1HiK9PnsSliKdZXL4IFis?=
 =?us-ascii?Q?Z8otuFdVTHV/NWujeYnnFw6VdOqlD/ZK8+p75v59XDn0tKTtrgGlB85c7peK?=
 =?us-ascii?Q?vDKd7/J160NsC8kU0njHoalsnUfCOGrlbF7yROShaIzF3igEEtnB7BLYtSHV?=
 =?us-ascii?Q?yCoHYjwE527MFYt71du/sKYCmyPBjkzNFipw9CHec+LLjO5ouZahvWnoAmTK?=
 =?us-ascii?Q?FEVfV+9ByDAa9OtKxD81WORoMn1ptSkfVoigoiw1jRPLdvQ4sLFjOau22zLm?=
 =?us-ascii?Q?xj5ywdpFk1E9mgTGFbw9MbcrWdn6v9bVqa4yJrs/1jSY7e4vOCwwQZIcWPm0?=
 =?us-ascii?Q?ZfbUwMsH+MWmYGPVm6WVh1WUv7L/lgQJujuLv3gmCPuvJBjuj76WPDYnOO0T?=
 =?us-ascii?Q?hr3psMt4kraS1+CITWPLnm5ZJ/6r9jO0jIcdSAu0xgAH7Xu6YbMR6clR79A3?=
 =?us-ascii?Q?Lgdk1ehT+SIVeEjA3m6eoZ9tl4ZxXkDPFClPhvFTiw3pCNYR2jcZrcSHbQw4?=
 =?us-ascii?Q?7HUnm4QA02MHl2o9pNyVRWQ0ZOlXpZ3YwXtc25YyBtc43pJlwpi9ZZiKIj+X?=
 =?us-ascii?Q?p/P9TbkH0NaP/+hAjw7cHt/1H5LGMSJGOjYBjjoJE8OfqcmOM5g8Q13bw1rp?=
 =?us-ascii?Q?MfcTdR1vRE54uC4eQ64CxoLTfwMQbsG6kY3r2Xipzxt/IVgiXJFhz17hZHXX?=
 =?us-ascii?Q?Ms2Sn5CXyV7Mpp5acOZjbdUolNl8dKNLQVlJdl6TXX3mOwNGVHpwRfCYkZAA?=
 =?us-ascii?Q?qpknkhefxeJ9vcsZ9KLalT80fvCRtas5Xz0EA5HTDsgFk86UL6QPQHcZ86+4?=
 =?us-ascii?Q?dG7CQqxqFF1nQr4usyVFrhsYzlOOrWrP3MxEKM42ufiHEnq4stZ5kNTUi99X?=
 =?us-ascii?Q?iUqBEtiKlB5nT9zPaGp3q6M4r+Zfc3PenM6CRb9iSNZTTxdHqCvk3gxTyaRp?=
 =?us-ascii?Q?8Mj8xZ9FUMY6M6qLVlv9lwc+MYchbCGkE0yapEE1DGEMxm8cRQVXF1QmgGon?=
 =?us-ascii?Q?+Uxo8AfGENoVhAIk1x3Dp2BYE5FAde/wsGBWfIrIaADk2TpsS51MD2MGf2KR?=
 =?us-ascii?Q?WjnUPQchKjoU4S/MBhcTKoR/0wRdhkgI7ksGniyzTy4ypWmufX+hZpynHYVJ?=
 =?us-ascii?Q?8bpqbf6YHuDrA/maaWjQUzLd6mXfp2tNt5lnXpwBB7EYVXS8+7ZuWjQENvzA?=
 =?us-ascii?Q?LnIVzAzFb3zSwJFfDLzjgkw3C1WFYsW2789egCMDdw3jltmZqZjndloJTa3Y?=
 =?us-ascii?Q?ZTnsubcuDAaxsanYcqfWCH639ii68t+yzUH+p72O26mCHUVzDn1e0EBa3Jgl?=
 =?us-ascii?Q?PKtNEYWzIhljdO/uCpIaZBCO1OAfy5ZwQiTQWWKfE3eejPAI4VUJtNc+0YhW?=
 =?us-ascii?Q?oTskh6kuaEFdB/qr5HV/KvFJje5EjRRmDVCDD9nNhCbn8Cm4/RfFYdlQHDWf?=
 =?us-ascii?Q?SasjSyqL1CXCVxprxJ5YKx0PczYZOWgx+h+xtlb4sp/yDIK52pDndQrI92Uk?=
 =?us-ascii?Q?zQ2idCtcWsSgs/UKyhznOfzxf8axxAr4AQYgIML+nzRTVOnJyoFHW+ff09/y?=
 =?us-ascii?Q?QZj8u5YsPJoGmAulkJJ8U9Sfcr5TYHB8FsdIHT684k5fRdicV+wzWgfgFKhE?=
 =?us-ascii?Q?Xq1f6svVr7eo6MB9mFEH2FY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba49633-d67a-4a3d-ea56-08da0071b464
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 19:35:58.1351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gjjs5jhBbckGuGSxD8ehS1qJQukVipX3BXbzI+KmpyBPYFwXChkuE5DbNkQywlMig5sHkRQBenTRmHA8GoTi7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5488
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
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, March 7, 2022 12:23 PM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Koenig, Christi=
an
> <Christian.Koenig@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>;
> Anson Jacob <Anson.Jacob@amd.com>; Wentland, Harry
> <Harry.Wentland@amd.com>; Siqueira, Rodrigo
> <Rodrigo.Siqueira@amd.com>; Gutierrez, Agustin
> <Agustin.Gutierrez@amd.com>; Wheeler, Daniel
> <Daniel.Wheeler@amd.com>; Zhuo, Qingqing (Lillian)
> <Qingqing.Zhuo@amd.com>; Sasha Levin <sashal@kernel.org>
> Subject: Re: [PATCH 5.15 100/262] drm/amd/display: move FPU associated
> DSC code to DML folder
>=20
> On Mon, Mar 07, 2022 at 05:19:20PM +0000, Deucher, Alexander wrote:
> > [Public]
> >
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: Monday, March 7, 2022 4:17 AM
> > > To: linux-kernel@vger.kernel.org
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > > stable@vger.kernel.org; Koenig, Christian
> > > <Christian.Koenig@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>;
> Anson
> > > Jacob <Anson.Jacob@amd.com>; Wentland, Harry
> > > <Harry.Wentland@amd.com>; Siqueira, Rodrigo
> > > <Rodrigo.Siqueira@amd.com>; Gutierrez, Agustin
> > > <Agustin.Gutierrez@amd.com>; Wheeler, Daniel
> > > <Daniel.Wheeler@amd.com>; Zhuo, Qingqing (Lillian)
> > > <Qingqing.Zhuo@amd.com>; Deucher, Alexander
> > > <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> > > Subject: [PATCH 5.15 100/262] drm/amd/display: move FPU associated
> > > DSC code to DML folder
> > >
> > > From: Qingqing Zhuo <qingqing.zhuo@amd.com>
> > >
> > > [ Upstream commit d738db6883df3e3c513f9e777c842262693f951b ]
> > >
> > > [Why & How]
> > > As part of the FPU isolation work documented in
> > >
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpa
> > > tc
> hwork.freedesktop.org%2Fseries%2F93042%2F&amp;data=3D04%7C01%7Calex
> > >
> ander.deucher%40amd.com%7Cf4f4d5bfb9f74edfb8b108da001e6d8f%7C3dd
> > >
> 8961fe4884e608e11a82d994e183d%7C0%7C0%7C637822427968538535%7CUn
> > >
> known%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6
> > >
> Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=3D2Mm24%2FPkRkih%2BToJ
> > > oBGx2wpeth0Z0Rv3dG77D06fHbw%3D&amp;reserved=3D0, isolate code
> that
> > > uses FPU in DSC to DML, where all FPU code should locate.
> > >
> > > This change does not refactor any functions but move code around.
> > >
> >
> > This is not a really bug fix, just general reworking of the FP code.  I=
 don't
> know that this is stable material.
>=20
> I think it's needed for a follow-on patch in this series, right?

I'm not sure.  This series comes from Sasha.  I'm not sure what his depende=
ncy chain looks like.

Alex
