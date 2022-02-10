Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F194B087D
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 09:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbiBJIdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 03:33:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiBJIdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 03:33:35 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33B3220;
        Thu, 10 Feb 2022 00:33:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ykr7X1Y7wieG+jf05QvcI/RrFR1pRvcZmN0Cv6FeuIje5QGfxRIMthAEw8jUsEQQC5C/wFjNP78Z+0Oygr52potoToCC6wpvyDwd5v5MqsxHKpjlVNz7wJuXnvB2BqMdwF9WA8A/uKbVsk66dMvQPdY93k1yUIfgEqKKhV80t92ShyNcd1kF7ZHJfglMUXkwuMK1MuH2pSdjIuBpKjCh1BaV3K/a8Iq0z0juPsmjtUTS8bPPkwAMCjXgD2a6QeRlYv3SVAXpWrQ5drjDFSb42tQBM046wQktErnA44su4IHjF7f9pb2f8xGm7cUGFQ2sP7sYgqCoGEpLly8tSnAbJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6eA+Ffv/lTOwVsCeYrXMiJdT5RGrGxhl8uX/wESXFFo=;
 b=FybOB0scIxRlOJVx+7Oewv2uzzzN1qYqh4A/N0bn8I5f97bKVuWTOE5vUHvhM5I77x3M7pQedWbGXae6u+CATVotPTJcH1E+2x5qdgJKlXhxI53yaZBuVT7SXMGG0/IwH7E8E5+gn8IYNWatDh/LzFnaF+B90Y6cSSHdgb3RQrHaaftMSYFLhZNM8zSf0k5t+7Ddi8IhQOm/2tSNH4ZMg4NRB2Fn9aHtEio8rmzQHliu15e0Nou8Rmp6+ASMZ0SD0pdCipl+YgHjO9jO7dy4A2nkXl06oS6Ru/rtdNfD++MIdGT9u5uRnLb1sVc9RiITuMV5ltbXVn0S0qSw4ni3qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=temperror action=none header.from=nvidia.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eA+Ffv/lTOwVsCeYrXMiJdT5RGrGxhl8uX/wESXFFo=;
 b=oaWZvtE0Ta5j3pUkAVGLp/0qu8FdvKDrraSB9FqXdGRf22+aMDIqXVxHR4w77vxYao+b8wbjK7xY2JkU42k4eWjGBbxI0Yz65Yya6QjevKwKWVDLoiJhbjUcjmduodSHIo8X/X0wc2bJQhuBY8WbM3UkWzZfVoSGNdYJoH8RRNAE8fhmCRUmYHSRtgpyR8QUdfIsXEl10JqTREvT/QkQlICDga7uySTCylUhVnD8nAplWTHX7YEu0yIUjx6F87cAEcgU2RNDhFVwiJpr7NJRV9g2oP3Xa+M5ES6cZuiV6B8F9nyh+S5YY1cjDlMKN5GekIkYMh3tLkEodc4JE1Omig==
Received: from MWHPR17CA0080.namprd17.prod.outlook.com (2603:10b6:300:c2::18)
 by DM4PR12MB5053.namprd12.prod.outlook.com (2603:10b6:5:388::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 08:33:34 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::5d) by MWHPR17CA0080.outlook.office365.com
 (2603:10b6:300:c2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Thu, 10 Feb 2022 08:33:34 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 08:33:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 08:33:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 00:33:32 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Thu, 10 Feb 2022 00:33:31 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <slade@sladewatkins.com>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 0/2] 4.9.301-rc1 review
In-Reply-To: <20220209191247.830371456@linuxfoundation.org>
References: <20220209191247.830371456@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0af46448-46fd-47ae-afc9-9b7421d78e8c@rnnvmail203.nvidia.com>
Date:   Thu, 10 Feb 2022 00:33:31 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95a42b43-120d-4b55-94a7-08d9ec70062d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5053:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5053445401FD41CB415DA0B6D92F9@DM4PR12MB5053.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9G99GcD4+PybrwBSCESwPM+SoIFSjAdLdOWu4W7Nz+8zrTEH104mxl+4KMAt5muVI6o89jmvkXAZyYEk+k3YdGBJVtaUPw6nxbmGKvwcIJAaBW1HoXe4iXdGdaG8K2EXvceyhOa2zUkuiYd7/DggtNL2Ptrfn/PefIvBkBTVBEfT0qepxiif/wKNGe7Eelis7FPKEb3VNDS3PEjQP48REmMxXyci5u4l2U+s3Fm3SDHmgP5xPu4iSPhZvnt7XjwSmBcsCHK/MKL3+q2X4GlQZuYrI4+2Mi2GafK8nXnGG+6uHk/uuLqXRm1FTnS+ShAwOSVjX3+cjoYO+r8ZwOW/TSXuz3rybrNJ5OXVWd/6t/k7o0iqK0OWy5gSXxdg//AtyKL1lRg18k2NDIrVzm7r39mnoS/y+gLBccUGg+IPoVlI2HT8K5JjH1XUGXir+cjUqkjMYPyT+xo0Jn6EvueJny8OzDUcAsfEg24Lcjq524SH7A49bLhb+8ae3Jf4aInJH6ZWX4JcetD9u9CSLJT4nfkgOavjov1TvZJqrePhGJ2fhwBVyInSPMoIfudyreO3ZE4fmuSBzhagUaMw35sWQAa6w9rwdffHFc5Wks6ZDe/1LTwLvCk5+V7VHllZg/p541VHd+fi5kObRDl2mj3oWwC3BVzWN8nC+pp+IByBqh9UesuGSWXOg6Fn5oF9tOHe+1RgrjRvqJciJ65vN1uKLY4a4/rYKCfRiTs037P6SrxOHVmhtRiXT2tNNiEyKqPpjE2wEUd0t/QCPtdT0HAhBxRgy4TIu0yfhm/RpAi55Ak=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70586007)(186003)(6916009)(26005)(316002)(7416002)(2906002)(81166007)(82310400004)(54906003)(356005)(5660300002)(966005)(63370400001)(40460700003)(36860700001)(8936002)(86362001)(31696002)(508600001)(31686004)(63350400001)(70206006)(4326008)(47076005)(426003)(336012)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:33:33.2684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a42b43-120d-4b55-94a7-08d9ec70062d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5053
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 09 Feb 2022 20:13:31 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.301 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.301-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.301-rc1-g2b86ebafad46
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
