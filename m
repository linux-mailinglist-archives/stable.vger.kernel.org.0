Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60AC32256D
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 06:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhBWFeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 00:34:02 -0500
Received: from mail-mw2nam10on2081.outbound.protection.outlook.com ([40.107.94.81]:15808
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230296AbhBWFeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 00:34:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FiR9H4A1r6Zi0LoFey0sb3F6rmp0UbojGvmV6vxt2TyqjMIzRsljdmrB/LKn4P3J7CgeYXG2/WjfRvoIEIi23VX/pE4KWqauSRi7mgX5qSnxuByqC+LaFZop6oD0TNmJ2zAcQBqBYBrwiOIM/e8YkADTgw3lJ8yvQ1gfx9OK3549oyXSR4a3bnp5/cYKyF7zA1RynDzVPRPu7uuPf2CDLKEEPnZGvQtBD1E9J1Zuav70DjI4gufse6EfNH4EeXild+cdzLLEdeDPmVosONumVSIbPQm0ZEiaXZh33HpXmjxfXU37CsvSktsaJbg6datFYf04q9OHrRN/NeDyfQ9cAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUIePYHz2XylQnIm71Yww5NQPcFcJ1wdeoTDBEwLpMc=;
 b=EKtTUJAWuYBQMYYc781Mq5/XxPtmb9amY2weDDiUQtawYxVXuqPdaRNVy/pIIEAupC3eORPBApz38HxP5MHIu0H4lqZGduo60Ho0VuY7Rcc0ka6i6QpqedfhyTKnmANc+I0fushle/BBBbx8NEFpPwY03Py+K5u3SQxaRCii9A/4nH3DnmlQT1ix/XLQo1NOrINrVXDXQ7+Ek7WDrKb6raA/Oxv6Xj54zQwifAUs60oborgtYQie7JseEbSj//VDHJpyQsQOtUtfexb1zHMTqdSNQaCQ1jLR1QxFGZqYWeNHYjhdHYFKvdyZLjcZAJJWw38l87bqdxvVOO/ZxuxvXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUIePYHz2XylQnIm71Yww5NQPcFcJ1wdeoTDBEwLpMc=;
 b=tKJPkLR9BE8xoVszk+zmWGdh5Bb9NlMHYBI/9Zx2BFHf+VvhXybqnBSl/HceNUu4cF2JYv5oKViCrWwbBSELQUe6OMRSPY2hA6q0edLzliRr2GRuiwGrtNA9OoANJhNyg5P2gJ2FD40SacSC/yRe42TOjdgRJ9n8vq8tI/gSfko=
Received: from BN8PR12MB4770.namprd12.prod.outlook.com (2603:10b6:408:a1::30)
 by BN6PR12MB1377.namprd12.prod.outlook.com (2603:10b6:404:1c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Tue, 23 Feb
 2021 05:32:37 +0000
Received: from BN8PR12MB4770.namprd12.prod.outlook.com
 ([fe80::2054:faac:dec5:d93]) by BN8PR12MB4770.namprd12.prod.outlook.com
 ([fe80::2054:faac:dec5:d93%6]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 05:32:37 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     =?iso-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Brol, Eryk" <Eryk.Brol@amd.com>,
        "Zhuo, Qingqing" <Qingqing.Zhuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Subject: RE: [PATCH 2/2] drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast
Thread-Topic: [PATCH 2/2] drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast
Thread-Index: AQHXCM+dGyBeQBitREOazgA2B01InqpkZriAgADPzQA=
Date:   Tue, 23 Feb 2021 05:32:36 +0000
Message-ID: <BN8PR12MB47700A55800116A14DF96B1FFC809@BN8PR12MB4770.namprd12.prod.outlook.com>
References: <20210222040027.23505-1-Wayne.Lin@amd.com>
 <20210222040027.23505-3-Wayne.Lin@amd.com> <YDPjFzPdfZXJqex8@intel.com>
In-Reply-To: <YDPjFzPdfZXJqex8@intel.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=c28ed030-ac42-4e2d-84e6-100b4e2abdb6;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-02-23T05:23:59Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [218.164.111.50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c8b70e7c-20b7-43ef-c4db-08d8d7bc6de4
x-ms-traffictypediagnostic: BN6PR12MB1377:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR12MB1377EF6E2C70ACEE2B93DCCCFC809@BN6PR12MB1377.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VIE5TtVc646e3EO8tR6cjXkJpVZebDtRUgxBEKih7liphsAdnNwmktZxY5CI+UhIBNYLmueydUBHxaeQji/Pl31IH6Eikg2MObEaWxSxGceUZASxWFTsomkroG6UqxPEHw94VKKgUJwTJrKaiAQsOZDea2BsiwAYsEmGiHM4tR9igq84CjN9eTFMfZxyPGU98/+TZ65c52FCTd5bqWWAOzekSlNbJrXvzDXKZZks9+dd5XW6wf3CHTFHDOAeKIDzM5TXUFdUElYfoxQ6sNz0Etcqg4wi257tWjylvQT3r8hc+BoJ/AMe0/YfCAWGV0E3uWsbUkIkYqW7NhYlAEUk+TZc5Ex1NQAHrCRJEX+ZEwmk95nVEQHs0gGlkwS6PAq1Ehxx5nUKJorZ4OJuHE1U8/Dsu+vDiXCAz03VkdmRIDTHs3eyLapLaC9cB5Axi6iTb5VWp6UHNF73MkIwouLwWEpUiiFfRD53l18AD/ag2q7ePFf523AsFyP4NGiX5zJhPUbINorUtNYUMKpr20uLhd0F+dTs+xTQZU4RFBJQscj2jd2c755Ju3pEkOv6P0YVX/IxyHr7xgJzzS8aacO6plw+4uLWQlXGm9+NIRutHl4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB4770.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(83380400001)(76116006)(66556008)(66946007)(66476007)(66446008)(316002)(8676002)(54906003)(53546011)(478600001)(45080400002)(186003)(52536014)(5660300002)(966005)(66574015)(64756008)(9686003)(8936002)(26005)(55016002)(86362001)(2906002)(7696005)(6916009)(4326008)(33656002)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?V6WA5ya+BjtkPewTCicCZUH6xJuxGC+X4dh7VxvMFeZes8D2bbNLvYwP9h?=
 =?iso-8859-1?Q?HaMvqewRAXUNG/i8HdHCxe0zkfa/9n8Us8//WZTj7xS2N06x7ljPHNh4Pi?=
 =?iso-8859-1?Q?cf0Jh1nw+7FaWktypmIwoCJF06Lo35YggcWvPBFVrDh//a/+BhV+7YOJCI?=
 =?iso-8859-1?Q?cmgLBfjxZnT3dt0QxXL1J16AFPB+pzxAuHQc8VGGTaQHNunD/3YnNv+kSw?=
 =?iso-8859-1?Q?+C2ol6y8Pb3ZVVspyNkMmWfh9giYscg9lNAKxXf6i/iOPPXIs8ssbsgjDl?=
 =?iso-8859-1?Q?QJ46Oa/wxTdRCuuIIkG/eS8/E4FvHZxdOqskmX8FRyTSDTxqtmpPMC71dH?=
 =?iso-8859-1?Q?E5WG/TR5Oesm45bZDUXHgStXarGDBoN4jEVT0soKfiUVwljtteDa2sZ/GO?=
 =?iso-8859-1?Q?3vyirY7TgPkEJYWfadX4RqOTWPe6BhviGKCPHfVJAJuwpmQLVyqJptxMpn?=
 =?iso-8859-1?Q?yYYVlkoFrv719k39sMhxoYy37t/mqUjKegJe+z3DPhZE7rMyJ47OS3wkoE?=
 =?iso-8859-1?Q?O/eHvbZcJ349uTC3LyNYBPTay5OwNLmA9Tmq008RLSShkGvaestuOFQw8f?=
 =?iso-8859-1?Q?wjP/rTk9Wa0YTIrx6q2+H1tCImBfOGtTn6FsvIawEFc1Mp61lMl1jqjry+?=
 =?iso-8859-1?Q?2cFaIYHeiiBGMXDYKnlX/DaoMtmEjtkVGij27HtX73heNsZMtlRaom5RnO?=
 =?iso-8859-1?Q?T1F10VaRv0HoARTEgoIUuNIb1phyFHyTBaLnClP+RpgySw/8e+Ll+Q/THb?=
 =?iso-8859-1?Q?dljudxoEd8YVKy4kIRS1qIPHbQXeW5GZBkdi4dSomrxXXPm8KPs0RGqjzt?=
 =?iso-8859-1?Q?d180NQn7NtRCDUj6vRJniMId9JvqWKn3GfOUfGFH1RRUSgHgFraN1Uv8hC?=
 =?iso-8859-1?Q?HXrRkYc31jK6As126TKTVcIM+4Z91vf7SfqoyKXvH1DzuqbaeyYU1wvsCi?=
 =?iso-8859-1?Q?dz1FFCFh9Hy1UvxPjiOgVmx3PZJFwTFA8TDnI++jKdSsVS+91QVCd4gpy4?=
 =?iso-8859-1?Q?/O+mTH2J+sg+JcaAP9xW0zwxdH7G3kDVu+1Vn0+QUGatiJQCrAUHthLCUM?=
 =?iso-8859-1?Q?rJfLgYlQZBCLzpy15aIg0ovGWyK8sA7aZ/MDLgHNmy8H1wdt7EoFcueQVK?=
 =?iso-8859-1?Q?JJ9SMDc06i5mePsZ84ydEl1F7uw907PQBUro/RLlDN/6/1cZpbjaqg4XV8?=
 =?iso-8859-1?Q?g4FYpQGOwhqiuzb4mJpoL2BAPV4kgzDSAsKeuVNMfqw6BulJ79rwJoBfRl?=
 =?iso-8859-1?Q?vj0Ia0iTNHOj3ZhGuZicMfoKmVUXwEYnmij55JGhOqgBMddpSp1i/ADm4X?=
 =?iso-8859-1?Q?xBN9la/ZNbvTne9OUia9Ay1nfwA6e/RzZNZ18ZC3F/SNG2OaiDxXuT+gd3?=
 =?iso-8859-1?Q?kc3KpN19Qw?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB4770.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b70e7c-20b7-43ef-c4db-08d8d7bc6de4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 05:32:36.8169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a6D+7hiBLSKX5hXixZ7b0OOvTEUfPs8hA2ZESLAw7wgl+JFtxUROqNhR4pT7sbMiOZnBU77llL9hk1KE9zYVJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1377
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> -----Original Message-----
> From: Ville Syrj=E4l=E4 <ville.syrjala@linux.intel.com>
> Sent: Tuesday, February 23, 2021 1:00 AM
> To: Lin, Wayne <Wayne.Lin@amd.com>
> Cc: dri-devel@lists.freedesktop.org; Brol, Eryk <Eryk.Brol@amd.com>; Zhuo=
, Qingqing <Qingqing.Zhuo@amd.com>;
> stable@vger.kernel.org; Zuo, Jerry <Jerry.Zuo@amd.com>; Kazlauskas, Nicho=
las <Nicholas.Kazlauskas@amd.com>; Dhinakaran
> Pandiyan <dhinakaran.pandiyan@intel.com>
> Subject: Re: [PATCH 2/2] drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadc=
ast
>
> On Mon, Feb 22, 2021 at 12:00:27PM +0800, Wayne Lin wrote:
> > [Why & How]
> > According to DP spec, CLEAR_PAYLOAD_ID_TABLE is a path broadcast
> > request message and current implementation is incorrect. Fix it.
> >
> > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/gpu/drm/drm_dp_mst_topology.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > index 713ef3b42054..6d73559046e5 100644
> > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > @@ -1072,6 +1072,7 @@ static void build_clear_payload_id_table(struct
> > drm_dp_sideband_msg_tx *msg)
> >
> >  req.req_type =3D DP_CLEAR_PAYLOAD_ID_TABLE;
> >  drm_dp_encode_sideband_req(&req, msg);
> > +msg->path_msg =3D true;
> >  }
> >
> >  static int build_enum_path_resources(struct drm_dp_sideband_msg_tx
> > *msg, @@ -2722,7 +2723,8 @@ static int set_hdr_from_dst_qlock(struct
> > drm_dp_sideband_msg_hdr *hdr,
> >
> >  req_type =3D txmsg->msg[0] & 0x7f;
> >  if (req_type =3D=3D DP_CONNECTION_STATUS_NOTIFY ||
> > -req_type =3D=3D DP_RESOURCE_STATUS_NOTIFY)
> > +req_type =3D=3D DP_RESOURCE_STATUS_NOTIFY ||
> > +req_type =3D=3D DP_CLEAR_PAYLOAD_ID_TABLE)
> >  hdr->broadcast =3D 1;
>
> Looks correct.
> Reviewed-by: Ville Syrj=E4l=E4 <ville.syrjala@linux.intel.com>
>
> Hmm. Looks like we're missing DP_POWER_DOWN_PHY and DP_POWER_UP_PHY here =
as well. We do try to send them as path
> requests, but apparently forget to mark them as broadcast messages.
Hi Ville,
I also look up the spec but DP_POWER_DOWN_PHY & DP_POWER_UP_PHY seems to be=
 defined as path or node request only. Not broadcast message. Please correc=
t me if I'm wrong here.
Appreciate for your time!
>
> >  else
> >  hdr->broadcast =3D 0;
> > --
> > 2.17.1
> >
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flis=
t
> > s.freedesktop.org%2Fmailman%2Flistinfo%2Fdri-devel&amp;data=3D04%7C01%7=
C
> > Wayne.Lin%40amd.com%7C372bbed7b5354ca05f5608d8d753533a%7C3dd8961fe4884
> > e608e11a82d994e183d%7C0%7C0%7C637496100180287539%7CUnknown%7CTWFpbGZsb
> > 3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> > 7C1000&amp;sdata=3D2uhm9Nf31hfhf%2FbmwfqYW7b6ay9swWb8oS10Uc%2FVFRQ%3D&a=
m
> > p;reserved=3D0
>
> --
> Ville Syrj=E4l=E4
> Intel
Regards,
Wayne Lin
