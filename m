Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249E13CA12A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 17:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbhGOPKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 11:10:15 -0400
Received: from mail-mw2nam10on2059.outbound.protection.outlook.com ([40.107.94.59]:44512
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231771AbhGOPKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 11:10:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvZeuXgZuOeMwn2jAdhUl8/GC14D35ufApn4sFgYCoIjo3o2ksViHqzO81p4DAKoGrbUpNcevE2zF0kiiFguOLaakdInDeXGPL+gLc0xzPyHPVxT0cCvr8sbA6jlIaE7MWbwC5VzsVyI/d9TSS04ceuFUBgvWinJm59dkyp1isaqFufMBGrBJBkkfZX/F4Pdk5uX2MhvaFyyg2VBXRWYs7/an9qRlHAxVGD/YFTgWsrFhNahNWmy75cfuxVwipZ7mBRTgFrvle0XWU5mH2dwd8x7/Fo7tt4FqV0xHKcGfdQ4sWU2BwMriMOOiRnNVkUhzFFkOF8FQuux3sUbi2NjYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5vcPtaTq9tuEAEim+hlJ+42IrTLvRjH6B4PtXJ9Gno=;
 b=oeXw4D8OIl0HxYgjKS+tPkL2wHwqjCry4Wz/9Q83fgmgl+hD8Pd0NAYkzCgUwyPPRIiIGw0k0v7hqeG/DPloHJg4xIZSsqd1y5hmSPh5ag0JGN3t+B9IyapGDKIS3hWHig4hwjfeKnqCUCBae1r4KA5O4GuXt3nmLq02A0N1xiu4tzq6P+QcKa9slLDA6h9DW0o0leVGMc4snPmd96YJXBoH5dqRHWGGeptPTDbMCPK6Vnk3YAd9lQszUG5oxJkiyESMb6QUHnfuSF17o+3aFA6rOG9Hg9ZQhEAnezCRkdYD74JrqErRKWb8Zv4a2cYkDaajmqtMJt8uA/SNqQdVjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5vcPtaTq9tuEAEim+hlJ+42IrTLvRjH6B4PtXJ9Gno=;
 b=gwUPIqqLCKoxCSHOpmzI0wf+CuG6sarmLm2DoyzT+p7MVLA9IEx5C/dQzXObQeriEIsZNAQpzd111bg5hOnt1LZlGnkRNgqwtgLkoAQ/pxdY3BQIEu0kyJfQzprZLekiIwBNw7JvYI4DsZPFlv7nndFK8M8MUOfZYgSmeiOmjVU=
Received: from CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18)
 by CO6PR12MB5441.namprd12.prod.outlook.com (2603:10b6:303:13b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Thu, 15 Jul
 2021 15:07:20 +0000
Received: from CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::f423:a6b:5d85:fd8c]) by CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::f423:a6b:5d85:fd8c%5]) with mapi id 15.20.4331.022; Thu, 15 Jul 2021
 15:07:20 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lyude@redhat.com" <lyude@redhat.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] drm/dp_mst: Avoid to mess up payload table
 by ports in stale" failed to apply to 5.13-stable tree
Thread-Topic: FAILED: patch "[PATCH] drm/dp_mst: Avoid to mess up payload
 table by ports in stale" failed to apply to 5.13-stable tree
Thread-Index: AQHXeXVT5axIYUNa2UKt4ZoTYri3gqtEHksQ
Date:   Thu, 15 Jul 2021 15:07:19 +0000
Message-ID: <CO6PR12MB548978A31FF543E2333447FFFC129@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <1626351420140215@kroah.com>
In-Reply-To: <1626351420140215@kroah.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ActionId=63a3fd5a-ac59-401e-8298-3262380750e0;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ContentBits=0;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Enabled=true;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Method=Standard;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Name=AMD
 Official Use Only-AIP
 2.0;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SetDate=2021-07-15T14:49:25Z;MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ef20ac8-ae20-4c49-d1c1-08d947a23dfe
