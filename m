Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0162432256C
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 06:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBWFdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 00:33:38 -0500
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:23137
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230441AbhBWFd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 00:33:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKxj0/xv9eORz4bfpktFZRqKCCSInQhXNcI+bYDmmnsgdIBvekiowlXDA1a1J58asedbldJp0uhGEf1VsMctAQWiOdZOTkLGI1jrkB8vAtkcTjdq6DT0aSxSc+EiJ1PJvOMCtsW7LMcAWCfCsL947B259cRnIGU6/ez7bF0/OfnpZOAopVQuYvff0LWzTkGjZVU8r6WgiKceuJ1HOxbQtaUCMzV+zbqgVufDEdub4vz1UQ7RgIxk0f6xl16QUE/EJJ3Nk9FNjsO54i9td2M+BKCPI/oOsThGNgiJc4VoPET6ar8hb0KQtTEVgSbwPOpbP+wfA1yAoKWTHKvjK7nWWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSnyBE9/mMo+Igz/fOa1rqENk0zhiiIFLLPt5NDk1Cw=;
 b=lLrQgVMggN+HyfHswcnYPqKKyseakdeeI98It0BWAf3tcf9Zz+v+EQRYC7q6HNvlqexwkmQS+jSbvPknZ7bQOpUbPEtzxQKFCq/PURmRXEOIC+fTl8RYWpHoCUvAGDgFObxcIJ98wWveXsZJQuk2plkjCKSQZqbGpgATU0QXhJohWBnFqGMdfv9LngVAmtoM2I+7FA69ZSsWrcKRLZe8PEkNVEeHnX3kt63SimbcreXmLvbtQr6KDodKhBUjdY4qOZNfd4+hL3AYME25pQBuZijSzr2wkUjHliwOn/O+T9NclfUMvDamNblsRlVH+P28q7t59SG8GeIbt1CfQ7AHSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSnyBE9/mMo+Igz/fOa1rqENk0zhiiIFLLPt5NDk1Cw=;
 b=5bYntOtUDGbcUFTpIlgDnVF2lYKa2sJ3dJId9HFFawzZfr9gPFXaqRgs3xNmqFEGV1jCQEYaqToZikNQY00mo/WMf1/1cX+Bqka0L/3WLdluE1RFOc6eJeVtaNPdHvXdYUzjDijslkegPqo8wIjfzpQiDZ7G2Q1H2M6QOi6BGjE=
