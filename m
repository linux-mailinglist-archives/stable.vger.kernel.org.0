Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9ED8FB78
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 08:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfHPGyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 02:54:20 -0400
Received: from mail-eopbgr740040.outbound.protection.outlook.com ([40.107.74.40]:62176
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726823AbfHPGyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 02:54:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqfDT+9XH0OOa6UMDjZkgfjNYqpose4pIvOGgUhIbE3HQPae2uAlHDZ3zoBKRP9OECB5Pw2qyYaCQO8tjIeDnXk6MM2NcTHdaGksrAV5oP3gsGFkdAHWwcA5mfFNTIoo5PMIB5v95vYbDvwp9ctMMSaVVIWd+kJlz8nXU1J+eo7Ws95u8yA7l/JsG8BMV1srs4hjYcGVuFzAmKOx7SZXNJanLcDGMEES0h9zfI0afftT0d0dFmz+/1b4BxAKBcFpUo5Bh6GFou73W1LFkbbHWJwsykg/pPl38bj+jNtDqNyAxXh6PeWgWrsR1d/wZEXk+rsz1T9qf4xbElAe7OGB5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6bcShvS65B5sYp34nGlH/E2EzcfVq7Q+6wk7PYlwcE=;
 b=ARIHo+l4eabQDvmnmxfYnRnJtkdbeHK1tGB3TiCr9bO01WOhQmaGzBG9CLJB0g1DQnOBBligKRi1mXI+GfjQHxxqT7bi/SaRXVo4qhoOtxohclvsieX9uEGzyzGZAwYosGV8uD6bkSxuGex4Pl8wVljASbrdVaXpIk2Hd+c4f70KevF0RCa7tmbClHQTQy6hWrodHJbLMDpCe3ghOxwv+eENdxpZOGAPdtD78PGBvTQAl0ji0/ktkeBa+4OxoPeRxvmwIN03nnQApcb1YaqAbxQxzVjLTnkm/0LIZ74Ks4q1jt9hEtigwgrzXkp+Q6Pz6RYuI2QLPuMeSyVOBwuEHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=arndb.de smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6bcShvS65B5sYp34nGlH/E2EzcfVq7Q+6wk7PYlwcE=;
 b=kb4V2LWEDPn3apHKbqJffdE1rhVfW9qlJW5NCHQFDsJW3gVejSHNZ61rRtHVBOTFPJZ/opyyBH1MUaJpbwaPOfI3tq9hG/ZqA9vINlClI0lLMSD7p/cJHQVmtX8HTQgwDSuHdAI7fyDKuZLPfb5/psopB00TSCEe6pcXtz9YNik=
Received: from DM6PR02CA0025.namprd02.prod.outlook.com (2603:10b6:5:1c::38) by
 SN1PR02MB3807.namprd02.prod.outlook.com (2603:10b6:802:31::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 16 Aug 2019 06:54:16 +0000
Received: from SN1NAM02FT033.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::206) by DM6PR02CA0025.outlook.office365.com
 (2603:10b6:5:1c::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.15 via Frontend
 Transport; Fri, 16 Aug 2019 06:54:16 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT033.mail.protection.outlook.com (10.152.72.133) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 06:54:15 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1hyW7r-0002kV-Al; Thu, 15 Aug 2019 23:54:15 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1hyW7m-0006nz-7D; Thu, 15 Aug 2019 23:54:10 -0700
Received: from xsj-pvapsmtp01 (mailhost.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x7G6s5NK030993;
        Thu, 15 Aug 2019 23:54:05 -0700
Received: from [172.30.17.116]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1hyW7h-0006mm-IG; Thu, 15 Aug 2019 23:54:05 -0700
Subject: Re: stable backports, from contents found in xilinx-4.9
To:     Arnd Bergmann <arnd@arndb.de>,
        "stable-4.9" <stable@vger.kernel.org>
Cc:     gregkh <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
References: <CAK8P3a0gX2dM=VDjs2Ezh1EYM-buXCZ+79bdG2E+HCjO21StcA@mail.gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <a1f81a90-26e5-364b-743a-25a3525a9e99@xilinx.com>
Date:   Fri, 16 Aug 2019 08:54:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0gX2dM=VDjs2Ezh1EYM-buXCZ+79bdG2E+HCjO21StcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(39860400002)(136003)(2980300002)(199004)(189003)(36756003)(110136005)(4744005)(6666004)(966005)(2486003)(26005)(229853002)(186003)(81166006)(356004)(81156014)(76176011)(4326008)(23676004)(52146003)(31686004)(50466002)(63266004)(5660300002)(6246003)(64126003)(8676002)(478600001)(31696002)(106002)(230700001)(316002)(58126008)(54906003)(6306002)(8936002)(336012)(65826007)(2906002)(476003)(44832011)(47776003)(486006)(11346002)(446003)(7416002)(14444005)(65806001)(2616005)(426003)(70586007)(9786002)(70206006)(305945005)(65956001)(36386004)(126002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR02MB3807;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e59edc7f-6c6a-4539-82d2-08d722168de3
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN1PR02MB3807;
X-MS-TrafficTypeDiagnostic: SN1PR02MB3807:
X-MS-Exchange-PUrlCount: 1
X-Microsoft-Antispam-PRVS: <SN1PR02MB380735F50C820295D2E338B3C6AF0@SN1PR02MB3807.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 8PWBbLJiDBV9cxZOxSuLx7zh9OWl9dC1nkQCLRQ2XGTEmF6GQxpTYDVl0UkYwyhEJQxmdyI/+cM2EqbkfOZxMa9z8gb+Fk/zi3NZMB0fTwkSOcdDMKIdlJK7n8c/J46r1LSm2Oee4d93HDAakuFvU2vVPq1w0VhCKV1P5wsq4hNBrGo/W7a0UzuSWhVIZSwpMaFrlxK7iaJQs/hH8FJUlj1Z2QNwSi/Nc/X3eKT6ygo6cehrp9d+Pa1A9DGaY7wy/C43QLaLUGN6srrHuogUMDjQmYu+94BVMpUHKHxN/m/mD2rK+UYu1JgCSZiRpdeCPxIOLsb6vC0JQbwQ7pk8/aYvAuGvamXD+BebMtot9MsYfx0T3a/+gcBeqTZmIZWeffhrb4vhn+ELFiMW7x9XIfeRciP9X9kUzuAnb88XcWw=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 06:54:15.7354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e59edc7f-6c6a-4539-82d2-08d722168de3
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR02MB3807
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Arnd,

On 15. 08. 19 23:34, Arnd Bergmann wrote:
> I searched through https://github.com/Xilinx/linux-xlnx/tree/xlnx_rebase_v4.9
> for commits that got backported from mainline, and categorized them
> to see if we want them in an LTS kernel.

This is not how we are working. Normally these patches are done against
Xilinx tree and then sent to mainline. And Xilinx kernel was pretty
close to mainline version that's why it was easy to do.

I expect that v4.9 is mentioned here because extended EOL.
There are also xlnx_rebase_v4.14/xlnx_rebase_v4.19.
I see that v4.14 is another candidate too.

What's the purpose of this work? Make v4.9 better?

Thanks,
Michal