x-ms-traffictypediagnostic: CO6PR12MB5441:
x-microsoft-antispam-prvs: <CO6PR12MB5441BF15E4E5FDAA40362723FC129@CO6PR12MB5441.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VFqAlaUAgu/E/r2xkPt022eKWP/hpQdtPRXYcAeLFSPO6irJBDtPPqsATyIBMd+KEuN5O3e8Jz+fIIoAS3rUgB3AlhDxgqz7w0eHzLabmQ9CMrzCke2TOUH7o4q5Xhp2PNPIsT9hkhgVAJ9+6f9VVY86Z4pO/yjRHd2WTl9PZlv04vi3FvK11u+oGY9v4Ch9ZIgFuy1/dOuyYjGbM/eM5rXYbPdEJ4ts+FOFur5gniSPLNrL08niK/26tVDJJ73/qtGZO5sLVnd0rotRy9bE7HU199AynToWRNdNCna1iSYsZd0rRJWTFBrFm8KJOizSFM8JSzBGIWzO/BQOVsQfNhjMSAls0i/x/sU7L/Yb5oow3hTX3rRRpUx7FzRm7fmiUP3vxLP3LiJqINCZescoEcBni9Ey8htMWvgNcaHnBKn8WhPSv9hoyqxNLr1Xr+ZiUCoIbYFknvQzMpHi9miYrfEUhiUph0kGar2N66w9mjeq7xOhd6NbBQcRgeVSMj7X3IhjwMnLgkbvavG5+rXC8eEBbk0PulPbG1S0WhezxW3flOrvCf7WU1Pq4kD4cGn8AIOblwn1smVP/i2f/FTLwZt/qQMEWNxKK3ImWjaGM4YpKgUOD3PUqrXzAF9O9OFzFIuFzJNNEkkifl9g66usjnIe7Yfx0nafwdayJcSvLuakb/FpKszRM0ejJgX4rgCZZ/0XrzFl/cvrCBjo34/dMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(110136005)(71200400001)(7696005)(316002)(53546011)(26005)(122000001)(5660300002)(38100700002)(2906002)(186003)(66446008)(66556008)(66476007)(66946007)(8936002)(8676002)(64756008)(6506007)(4326008)(52536014)(83380400001)(76116006)(9686003)(966005)(45080400002)(33656002)(55016002)(478600001)(86362001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i6muyLWmOAqxKDGj2xI/e05sHpBcnZrVQzu23SuXaJuJbbqx/jBbmb3k6gP+?=
 =?us-ascii?Q?By5psmGekS87wuA+lzCD5LxiaV+eCcvPBhN+qQLoADCdLT2cf0r0yHTocCaR?=
 =?us-ascii?Q?vSG+vKWxbT/VVlkvPtzI1Mc3J3ogF/ENBah4ZEYIZgPB88hPg9LJMhMexs4w?=
 =?us-ascii?Q?ke7py3c/99vAmtaNxBduHeJYDHH/AclqCcnezCm18P1VdS7mWNWdNHL1bCvZ?=
 =?us-ascii?Q?axEyWbx1MXDkjd9EkHTpIn1lYvoebiAZoZKIIAQFQJYaGFpmcYgG1BH4U31U?=
 =?us-ascii?Q?xalj8df1I8BtmoyzjRPaPiz9jI8FK60fnFus1hK3ymX+fyPZ/9lBQBTmFkNB?=
 =?us-ascii?Q?i5LraoE1cQ6v+IPOWwi+ShkOsnWA1gC2J752jj48B9sxCkMw3q6aAu4Qt7pn?=
 =?us-ascii?Q?adq6rSWLY38wzuoEP76jOz9f84Ke7haksL9rjJ9ekh4FawKwYsmC0VfAq9aI?=
 =?us-ascii?Q?65tYZACE0DIqyGbbUo3TGxA8Ue3T1BTsuALcDij0FFmsFnUriYX0EnRB70JV?=
 =?us-ascii?Q?p9S9bSQwXWHrRQiRBroIy3PmNsJZkelCFzEi7GpuW3upuC3qoUEPswUauBix?=
 =?us-ascii?Q?P961iJ94cHc3VE8DLwuaGJevx0KDHu6koXMFSAl2K7HBYPRiyqt0wfrRzwCh?=
 =?us-ascii?Q?+6d2FiXD642PM8EUQ/2VgDtAyO5+Qi1MHmIYg8nD4pvK2+ksxwcdDaqFJbex?=
 =?us-ascii?Q?gCy2vNZMsrZ15NcHl9tY2ZfRIn5V0AK98Kn04G1+RrQmH4VWIWAXvFu76pe1?=
 =?us-ascii?Q?jNuoqz+zDGKpH0RINiK5kwO33LEVBssBS4V+I7YbDVpHhPUIz3TUp6r0P+r6?=
 =?us-ascii?Q?XfJBlL8NL0Q/G1bkoKevSrhp5r/sM6V94UVZoFy57uxxi7n13lmkvGc0yLOv?=
 =?us-ascii?Q?SMAiLWRJKjFT/C4Hi2HpQa/074pxnsS73Z9mmubuw8u78S8Jm0tGSTD4UvOJ?=
 =?us-ascii?Q?JX0NTabZ6UnOCnacPANbaAoEvdBDRLVu4LCUOWFWT9pbgfynfYbQ/vF4tSsT?=
 =?us-ascii?Q?uC7i8hV8TiwOzZ8Wn8cVpWXrkUQKYeBfBxq9nN4N5N6SJtwei0lJLycgfCQt?=
 =?us-ascii?Q?iVztuQN8DyHea4lZQQAUacuFfAz38HepFbZWCvn6GVI6Oiqax2qKPzSbscUo?=
 =?us-ascii?Q?stjmEauPntj9Y0n+Vo2IKEy/WvhrukAvHKNWH8L5m5W1qffmldR3sz/161DX?=
 =?us-ascii?Q?9w3RI/NqD2WttRfsDFftnsuRZOWfLwhTvZZKwgI2QjjdgH4NFtFCRmBT/qHW?=
 =?us-ascii?Q?nqgf0BW0j2H2drdMxqgIUUylbqmsuEdNelVpSWPlws5wHakun7ca9G7MLL7U?=
 =?us-ascii?Q?FwIoCuGg1NP6EbPinSW5zD+3?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef20ac8-ae20-4c49-d1c1-08d947a23dfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 15:07:19.7729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pLb1kLBZedzj1z+8HoESc0ijA34uh7CCIteJhrgKGSn+V4j/GtvJIaHxHfvSDsiqGaleV3p/+KGUc9LzJ3NoAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5441
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only]

