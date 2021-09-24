Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31E1417781
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 17:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347098AbhIXPaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 11:30:11 -0400
Received: from mail-eopbgr30125.outbound.protection.outlook.com ([40.107.3.125]:13537
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233132AbhIXPaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 11:30:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llNqg0/4Scls1D0E29kPOAxKhSb9WAjpXA4ffGCtHpkVwlB340hgpXhsvK/vKSOutjlWCXMS8UrjD162oCpfEhgIO7DWMBq7wYq1HTD/IsxnRCfs7AMjF96x0NAbYEwp4mo6VR3AlPyGkWI7PnwKL/dzQjjklsC/yoE1aJJdk+lLyD57rh1JbK5ChIEibhppyqVMJDRvO9jMKOQq5V8DmD9ZxBU5ltbriJDJ9PcLqJ+HooN9Ny9OhOczA/Ik6NJXTBsCJveQ/YsnOWvL+h0S8ryxxYc0e+CplOGqhh0PpQ5VnMlnrOzM4RF2bPQaxWEbiNr/VfF7UMmddyC93N+ezw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzbse2ebsjEzKaNCvnx6U9s30JoshUbuVBJa062akPA=;
 b=bhZcHM9uqN79MfpgxKPeJJiSa+GKu78Jg0/Kex319Seqo8SJmVL/hQoGdXpUYIjGD+SRxLRLK1AiRGf2iqfr9GE6N3w4WyB7WHc0+6p9VX2x01+pzC7H2umLSKJA8kNc5VDm/QTN1Au4H4CsTp+w/U9rQW9UV4BEm7aSDqDyDziR26HeVMTu5cOr73+C3TDiSnXtecVoIuuYX6cfY8ibYri/7WMcp9cL6HKZA1yRbhzSWX2GZdPS8iED5bsaYz1EG/jDLNLvu8na744Tcmv6C3QoJX2p7UlbAb3RZFLPjOtF99r2dq42kWsL/JzVIFJYWI0nPwiSIYdzPqaBt9OAHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzbse2ebsjEzKaNCvnx6U9s30JoshUbuVBJa062akPA=;
 b=SzsW2QoO9lCsVSxeLbovbwBIQghcVDLi8b8bqMRzqDe0gbc2Cb/rKLczEY4Tc7CZQV9bLHQdG4KMF3g//xN9jPrL5etRxhtdxcihDyvVNXoNm3L6d3NdF8lCqYE30YqWfySXbJo+2vNeDelcaHECJa1IccpU8WtXsxrUaw9DSrw=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM8PR07MB7633.eurprd07.prod.outlook.com (2603:10a6:20b:24a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7; Fri, 24 Sep
 2021 15:28:36 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::91aa:4873:6782:4917]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::91aa:4873:6782:4917%7]) with mapi id 15.20.4566.007; Fri, 24 Sep 2021
 15:28:36 +0000
Subject: Re: [PATCH stable 4.9 v2 0/4] ARM: ftrace MODULE_PLTS warning
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
References: <20210922170246.190499-1-f.fainelli@gmail.com>
 <YUxYV/m36iPuxdoe@kroah.com> <YU2769mOr3lb8jFi@sashalap>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <bb9fde7d-3644-6d30-c238-73427ab200e6@nokia.com>
