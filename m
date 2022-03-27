Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D994E8932
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 20:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbiC0SK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 14:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiC0SK6 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Mar 2022 14:10:58 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07olkn2054.outbound.protection.outlook.com [40.92.15.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A703465B;
        Sun, 27 Mar 2022 11:09:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdN74v5ZPd2lOMu7CJtGHO0nxSB9P6PHSKsScPYhkWj6ACPLqO1FIUymRvX/oDdSeqoKErIHX1Qq3UCmGaFR69HXdV7Xk5d1SvU5qJSeI/SyBsabiw6ElJL5eGDJq4MXxE9g0qN/nS4dtrYb5N+/42A1UF2mXwUKttVmLNwQ7eo2PXeWEfezWJvuA3Fzd/1JBR6C99QmUmhqUX9rBW1FsXYLdM6xt4JWrActMF754KGiPy8iJ4VQDIHRMrP01OuRoxi3JisSUpjwR/fc/kVjjB1e770D59GDPk6jP+Op21WS+Dt1fMmDPC2RMYg66giNlx7j2RYBfsmLji43zMedgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhd3xbUcanB7P2j8DZTle5H2wmtGN1mpL/0bJOFgtHI=;
 b=UCVWDnvY/taiKOKfjlxH6iw0Ys+er+VbljB3Oz+cbOz+Gdl89fPEibwQu01PCu8M42+kmIz15E64/GvWsvx0eHGPgefweoMN/6qwp31kKJvGaljV8Bf4Nwn8zPz0AyNyE6mUsnfNiVbzzlsNXyiLgPpqe7xSPvft7aIHexCvhwR9NOnS6vWLg7LNoTYyLsZ5hVQ7TKxoCT4P1PdoTR/aRcbGKmEwIZcr6ejzJrPqENaBRDr7F+1CohL/5/HBQMYP3DVN0ri+8sHvJ/6Bjh3mj1fvyBo83q3E1fx185ec4UeZGZt1g74rn0wqCUtx6wNgya7mn5aaQqvN0ZSOYVcxIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from CY4PR04MB0567.namprd04.prod.outlook.com (2603:10b6:903:b1::20)
 by BN8PR04MB5778.namprd04.prod.outlook.com (2603:10b6:408:a3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Sun, 27 Mar
 2022 18:09:18 +0000
Received: from CY4PR04MB0567.namprd04.prod.outlook.com
 ([fe80::451b:e5ed:c1a3:4070]) by CY4PR04MB0567.namprd04.prod.outlook.com
 ([fe80::451b:e5ed:c1a3:4070%5]) with mapi id 15.20.5102.022; Sun, 27 Mar 2022
 18:09:18 +0000
From:   Jonathan Bakker <xc-racer2@live.ca>
To:     krzk@kernel.org, alim.akhtar@samsung.com
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Bakker <xc-racer2@live.ca>, Stable@vger.kernel.org
Subject: [PATCH v2 2/5] ARM: dts: s5pv210: Correct interrupt name for bluetooth in Aries
Date:   Sun, 27 Mar 2022 11:08:51 -0700
Message-ID: <CY4PR04MB0567495CFCBDC8D408D44199CB1C9@CY4PR04MB0567.namprd04.prod.outlook.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CY4PR04MB05677B4C4E26A8A179F6ABC0CB179@CY4PR04MB0567.namprd04.prod.outlook.com>
References: <CY4PR04MB05677B4C4E26A8A179F6ABC0CB179@CY4PR04MB0567.namprd04.prod.outlook.com>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-TMN:  [JwAms03OvvPucqBdZkNCxVufIdflQVAvrQPYtunA88TO7mXphQEHBroRasL0u9ft]
X-ClientProxiedBy: BYAPR07CA0031.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::44) To CY4PR04MB0567.namprd04.prod.outlook.com
 (2603:10b6:903:b1::20)
X-Microsoft-Original-Message-ID: <20220327180854.4857-3-xc-racer2@live.ca>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68cb85b4-58ba-4dba-db44-08da101ce8f1
X-MS-TrafficTypeDiagnostic: BN8PR04MB5778:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mu/0Y3wtdRbRRLzRWMlvbNshiH7BP63hG3y+/ICaf0nmV9/jLL5P5bGeLZNnPgk6uLOxB7I6+n4fTiHkMR6oTs3NBLSxszW9hg6jaxgssNw0CEE//cXssqTP9ViOyoprmwhspm/OVvywkCIS1dqWcmvUykO+bXzxPKt7OPU8L7VRMIuw9ku0TUAgRqszbKI5l5Sx2CUZZ0xHBs4uAcouUcoEON5J0iPg5y/o8t8s3qG0EDDk7wvF4Z8ys8B4i0o9KeLuJLpVFcduV4HxfFscl/ZBuJ/axPBVUEbj0Ap3jbRdnwXj7C52pGKJslY7gTQe5roqQkzUD5KGjHpor+hK0ZFlR2YvXh6XgiCYajRZoCLregYZNuADaivwFTe7jHW5lS9SyBlKZEUEBt4iQeczDuRsNGvXfz/y3GTl6zobNbkBGgqLSDiPjsGNLo7pKi9qhh6YS1++zEgoQYeH0s+Msl9Tjb0JUWJ0/3wwfrK3YEQL7jK75DG8jPmnzXyJmaGTVi+mzELO0TQyWJf1QVFbccvw9OdMEOzt4tfZxxqOlXsnOSHwWlkFRT7aH8eS1J4I+KIbLBKyB2TrlxB7nyKPQg==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OkQzMBNwKAeafSBAhsN65d0pKcbk3dxhvbofQFvcO+NUaFoG4bg05Rh+MqDP?=
 =?us-ascii?Q?iJEUIq6K+tAZ6LfhYx+5nxYxjAHSUKNb1QEfRsKUMJ7yqFUy1pjEtWd6Qvlp?=
 =?us-ascii?Q?hc/gnNMMu71zKKGEHKgFkBj3QgsqLarriWh2HeivZ1xWetRsj4KYun9N68Wh?=
 =?us-ascii?Q?32yuzDfhxCdDYcxouwVq90Bjw9sXTn+y5bAwwlNnig/7O29/4jstKaWMcwnk?=
 =?us-ascii?Q?Kp9JlEM6UX2tXREPBEBxXtmeQGgV5Rq9QPctZ4K47okNaELcmiSc7OeX+CCZ?=
 =?us-ascii?Q?i6WWl175uqmvHMcP87TaD/7Eyp888YY/orTPerEtv5dEU8gYHEtm+MdMDUnK?=
 =?us-ascii?Q?52DQuPsKwkjAcCA2uAL+f5wpO/xwp3n14hLxaS/d1aGERyCaaHAwvdgdw98a?=
 =?us-ascii?Q?DGZUng7cVjCtygMoIb+UAKaE76l7FZvNe6WhbAvtnCxbQGpIbXdbIVTSBvcY?=
 =?us-ascii?Q?ebQms/aRZigqG0ioAKxz0YBU66BWlr18W6K7Ox/OyX3G6xL5HpRidCvqBd0/?=
 =?us-ascii?Q?XQVEyFjqdlrPdgUQiVgL705SIoEpGjb9DYZeKU+04EENgzoTH4JproJydSWz?=
 =?us-ascii?Q?sBZ16xDvjC3fF9ILxy57165pKhnUa4AVnZRolxHZXwP1sJnHK9bY9go7+hYj?=
 =?us-ascii?Q?dWUZw1tXuNo6KRhpxuYkUotjyGIiLTxtudKHrCRKc4Z+1hvpAm0giWCr9Hoa?=
 =?us-ascii?Q?uDRkPosja8RO4O+DT2GsDh1zwKgmVK0y3ZwmUz1/UMen//pp7o5fJcMNUe3n?=
 =?us-ascii?Q?KSP9UTTm0Fs/X6/Bde/nKXE9C44FpW1FfIXWnDDAcHP6zwlpY+BVx6TJbu+a?=
 =?us-ascii?Q?5rztXZ/5IVuNFpq9itt2L18F/vxiv8x9WeaX1IsLtajZPqCqZtiLZwCetQ4E?=
 =?us-ascii?Q?3wBkgD+TM6hNYadKqur6oN/blaCTcvL+IqM+1MfvdOAxi+zZRpfI/zH1beWJ?=
 =?us-ascii?Q?Lef+Erxdgoi4mBQM7qoqM+ABnVKnzAFnMEzeMhU8ZNFHKe5dDZ62kpg5mIUI?=
 =?us-ascii?Q?xIwvSMUY2uaYtJUgmN2M5d8IIR5yiEDWwaDug0AxfIwn3VTUIC9a2kdQLo2I?=
 =?us-ascii?Q?DmwrM4GoN4j4o72DIDVdBQ7pGl69qyi/BlZ85T8PkiBY3KBp5IcbKdO/HSf5?=
 =?us-ascii?Q?a5wyGi9LSZmVHeg3vGUx/YzFtdNHzWi7BPiqO+z76eSqOEJQTrJrrHV05lxN?=
 =?us-ascii?Q?cORjf2HN2kcN0GdTChYo3QguUe1qpsumL78l0ytLZdIH9fJnmxFRxa6GqzwS?=
 =?us-ascii?Q?q9u3ckub0DJ4rLNxfjO13W2wWZXTv3ks26OvngyN72UuuAkkLjV79GDkVQh9?=
 =?us-ascii?Q?GjQHH80jQ4OPPfetFkU09DK5xtU/DY7KS8UaVWNSvN191tDgswHaSiQmBeQz?=
 =?us-ascii?Q?BvUu/cp43f0ZZ2tSIsS6kNmVpBmRIw79MUhWzuLBuBzWNh24+nwnEzgE2g/e?=
 =?us-ascii?Q?IKPbuN9pL709ltFjxviOQ77NRDq1D/zNVjN5khefypaW1DVrOJ6k6HFd8mnp?=
 =?us-ascii?Q?04Z5VPH01Pr9PC0=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-edb50.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 68cb85b4-58ba-4dba-db44-08da101ce8f1
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB0567.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2022 18:09:18.4170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB5778
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Correct the name of the bluetooth interrupt from host-wake to
host-wakeup.

Fixes: 1c65b6184441b ("ARM: dts: s5pv210: Correct BCM4329 bluetooth node")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
---
Changes in v2
- CC Stable
- Correct Fixes tag by adding commit message
- Re-ordered bugfix to start of patchset
---
 arch/arm/boot/dts/s5pv210-aries.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/s5pv210-aries.dtsi b/arch/arm/boot/dts/s5pv210-aries.dtsi
index 740036a61c8e..cbd378ac4e18 100644
--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -894,7 +894,7 @@
 		device-wakeup-gpios = <&gpg3 4 GPIO_ACTIVE_HIGH>;
 		interrupt-parent = <&gph2>;
 		interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "host-wake";
+		interrupt-names = "host-wakeup";
 	};
 };
 
-- 
2.20.1

