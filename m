Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83ACB6A9520
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 11:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCCKZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 05:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCKZi (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 3 Mar 2023 05:25:38 -0500
X-Greylist: delayed 1358 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Mar 2023 02:25:37 PST
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6125B23659;
        Fri,  3 Mar 2023 02:25:37 -0800 (PST)
Received: from pps.filterd (m0209327.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3238cgb6024886;
        Fri, 3 Mar 2023 08:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=S1;
 bh=kd9fyhb4A4Bg3zxA0SX/7pXZCwkoLX0uiLs9m3vgeTM=;
 b=h09YcgGswbVNsBwLLFe1N97INiSIYaVfWGEpmfcmehPo8h9Z07v7oLfkSMs+2B3cimEb
 2orOTvmo5F0kJjJ8wInzWC/UsZIVWL+Bg2rAp5UZQQ9+zW42xjm4GcDGPiWbFP61L9g0
 ujloSJb9+OHBSrrzIeGU1BHhqYikkNIYcW0mA51PlRuKUA7K7lFwcJ92FtPB4LngfwaV
 ZWgbHiFOMT6AZ1l2d3wxiDg642vdy1UhyCRXHw8PNe68Mt1d8oiFSjCnycl8ZapTeYfv
 SazEZJgpIpDi/4ahGSK4+bhnBhYA8+W8Op0jUN5wgxDjqEcxWFQWF36adHuqPeCvMvBI 4g== 
Received: from eur05-vi1-obe.outbound.protection.outlook.com (mail-vi1eur05lp2172.outbound.protection.outlook.com [104.47.17.172])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3p06n1n3f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Mar 2023 08:51:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOuGejFjYOgLrzr7BJ7HkLRsYRSrVWjhs8DmuXxv9qYv65LP0YooM3/ttlPoFaIDeAJWb6bgpKlB+7sFg9dBcJxMk9eeSGvce3zrXEluRNSY5bMG0NaYz8nkhswfo7cRpE/1sri8pDKUg146zNCU87sj5+QmHEpMA9+LUY507hkLhqTADMMvkyph5DiIO9YZcJ6K19NVGOtrM77YD5UCnbQolCOjyLoFNbjqiGtNf0yO5y8nr5f/G1lQQt1QZ6xv6iyOKHzhI2J0W8nuQ0uXT571ZtHBEWJd9iW8o9UJ73fsQiLi0CyToAjzga+Q9nTF/WBoEEhCKe1hOPBOnKMJug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kd9fyhb4A4Bg3zxA0SX/7pXZCwkoLX0uiLs9m3vgeTM=;
 b=deLgZg6Sk8BQX8hfNvN6MyBYUeuaGXnm8L4WilXTeMErIrhUpArKMFGQsNbCt+WuMmiksoGxX6WKgYkKusWF2lafMVsDZ5fxdYFJGDtLre2/Pen+hhoy7jhWbX3qPD/vYWwjfGVRo6sFgVz2jCc1ONuK1LuVRKw3SfmWiq+VbUHKydp8xvUn2VhPkddbq31+mc7XJclwR0JF2t2GdJsOrJt0MMNEPxiyKVRpWz90qY3gWHoD3i8uyA0o0zSD3e5C0kB2+FnyzJmlboqAUWTPc3HzReIu+TIG9C/ONSk/OorpJNWa4km10ZfKGye36qKkq8luVqU21K9qutYI6snXZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from AM9P193MB1332.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:30d::9)
 by GV1P193MB2151.EURP193.PROD.OUTLOOK.COM (2603:10a6:150:2e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Fri, 3 Mar
 2023 08:51:18 +0000
Received: from AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
 ([fe80::b1ea:2de8:5297:f6ab]) by AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
 ([fe80::b1ea:2de8:5297:f6ab%4]) with mapi id 15.20.6156.021; Fri, 3 Mar 2023
 08:51:18 +0000
Message-ID: <6f674f9e-9f32-dabb-60be-0e757e145b14@sony.com>
Date:   Fri, 3 Mar 2023 09:51:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/2] maple_tree: Fix mas_skip_node() end slot detection
To:     "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Stable@vger.kernel.org
References: <20230303021540.1056603-1-Liam.Howlett@oracle.com>
Content-Language: en-US
From:   Snild Dolkow <snild@sony.com>
In-Reply-To: <20230303021540.1056603-1-Liam.Howlett@oracle.com>
X-ClientProxiedBy: LNXP265CA0048.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::36) To AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:30d::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9P193MB1332:EE_|GV1P193MB2151:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c456ab7-42dc-4517-cd87-08db1bc4742f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WTXTWNydcsZgVa0JLEnUqVk5UjEnNuVH6ndQy89X3gxv6aQ1O6gnQ+yQyH6m8czFzv+1L0O52Yzh586ZGG0tIPDl5vlI0NacPQdxwIxfcKA9sqywgDi8JCY3FJeXeE6awGo1lYuFQMFah6dgTlZalcixKbrLWtv3khHpYxskDmesdSag+lFxkX9F2FlCxe2MvjpXig6lV8VB+170B59MgxTVr068zMTGRlErW1IWT7V8KqjXGM5nXVB3dL8J0XnRGK96lvkYFGxtRhUi93XxAuF59wZVuq89WOeL0rnJyBA88YpDD05B1k+ubK1e6iA0YM6m3Lz5huPUzJnps60wPI0qJxmZBsEFo09CyJMf8G2BKvVQo5kY5yvH0NCYSfa8kCgQZrhR9E9obl270sijR2HVDTkoGxpuge9Z1XyUp0yKg25ShH+xBRwlKSwwtwyQU9MRyKpnEIIS2G85YPCJ6PccaVLVSMSA9oPmNd3Ha8+uhIyZYsjPH8G/P8I4Fq4B5yWd+xElivQFbidI150NG/TT0LXH+0Gt+otWw+nbXHopt/zDNxHDDakvSSj4nJvxCM5hHXO4ECw8vji4Af4vKmCEH8qf4lTb5Z/LLtLnyp26MQ1GJ6zAH+apwu+3Yudr3rXtvR7iley2Z/iUy8QvV5llfNbzKkAP/UDpuCOKB9SfG0A2tkgmzucV1LgOErHqJbQqrBVRGCsjr0Qdd4Dj6+VNx9aRNwEN6feRIpvAEc0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P193MB1332.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199018)(31686004)(6666004)(83380400001)(36756003)(478600001)(110136005)(82960400001)(38100700002)(316002)(186003)(41300700001)(6486002)(2616005)(6506007)(6512007)(5660300002)(66556008)(31696002)(66946007)(8936002)(2906002)(66476007)(8676002)(86362001)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1NFOXlkL3BQaStZeGVoWjU0VXEvMkd3K1JlaXFTU1NaTm9oZDhyYjczb2Fp?=
 =?utf-8?B?bkMxWURRYzNUUDNxdTRvUUp4cFlhVExhUzVXNFZ5KzRPZ21xWlNVQWl3Y3Nj?=
 =?utf-8?B?azZmWXFSczllTmV6am5hekZUTXV4UXlRemZjdEpSbktyemRnVW9xaU1UWldr?=
 =?utf-8?B?TC9aQUlBTDlXRkRIdTdRSTBjRm5XUWhZSTJnMWdqQnVsT0pScGNWYWhZeFBv?=
 =?utf-8?B?S3BLN2NiUWF6SGJTZ2JNUEhmb3VycDBxTk9ieGdobll1NVlOSWs4OXJoQXRF?=
 =?utf-8?B?dXZQUGozeU9xcEkzNjU2QU0wRjRBN0pSTjExL2NISUhRbnU2dlRCQWZyQStM?=
 =?utf-8?B?REJVZWlWK21tTlZ6UUpLQm9paVhraUlSOEpSbUhhamlnVS9PMHhMaktUckhL?=
 =?utf-8?B?UUtxS3F0YlpWbUxxY2ZPcVpFRzRjT0Z5L1pPdXJFc0lrbTltQ3BsQWp1eng3?=
 =?utf-8?B?YWkxQWRWN3dPMmxjNmtMUDFRNSt6NzhVcldrVVNiZnlkaG5HdjdHM2l5OHQx?=
 =?utf-8?B?bWx4RjhxUGJEdjVxeDd1MWhTTjFoUVpGTVJSQTNUQ2RZUzlsdmQ5Tkd5c0pR?=
 =?utf-8?B?TzE2Ry9kWE1aOEZGRVBSejMrWkRRWEQvR3hYYVpkZnA0WnBWQ3JjRjVpZHR3?=
 =?utf-8?B?T2pDSUgzOHhJblN5S0czY2NMdVRoN0lDZEtEQU5PdEd1WHhsK25GYndmNW45?=
 =?utf-8?B?d1lDeHRCVjZ4QXJwK3NhbmM4dlVGZU1rTGZyR2JBMzkrMUtZa01VQTJsZmo1?=
 =?utf-8?B?K05EOXRVVUQ2NzBkWk5KZlRodzFGTEhiUlZpTlNBS2JtWHFJWUkvRHVQbGh3?=
 =?utf-8?B?RkpDcStkbTJndXJsQ0d0M2NzaDJYc011aSs3KzhLZkVMZGxmY0VRa2g1bER5?=
 =?utf-8?B?NHlYNTNEbGUwYngwWkREN1hLYTh2TjlVZXVNK3dLUmtTMldrVDN6STI2UzJC?=
 =?utf-8?B?QTlSYlpwYmE5cFBhQ1lFRTUzb2hXWk96emVmMjdNc2Z1b0RXeGE1TjFaUHY0?=
 =?utf-8?B?UUVkOGV0ZHdEbENhcWFETWlTRFJtNzZLZmpVZXIrTlBCNThVTEZmVm5EYjJV?=
 =?utf-8?B?SkpmNUEzaGQrakovbndQUkdFV0JEQWFyYTZwZXJ2MXNjSm5wUmxQYlBYQllt?=
 =?utf-8?B?MUcva01OTWRUeXpGYnlIVnNQSW9reXpHTzB0UUlKbTFPN0NlQjgwMW5MK0Er?=
 =?utf-8?B?OVVLZ3VGTThiTUpyV2NxVmxNZTlxSjEvanRSV0hhajhDRldzN2JIQkNreUxt?=
 =?utf-8?B?dTdwMkU5OGN5NituOXl6Q1dySnpUQzhHUXFrL0hWZTh6K2VjRVhPdUVNbXd6?=
 =?utf-8?B?ZnI3Vk5ObytjZjJsa1BHL2IycjFNSnZuUmFNZnVVcXBQeklFU09nc0dTdkN5?=
 =?utf-8?B?WWZqOUJHeHFkVkxBRVMzWkZZK3p6RFRTMVAwNzkyTEdYdDlpMVlEYlZiMEhH?=
 =?utf-8?B?LzBIWm9WQlRsTmsrc3VuV3BHNHFxSzV2Wk4yU09IMGVzYk1jOTlldUhHWStX?=
 =?utf-8?B?SmxSSi8vd08zWVBGb29oK2Q5ZkN6dmJwNmlSTlBScUVsMHBIOUNDcjQrQWM5?=
 =?utf-8?B?NXFFS2lPQWxsK2NiMlJ3T0YwUGZ4NlNNOHRrbUxWNlV6cW5SNTlJRVc5anR3?=
 =?utf-8?B?WTZyZ3Rhb0JUTG95QVVwU1hmQW5jc2xFUUpCaHNuNlUvREZDVGQrYndWNytD?=
 =?utf-8?B?cEo0cG15ZlcvVXo5SXdPdmNEb1RmOVV1VXBmSDhyWFVrSXgwejFtMVlzajNV?=
 =?utf-8?B?a3I4NU5ZUFNQbC8rcXFCK0xvL3hrRjlmWXlQRjhGNDZHK2p1UHpCc1c0clIx?=
 =?utf-8?B?bVNkUHpmRitDb3dKdVFhNUdkSXlYWEJvU0pLRVZXOTAxUmcxdnYrNE14enQ5?=
 =?utf-8?B?b3R6OTh0bjB6Sk5IU2VhbVU2N1ByK1JhWEp1Z1JxVm1tTk5UQjJlUHJmNnZZ?=
 =?utf-8?B?WHZZUU93enVvdVc2SS82Q01wdUxKUTYwdEh4TWM3OVZBMis2Ny9DemdJR2wy?=
 =?utf-8?B?UUlYVWRBSVdtenlnVTRQR3RuQVJON0FSV294Vk0vaVU2eEIzZjhHZDRXMUFT?=
 =?utf-8?B?dzBmR0poWi9oZElZMVJ1b1U5VXVYU01jQ2g1aWRsd0JQUHdVZVhESVUveUdi?=
 =?utf-8?B?YlRraThtWHZCd0l1UWN1Wk1kSEVpSFVDSnI3akRUTEMvekdzRGZlRWkrMGhK?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NlJ1K0tuMnNFVm12VlJRTEwyVnhEalJMZHpKRDZKdlRaRXh2K0l1cExMcE00?=
 =?utf-8?B?YUY5VmFoclYrRnlqUlFCYXRCK2d4WUFnN1NRanZpNmdwVlBZZCtaYmNZQWpS?=
 =?utf-8?B?SFZheVJXOUxTSG1xQUxvZVlSN3hhS2piaWpFWWUzWm5Bb0xESE9HM0lKSnJv?=
 =?utf-8?B?UWdLMllxbkNEcW5EcC9YRHpZeERzdFYveGxMMmkyWVV2VzlKU2lkSjlmOVB6?=
 =?utf-8?B?UjJhRVhHNE1GNzdoNnRublpiM1R4TDgwTDRtZERsZk54a2JPY1YvWTB3N3Fn?=
 =?utf-8?B?cUNlZHNOOHhOL2J6Z1Rla3pmNmNWR3llSzRtcWJCdzJBZ1gzczR3emZoaTZv?=
 =?utf-8?B?ZU5GWTkwOS9zeXJiS0VvRGp6QTZSQUtBb0xPdjFXbS9RMERjWmxPZXVuQ3Z3?=
 =?utf-8?B?cnBCZkIvR3lqSGl0ckYvTktLaEZ5QVhqZzhwMXB2VEtjVUVxdC96NGk3Wnor?=
 =?utf-8?B?bXpqNkFzTFJGOGdmY2Y1dXZHMGx2andlcVRGS1F4Qk9Ca1VIbkhmUmRQM0Uy?=
 =?utf-8?B?UHg4NXBYTWJCNHlHSXNoWklkMS8rRHk5cnJVZFhzQlVzb0dPSm40RTlwU1A0?=
 =?utf-8?B?MERteXRKVDdrclcwQ01NVzR1dTY3dVNqd0NUTW1tNndVaENVNSt6VGNyS3hI?=
 =?utf-8?B?ZFQ1VTRhSXNHOFlDUmc1Wi8xb1JxSDc3U3NuVzI1MjZmTUhVdmwzemNoMjNw?=
 =?utf-8?B?VCtnNmpjMFRsN0VjUkRSeGVYREhYeTY2T1R3cjAzYVA1LyswSHZ3NnRDczBW?=
 =?utf-8?B?SUdCYjlFYTBiMkxtb1FmbzlyczdRWmU4elpkRnJybllJYnpUMlFUdC9ublhx?=
 =?utf-8?B?ZHVLSlp6clJ6QU1yOWhhcDJtTFBPTWUxcDZOUFVvdDc4OXhaeGxJVjBjbXF3?=
 =?utf-8?B?c2RwdkQyUlB2QWRQd01BTm1ONFpXaStFQ2xmc05iMnZsdjE1c3daSGkxZnNl?=
 =?utf-8?B?bFdsUjNXS1NKNy9GT0hIcWQ0bWZhejBYejFDMkFMdENHZjEyZDA4c0hRQ1Av?=
 =?utf-8?B?QmtVOWVKNEZaVWN6OGZLaGF5SjBhdTUzV1RhWE0wRHRjTkxYK3QvTnBHcVEx?=
 =?utf-8?B?dUVUUnROSE5pWjZwV1R4UHZib3YyQUZoZWcwMU5NMmxvOFR1U0tjQ01PNGNl?=
 =?utf-8?B?SzRCaG1hUXdwajhjME9lS29Kbk41VHEvZmNGY25MTVNySGZzeHhRY2ZYdlQ1?=
 =?utf-8?B?ejVOTnhJenBMdk1LNDZQTDhqd0Q5S05JaWYwZXVEbkVZZ1VoM2xUT1JqTmNr?=
 =?utf-8?Q?rFNINnX7l2fVHKJ?=
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c456ab7-42dc-4517-cd87-08db1bc4742f
X-MS-Exchange-CrossTenant-AuthSource: AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 08:51:18.1136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9dnEmx4/G+zIInVDgCAvDi9Ju+vjuLzHUQZca8+H1CLwHp2KV+aHGlZoozBm/bG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P193MB2151
X-Proofpoint-ORIG-GUID: _aZe8OqDk2ZsbkVFwUZwiCTKdhf-Fu3R
X-Proofpoint-GUID: _aZe8OqDk2ZsbkVFwUZwiCTKdhf-Fu3R
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Sony-Outbound-GUID: _aZe8OqDk2ZsbkVFwUZwiCTKdhf-Fu3R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_01,2023-03-02_02,2023-02-09_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks, this is a significant improvement. Applying it on top of v6.1.12 
allows my reproducer to pass most of the time (running as init in qemu).