Hi Greg,

Really thanks for your time. About failing to apply below patches to stable=
 tree:
3769e4c0af5b82c8ea21d037013cb9564dfaa51f
[PATCH] drm/dp_mst: Avoid to mess up payload table by ports in stale topolo=
gy

35d3e8cb35e75450f87f87e3d314e2d418b6954b
 [PATCH] drm/dp_mst: Do not set proposed vcpi directly

There was an immediate following patch to correct the issue caused by above=
 patches:
24ff3dc18b99c4b912ab1746e803ddb3be5ced4c
[PATCH] drm/dp_mst: Add missing drm parameters to recently added call to dr=
m_dbg_kms()

In other words, these three patches should be committed at the same time. S=
orry for any inconvenience it brought.
Please advise me if there is anything else to do for having these patches a=
pplied to stable tree.
Really thanks for your help.

Regards,
Wayne

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Thursday, July 15, 2021 8:17 PM
> To: Lin, Wayne <Wayne.Lin@amd.com>; lyude@redhat.com
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] drm/dp_mst: Avoid to mess up payload tabl=
e by ports in stale" failed to apply to 5.13-stable tree
>
>
> The patch below does not apply to the 5.13-stable tree.
> If someone wants it applied there, or to any other stable or longterm tre=
e, then please email the backport, including the original git
> commit id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 3769e4c0af5b82c8ea21d037013cb9564dfaa51f Mon Sep 17 00:00:00 2001
> From: Wayne Lin <Wayne.Lin@amd.com>
> Date: Wed, 16 Jun 2021 11:55:01 +0800
> Subject: [PATCH] drm/dp_mst: Avoid to mess up payload table by ports in s=
tale  topology
>
> [Why]
> After unplug/hotplug hub from the system, userspace might start to clear =
stale payloads gradually. If we call
> drm_dp_mst_deallocate_vcpi() to release stale VCPI of those ports which a=
re not relating to current topology, we have chane to
> wrongly clear active payload table entry for current topology.
>
> E.g.
> We have allocated VCPI 1 in current payload table and we call
> drm_dp_mst_deallocate_vcpi() to clean VCPI 1 in stale topology. In drm_dp=
_mst_deallocate_vcpi(), it will call
> drm_dp_mst_put_payload_id() tp put VCPI 1 and which means ID 1 is availab=
le again. Thereafter, if we want to allocate a new payload
> stream, it will find ID 1 is available by drm_dp_mst_assign_payload_id().=
 However, ID 1 is being used
>
> [How]
> Check target sink is relating to current topology or not before doing any=
 payload table update.
> Searching upward to find the target sink's relevant root branch device.
> If the found root branch device is not the same root of current topology,=
 don't update payload table.