Date:   Fri, 24 Sep 2021 17:27:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YU2769mOr3lb8jFi@sashalap>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR0P264CA0134.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::26) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.166) by PR0P264CA0134.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 15:28:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20b81d6f-f776-4295-da3e-08d97f6ffa0b
X-MS-TrafficTypeDiagnostic: AM8PR07MB7633:
X-Microsoft-Antispam-PRVS: <AM8PR07MB76335938FDEAB7C1AEE8794188A49@AM8PR07MB7633.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3W5AuT3PfL+YpO1bGm0OvermDZmwArneeyzJoY7gKuQYk8mPnRw3nwBydrbIFprW0bGYzZftwL7ezFC/OLvGXa6eitIYLQEFQx1apiclsjN/VT+NPE4cCcgxFKw/9uzwUFILhX/Qtg/yrawAsSjZnw10aXopZXNLU6B6P32RvGjRPXSyzA9XD0OEizwfSkB5M0BLwfvzE5gwty7XyAwE8rRQnfgQBH7+O67GN6Y5SrhmAdHjdxvXqjJLUesP+4+5L4cP+Z/XD2tgdlqJB0/Oa3N7wSq/Spd5rB11aUp3WTgnEW4QKN6uEx2WuYTCl7GixTBY9yV3a4aEesxHLgAYbSG5TpxQ226bqYliOxV5tyY8W2OpnjITEZvfOfseCBMTsB5sC+X4ypK1nk0WiBXlTcdZ+m+qT4qDJzmov8QNF8UEpEFFyKfK5hx4u3nWyDpSCeqEfwkCw/kZ60CmIsWJ01oOalU9LsKlHI/FRvTxIYvrhY8G6OFOjTWrav5JiY/rPDWtujoh7dZILC9/uMuOXoRRF7/SyYttVU4d+9UYDbfhlKrcbnYAmo8QeM7grPFTHc+pDjq3BBQJZUAcwBf5pM4c1y0cGyBmza/t6+RZuLn0O5EjC5DmIhSP76LuESTXQdOD6Y9vIYGOfcaJgnUY99Do5b5hwYE+voPIukPvxJX0osUR4VacRhbf8B/I2Vi78NQrdknKXEivw00a0GD4meXNcssX+SkbqGgHwOS1ETGCJd1+SOAXl09llMEiO8g5V3gOUm4bAv0vMCpOLe2Gtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(956004)(2616005)(6512007)(8936002)(2906002)(5660300002)(31696002)(6486002)(52116002)(26005)(508600001)(38350700002)(53546011)(6506007)(186003)(36756003)(38100700002)(316002)(66556008)(110136005)(66946007)(66476007)(54906003)(8676002)(4326008)(83380400001)(44832011)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVRmSmdaRkxGTzFHMVRsVFJGZFRKeDdGcTl3U1p1U0ZmRUhseWtNbWRJSURM?=
 =?utf-8?B?dGd1V3JNQksrQjQ1eTN5QVl1M1pZbE1Bd1gyRU9wU2gzUXBhaFlpWE5pc2FU?=
 =?utf-8?B?KzZyNUw1RGFjWEF3dzI0QjAyeEtvTVRYbU0vN3dXNmJjUGJEa2tEZEVBM0hk?=
 =?utf-8?B?S3VNOXdmYy9QT0JaRlVKUE5zVmJsRGpGSDhlNHJxZWpPSHJQSkxFRlNtWEtD?=
 =?utf-8?B?aXp4ZkNaMjNFQWxMRnp5L3lraVJGRFl1ODR6RFlLMFREUGs4dkR5UTQ4M1FT?=
 =?utf-8?B?TEt1N3NKQ1JYdXRpcDl5ZlUzcWtCVHRRZkcxbVhjL05oblpkRW0zME1tcWpw?=
 =?utf-8?B?MjJkZUc2ME5DUUxSZnBtV1o5YVJxRy9hV3MwRi9KVTF5MWtKNnc4dEdNMnl4?=
 =?utf-8?B?ajdJd0dSNUNKcld4S1VhMUErMDFUdGZ2N0ZUUXREeFAwRG9DaWU0V1U4Qk1L?=
 =?utf-8?B?UTR1RHpvbldxL2dMbjJpWDgxeGsxektWeWRvdHdPZzdVbkpRaGJmWDJmOTdM?=
 =?utf-8?B?YTJTaUdGZlloQWFFOTg1RUtkRk9kTFhXY2p3dWdIWlVXWG1qQmNYVjVNU1BZ?=
 =?utf-8?B?Z3JQOVJFcmpvbXVYbTQyeWh0Uzk4K2dLWkNpUzhLUHZZZGtmeFZ5TzhZOUdr?=
 =?utf-8?B?RndUMm5jdkxZeWJWMm1JdHBkUVZ5SVQ2NDZvblEzSGdzSURjUjZIL0tYYVd3?=
 =?utf-8?B?OXlzVk1yaThmNER6VnE4V1pzNFVQb1lUaVJxM2dZV3pVckFRWFRXQzdpQnZ0?=
 =?utf-8?B?ZjRTNC9zcExtcnBFb1NFa0xiU0lWL3BZK3ZNaW9wMFk1ZXZQSXdkeDJ5a3N5?=
 =?utf-8?B?YmJoMFkrMWVIcnFDL2llckZOSUliVVpmb0M1cnBFZG9WaEhLRzdGQndGK1lF?=
 =?utf-8?B?UDFhWXp2Q2IzT0J2dWJ3R3RuS0tiaXRNK0NoSmNqTU82Umx4eit0YjJJb1B6?=
 =?utf-8?B?ZklJTWd1aWhwdGdtSmNVdDhUK1FnWWhnam8xMlBpdnRzbXE5Q01HelhGR2c3?=
 =?utf-8?B?eE9tOW9MOG5tMWpxdVVuMG5TQ0hJWWtJQmpDLzdGbm5qYmVQSlFINTZYVlVO?=
 =?utf-8?B?eTdRdXZtL3h4WGd5bEVBdWY4MGN1MFVHU2M1UFBLZzFqMnB0bGlIMXlVYXo3?=
 =?utf-8?B?bktFSzRwU0JtejBmQVB3MmY5NzlUUHN0c0p2azc0dFQ1Zm1xU1BXK1VaMzcz?=
 =?utf-8?B?R2hTSVlPckdiZ1dWdEh6VkVwdDQ4ZjNFN0QrQm5jY1o4bVlMWjg5NHUwK3Jr?=
 =?utf-8?B?T1RRaXQyeVUxT2Nqd0NZdHgvTDRxdUhxOVZ4RUJaMDVDbUtwSVRMbmNpSTND?=
 =?utf-8?B?RVQvMzJxaEdLTHdmdGp1YUN0WHVXbWs5THpicnM0UHE3SDc5Q2YvdWI5THVR?=
 =?utf-8?B?N1FyQTEwM2tPV09oMm5iekNQN2ErTHdhVzlJK1hVdVlMMjlBb3VFSUY3WVNj?=
 =?utf-8?B?dlhwc09SWFBsRWpzR3FKQStPanBXZCtlZ3dVTXpxSXhtTmo3aTZkUmdPS1hR?=
 =?utf-8?B?Q0FRbnJGNVhSZDVOTm83a3A5ZEpCTmRsekFuZUloMDZWWThGY09DOG5IRmJt?=
 =?utf-8?B?dENUcFFjT2pmakhiWUxwNWtneC9nWklzN3c3bXlIRnBRNWFSRkRsc0c0ekZx?=
 =?utf-8?B?Zm5zVDR6TVNqcHp1b3M1V0c2NGtBWXY2VldsZG9XVkRTdVZFSWpueHFvenBo?=
 =?utf-8?B?cE1nZHJPWGdEY1UwR1N1SnRmaXJ4aml6UTgrU3plN3k1emZIdXlTVDI1NWU0?=
 =?utf-8?Q?FW9FC55AyZLFMw+rmUOKTwv0KJaqOdQAuIbKz/p?=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20b81d6f-f776-4295-da3e-08d97f6ffa0b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 15:28:36.4403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJyUj9j7T5fcMORU04Htqbn9w0jJRmXwakUsItclm4Wm3sNgb0ldsKqUGDGT+F4UAkUoxQj2WlAsbs+JkJNLm9VnXmYjgomyTZS8ZHqHB8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR07MB7633
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 24/09/2021 13:52, Sasha Levin wrote:
>>> This patch series is present in v5.14 and fixes warnings seen at insmod
>>> with FTRACE and MODULE_PLTS enabled on ARM/Linux.
>>
>> All now queued up, thanks.
> 
> Looks like 4.19 and older break the build:
> 
> arch/arm/kernel/ftrace.c: In function 'ftrace_update_ftrace_func':
> arch/arm/kernel/ftrace.c:157:9: error: too few arguments to function 'ftrace_call_replace'
>   157 |   new = ftrace_call_replace(pc, (unsigned long)func);
>       |         ^~~~~~~~~~~~~~~~~~~

in principle you can add ", true" as a third argument in all these ftrace_call_replace()
call-sites which still have two args.

> arch/arm/kernel/ftrace.c:99:22: note: declared here
>    99 | static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr,
>       |                      ^~~~~~~~~~~~~~~~~~~
> arch/arm/kernel/ftrace.c: In function 'ftrace_make_nop':
> arch/arm/kernel/ftrace.c:240:9: error: too few arguments to function 'ftrace_call_replace'
>   240 |   old = ftrace_call_replace(ip, adjust_address(rec, addr));
>       |         ^~~~~~~~~~~~~~~~~~~
> arch/arm/kernel/ftrace.c:99:22: note: declared here
>    99 | static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr,
>       |                      ^~~~~~~~~~~~~~~~~~~
> make[2]: *** [scripts/Makefile.build:303: arch/arm/kernel/ftrace.o] Error 1
> 
> I've dropped them.

-- 
Best regards,
Alexander Sverdlin.
