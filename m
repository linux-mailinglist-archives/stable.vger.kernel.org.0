Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00284C5614
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 14:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbiBZNRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Feb 2022 08:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiBZNRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Feb 2022 08:17:48 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2100.outbound.protection.outlook.com [40.107.20.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF14E20F5B
        for <stable@vger.kernel.org>; Sat, 26 Feb 2022 05:17:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dM+r+FoTERw9OWX1+7Srs0G4J08PjUSQ9sYsXpTQ3Gc3nAJYfmySkVLLqk0gWbVu8ynaMgnf/xekbhk6xGMsG+uYSyhwX70wfmiZeyEuC977rFw1d7SHKJQP49jj09n5zixKH6VYweA6IeTP2dVPRZo2t6ktAOE3iYj+e7huAtmQuo83ihy1XeU+kOWrzMxJWO2b8RHcmENIrUHAUAX8iOzXHXrd06WLL8F12bilT5ox/Ik+1t5ycJIEMJC9DLspY76srFTYKCwpUvQg+etoSizJPrLvkGUE9sGC304AsDbwm3IcLd6zYvpZC1Gpc3rVJ1W9MLVBdWi/JLr6L4KyaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K95+yJRmSS0H3I3V1a6xhKdSPOR9FeB6eFglSlhahaY=;
 b=heKF7qx2EouWY6xVJ0KjRmYMuJ3Ch9xd8PCcMWbGpOtK0uY+9eASvb2ok8qu3Zd2QBgith7qntj76TNRBelHTPgeZgEfZJvctzJqJ2dFb3i7ruxotCFbdXhyrBkZlGve+dBq1fvptKUMwaoCLmGQ2ysmYrJ+Sufex1MFsXC2cZ+kbhwDOt+4CDNnUOMP/a9l5/tOFFdRuK7zRa3MGztRT68rfDOlxad/QEjVFDGMwuJzRXiqJ8seWZKYaxq4VPrfzUc8faPo5bL3VviyaHuLggBr2Jki1dfx0Bxh2myaLfMBuE9fuMXEdLjnG0qTamJ2ySSciPHmVgw+TauLDpxhQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=secomea.com; dmarc=pass action=none header.from=secomea.com;
 dkim=pass header.d=secomea.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secomea.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K95+yJRmSS0H3I3V1a6xhKdSPOR9FeB6eFglSlhahaY=;
 b=INnUCXblSRVY9vX/npLpK8jvqkK5AOsr/T/DTa5wYsMvQ9Ktf6rCSkUNhCPI6oKDJf2iM98q1NVIj01tdSeFIuGRZKXhwb8ns3GZ6qFGiVqutXbcCdkDKlu9dBA6cX+jCHzz1fL4fnTrPqM9K7fU3E+RuLARcPZgvgnYqhIgRB4=
Received: from DB7PR08MB3867.eurprd08.prod.outlook.com (2603:10a6:10:7f::13)
 by AM0PR08MB5043.eurprd08.prod.outlook.com (2603:10a6:208:166::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Sat, 26 Feb
 2022 13:17:11 +0000
Received: from DB7PR08MB3867.eurprd08.prod.outlook.com
 ([fe80::216e:9d9:ffd1:7af1]) by DB7PR08MB3867.eurprd08.prod.outlook.com
 ([fe80::216e:9d9:ffd1:7af1%2]) with mapi id 15.20.5017.026; Sat, 26 Feb 2022
 13:17:11 +0000
From:   =?iso-8859-1?Q?Svenning_S=F8rensen?= <sss@secomea.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Sv: FAILED: patch "[PATCH] net: dsa: microchip: fix bridging with
 more than two member" failed to apply to 5.16-stable tree
Thread-Topic: FAILED: patch "[PATCH] net: dsa: microchip: fix bridging with
 more than two member" failed to apply to 5.16-stable tree
Thread-Index: AQHYKmNbQhXOuQp3Q02tv5p+1+zni6yke7CkgAD3TYCAAFMS2YAACQoh
Date:   Sat, 26 Feb 2022 13:17:11 +0000
Message-ID: <DB7PR08MB38675030606F175301EDE48AB53F9@DB7PR08MB3867.eurprd08.prod.outlook.com>
References: <164580577118139@kroah.com>
 <AM0PR08MB38593B3E0E9B6A861479A7F4B53E9@AM0PR08MB3859.eurprd08.prod.outlook.com>
 <YhnZBVVezubGkecl@kroah.com>
 <DB7PR08MB3867F9A962DA7A3B13408C12B53F9@DB7PR08MB3867.eurprd08.prod.outlook.com>
In-Reply-To: <DB7PR08MB3867F9A962DA7A3B13408C12B53F9@DB7PR08MB3867.eurprd08.prod.outlook.com>
Accept-Language: da-DK, en-US
Content-Language: da-DK
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 7dde3e55-093c-b0a9-e2fa-1ed5c6607a05
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=secomea.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e064a8c-a6ad-40f2-a02b-08d9f92a4c2a
x-ms-traffictypediagnostic: AM0PR08MB5043:EE_
x-microsoft-antispam-prvs: <AM0PR08MB50430F7CAA119CB3873C53B1B53F9@AM0PR08MB5043.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pkyPz8qfWyJ2sfNfM7rRbrYZl6/1FLOF+Zs7hStj68uF5cDlmnq7JUwWKER5cXcM+yl9plflmmui+H2o+8kWNhuPuy0XEJCgNJf9jfzM4lwSZiA2Ng9MsJRIJTYWP8wEOAQdl+yN8DYYFD6wfudiV45jB6af5QT+SPDDFGdif7zQLP5pDuCSgWsRtkucvpZokF3ng9xrEEGI2W6Q7IkYteYfpEHWqqDTfdtf9/Nou3//XKlVm6GcEslls2mRhhgvo0iKHSo9yTAewZjOJLywJkSGdMuW6tdpamuevtVOfgPOl1v47NyXMzBLyiSlh1lvmvcxofci1oFLJKDi3/7sfMEFqkvEr1lRHtP0+dLXoHf7qp08B74j2WN6OTBk/2qGZiO3IvlS2XFikG1C+iJk4RSgr9+X+1GOSXc7ICZoMmWItheKoCZREDtSAGpvyhCLf1mW+NApXk/KmaeovjdJS9FTAo1LQQ1HjiqXRqnSARsykK/zFxLF3+N/tWXYucsx7hThZP982NlGH/85qcfOX7Z7V/e/0H6OKOw2BbdPRuKyF4p2C//M06jPqG25X6FuJDP2DSMYcJY5KyM/NVl9mahY/Zg8/yfWj2GBz9kmTFYD7NOWfjynBNma0Hy0iEr8mz8Ly2ItRxnsY2nF4ZG0N588/VuAzr+h5OJqKhShsyE6ah53gT1uHzxsduAIuMXC+NFPQSRn18RY6prIGtv1vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR08MB3867.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(39830400003)(136003)(346002)(366004)(376002)(396003)(55016003)(316002)(66574015)(186003)(508600001)(66446008)(66476007)(66946007)(2940100002)(83380400001)(76116006)(66556008)(52536014)(6506007)(91956017)(122000001)(110136005)(7696005)(8936002)(33656002)(71200400001)(26005)(64756008)(5660300002)(2906002)(86362001)(8676002)(4326008)(38100700002)(9686003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gDbQ5+RhT9y/wgCr/JeXgYu39oEQschQ52yn8k4rD48saH5ub7HUkIAtPs?=
 =?iso-8859-1?Q?+K9eXog2IJAXIr0XNx05sa6D3XBaeZqF8LhTjRgmSoJuoF2l4QhMiyqoi8?=
 =?iso-8859-1?Q?Ybbs9ayL+HExtAwe4fRZl62n5bdNqNqJZwPFYZ/g16Zzt4x4d7oCF87tyV?=
 =?iso-8859-1?Q?9HlWCB9iXwsHKYZncjWV3Yjl7eIzuxrJ0cRv6Idu/Ur0Fk/xKKU38RzGXB?=
 =?iso-8859-1?Q?8Zubt89U/v93KXIZtee5jk/SFjbbvjF/gt2VdytIyl7RHPt4L6i0o+rZ0G?=
 =?iso-8859-1?Q?13FR7W2Fb8aAw5BU4sNYSEa/336VefYCge+EhI9bZntAzCyGSioOBHb1zM?=
 =?iso-8859-1?Q?N1MhOouZztTL2oTFhDjpgIJU4eHACzH8SYlgly5zxjlIZIWE+DtWKnmx/o?=
 =?iso-8859-1?Q?aXBFlymTTA/zd7FtQr+dd2ZyeDm7HMNurYeu8DuH7YVoi9ucQuBI/UWmlx?=
 =?iso-8859-1?Q?lu50k4hckmu0nTvboOOT2YqIfmBLaA1jNdwx8APX1a8CkLugkwL4+SaLeq?=
 =?iso-8859-1?Q?ioz6ebppt9om95ojnykFkdbABjGzFeES2Vj1g/xgrUuLY17hK1OXDfWcIq?=
 =?iso-8859-1?Q?vdTFZ3TJu51jV+lnN3y6mvGhhIA13UsjIien9rFViGIqYskvdcmgzx/F+j?=
 =?iso-8859-1?Q?9IJ/EhCaieLWnUYz8OvH1nPdcEWhPwX37ztwy9wMcWygWqxdyRuOusn0Lj?=
 =?iso-8859-1?Q?FJ1KEOgKIPSzCTtpQ07iq3du9Wvlz2VUHaS6Urp2/Wc1u1eE+KHAySPe7Y?=
 =?iso-8859-1?Q?1mEqCuBS6ZLrrSjL+amk95p8nYlSJzCP+fyuZqYwHAjyhYB25i7jLR0M5v?=
 =?iso-8859-1?Q?CU/TuXeylS1xevp5IujqCY6Gwstmg95jUe83cByTzRS7bjHiQWAbr4XQf0?=
 =?iso-8859-1?Q?PEEbBqOc/5EBJ6/U3unwAtNmt/5cHg1s8m0Q0Bz4/wUqNFNdfkzR6RYCIJ?=
 =?iso-8859-1?Q?KdbhaZ4PJi5XzSejlSBYGINMNDBe5dXyPe9Csf9EbHhd9J9m5tcCKrmVRB?=
 =?iso-8859-1?Q?sbbtmKMQ670nRSxSFmRhJ4Uq2Rof/PyK0JANnhCyTKzRSMdRq45DmIIBJc?=
 =?iso-8859-1?Q?FsSlLxTprMSVT5a+NySs3IsX9UKBeMxDZ0UfoJf6Cglqno3CcEKVqPRyEG?=
 =?iso-8859-1?Q?0RGn7BsVnUHWP32FDsXTO1MrCOeGn500rRhfWCwBLDegr7XoVb8F2QLnHS?=
 =?iso-8859-1?Q?OH11ddVo0ZpAxsn427gicldc4dNjlNFk1wABBmRGPkYQRIRFJfiEHvtdUh?=
 =?iso-8859-1?Q?St4LLJ0qE1MzsfZhp2RdMXoHAdmErMsyveEUzdGqMftjSZQtdZsdVlDOw/?=
 =?iso-8859-1?Q?YQ8M7/gO4eFllHRU1gu/yOr/unfjWjZd0wlrnQGNhBgWX6+gSLlDt8EluK?=
 =?iso-8859-1?Q?489l2Rf2UcXFcDpsAmaA7wtjm57cbCiPgmxwqiDqUhTCpte2kL24d+28/q?=
 =?iso-8859-1?Q?S6Z81bQIxtQ3lDo6S8Pq0MDewMKoKY9H8L/Xil4xLmD6CWaXZEFF8BaQS5?=
 =?iso-8859-1?Q?ESmgEyn+FuZytbCYSlOPOXvyw7zCWM6xydjEdkfTK/BsDPoQCc43PfEeJG?=
 =?iso-8859-1?Q?MvpARs80BzU0VUTOdbaCTSnINzeSuwon+BmfyyWUB/v1m+z3NA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: secomea.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR08MB3867.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e064a8c-a6ad-40f2-a02b-08d9f92a4c2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2022 13:17:11.0502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 979261ea-5b3f-4cae-9a49-3a7da1f4fb47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L1D+2+nr2zVWLY6Mj3e8JOGNJ/JCZgSPEjf0y/4ieBYvFQoayd//aKRU2123KNtz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5043
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
plugged a packet leak between ports that were members of different bridges.
Unfortunately, this broke another use case, namely that of more than two
ports that are members of the same bridge.

After that commit, when a port is added to a bridge, hardware bridging
between other member ports of that bridge will be cleared, preventing
packet exchange between them.

Fix by ensuring that the Port VLAN Membership bitmap includes any existing
ports in the bridge, not just the port being added.

Upstream commit 3d00827a90db6f79abc7cdc553887f89a2e0a184, backported to 5.1=
6.

Fixes: b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
Signed-off-by: Svenning S=F8rensen <sss@secomea.com>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/dsa/microchip/ksz_common.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/micro=
chip/ksz_common.c
index 8a04302018dc..7ab9ab58de65 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -26,7 +26,7 @@ void ksz_update_port_member(struct ksz_device *dev, int p=
ort)
        struct dsa_switch *ds =3D dev->ds;
        u8 port_member =3D 0, cpu_port;
        const struct dsa_port *dp;
-       int i;
+       int i, j;

        if (!dsa_is_user_port(ds, port))
                return;
@@ -45,13 +45,33 @@ void ksz_update_port_member(struct ksz_device *dev, int=
 port)
                        continue;
                if (!dp->bridge_dev || dp->bridge_dev !=3D other_dp->bridge=
_dev)
                        continue;
+               if (other_p->stp_state !=3D BR_STATE_FORWARDING)
+                       continue;

-               if (other_p->stp_state =3D=3D BR_STATE_FORWARDING &&
-                   p->stp_state =3D=3D BR_STATE_FORWARDING) {
+               if (p->stp_state =3D=3D BR_STATE_FORWARDING) {
                        val |=3D BIT(port);
                        port_member |=3D BIT(i);
                }

+               /* Retain port [i]'s relationship to other ports than [port=
] */
+               for (j =3D 0; j < ds->num_ports; j++) {
+                       const struct dsa_port *third_dp;
+                       struct ksz_port *third_p;
+
+                       if (j =3D=3D i)
+                               continue;
+                       if (j =3D=3D port)
+                               continue;
+                       if (!dsa_is_user_port(ds, j))
+                               continue;
+                       third_p =3D &dev->ports[j];
+                       if (third_p->stp_state !=3D BR_STATE_FORWARDING)
+                               continue;
+                       third_dp =3D dsa_to_port(ds, j);
+                       if (third_dp->bridge_dev =3D=3D dp->bridge_dev)
+                               val |=3D BIT(j);
+               }
+
                dev->dev_ops->cfg_port_member(dev, i, val | cpu_port);
        }

--
2.20.1

Backported upstream commit 3d00827a90db6f79abc7cdc553887f89a2e0a184 to 5.16=
.
Sorry about the subject; the MS webmail client doesn't seem allow me to cha=
nge it when
replying to a message :(

Svenning

________________________________________
Fra: Svenning S=F8rensen <sss@secomea.com>
Sendt: 26. februar 2022 14:04
Til: gregkh@linuxfoundation.org
Emne: Sv: FAILED: patch "[PATCH] net: dsa: microchip: fix bridging with mor=
e than two member" failed to apply to 5.16-stable tree

gregkh@linuxfoundation wrote:
> >> The patch below does not apply to the 5.16-stable tree.
> >> ------------------ original commit in Linus's tree ------------------
> >>>From 3d00827a90db6f79abc7cdc553887f89a2e0a184 Mon Sep 17 00:00:00 2001
...
> > That's strange - it applies just fine without errors here:
> Try building it :)

Argh, yes, I should have thought of that - Sorry :)

It depended on another patch (implementing dsa_port_bridge_same()) which is
not in the 5.16 tree.

I'll send a properly backported version (which has been both compiled and
runtime tested) in a reply to this message; I hope this is a workable appro=
ach,
as I'm not really familiar with your workflow.

