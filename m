Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9F854381A
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244266AbiFHPva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 11:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244405AbiFHPvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 11:51:24 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2088.outbound.protection.outlook.com [40.107.100.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCEB104C9A
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 08:51:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5a+H9/5hnq+vXrGxpcxuDatjMB0rGsiRvweADQ+p15vy57dcR/lv0QJDE7wj28cSBV35Z/q4VL3ZdottgSvCb/0XRSps1sBZEsZJhPnsIYRitS5Lda6JyuYBWNVxl8u5bzFF2HjTE+pNPM0EEdbAUmFbv6RWbEK7FPoM00xz3FOpJCsL1PU5ZX1ylcPQBOo0VEzVBS357seYIsHnmQdxZhKsSDeiouImQX90bs3aJDXZ5ZYzTI3KX2BIv7MheUrnBPULNSN6to+YzyBNP2ogjGqU4Qvldpu8dWm/LXcQFU4CV6K/d+B92aPhKWzu88vZvlRFgWsNW7DTzmroacbuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBm7WhEs2gZpChCGF1j5xqdQeed6yb49Xtr7scyLkdo=;
 b=nV2/B8/azU4NNxQnCFaqzgd1OBsomNnQEALhKdtnvkXJficFQmfEzJ7O7T4nFPxq2nO9fOieMmYWcQYxjHJ6+De7OVkd0UXCS8hv7cdXsyMY+/vIx4BhTDpkoyidgPg/sZUSUWVazd/ngT9QoQIN6+I//S4U9HOgSg5yMH68Sim3wbFqRW2SE9qj9qRdlkE+SMQRbQGWgvPravojTUZU4RvbDZ0luEZO0fgqqdTW5Mv3qOfY6W2Evm14HssPVeeIzl6TO7Dl8SecgbhttTjAcn/7tpGZgGUPmamIkQQnGbeoyIVXIUy/RKkamULGmqciimxnrMwzXJPg8Curzh6Bxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBm7WhEs2gZpChCGF1j5xqdQeed6yb49Xtr7scyLkdo=;
 b=z+LPWnVzKdxj+wlDJXQL5lnITrtP4k0BePKU6Wfv3q32PMHaJwa3CbxkiEEaN4dlN7LkYWxFy75CwWo/id/4oZyuFJrwBBs3L0U2q6netq23pDtJecH+fLTeRC4yYlfaFGRayyyk1ABWwAnKeMJejj/jQn7pKAuFCbgAethkSb8=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DM6PR12MB4483.namprd12.prod.outlook.com (2603:10b6:5:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 15:51:20 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::589b:a1f6:9c87:a8ba]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::589b:a1f6:9c87:a8ba%6]) with mapi id 15.20.5332.012; Wed, 8 Jun 2022
 15:51:20 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Quan, Evan" <Evan.Quan@amd.com>
Subject: RE: [PATCH] drm/amd/pm: correct the metrics version for SMU
 11.0.11/12/13
Thread-Topic: [PATCH] drm/amd/pm: correct the metrics version for SMU
 11.0.11/12/13
Thread-Index: AQHYe0dU0+ZGpIDfOUGYEl/1+v0B7q1Fp3SAgAAAupA=
Date:   Wed, 8 Jun 2022 15:51:20 +0000
Message-ID: <BL1PR12MB51449EAF976A5F3EFF100A4DF7A49@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20220608145150.3536211-1-alexander.deucher@amd.com>
 <YqDEe0shEmrRR+Sc@kroah.com>
