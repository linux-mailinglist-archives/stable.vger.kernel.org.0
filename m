Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB586BABA0
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 10:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbjCOJHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 05:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbjCOJHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 05:07:21 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2135.outbound.protection.outlook.com [40.107.15.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEA47B4A0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 02:06:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCaCBYBLvfOyexMp0I0a2FuNM+ER75xx3im7nLFJEUQj5AJrHuhGBPcl6sCIQQIQEwpVLDeRapEDXnuIr3u9T3oejk1QsWKK9mWq0IUNABZFmNwDHMvu+/frXdbwqv1rH8ClrqoHUSIyXT7KJTDQrSB2fjb5ms1xFLqKAac63gyzxwCYiOQWVUExDnDi8T89kaHV3Os/I9Zb5JmK6DkdFJhejwTNLhoI5dNfH4Eyo9ecvTheD2joNOGnqHfcJyU+UgL4DDzK4zUOz0JQjeTrA8SMbl6/cSbuAGVfT0JxMc1ao3O352NwILC4SLHjY8gAWdkWmgAsYWxeUDM3gSdDyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9SQlNs/lx5bXZF9x2SZgWTYWbfD4261wvwRrfeXYUXE=;
 b=U6ZQvkt76/IN90JuDcuttNor/GPdAk2u8UhSsMnNyBSOJnKArN18CPZjDhKksBljFW/LBxoRZ5r5mQThjGaZrfXslsHRfCyocp+SPwOeeVWRIrVfqes1V3U7DDpONnxWeJNAVUixsMG+nnYO/uaNStLXfdNBlKcAmDkAPmawkZvjggcbwF3fLpTVEhoO+av12kVx1Og66PeqSuvPRbo+6QarGtwyD/Qd0NlE5j4DFNt+oSwghhtVbIHxpExFDwmyzCk1u37J5CiYb45ttxQ62tUBsqJ4Q1BuyaJuXW4ARgTW9hcN5/GefDhVlvlGGwGcMALai8y+OEMz2je4eFl4uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SQlNs/lx5bXZF9x2SZgWTYWbfD4261wvwRrfeXYUXE=;
 b=Nu/KwiLAntqw3r+TKjqgChIoJ6IWed9FRZyV/ipaHJ+ph8k/o2mQKJqHqqsELAy7hXZDd9Tjc9tYFhyffasFPk2jBHSLfGsr+IxuMwjUk3J3Ev7XILptMxUS/3PwgCxgqv1A1/ojkPjsnLG2nN3ynCzvaA6XPs9HqZfslAVS8or2MkiPLHNvhkRFedNr9JvJXKsDKQhcT0sx83f8D8lOxZaOh0BJprnBFhsucSpY9L4ciqHvoPS7pcJb19y4K+3AIHFXAIU4+7b3UT4RQxtsypaZXAaWx9ed+PHo3WyFcfOu6YvhYN+zYSNjzCC3XaPuCPZpw4HriByJhpToEb99hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PAVPR02MB9866.eurprd02.prod.outlook.com (2603:10a6:102:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:05:55 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:05:55 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.10.y v2 0/3] Stable backport for KVM-on-HyperV fix
Date:   Wed, 15 Mar 2023 11:05:25 +0200
Message-Id: <20230315090528.4180-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0105.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::34) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PAVPR02MB9866:EE_
X-MS-Office365-Filtering-Correlation-Id: 47c6566e-7817-4143-1d02-08db25347c2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zkw71v58x9bgHsHA/n2jZJSHNhPCKJl6JqXhAjPIrW+V9SszRjlVXYpljsYR3f09ms/QLcVXD+LQ3v6T5croy8pie9rE3mReBqShVaGtB3HOSxRUhZmL9rirZgozdN3/z8xyQE6toWnQwJe2WFweqPUOl+Qp7Wu86hqs4byF5tlpSBncO/FHLU7gQjaFhJL12x7Sw+Vwu7M9vQ60Ssn5750i2N8lST3GbaCp5ZcDLtFoocM9mi6fctZFGMRh0vpc9XkoIFpLa9RTjNK2PnziIwXh7e5mjtupBcsDayYQ5E90IMRedNSF1DRdob6sGc4lLhWNRH16f+YU9ustB81QCpv9csKw0WEWsLXBxe0vlpdssNjeSePzm0S8YU92lEgyScd7a8rQVIc/O1MvFN4Ga5LCiZEuo2ODYUk1UnwidKuGZTgfOIQ0ERx4biQOgmfx/nacp2E8rEixUsA/nJJ0wJtfqD6pik7z5v+td1exmB6y5WViY2N9F6R7CS1U5cWY9XhXUM1MVUDsaEHaFd2tOrYiouoNMJrqK0OH2IS5TbJOR84wCfFe10zTQcjIxGjyxlbHwe6GZgO5hFu0Le4kO2GlAQou+2BLaKdjJ2ue9CJvwfoYDncBLmBx1LMDCYNOTrhz+rujTKnjTxWGmtf2sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199018)(316002)(41300700001)(66556008)(66946007)(66476007)(186003)(6512007)(26005)(1076003)(6506007)(54906003)(8936002)(6916009)(8676002)(4326008)(4744005)(44832011)(478600001)(5660300002)(36756003)(6486002)(2906002)(107886003)(6666004)(2616005)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ttR9JksnRBaIRQvIyhleiKPHdFTPeB7JO8WjF2aAWsmIK+5mONfBnogKbGWe?=
 =?us-ascii?Q?gYKIp/C+7W2cWGOqabql2Qjfn8FMbkos+kSMop+t9n7f+AiQ+UUPRULtTLC7?=
 =?us-ascii?Q?R9vqr2PHBjmItbXrKJOe5U9frudNM5URUq5KU0uAov0JHiJ9pO+GOrMADWbI?=
 =?us-ascii?Q?O2HGcb2eUE4GQb3qD06D58Ja2D98WM4ktayheSWjEs1FqrIbMzI4LWxbz3Ag?=
 =?us-ascii?Q?otrpzyW3kNdZ8dtQSgU3MHfBCUh//AxnCGaIHTxjp9+qP4Q15jcdFfu/XoHT?=
 =?us-ascii?Q?JKymayjKidtlrWZiZEjNbFjUl+feSk3kFHNTJoOjai6qorQ0o7O0MoYVeXCC?=
 =?us-ascii?Q?y7yuSeAGbOH5EOREEDSqBk+vKOq3i4ksfizAwug8UgWXFMjtZLzDVES7Yf4Q?=
 =?us-ascii?Q?DaRtQVtZD2MA2KnZRUWydiT5/kMUc17vE6Q4mL7/S7RwUcrK622wDJpmQU/D?=
 =?us-ascii?Q?FfNOjouMblC3d62uDvnkNgCPa50Oba0TQUs8bmRcn4xXWjtWR0FgOWgMyx32?=
 =?us-ascii?Q?kFSnX1fcS8c73IaBCocH0Fbu6LMSiRCLR36UdmVzSB8Jsc/vCFqnLh87dhvL?=
 =?us-ascii?Q?Nb3lVhdElaFLYjkmWOP/fLBPhmI1iitE4dp15WEn5P319dAqqcHGK73qYOSb?=
 =?us-ascii?Q?6ahfapyOwUrgfv7uX3K5INI2SWH7Y6xY+RfvtGqFR3bOxNVe3PkisSDMuBwu?=
 =?us-ascii?Q?BHjXbKr+iJk6rICidSoooWZnLVCZYzu/vFA6oZPUgAK1877479gKHulPJvwF?=
 =?us-ascii?Q?DsOYksQ/bRVHp55SD/FAmskb9BgH5gEjc1YpIEv+dljYbKNjtvLRVH3EdTB5?=
 =?us-ascii?Q?M5UheC2tax6SmLlI3cyFlIVgv+8c/SltUPMZEDijB8REw0QhHU+uwhqFzSPu?=
 =?us-ascii?Q?bDEh5hySHIMaZUodqgQxCNfQUXOElETwX2w3kmxEWS7+/9mxdhKTqrY25KxM?=
 =?us-ascii?Q?Y/EFjCPXmO4ycRQEup5nYkMjvD8BrP/77z7aElMv5MoKgKs68LDvkDfan2W/?=
 =?us-ascii?Q?xJ2fmveCPiyX7BZOPF7emIudotO2QIWYMIboGozIPrHzIWMHbz1cLLCU+cLF?=
 =?us-ascii?Q?S+n6vrwd/9PVDTQSzDuzpfmXz1rU8nXAbEYslH5tKpaDiqdoU7Rx8uzuUiIY?=
 =?us-ascii?Q?cdV9eVCXULaxBMZzfwlYvoWsjqDCjUhhgRCP6XHw1C6AWO4ooSc8dRBLmPqp?=
 =?us-ascii?Q?cmocnQO99NShMKqv7H/PIi2t2W/Iybj9jgLoSMc1PK+25AZUv/weSXLfoxGP?=
 =?us-ascii?Q?dCYx3yPLT9HqcsXwJNYDTH7c4POPhB4Y9PgCXtHJKOZqnPbk1nxcmhdrCkKM?=
 =?us-ascii?Q?jL7DSDLNW2BGj6QllCzHft9VIqzIkimK6dgucVrOqkKqdoIKvr6jidMvd5II?=
 =?us-ascii?Q?a/iAQIfjjSIqp6qqVyPothaSfGPjigL9MVBlQdLLwVwEh3q4kHDV3FUkClPE?=
 =?us-ascii?Q?Bs4V9rep6z9JNhMfPAVn65MjiwfEx1YGWFLAKzaT3nkVv228nEoarmNnYfXo?=
 =?us-ascii?Q?fasKiSVbUN9qdEk91lGLVf2NymIpyJ5cPHLfGPhq9poCGbs3/AhgqJaOyHhY?=
 =?us-ascii?Q?n948oHw6EAtHPa4zdITv5oGkKAa5k+Jc94mzPpAh3TiAKN6wNkk0BpLBRaJ3?=
 =?us-ascii?Q?nw=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c6566e-7817-4143-1d02-08db25347c2d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:05:55.7259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vexwmT1wOK9nfaoY9Hfyio/j8hhPNeidrduoj2IZHJZRhz7q2xOuM+nQCVc4vD/94r7fZDSn6VVdXLWhXV/2D5jArpCth5R2azJy3mAnEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR02MB9866
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi folks,

Here are the backports for enlightened MSR bitmap fix and two prerequisite
patches.

v2: signed the commits

Thanks!

Alexandru Matei (1):
  KVM: VMX: Fix crash due to uninitialized current_vmcs

Vitaly Kuznetsov (2):
  KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
  KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper

 arch/x86/kvm/vmx/evmcs.h | 11 ----------
 arch/x86/kvm/vmx/vmx.c   | 44 ++++++++++++++++++++++++++++------------
 2 files changed, 31 insertions(+), 24 deletions(-)

-- 
2.25.1

