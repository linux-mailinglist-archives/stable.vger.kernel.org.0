Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEFD5B9DA1
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 16:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiIOOpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 10:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiIOOpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 10:45:50 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150072.outbound.protection.outlook.com [40.107.15.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE63E30F45;
        Thu, 15 Sep 2022 07:45:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKydMhYbXa2Dbez1VE65D2N7NnO7U1TEMEccd5LOM/NGf/HaC0HNbVzldR3Og5hVZUGsI4fJ9yWMMoSL7UoOJ+QAC6WPGW3PGwbVPNzeZpwPCQxU3BTxELA7hicIfiECWcSqRqdYJNdWIo0TTV7fBOa2I+SQR4qkZUYKblGUxZDFfpPAhFgqbNRKrcv7030/kG01EdnnafiKoepZu5KRFBwjQEUWTwAyry3bHIA37VI/H2QeOBIyNdE19LuFko0s7haGZvbk4cJXFKfVIJiwphp4ZO7fR2FixydeNN8BqKheh+CKDgOUcDjWiIK9sqe4LtnBlG39BMrqlvMYPsHOOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJjeLxH1Deci1MDiuriHd4zkXDSiqoNcZH5YXYjOS/E=;
 b=NPx9nwQoeSTqwWANsk0OF1DY2oZQ1GGriA8avOKwXsNo06gDoGMLsAvJ+rpuiPW3iIa+5MomibNXwqgjxDAImxK1chXGoKHPOQOl7eBJtKcueADCxV/LMFTz1AMo7OE9skGqo/oeED+tkeVfhNv0e6/Zpa98MpKfolQwgB/WNaXxvVbNydj5UyUaLCLC4UAVW0hHHW3zNvjWW6QEg1Ok8VTeXOSIlJzz+PWXO4BJe5LYNnjv45gOT1OI1E8TmqDGlmeiTBW0JDDCj3SXsCs7pDBbnuslrQ2AADAIHq1tYXfv7zzbI72prXgrqTcvwdpxHcS/6AnEDatuJezZxZeohw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJjeLxH1Deci1MDiuriHd4zkXDSiqoNcZH5YXYjOS/E=;
 b=DkWaCTSvYMuvTtOvARyEiN7hKL9E0XOTC0y3a7ffIhT1d98WDVsoP2yCyvzNngDmgxo0b3ZW5pSOTKjtOG1dJ6V2SDc1eJogBTmMbEd4U9sX5F0Ijnwl04M1r9lTx7/cwHxpG6zLtBuoqMkgSYRMKWSCxV2WHlJK+OaAkk/YFQOjQ50eGXCxLaO3jI9Y7ydueDeSTvu0OQ9KCLeoqVQvRzEKUuXfawKUfCT9nKO0pr8TshaYliqn7Qfk3JcVcZOSHxj0EjZQFseU+ee/VOmoH72P+0WfNX8d8qNrbvQqpV7bOuJr2hHEk1C86HJOdkzPCTWa/TJG8F3yPxkE0zUZ6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by DU2PR04MB8869.eurprd04.prod.outlook.com (2603:10a6:10:2e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 14:45:46 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::59bc:901a:98a7:76d4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::59bc:901a:98a7:76d4%5]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 14:45:46 +0000
Message-ID: <d8b7f77c-03d4-be57-b342-ae84d1ae38b4@suse.com>
Date:   Thu, 15 Sep 2022 16:45:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] xen/xenbus: fix xenbus_setup_ring()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org, Sander Eikelenboom <linux@eikelenboom.it>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20220915143137.1763-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20220915143137.1763-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::18) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB6560:EE_|DU2PR04MB8869:EE_
X-MS-Office365-Filtering-Correlation-Id: cf0e6ed3-a791-4ef0-926e-08da9728f931
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PztQYUn97TEjum4d5sBSp9fGeqA8Ylu030FJEoj2JTOolNmLaphpPX9Mmz5WeCAovH5FcNuIwobHDlgCA+VjRZvnHVbzF8rvc4xotSVIaeFdeK2QMk5ZSqhkKr4iEETvKRZc7a+hVdRP4KT26pK1rNoVIz0XwcmsAwdFOaMbup6RyOpnZGfHY+FpMkFXNXUC4gikAb8+boHbzTmPtcdQbEoEWgBN13deNk+o4MkwLiSGF7DXdIwSdQYt2ZfepKBALlYxEdAbfupt20cFbsUw84PL15wdVCBP3YXLTZqn14TsBALMWk52G2C5SfnrXY5O7Qp6Ixi+rBkU/bQB3hOhwIcadXqPI7ENhn/UaOId0wSBbGl5uQoEaZpGv5lbWNTi5jsfOVgbQXoZjd8fpDXxOH514kAeInMetIXq7e0ySAEUmplTpV7RTR11ZxRf55GRWdbOJYYTd6dph6Gf5iXWM5KXd5Au+3thVy6U50lFKraE5KR1w/9DW91NtbU4xm6YhZ0YMZpihWZn/w+Z6tXkcJ+s02PUs6P3YG4e1axzuSnSLOvgbsYl7gYex9nVokvGVjDuwEufIPDvd3EFXjEzvhXa8bFhTB+S93aLMjrI+4tPp+N8lEiRXs1Y1EbZPC/QQyPkF+Qay90D4bzU3AM9SYmOXTpXGQj34dwLw1M2svceGNW13SI9Ox2x3E84ZPVdMTQ1dXcGw6g1XG1wnFmHlQKGVLZFY0MuX5RX4U9Sf3QrEf8mh7ILBDyXsDnahA7152mMCqQHhvoiDPhcyZR50gxXLH6iHvsGUT7IvxAC1Ao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(346002)(39860400002)(376002)(451199015)(6862004)(6486002)(6506007)(66476007)(2616005)(37006003)(8676002)(31686004)(31696002)(36756003)(6636002)(53546011)(2906002)(6512007)(186003)(54906003)(86362001)(38100700002)(4744005)(8936002)(66556008)(5660300002)(316002)(66946007)(26005)(478600001)(41300700001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzJXSlNsTDlHRE9NNGNxQnFsaUVJc3dndE4raUVQakhSYzYrMjZuRFQrOXlY?=
 =?utf-8?B?QXk0WENZV05YZjdCemFlcjN4M0Ywa1U5MHNmQXYybzIvN0RJNS9RZkROOHR0?=
 =?utf-8?B?UEZxNEgxWGNycGJwTi9hamovS1I5SzFyNkZEUUdUZmtnK0xxcEhDY2xSYXQ2?=
 =?utf-8?B?NHFEcVpsQ0xjeDBselljdmgySUtQa0VSTUdaVXp2K3lOeDFKUEFYdUpLOUNu?=
 =?utf-8?B?QTlnZnB6bVpoLzRKVlB2RW9vZkhld0k2NS9SYjZwUkhvYXZYcWl5ek5UV3FN?=
 =?utf-8?B?bmhHNTNzVVBsT016dU1wdzMzL1RpbkxaQm9HVjlXR2tBSWJjM1d0c1MvcVhC?=
 =?utf-8?B?NDZNeEY3QU1aS0pZVTJQSER2T3FicjBSZ0MrVHA3NFFONVNRMlZKUEdVR2x2?=
 =?utf-8?B?QXNLb1l3cmxtM0FGVzlRbUEzekRZa2M2eXF4UUZramNDNStiaWFFR2E0aldo?=
 =?utf-8?B?RlQ4WUtoR29IVk04MElMNy9FdDBmRWk4NnBkbyttQUJwYzREbzdyK1FJam9T?=
 =?utf-8?B?NGtxRE5Gby96b1c0VkdDcVVkYjZqZk1PYUVRR09LV1VCcUY4NkM3MmhiNTNC?=
 =?utf-8?B?OXQrRVM3ZWhXZlplTzludldkMUg1V2VJZFFNcUprOS9RL1BDTnEzMnF6V2lt?=
 =?utf-8?B?dlBhQkJWVzdiemRlVFJYQmlGUCtuUkZIeGV0QWMwWkMvVGFWZVRwQ3RIRUlQ?=
 =?utf-8?B?UmV5Qk1wRW9kUzRoSzduVlkrTisxdFhxMEtadDhTNnNzZzZVZVBuVGdScG9L?=
 =?utf-8?B?cmhyTUgybGpiRXlUN0FGSkUrZjI0TTlBUFRHdWJ1S1JBWjlkbW9NYXZhb1Rv?=
 =?utf-8?B?aERWUG9sREU3SDRDa05LWm1wVWE0aFZxMDVTZUFHbk4wNUFyMjlJVU9POVBJ?=
 =?utf-8?B?ZitYZEVMSmZFVDdpa2RNbDBwcnptcklpaXM2Q2dXZzhmOUtzYWNoWFNBWXdQ?=
 =?utf-8?B?aHdaNTM5QVkweUx1dzZFYkd2bW9BMzN4dW1vcXlXajU1NWVMYnZHRWNNWFdK?=
 =?utf-8?B?SG5ydnhjVy80cFo4bVFsdlpVTldqY0RhdGdyYk5mSDNCUGhmUnd1N3hNc2tL?=
 =?utf-8?B?UnFNVDFVVy9pVGhOT2xVR2xUeGhsek56UlRNc2hqWnpUVGllQ3RMdmtVeXZi?=
 =?utf-8?B?VWh5V3E2ZGg2eTZnaHg2LzRkMUloYlg0dWpGLzRTdzlQekFheE10SFZYRm9k?=
 =?utf-8?B?K1Z5YzhrWmhGeHlwNXNhNnRDRm5Kd0FGOEQxZ3hUOUU1VXphTmxsRG9JTytW?=
 =?utf-8?B?ZjNveVpmOC9tdE5PNEZ5dzdKQTFkaUx4bTE5OW1jQk85M2tWTGhkRyt6K2E2?=
 =?utf-8?B?YjRtSlI0a3hUYjhJci9TWDlNaVh3YW8raWdEc1JzZTJobzg3aktnRC9qSGZn?=
 =?utf-8?B?amE3aHZOVi8yR1R4SEZ4SzFzb09JZ01xZldnUmNyc1hjZldrODg4c2c0bGhC?=
 =?utf-8?B?bVZPTEpVeTBWR3pNVi9IQVVhSVpZTVVQby84QWpzOU0vTlQxdm95Q1ZaMW8v?=
 =?utf-8?B?WDFEVncwRHk0V2gvcGozeWcyRE9XOFZ5ZWxFR2ZaVVJYbjlsQU5leDIrYjhs?=
 =?utf-8?B?VVVtaTRiMzgyaWpXeGlHRnZaTi95UE1CY0lxMmNMaDA1em1WRC9EZG5Ua2JL?=
 =?utf-8?B?dlZhS3JWcTU3WFVyMDFPSjMzS05uSEJFU3VoK0YvNkhFaDRpOHgvZ3BxRG5x?=
 =?utf-8?B?NUFacVRwamk5Rzhla3dYM0ltcURETFpvY0YvWUY2L29SYWhIa0JVVkF0cEFD?=
 =?utf-8?B?VEN3WUhlaGdCQU1oNnFkdmR2TmxwbWV1TnNFSXR0Qi9mQTdPN3pKRGlIc1lP?=
 =?utf-8?B?QUdzcUhKSGZ4emlWZmtLc1B2bDJabnF2WENpbCtnRjRRVHRjUDJ4SFdXMmt3?=
 =?utf-8?B?b1NVSUE2VWYrOFFsNlZ5SmJYVFR3aVRuY2NvVFErR01mWHd6eHh0RmRSc3Aw?=
 =?utf-8?B?bjZLTXVyK3FHSHV3cDVRMk1YUDlITG01UGRIMjlObDM0dDJsVkFBWHFzWTRN?=
 =?utf-8?B?eTI4T0k0RWErMzQyV0NWUFFKenZwNU5sVmt3ZWFvcXcvdEwvNEFYR1BFQzJG?=
 =?utf-8?B?bVBaS1dkWURlMzUxOEFva09KS09tUThFYTYwd3FzaGJaaVlBVGZFZ0lDTWZ1?=
 =?utf-8?Q?TwceDnS36OdtCTvJbi4QCDCPr?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf0e6ed3-a791-4ef0-926e-08da9728f931
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 14:45:46.3170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wuB47+DsDCniwhJnDoU9M7Qt064zvDZh3USwVMlD6aRmTTbP+OKMIxSEpdb7wYVluDEpxubIKvLLn3tOUaLZnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8869
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.09.2022 16:31, Juergen Gross wrote:
> Commit 4573240f0764 ("xen/xenbus: eliminate xenbus_grant_ring()")
> introduced an error for initialization of multi-page rings.
> 
> Cc: stable@vger.kernel.org
> Fixes: 4573240f0764 ("xen/xenbus: eliminate xenbus_grant_ring()")
> Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

