Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474C038FCCE
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhEYI3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:29:42 -0400
Received: from mail-co1nam11on2078.outbound.protection.outlook.com ([40.107.220.78]:19569
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230224AbhEYI3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 04:29:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UABc551HFvAiYFl4NmyZJaSf1GmVzFIawXrU2DGvnDijwctAfBpkX4y3/LRf1gMgsinzy3qQYeYWH7/Lu2oQauSB+rIvF5ekVl0ArMzH42TM/3LUf4tsTJvQeLuK5zinzCRnF7j4/2RPCuVqIJaO2s2Wdkb/mhIuC5pwTYnMm0//iB5Q6M5Zj9MxkL5W84DunczNc7IBtlcPaq61zYZDJV6bvC0VCwTxStqeWr0i+oaJu7Pl7SsRN+hn57w04NpHXBQewrUITPkimckXcheB3qHPdRDweYnhqsBFp/COzy+Oi/hElNpVpS/B+JQQbBo9Kb50BIlCDuQwBYXHI6qvZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2diFJTCsQE/+pDwtQnlAHA5LWfHkI6e2MA7qlfiNYA=;
 b=PSbfrYQzJ2+JJJe5SbgBMQPJ/xNjBM0o/iDUKUhJpbCASwDCvS+spjHWS5pyu0fZ7kXnAT+1dHq1ACoIlIC+KShMrfS334wCVZftwI/gNIT7M1w9d6K9RfHKkF8TKZ+ffT8ykIkyXibtGb38tECCo6lN0cupdfxOA2fhsFCkwzl67F6DemCL7rVMqxIX15702o3sQeTKvtYQAPcMPgBrciuKrv7EC98+d2/sdhPAyMMKCH39pAFldcVUYBUuszJW+CoT0MDuNaNGANO464SRzpqA88nAWM95lJpzhtGY2uru27+DcsbawrtxWuqUR99URLltWpt+Tp6/Z72U5w99Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2diFJTCsQE/+pDwtQnlAHA5LWfHkI6e2MA7qlfiNYA=;
 b=ZuzTbDK6ekGfuav76r+/SMvL54oNQ9BboXngCZgXikkNgc/3xk5y7SQUezFfREoY1hnk6l/HKufEOlIvhtQL2abMhgvlL69oCUo+lXDT7I7qP31A6vrt6/8arTFcKEGRSptqcxuruIvqCCqUHR7q3gCgML48f13MIo3LjPBXrUiSf2nWSgIIWojZPm2JCcW+PgcXzJx0EbOQKk71eFuq+zSjF67PYk2uT2feuI2sO6oVYRI6wbRU001/zmy/SdGt1hj+aoCi19rVmrG7wiS2+mZ2hzvEwstvEcBCoZX5F792NZk/TmfZxCTA84mRN0zvMpXHkeiYKz+FE8s/NmiTCA==
Received: from MW4PR04CA0108.namprd04.prod.outlook.com (2603:10b6:303:83::23)
 by SJ0PR12MB5422.namprd12.prod.outlook.com (2603:10b6:a03:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 08:28:07 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::49) by MW4PR04CA0108.outlook.office365.com
 (2603:10b6:303:83::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Tue, 25 May 2021 08:28:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 08:28:06 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 08:28:06 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 08:28:05 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 08:28:05 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/104] 5.10.40-rc1 review
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4f52abb1902747dbb33910d1b48e131f@HQMAIL105.nvidia.com>
Date:   Tue, 25 May 2021 08:28:05 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48d243d2-ccd6-47a0-3299-08d91f5705a8
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5422:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5422FB7C155BE4DD586A5B3DD9259@SJ0PR12MB5422.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7VSijo99JxCqpNDvjw6EsMqzUjHMqyHlY2x3PzsOYHdrQ0bdS5C0AqUGlQrlO26nLOcsh39DYSQdvU0KZl6L2tFgEtei3gum62idnO0zeieUlNV3cRc+rlINzERAM9AZKVIgqos8UVKUhmmwXwfsVINwDAoqeLmD9ZnMTRHB9OHXibtz+PRygrL37ntO7JIlGXUqRiUM1o4gXOtkOPSXoX3q4Rvlv67jDl4I6yIRfgKL3ho/Ceml2B4laa8hnPV/nLLEEsCYyoiHbH3nZb8Lr4hNNaPgS94/Sx3O5p7cZQ4Y7saZ+SKZFZ52PtwyPh325mCik6Ck7etzantg8W/aLHbPXolYZR9KfxmYG4OpByV9YpqyU8d7RIX2FrI+IZ+MjCeTdBIc+VY2jDLsm6zcNlHzP+8Q2bQTEiVy0P9AzUuInTppislw45UBTf4Ov8NSrHl8oq9m/NJdK353AaYd71R83E0tT1a5lLv7FxGZlc7r0skbBdth1U9VzLcD/GK0g98dYwbvd1X3U+c7b+z8nj8OWGaVgrVtVLhKmpt7wdNLKBgSvqrjfTmqTUiq9vcUK2GhKd4/92MMS0vT+ItP7R7JjtE8lVNQrWRwfTPsBR7sMNvqcRVcP9ztKbxg+EcMWOlpz0JNOqAQejxf7IQX4viQFQc/R9a21UrN3wmS7qoBtecj3jC0mbYBdERD+DtbCEY8bFwmxHYbIbpF6i216DClDt3f6qcix7nvdipMwm7X8fIBtHPBMFN+nGugTwEnJMuN93oymPzHEP9OsqsB7Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(46966006)(36840700001)(478600001)(5660300002)(47076005)(7636003)(4326008)(186003)(70206006)(82740400003)(26005)(86362001)(7416002)(316002)(54906003)(24736004)(8936002)(426003)(356005)(82310400003)(966005)(108616005)(36906005)(8676002)(36860700001)(336012)(2906002)(6916009)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 08:28:06.6081
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d243d2-ccd6-47a0-3299-08d91f5705a8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5422
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 May 2021 17:24:55 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.40 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.40-rc1.gz
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

Linux version:	5.10.40-rc1-gd8d2794a2bd3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
