Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92173375CA6
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 23:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhEFVLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 17:11:55 -0400
Received: from mail-mw2nam12on2052.outbound.protection.outlook.com ([40.107.244.52]:20879
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230037AbhEFVLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 17:11:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhzyBnThMh6xKl3o9SOSqZpnzbcF8kMkvN0qOjkwNegNv+tAdQNtVZdO/5sKyX66dLdMMf34D79S4m2S0LQ9WAn/rdhnlMLuqW39qkzVGPgFlqBybe5n+TmSLUc/nLPK3hmWJhonYAw5yaa4PL1qzgsQjFWIj4cMVop4Zt/AR/WtUJoCCsSfoxM0thYdIkfS2ZMhh8sdA7Z/+u9lhPtRPqlVmy7u8cZwaBc3TOMl5UyfUrbRQV1+ESUHFIen1K6wr3hDFxarXJlZ73dnHMdnUICTpEtFsNqFvQ3swugcX8F5f3E1RGGXc9MQMmU327hOpZ6O0rHV4TGFXVHwAbZblA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7u6+MIFLSEtWl+ecOXTqXmJ4Xm44pRV44S8rKk/Xnk=;
 b=lHWQse198N0hGCZSIxR212MyxlBJm3KnVKFy6VVE6m0305gXwKHRLnqGnk90w97CN2iQgPETH/iQvzkpInFMLInNzYh1eem6X0t62z5C5daDamPG4FSnFFISy1mSN2M69oKcAxHFBV5evnzwtzpAFgMtluQpluhJzsfOwbiGCUzfAaap51/jd2LP1eOqTJTRTgXGlryIpdkp3/vpNTr8ORDWLrpDdku1efVOy7jgQJgwFbL+yMfD3Q2ludSiiOA34hofI09V7h53zNckinoKEBa5UXnZx/4cWJcCoryEmJc3rB2j4Oe0a+lnggexq18fRwaUmnqwxFvGebDG4AzEBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7u6+MIFLSEtWl+ecOXTqXmJ4Xm44pRV44S8rKk/Xnk=;
 b=WV/OaZFjPeGVpird0I+5Jbwv/Jiay5Gcf2N4QTvfAacGLAVYkUK4T0G8hN08Vd2psOrS0JGfzFevXMRjbeGPEoivQNLsAik9D8611VQcXpXp3WF8cIhBe2ajjOXxUviiWTAF94VfEfrGRwG/0EwopoYtvC6vg9iL5oXDGARqNdy6x53HOArgtCcR3FTJ5hhVTDrrx0tr+irmJrhoC3K821hXOuFZ5CX6PzIGAUT9eJL8aBOJXLkINOlmyq6tUJ+WN2hI8LnnOZkh6x8LUTK81brBQoVgz7F8SCBXdT+iP5Xtf2tAA6vFa4hD7SHkzrP3L0hj6mNDmZikpwT6vhbpSQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 21:10:55 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 21:10:54 +0000
Date:   Thu, 6 May 2021 18:10:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.11.y, 5.10.y, 5.4.y] vfio: Depend on MMU
Message-ID: <20210506211053.GR1370958@nvidia.com>
References: <162033393037.4094195.18215062546427210332.stgit@omen>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162033393037.4094195.18215062546427210332.stgit@omen>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0441.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0441.namprd13.prod.outlook.com (2603:10b6:208:2c3::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.12 via Frontend Transport; Thu, 6 May 2021 21:10:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lelGn-002XrX-Hl; Thu, 06 May 2021 18:10:53 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b34ef63-9370-4837-9313-08d910d36f8c
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0201:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0201D44C725B99528C8C6B9CC2589@DM5PR1201MB0201.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UnOH2NqpbbIjEc8IJErn8uJjFOzbz/4jTx4VDc7cUVehu66elRKpdQIFbej3xgDjKbeswFH0qbzE0V6+Eq6gfEbkunlC/MDrOM0FTomZO5BH6EJ23ND2MnWU24uwQvL+sZCx0YtmtWDW6XGXGDeJrIHKgn/z+cn/d64IK1rGLjiWuRDm9UVjFeSmikSvihZdAS3+1NooYAiAhAvP5OmKDxb/LMcCMEvQ58OuK1q10647KeRPA82GXNVj9lrdJzHdXSKPm6JPONaOP56MT6tn1Cf5SWF18+omoOWu/oxdscUh+PXdtuomZwCvbrPE0ZXxEooqTj6O9pxnxgn0ObO9oa87sTqC+asf/ezoVvzJXXH7rNvcnkgMgkQ4S8Iih3DX4uZqo0t+6V24uUAczqcO2O8n9x6ljHE8aILyEp+xqygvh59qgC5EjvX8yiVa9vb8wMISFNeEM6fwgTfy4edA2LMCpbAX8LJRRvt18WJ1WTcdfI8gHepLtKERpNyRltIqNfEqFA8IvWyD3UiseHqnnD5uwPKNByZR5IsaFDQUlE1IDQbSUjijFRsIhUyK12/IOd8SCA9tMqOkrliNDJ6KJXL5EuoXR7vGM2Iw04vGX/o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(66946007)(36756003)(66556008)(426003)(9746002)(86362001)(2906002)(1076003)(9786002)(8936002)(33656002)(66476007)(316002)(26005)(38100700002)(186003)(83380400001)(5660300002)(6916009)(8676002)(4326008)(2616005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vj6LWa7PTi194bw0rnlvHhNCBl46E/ezsLSEL0UviXD2bpSgVSqCU8HniAPQ?=
 =?us-ascii?Q?Z3xUCWX9RO+ppeKVPYFe+IolnwRydPcw4cauhIebeRIi2Ui93CuBHynpBVzD?=
 =?us-ascii?Q?p6stkaX4hQJzVXQfGaMCDJyjavLWYbbt4sWfU86YMgi9gFBINDmBtWE3C0my?=
 =?us-ascii?Q?pCx1l6ZOpAknQ3LwOEykSQSD2AWvmsxkRlqEOiA5uHMlzLkC6P1hhU+4o+sn?=
 =?us-ascii?Q?lxcC85CbuDPEUV2zqQL6zeP0pFicBXEOcb5Kh8at6u/eAp2ypB9b4nFHupam?=
 =?us-ascii?Q?/vLB8hWVyU5g73pQDaK3qAPv7mgDh/LO+/OHOEuIAzo7xV3uG1EHpJbfAP6B?=
 =?us-ascii?Q?g1CgBK62DHcvbof1telpb2qbS39/tDz6bk8YRqBZ6fJQtjHGmw2qX2IZhY+T?=
 =?us-ascii?Q?zlSgDBvjyxWV94nriGswJaP5GDft5wyySNVVHd1oTFkk+/Cg9bt2kvXPU6mH?=
 =?us-ascii?Q?uykGb4M5NjXunKdr944Lu5AENcTPJpFY1BGdclBIrKto6x3gqnsuKuR8ahV2?=
 =?us-ascii?Q?4WNOu90OmeEIfW/EbcypcR5TSZ+PSexsAfCO1fx3e2ch3GgoPcgqjgUwZ6Iu?=
 =?us-ascii?Q?kng1uGkvQteXbICnOsw5S2iIBhBSYqVNRivY9FhCH+kXo3S/pr7069XkuTgg?=
 =?us-ascii?Q?KiPyzCT2w29OjzRFiIEGhVZIE6uSbqEx9darDopDZ36gztHbMNk2Qfttv27S?=
 =?us-ascii?Q?LrDNyQK43aagY9TcI8p3PP6SgJ/Lc6600fUY3IWn8xHcg/ENT+Ti3f+Ep3FJ?=
 =?us-ascii?Q?v0QdGLlyphQ+xBBjSuwaSjWmJh1r7cRgHES6b9fVYOCUsJM2293zxCDKT/5Q?=
 =?us-ascii?Q?o8bIjZ3ZtA4Jq6yxlQhVmeBc+kp7HNf4kzWVGqsv25k7Ut/ztRuzZGYsNUfm?=
 =?us-ascii?Q?C0WPTtpoWrKfjb9t1J/AhW9XLsJu9EyTwllE4hI0MbJ1igCCdRafxlpYgLXh?=
 =?us-ascii?Q?Ki2IC/SAXazlrdNm/rsvRKEiL6Jwi9n+KTTe+nYjEtzDIYLzw4hKZNzz0IWr?=
 =?us-ascii?Q?swdTsrTqYirVfQ/er6kjk0hCdh4ZmopYxMGjWBpWeosOPWt3d6EokZlmcg+/?=
 =?us-ascii?Q?O7lZk9kouJl82JtcSjqsoCiLI4tU9vroupq6X3UhUL1fU4eG/jOEJObX+9Jm?=
 =?us-ascii?Q?jP+cJJNISgK8HMoQdjC2atuHL3Kc6cQkOiygBGxdspwk2l57pFufHGoPc0wO?=
 =?us-ascii?Q?232OPF4VTaw7uVOhasiFiZjMST6PZLU7V+W8bvZHn3y17X+6D7bOxltfU4ON?=
 =?us-ascii?Q?8piuNUiH+nYwrhEURjWbdJLtajtFmHj3GLJpJST33RPDFubFR7yTxa59hjWU?=
 =?us-ascii?Q?S6A8Hxe1lugCMfLVPMwEyGqO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b34ef63-9370-4837-9313-08d910d36f8c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 21:10:54.6602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c101MfPhaLPhbAFG6X1CHL9X3Hh8d0TcJO/h3hddXcuW8mZaoB67Sfdr9L1rC4kc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0201
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 06, 2021 at 02:47:51PM -0600, Alex Williamson wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> commit b2b12db53507bc97d96f6b7cb279e831e5eafb00 upstream
> 
> VFIO_IOMMU_TYPE1 does not compile with !MMU:
> 
> ../drivers/vfio/vfio_iommu_type1.c: In function 'follow_fault_pfn':
> ../drivers/vfio/vfio_iommu_type1.c:536:22: error: implicit declaration of function 'pte_write'; did you mean 'vfs_write'? [-Werror=implicit-function-declaration]
> 
> So require it.
> 
> Suggested-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Message-Id: <0-v1-02cb5500df6e+78-vfio_no_mmu_jgg@nvidia.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: stable@vger.kernel.org # 5.11.y, 5.10.y, 5.4.y
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> The noted stable branches include upstream commit 179209fa1270
> ("vfio: IOMMU_API should be selected") without the follow-up commit
> b2b12db53507 ("vfio: Depend on MMU"), which should have included a
> Fixes: tag for the prior commit.  Without this latter commit, we're
> susceptible to randconfig failures with !MMU configs.  Thanks!

Right. It would also be a fine solution to not include '1792 in any
stable branches either

Jason
