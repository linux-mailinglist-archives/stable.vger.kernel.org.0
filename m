Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412CA6B8E71
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 10:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjCNJTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 05:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjCNJTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 05:19:21 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2114.outbound.protection.outlook.com [40.107.249.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581529663E
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 02:19:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6o92UczIXXHKW2YcrzqzuRz6CAEpYSS1jwzpVKyzxh1XTB4uq/JtY9QeO26zE1Pv6z5cnqaRkmXlqJcsO/nq+tpBpW9IJNMv5uOUQFG1pBhOpNiVQY99w9Qi84VI9oiNwtkrOnhXhBlu1Y+scAx+sum1Hl8v2qaWUSz4jeSnBbDjY6AQilabnFYwstTENOqBZaooTfyXfQNfCuUBB7gw8T/3uN9KO7Upv+Y0u+M7PBQkLzRKyp+UmN9pwghsPxg5Kuezs9dqNxC1Tk0xBtEj6G0VNkSldhm6uS+g1fHDwjSbG5yY+7fa/SempbCVZAQ9utPwfq4CVbGQiLLWVWdNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yEYm/sTLEadVQ7wO2UW2GN2K/KiGy8LC3pNIkLHwsA=;
 b=Pn/9fsAHSrxc+fQk7BUJ5C0mUM1hqLf0eBI1PIRc8TFL4NCZFNUj52bDq4ggFKVe++Q00aRSNGOBcwZVQtW1JAYuD8BZdsQjy6OKsBcupHcGMVabm7NLdVahET9WRB+WN0qhwDS9g60JQ3Pyq8BpztoDuuOy+ExB9E/SzABhKCJ/B15K0JXa35kjrQdKd82vgCLDgg44++N+4pY+L0NbBm0pq0ZIvgHmWgQU0th1F8sKqrkrLOKxrrjlj80F/INaE1stXA+3y0uiC3gGyTWMTYDFSKPUecEWCGdjMBAyc3ht+LGRsuCvkgW0wMQt6m6RvYykbpx24Xkfs0IcZlzAlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yEYm/sTLEadVQ7wO2UW2GN2K/KiGy8LC3pNIkLHwsA=;
 b=pgA/gWOTEO2BZSNVgEKnYV6k6HLJO3r9/oxj2aCRql63M29R+RZ1Cxsz29hY30xtR63G6ac1M2HysLMPbYK8SzaAWhCS7Spoj2ff9Ro04Ykl4/Q7/DjB4g+4S4+Jo6YMGsqmsujA5F7KZ3s1+ooShFjyCaULrgUr2zSw7BQr2QEjJiCG/nxInka3iU+m5XlFqY8TFU1o4LgjWkODJ5WxpEI+wTzXKgfJMl7ds/keaLRmgxieLTodf8dupB6rbfpNXQJ3kZDm4G3RbXF27DbrmAAFG/18/8rRy0iXhySrJZd8DUYTa9u0WqGRQE/mlhR0cu0uZlzIg0XOKJh5fnxLUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PA4PR02MB6543.eurprd02.prod.outlook.com (2603:10a6:102:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 09:19:16 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 09:19:16 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.10.y 0/3] Stable backport for KVM-on-HyperV fix
Date:   Tue, 14 Mar 2023 11:18:58 +0200
Message-Id: <20230314091901.2975-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <167811889022881@kroah.com>
References: <167811889022881@kroah.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0050.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::39) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PA4PR02MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 26654731-f480-4860-05fd-08db246d2ee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZkS/j2AFmwqeZgH/9wmELH1LcdmaaunVDowu8MZvav2ikgtgEW2uN8FePMvbvB+tRVnqEly4Z8RKT0piCNlj72wA+nbRzeg7HXYu3R+tiXGx7Vd/Denh73Erqreo9z4H89djL31KYe4L+2ffq90wrinjHXKF9N/8crMpdzc4bR3O/RyS6QN6bSjuPTH+QWQZS0xVhopIDkSob4pAo+XyZL1jK92AeJdJS4cwN+JUdD8yefdnBkQU0m5U2iwEcebpLHluBEtoFToBxWyMDVUMZqRBP+Q8TM1ufIWkE4yVJ7L0c9lrp1McnR9zIEA7Pw3fql8iDlFxFQCNNKOu/XzBLdrcjFZG4Zw722RQl+oc4XofBQU8TvuaXZ6XX7jEbBJ7w7LY/rTNtmiLeEPsyk952DPQBDdk4ZPGIk2JGAZFOUDFtM5k0ECBJIGqmnDEhneUdXW0wrX1UJLHKLGQzmA8WvQWXVMuDgjExiFStJr+5C9z0t2r6H7itWxtWED7UfwXFjGS40tUWVD9VzWJ2lgO+msoIqJaidCev2JTYrH3shkhS4N1JBSONJiS401+9KReO3VAEnTZSZmRZhGs7ijf8/edUx7Jfg7HCEC/1Il722RijyjXKT+7OMqoqyZj5U/It6VX3D9w3OjupiRkx4Mww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(5660300002)(4744005)(41300700001)(44832011)(2906002)(38100700002)(86362001)(36756003)(8936002)(478600001)(6486002)(66476007)(8676002)(66946007)(66556008)(107886003)(6666004)(6916009)(4326008)(83380400001)(54906003)(316002)(186003)(1076003)(26005)(6512007)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oa04jUXcM5+iBWMWNYgbySJSpJC+ydHtuph44cg39zy/RNihZ+UqtHqTQ4Ws?=
 =?us-ascii?Q?RxKqNvLxRTLJmjwYstfaY278ttZQCfQ4DEmVuxfzRxsfksIloWc6xQWbIZ6C?=
 =?us-ascii?Q?lXSHv9kitbx0rhJynTMiRoaedNBLzPPj3CVkTgkwPfhEhyay0fdUtkFtik7j?=
 =?us-ascii?Q?sAvZ19JFYQBjnjKo09UPq65ARGMGHhjQjAcuOEeBlgofCRvbAf7wYFp2UT4y?=
 =?us-ascii?Q?VVjpOQIv/VzB0UmY0r6ji0EAvYuGRAciSebnsXu1hHSHG8lh62yLEvZyFpBU?=
 =?us-ascii?Q?7gDCeXUHtgeraFKYcIyP8DOJq9IhPq7slqKbzjlOXU2EjagrWVTovPWUf2QD?=
 =?us-ascii?Q?Jn032z28izfzrJ9N07x5QRexr15W6JTJQ1UD6K+ZpQ9jAa7+QTbrRIQjkIc6?=
 =?us-ascii?Q?mlY2UrGykKRWeOVlAUGv76qcSp4XvayWOONcjlMR/csLP6oDtF3+mciCcbkr?=
 =?us-ascii?Q?esvgthFWbN3eDP9BCTE1hudnwxY9Db7C4mtFf6k9qy0fgr4Gjg7VeFWakgV6?=
 =?us-ascii?Q?2os1s2KfBkHU1MfWJ3F2QTaNwg0/ZpA622E3cBR2G+OFvU2g6jLTrx5PHUWs?=
 =?us-ascii?Q?/QyP11hPF8IwaQ5OO6nWNa8wW3CEJ4PMMS7AYBBS0QU3QPmVuKFEj3LHrh6L?=
 =?us-ascii?Q?cdkE08HyMHx1jy+cLq+5zGg9PaOx5GwYdiOMnyyTxl/2bxXNFzd9MqJrLqtv?=
 =?us-ascii?Q?N3xj1rjpsUEFeSAEa/p45WeMfpGbPNNxhfUhMstp1u0XCEcx3WsLEURgDhEl?=
 =?us-ascii?Q?aMGLH7WGqcGQsGs3tz/QOh5QElNpbSmgpKQC2XHBk4Vq1mRR3jnLKvM3VS92?=
 =?us-ascii?Q?/1NXkvcCo5CPCc0tOwbgqiUptv7uHBsp++UoSoOMytShefv6uzYNBzZeszOx?=
 =?us-ascii?Q?tReLOY6jKT6qqw9k2iWyGOmAWBDnBLDLg6+Y5EmPxsP/nxzsnI1ZG63FoYDX?=
 =?us-ascii?Q?cNuJve0fohrSKzm0hyzY07dizYVe+nX0nzfBC2MPbqqzugaN+XeJBj3IQ+pl?=
 =?us-ascii?Q?MME/iJzNqxEBUO2R5550hgzr1xmTneZJajbKZz9xjg1ULNg99pxNoj1bQrJR?=
 =?us-ascii?Q?HItRXaDrL4H28vCF25bPA9rWQV867iQxANGKdgNzlgmmpMMXqq2P1CaigvzY?=
 =?us-ascii?Q?PzZWvQQMNkccgOazHCinqZM4DMXl0EkGo8bRsv0AqU0yMcCZz6iGFu1bRpOb?=
 =?us-ascii?Q?SdsVii+aLVlQ11X3xrBM8zKVni4/WGEzNUqgdbnHS+7yTJVbAVFy6ooF+nIh?=
 =?us-ascii?Q?it9Z0Wh26r6Emv5HiHJvzMw6YFVAR6PSL1KHXAudSayrvc+MOL300nXl9hc7?=
 =?us-ascii?Q?TYNOVvzh9U4ikqc8bCEunf6Sf0JC6iGQrMMlcmZCXzyLAtQwOAWP1HXwehVf?=
 =?us-ascii?Q?GobeoRAjywbiq6JIaJddCY6x/IslwznDx78kHW63R8fCpKqFsi6P+NQATtCp?=
 =?us-ascii?Q?GQpQXjLwyq8n9YMC9/XJemWjFpvAoZCWQSlFBtWwlPgk4B0NicVklL8ofh7U?=
 =?us-ascii?Q?pDULfmzO6Au4qo0/mVOT2kM8U4kyKjM6sY1niTXEJpsFj1901zHFVcB2Q1Hu?=
 =?us-ascii?Q?PUOo+c5LAEizKfhtZWP4dlJ8ppSEFn/qqGJJGpTijHscRvc9dYjVH7oF/G9a?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26654731-f480-4860-05fd-08db246d2ee2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 09:19:16.1844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U70AwyXYrqKQgsCn772Ym9iisf6AQ96EvWSyNci8YqtjNa8HG48xNPoa0Z9ZpmF2YYd2jWare54uFtHmwRIlsmeOX8cnqFoiXgY51Tn7iEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR02MB6543
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

