Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70ED3AAF0E
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 10:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFQItp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 04:49:45 -0400
Received: from mail-dm6nam12on2049.outbound.protection.outlook.com ([40.107.243.49]:47968
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230291AbhFQIto (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Jun 2021 04:49:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIdBtNFijnsw4l9K5Hud69IjhqII/xtDHYO5CG38kS4WIMBmqqUsdOFf9wjl1HZzeSA8RzRi8hUiel6g11sa2F+TALmJ2R/ynzrvDhivHFFRtho4eG8Uxh9Znfl7PrRmHVIYzt7NQkBv1HtaD5yqGPzSQSvXx2Ocj/JWL7flPyi66rCFG5Tl6E2bV1dBebu/2COBkHfacBcgYbIlODak3r5ho0LGcYOy3z3D+beJHv3shlHEzZhoofQZwbEvIkp1O2qpVpeVhjcYnBYcBdC79my32moqN/JvD0FASToRcRcYo9sTvoZbs60JzBGhi3uib1OnZzMcpfqym3I5Ut26eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHK4BQcBtaFK7soOqVnLA3XHtwvo8c2GfVzchZs8ACU=;
 b=j9dKKNFywB2htce+5Y5ly7cW4WKYdCvpi1Gx3w8mSTTEhY/VTXWqfXdn1AerdSYzq/lXAzD8sbGNrKtvwoaUacMPzgbE/NNo55Lkg/Dz0TuD2Dh7NXea65zg17yhAud1GhHJPxT5byzXliAfG4WAMMUcOERjh5qaCHj3739j4ScWOCqzLhxXTcz6XUDghf5htQ1D38seasgziPs/VkAoZaSiYxZ+yH1hXNeyKlYKH7uZKS4qUkoNV5Rhvaaqwfjw76bBJ9zCwo+p3HlgVtDxvL7S5e/R2BfglELh3TF1wuWUr8wPZNPLY07s97PMAh/2RT98VlZgvpTeasVNTD7fRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHK4BQcBtaFK7soOqVnLA3XHtwvo8c2GfVzchZs8ACU=;
 b=4WMrpl3wjzWtaohrC1njnMQNkk7LINQGNIzSpPIJCzqdYhXIWTeDHcxBRveV9Nni8yTAwhlOj9k1kzIekMKujM1RWgpRJkGWYPrXRPGsT9MU6w3ykgFOsA9TCKxMKtqs+fZqH9PTesrYI67wd8IhmKWc+5g//Q/QpP33wSMcexY=
Received: from CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18)
 by CO6PR12MB5460.namprd12.prod.outlook.com (2603:10b6:5:357::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Thu, 17 Jun
 2021 08:47:36 +0000
Received: from CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::704a:9f7a:1c8d:db6]) by CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::704a:9f7a:1c8d:db6%4]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 08:47:36 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     "Wentland, Harry" <Harry.Wentland@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     "lyude@redhat.com" <lyude@redhat.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Pillai, Aurabindo" <Aurabindo.Pillai@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] drm/dp_mst: Do not set proposed vcpi directly
Thread-Topic: [PATCH v2 1/2] drm/dp_mst: Do not set proposed vcpi directly
Thread-Index: AQHXYmOAF5JP5WagLk2QJkfz39Il46sXDeaAgADVGno=
Date:   Thu, 17 Jun 2021 08:47:35 +0000
Message-ID: <CO6PR12MB548969C7674DD593B0497A31FC0E9@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20210616035501.3776-1-Wayne.Lin@amd.com>
 <20210616035501.3776-2-Wayne.Lin@amd.com>,<b9eeec7d-c080-3c7f-706b-ce11c8533d16@amd.com>
In-Reply-To: <b9eeec7d-c080-3c7f-706b-ce11c8533d16@amd.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Enabled=True;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SetDate=2021-06-17T08:47:06.393Z;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Name=AMD-Official
 Use
 Only;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ContentBits=0;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Method=Standard;
