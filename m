Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940CE127303
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 02:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfLTBqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 20:46:12 -0500
Received: from mail-dm6nam12on2081.outbound.protection.outlook.com ([40.107.243.81]:6100
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727084AbfLTBqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 20:46:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDOyyftvJIeYc5UPdEUwUJ4E2fk/DSXeN8eFq/BLBbHuUNxNtpaSrcu0thJhApc+7soC6elB1V7Cog4cbYKhDBUyya4NTfP/UV99EwxGnX2p9QbNLgF0Axa/EvE250+mavhnCsnALy83pG+dHaDmQ5wmx1yaU0UzgBC1do7QbE70I4TdIs3EUv+LZRXK7355nO5TUkPoJfQ+yo7ez4z0nUszg29HzAHEFh/HchiDnDac0QoBSAWzNNLcMObGeOn4/gmCGEw49yGzjbuqrA/cX4nCHtDVuB/NLVnJpwbxrM9qwGO6RULzA0lzrplHeEn4R5wtTeLxAKg/KmKfsoThvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/MWmToYgSSjyFei51TmaJlpsexahcfV5TyeBrOTRMk=;
 b=eHKwMKPhkZYZR3KA3QFK3WLYH3FqOFn/UpvMqGAgvaNQ7vNS1V3fy/8JC4aRbX68sYvSYMeqbENXpI0VjGZxeE8TVElvJ382x4pu6p2R9cdSi9GEc0yYcsaIgtTVMpM9MpHD6+7LvRzTNfZFabKhHmpAqAKduMocyqZ4IXp5YUwN3bHrwxftPwmRFL0vDD2opT3a/OW7xngooUwNMuLyvHWvl2iWBIB6bX0QgalMwjVC1V3g6yBrHvv6vwZ6a0zse3QPL76xt9vtVeilGslfetdQsiBCvVI1GNa4XjVvH+5An3qgFx/Dv5WqbK4/VcseJvVCoV0yEjuqGe6DVXw++A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/MWmToYgSSjyFei51TmaJlpsexahcfV5TyeBrOTRMk=;
 b=cQGjL+aN+9VZQjFBIaeFdQBSwQ4EJtsr1o5O+d0dH5U33tyAEGMYCLccoa6MQxcJZUxynODV7n/JCbiaOvFV8/2iyTgXAZy2e2sgeuj74D6xd8oF3fbmqMitvbfSzqS4gHiPP7oHImFzcmLJTBVVI0LJGM/Wl+A6naa9gTWFV2M=
Received: from DM6PR12MB4137.namprd12.prod.outlook.com (10.141.186.21) by
 DM6PR12MB3418.namprd12.prod.outlook.com (20.178.29.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Fri, 20 Dec 2019 01:46:08 +0000
Received: from DM6PR12MB4137.namprd12.prod.outlook.com
 ([fe80::f06d:7ff3:2a22:99d4]) by DM6PR12MB4137.namprd12.prod.outlook.com
 ([fe80::f06d:7ff3:2a22:99d4%3]) with mapi id 15.20.2559.012; Fri, 20 Dec 2019
 01:46:08 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "lyude@redhat.com" <lyude@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/dp_mst: clear time slots for ports invalid
Thread-Topic: [PATCH] drm/dp_mst: clear time slots for ports invalid
Thread-Index: AQHVrBDEG2oqjDxKoU2lob1fSRqxeKfCVXUY
Date:   Fri, 20 Dec 2019 01:46:08 +0000
Message-ID: <DM6PR12MB41379C431DBB59A0C0A4C910FC2D0@DM6PR12MB4137.namprd12.prod.outlook.com>
References: <20191206083937.9411-1-Wayne.Lin@amd.com>
In-Reply-To: <20191206083937.9411-1-Wayne.Lin@amd.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Enabled=True;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SetDate=2019-12-20T01:45:41.773Z;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Name=Internal
 Distribution
 Only;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_ContentBits=0;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Method=Standard;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wayne.Lin@amd.com; 
x-originating-ip: [165.204.68.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 434c4e88-b925-47a3-a35a-08d784ee626c
x-ms-traffictypediagnostic: DM6PR12MB3418:|DM6PR12MB3418:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB341889554B825F19A26807B8FC2D0@DM6PR12MB3418.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(199004)(189003)(7696005)(4326008)(52536014)(8676002)(6506007)(81156014)(53546011)(186003)(81166006)(54906003)(71200400001)(91956017)(110136005)(55016002)(9686003)(66476007)(66446008)(64756008)(26005)(8936002)(2906002)(66556008)(478600001)(86362001)(66946007)(76116006)(316002)(5660300002)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3418;H:DM6PR12MB4137.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C7QZn1ZvwubS9j+KHmERqxJ6KmgaqiJ2JcHRn6g70l5jEZHBySUuPslsmoo9BXv2B8xpfh/5cYp4o9QsQe3eBSYgsnz9jrLRy6pVBnp9HMd2WQoeDdO4/8GiduEL0p+fDoWH02ys236IkTDrOgEDt6Skf+0sHbw1YB2p7rz7XSYjn45XSd/r8IcuWOzsagjFMaamC6v/IQmFHQk1zz6PcmDOg8Qsk4IsgZlDqcGcu104EoEpzLbKheD1f+V0ux76pbT5AsLvJmo+arn+KALcsYlM0Vf+p2bQ4JuTq5tibxbRXov1JU5/qGtgvjVw6aLs5oHJdACE74+YMIi1uC8b116bOcGI2QbARVEwn3mIhiw3AGvNiTnu4HG5vi9CUjHFWFF/0laGmgAwCjFTaj1Et8sHjDbDPczNGefDNCfcKisCpm4DOWybSYBaD6I7LnZV
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 434c4e88-b925-47a3-a35a-08d784ee626c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 01:46:08.3289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IpezV0q50xKtcNDYekco1dqvFuszG/6eLQTkuQkxSQry6vE5fwrDUY97LPE+9vQuVQrTgMBHR5WCz/SHwTjZxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3418
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only - Internal Distribution Only]

Pinged.
Hi, can someone help to review please.

Thanks a lot.

Regards,
Wayne

________________________________________
From: Wayne Lin <Wayne.Lin@amd.com>
Sent: Friday, December 6, 2019 16:39
To: dri-devel@lists.freedesktop.org; amd-gfx@lists.freedesktop.org
Cc: Kazlauskas, Nicholas; Wentland, Harry; Zuo, Jerry; lyude@redhat.com; st=
able@vger.kernel.org; Lin, Wayne
Subject: [PATCH] drm/dp_mst: clear time slots for ports invalid

[Why]
When change the connection status in a MST topology, mst device
which detect the event will send out CONNECTION_STATUS_NOTIFY messgae.

e.g. src-mst-mst-sst =3D> src-mst (unplug) mst-sst

Currently, under the above case of unplugging device, ports which have
been allocated payloads and are no longer in the topology still occupy
time slots and recorded in proposed_vcpi[] of topology manager.

If we don't clean up the proposed_vcpi[], when code flow goes to try to
update payload table by calling drm_dp_update_payload_part1(), we will
fail at checking port validation due to there are ports with proposed
time slots but no longer in the mst topology. As the result of that, we
will also stop updating the DPCD payload table of down stream port.

[How]
While handling the CONNECTION_STATUS_NOTIFY message, add a detection to
see if the event indicates that a device is unplugged to an output port.
If the detection is true, then iterrate over all proposed_vcpi[] to
see whether a port of the proposed_vcpi[] is still in the topology or
not. If the port is invalid, set its num_slots to 0.

Thereafter, when try to update payload table by calling
drm_dp_update_payload_part1(), we can successfully update the DPCD
payload table of down stream port and clear the proposed_vcpi[] to NULL.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp=
_mst_topology.c
index 5306c47dc820..2e236b6275c4 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2318,7 +2318,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch =
*mstb,
 {
        struct drm_dp_mst_topology_mgr *mgr =3D mstb->mgr;
        struct drm_dp_mst_port *port;
-       int old_ddps, ret;
+       int old_ddps, old_input, ret, i;
        u8 new_pdt;
        bool dowork =3D false, create_connector =3D false;

@@ -2349,6 +2349,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch =
*mstb,
        }

        old_ddps =3D port->ddps;
+       old_input =3D port->input;
        port->input =3D conn_stat->input_port;
        port->mcs =3D conn_stat->message_capability_status;
        port->ldps =3D conn_stat->legacy_device_plug_status;
@@ -2373,6 +2374,27 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch=
 *mstb,
                dowork =3D false;
        }

+       if (!old_input && old_ddps !=3D port->ddps && !port->ddps) {
+               for (i =3D 0; i < mgr->max_payloads; i++) {
+                       struct drm_dp_vcpi *vcpi =3D mgr->proposed_vcpis[i]=
;
+                       struct drm_dp_mst_port *port_validated;
+
+                       if (vcpi) {
+                               port_validated =3D
+                                       container_of(vcpi, struct drm_dp_ms=
t_port, vcpi);
+                               port_validated =3D
+                                       drm_dp_mst_topology_get_port_valida=
ted(mgr, port_validated);
+                               if (!port_validated) {
+                                       mutex_lock(&mgr->payload_lock);
+                                       vcpi->num_slots =3D 0;
+                                       mutex_unlock(&mgr->payload_lock);
+                               } else {
+                                       drm_dp_mst_topology_put_port(port_v=
alidated);
+                               }
+                       }
+               }
+       }
+
        if (port->connector)
                drm_modeset_unlock(&mgr->base.lock);
        else if (create_connector)
--
2.17.1

