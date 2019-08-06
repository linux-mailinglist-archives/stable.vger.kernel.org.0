Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494E082BC7
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 08:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbfHFGjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 02:39:39 -0400
Received: from mail-eopbgr700071.outbound.protection.outlook.com ([40.107.70.71]:56609
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731560AbfHFGjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 02:39:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8TOySbdc1lkSSulCyMAXL7llDF/Vzt9DSsFtF0ZuIJCfiPG/hbfgoAy+xDF563EsXPkUrxmh4lpccbio16eSifLKT4COgPZAHxV9iYPqyhxGDDTlg6sRJGLPwiBXb3GW6HXI1w8mhYYRUiNK1CKPkIK9WKy+sL9ogudVZgk21v+YyjyDpwP4kGG4k6UmJJzuaQPgfD/8a8L3Kaf/39WSmQTVTCLEo66SASH8acBKdGbpbkGNoXBBfpAwkDZ9YHQLd8HAquW5e/aWpphhexc45h0acc5osFarOKI4yilwlTR+jcbiHeq+1V6Gcofw2/9hHcRHyX6qaIF2S8bAk7k3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAUBN+EwUvc6JrNlM9On9zHfRBdbBrWObw1xC1j4goM=;
 b=QkXJbAANVD93GoSdXM/7kGs8IRoZq4v7Of4qJplDjg3CC/XWGWnA59sfnhJ76gat7TQ2/u4NUDD4iRiP+jgQAXeVeeQ3izFNd7/NcUWPy92KxAoadgShjSZeeEQhSnvKR2G5V48BtlVtGeD6JVUVnk0POR19+xB69/LEDmgdiRVqQSh5jo7IQCMHOErzhFLevScGlj0BXO0u5r46W1kMHL7cIaig/FdBGifWcTZccR8cEcf1Dz6+95p13/P4+1/kUZz2TxhAFcaxNauSSruLO9UpEWG71o1aX6pHAH/JrS46WoPBpqdwc8lEAvMQog0LBs3lx0OwYEBuU3DEM8899g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=gmail.com
 smtp.mailfrom=xilinx.com;dmarc=bestguesspass action=none
 header.from=xilinx.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAUBN+EwUvc6JrNlM9On9zHfRBdbBrWObw1xC1j4goM=;
 b=d2cdHAOV+FzN7mOG5qfCn1i58V+tTaPvlgdqOmY2sxUlSKb/YaTJBv44wsy+TGqNseDeaG+/dJn+dAVRpyBZ+YIVLoiWziYlIpczppTbMe11XuLXgT6N4Tsi/9bRzACWOJ1jYZemKeLrf3ce2EzKw0Sv/8B7z1Qk3aYpbUz4dho=
Received: from MWHPR0201CA0080.namprd02.prod.outlook.com
 (2603:10b6:301:75::21) by SN1PR02MB3696.namprd02.prod.outlook.com
 (2603:10b6:802:2d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.13; Tue, 6 Aug
 2019 06:39:36 +0000
Received: from SN1NAM02FT044.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::202) by MWHPR0201CA0080.outlook.office365.com
 (2603:10b6:301:75::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.15 via Frontend
 Transport; Tue, 6 Aug 2019 06:39:35 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 SN1NAM02FT044.mail.protection.outlook.com (10.152.72.173) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:39:35 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:60651 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1hut89-0008Qg-C1; Mon, 05 Aug 2019 23:39:33 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1hut84-0006sM-8Z; Mon, 05 Aug 2019 23:39:28 -0700
Received: from xsj-pvapsmtp01 (smtp2.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x766dMLM001169;
        Mon, 5 Aug 2019 23:39:22 -0700
Received: from [172.30.17.116]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1hut7y-0006rA-4v; Mon, 05 Aug 2019 23:39:22 -0700
Subject: Re: [PATCH 1/2] ARM: zynq: support smp in thumb mode
To:     Luis Araneda <luaraneda@gmail.com>, linux@armlinux.org.uk,
        michal.simek@xilinx.com
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20190806030718.29048-1-luaraneda@gmail.com>
 <20190806030718.29048-2-luaraneda@gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <17a45e21-8362-e888-d222-812c879a38a8@xilinx.com>
Date:   Tue, 6 Aug 2019 08:39:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806030718.29048-2-luaraneda@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(2980300002)(189003)(199004)(26005)(426003)(476003)(5660300002)(63266004)(106002)(478600001)(65826007)(9786002)(31686004)(186003)(14444005)(31696002)(50466002)(44832011)(336012)(230700001)(356004)(486006)(11346002)(2616005)(126002)(6246003)(70586007)(8676002)(316002)(64126003)(58126008)(2486003)(52146003)(23676004)(2906002)(305945005)(446003)(76176011)(70206006)(65956001)(81166006)(8936002)(229853002)(4326008)(36386004)(47776003)(65806001)(81156014)(36756003)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR02MB3696;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-100.xilinx.com,xapps1.xilinx.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a833b9ca-5cde-4d52-bcb4-08d71a38d8b9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN1PR02MB3696;
X-MS-TrafficTypeDiagnostic: SN1PR02MB3696:
X-Microsoft-Antispam-PRVS: <SN1PR02MB3696D410CE0D39653B446E1BC6D50@SN1PR02MB3696.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: VNs2a3X5ASHT+bfPdAzQOEMbshkx5yeQquhNx77lAOG54i4otG4/Mzgxojln94H+zDsUxV7GbgjY7JpSr/ZU5Kr4B/TFaNVFUVFWdNSQ+1RNmYL7Wd7pw/XMALUAIojUUMyfVj0Vu9KtToHkCiPjiDg39VBJOFCVuT16sCCeM+hk35PyYyFPrBRai+0g1s/0HQ/AdYm6nuvL8L7nKttsUovptNkTzVh2m1gI/MywNOoSPKyuWrkQKkzoQ/nrUXXHw4zhlwaDZCg0vhRcAlQphBSVWg/txss8y2xLZkLjgWLyvgPgzHKkHBcOM0XQVA87seo2cl4BSqoht4GNV93hhztUi05isT5uRG1TjvYA7jeDY0VcBfjJJQJo3Mt0zQYjwM+RF3NDE27lLHK4NkUVKX5AF4FCCVEzDRSdLpTwru4=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:39:35.0134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a833b9ca-5cde-4d52-bcb4-08d71a38d8b9
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR02MB3696
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06. 08. 19 5:07, Luis Araneda wrote:
> Add .arm directive to headsmp.S to ensure that the
> CPU starts in 32-bit ARM mode and the correct code
> size is copied on smp bring-up
> 
> Additionally, start secondary CPUs on secondary_startup_arm
> to automatically switch from ARM to thumb on a thumb kernel
> 
> Suggested-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Luis Araneda <luaraneda@gmail.com>
> ---
>  arch/arm/mach-zynq/headsmp.S | 2 ++
>  arch/arm/mach-zynq/platsmp.c | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-zynq/headsmp.S b/arch/arm/mach-zynq/headsmp.S
> index ab85003cf9ad..3449e0d1f990 100644
> --- a/arch/arm/mach-zynq/headsmp.S
> +++ b/arch/arm/mach-zynq/headsmp.S
> @@ -7,6 +7,8 @@
>  #include <linux/init.h>
>  #include <asm/assembler.h>
>  
> +	.arm
> +
>  ENTRY(zynq_secondary_trampoline)
>  ARM_BE8(setend	be)				@ ensure we are in BE8 mode
>  	ldr	r0, zynq_secondary_trampoline_jump
> diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
> index a7cfe07156f4..38728badabd4 100644
> --- a/arch/arm/mach-zynq/platsmp.c
> +++ b/arch/arm/mach-zynq/platsmp.c
> @@ -81,7 +81,7 @@ EXPORT_SYMBOL(zynq_cpun_start);
>  
>  static int zynq_boot_secondary(unsigned int cpu, struct task_struct *idle)
>  {
> -	return zynq_cpun_start(__pa_symbol(secondary_startup), cpu);
> +	return zynq_cpun_start(__pa_symbol(secondary_startup_arm), cpu);
>  }
>  
>  /*
> 

It is really a question if this should go to stable tree. It is pretty
much new feature.
Will be good to also add link to similar patch for example this one
5616f36713ea77f57ae908bf2fef641364403c9f.

M