Best regards,
Svenning S=F8rensen

________________________________________
Fra: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
Sendt: 26. februar 2022 08:38
Til: Svenning S=F8rensen
Cc: davem@davemloft.net; o.rempel@pengutronix.de; stable@vger.kernel.org
Emne: Re: FAILED: patch "[PATCH] net: dsa: microchip: fix bridging with mor=
e than two member" failed to apply to 5.16-stable tree

On Fri, Feb 25, 2022 at 05:14:13PM +0000, Svenning S=F8rensen wrote:
> gregkh@linuxfoundation wrote:
>
> >> The patch below does not apply to the 5.16-stable tree.
> >> If someone wants it applied there, or to any other stable or longterm
> >> tree, then please email the backport, including the original git commi=
t
> >> id to <stable@vger.kernel.org>.
> ...
> >> ------------------ original commit in Linus's tree ------------------
> >>>From 3d00827a90db6f79abc7cdc553887f89a2e0a184 Mon Sep 17 00:00:00 2001
>
> Hi Greg,
>
> That's strange - it applies just fine without errors here:
>
> --- snip ---
> $ git log --oneline -n 1
> f40e0f7a433b (HEAD -> linux-5.16.y, tag: v5.16.11, stable/linux-5.16.y) L=
inux 5.16.11
> $ git cherry-pick -x 3d00827a90db6f79abc7cdc553887f89a2e0a184
> [linux-5.16.y e1e17aca71a0] net: dsa: microchip: fix bridging with more t=
han two member ports
>  Date: Fri Feb 18 11:27:01 2022 +0000
>  1 file changed, 23 insertions(+), 3 deletions(-)
> --- snip ---
>
> So I'm not sure what's needed for backporting?

Try building it :)
