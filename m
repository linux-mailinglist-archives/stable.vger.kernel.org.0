Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F5F3A6DCA
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 19:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhFNR5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 13:57:34 -0400
Received: from mail-bn7nam10on2056.outbound.protection.outlook.com ([40.107.92.56]:52065
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234412AbhFNR5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 13:57:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SURJxeuFMiADrPPoba50IHprvtk5u0TOU1nSzcZGoa7xP0Re0UeN8NPrmOSEicby70yUcEY5YcwujMN94Ap2UNHNDqiHT11Czy0VfhA/DOr0PsX2JmenjMYtdwfkziEPXjEXmEg904CJKgIM0aRQl30bqapK5iqzIpv8F5R7g/6QsyHOgBeDJ77Vc4M5nhXP7abazGjHNZmT9jMNOP32lPuRh3Js4YN/22yJ4oZicqoUX5sU97gLdVCHRIF+oM0I0F/guAuygBco0ZGrJBoAMThNehoEomso2FGMSUWjic7Oy/Emf+Xd9UR0cjXgOEvXeSy5326YPDL+3HQPZJPD6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAH7lvbDCF7XvZj9eSmfFuwrd7cBU4mZkzkajMal/Yk=;
 b=Ulahrw5lL9Odn4jb03+KK7e9FSi1HOBdhG+OXjtr/q0d4/eLax0ifaqHmTYEa5b+Bn7y0s8eTvZ5bYg8Bme/5YJG9k8uMC1Tp8yBthyIgLWZ2FYqhrQf5NO9B5FJ3Ox1++qR1si5qFg9g26n+oUMRH8+Oow6rbEcs8/rRJCIvF8UATFbQTPZq+PxdjTnf39l9kz7PLaTUDJPk/Zqad+3w0ll3zf6NX8aqJe56B73dIRIHXmHpOOEdkyG/CnaDuU0DmN4rLfdtH0IsQUwpd/QsOLXn/8NccRM1Hq8WKjfd/10xs9uHI/uS4uEBemnV97Bw3gxV8p+UPpxdV3YrtjBUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAH7lvbDCF7XvZj9eSmfFuwrd7cBU4mZkzkajMal/Yk=;
 b=ZAiLSIMX+EwfqOZ2dkMHVWaSp9j4f/P/dkWezYdDliD3zRHZj1e52GvdICVHHkfRuWCE6QlyNUftgBXAX1JaIG2CvZIszunCte2X+DaK/nKw6BLq1lBIHBQkl3O32tgn9cTAm2rrsXHUJcQMFfXKqSDxy881ve8tCl20NSS95oT5NiqG6A/df/ay7VpBWmxrVec/RoxiiJvv/KwRC61FmjR7N8dbe0BwyJ2UUig6aDyCvrO1loZwf1sEe8oDPPleNn7/sPfkDBJ6VFM7z5eaRjtY7O/hCx1Qg/dMBD1A3Pk189rIIzFzea49NmgSoayGf5hqkLGa4V39mDcPRn4XAA==
Received: from MW4PR04CA0081.namprd04.prod.outlook.com (2603:10b6:303:6b::26)
 by MN2PR12MB3214.namprd12.prod.outlook.com (2603:10b6:208:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Mon, 14 Jun
 2021 17:55:29 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::98) by MW4PR04CA0081.outlook.office365.com
 (2603:10b6:303:6b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 17:55:28 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 17:55:28 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 17:55:28 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:28 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/131] 5.10.44-rc1 review
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <446013a8075c4680a7512a85c9a4a179@HQMAIL107.nvidia.com>
Date:   Mon, 14 Jun 2021 17:55:28 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cc6539d-f891-4e8a-ded1-08d92f5d98a3
X-MS-TrafficTypeDiagnostic: MN2PR12MB3214:
X-Microsoft-Antispam-PRVS: <MN2PR12MB321441617A87D8F04CE10242D9319@MN2PR12MB3214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G0DBryt04G+JmfNi2/0pDqGajqEsJAJz4iv1oDuOo32xGrDSD6Rjfr7oqd4465AYpNAr2DO/XKNy/uGo4vfRhQlweg51rnY7FREvbN3seKXi4C8eicOmGdk3Ch6kGKf4iY3cx1WjYZqpFzWNdVrCr8+4xGiNg9O3F8h6NYh3EIH22z+NIybv6vVUju7RaAaWEIJQkW8mD9BcnGM4ryB8y1BoPwwsC984Ye1oIYRxr6rd35N9Xdi2rNaGzUkjQ6dZlDHCLWbq0C609XahNio0uVzzGGU+mlt1OR2hdvE4aL1c9sWQ+Yk1+k0lQspSPOXf/tB8HWQLyyeWBn2/O6BBvZ+Bbh4P7DjGJYAllZL0Oum4DGJZYRQC6C5xKSJdnoSimgj9ICc7AnbJXLZXHMaVUvdJU7eMRIv8qLdKRJxSc6q+no6mme1DEgphYE2Sg25Q8yG9IL5nkFBnJ+/28RZlSRhteTmMLhwUDrzM2i/ovPOe7jWfQWRRxV0UC6Hv4RUmALO3Tt2qcEHzcqgWhEe110wW1QdmEdIVzb8LHPIGohY+S9Zq9zlMSL3rF9ShztN8FnVTZb7Rxcqhof/OK8lrizgBuqzQq6VLTiPo+LrcCoLZA2RamiYK3cCCloOvv0+WPsbTSTZZzBcVXwMpnxcz3jAcS1za7dmSxCRMcVWyvwXhX4Q1CVSeO5FCAbPIqC+07c96yQ9Bq+DrMHkQTSAFS18wz4WcrehvWxFciz6Uldy+234WWWFyzkwfoX6O/CgIQcktM+f+gS4hRZISRpPofg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(36840700001)(46966006)(47076005)(5660300002)(2906002)(82310400003)(316002)(36906005)(82740400003)(36860700001)(70586007)(478600001)(54906003)(70206006)(7416002)(966005)(8676002)(108616005)(24736004)(426003)(26005)(8936002)(356005)(7636003)(6916009)(336012)(86362001)(186003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 17:55:28.7926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc6539d-f891-4e8a-ded1-08d92f5d98a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3214
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 12:26:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.44 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.44-rc1-g406cd5feace8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
