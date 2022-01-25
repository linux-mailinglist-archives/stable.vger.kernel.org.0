Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F67A49BCC0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 21:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiAYUO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 15:14:27 -0500
Received: from mail-bn1nam07on2047.outbound.protection.outlook.com ([40.107.212.47]:29348
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231447AbiAYUOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 15:14:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fc/OEqC0Y8Wb40XejszFqKXvrmwe0rDvU0crW/5XzJyZD54dVEaNP+1vI7DhuBgjJHV53R/01HQicJFgVEKgbheLi6R+c9WyFxWch9cRfjy5JOaqljg4S5UvMqTNfZ2dsZSGSxls+j0hDQ7/Lw5NKxpEFdVTyZX/GpOdLlPuMluI7aWZJoUG1G1hlQEDIIIR4hmvytLY67Yj5X7o5cu4G1iOSHxDjNNzy2Y8vyCCuBu7c4IcqPAPIDEb338FEyp12nUR29AgAmswOCpZ7s9gw0bcgF4GRpU1Thag4FyZyR/NVNM73F3F2PeOzmuxfpFalJzON90RwhoK19iONF3u4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=koxp7tOAxCQKXf4vOWpNfQvxqlKVkj6mff45G3dXGd8=;
 b=ZU5nTD7X3AvEWteSQebBUuxR1wnV1GlVj7i5I8IPidk6pJnI+BTp3wIk1I9hDpt2DZR7rqyyTlzjyLHCkNwdmxApi9UdH/B9+MdDBDE9SwTHgSvBpYWFTbB2R6pey23ezUaAahB5odG1yAHroVbF2hzripEwzPuNwBvYJWEkOIR6lT9YSM4XtSfwLqzFSkZXK319G0Ea3PItZ+kPHCIt63YjQDzT/PKgvSH5aqacsJ1pCwkK++gSX0ASpbiS099YuQ4jVbHs0Y5hMDuTwWT7VYfPF1Pb3zAcXv+vqHz8KFz9BEAgiQit9VhwlyQKYH1o0/EUqT9e0KVHYUNhh9NYyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koxp7tOAxCQKXf4vOWpNfQvxqlKVkj6mff45G3dXGd8=;
 b=MKHQ8xOgREHRngOJQMS/0CzXNj63PsxgzBxbqMB14/lALLOj7VUvWMB+48Py65VRbM9f9M3uLLpLEAdowYIKPtPO6lj0Dre/htzPiufZz2NB3DWJXefrlSGZW81HmNzB1Pn7OdCWaTOU4piWRKFGOvj1LBBPrnrb2rUHWregbjxf8YRpi0JJVYxB7NrdwJo7/rw8kiO/7gIIrzcpVMNpwumNZx9cKdeGPcoXGC6gwCwGMa+mXYljr1hm30dlyHlb7CvP45mTaI/H5txFyxFQ4eH7wiOc3kGxlKsen++lQn2XbPOffxdgph9nDQSauxggsPvdTLmDcbyjRUZXBv/rlQ==
Received: from DM3PR12CA0083.namprd12.prod.outlook.com (2603:10b6:0:57::27) by
 MWHPR1201MB0158.namprd12.prod.outlook.com (2603:10b6:301:56::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 20:14:21 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:57:cafe::90) by DM3PR12CA0083.outlook.office365.com
 (2603:10b6:0:57::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8 via Frontend
 Transport; Tue, 25 Jan 2022 20:14:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 20:14:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 25 Jan 2022 20:14:19 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 25 Jan 2022 12:14:19 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 25 Jan 2022 12:14:19 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/184] 4.14.263-rc2 review
In-Reply-To: <20220125155257.311556629@linuxfoundation.org>
References: <20220125155257.311556629@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d52080ed-a79b-4e2b-854c-6b98d579d65c@drhqmail203.nvidia.com>
Date:   Tue, 25 Jan 2022 12:14:19 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c6c94e3-3650-4cac-2eb3-08d9e03f45ad
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0158:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0158A211790481957ABF87B7D95F9@MWHPR1201MB0158.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: djOVG86Cy9N7jhNLuNXSQQAn3MZdqrNo2DayIW8h17ysbQ3bsfUk/xnin730EEXhGDQ8s19kR0lzUFwAJnP06eoJYq/Iw6jhhA8RhGnWkrIRUzSgI6Ud3jNbgdbFtkieF+zObGq8QzbHjNHgDKzZBsA+bIUoFuSlrMGazIUb391p0BZU3mwxRkFNcVQcbBaMhiPHBIC52LCtjrVb/g/PBB0QgTjLWOLZ2/o2oVH6kxUJF9ap5A7xbYShw7i+Lmztd+C0PcCDMBDzSBBsVG8PukzLlY2/5ynqLivsMKRIfghk/0oMITCElplyvhnD0CvvuGFLo/qbxDPBVILbQ6BGLoEb/b+7RhlCH20Aiu1WBjdEQez8d8G+l3ctW0AGLoISkVAsHmPZSoC6dVijibhCqCPontyowDu+zjHLhst+yk5jjyY9OJq1xusgUCtLm9Hm4OMUvwks48BrkUVsoT4+TcJ5VVVN00kg8b/QADjVR14gqrFeP4iLyY7CoNltyVac0upvdrcXI5VY6YpVjsxQADk6sM6G186Ns806KfY8Lhh9ceb30qVgx+cr/32QZgpX+WHqL2g3eRCmVMG/oTz4axQBhGaiCruh6BWbNHFRQK1WoJyHjubVDR4OVraA5I9Eey+YydrXfwfO+RbQwArnTImo2dZ8qzj8M5lZeQJzVjzIC9zQ0qQVk6hRmqGDUAF+HxzNlTP1CKXAKwAfhCs5AuPudtQPEFaqfIqQr1qkeSZlgsQn0hTSxb0O3zM0e7gbytYydNrbCI2Tpl3pD9K8s6fKfhESvuNZ7sO926/FdP4PO//7uHyOw3nyiAgUD1/IChE+QbIfvtyahY72RQ+xNvUJX/m5TGVCjmdl9Fi2gXJtu106SVjtTL/tDkvV1m74
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(46966006)(36840700001)(316002)(8676002)(966005)(54906003)(31686004)(36860700001)(81166007)(4326008)(336012)(2906002)(47076005)(86362001)(186003)(426003)(508600001)(31696002)(356005)(70586007)(70206006)(6916009)(82310400004)(40460700003)(8936002)(5660300002)(26005)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 20:14:20.4612
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c6c94e3-3650-4cac-2eb3-08d9e03f45ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0158
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 17:31:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.263 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.263-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.263-rc2-g1cb564222633
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
