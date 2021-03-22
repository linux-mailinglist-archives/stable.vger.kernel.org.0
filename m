Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CDD344770
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhCVOf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:35:58 -0400
Received: from mail-dm6nam10on2085.outbound.protection.outlook.com ([40.107.93.85]:22369
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229614AbhCVOff (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 10:35:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaIZ9dSIcLkgpc1JMjoZjX0IsGTbLJeH+ZA2cbVDCFBwdXVn9mFgCMU/UW2H8W6jruBtgvWrZ4z/xcJt+7TWKwuoEnxTJlPFgfBRIbIbZNjk4I0JEiz+jwdzx6Qfy0HqHAT96Tf3JxWyUDjW0L9IMSdMpBcREjgCvWxOZNQW7j1fAJj+jJ+ClnFTcpDCowH6TvGquTqEaOjvnYAvqaW9kmuRIt+Zvff0BG3wNcdXWERC0ZAoYIod8EGiFJMT4B4T8jYm0zY1lRZ/Qc2/ySGTBXwn7GeHU/YWnkIXuEebdK4c0xiXchTVnGIugypbYp3gmM/GaLRwTAxFrXAC8tmEHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNcdHOiP8IFl0mVrt3fOXNsIsKVaVGxJJDRnIajadL8=;
 b=DHyPr/xE4/StJeP2/iU+FCSwUGN3IqV5KXPCUqOu3ua9jCGMoFP0Yz+e2GXK0FtMaeLQ6Mc6PYxROmiAnI9RWclpK22gKLX1Z+rzN/Ej902EVO9QKNC6p/MQutEaVWbSmC+HVtpqzy2pKxirfTVIlNug3TGAAgPmVVHnOlxscHnMovwijJahk68/E7jl2LZnwGDUxxpIbIQm98e7YgQGjnpEjPXukNG1ldg6SsfFXInlhF77xVwRnRuUC0tbyJjuNTACZ8T4k09j6keIT3yaBVUZBBk5CxsZgN7knzo+buKZlZEQXU4TCG2vwbD0GmKZ6/cGE8KG1YOtL3LI5SsliQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNcdHOiP8IFl0mVrt3fOXNsIsKVaVGxJJDRnIajadL8=;
 b=aZfwR5MdlrmmEXRkKvhkSmLeiwLDsZIOBvLkau2H1frJzOxgYWTyacwDoqmOTH4GgCJ5cGlnJxwdHAM4ic/ZXdsTfeRa/oIUABTMDWrq9TtamA7RqxuyfTa/Ym0pOmxSZq+HGr10U8G3QZSMkiYifwB+t8sz7UexuMV4A2dFZRYq/WS+zy5naGmUtP7ODFwNyeW80KGh4SgKhgIsXw93IBv6DaUGco/5Vhis/e2bN1aH1bwehiObYV4xEwIJR9/vW6rBpdSyB0ioZCXhVpFFYD4jrokTXYcnqt03MsEwLIPjmX+vKgDlzsdFEsu7RnB6wE5X17ULSEEFT6w0dSu9HQ==
Received: from BN6PR13CA0008.namprd13.prod.outlook.com (2603:10b6:404:10a::18)
 by MWHPR12MB1805.namprd12.prod.outlook.com (2603:10b6:300:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 14:35:33 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::a9) by BN6PR13CA0008.outlook.office365.com
 (2603:10b6:404:10a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 14:35:32 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 07:35:05 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:05 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/14] 4.4.263-rc1 review
In-Reply-To: <20210322121919.202392464@linuxfoundation.org>
References: <20210322121919.202392464@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c20ffc6df7524f6db10c722c1b2eb7b3@HQMAIL101.nvidia.com>
Date:   Mon, 22 Mar 2021 14:35:05 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e603b141-2e54-4f38-38fd-08d8ed3fbfcc
X-MS-TrafficTypeDiagnostic: MWHPR12MB1805:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1805434E5103067AEAB06673D9659@MWHPR12MB1805.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OrmhLRTIqNkbun4ThIV5Yj2BWZ3hK8TEN5kf156wj2AclzUq0WVTbH/OMcWgIcX24S+P8rjZaX6RQnPNG50xN4EK9+rDrZ2Lh/6cgfDOLtRl12Zi5NP5kCNG43O73BZ70wIKJsXuCbs9irYxA5EQBcctfMXp0PCKKVUltXIizzpeh998Kxgjm7ApE7W1s1qpAIgjNehXBAJ/rx+NIgo/IwdOqBrOYhNs6Y3i19OggyiDymX6tyayvShg9M/KeSvdfDHMlyuAIK1dVPn6GecSrnc6EMFjW1ZWLcj1mvGjwVilfTENhHwpBvSdLFGQWIrKdleoPy6D8SAdJFT6EgYVQ7mtZlOCXZZlBbQUkVf9bTnU8uQ39Yd3H/XyV7dUwXKGj3lnsxH26Y+vpynmv8G/Ay3bOA9KR8p9d+tazxAAowJP3XY2shyqLPmu1fbmEtuo4GdqL/Obsn1xxI3aqvGYinDZhDrE8jjXCaydCOAfOd2+B2QodosJ8P/DyKQR0kMLY9D32V5/eOWnPAnd5LPmJ00xPUuUsn6m6yl/hysiWuRV5cIrmP6R6A1qfGNuwnFZkD91EXgnpLTcUSGeVj1sLcQIJe5CoaOZ15oEpFcUakDxoIT62CJulm/8r8O84CHfvB5ocnAA+9GhxHsZCKTuCs0RgO5jdpm/rhuNsq8as5njLXn9lHXOGyLIwzzcr9VLpGyOdeS6fx/nIggqYiwocnmhCjNs2R6dFSD24q/JrBg=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(46966006)(36840700001)(316002)(36860700001)(82310400003)(4326008)(8936002)(356005)(426003)(336012)(8676002)(186003)(7416002)(70206006)(6916009)(7636003)(82740400003)(108616005)(966005)(47076005)(5660300002)(24736004)(86362001)(70586007)(478600001)(2906002)(26005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 14:35:32.7780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e603b141-2e54-4f38-38fd-08d8ed3fbfcc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1805
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 13:28:54 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.263 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.263-rc1.gz
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
    27 tests:	27 pass, 0 fail

Linux version:	4.4.263-rc1-g769f344ebed2
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
