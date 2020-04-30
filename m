Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6F81BF3AA
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 11:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgD3JDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 05:03:07 -0400
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:61144
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgD3JDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 05:03:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdntmjxK0mg/JunuKlEm7Venp7hif/dknya/H9ttPcg88JT1eJev4Kg/pcrxfZSbaUEAzXmB5D4jCIWqZiagPOJpYCNSspiWaS+cQT4EStyXbHvLZMNaKMJFh7ZC0HTvMNSQ+yggdBRI1tbeNKMq8w+KRQvy20PATSXw7sH6qDoNl//QZJ+ANui1GhgD58LKTw4uOP1TWfIsgOZSRpRrcl88D1+6n5PPQaXk5hRuy41lhdyCiLi/dPfkrRpqJLg2zU9/Hx7rnp72+y7NaefiW0JGdk9xeYGk4dQFul7BktgHRHA2kzBzMwAoFsd8kaLCt67yoIeBSATa0uqywn2/Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Doefa5wGXEATvHVmDaY92fi2QHe09JxXT3AM/usIw14=;
 b=HSpnt9k3JFBjwJuE8yjH30fcWFKQAPlvrK58chE6xBleYK+hu2wWtZHHu3TT7Fpxuw7RMLjV03xr8knCTXFusdao0vLwdGmKRKZVC3roJlDGOxtYdrYEkCzpqR5ZKBvI90rhSVVPGaGwaf2epPJBd3eABzEFm0sM6d7g92Td1JD1GZqX8WbomqxyUS86aDHcglzD2B6nvNk9rgsznmtl5az+yhIKDk4mK2t2LKW+C28iyxDZks72JNm/TFKSy+bfYUNHojucmyFJN4uC9v7V/r5aiw0W8zSBftctGBMAAQ3zKMDfpQWFN3JBIZJcv/el2bRrnFHdoCwm0WTmbuBT5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Doefa5wGXEATvHVmDaY92fi2QHe09JxXT3AM/usIw14=;
 b=e2CSS06/rQmsIChIJCLi3pVtf4iVWIBPKlrMP+QRyCeXpkBO3dvjarIem7g7ceUTvuXY4waIt39ic1f8wWWKwjJ6x23v+bhilitfMDFcSISkNXUIjYIt3iSBTtXhyDhnGIffCOE2i0xfwxxoU9nC65cssNbRKDCodm61bf39bJ0=
Received: from SA9PR10CA0014.namprd10.prod.outlook.com (2603:10b6:806:a7::19)
 by DM5PR02MB3371.namprd02.prod.outlook.com (2603:10b6:4:6a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 09:03:02 +0000
Received: from SN1NAM02FT048.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:a7:cafe::36) by SA9PR10CA0014.outlook.office365.com
 (2603:10b6:806:a7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend
 Transport; Thu, 30 Apr 2020 09:03:02 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT048.mail.protection.outlook.com (10.152.72.202) with Microsoft SMTP
 Server id 15.20.2937.19 via Frontend Transport; Thu, 30 Apr 2020 09:03:01
 +0000
Received: from [149.199.38.66] (port=56252 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1jU55r-0006qY-F5; Thu, 30 Apr 2020 02:02:55 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1jU55x-0005IC-AD; Thu, 30 Apr 2020 02:03:01 -0700
Received: from [172.30.17.109]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1jU55s-0005ET-Er; Thu, 30 Apr 2020 02:02:56 -0700
Subject: Re: [PATCH] tty: xilinx_uartps: Add the id to the console
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc:     linux-kernel@vger.kernel.org, monstr@monstr.eu, git@xilinx.com,
        stable@vger.kernel.org,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Jiri Slaby <jslaby@suse.com>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
References: <06195dc0effe2fb82e264e4faefcfdd6ebc00516.1588234277.git.michal.simek@xilinx.com>
 <20200430084915.GD2496467@kroah.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <9a23de4e-39ef-a2f5-1386-2e65da47881f@xilinx.com>
Date:   Thu, 30 Apr 2020 11:02:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430084915.GD2496467@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapsmtpgw01;PTR:unknown-60-83.xilinx.com;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966005)(478600001)(316002)(110136005)(9786002)(31686004)(8676002)(70586007)(82310400002)(70206006)(47076004)(4326008)(81166007)(82740400003)(356005)(44832011)(426003)(336012)(4744005)(2616005)(31696002)(36756003)(26005)(8936002)(6666004)(186003)(5660300002)(2906002)(54906003);DIR:OUT;SFP:1101;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f22fb4d3-4a5b-4089-7ad9-08d7ece5495a
X-MS-TrafficTypeDiagnostic: DM5PR02MB3371:
X-LD-Processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR02MB33716FAC17431804D369C8F1C6AA0@DM5PR02MB3371.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wz6vTy5agTKQraRm5mOEqnhZ8Fc5Sy+IsWGW5isxCwzEcVMg7Ro6Kf59Pqi6f+ZiHnL7qQdkWD7+NGL3o7p+nOvFaF4pQ8nY4rj0F7BxjBVA+KCvLvKUmkwFohNdlYpCC6LX3aXfbCoCoYmF90bYBDFF/H7G0w+M80NDrleTrrMHhUJpfVclS8XGLnVUxDQHrPDAhHqV6pwLqzQwWbLmle+W+sNxOpSoam1kqa9gUIinyMdTci5c3fB0/wSUUF0TXHbs5B1sUpmov/dC0LloZrHe98TWqzvDYfTPsmL6boyAlQzKWUyS5XuOq7BFWIhHaH33QFitcehBYkC6CExrNwzCRVYCKhU6StqbPQpy/ExrFMy/mq3ADm6NXR0HhzEzQdonF0mtWqsQ+RtbNJOX3BGfUfR6CIKHJUc5v9wS90/eAPjp2BCVT5Lp0+RDZf4omoP5iozEgMQEratyxGAxX+JAlJxPoCBYwAjl/POo1AvPOAIDPWQWs5yRvsnW+Xkr30UDxrn8ujmYXAVSQ02CqA==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 09:03:01.8416
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f22fb4d3-4a5b-4089-7ad9-08d7ece5495a
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB3371
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30. 04. 20 10:49, Greg Kroah-Hartman wrote:
> On Thu, Apr 30, 2020 at 10:11:21AM +0200, Michal Simek wrote:
>> From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
>>
>> Update the console index. Once the serial node is found update it to the
>> console index.
>>
>> Fixes: 18cc7ac8a28e ("Revert "serial: uartps: Register own uart console and driver structures"")
>> Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
>> Cc: stable <stable@vger.kernel.org>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>> Greg: Would be good if you can take this patch to 5.7 and also to stable
>> trees.
> 
> WHy?  I don't understand what bug this fixes/resolves, please be much
> more descriptive in your changelog text showing this if you wish for it
> to be backported to a stable tree.  As it is, this just looks like you
> are adding a new feature.

ok. Will send v2 with better description.

Thanks,
Michal