authentication-results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [165.204.84.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6da72fe-dbea-4a29-6c60-08d9316c8e2d
x-ms-traffictypediagnostic: CO6PR12MB5460:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR12MB5460C930E10E2AA00FE1E920FC0E9@CO6PR12MB5460.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:46;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m5313y4ymU01WsIv7ngW7ODuFahMTpUdXpEZLCNP8z3j/SkfFY5KjGbOBXnJgtcafKzOlrTago+psnaVifXDCS4+gv1My9P+pYI/J/xE1SEDrMnFDxeo3SxGN9bjKo+McF4MS7rpfmJaFcGInpxGOq0b9O057yz9jrp9JXB0yGpvKuW5k9PThBI3tpgkwd9RdClrtpftLN+w13rMGFyFwAMdoETFkjx6cyhdAmdR98CCvuJTGCskaVwnFizvU9X0ReOODmj5GpZxTzpjxcM2L4C3ZN96f6Y3lCXC+hgHukmidw3PdN/QzoUKFTPquyb9LHAVxjUOTEu1SF83t4WB5HY1T+HtKY2NYNFC13qPClRAPjM+hW60P8kH2vCrJVD2NfvMWdrYOcnFswGoMARODF9pF89zmcV7s+r7P6ZscpYIc8EKMKHK+3pyXwqHvko3i0KDym0xLpEV4v9RZIZkBYvbR8CUxFfs74u/XtQYKlKqu+LilRf3xZFocxoHcoqoIA++8LtZEfuIpYl5Y96AdFv7rj/3KXfjLBaIDwQoNzzV1+3RJehOtWcHMwMafjN+/wxp4ZPzIoU0zMI3IzmHoqLHh53u27jMFCl0arHhBv0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(8936002)(54906003)(5660300002)(52536014)(8676002)(316002)(9686003)(110136005)(83380400001)(55016002)(2906002)(91956017)(76116006)(66946007)(7696005)(66476007)(66446008)(4326008)(6506007)(478600001)(26005)(66556008)(64756008)(53546011)(86362001)(38100700002)(122000001)(33656002)(71200400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?EzrVZO7iEVG2oQhzjfVqWuykR5IYpKBwUGvkNjGkNUZzgdopvK/ZxOpxNy?=
 =?iso-8859-1?Q?GiFusY2P0+Q+qAxRI1517/5Z3tziHm+kZOgNtED+shnoXg42i4cVxOr4XZ?=
 =?iso-8859-1?Q?L+aPLowWDobsk/XkH3CU6/P+09CuYNvbuwar6pNlc/O4R0VQzVOoi0wJUz?=
 =?iso-8859-1?Q?zdR+fR5mOEbofMeWR3XHhSSm0RiFdQoqaBKOv9xoz/14vduC1legKOhic6?=
 =?iso-8859-1?Q?6cKlfGwY2fehhoD2ozQXsda2xOs+upgSDv+6ZSVfq1AlTyUOD0htgCHijs?=
 =?iso-8859-1?Q?6B/zmHxne4Kxp4XAgS1F6FOuk1muxaH0ai+3ZzLKvQ4/7xf8XuAxZs+hC/?=
 =?iso-8859-1?Q?ioAAMinQ/NpVxSFzYhL/wdr5SjICTlcXM3IcLv3ZXr3JmQLANRQIR6d/0b?=
 =?iso-8859-1?Q?7gROvxzdTk2qNafkIjuZP3krovSoPABvZKWf/See2bNynljnxCo3iDUcNp?=
 =?iso-8859-1?Q?XH/BFIKeI53UxNsdal4by2j4Dyk+diHTfE4E/r9iaMDbVHymDrNqrSHO7m?=
 =?iso-8859-1?Q?SO9HOdUj/H0y9LV7wVoGHhe3Ds7L3maqegibRmq88K1/I3tLt7FQ4syXp+?=
 =?iso-8859-1?Q?GBaNX+Euisj4ie/4Hp0YSPD28fZpnzNy96g+/KeFaSbRB4ByH945j1b6Tv?=
 =?iso-8859-1?Q?Ni7IZOeX3CJNKeJULaxfDT3d9HkzH8H7n2IhM4amcDDa7qesmEHPSLGKSE?=
 =?iso-8859-1?Q?2QFforUtrzi/nrL+oBiOFOPvirxJJCiVF1QqiO43LPSNpB604D8GcTZ72N?=
 =?iso-8859-1?Q?tM3EmrtI4PhQ/QmhMnNN+dNNvBrlqM21/t0RrdWwGZTvRos8P1E7sxi5Oy?=
 =?iso-8859-1?Q?5QwnVslGwxgh1yFc4OyghTVrqAA9jU68nuhT/gDvBQr3WhacpU/HgAfDwG?=
 =?iso-8859-1?Q?y2YvTu4bRD/e3FzDMJNmhe1N/yowJ0Mudq5bdXTFZA6jRKGFIfMzf95CFG?=
 =?iso-8859-1?Q?Ya495wIsCUjS7SmpLrAiEWQ2pG4ThnMLi4JP6eFD6ZiIfuPogg15xYD7DY?=
 =?iso-8859-1?Q?kx4lG3A3yfICbAyI1FaEpuBCmKvU6LL93uiiBQpebTxGS5kZOy+iHOqM6q?=
 =?iso-8859-1?Q?VUX09LVEuMXGO1i0Pa/pnAZRei2gVorG+yv1CPatK40QRAccu+Kehy8OXD?=
 =?iso-8859-1?Q?iJYpOcPB/YpGxPVnWMba15uA8qIWjW2b8o170/b8i97xqz9UfRg5dsx4Gc?=
 =?iso-8859-1?Q?8RLXjd8fwnZod+qcPZbZs2WQ1OpwVazik6NjThnPiqe6zmkIAvlJ+G3Xk0?=
 =?iso-8859-1?Q?lSQXAH5hookrn8AEl/unL6FJ2gLnfaKzFeSnY8qDk+i/GYgBx/3LfjaEOj?=
 =?iso-8859-1?Q?HcS+n+etV7oEt6BDb/XhDhrPDCf2daxj87jKlcntzNRpbM8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6da72fe-dbea-4a29-6c60-08d9316c8e2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 08:47:35.8259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 26RhnUpeEoUwFD/uqMpMIl67t0pP8sfbbbym3Ug80P2iiNGx5qB/4J2LNf6/VDeoChpdY3nFVbeJ3bdNSw0p0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5460
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only]

________________________________________
> From: Wentland, Harry <Harry.Wentland@amd.com>
> Sent: Thursday, June 17, 2021 03:53
> To: Lin, Wayne; dri-devel@lists.freedesktop.org
> Cc: lyude@redhat.com; Kazlauskas, Nicholas; Zuo, Jerry; Pillai, Aurabindo=
; Maarten Lankhorst; Maxime Ripard; Thomas Zimmermann; stable@vger.kernel.o=
rg
> Subject: Re: [PATCH v2 1/2] drm/dp_mst: Do not set proposed vcpi directly
>
>
>
> On 2021-06-15 11:55 p.m., Wayne Lin wrote:
> > [Why]
> > When we receive CSN message to notify one port is disconnected, we will
> > implicitly set its corresponding num_slots to 0. Later on, we will
> > eventually call drm_dp_update_payload_part1() to arrange down streams.
> >
> > In drm_dp_update_payload_part1(), we iterate over all proposed_vcpis[]
> > to do the update. Not specific to a target sink only. For example, if w=
e
> > light up 2 monitors, Monitor_A and Monitor_B, and then we unplug
> > Monitor_B. Later on, when we call drm_dp_update_payload_part1() to try
> > to update payload for Monitor_A, we'll also implicitly clean payload fo=
r
> > Monitor_B at the same time. And finally, when we try to call
> > drm_dp_update_payload_part1() to clean payload for Monitor_B, we will d=
o
> > nothing at this time since payload for Monitor_B has been cleaned up
> > previously.
> >
> > For StarTech 1to3 DP hub, it seems like if we didn't update DPCD payloa=
d
> > ID table then polling for "ACT Handled"(BIT_1 of DPCD 002C0h) will fail
> > and this polling will last for 3 seconds.
> >
> > Therefore, guess the best way is we don't set the proposed_vcpi[]
> > diretly. Let user of these herlper functions to set the proposed_vcpi
> > directly.
> >
> > [How]
> > 1. Revert commit 7617e9621bf2 ("drm/dp_mst: clear time slots for ports
> > invalid")
> > 2. Tackle the issue in previous commit by skipping those trasient
> > proposed VCPIs. These stale VCPIs shoulde be explicitly cleared by
> > user later on.
> >
> > Changes since v1:
> > * Change debug macro to use drm_dbg_kms() instead
> > * Amend the commit message to add Fixed & Cc tags
> >
> > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > Fixes: 7617e9621bf2 ("drm/dp_mst: clear time slots for ports invalid")
> > Cc: Lyude Paul <lyude@redhat.com>
> > Cc: Wayne Lin <Wayne.Lin@amd.com>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Maxime Ripard <mripard@kernel.org>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: <stable@vger.kernel.org> # v5.5+
> > ---
> >  drivers/gpu/drm/drm_dp_mst_topology.c | 36 ++++++++-------------------
> >  1 file changed, 10 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/dr=
m_dp_mst_topology.c
> > index 32b7f8983b94..b41b837db66d 100644
> > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > @@ -2501,7 +2501,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_bra=
nch *mstb,
> >  {
> >       struct drm_dp_mst_topology_mgr *mgr =3D mstb->mgr;
> >       struct drm_dp_mst_port *port;
> > -     int old_ddps, old_input, ret, i;
> > +     int old_ddps, ret;
> >       u8 new_pdt;
> >       bool new_mcs;
> >       bool dowork =3D false, create_connector =3D false;
> > @@ -2533,7 +2533,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_bra=
nch *mstb,
> >       }
> >
> >       old_ddps =3D port->ddps;
> > -     old_input =3D port->input;
> >       port->input =3D conn_stat->input_port;
> >       port->ldps =3D conn_stat->legacy_device_plug_status;
> >       port->ddps =3D conn_stat->displayport_device_plug_status;
> > @@ -2555,28 +2554,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_br=
anch *mstb,
> >               dowork =3D false;
> >       }
> >
> > -     if (!old_input && old_ddps !=3D port->ddps && !port->ddps) {
> > -             for (i =3D 0; i < mgr->max_payloads; i++) {
> > -                     struct drm_dp_vcpi *vcpi =3D mgr->proposed_vcpis[=
i];
> > -                     struct drm_dp_mst_port *port_validated;
> > -
> > -                     if (!vcpi)
> > -                             continue;
> > -
> > -                     port_validated =3D
> > -                             container_of(vcpi, struct drm_dp_mst_port=
, vcpi);
> > -                     port_validated =3D
> > -                             drm_dp_mst_topology_get_port_validated(mg=
r, port_validated);
> > -                     if (!port_validated) {
> > -                             mutex_lock(&mgr->payload_lock);
> > -                             vcpi->num_slots =3D 0;
> > -                             mutex_unlock(&mgr->payload_lock);
> > -                     } else {
> > -                             drm_dp_mst_topology_put_port(port_validat=
ed);
> > -                     }
> > -             }
> > -     }
> > -
> >       if (port->connector)
> >               drm_modeset_unlock(&mgr->base.lock);
> >       else if (create_connector)
> > @@ -3410,8 +3387,15 @@ int drm_dp_update_payload_part1(struct drm_dp_ms=
t_topology_mgr *mgr)
> >                               port =3D drm_dp_mst_topology_get_port_val=
idated(
> >                                   mgr, port);
> >                               if (!port) {
> > -                                     mutex_unlock(&mgr->payload_lock);
> > -                                     return -EINVAL;
> > +                                     if (vcpi->num_slots =3D=3D payloa=
d->num_slots) {
> > +                                             cur_slots +=3D vcpi->num_=
slots;
> > +                                             payload->start_slot =3D r=
eq_payload.start_slot;
> > +                                             continue;
> > +                                     } else {
> > +                                             drm_dbg_kms("Fail:set pay=
load to invalid sink");
>
> drm_dbg_kms takes a drm_device as first parameter.
>
> Harry

Thanks Harry. Should be addressed by another patch provided by Jos=E9.
>
> > +                                             mutex_unlock(&mgr->payloa=
d_lock);
> > +                                             return -EINVAL;
> > +                                     }
> >                               }
> >                               put_port =3D true;
> >                       }
> >
--
Regards,
Wayne
