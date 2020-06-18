Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131AB1FECEE
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 09:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgFRHw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 03:52:29 -0400
Received: from mail-eopbgr690054.outbound.protection.outlook.com ([40.107.69.54]:58339
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728144AbgFRHw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 03:52:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0xTsm32EpFhQ3Z2bFsPGMY2Yr9ZUg2PycuHBEzWlJgpeVAibjC3uRgH2LrtiDxf+xdObQCdjfbhMzGilJqBqaZtdefdzTskcbfwVNyJNWIlXKpMpdxAFniszIEnQ/0rGvvJVmJ7FH1HWnKiZ0uH8DfJKf+bhT1eB+e4JWjAI/yP1yTg3+OLfd2q5vN+3xbe5OuIAPvWSwaAdPx9PG562vW7D7hXW2H50hzDB2ePJ7ij9iR08PIJYRglrVYbXzWAqNY5TVPhju5XksrpQdXxzMLFA0DLS7KRmEwP/3Unto1c6CLowKOoKL38aB6OW9y6g0ZAoeoWd3RnwF/QSGgf3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGIfTYkQKTsqnR+VD2mj0SQP4lINASExEgnGJV+uywM=;
 b=d7aA6Pm908zeJvsbIkXfp+V0nkN75Du9s4ZtGa34eiJFuET5o8+LUSV5eC31dJ+lKijTn8SJ08Mzddf52sw7+NgHYX7IvXiDx4R+5BTJWPMGvtVGszo5m8YJnz8ptllUEtuPQqQf+Q7Sy3pQDisKDfAN2rBIkFJvE8y7mSZ+bhqSrVKYHxfA8V1hbNrXLa1DSQe+B7NrsOEJkwrrmEtUj2PqLFvK1aLqCKLE3Fyux81yhOG+gUAnLT+fQclPuQvyTlsrQ0TK77sM54jKpV1og8RZmF0h2sPHqRcFsN4kg1Z+Ui4iaj29AmOT3wKw3JBlNE2PM8I6D8PUe+JxsUNRyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=web.de smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGIfTYkQKTsqnR+VD2mj0SQP4lINASExEgnGJV+uywM=;
 b=a1IlXsMKFjUpJNoHvg4P/AizIA0dGbQ6qXcrl3NWIkfsFxVEB98cWHmJ3GQsvefajgwnBPxguI5rtShmxBPS5OLtIEXYmhcBBPvVKUyps+s/r//m1qD3A+8p32nVGmEah5Qu7YzMmkb4y7bFUcGGi0KeGn1ob5pI4RZBz3WOEcg=
Received: from SN6PR01CA0016.prod.exchangelabs.com (2603:10b6:805:b6::29) by
 MN2PR02MB6096.namprd02.prod.outlook.com (2603:10b6:208:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 07:52:24 +0000
Received: from SN1NAM02FT043.eop-nam02.prod.protection.outlook.com
 (2603:10b6:805:b6:cafe::98) by SN6PR01CA0016.outlook.office365.com
 (2603:10b6:805:b6::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend
 Transport; Thu, 18 Jun 2020 07:52:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; web.de; dkim=none (message not signed)
 header.d=none;web.de; dmarc=bestguesspass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT043.mail.protection.outlook.com (10.152.72.184) with Microsoft SMTP
 Server id 15.20.3088.18 via Frontend Transport; Thu, 18 Jun 2020 07:52:23
 +0000
Received: from [149.199.38.66] (port=47253 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1jlpKQ-0002K7-4s; Thu, 18 Jun 2020 00:51:18 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1jlpLT-0006RN-JB; Thu, 18 Jun 2020 00:52:23 -0700
Received: from xsj-pvapsmtp01 (smtp3.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 05I7qGnf013235;
        Thu, 18 Jun 2020 00:52:18 -0700
Received: from [172.30.17.109]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1jlpLL-0006NW-Lo; Thu, 18 Jun 2020 00:52:16 -0700
Subject: Re: [PATCH v2] tty: xilinx_uartps: Fix missing id assignment to the
 console
To:     Michal Simek <michal.simek@xilinx.com>,
        Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
        git@xilinx.com, stable@vger.kernel.org
Cc:     Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
References: <ed3111533ef5bd342ee5ec504812240b870f0853.1588602446.git.michal.simek@xilinx.com>
 <170a896f-42d3-345b-7b93-c964d33fe71c@web.de>
 <fb68cf8c-8b89-b7d1-ed7d-f21c327a0c75@xilinx.com>
From:   Michal Simek <michal.simek@xilinx.com>
Autocrypt: addr=michals@xilinx.com; keydata=
 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
 0Z1MQlmNcq2bhOMzTxuXX2NDzUZs4aqEyZQ=
Message-ID: <54cdb490-1467-b745-a448-3ec4c19b9845@xilinx.com>
Date:   Thu, 18 Jun 2020 09:52:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <fb68cf8c-8b89-b7d1-ed7d-f21c327a0c75@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapsmtpgw01;PTR:unknown-60-83.xilinx.com;CAT:NONE;SFTY:;SFS:(136003)(346002)(39860400002)(396003)(376002)(46966005)(26005)(186003)(8676002)(316002)(53546011)(47076004)(2906002)(82740400003)(54906003)(478600001)(5660300002)(44832011)(6666004)(31686004)(81166007)(36756003)(83380400001)(110136005)(70206006)(4326008)(70586007)(356005)(426003)(82310400002)(336012)(8936002)(9786002)(2616005)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b99ffcf-25eb-4d16-e35b-08d8135c8996
X-MS-TrafficTypeDiagnostic: MN2PR02MB6096:
X-Microsoft-Antispam-PRVS: <MN2PR02MB60964274C16B31E67BFA9A28C69B0@MN2PR02MB6096.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0438F90F17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Flf2XTBgu1C22y+SWENGTHJOWsikaznX9/Tk5DDuXpPEnikEDFlBExDJtyjkc+7Q7MEsbSPIlqfDad5wa7b2B3I1bPWjjUoRS+oGt4z3Np0gIZ6fuZT0AcLBqr6c04HvZMvI0Md/wjNlcCgTuaCEsxeH8UsZ2PJk8F10usaJ2biS4+yRP7qSGoh0aqYRe5ZTYP5id0rQOSAfJbI5v/9Oylew0q5EnWIEAf+19LiHAiJ2EAKIQIb+Al+dPjK/dGBHYxffx1bYlB17qouQz/YOAPxR89j3cGtlJcp8F0m/icNL/Uk3nFaMsh4x94O7cFGdchZ1FQVPIw418pVyodxXxYSj2tE6xIgRk3ax/XPHlhqI7jI3Kgv49V+2ziOTAPxFsfvyox+ZUzSpExmEjDOD1PLokhQgyuVAgHUi/QCpIraVQrtvof2Wp7Awp6ci9BDC
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2020 07:52:23.9101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b99ffcf-25eb-4d16-e35b-08d8135c8996
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6096
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jan,

On 01. 06. 20 12:23, Michal Simek wrote:
> On 30. 05. 20 14:06, Jan Kiszka wrote:
>> On 04.05.20 16:27, Michal Simek wrote:
>>> From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
>>>
>>> When serial console has been assigned to ttyPS1 (which is serial1 alias)
>>> console index is not updated property and pointing to index -1 (statically
>>> initialized) which ends up in situation where nothing has been printed on
>>> the port.
>>>
>>> The commit 18cc7ac8a28e ("Revert "serial: uartps: Register own uart console
>>> and driver structures"") didn't contain this line which was removed by
>>> accident.
>>>
>>> Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
>>> Cc: stable <stable@vger.kernel.org>
>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>> ---
>>>
>>> Changes in v2:
>>> - Do better commit description
>>> - Origin subject was "tty: xilinx_uartps: Add the id to the console"
>>>
>>> Greg: Would be good if you can take this patch to 5.7 and also to stable
>>> trees.
>>>
>>> ---
>>>  drivers/tty/serial/xilinx_uartps.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
>>> index 672cfa075e28..b9d672af8b65 100644
>>> --- a/drivers/tty/serial/xilinx_uartps.c
>>> +++ b/drivers/tty/serial/xilinx_uartps.c
>>> @@ -1465,6 +1465,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
>>>  		cdns_uart_uart_driver.nr = CDNS_UART_NR_PORTS;
>>>  #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
>>>  		cdns_uart_uart_driver.cons = &cdns_uart_console;
>>> +		cdns_uart_console.index = id;
>>>  #endif
>>>
>>>  		rc = uart_register_driver(&cdns_uart_uart_driver);
>>>
>>
>> This breaks the ultra96-rev1 which uses uart1 as serial0 (and
>> stdout-path = "serial0:115200n8"). Reverting this commit gives
>>
>> [    0.024344] Serial: AMBA PL011 UART driver
>> [    0.028010] ff000000.serial: ttyPS1 at MMIO 0xff000000 (irq = 19, base_baud = 6250000) is a xuartps
>> [    0.028172] serial serial0: tty port ttyPS1 registered
>> [    0.028579] ff010000.serial: ttyPS0 at MMIO 0xff010000 (irq = 20, base_baud = 6250000) is a xuartps
>> [    0.557477] printk: console [ttyPS0] enabled
>>
>> again. Affects stable as well (seen first in 5.4).
> 
> Will take a look at this. Just give me some time.

Your patch is right. We found that if you specify console via command
line this issue is not visible. That's why testing didn't catch it.
Can you please send a revert to this patch?

Thanks,
Michal
