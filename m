Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0495A0FBE
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 13:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241176AbiHYL7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 07:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240886AbiHYL7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 07:59:07 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10086.outbound.protection.outlook.com [40.107.1.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F94A8CF1;
        Thu, 25 Aug 2022 04:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljN0+Em1UOClojHW31c913QJDSwXBhtcRu4C2CWAHPj+pivzp9SBrB6rWO++HAtTqawUicjTue+FoURNHHxuvhGFjw7nHJCXlri31BfYHzjSuLk3JQHseJWvW/dtau3gS83EpkH5A1r/aZfsq3fG0QNRX6oTkkhlmFAu4rs+W+YDlCSuTz/TbN3c2WWkxGEsFe8TDQpENLwPwDJTaCoZhhmS3B/DPlLfMbVa5C/vCa6bgMCWC3o5aCAvoxZs5XTsO2x2Dv+pVxjl/mPQhyyYgx+gBfT2AlH0/ZnJ/us70V98vI8nSA30lNpACwu1sXs0y0/7kXnlICHJTmQfHm3WaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgLqNjkKvx54cavOvEZwb4BeesXYydDkDbr6VRLbW1U=;
 b=eftEawJHCc+7OmpwTVHx0WKNPR9L7IWsh3ldhUn657vvZwzgAzB32kfEsx3bF/hTu6XRddL1e+ld8vwjcISIbj9qX5aMhFcIzY7bf0YSxJPwWjV80+vfL0pfuLPzcFHSiNkPPEK/jjGvulWlZi/oMMVw2VLrtXgjh7RoC9irbGKg8ZXJKHiOjDcPJIIrquTrdSyU7ckngELvmYseDHQN8wgi7DwDq3ZUhXpky1BY+jaRuJGazF6/nGKfB/KzlScKLAJbIbtwg0x6BHzXDT9Q196RVTb6ckF01aJldC/VrvM6arMPLnJiTrTEmp/qCVeQLlvcP1rELeC2EX7bJxOu/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgLqNjkKvx54cavOvEZwb4BeesXYydDkDbr6VRLbW1U=;
 b=irckHCB8kXS+pTF7hgKkKO/YLNk+2a7h8ODBHa4bte2Yk24MUCSe3E8g7yKzY3rXaBFqxoaoUGvb+YxLUIyON378zToBW+orVfqjH0aQ+jnVMirtIByiPvbBQYSZJ3lgt/N1/Ck4eMKUCeCCemO5q3GHvYShMJUvWYb9fcgseg2MhC2RtMilg7bdt155OEw0uFZWKIU7ZIU1HYeWQ6Z9HT515CBY3AZr+ZyEBk/ZojfiaakCDXESAFuvwqLiArTXLpgSh7Z8/4ggCX5kmasiwn6cn4MH1hrXrfHSOC7RMbwn6edHBwLFnsgZPFhaxGe/6hHOabige8dN0wvtrJ+h2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by HE1PR0402MB3370.eurprd04.prod.outlook.com (2603:10a6:7:7e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Thu, 25 Aug
 2022 11:59:02 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 11:59:01 +0000
Message-ID: <744be7c4-8e00-7876-5819-a1d07d3d423f@suse.com>
Date:   Thu, 25 Aug 2022 13:58:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20220825114004.24843-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20220825114004.24843-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::14) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14ccf690-428b-4e31-aa92-08da86913362
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3370:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uMTQjNGWVcBJY4XRKEUqZl3fqjYMF3pFTlVFrrePrnOX4RvtBjAvU5WilbqPy4RQ+y6B+2hYHmeqEJr5t8ZcBwZroyIFkxW++I22lEj6xoLzbIExwrHZEisoFJQCY46DE3up0YasF4P1ZGOVDELIkY2YGtAP4jeWy7dzPgyjkGILJhERJkP7n2PidQg2UsIJE5CZ07810BFFJMC7hCYCKOn77LCv/9C4liKwYs3lOXkkYDw42NqcVTuR+J3WmLiO54GxFX8L6aXlRZoJm0Hn5xR12187G6Jf5+L6wudNykgvr1A5AJ/a8fVGZtnl7dqTsObciNQeK09x7YkGTwrpxhtS+7vfeGBm5oS4cUGri8zUX8Tka8bNXPwcXBbVq6RCmk1tHAA8j9/5cbYfLjXtng97W3/klYUuEOg/S+tTeFbOE4pGZyZ008+03w97a/AXASPn97WHSw7azITsDxGbUcsp92Jozej1bc2cRRFcYcvwU5s6RqYlcK5DvpIwX2FNQFs+KuL/u0oAzTzlbOKBxk9XWAHgg3mMzdl/jMZZE8uY6rSWL9l3/OS27WpX8CyzEZooq+lHu/PfaUM1A62f7Sioejzj4BduCTVPAjeuc8lMWGj62BMJnyubCp97F9rRoKzwDjLYUBala9uKsMNQqZTVJuXsP/aJ+zzXoLpH62eQMVpljw26PXLRB0s7lBofQz5CVRg7YmaJNxjd7H/bHFHUKTPEm2R2UDlpqIXIdtdfafeBC5I9T1JeS0jwZf22zEwrpRPtOOAdlpqAvUuFoKknT26yUJsuNZWQIgL5xLY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(366004)(396003)(4326008)(66556008)(66476007)(66946007)(8676002)(38100700002)(31686004)(86362001)(31696002)(36756003)(26005)(83380400001)(2616005)(478600001)(6506007)(6486002)(53546011)(41300700001)(6512007)(316002)(37006003)(6636002)(54906003)(2906002)(6862004)(186003)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REs5MW4wcTRnNEpQUGFsbG5WMmJoWEtqWVFKblVoQzlpNHF5VHFQN2tOWkZZ?=
 =?utf-8?B?bDFpakx0RTlCeGZaRG1RVWRqZTJvb2l1TCt0WE9jMVJMTEgveXYvS2h4eSs2?=
 =?utf-8?B?bGNCK0pkbDhFL2p1d1QvaGErcStSU2JHa0FoTy82L3pGYzVMdnFyaWwrRVA1?=
 =?utf-8?B?R1ljZWhCN0VrdzBpd3V4RE16dmI0dmhmMWwvUU1YZ3d2c1QxODN6eTJ5WmJp?=
 =?utf-8?B?K1BzcTlaTzVEMEpCMFRLTlE1aC9QS1d2R28yek5xS245KzRhT2thbEFQVHFY?=
 =?utf-8?B?QWtKTktCSTcrOVNCbVlBR3BIT21xRWhMWTB6eXVpZXByMkozYjFIMnBQN1VW?=
 =?utf-8?B?WU5CYXlzaWd5eWVqZ2pSSXRNdG9JQ2JhWk5JNWxJbmdKRWlNYmFIaXZRZ2RP?=
 =?utf-8?B?dVo2UXVDY2NxSFNYQ0xJYkYrYkNJVjZ5Q0lGSUp3aVE2YUVPN1dtQ1JsUVh4?=
 =?utf-8?B?UzZhd2JtL2ZtMlAzakF6dk1NY2xRYWhsQXg4aE1Wd0xCUmRpam9rczJhVEZO?=
 =?utf-8?B?S012NGFNMjE3dW5tQllFRUVFeWdFUGRXVjRMRjRwRWttS3krUkpYNDNSTVNO?=
 =?utf-8?B?RmNxU25TYnB3Yko5czA0RzFLc0lTSG1WblBWWHFzeDhRbUJDZkVlNy9MVmVi?=
 =?utf-8?B?R3VFMGlsclhWY21kVnJhWWZjTit3VkhQV2FTU3cxbmRKNjhiRGovRGY1aDQ3?=
 =?utf-8?B?dHVsd1FJZkFOUGN3cVhCMFVYVXlabEFQS1VwT2xka1IzL2I4Tjd5YWNKWitF?=
 =?utf-8?B?UURvVHFaZjczblNWSVA1UHFINVI4bFQ2YnBGeU5yN29STlNyUlI4cnZMaHky?=
 =?utf-8?B?WmxabmozR1VHWDNBVXhmNWJkN2JuMzBaY3JUb1JIRlRWRVppNzVoeFdjcmM2?=
 =?utf-8?B?Q2N2TGcwdlFBb3JEQzFRUlJva3FNTHdNMXlLK2kyUVI3NG5aQ21BT203cytp?=
 =?utf-8?B?NzQ3VGc4RGFRTzJYWXdWaG0xRW5zV2FIMmRLaVh2cWRqTkx1YVpQNzZRekdN?=
 =?utf-8?B?RHdZSG92NnNQYVJTclpsOVN6WE80OE5DN25TSHJzZjU1emNxYUdzMFNYaEMz?=
 =?utf-8?B?K1JhR09PYlJmTWQ0T0RpWEJDbUUvRE42R3lKeS9GWmh5dFkvZFNVeFVuWkpC?=
 =?utf-8?B?ckdpSlZOOXZnYkxjL3ZKajZpT1dHVGxwbUFrcWJnL29QcGdoSGo0SkFzUXh3?=
 =?utf-8?B?cUY0dlZtMW13RVdWUHhGTG5FMGVvRUhzRVBwZ3I5TkJMdGVJV1lIMTZWYnlv?=
 =?utf-8?B?ZGRCcy9RbW8xSE1PSC93NFA3bDR3YlJBMFVlUzlHdXpmTzZEc1plOGlYZCtN?=
 =?utf-8?B?WGx3b05xMFRzMkE1OU5lcmxydllQOUNYaGxlWTRySkp6aHU0Zi9NR1lLY2ZT?=
 =?utf-8?B?dWZHOUY2VUY0b0FTay9Md1JtUGVaTmdPTXJMUzZuNzQ1N1JGbG5raHZMRUE2?=
 =?utf-8?B?b2xobFdIRk9vRGhVMzVjMWFLRytYb21uVm9PV2NpdUFXc2dRQWlwTncwbEhW?=
 =?utf-8?B?d0IrWVM4bytENXdTYTJBRTFyT0YzTGxFcWVJRG1ER0RNWDVRTFFzemhoRHp0?=
 =?utf-8?B?RHpMTVByYkw2dlBWUnAxUkhNZEhBc0w5aGw5bWtsekZkdnFobzJOMTFjUVFX?=
 =?utf-8?B?cmxJekRjMW5kMTQraVhSdEgweHFEMmJTd1NGWi9mWVhYYzJpMmFVLytiN0lX?=
 =?utf-8?B?djJud0F1ZE9EOENlWEQzUDA0RFZIRG9ramRKNW1NY2dOSXNpNGRsS0JnTlpj?=
 =?utf-8?B?RHloQnJNMnNVK0ExbkUrcVl3b3NYUWZxbTZWSVBLNkFqRXJhMk5VMi8rWjh3?=
 =?utf-8?B?RkFVZFBuTUZ2Mmd3aUtDdVdSd3NNMjhZV25sMlJXVTBzcGFBVWc5eDNPUDhq?=
 =?utf-8?B?NU5BdVpLTTIxL0NvTG1YT3FzZDZHeXRNOVFmdmNyL2VRczUxYlp1Szc0d1B1?=
 =?utf-8?B?Y0d2MkIrcUwyaEZWK3U0eldHVEl6YS9Wbml1c1pPdlFFcktYRldRUDJsb05C?=
 =?utf-8?B?WjNxdy9zSGRHc1lxWkVSaWQrWC9UQ29paUViUG5MV1FsZ3BpTjRIR2k0b2No?=
 =?utf-8?B?VkdmUXIwR2hjL1Z0RkNESFMrMndRbzVxdjZhQitIWkpqYlNRRjYraGFHUXcr?=
 =?utf-8?Q?HcqZsymcYqNC3dvhDqY7OZANN?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ccf690-428b-4e31-aa92-08da86913362
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 11:59:01.8393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pEB7r9IoTbm9jjMhgTGqSUrd/gi8QRX5XwJL331qlFBpxSmE7I4b7VAa40Bwxfq67EobPomMjVqCMlTQY2oRxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3370
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.08.2022 13:40, Juergen Gross wrote:
> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
> @@ -581,7 +581,7 @@ static int lock_pages(
>  	struct privcmd_dm_op_buf kbufs[], unsigned int num,
>  	struct page *pages[], unsigned int nr_pages, unsigned int *pinned)
>  {
> -	unsigned int i;
> +	unsigned int i, off = 0;
>  
>  	for (i = 0; i < num; i++) {
>  		unsigned int requested;
> @@ -589,19 +589,23 @@ static int lock_pages(
>  
>  		requested = DIV_ROUND_UP(
>  			offset_in_page(kbufs[i].uptr) + kbufs[i].size,
> -			PAGE_SIZE);
> +			PAGE_SIZE) - off;
>  		if (requested > nr_pages)
>  			return -ENOSPC;
>  
>  		page_count = pin_user_pages_fast(
> -			(unsigned long) kbufs[i].uptr,
> +			(unsigned long)kbufs[i].uptr + off * PAGE_SIZE,
>  			requested, FOLL_WRITE, pages);
> -		if (page_count < 0)
> -			return page_count;
> +		if (page_count <= 0)
> +			return page_count ? : -EFAULT;
>  
>  		*pinned += page_count;
>  		nr_pages -= page_count;
>  		pages += page_count;
> +
> +		off = requested - page_count;
> +		if (off)
> +			i--;
>  	}

Initially I thought this would go wrong only on the 3rd iteration, but
meanwhile I think it's wrong already on the 2nd. What I think you need
is

		if (page_count < requested)
			i--;
		off += page_count;

or with the i++ from the loop header absorbed here

		if (page_count == requested)
			i++;
		off += page_count;

Plus of course off needs resetting to zero whenever i advances. I.e.

		if (page_count == requested) {
			i++;
			off = 0;
		} else {
			off += page_count;
		}

Jan
