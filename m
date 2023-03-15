Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA37C6BABA9
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 10:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbjCOJIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 05:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbjCOJIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 05:08:06 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2128.outbound.protection.outlook.com [40.107.21.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A7D3668F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 02:07:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAYdeW4MK+BAKaJ4sAYR7NH654uLrId6WSupBwOl8N/Swmip7QTXR5Og6r+qgiHNYRWaVNsNYPmmytMD/kWsC2onV7T+m6B12CaVKCDxmbreeWuu96cGMWTDsoTAQK9NVAftQ1jCEkco8PEr1Ujx30dfDpTjNpihnO5gHiNop+NyRbeY6DFpvEwCbCSpZ0WFQBjsY9HRc9K/pk22IiJUIwp4alHKWvClS0GlasEJSY1zrFshPLDhU3h2cQ8Lm23kuc/YAi5RodXEMaetogGZQZtNdZ+rUE4wH8bbPgt1dHeJ39mPgDzWTVp2Pz6q7w9jVKLSWHRqqL/1YxMJrTUxxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9SQlNs/lx5bXZF9x2SZgWTYWbfD4261wvwRrfeXYUXE=;
 b=gxxT93KnCI+autMcvdUKFoWRY8p03ZhwKrb/0Zt+YXfZd6ZCq91f0RISZaldPCEDaO/nZkDC+H1VLsWRdioOoYUpIMELQiF6fzNeZrMdN62Sf2ep9evFoYF7D7i2+UY1jXWBRh0vNY05NKBu6OgKBqRDF+Rp4qoGttjvTbEcF8EiJTxyEntT4sbsOpQHynPl6nCg9BT0eYZRq4sJrIS3wFHGWHN0BE+DP55GxlbDBpDJl0upaqAoo6/DrEa/6qdurGGnXm4qmxsxMRbObGPnsLwjV4wbdG9phMBWKpvxtQ49A/UzWeE41IFcL4FBoOlSBJXuuf+ryjumprrC95ljFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SQlNs/lx5bXZF9x2SZgWTYWbfD4261wvwRrfeXYUXE=;
 b=GmWThwWE2mgw/WCidEauBJOZfBrsxjbe5+Ud/XRIGDmjPNOntILdgHaN/uZvNgbfRX4MeivdfMS9rkh7aeMsGGtKTOM6ttDYRGuSmT3U0Ard/HVLRStrAq9LPPr5/kGB5q9JXbUEn1s+6lGb2Us2PeUsJyeqRbY5nhy8QJa+tWoznRD7Nd6IzbET5/L03G3nkA5uVuYfiUmoZAOW/G6PCTFxBSqQfwSNvqVzGhOc7okr+7QDEoCjY3vNUja73uMOaofkP7ftugke07KXbBKzK0BZNfee5BNQDTyXV0emvcSHOycr8/+y1Bcxd/Etekwf3R7/UeYsdfvNCl6eUZYBCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by AS4PR02MB8358.eurprd02.prod.outlook.com (2603:10a6:20b:515::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:07:25 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:07:25 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.15.y v2 0/3] Stable backport for KVM-on-HyperV fix
Date:   Wed, 15 Mar 2023 11:06:53 +0200
Message-Id: <20230315090656.4258-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0046.eurprd03.prod.outlook.com
 (2603:10a6:803:118::35) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|AS4PR02MB8358:EE_
X-MS-Office365-Filtering-Correlation-Id: 1622c972-c39b-493e-c4b2-08db2534b190
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UQw7cSkk+y569AwVw4CYJQvercp1YilUiPZ6OM3V8ClJuMyecvMLWLY4CbK0f1yi2JQFLw2ZLqHVFSo8JOXl0AZdNBjCErXIAYx+eTXkyDG0Mn/7z0T1OZuEy8gRlmme4lG830ho4pyUv1+P9MIArC+PVn1oxlUqlNG9UBY2uZsYaSjQHxmFtELA7yqEh3ufy6kO365GZEdyIV+2WJovbOB7mdlPMw16bv8z2CM73yGmmJvCXptlyouh0oSioBWkJUEOqiMSU/lvDfupCnG+jVApzMn5I6XZKs2Sew6b9264hvckjLpbzYXx/V6GT/HaGDYZViU3sKdLvpXpyerfjEGTwy1p9qIbv3sI15q94/Gqej+B7FUX5MU9uDRqBasxftxGSIHLSYpVQ192HqGFbSNwPHDTACq8kZoW1iNDnq/CkiQ/odlWSmaNzle+d+mpRp/38WWkL9fFnttdJIrlB+Ynw6kZWINBuEbNvzegeJZVAAKDUpK2OM/z2rncTBP0SqBkiuZQ9s7ZwD4mpE+2bwCgF5teNLDilxs8X1fskcO9Z5B4vrTCzYag0vs94B+noYZtirzzZ+D7o6ajFTRZL0Sjc4BJPitYMm8Neeath+7QDdWBlDT2OJAlXEfGfsWaZjgWVMOls+GzdNdpYDl/JA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199018)(8936002)(44832011)(4744005)(5660300002)(41300700001)(6916009)(4326008)(8676002)(86362001)(36756003)(38100700002)(2906002)(2616005)(6506007)(6512007)(1076003)(186003)(478600001)(83380400001)(6486002)(107886003)(6666004)(26005)(66556008)(66946007)(66476007)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zv9B8NymMeMTBoTIOBS718N9Z/e1IBQItZ+8kzzXjxdNu6Ac5/myWmx+gSJh?=
 =?us-ascii?Q?jKN4fUvs9MO7pogqs7ZlXLCf3aTdigXAAPIIH9FS54ReK05VX5n7sxuSVH/J?=
 =?us-ascii?Q?Qnej6ZSmRvl8pXTQPAREukLXXuiIisPJG6pNU6ZvUkUy+clgh4LdAS/7pg2J?=
 =?us-ascii?Q?gOdwrj/YyxdVlQx/zhsNjKjb+YN9OuM7r1aRl8m5cCUSyM61xKTV4I9RrJJb?=
 =?us-ascii?Q?aRLfObcTiV26sZByrsgtD14hwTi7Whz82/UIXmrFwOPy3WyasQL67j0pYVbR?=
 =?us-ascii?Q?Cr/4pmr6dPvxIzc8y4Kbnn9EHtyUnHEdYdvh0rdDKOwD46hek7cOjskimv2J?=
 =?us-ascii?Q?pVWy4QeupqhoMPPTSknF3qbldgljB9Tev6GvTlxcD2OF0avlPR+Cy35LuHKx?=
 =?us-ascii?Q?ruShYyI/W/cm8Z/vCAawI6XekvK/XJqi49G2/M9fHJbc3OnoO9PYslyW+3Qj?=
 =?us-ascii?Q?grROBXVW0xzO9eIuH+jf//Q3hZohD0sHpMZkF5egA2XcuNIRh0yCgsAyzA2r?=
 =?us-ascii?Q?n7oUjdCMvTHiz/HqfgPOrd2fTeo4OBD+/+o//pmGIoUxjZ9x20xppFVb837S?=
 =?us-ascii?Q?cYqSp0kP9eCV8DOSvscCrZNIc2GwDGvnVt9lvkWBH5wVkdqjQA/x7+P6n7HZ?=
 =?us-ascii?Q?8DzF4YzM1ytdCLaK3qB7ay8f/CDRtxcFlqraQOzUd+pIl3LZefdjbkBIRJBi?=
 =?us-ascii?Q?k/GdwYtLOap3H231Pa4t3tAmJLHCvdh9LaxTMYgBDom3zq4v44T5NkMjluo9?=
 =?us-ascii?Q?7cMFOKhYLjSbpJvFbSmE5rVrSMvX8eIjKB0N0X6hmNR9mMMIHFQmeQMz3o/L?=
 =?us-ascii?Q?OMhxIirNLYpakkaKS+tho7vYto9rfOCR7lRHePjPfdOPpnxNbJElaDoFS4FV?=
 =?us-ascii?Q?uay9Ivf51w2nn9JU1tV7fbnOR4b4GP44fBADcA3UtBzGzXGczto5oGrTlqHd?=
 =?us-ascii?Q?xemC4Ky7S8dVDqk/kqj6zKgtYbtzyXn5orIdFsrh7/hTPPnnq09W6UPBD7CV?=
 =?us-ascii?Q?Ok2crErCFsONbTQUI4tOzHp3sC/w2hj68XMrkdCC5EaprgtRYb17RvCLAofh?=
 =?us-ascii?Q?j33gijOomJTt5X4yXHXGPI8dKu2R2pv6TZ3/Dyu3UCRjFVQb7CNcWZeI1Sqp?=
 =?us-ascii?Q?/UGMQsfMg72Tezl9YwN3vYBtgde8bzPNglCjJ87q3SdPJNVBOo2zPdBz5+1Q?=
 =?us-ascii?Q?Bp99IhbiuTt0WTjWo33otoguvIObJuVJ5htw008xqTT+mgbf80JLgGCu1CwB?=
 =?us-ascii?Q?B1f0oVrOtuMLS3XuhOFDAnXKdab+mmHuL3R4a+bJjXQYr2Z2rXvtFx5aQ9Mw?=
 =?us-ascii?Q?nkG7jkx4NwVsF3TS0bS/08CKsAm6ea4THijIxdRY7LZZPNhIm0hATGFU88gg?=
 =?us-ascii?Q?bewYkcCiJUsIh9cBK81qe4oW5gYzrpOKkbraG/DtC3Rc57tli/9+X/c8LIOm?=
 =?us-ascii?Q?q2P79hDERFZuW7ozzCPyX5WTokJ3i/YDLVZQFiMfqqHc1MoQVnO07nc/+hi1?=
 =?us-ascii?Q?6hnrK11zeNT4v9/SUdxU4Cz3qB8JlR5F7Xg61b9M/3fN3CdK92SkSazeXpku?=
 =?us-ascii?Q?FAdeN2K1EL7o01ErB+2x4mIfv9rdsPe7QhQ5lmyEFodjKWRJJmgCH7/MAiBc?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1622c972-c39b-493e-c4b2-08db2534b190
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:07:25.3138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HIFO1Wf590RWzgCsNL5mDhKNNmrSowhyhuwYmVTdQ5HSxsCORRHYm34WnqUDUmu/q/LecmHHfKxcJHOK/aZyjINKX5nPN/Xn22ruRXZXXvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR02MB8358
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