Unfortunately, it's still failing around 10% of the time:
> $ for x in $(seq 100); do qemu-system-x86_64 -nographic -no-reboot -append 'console=ttyS0 panic=-1' -kernel arch/x86/boot/bzImage -initrd initrd/initrd.gz; done | tee qemu.log
> [...] > $ egrep -o 'Failed|Success' qemu.log | sort | uniq -c
>      11 Failed
>      89 Success

The failures now happen later, around 25 MiB:
> $ grep Failed qemu.log
> Failed. m=0xffffffffffffffff size=8192 (1<<13) i=1050  errno=12 total_leaks=29081600 (27 MiB)
> Failed. m=0xffffffffffffffff size=8192 (1<<13) i=332  errno=12 total_leaks=23199744 (22 MiB)
> Failed. m=0xffffffffffffffff size=8192 (1<<13) i=838  errno=12 total_leaks=27344896 (26 MiB)
> Failed. m=0xffffffffffffffff size=8192 (1<<13) i=282  errno=12 total_leaks=22790144 (21 MiB)
> Failed. m=0xffffffffffffffff size=8192 (1<<13) i=695  errno=12 total_leaks=26173440 (24 MiB)
> Failed. m=0xffffffffffffffff size=8192 (1<<13) i=1064  errno=12 total_leaks=29196288 (27 MiB)
> Failed. m=0xffffffffffffffff size=8192 (1<<13) i=608  errno=12 total_leaks=25460736 (24 MiB)
> Failed. m=0xffffffffffffffff size=8192 (1<<13) i=443  errno=12 total_leaks=24109056 (22 MiB)
> Failed. m=0xffffffffffffffff size=8192 (1<<13) i=549  errno=12 total_leaks=24977408 (23 MiB)
> Failed. m=0xffffffffffffffff size=8192 (1<<13) i=630  errno=12 total_leaks=25640960 (24 MiB)
> Failed. m=0xffffffffffffffff size=8192 (1<<13) i=820  errno=12 total_leaks=27197440 (25 MiB)


Just to make sure, I went back to e15e06a8 and ran the same loop.
> $ egrep -o 'Failed|Success' qemu.log | sort | uniq -c
>     100 Success

And with the patches applied on top of master (ee3f96b1):
> $ egrep -o 'Failed|Success' qemu.log | sort | uniq -c
>      10 Failed
>      90 Success

//Snild
