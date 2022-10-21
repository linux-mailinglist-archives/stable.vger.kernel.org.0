Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0DC607F43
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 21:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiJUTsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 15:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiJUTrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 15:47:55 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2134.outbound.protection.outlook.com [40.107.105.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672F217F640;
        Fri, 21 Oct 2022 12:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+UmVE5yq5y92OxGMFUh6q04rEPM+djfm4LhP1dmhoee5YbjZPMUn0aJayy//Yu3dUwMCFc901kTWmR8Vctr7weBUx5YQpq5dO/GgeKFqUyuYrqyc5Q8GFZHCCG+JULfsizz3zTqM52qhQCQMJpymwsrx28G5BL9xtbtv3G2Uh3UkR+/7TuW1YBYGE9Gx4g3EX5h/THOq3hM8lHYDDIFTh2VAbnphAmOn68LB7idUClr3osAyr3qSW1nYR+o/O/K/VwouV7D5TKBRvJZ52pQNtO9RA7G090OCiV74X1H8yaTVHkynlw843vJ7Ae2TwvyhzeuT7YMpzIZ0zdouEmnzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tYJvJoeqmzA+wbsGxQgSLJ6zwFV8PjIUyjQ0cOVypjA=;
 b=gZPJQ99lZaUJsTIsE+Hm6CWhgdehRD9WSN23b5l0wBrjt+zneTVGnPFjuAMN2IHqwZGAmryWpEk04qeEGekPW5qJdmyfppqjnED3oYktMHg/7vILl/VLsE2o60AIzlmkhvLbVVaVgd2bmGPSz7W1etncIiZBSxyjMahYD97+uQ11TULoG6RUh1w7HOeYYD0EIqH0zpDRrfpxsnT3hb9yrHH15+x1A/h2IYoy+Ras7josiIwFZCOJNX0wG7Fw+IcWQt6jGY7D2zIo4uFZNSFJTDqC6efSbSvbVc753c51aHGk/iDu0DVdpPQ0JxYEvn2Z2XJozNnvAdmfZ54Fq2UpAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=concurrent-rt.com; dmarc=pass action=none
 header.from=concurrent-rt.com; dkim=pass header.d=concurrent-rt.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bksv.onmicrosoft.com;
 s=selector1-bksv-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYJvJoeqmzA+wbsGxQgSLJ6zwFV8PjIUyjQ0cOVypjA=;
 b=mEqXJ21d3LViAulKSWruGiAYgyYZoJi4I7FkO/Nwy2aYyStsQANWfYcHxrCUMGUVva84QUMPixHhNG3GpieEHUQW2heM0Zjv5tGVLhbRyuhBNQz2bGoKr+NgZ4yOn3p3wEBZ0TQl7/9UFSZ9s9OVyEnyYZ9P8b/Xyy3OLrKAbw0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=concurrent-rt.com;
Received: from DB8PR09MB3580.eurprd09.prod.outlook.com (2603:10a6:10:119::23)
 by DU0PR09MB5906.eurprd09.prod.outlook.com (2603:10a6:10:3e9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Fri, 21 Oct
 2022 19:47:51 +0000
Received: from DB8PR09MB3580.eurprd09.prod.outlook.com
 ([fe80::c48e:11a3:c89c:f655]) by DB8PR09MB3580.eurprd09.prod.outlook.com
 ([fe80::c48e:11a3:c89c:f655%7]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 19:47:51 +0000
Date:   Fri, 21 Oct 2022 15:47:46 -0400
From:   Joe Korty <joe.korty@concurrent-rt.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: arch_timer: XGene-1 has 31 bit, not 32 bit, arch
 timer.
Message-ID: <20221021194746.GA5830@zipoli.concurrent-rt.com>
Reply-To: Joe Korty <joe.korty@concurrent-rt.com>
References: <20221021153424.GA25677@zipoli.concurrent-rt.com>
 <864jvxnj65.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864jvxnj65.wl-maz@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: BN9PR03CA0179.namprd03.prod.outlook.com
 (2603:10b6:408:f4::34) To DB8PR09MB3580.eurprd09.prod.outlook.com
 (2603:10a6:10:119::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR09MB3580:EE_|DU0PR09MB5906:EE_
X-MS-Office365-Filtering-Correlation-Id: 72ea1dab-e3b2-45dd-6cdb-08dab39d23b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aj3hSm0OWP/lQ7fxtRZkhRFO4m7S7Vnz/c0KfvwIBtKxIX+BTQEH6uBUC77UumfAiLikSYEMgTc/tz0uk57OO9gtM92q1xwBn3Psl/7Ek5yC3LnqfJ+BboQJ/5yGLtHVheXFJ/TytkHPXqFKyO0En0A3MimZ5PyATyoCNbiPMIHxfIOEUEwmycYmfskZMGG/vRZ9BZYqwryIex8qWAobyhqXuGfdn6JAP6A7GtcVsClAAKStXYbAZF5ABvckDd6SBMrNKOyv1uDWuwjcBgVzS2apMFiW8W+F8ZRf0CbFbL3brfMtw7gcmFMrSQhUmknWXwqWUGy9ObYT1p/FKq43VrL/llcFb2nU6KGjO877z89R+ajUcTq4FYlGskaMZgVhp0hggIVBDFgOjbEcP2WlaalVZ24rTpRpKrUAn/E1j8CPFjF3+DDvQGSFHnF/ksthKucnViOS90z5nhd9oIykaloHJ33ZUzVXPvc4MQWCznKdt9FIlN58PQkwL9phYWYcKoZY2PrOpuqPwlBiQsNW4fZG/U/r1U+m+LaCura28HIG/YDHPo+qv50QnXOuQEBuxGX8lQ0++u9TMTNlp0EVj9CM/tWl43hxdfTgCYfjomKpWuJe0xTDGkcfruHKV8hH5s8/TJwMZDwfWCMb/ohsejZ7CcxwjVVtsXz6lD9YttNAZeSmMZtxQUL80hkEXe+MTjM8Q2WDFYdmC6ovbtUynQvfri261+k60YvDSQQatxXgJMihcj8uOs7xOaOzmlWV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR09MB3580.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(6512007)(1076003)(186003)(6666004)(83380400001)(26005)(5660300002)(3450700001)(44832011)(6506007)(52116002)(6486002)(8936002)(66556008)(478600001)(41300700001)(6916009)(66476007)(66946007)(8676002)(316002)(4326008)(2906002)(86362001)(33656002)(38350700002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mM5qYkIy/goyhhwa0esG2uWU1xzG9ynB/1SFUJZpkRyUdwRhc5pc3yuUFEVK?=
 =?us-ascii?Q?dAkBopNZHNot1rw9tWDngoOdtN9dWuBCayMGiMJ1bbmeLlIHalRFr2Ewy85I?=
 =?us-ascii?Q?OpFUEcweJ9Q6rLDjmk/WnEtUXyy8ydx5gxGW+NJ/kn13tOx0grqUXP1hvNVT?=
 =?us-ascii?Q?wz5Ps6Nw0MTQ2h2iInnApeTuZvOdU6YgFUHa/ZvbhCbx05uyGtWdsxzhe/Ua?=
 =?us-ascii?Q?ZbduM6zrVlnBtz9XR8KV9LqVLCadDRQx6LcJls4vb8To1TXAAd7kqVRmcphC?=
 =?us-ascii?Q?qOHsNI6Br8IzRCVUkHeAxslJII2YzxNq2OMZ/gqXTy0w4hKBQifZ8g4epWu/?=
 =?us-ascii?Q?9LoLs6E8pFNovH79+Pqyuz921gTw3c2z00aqn7O1nf8K4gnEooYiXojeC95s?=
 =?us-ascii?Q?0Y2RewQpY84MiSqUiWGqj+icrhFbKIZ+x/WjbQbPtOfXThtZ4LMNf69i9y8U?=
 =?us-ascii?Q?e/7PR8ZfYdz/kROyQYWD88kgHc1yuYFQT5pHIWho9QHl4hxHadvJkqbOehwP?=
 =?us-ascii?Q?jVHbpUmLbJijKmQFfklFKKrYExYR3bTl10HbamfLpS9SHXo6JML6C7NTHHkD?=
 =?us-ascii?Q?609V5LkVQgkRCAQDs7p+oYmYV5KxzU7T08A/0hHBRZK6rYefsapdlPIMYUTq?=
 =?us-ascii?Q?vOqEgaMbnkuPGt+YgtSMXQjxy1ETwZPWabdK4T10HI4vhq1FVl/8f8WKCb9V?=
 =?us-ascii?Q?ziwDy5PjjeezZMajJZPpxjfhl+kX1Tyz2nrUvNIZTow3UBpzQR4yJrkdoXDp?=
 =?us-ascii?Q?+U+WEaBu5InhLrOKhRURWqCqFjt5JBHrU5yFTEPpCevxsyOJYncTx9zuExmA?=
 =?us-ascii?Q?ggqRTGlR9Dz5d1cnbkgHsiU2O3yfXiSNw/WFlOOYSvdVJJ8lZr4+Vaedi1LW?=
 =?us-ascii?Q?kuiLZwCVRY0DoZkJHHL5rFAWRAB+m/117yJ/ZUM9do28DmmHJsoqUQ04gIt9?=
 =?us-ascii?Q?X60cPH7kEXYAv+wH/DOt+WmosIaG8NThgdWL2ahwPxyut/kcD2qyWbVmIQZk?=
 =?us-ascii?Q?9MsCVDEM8E8j3lYFANpctiFDqhVR8czNU2WzLbY0bLgsA67iq1pmJ3Nlk5OM?=
 =?us-ascii?Q?n8WfiZ6jGlNne8QgH26ngGPr3WpeJT9KQNg2rZZOyU1mtme7uYBXuOl6O3sf?=
 =?us-ascii?Q?qR5BcOy8mPs1jGwYSUZm/0ApsicUP3ia/UFN8SznE9WBupghRH3DSxECTcSd?=
 =?us-ascii?Q?U81ItAfSScQy0lJJJVRDt+LLWv9jJaEjNHXXuC5Tr6fLE12QNyvcHEuwFtK4?=
 =?us-ascii?Q?JirF7qPnsoNu+AQpDktygOxXWOR3Ryo87Oxa9+2Qy2B9PagGkAwhBfTVnTO/?=
 =?us-ascii?Q?qlVJVPdDII6JUFAylX8c/ytEpw3HXfwsWzi6EO4XXm5C0ddyCuKC3ConCW1i?=
 =?us-ascii?Q?RpJhFY0bavydSaJovv/Y02seKlEm7iQ/cEhswkD7JjGBvEK3K0jamtMTYG7S?=
 =?us-ascii?Q?CyuDoy3Xktwu7JvGM3tHLq2EHeJk0skQIdxJTlZkoYgE4mOfaW+lv593aKEz?=
 =?us-ascii?Q?q+o7GfmmeP7PMbsikbMDWvjvvb7srSZULgCazBLYC9C4arNcLyKGjm3HfInj?=
 =?us-ascii?Q?9K3tz/vMT+Wx8pzWeoD8I6a5bVhhDONhTsjaIs6lOMrwKH/4BU4P9hhTbPls?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: concurrent-rt.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ea1dab-e3b2-45dd-6cdb-08dab39d23b1
X-MS-Exchange-CrossTenant-AuthSource: DB8PR09MB3580.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 19:47:51.7351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6cce74a3-3975-45e0-9893-b072988b30b6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 590R4Bb5C2hox1xEC+ocyVO5m/i8YJI97l1iYe2z7TgHV1CYivwHcivG6MIjNAEOugvmev3rywsVgJ6HarAn9zCEIGl4EWFZgGFFnSLqONQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR09MB5906
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On Fri, Oct 21, 2022 at 07:08:50PM +0100, Marc Zyngier wrote:
> Sorry, but you'll have to provide a bit more of an analysis here. As
> far as I can tell, you're just changing a parameter without properly
> describing what breaks and how.

There isn't much to analyse.  For ages, 0x7fffffff (31 bits) was the
declared width of 'arch timer' for all arm architures, and that worked.
Your patch series made the declared width vary according to which chipset
was in use, which is good, but that rewrite changed the above mask for
the XGene-1 from 0x7fffffff to 0xffffffff.  That change broke timers
for the XGene-1 since it seems that, in actuality, it has only a 31 bit
wide arch timer.  Thus declaring that arch timer has 32-bits is wrong.
This mismatch between the actual and declared sizes would cause arithmetic
errors in the calculation of timer deltas which more than accounts for
the hrtimer failures I am seeing when running 5.16+ on my Mustang XGene1.

Only one line need change, the rest are fluff:

-             return CLOCKSOURCE_MASK(32);
+             return CLOCKSOURCE_MASK(31);

> Also, this isn't much of a patch.

I don't know what this means.  The patch contains all that is needed for
the fix, no more.  I could add more comments as to _why_ it is 31 bits
not 32, but I don't know why.  I only know that the motherboard behaves
as if 31 bits is all that is available in the hardware.

> Please see the documentation on how to properly submit one.

AFAICS, the only submission mistake is that the 'Cc: stable@vger.kernel.org'
line is missing.

Regards,
Joe