>
> Changes since v1:
> * Change debug macro to use drm_dbg_kms() instead
> * Amend the commit message to add Cc tag.
>
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Link:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatch=
work.freedesktop.org%2Fpatch%2Fmsgid%2F20210616
> 035501.3776-3-
> Wayne.Lin%40amd.com&amp;data=3D04%7C01%7CWayne.Lin%40amd.com%7C231171835e=
1e4d40019a08d9478c7553%7C3dd8961fe488
> 4e608e11a82d994e183d%7C0%7C0%7C637619490858271159%7CUnknown%7CTWFpbGZsb3d=
8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luM
> zIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3Dry%2FBe6oKXqA51GAiVY=
Ssl4RqIoGZ%2BT9%2FsVbqMD1OlXc%3D&amp;r
> eserved=3D0
> Reviewed-by: Lyude Paul <lyude@redhat.com>
>
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_=
dp_mst_topology.c
> index b41b837db66d..9ac148efd9e4 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -94,6 +94,9 @@ static int drm_dp_mst_register_i2c_bus(struct drm_dp_ms=
t_port *port);  static void
> drm_dp_mst_unregister_i2c_bus(struct drm_dp_mst_port *port);  static void=
 drm_dp_mst_kick_tx(struct
> drm_dp_mst_topology_mgr *mgr);
>
> +static bool drm_dp_mst_port_downstream_of_branch(struct drm_dp_mst_port =
*port,
> +                                              struct drm_dp_mst_branch *=
branch);
> +
>  #define DBG_PREFIX "[dp_mst]"
>
>  #define DP_STR(x) [DP_ ## x] =3D #x
> @@ -3366,6 +3369,7 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_t=
opology_mgr *mgr)
>       struct drm_dp_mst_port *port;
>       int i, j;
>       int cur_slots =3D 1;
> +     bool skip;
>
>       mutex_lock(&mgr->payload_lock);
>       for (i =3D 0; i < mgr->max_payloads; i++) { @@ -3380,6 +3384,14 @@ =
int drm_dp_update_payload_part1(struct
> drm_dp_mst_topology_mgr *mgr)
>                       port =3D container_of(vcpi, struct drm_dp_mst_port,
>                                           vcpi);
>
> +                     mutex_lock(&mgr->lock);
> +                     skip =3D !drm_dp_mst_port_downstream_of_branch(port=
, mgr->mst_primary);
> +                     mutex_unlock(&mgr->lock);
> +
> +                     if (skip) {
> +                             drm_dbg_kms("Virtual channel %d is not in c=
urrent topology\n", i);
> +                             continue;
> +                     }
>                       /* Validated ports don't matter if we're releasing
>                        * VCPI
>                        */
> @@ -3479,6 +3491,7 @@ int drm_dp_update_payload_part2(struct drm_dp_mst_t=
opology_mgr *mgr)
>       struct drm_dp_mst_port *port;
>       int i;
>       int ret =3D 0;
> +     bool skip;
>
>       mutex_lock(&mgr->payload_lock);
>       for (i =3D 0; i < mgr->max_payloads; i++) { @@ -3488,6 +3501,13 @@ =
int drm_dp_update_payload_part2(struct
> drm_dp_mst_topology_mgr *mgr)
>
>               port =3D container_of(mgr->proposed_vcpis[i], struct drm_dp=
_mst_port, vcpi);
>
> +             mutex_lock(&mgr->lock);
> +             skip =3D !drm_dp_mst_port_downstream_of_branch(port, mgr->m=
st_primary);
> +             mutex_unlock(&mgr->lock);
> +
> +             if (skip)
> +                     continue;
> +
>               drm_dbg_kms(mgr->dev, "payload %d %d\n", i, mgr->payloads[i=
].payload_state);
>               if (mgr->payloads[i].payload_state =3D=3D DP_PAYLOAD_LOCAL)=
 {
>                       ret =3D drm_dp_create_payload_step2(mgr, port, mgr-=
>proposed_vcpis[i]->vcpi, &mgr->payloads[i]); @@ -
> 4574,9 +4594,18 @@ EXPORT_SYMBOL(drm_dp_mst_reset_vcpi_slots);
>  void drm_dp_mst_deallocate_vcpi(struct drm_dp_mst_topology_mgr *mgr,
>                               struct drm_dp_mst_port *port)
>  {
> +     bool skip;
> +
>       if (!port->vcpi.vcpi)
>               return;
>
> +     mutex_lock(&mgr->lock);
> +     skip =3D !drm_dp_mst_port_downstream_of_branch(port, mgr->mst_prima=
ry);
> +     mutex_unlock(&mgr->lock);
> +
> +     if (skip)
> +             return;
> +
>       drm_dp_mst_put_payload_id(mgr, port->vcpi.vcpi);
>       port->vcpi.num_slots =3D 0;
>       port->vcpi.pbn =3D 0;

