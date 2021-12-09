Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1221346F687
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhLIWNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:13:47 -0500
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:14239
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232333AbhLIWNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 17:13:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ka0b2Yxt2y9j1CY4JgU2QeKsVIcFhhRze4nJnjy4DgtiYr1QcGjxAFHxlSTCOOA0nCI6AkI5CVDHmIrfNDX/jZYVhEjLauv80Ry2UIqMLbQfAaMrmVgylR+XjmPk7chl0j7s1ChstguDVJxYVWaAVxVKcGgP8vHmjTqtXfKgm2Qf2ozr5sySVQ34sYci6JQMM/O18NyajIMaa6w7mkchjl1KeHQywKJ5J7wXWhnOTMTyv55R57cY1MdfY2l0+KU/GxWOA4sYFlzlmf59232CeBHu/Xe4/6/EUhlyY6Q+Mfe6UAReVd9DtLG9LZ7sim9Ui2J9nj9+G59oH/KfQvGa4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHSksyG0wc4z37PrA081HnEmqGjyMgJxwhYyqnPRLqQ=;
 b=BISj8d0voJi9/KWpvroLUSmMy7aGQgbXdfq8d6I1J2KUXR8gP2cwAZDlIq+0zD36CAV3n5d3C5X+qGonxA2m0cd1jHWJOkf7ir7JXmcJz+HbEFY7xx/sSTeToAODar7OvN/qj6rKgWfg8iYlzAo8n05E/zmJX09UowF/3J+fcaVMt7JSGDNeTbi+gaplRBs5KnPACLuNdqdNcqCxEbslHDOBg7OQM9p3mdhphUfbFZ632hkdyRJ3lvCJ1DjDLD15Hy3gKqRYkxlcKuoKybZ49kvzn9hKyWReJL68JqekGct4vx08BgYqky2wuTgcZjl9lHNdvkD1RmJ8Z28kTAm9jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHSksyG0wc4z37PrA081HnEmqGjyMgJxwhYyqnPRLqQ=;
 b=dJ7G3yEtTq1JC9oFY9YWkXrw3TctqM9G1k6qLCv/f2eqokpUqjgDpo9G0Ta8PBP71Bo4fsabEfQDwDs1LQIvNX7Es1P4IQ9R6ju5Jqn6CoYIKLshmDxqvmfOhuau2vEhlrrVZX3LlvOfjRLd4UPBywJcL/KwHri3RVnSq0Lq08s=
Received: from DM5PR06CA0072.namprd06.prod.outlook.com (2603:10b6:3:37::34) by
 MWHPR12MB1439.namprd12.prod.outlook.com (2603:10b6:300:12::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.16; Thu, 9 Dec 2021 22:10:11 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::1) by DM5PR06CA0072.outlook.office365.com
 (2603:10b6:3:37::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13 via Frontend
 Transport; Thu, 9 Dec 2021 22:10:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 22:10:11 +0000
Received: from jz-tester.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 9 Dec
 2021 16:10:09 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>
Subject: [PATCH 0/6] Bug:211277 fix backport for 5.10 stable
Date:   Thu, 9 Dec 2021 17:09:50 -0500
Message-ID: <20211209220956.3466442-1-James.Zhu@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c325111c-41a0-416a-5909-08d9bb60ab1c
X-MS-TrafficTypeDiagnostic: MWHPR12MB1439:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB143902F14FD98AFC487A0D29E4709@MWHPR12MB1439.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uxvqa1p/CCLO6OG3vrc/9cx5BzqqQfuBbF/VrFli25aQl76KrM6cvuly8dF9xbzkNATOX+zv0Lim80CvmuM3HGQZRuFqkHQPpnRZQPFFvna58BrldftO1CQfX0TM6q5ESBXi7TBM3dnE74uw1fDsYeS/fqiCJbr9KSxYS37rmXC1NkWYLXIiv7UddBUPqT4eOQMIkftQ6YxW084HkhfWhxeU9Qcq9+bUGYkXUKlkC3f+qjMSevd6PqwlQua9USXsX7IQ+mxBJt7GowJdpYdb4VY4dpRe8pFbIvdrNXME+u5b3fBURaWjNI125Oo9X/omF1ru4Mz8Il2MEApC9QJad+XBGUvlGKxQuoDpgJsc5yBDIGiyiDTFUFylED3Heia+HeUr1ZnGhwbUEcqMrDuxT74/tYKCBM4D+N6Yv+u0b9ByFRShr16lwfiz+OGbMCPZmawEx1CAXGl2GC6qVXHuDuKlTn2t4CS7NyyTkAm44ZThARtCjngG0cEdzH3pUseFQ1KIV5LdZvSi31nSGi36Mm9GEo3q+fhisf0JioZ1KTFFQN+vCdzTFxnBCeAotXxRuHVWOOmJ+ejZgS47mgNMKi64vD0Y5mbe0F9Ut2+1W9MKTh+merXe93P8YOK8Kb3+353vRNRr+zNJ09/v+CXVt84enqszNpIUoKqTiRKkBQGUrvv2R6KPTyOotggzINeoZaLsD95RzxhVV0Zw3SP55Jk9auGoI4OlgPHUR6Inb09oVQddppY1hrfbN9NgLbvt2M7TW/OhJd6q67s3UvslZYvXUcbNg54adMTCtTtbeYZV9lMcfYguhgPm8Jw2aY0P6yGagM9cPqETKxU8xJ4ROmfHDknwWnU+JiRwlvoodg22hvPasw5ozW6WmQIy46s0
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(8676002)(4744005)(2906002)(70586007)(70206006)(83380400001)(47076005)(508600001)(2616005)(36756003)(26005)(8936002)(186003)(426003)(36860700001)(316002)(6666004)(336012)(81166007)(6916009)(40460700001)(7696005)(16526019)(86362001)(4326008)(966005)(82310400004)(54906003)(5660300002)(1076003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 22:10:11.0558
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c325111c-41a0-416a-5909-08d9bb60ab1c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1439
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These patches are back port for 5.10 stable.
They are cherry-picked from 5.14 stable.

BugFix: https://bugzilla.kernel.org/show_bug.cgi?id=211277

James Zhu (3):
  drm/amdkfd: separate kfd_iommu_resume from kfd_resume
  drm/amdgpu: add amdgpu_amdkfd_resume_iommu
  drm/amdgpu: move iommu_resume before ip init/resume

Lang Yu (1):
  drm/amd/amdkfd: adjust dummy functions' placement

Yifan Zhang (2):
  drm/amdgpu: init iommu after amdkfd device init
  drm/amdkfd: fix boot failure when iommu is disabled in Picasso.

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |  97 ++------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h | 145 ++++++++++++++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   8 ++
 drivers/gpu/drm/amd/amdkfd/kfd_device.c    |  15 ++-
 4 files changed, 155 insertions(+), 110 deletions(-)

-- 
2.25.1

