Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549E86B409E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCJNjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjCJNjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:39:37 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2119.outbound.protection.outlook.com [40.107.20.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA6410F846
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:39:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpdLQUzW3CtGYuVG6SbeCPRrqAp/EB4UtN1ibsabYu2/HzCAVyQb8eDOLOxFmX3/HhCRdj8kDpLK3wL70Vj+G3wzOwbhp1Hlr7NrP8tm5SAHeJ4rFqWmpuCUy4vVkTs3EN1hkW8hcTaYit9J/jFxJcwdWUsDrmCDnGPv2ROCqXw6swinERPiqYOBJTn3hTTfANMSEK3Qflp0DnTD3tP8y6ajoM7soTivvDnx+EH9rw7u6H08ebnyrXNzVW6zI6CS3bmWSxIYxqkY56HNUu8Rc2CU65g2Nx2KfDBzNDJxUKNY452DkVvczLat7dD7m9gySvBs0BAS9QMMnPwtBgxWSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38Y2OQiskBFnjlFn4XsUzF8ivUiklh/q7InrHipjRME=;
 b=mxUrBXjEgxz1daoxaR2xPlKcSUKBQ2FDOXL17PvWgxWJxHjbUFX8MwMYv9w6EaHhIvG1o5UtzXmif2WB0gML13zWePAIPOwfdPlzC/8HutkUuY2E9xwTiQ0uQ+AiuJSZzya8fqLLuX3HeKBWfSq/NILqez9L6TyYVpMGZvGJ/NtxN0/V3Pbrz/hWmSGo2qs8GiVDc3xFCMGi6DMH51+5MsRIMY3bwCufD0rGi/uIBRxECqk1dwR/hRVfI5AsJ3dBMymedbbBM+6M6ZFX7qkRoLIMuN26aXi2AmkkWwnQWHhP2K0cPnvCaJ14DJUiLklRDqp2LkcRVt9UCSurPgXLLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aavamobile.com; dmarc=pass action=none
 header.from=aavamobile.com; dkim=pass header.d=aavamobile.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aavamobile.onmicrosoft.com; s=selector2-aavamobile-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38Y2OQiskBFnjlFn4XsUzF8ivUiklh/q7InrHipjRME=;
 b=NZ6O75qAsh0A3SnbgeNco+c9CN7DD5Y4aNls4XsRuaiWUFlTPP1yWJxxkEWbIqUU760izFp6tTL4iPcmbv5jF2cGPgUqgoGpdkKGGYEDH5xEgoEM5FPX/yQEIuIW30x4rVD6GYFKu3bFya58ZvlI753Hk3ixqYW/DqH8bcSJPrI=
Received: from DBBPR09MB4665.eurprd09.prod.outlook.com (2603:10a6:10:205::22)
 by AM9PR09MB4754.eurprd09.prod.outlook.com (2603:10a6:20b:287::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 13:39:28 +0000
Received: from DBBPR09MB4665.eurprd09.prod.outlook.com
 ([fe80::e82:6f41:f748:6d6]) by DBBPR09MB4665.eurprd09.prod.outlook.com
 ([fe80::e82:6f41:f748:6d6%8]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 13:39:28 +0000
From:   Mikko Kovanen <mikko.kovanen@aavamobile.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jani.nikula@intel.com" <jani.nikula@intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] drm/i915/dsi: fix VBT send packet port
 selection for dual" failed to apply to 5.15-stable tree
Thread-Topic: FAILED: patch "[PATCH] drm/i915/dsi: fix VBT send packet port
 selection for dual" failed to apply to 5.15-stable tree
Thread-Index: AQHZU0YcUKxcAbScxkOb4rzYDfkVSK7z/PEg
Date:   Fri, 10 Mar 2023 13:39:27 +0000
Message-ID: <DBBPR09MB4665ED59B9E01069E408F80991BA9@DBBPR09MB4665.eurprd09.prod.outlook.com>
References: <167844825562231@kroah.com>
In-Reply-To: <167844825562231@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aavamobile.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBPR09MB4665:EE_|AM9PR09MB4754:EE_
x-ms-office365-filtering-correlation-id: 5bf5a5af-e88e-42db-5cc1-08db216cdeba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VnNagx2Oh4fFVuLhS0hLWAf3vyXGHhlYQ+ouHfesYbIP+gUvsXRcEKQWQaM6z9balbhZBcZFI6RAlgglNabicLPV/r+gT0VYXHWuYaMtC+Nw8wLcuB7OS6EepEUM+SUufHDRfhQxwFeGq/aNhxGFy3mdnvZk6adwMhmiQL26WLUlRVdUvOIRm+PHjx8A/1kLcu9mvmcG94bxfVUjbp7ql2OZyFrWdUCtPgFu3tm24XE75vGqMZkMl74bPmHoeixr0ZR2x0L/Rn1igsW3Ft73Q3F4fdElL8eJCQxosjbZmOp/gn5UvUFga8lP0X7OYTTZvogUAEQ9/SeqrdWSoxo8ITFF2yBi5kd9zU3RjWzzYdPqy6Yjn59/cLuCk5y8BkObqNDOjcpImSS4i8XidzkEVbSP36ti23qe898goe0kHjqJTYah0LydE7rcUEYNyRWvarD0G+zfMIq34hZ17dI1bqy2vkmkBbbHrfEOmVr+hf6q63AKo10bjZ5j3CqlcZWPrJ+SX7yOmQluFN7DWQoXy2RsnVJNmOd62H3IH4yU+p0gsxvjidgdVRahdrN7N+Zgf69cVFEWltOXgxksNW0QW0E1uASpkzRxQzeD5BHfYi4xmvLBel+3ZFpbtUvSrVgdwIZP+AurjF2INUM1g6AdkkMjsxrkZAvJ8exdpydVra4m0BgAAz2O6GyNC2rDtCXJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR09MB4665.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39850400004)(346002)(376002)(136003)(366004)(451199018)(66946007)(76116006)(66556008)(8676002)(66446008)(4326008)(41300700001)(110136005)(64756008)(83380400001)(66476007)(316002)(38070700005)(122000001)(38100700002)(8936002)(52536014)(45080400002)(966005)(44832011)(7696005)(2906002)(33656002)(186003)(5660300002)(478600001)(86362001)(71200400001)(6506007)(9686003)(26005)(53546011)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2AWBBU/V2zBqzjKwUEMpRxL8nOR5+ldLH1te32DhpAYwp2HLGXqe53X2qRZA?=
 =?us-ascii?Q?a6JZBxNByK8drNTB/vbRSrBTDKSMGlzE8B7apmzbVkJHi8usX1PzmVwYuM2b?=
 =?us-ascii?Q?joG9xOVkhCuc816yrlatLRf41ErSynDKFR/Uf/gqKZuQ/h1cNeElbP163B48?=
 =?us-ascii?Q?dRIxm22SGlwZ0/RwrZPikHZ9lq29uHWuR924cq85sEcKTx1F2lneDdtvG06T?=
 =?us-ascii?Q?Xn0XRWN8H9KycJuYs6i3GQb6nkG+kFx6elI6CpVcnngq5i3nn326baWqMgZA?=
 =?us-ascii?Q?qZ8H1V3KVlu3oi1mGTuDwK6qq0ARejhjKZT/VVc5uAl1Lntv8Lv0SEhLOywn?=
 =?us-ascii?Q?XefGst6YXb7TufA6wPyw5tplWsIenXAWZGNlV20D9yr7Q6ZVRmjUpPRc76V2?=
 =?us-ascii?Q?baYEwCU7A11wAE2SINPzCDcqnhReXVr9Eaw8qwxZhEiwtisTJEiQwCMEAH24?=
 =?us-ascii?Q?cPlo5MIfLd27flZqIbfm+K7zVT9KHDJ/qO/OYHtD6tVFq95B2Ejfq1rGHLcr?=
 =?us-ascii?Q?3hLX0NEfOiWBcUatKBzdgv0R/Z+qtY0zVma96ebBwkbNEMy601pTILmDZ6So?=
 =?us-ascii?Q?JKW0JWBbOMHVeZr/eFqaAkDG0iW0pCsUWJUzfhNFeKdopnkupVhjGw1J8aWt?=
 =?us-ascii?Q?JBa2EZM9bcZ6QywGWiOApTmo5I5mXC8nHzzRqHSDpDlyV61jY/n8ynPbWDb9?=
 =?us-ascii?Q?/Ki4nmFL5dR/LW8TZNzLNTzfgdDvHMLL6onihZkKhZJAUEYIILlz6yahJI3W?=
 =?us-ascii?Q?kLNEAyC0Xg8WPZCbnOcju4akJGay1kOPLGb+ntiB7B0N+kjw2AWsdoCrMtfn?=
 =?us-ascii?Q?NKhrqswbYdZ8e6tpT6hom/mhLqRgeD0FhTr1z07bNGY9nWAgvJA6fmburauT?=
 =?us-ascii?Q?aqhhKKnUg+OrvQIB4WagUIzJ7DoEeze11ZxlmpKf6YUe4mGXu4N1lyyHaS3l?=
 =?us-ascii?Q?73ijSY8kMzlUUtOVKE22FjaOmbBDNU0k/o8jKFHqy9wOYg689/apoXnEmIq1?=
 =?us-ascii?Q?4UV0OiEWI/edgyandNMskR1eipX1OOLf9VlSpf2RfsfqfQpsl6ZV96O3HHvD?=
 =?us-ascii?Q?dH30aGHFxbCS+F3Af2cBFUfuYyV72OrEul6q7mkwlmU6K+uikHVr78+aqBMm?=
 =?us-ascii?Q?jCldWmdvtbojRCW9cbWWMfFiYV4LpCWdNb9hekeHDNC0hlvUVjlENnf/nhSi?=
 =?us-ascii?Q?CDob2FVtmAjPIYU74zEYOlk6q9dEp+tzZjcFl1rbP9etaq73hTOz1Drbyzb4?=
 =?us-ascii?Q?tQAMdTz23ucx4akHI6fmsuPivOTdw3HlWCK7G/kGx4YsUAY+dBA9AOKca92B?=
 =?us-ascii?Q?uGnKwM3BRlriOmlFCTPnJm7soy+e/TLrtbhYB2sTWy7QUfDjxmJQwbHU1pwg?=
 =?us-ascii?Q?ULr3H9LFaozxganK1edPIi2tLKX2axc1vc6PDphLsF2SQbZcZ/TFjNqK2k6K?=
 =?us-ascii?Q?qpVHOIejL/o1J0bllG/wxYTov4ntKirHXDPMX/Xe+EW/4wF92MX6bV29CiS8?=
 =?us-ascii?Q?8Pl3I4LEbNCdtTdTiyHMSNkehDuEKhvddtkiEprsWFWQ/3Kwj5Cm48uJJKZu?=
 =?us-ascii?Q?Xg05uHCMan+7jtZfOXYMdugNH+g0vM+2CoYLOI0dMCwRfSqmzYz9OL+ASwtL?=
 =?us-ascii?Q?AA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aavamobile.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBPR09MB4665.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf5a5af-e88e-42db-5cc1-08db216cdeba
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 13:39:27.9372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f89be375-dd3f-4314-b40f-dbdd01f05029
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mRMv6+8k3U2PJTBw22oWLqtLWIO7LKGOi/pQAWV2VOwcxA4AM1+1p5v/TNdyvygQg8ZX6aELOEZ5L8OGIQirRbk2cO0Veinm6vOG8+96XTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR09MB4754
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


  Hi,

  as far as I can tell the change is already included in 5.15-stable tree

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/dri=
vers/gpu/drm/i915?h=3Dv5.15.99&id=3Dc919e1154b8c25d0da7b45655f6026761dcef5c=
6

  not sure how it has ended up to being applied again.
  Same thing for conflicts in stable trees 5.10, 6.1 and 6.2.

  Best regards,
  Mikko


> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: perjantai 10. maaliskuuta 2023 13.38
> To: Mikko Kovanen <mikko.kovanen@aavamobile.com>;
> jani.nikula@intel.com
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] drm/i915/dsi: fix VBT send packet port
> selection for dual" failed to apply to 5.15-stable tree
>=20
>=20
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm tre=
e,
> then please email the backport, including the original git commit id to
> <stable@vger.kernel.org>.
>=20
> To reproduce the conflict and resubmit, you may use the following
> commands:
>=20
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.gi=
t/
> linux-5.15.y git checkout FETCH_HEAD git cherry-pick -x
> 8d58bb7991c45f6b60710cc04c9498c6ea96db90
> # <resolve conflicts, build, test, etc.> git commit -s git send-email --t=
o
> '<stable@vger.kernel.org>' --in-reply-to '167844825562231@kroah.com' --
> subject-prefix 'PATCH 5.15.y' HEAD^..
>=20
> Possible dependencies:
>=20
> 8d58bb7991c4 ("drm/i915/dsi: fix VBT send packet port selection for dual =
link
> DSI")
> 08c59dde71b7 ("drm/i915/dsi: fix VBT send packet port selection for ICL+"=
)
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 8d58bb7991c45f6b60710cc04c9498c6ea96db90 Mon Sep 17 00:00:00
> 2001
> From: Mikko Kovanen <mikko.kovanen@aavamobile.com>
> Date: Sat, 26 Nov 2022 13:27:13 +0000
> Subject: [PATCH] drm/i915/dsi: fix VBT send packet port selection for dua=
l
> link DSI
>=20
> intel_dsi->ports contains bitmask of enabled ports and correspondingly lo=
gic
> for selecting port for VBT packet sending must use port specific bitmask
> when deciding appropriate port.
>=20
> Fixes: 08c59dde71b7 ("drm/i915/dsi: fix VBT send packet port selection fo=
r
> ICL+")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikko Kovanen <mikko.kovanen@aavamobile.com>
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> Link:
> https://patchwork.freedesktop.org/patch/msgid/DBBPR09MB466592B16885
> D99ABBF2393A91119@DBBPR09MB4665.eurprd09.prod.outlook.com
>=20
> diff --git a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
> b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
> index 75e8cc4337c9..fce69fa446d5 100644
> --- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
> +++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
> @@ -137,9 +137,9 @@ static enum port intel_dsi_seq_port_to_port(struct
> intel_dsi *intel_dsi,
>  		return ffs(intel_dsi->ports) - 1;
>=20
>  	if (seq_port) {
> -		if (intel_dsi->ports & PORT_B)
> +		if (intel_dsi->ports & BIT(PORT_B))
>  			return PORT_B;
> -		else if (intel_dsi->ports & PORT_C)
> +		else if (intel_dsi->ports & BIT(PORT_C))
>  			return PORT_C;
>  	}
>=20