In-Reply-To: <YqDEe0shEmrRR+Sc@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-08T15:49:47Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=d1843cea-7689-4853-9d96-dfe76c85b184;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-08T15:51:18Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: d5904766-aa80-4acb-8671-c44007b2ce24
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ade5de63-6077-4f78-3843-08da4966bb29
x-ms-traffictypediagnostic: DM6PR12MB4483:EE_
x-microsoft-antispam-prvs: <DM6PR12MB4483E2D57D4F5678F534D78DF7A49@DM6PR12MB4483.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1qVaouG2tHZHR0CcC7VByXZRZjvE8Gm5BbUfuwIO3PVtJxVGU8Hp/yC//UQujEfDhmuca7hD5QoT0MqOCfk9dOws2GUrDE0i6hiJnkGXeoMrXk10A0R79Uks8EDhczivdxezHiJvkYNWVCet/+R91an9DKc3acmFPGpuK9C6LQoxaqA4KnokkLL9gbMuuFVsdaNwKRfEtKrQnF/UlRfT4At8FUrSVTnmCBnNcsZf23afOVEaPvCTSKAaeE6qWXr8LrNbAzL+j9mFvy6TJ+h5nEIUoG9w95PH5HT57t0vy1lSeFWGCyns9AitQ2ec574HVMzVec0Wr2d+4c1AA1gDl1LcrpylckI+dhLuJoJ5CVBi0d3JIwubYdlTSTXe4mUPZd1HAm8czNdlM9CkWWJ86H6GR++9wtJ8UHJ2RI9XOxP+LQWP8ySoROuIpl38w3tlac8cYqVNzdB0AvAkyeaSQ2jIotfaePKaszHydY1PFIsgM1JPla+/zQV7fPJ6TmxWaI2hoXAgKEFgfhwPy+ksFBp+mkTjk4083yBDIpGh7wnqDDQMX00fWS6Gc1FsgysesXWOq+ncQpIeS1XgfX3OHIiiyYiaywhggV0GHZD1LSBolPLqnSNxAM7bMh21f/sfClvzUEzapgDb71/i/OuF2855l2egCyXnhneIGm792Bxh6WKA4YT7gjSH1OFfIatIfk5lARvT99V9AfKGwc+jLBd8Ihn6nQtzKPj2qLSVPXa7CaQOGHCEZyXu3NBZpHDwnkHIMiGJleJa5ZudpdayMM0OSyZ8O03jHy/DryViKH4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(52536014)(2906002)(966005)(76116006)(186003)(4326008)(66556008)(64756008)(66476007)(66446008)(66946007)(83380400001)(26005)(122000001)(8936002)(71200400001)(316002)(53546011)(7696005)(6506007)(8676002)(9686003)(86362001)(5660300002)(55016003)(33656002)(54906003)(6916009)(38070700005)(38100700002)(45080400002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Daj5PURolZD8rWJN6WbV2u21Ls45H6SgNE5+38p4B9vDZ6aUbb+bGsQ7DFL9?=
 =?us-ascii?Q?7jVrepVkCditRcOWS2HbxrvjNyxgIwRdVTFuhywp9dgnfBqwmjyivZOqIMZt?=
 =?us-ascii?Q?Nk3v+gJNmE1J2ei208xcOKg4s+aO4wVvct/U2zR17AJMASYnJTv153GZZ8sb?=
 =?us-ascii?Q?4UMuSAkvbURMvy2yY+RGd+aw0JxwP+fu5uypMJZB4GxyUCSh6m3wkeABIveJ?=
 =?us-ascii?Q?GzOsNg4UNvypijC+qX3YBzCqjFY2ejJQzvSb6uN1XZc7w0sB/3ayfHfu1T81?=
 =?us-ascii?Q?4dCAvQlp9KMhUxmeq/iNxkNL/PFjZquO+dCi1wX0mO+7AS9SWNMXm9IknRFZ?=
 =?us-ascii?Q?Q/5H3emmloWjyrhDJP90r5bnYA6pcZAKch+wzQs2kVfzBipkWiBsSoGbaJy/?=
 =?us-ascii?Q?GOM3kCrNwgzaHBymw3pmgoLePM5eTGk1lKOrn7eKDAjjvoDbKcbfmX4zwTxE?=
 =?us-ascii?Q?SYZKiQHCvWKMbiAL+NqMbG5MkXZCeTR8dIyw+ovR5smCZeXsSa1x9JnaPGvg?=
 =?us-ascii?Q?jpd9roRHj5apcY0XTsqitY8vMGVTh66NNjiMsP1TQO3TbH7qnWqc3qIpNpr4?=
 =?us-ascii?Q?smQeVft2FIfPJkMAMNznHhsCdHj9DsKCOAOmTwTpRpxyWdZecxxY2x3uTBJY?=
 =?us-ascii?Q?0Z1Q8me1EWwJxsCLRxsMHmy5V18k56/RIkGr8Bj6l9Ajn1KpBVgr4/VPLcab?=
 =?us-ascii?Q?TvasN0WrRaGLKhhZmektObOy9WvKmQCo/swEjeuILUsjx4qjoPiXbWEE5rIq?=
 =?us-ascii?Q?c/O9JOTPAnBN4Ib+0i70TMVRQQ7AW9oGZJNLu06wh/dKo40ezyK2eziBpxRV?=
 =?us-ascii?Q?PGlM9uPE2cte0Tr7sJXC7sf0kph1PMH2d9cWZuOmEx8+XpKBsFPPtRVdM2TO?=
 =?us-ascii?Q?et7ePfGA2Sr9ArYjX4Hegzi5hVRL6h310EIzFh2M/xhN7cI5wC+AzVphJkcX?=
 =?us-ascii?Q?FXLk2YB/Bjf8XFb0Fhls7+eyA/KW+8Qb8kl7K5rQcebrsmy/YCUFtRVAu+eY?=
 =?us-ascii?Q?yEGk6oxhAEgPDZv4iJW9c5dhOeKuN5qnX19wMY5OSimL06vcsY6TbkTl4Cdw?=
 =?us-ascii?Q?JdWYroVl1j3aAeCpraqUxppp1RtRh+cWteemNDsjxn6jRkKtMMDPHkCdP4kP?=
 =?us-ascii?Q?bpVR32NhXydnjoTt9L8UfSVEhVJZ05VYYohDG52giuDFC7bBfAnsZfPiwhWL?=
 =?us-ascii?Q?T5Ib0XMm+sRhFwiTHzraYUmD3K/lsoJcfmnPTnlgec3GaL6VlESdkxZHH/bX?=
 =?us-ascii?Q?5D4IN6Ymj3YWeZ7AX2KrDU3tunTorxmHx753ipfDHOBR1djdnn0o1GdfqPdv?=
 =?us-ascii?Q?QkJGI32JqyaXjZDLpoNlkMIcTeT5xq9DCvrRsQcoPPZihaa7l8f1Cn5lt4W/?=
 =?us-ascii?Q?sUwtIzJg0IyjyEXQ0f2JLy2c9LzpPWEM5HDSrjirHvfX091s5ooG3ioJXdCO?=
 =?us-ascii?Q?sgR3QqhVC2vvA+MWA9cgWvxtDM5yYE9//fa5R0JV5nNJOR69uMd+tsd+UKY2?=
 =?us-ascii?Q?JTkxx6+7DHNNqrPejR0nP9iRlYd9xWCwEShykSyJmWZ38ASDBqk9m/5nXAtn?=
 =?us-ascii?Q?ThRM0RHdA1K5YyuPO20MTUrLb2u4u/B9yk/qM5i7h/2DIc92615v71ZCqcMe?=
 =?us-ascii?Q?f5q8a8aeq3dMjJPpQGx95AZVAiD7cs39QVaxARyyFf14NmidlRgNGUh4taKw?=
 =?us-ascii?Q?r2tnqMQfzO1+JpCg8MF8G+R4ZRcKsU44xeVgnjSTLeNWYHQIDxhvexNBCnpk?=
 =?us-ascii?Q?vp7ujMxvnw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ade5de63-6077-4f78-3843-08da4966bb29
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 15:51:20.1566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HxsCEO+MMw+MypMPLENuyD7q0IQpaOBzVbJsz96ha21cBTwannRt6kLcvCNc1dSZ3A4/9g87QwJbd2g1jQLUmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4483
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
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, June 8, 2022 11:47 AM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>
> Cc: stable@vger.kernel.org; Quan, Evan <Evan.Quan@amd.com>
> Subject: Re: [PATCH] drm/amd/pm: correct the metrics version for SMU
> 11.0.11/12/13
>=20
> On Wed, Jun 08, 2022 at 10:51:50AM -0400, Alex Deucher wrote:
> > From: Evan Quan <evan.quan@amd.com>
> >
> > Correct the metrics version used for SMU 11.0.11/12/13.
> > Fixes misreported GPU metrics (e.g., fan speed, etc.) depending on
> > which version of SMU firmware is loaded.
> >
> > Bug:
> > https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit=
l
> > ab.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F1925&amp;data=3D05%7C01%7C
> >
> alexander.deucher%40amd.com%7Cedf89fa3ab394ba5362808da496627a1%
> 7C3dd89
> >
> 61fe4884e608e11a82d994e183d%7C0%7C0%7C637903000346405316%7C
> Unknown%7CT
> >
> WFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJ
> XVCI
> >
> 6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DRo1FN8XPjNoT79lk6A450jv1CO
> 7ri02O1dUi
> > Bjj9cO4%3D&amp;reserved=3D0
> > Signed-off-by: Evan Quan <evan.quan@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com> (cherry
> picked
> > from commit 396beb91a9eb86cbfa404e4220cca8f3ada70777)
> > Cc: stable@vger.kernel.org
> > ---
> >  .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   | 57 ++++++++++++++----
> -
> >  1 file changed, 44 insertions(+), 13 deletions(-)
>=20
> What stable tree(s) are you wanting this backported to?

Ideally all stable kernels, but I think it will only apply cleanly to 5.18.=
  I'll look at a backport for older stable kernels.

Alex

>=20
> thanks,
>=20
> greg k-h