Received: from BN8PR12MB4770.namprd12.prod.outlook.com (2603:10b6:408:a1::30)
 by BN6PR12MB1377.namprd12.prod.outlook.com (2603:10b6:404:1c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Tue, 23 Feb
 2021 05:32:33 +0000
Received: from BN8PR12MB4770.namprd12.prod.outlook.com
 ([fe80::2054:faac:dec5:d93]) by BN8PR12MB4770.namprd12.prod.outlook.com
 ([fe80::2054:faac:dec5:d93%6]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 05:32:32 +0000
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
Thread-Index: AQHXCM+JuH8uyDFmm0SPjn2w130vSapkZ0OAgAACBYCAAMmu4A==
Date:   Tue, 23 Feb 2021 05:32:32 +0000
Message-ID: <BN8PR12MB47700C725A9D4411BDBABE1BFC809@BN8PR12MB4770.namprd12.prod.outlook.com>
References: <20210222040027.23505-1-Wayne.Lin@amd.com>
 <20210222040027.23505-2-Wayne.Lin@amd.com> <YDPjiz4tiMRo320Q@intel.com>
 <YDPlPRJXVYfPZenQ@intel.com>
In-Reply-To: <YDPlPRJXVYfPZenQ@intel.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=7bb80e3e-9581-4d21-bd85-045befde5112;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-02-23T05:11:19Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [218.164.111.50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 92203f60-b4ab-46f6-9229-08d8d7bc6b6d
x-ms-traffictypediagnostic: BN6PR12MB1377:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR12MB137722FC2283F4D5BC0F41E4FC809@BN6PR12MB1377.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BnVX4HIVMvh1alQCUV3Qv3KHgtJC95mf7qdHg0P5T7JD7feFXlN7CXvtWvSmAdLyHhxJA75jnLNHhvD+NS3DhyA1h4bNC+aCeJCmpBfAAks5MKs6gaBtCtuA5gwteDap9tOyojyugtXidGN+axFg01DIJCn+WpWzw0JO0WaFmGr5H11tgU19g3EmWrNvq1vaW95iUcas8IZcHl+Jvfqv62P1acUjABKcPBRAvsAHfzx0DWOYrMfXGu0PSm6JTtFEwnBN5eiS2HrIA+MdXL3+fzzSWSvw/SFHOrFspEmlxqQDrutDQg/XPzTqi1rOha14A2FX61pyW86RNdNaCXe0pWKXR4ygaDe7nHFtZ6mnXInQvShaLzaYlcsuhQ+Yyjwn4ypLEqtjbjBVk+Gl8yiTbwi+FRV4B51Kq1XjtiFZdZ/ONcJ1bV2vdPMv2N1e9fdGcmqSGGd/b4DilQshjOlt148nXkcU6jLIOvPf9kLqCJM6RmM3OMMvp4a3lw4aP+0fcVRFWOyMKpHeaAC9RcTEVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB4770.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(83380400001)(76116006)(66556008)(66946007)(66476007)(66446008)(316002)(8676002)(54906003)(53546011)(478600001)(186003)(52536014)(5660300002)(66574015)(64756008)(9686003)(8936002)(26005)(55016002)(86362001)(2906002)(7696005)(6916009)(4326008)(33656002)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?taOD6Ecu+Tz+Anb0gxnVIPMApcVr/gS3JsNCvW/zoYVUmGJy/4ZfuzNNmI?=
 =?iso-8859-1?Q?D194WU5xpQUcRmKem8gG71J/aGUphJ+LdbJ98FGUtaHt1jn6HcytaQjgNH?=
 =?iso-8859-1?Q?9Ztzib34jv6vOKGUJL6waaUqVp9pgRVusQGBl233oz8sjmBJdAwJaCz8bk?=
 =?iso-8859-1?Q?WrsHEir7fjcAGwQDIDRPu8ROt0ksNgnRwtc6aGpjMm3GcaTH+mcQMhrNis?=
 =?iso-8859-1?Q?Iw5OJxToD9uOWIQmjID9mNzxBIecsFI/ddtNjcAexksU1EWGUoYKvgPaaw?=
 =?iso-8859-1?Q?nUqYq0y7r2zR84/0NUJPMSKaYRNY2r/3ZhaUXc5MJSN0OiIJJSUWAooa30?=
 =?iso-8859-1?Q?iXNC8AX3pYE+hzJbyfPOla35i4ikhA/JYoHLKyUy4g4DUzGHh63i56JSZ/?=
 =?iso-8859-1?Q?auWC3DXqgS3SYoSoul7TYtwN1CVy1tpmNcsK62tTmoeAT8MTC/GUwan8Ba?=
 =?iso-8859-1?Q?56NmVekvEWWsT/xNRQqQ5i6atWNXC208cSmtpjNclX77NoJNOVDOKdBCky?=
 =?iso-8859-1?Q?/gP4BUxY+K9bM48l1MUeN5Qi2tsCnpaRg6uFhobwb7fE3d3vCHebmOURea?=
 =?iso-8859-1?Q?O6kWl6T8GBhWav/jHsAp67vjDzad0mK+eLBahFT0Xuwtb5Pucdql4u5e49?=
 =?iso-8859-1?Q?g1ZHopsvUGwAzj14RQ+aADnxnUYxt7BSkJlMrHPw8xR+H66VRMXMjm4VQv?=
 =?iso-8859-1?Q?89zMxkMOc6Uderj8LFtSZlobPWhlImUBRaPWGFmDEPriZe5fpzjCkNbXwD?=
 =?iso-8859-1?Q?iE6GXR6qT/d2Y1t8Cr+9VbrSSlLzaurWfaEWwrLgAqFiZxTzpa4eE6SVqY?=
 =?iso-8859-1?Q?WsC66WMQKIpZ2y6kwVRELLQvuW2E3mWjbKDrBBcMSWK2q/SEUf0C+mNV0Y?=
 =?iso-8859-1?Q?fGCDgweiR6U3TinUYEdm+dfcuh4bH0Tpnfwclb2qC7KKr3H2huZLj00h9o?=
 =?iso-8859-1?Q?YFeitNVvmmoBuo+LNg2ThUjdlvbKPW6PpkshFG5g3hTop5ishXq7Xign55?=
 =?iso-8859-1?Q?BppEUElHDLCRnaWhy4IsgkOMBXBzOF39TRbCRr3SjiChL3MEt8oJyCPXI0?=
 =?iso-8859-1?Q?lbXpXj0Ynt77+dGSU91z4rJZoP79sYbEveDfILTQ1ddi60oUsyADNKu+Zo?=
 =?iso-8859-1?Q?XWKHRuU7kwRNLTZhqqCYxw8y2j/2/qNndj+mZ/iI5vdvm0NYRH+zHvzFSc?=
 =?iso-8859-1?Q?Z10VrWcpP165RTJQYYGa/uraivsVEdUhFFfdaWMIKb1EBxxeIVLWIdjPDj?=
 =?iso-8859-1?Q?YHB6ZHieuVZ0S2+E3pQoUUS/qMkIu9uL9JVoBa+RrQXhKS/me7wPpUNhlg?=
 =?iso-8859-1?Q?jydK+IAE9+usbiSoJKUYZEFiXm14Xr0H2b0J3Ous3qj3RoIxYYuhw4m+MX?=
 =?iso-8859-1?Q?nKqYG+fFwh?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB4770.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92203f60-b4ab-46f6-9229-08d8d7bc6b6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 05:32:32.6722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mtvqh5adWMjPM2LNmXJZccVX1w7NO/gVKLayscgWthb2Z8wz8w5a85anng9WrU1Ri4svHzm2o0QjGv4tJKHN3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1377
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> -----Original Message-----
> From: Ville Syrj=E4l=E4 <ville.syrjala@linux.intel.com>
> Sent: Tuesday, February 23, 2021 1:09 AM
> To: Lin, Wayne <Wayne.Lin@amd.com>
> Cc: Brol, Eryk <Eryk.Brol@amd.com>; Zhuo, Qingqing <Qingqing.Zhuo@amd.com=
>; stable@vger.kernel.org; Zuo, Jerry
> <Jerry.Zuo@amd.com>; dri-devel@lists.freedesktop.org; Kazlauskas, Nichola=
s <Nicholas.Kazlauskas@amd.com>
> Subject: Re: [PATCH 1/2] drm/dp_mst: Revise broadcast msg lct & lcr
>
> On Mon, Feb 22, 2021 at 07:02:03PM +0200, Ville Syrj=E4l=E4 wrote:
> > On Mon, Feb 22, 2021 at 12:00:26PM +0800, Wayne Lin wrote:
> > > [Why & How]
> > > According to DP spec, broadcast message LCT equals to 1 and LCR
> > > equals to 6. Current implementation is incorrect. Fix it.
> > >
> > > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/gpu/drm/drm_dp_mst_topology.c | 10 ++++++++--
> > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > index 17dbed0a9800..713ef3b42054 100644
> > > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > @@ -2727,8 +2727,14 @@ static int set_hdr_from_dst_qlock(struct drm_d=
p_sideband_msg_hdr *hdr,
> > >  else
> > >  hdr->broadcast =3D 0;
> > >  hdr->path_msg =3D txmsg->path_msg;
> > > -hdr->lct =3D mstb->lct;
> > > -hdr->lcr =3D mstb->lct - 1;
> > > +if (hdr->broadcast) {
> > > +hdr->lct =3D 1;
> > > +hdr->lcr =3D 6;
> > > +} else {
> > > +hdr->lct =3D mstb->lct;
> > > +hdr->lcr =3D mstb->lct - 1;
> > > +}
> > > +
> > >  if (mstb->lct > 1)
> > >  memcpy(hdr->rad, mstb->rad, mstb->lct / 2);
> >
> > We should also do something about RAD no?
>
> Just skip the RAD stuff by s/mstb->lct/hdr->lct/ here I guess?
Thanks Ville!
Since LCT=3D1, broadcast message doesn't have a RAD and this is taken
care while we're constructing the header in drm_dp_encode_sideband_msg_hdr(=
).
In drm_dp_encode_sideband_msg_hdr(), we skip stuffing RAD if LCT=3D1.
>
> --
> Ville Syrj=E4l=E4
> Intel
Regards,
Wayne Lin
