Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B1638FCD1
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhEYI3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:29:49 -0400
Received: from mail-co1nam11on2042.outbound.protection.outlook.com ([40.107.220.42]:61536
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231231AbhEYI3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 04:29:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcnE4nf7TtFJkkBphiIuTtUjPwkEcCr+4SVS7yANBZ5hnElWc/v9ia5eY5yQx1NNh5PD3TY+p0IYEYerdgp7DPc0VRtKPO+vekv4IOHM4ARJ6VxkZfMjY35Jqa+Wt7Hkm0AJy7whlq/NKIC9sHq/bclEDy3ru+p3rYTvzsMHXB9liybdb6I8SVz9Zfb2Ac9Brszflnrc/N4CwjgCPb7zf8x8HjRm2mTTArnuUPNCNOMFQsgIcv/+XnwcTBUM+Y01T1kijsk9elF09/1+ERnaKJAgEr1kP5C8/wmngx16XHBJkU9EE1QUwy/FIyj1BoVUnmeysgUBs2a44jh4GVaVwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPQ/EZ+pHCpzjWHgIrC+ENmtAxZMQqUpYtufX77w1AA=;
 b=EddHO3G8p0+XLP2oQNI1eXOmEoo6dgp/5HCNHWRXE0ji56PDybiACl9Kb8G22bBc8bbLAfP54if/pslmIFYMI/iI4fG1+9NMn3epJ+ikq850c7hXr7y3ZSZsDqoMBkTsp+gaKK5lEiUvRCNY0ekQzN5/6BOleXftxIy1pifK/Q4Jlge8Rrs3nJGU+GIIgquuMvEDnn1SzrjBj0WDGUWyMEsUC+QvKVWibwp1pSJn5miSITXkc0suh5y+T/cyG4qoJ/QrXAMd5upCRCERL07fBCAKnZoYJIjXdMVHgmMVEkQX/RhTluQK40J5pGmDsub87iE/HQ0n2N2ylfhWsfNksQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPQ/EZ+pHCpzjWHgIrC+ENmtAxZMQqUpYtufX77w1AA=;
 b=N7hN7zdUb6TsMArpFO8WtHaJtHEC3RvfFOmgHZbXwa/M7IO3WwlqmVt2PgkE5moO6VNZm+MJP5ggMDe77zBP8tjvPzoyoSlCfrHJCZ/ASkuyWufpblQOizbM5jjSILbf4xQv1wJo0kPkM3HKUoMkjGlPr1F2brn1clQODn9aRgJ8BNScIDGTiQTcvrGQreTYEb8n/hvsGEmAxhlR4bw3rnZ38FgCKjdtL/5aJKdPJPd6cuFGCQh35+hgwkMK7ntP9d5CGG9lP6rKifRJslApXqnCVchnjCP6thZKC7HSjoVmGOLCyArxGu9QxHjpmBRqOKkVvhku1O+g4XBhtQbl3Q==
Received: from MWHPR11CA0021.namprd11.prod.outlook.com (2603:10b6:301:1::31)
 by BYAPR12MB3319.namprd12.prod.outlook.com (2603:10b6:a03:dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Tue, 25 May
 2021 08:28:18 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:1:cafe::d0) by MWHPR11CA0021.outlook.office365.com
 (2603:10b6:301:1::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Tue, 25 May 2021 08:28:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 08:28:18 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 08:28:17 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 08:28:17 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/127] 5.12.7-rc1 review
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b912b5dcf1fc48ddb470d96e1dbb92b1@HQMAIL101.nvidia.com>
Date:   Tue, 25 May 2021 08:28:17 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cbeb249-d336-4f4e-c62f-08d91f570c90
X-MS-TrafficTypeDiagnostic: BYAPR12MB3319:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3319DE180BCEEB5427BB2546D9259@BYAPR12MB3319.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UW0zbabdSRFcOaUkssNNFiLB1/jNNItSw5UAk8Ebtq/yAaObp2L1a9jpqyP2SVVlmVLIhjFdNyq7xTDeXrllzvuiw91PGVmpxfOCzhxizN3CXEtk+2KwWvZTGob1pMd3H9TwGnjff3tB1D5xQo7AxM+oqKjb8EnO2HmHWqKxtAeKIO7+M1qjUmpb5DuBqkzpwC28gJ67mlBZAUTp4Qv6hliZwICoRjO6A6Z4gIl9zX44s+WtLqakR2UWpGP86GSv6wk/Jn3G6aV5O7XZwQE59lY5n8iEKsJEpG1DdlHxPXBsemQ95LPdSxEBm417HHfRN2ezxnzBdivNPWwcG3xV6rpOM5QHy49iZFfSHGAHxztenVBaGokrs9GBdKoBQdaBhZw4F6pFQkgHr9+TBzAP0cw065vN5NiQGgr+N1x2DragTf1xidJcUbV7NPBTG9sGoZZPh5yz/bAYO2+SXn5Nq4Ol1izo9+yIYFDQ7CZc5Na3ndb4D4ki97mjG1LJtTuQkk/y+Znp8sXkb5IMr1X+CnZQyatk0C8FrRykbQG9/nyElNR1BhAaXZs0yvwK6xWl1FesIJOaJTVMEoMe+2HBFv7pxRZ/EUAkt8o3OY+LoCPepq7m4uz0vItNQKRRlquGSNjcVcZwHIdyRCdOYRO5DIiLnWWAFT0YJnJNXE012Qt+wKWZrO9+gqPYjrXOOdH+fG2toGI0FZtdkBqUvpaszdo8rq4oGKNMWEHFk9fCqKqNGG1FsRv4SZC/Fd43zkkmZejyFufvwvWTUQ8BXXaLuw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(36840700001)(46966006)(7636003)(426003)(336012)(186003)(47076005)(108616005)(6916009)(356005)(86362001)(82740400003)(24736004)(966005)(316002)(82310400003)(5660300002)(478600001)(26005)(54906003)(70206006)(36860700001)(7416002)(70586007)(8936002)(8676002)(36906005)(4326008)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 08:28:18.2116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cbeb249-d336-4f4e-c62f-08d91f570c90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3319
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 May 2021 17:25:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.7 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.7-rc1-g63b7a7baa77d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
