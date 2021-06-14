Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E5E3A6DC3
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 19:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhFNR5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 13:57:31 -0400
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:45665
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233134AbhFNR5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 13:57:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfoTC6MDZLfH6h18rP/vUaOiW51p1F6KXANAQ/ev+PgASvbmyPzXSeGWinjfCPI19KAUfu9ZUF2OCWJJMZn/tmA0o3oVNxb2bxW0YriF9byf3HtpYpAq0rzMU6aFEta4yOgky4Od+D/RgD3x8m4Atnj4wilcwTVs0eTQ80Xe69bBVpJ/c004ao7c4pPH9c/sQfZP2at+ufuw0ASCv8hRGlBxsas69JB1Y7RtfSjb/+OYqpUKyr4J1/C+YojJsjt+yCnVhJ2z0Zwq+n5z9vDa2sgHZuin15w/dPanjAO63624jHHF3DqCQ3Xs2HvHULaUwYGTDhNIoAxUCK+idqQelA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbQkUdYN5LWFo69oMhOjrozxsWQsRZ93PTLxmmZUjn4=;
 b=fMxwHqxOIcEoCuxjIBKlIiZ78KAhVwAU76cYDstPxWLAew1HLICgHopB/OrK3epBH6acTCJYjzQ5pdjpnOjK3JDrVvYoJKZz9KgOXiEJrumiPUyTJ3sHFa7AC+LxuXAJzrGKJ2G2EprZ7FuXDb7/d0BrkNb4bQmMK81ts4jBYu5xj3xwZ08wDNN5Y9UIyUASSiCPR0TuvbSL/GG7XpCL0e0P8GebuGsg/MP1zEK4WY3M/P15Ngig88dQQmeSY2PMRvdXeVsGt8u+NR9o9BAcpgNaih71/9eYuysWDHTFX1Tha3T1Doyn5dlM1AqZsHuG10rzdr2kEr0K0j9Wf38zmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbQkUdYN5LWFo69oMhOjrozxsWQsRZ93PTLxmmZUjn4=;
 b=kHlDL3xU9SWYSZk9rGE6ME/Ltz5pVoxMwRtAoDdm1vR4YwBUcaT2Y9sKOgL8BfTJ+DZzei4+ofWwnkwvlM2w5vEgS931/QB5WMTDo6HIEVdPO5gPsR1/CyrsvYbJu2pzzfu9TskhW/Y8XP9tkkr9nzgDiMN6zbHA7MBbeuVKay80/vGvNVYZsdxGnlUhNGdi8DPWhOnZdD6QyTJs3aP9r2msIKnmWs3YcchHjly73gXOgBOD9ijEfqGmgy50wA22afaA+Yh6qedRA4Ypgj8fVIgOFrnK9MSMLN2yAPtbsvKICtAyU7Xbi3RcuLYxt4mjeqxQGryv8yRj0rfQJmGkMQ==
Received: from MWHPR2201CA0052.namprd22.prod.outlook.com
 (2603:10b6:301:16::26) by DM4PR12MB5069.namprd12.prod.outlook.com
 (2603:10b6:5:388::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Mon, 14 Jun
 2021 17:55:27 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:16:cafe::2) by MWHPR2201CA0052.outlook.office365.com
 (2603:10b6:301:16::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 17:55:26 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 17:55:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Jun 2021 10:55:25 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/34] 4.4.273-rc1 review
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
References: <20210614102641.582612289@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1f8227f5dd0b4ab4bc06cfa35eeea6c1@HQMAIL109.nvidia.com>
Date:   Mon, 14 Jun 2021 10:55:25 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e79651d7-5fc1-434e-1824-08d92f5d973a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5069:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50699BFFF3F0112DA1659091D9319@DM4PR12MB5069.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KgMYGnD2V5BB0pVy9m8vSNNrojHy7sDoFjM04a4tJt3amiz7EH/fs1JVcoFXuwQv6QFW1vzE/HGmRqviuBbIdlaBuJ7yoVM95qGXqC8atCoBBhrpE9pUzCd4804cR9SXBr8snfZtFNHKF891Utt3SOBiJ+MT4yfNeQtkvLMaugjM/c5cla9v6qK0gekdTbtKUJepQbwXaVS2v7kKdBdlv/zoKsaZcEQMn1v8+1A8fJoD7Tqoxr+kTo6n0IXPYRqOqsBML3XlFpYxe8oQscSaIY/D0XXKl+9NRbZDXSDDRJ6WsR1mlJ1GiaNlz5wrUMRKY2sz9OjBbWtvMDRf1ta9OPmt1TanDQ1RO8DljXaFaXN0SO5I6nLwYuoMPFHiEzb5urja3mmbD+yEgeivT+0UgobbMIkW5Mq2waUuhelGESDcPZUK9t42CSxpHpzUEfcv8hjB9JgUMhXVIJMpvNExlnZoaUnHHTdYxAWr8OIQ6nJzODjsIU7A66Z1dnXEJ/z2qTD7o+w9miR9G48DkjNdTYzz+8Tc1Xe9KamZNfjIsPymNkYRYL4SJLxklqdJ2n7yYv32QqPPIrB8Meu+Oxo6f97MWNn+FQsIuIdOsbeNiUNEzb3FcEghlb3hziFOfEj/FCzr/+VXCoZ7UGp80FhCBzjC5y++ByxWlJO8+ZJrlLVX+r/jQF/f+wxQYL+4waWUcvZW0J1+6+ZR1vussMcfsDvUXvCxspsOvVuLC18siMQt7nCcA5TS0oH9YN1XB5Qv5l4SuFudl5pSiRUFjBMrDg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(36840700001)(46966006)(70206006)(70586007)(7416002)(8676002)(8936002)(5660300002)(47076005)(82740400003)(356005)(966005)(7636003)(2906002)(4326008)(86362001)(478600001)(36906005)(82310400003)(54906003)(316002)(24736004)(108616005)(426003)(336012)(6916009)(36860700001)(26005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 17:55:26.4307
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e79651d7-5fc1-434e-1824-08d92f5d973a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5069
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 12:26:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.273 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.273-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.273-rc1-gc652289a55a0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
