Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D594B3239DB
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 10:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbhBXJtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 04:49:40 -0500
Received: from mail-eopbgr760084.outbound.protection.outlook.com ([40.107.76.84]:12934
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234681AbhBXJsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 04:48:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHacCrTXwh6jXlgSCs3n5npm8khxci65NqIyngHAG9whsnL4jspntUpnPbu205eSMMcid305RrzlQzsXRbtg54kvjW2Q/Bjf1QEeVDZ4PC4UKwxpvXL2IMLD8He8SX5i4oQAq/MHjPdvHRNUCTuRh2V4rUrKp1qqbKM1TXqSbC+Kg+FTeFU3ZduFu5kT8SwsBDbc3JvKquJ2Ht3czACl5TR/sVgYcjW49VrTEDA5XVF1jb2kMg6x0WXoBC4a0oGPezUiV4vspZmYfbUKmm0nTn/MwR423WszlhbtgYVXf71oekFfmvOkQoaxsb8EFq/7ZTpWVO6X7GHEcqKT3XLxjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZfY4VbKVxX4+pFDBiTaLeb1NBpR8aCASSE7xKSUzmJM=;
 b=aJTlvS5gwE1ObsNMAYvrerCzc6yIuwNm2lxpt5OVJi/AqVooX3xlqiXhGx1/4No8dRZbnu+bVFoN08DEVnBzTDGRKxCML+8poDHyXfUQFN3TiBad16mgiw2cwkALyWTASxDbUbofSQ/6O45Cqy/z+qfDdVJ2/dDUZ4Rfc7ls2DRR3HAdZ+00iJ0TDoA61i5NUqfXfNlOOk3ogCs+1OFpViIuOvO5flS8JKs+Hhio2qzybW7KSNO7rHPn4q81lj3d3IK9YJ480iLVz3B/4gErOPD192LDxfRybXEQSbMgMz2mKpFSvMzepvokNRl+WB/+pB98eH0aMfRDvldwBlgx9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZfY4VbKVxX4+pFDBiTaLeb1NBpR8aCASSE7xKSUzmJM=;
 b=lFi0q+tUqMXfuDKTrJfGkq6E3dJCB3q61VEXU36PVMpL+s367pVzwkAPERcho3SkpKjfVANEstlRfSSoNUTVQJxuaM7MHJP45bQGqV4dO1PLI+RpCK5NiSWGRw4IIecx6StVBO39gD2d2zvU6JabybLyumzYWs31hrUbQSROn1A=
Received: from BN8PR12MB4770.namprd12.prod.outlook.com (2603:10b6:408:a1::30)
 by BN7PR12MB2595.namprd12.prod.outlook.com (2603:10b6:408:30::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 09:47:43 +0000
Received: from BN8PR12MB4770.namprd12.prod.outlook.com
 ([fe80::2054:faac:dec5:d93]) by BN8PR12MB4770.namprd12.prod.outlook.com
 ([fe80::2054:faac:dec5:d93%6]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 09:47:43 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     =?iso-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
CC:     "Brol, Eryk" <Eryk.Brol@amd.com>,
        "Zhuo, Qingqing" <Qingqing.Zhuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>
Subject: RE: [PATCH 1/2] drm/dp_mst: Revise broadcast msg lct & lcr
Thread-Topic: [PATCH 1/2] drm/dp_mst: Revise broadcast msg lct & lcr
Thread-Index: AQHXCM+JuH8uyDFmm0SPjn2w130vSapkZ0OAgAACBYCAAMmu4IAAimYAgAFQUfA=
Date:   Wed, 24 Feb 2021 09:47:42 +0000
Message-ID: <BN8PR12MB4770DDD0992FDBFEA2E573FCFC9F9@BN8PR12MB4770.namprd12.prod.outlook.com>
References: <20210222040027.23505-1-Wayne.Lin@amd.com>
 <20210222040027.23505-2-Wayne.Lin@amd.com> <YDPjiz4tiMRo320Q@intel.com>
 <YDPlPRJXVYfPZenQ@intel.com>
 <BN8PR12MB47700C725A9D4411BDBABE1BFC809@BN8PR12MB4770.namprd12.prod.outlook.com>
 <YDUChEqKeqw1znMc@intel.com>
In-Reply-To: <YDUChEqKeqw1znMc@intel.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=7a32bd6a-24e3-4369-98e8-9806df25f6d4;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-02-24T09:30:17Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [218.164.111.50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b2d9f8e5-4fbc-4928-4dbc-08d8d8a93b6f
x-ms-traffictypediagnostic: BN7PR12MB2595:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR12MB259568F77D98D0C70A2BAA7DFC9F9@BN7PR12MB2595.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: olvujuSXVddsMGz8LLT2Nd0GxkJvhOx4K5EuI7GS+7O7fbpjl4S6XWBrkyQBn/6qV9fvDZUFxtXyx9+Y7/j4K69ICByOqmaOYH2ESbwLVrn6IzDJSM7NmwFpOANSM03JVP5f0680u46NndZiE0SIOnF4m0SxJJ9BhFcRjIHMqctOgVtDp8bcBviZRQfBBLciDyvnGDWPLXQwm7QKy2xx1s5Bgh3El0fFUTrs8HRoco4yMTZ6oiW9pIpR2/sKfxsHfKjfUIwhnIeaVk5iBv20Wi75DD+86m6cobylZRNvjR8XQFgTh6M+VQJQHvLexfQUuaEFSJqNgZ5krSD/d1MztjXa9tVIZyjJcYrPdnMgPeGYb1KsWOUymE5vlD4BLvClYa87Ee6nei53q01pqUsIRoEJF8wxLJqb//piPTPU1GKe3HtvFD3U7CRNFZBjtnpdOEnezQlxKISFTimnp24KNHvnHhOPfmqqS+11B26Cb4UdYvmKdsT5EDqYN/fo9hdiJImpe4dChj+HouHtfnqHTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB4770.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(71200400001)(33656002)(8676002)(66556008)(4326008)(52536014)(66476007)(26005)(316002)(64756008)(55016002)(54906003)(9686003)(66946007)(76116006)(6916009)(66446008)(5660300002)(66574015)(6506007)(8936002)(53546011)(2906002)(83380400001)(7696005)(86362001)(186003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?omURnQFItqHQLAYELQzgmdd5rsxfh1UmxgxVdqiGsanaCDQetTqU+Nu0eS?=
 =?iso-8859-1?Q?aCbtTZ3l+0dvHIil4YKiPAF3HcR4FAMdsUIseHosiPs67paFH/AV4tpF6J?=
 =?iso-8859-1?Q?ryB4UPf63sL/wpAnrvunBk9N/95laUAVwqa71eglBbnwnlKdEjN+JM3laB?=
 =?iso-8859-1?Q?TRBFoo/W+oKn3fbcf1ZEssEYQWqyGC/Pt2Fdq/g1JvrabgZtfHAWTubUcy?=
 =?iso-8859-1?Q?CoLFwcmfPSE5aCW9k60kRXDgZjRVGX1IZvA112yqHnYEt+RVLoADCrgSNJ?=
 =?iso-8859-1?Q?xgh8Kgez+oYK0nJwY9buuSPawyfm1eAsLAAytVZm1sFuZ51DGv3s01OW1t?=
 =?iso-8859-1?Q?C2BOfxnwGlQASxEL7zEUR9YAXcxUrDOEJ4o2vjqFeBJiHtXqT9DEDxE/jL?=
 =?iso-8859-1?Q?RFpvoTsiUB7csN+rZDLxoNBG3C3Q30aCKLAfdajnsZrxQVgWiCNqbq7Wfa?=
 =?iso-8859-1?Q?ILtDKM5hba8izZKJ2b858yJioCFimIP8aJjcxeuSWkvao56T5V6e5/txCC?=
 =?iso-8859-1?Q?aOd1u2GTFjU44NeOm7Os4FOwdTlV55nYHSluLn9iDbbRhd8J89ggGwqhOs?=
 =?iso-8859-1?Q?/Hv2e2BHqUncLDqALviAiEUk8slDah1ZDxnGe0juI0C7Pms6oDD8+ef/UV?=
 =?iso-8859-1?Q?+t+iGGi0F4sY1LcsHhznR2BWX+OxpKmFM1lzB640P5y581KcsTp0bLH7AD?=
 =?iso-8859-1?Q?TkTDNaa86jOFQGr5ZdIGCnQrzNa8Sto7s8/oU8LorAy98fqTf6/PSLdBnK?=
 =?iso-8859-1?Q?nvHg4KOluo9hPMjGdB9VgK0wM0btUKTdW7elOCDA1Dmofjrs3WO4bE8zVT?=
 =?iso-8859-1?Q?HOjufB03yw4sQgTaGfoBA6UggRccnV79lIQn5dP/849xs6WH2Ts9jficzf?=
 =?iso-8859-1?Q?RCXFUL9OnW1eR5K/GrNgc6SeBxSYehfLHzqiv22QWivDc2Y/2uXdxGZq0u?=
 =?iso-8859-1?Q?vKqx1ywkflm82yUIsCQP70xXeRRlBisRBiv0uyxaNd3BJMLbLi9x0JLCSi?=
 =?iso-8859-1?Q?5zNn8loayhYNOd2DfOoc8mVCJDD9UtbwmsCtNZYZsaNcDQIRStQMeeMlBc?=
 =?iso-8859-1?Q?0zwipAAi9vss+KwkdWzddWQaVuvOljwCn2wlTw1v3APLJ6bSRjZw2EsGGK?=
 =?iso-8859-1?Q?kyuCdY8Wtnb/hfx0MetUt41dBHZ6RKZjRrGubFVTCtmmcUg+MAsOOTmVV0?=
 =?iso-8859-1?Q?NbqKUaqX9vQmgBVuI7TegLadnODupOdk+jQeqLc+E/SFrCNNe2+E5Ity27?=
 =?iso-8859-1?Q?+xmBTw1Gcv36mNnx7U9R+I+ZsYidwGYvND/3Bhk+vPhV/FRR9S6Wn+RoZc?=
 =?iso-8859-1?Q?D88hWSayoeXL6pLxR3TzvPYtgo2kEdVhhcw0iwHsU4c+sEmqA4EAYxYzX9?=
 =?iso-8859-1?Q?MdVBR6k8rC?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB4770.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d9f8e5-4fbc-4928-4dbc-08d8d8a93b6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 09:47:42.9938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bzowDm+Cj/5iE9nnKLyzrbaS27vE57mgCiwpky7/rNUmTylSIlFr84YctoYUr8KOyC3/xcAGBhDJy2OjmVi7Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2595
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> -----Original Message-----
> From: Ville Syrj=E4l=E4 <ville.syrjala@linux.intel.com>
> Sent: Tuesday, February 23, 2021 9:26 PM
> To: Lin, Wayne <Wayne.Lin@amd.com>
> Cc: Brol, Eryk <Eryk.Brol@amd.com>; Zhuo, Qingqing <Qingqing.Zhuo@amd.com=
>; stable@vger.kernel.org; Zuo, Jerry
> <Jerry.Zuo@amd.com>; dri-devel@lists.freedesktop.org; Kazlauskas, Nichola=
s <Nicholas.Kazlauskas@amd.com>
> Subject: Re: [PATCH 1/2] drm/dp_mst: Revise broadcast msg lct & lcr
>
> On Tue, Feb 23, 2021 at 05:32:32AM +0000, Lin, Wayne wrote:
> > [AMD Public Use]
> >
> > > -----Original Message-----
> > > From: Ville Syrj=E4l=E4 <ville.syrjala@linux.intel.com>
> > > Sent: Tuesday, February 23, 2021 1:09 AM
> > > To: Lin, Wayne <Wayne.Lin@amd.com>
> > > Cc: Brol, Eryk <Eryk.Brol@amd.com>; Zhuo, Qingqing
> > > <Qingqing.Zhuo@amd.com>; stable@vger.kernel.org; Zuo, Jerry
> > > <Jerry.Zuo@amd.com>; dri-devel@lists.freedesktop.org; Kazlauskas,
> > > Nicholas <Nicholas.Kazlauskas@amd.com>
> > > Subject: Re: [PATCH 1/2] drm/dp_mst: Revise broadcast msg lct & lcr
> > >
> > > On Mon, Feb 22, 2021 at 07:02:03PM +0200, Ville Syrj=E4l=E4 wrote:
> > > > On Mon, Feb 22, 2021 at 12:00:26PM +0800, Wayne Lin wrote:
> > > > > [Why & How]
> > > > > According to DP spec, broadcast message LCT equals to 1 and LCR
> > > > > equals to 6. Current implementation is incorrect. Fix it.
> > > > >
> > > > > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > ---
> > > > >  drivers/gpu/drm/drm_dp_mst_topology.c | 10 ++++++++--
> > > > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > > index 17dbed0a9800..713ef3b42054 100644
> > > > > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > > @@ -2727,8 +2727,14 @@ static int set_hdr_from_dst_qlock(struct
> > > > > drm_dp_sideband_msg_hdr *hdr,  else  hdr->broadcast =3D 0;
> > > > > hdr->path_msg =3D txmsg->path_msg;
> > > > > -hdr->lct =3D mstb->lct;
> > > > > -hdr->lcr =3D mstb->lct - 1;
> > > > > +if (hdr->broadcast) {
> > > > > +hdr->lct =3D 1;
> > > > > +hdr->lcr =3D 6;
> > > > > +} else {
> > > > > +hdr->lct =3D mstb->lct;
> > > > > +hdr->lcr =3D mstb->lct - 1;
> > > > > +}
> > > > > +
> > > > >  if (mstb->lct > 1)
> > > > >  memcpy(hdr->rad, mstb->rad, mstb->lct / 2);
> > > >
> > > > We should also do something about RAD no?
> > >
> > > Just skip the RAD stuff by s/mstb->lct/hdr->lct/ here I guess?
> > Thanks Ville!
> > Since LCT=3D1, broadcast message doesn't have a RAD and this is taken
> > care while we're constructing the header in drm_dp_encode_sideband_msg_=
hdr().
> > In drm_dp_encode_sideband_msg_hdr(), we skip stuffing RAD if LCT=3D1.
>
> Ugh. How many levels of these do we really need...
> Either way I'd prefer the code be consistent so you don't have to sacrifi=
ce so many brain cells to understand what should be trivial
> details.
Hi Ville,
Ya I know.. Currently it goes few levels to encapsulate the final mst packe=
t.
From my understanding, this function is trying to prepare needed data and t=
he actual mst packet header is constructed in drm_dp_encode_sideband_msg_hd=
r().
However, I will push another version by your suggestion.
Thanks for your time!
>
> --
> Ville Syrj=E4l=E4
> Intel
Regards,
Wayne Lin
