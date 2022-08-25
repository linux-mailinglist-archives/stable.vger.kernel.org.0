Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C465A0A69
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 09:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbiHYHjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 03:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiHYHi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 03:38:59 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2067.outbound.protection.outlook.com [40.107.105.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51C39C527;
        Thu, 25 Aug 2022 00:38:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/AKPh8Hk1ifObUG3hELu5YepjSW4zGG3CTra13N1BWu2hRl+rKaLtMLx1w9Y7r5GDYVggMN8msCrN5xcljzbzTSyvqeQOX+j46JwdNMBa2ofemWkW6CGbcEOPCQuIhejVGqLOJfyF3HJyrdBXC4S1K0AldGUb5pZTYmfzdk/QgQ7G+7Mw7lWpH9N3mfiHD3hviQl3IvOVC99ZFZn8cPIRDPKXqek8rT6k36oNi/uOuPs4JMVOxNGMmSekSGLVwQrBw+4drAsgHH6vWz95F8JW3XYem5GSKTvK5IUg5JuMTIX4odhqhW84QUDmUYNkIPyinjZKGA2Os6PtHYntW5Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3O6AAcG197ZLgdwKvrbRJiihxehoeIAjIb3c4a1ELTU=;
 b=RkQ5PqP+bz2F2eCJAr3MYdHe96zh+TCCW0mvZux58xK1o4B2dfqAt9At9VPT/BomORaD7YPRDMk+U319LU7dF3cM3wc2rn6lKd30UZok4imWvHagU7oJCxkEn37jUepmwFh4fFyeER2kjQFABZQa9ZNEljj1A4kWNIgjfwtYMtbM7NbBVDZQ5NB/fYv2QE/2pUu4mbcLJjwMqBpHpYu7VqPEM7RIOmR5r63MPOnHRqCK2oJbo9pap+nrQ5hc+9L69ylZl8dWzn+Oad1PMmu60tDfBf4CUtvD7Z6tGlCrt3L8ta21mANUGyPH0jIcXl+RSHSJte9y4LvuZbmnMw+PqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3O6AAcG197ZLgdwKvrbRJiihxehoeIAjIb3c4a1ELTU=;
 b=vf9NS6Ga7v1c7jK3yPAtelBAj2Lb28p6KJzN/zqhy7otPu8IAGRSQJHqBsZ3rtNcyOHCTK8NI5XR5+3EeRS1MYOrN0YFn+x77/62iWiQ9NwGEF9FpRAbCYUEqDLAezqHxqij6o07dTsJSPTwJLkziZ6B8gTqt9CfzvH9TBw9ShnRPrMI/93BCV4mXHqZRXBXEufJh+VWOS+fb1fbHXjTlI3DWxOlEM7OTBOy9Biknx4jMsjlDxPOg8Chv8lUWDcnuoKnB8AOI2/m6XqAEAcEXBuYmb/sqkS+aKWfYqNhHqj/6/g0EdtoNhALQjX8rZlbUa+6Kp0vPZZaRB2hNIrjHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM9PR04MB8570.eurprd04.prod.outlook.com (2603:10a6:20b:435::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 07:38:54 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 07:38:54 +0000
Message-ID: <396156e8-304e-ed68-8596-ee544dce0373@suse.com>
Date:   Thu, 25 Aug 2022 09:38:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20220824142634.20966-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20220824142634.20966-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0108.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::11) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bad9774-940f-40f5-b5ec-08da866cdcf0
X-MS-TrafficTypeDiagnostic: AM9PR04MB8570:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FTx4ZfBQUcMkev47/i3T1EZHb7kyLto6H/hkaQTmn/fhyaIq4uxsQEnWcW9TUfQrrSe09GKb+4KjkJbvFITgliu2eVQAz5IyNyKj1NUBc/aWJuOWyoQgjbcQqOD5mQ4TXn+aQHlt9LJ8Fd4gqC5CeGoNsJsk3QvJVWZ7NLaLBIcqzOVJ1/BXcOE3uP0fznF5WRsbbRmLONAmRM+a7X3CGYHtH/H8ZO6hU3GUv7HzdPJhQ94KOtGZwA30neIMqFqBq6M+YTzbzz0QJ3CfZGk6Gd+ZqTXgIdvIzbnzky1J9qu4kgk2DGXLmS8EprXnwEBKWbaLcU/GC7t1wLBWoYXoSlRpE/3SkWjWwBm2gFIdFiff/O1SDPnnGuOtx/JNUJW/Eg20N/ubjMUjSt7DuQ/X1JZod7xKa5JjXwLpOlkq5M5CN9Zt34YErcyEExU22hF4BDy5KUCxyBc9rgOGAtIOIdlVhaL24H8wudiLlYI3oxPjSl9zt9dH+c+3UZ1XSdGFsZYoEIq4xgGz8U8SRzMjDiBFEXv3hsF3A/OUiyADFDpvfhz1lBqUtm2WPjYYTG+tTY6eI7sfuMBKLk35YdA3milaox2n9mEdG8JHc8c+8lZVv/BHVH6wlxlgr0lBJYqWv8O+oM8A+bPahbw5YA0U4MLFX4HwNTNIXioKvEZUu0IdljVDwZrI1V0gNc0XpXc+Lp610sVLLHslb1u1HO7zjKWchg7FT3kqPbNk5HScRNgBXUPUznQK8/4jl61iSu+ec7cRPo1vtLiSpO8TmDIs/n9wIEf0t/mpr92JBYDG14E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(376002)(346002)(396003)(366004)(54906003)(6506007)(38100700002)(86362001)(31696002)(53546011)(66556008)(66946007)(66476007)(8676002)(36756003)(4326008)(41300700001)(37006003)(316002)(6512007)(26005)(6636002)(5660300002)(8936002)(6862004)(83380400001)(6486002)(186003)(2906002)(31686004)(478600001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0tVVXBqRllHRzdKRGs5UXpyS3JSN2pZcldESk1Db3ZSSER5NEt0L1R3emtI?=
 =?utf-8?B?SmlMeEJ0YXBMTUt6QTRpM1FHOXFnNGtabEZVVTJ3cWdqdTJHaFRrQk9kU2xt?=
 =?utf-8?B?cmZRQmRhc2luVHdDalFpRmpBTnE4clROK3VabDMyQ2MwUExRNjZVczJnak1L?=
 =?utf-8?B?TlltVGpoNGpla1RjQkNVcG5JSGlHeExNSWpRT3l6OVdqOVlQekVLMDc3NDN0?=
 =?utf-8?B?WHJMcCtYVmFxWm41L2lMaE1HcVF3OUJRR0RwTlEzaEhuakxBSEg4UnA4a0JG?=
 =?utf-8?B?bDBrRWNWcmJhaWwvZjk3bzNWZmptektpMWN6a1VqR3NJK21qaUgyU21rbzFl?=
 =?utf-8?B?bW5OdmVyMUI4UXJ3VTJhMHFkMk1UcFVOV0hzVDBJdVBpMTZDR29ON3AySVFS?=
 =?utf-8?B?cnVjU0F6T2VjUFhwd0plT1crVmVCVXEwZ1Y0UWNTeXdneFljVVhpM2xhUStP?=
 =?utf-8?B?bUhXVkdSSTVUdnJKeDNnZG0rbHZDdzJtMXZOREFNSkdhY2JZZEp0VDZjU0RR?=
 =?utf-8?B?MzU3d0dXcU9IUTMvUWt3akI3a0c1cUN0aC9iaHVCK0xpQ0lnbHJ2azNEakxh?=
 =?utf-8?B?R1lNT2xCMGdiRjNvWkgweE9GdzN1ckx5VWRiY2Z5ZmJZRnBoTnB3TkV2NUdk?=
 =?utf-8?B?SW9GYjlBTlZ3WEhwMDVKVE1ONVREbXJUMjhuekRJNmk1NDVQYk9reEYzdG9J?=
 =?utf-8?B?S2tqalRLL1BjY3plZkJRVHNtQXB1RjE2NDRMeUVEeEkvUVNIZGpXbldRYkxq?=
 =?utf-8?B?MHhzSlAwVE55OXhyMlhjaW02bFc4NXM2eVFwVW15Q1hQYWRDdllQYmRVNytS?=
 =?utf-8?B?eDRQVFIwTWRuZUFKTVpPeDlJc3JGL0lFRWRDN3RIYWpqdDRQNDk1UFBQMnBs?=
 =?utf-8?B?SXJKTEMrVHdjMnpsZGJkaTlRazAzQXVzdmx1STRVOEF5endZVjREMTJhdytH?=
 =?utf-8?B?RlhXSWFYS3IwTWdsQk1CY29QcGlFd2ZYdzdqTXVFOVo2RlNxL1hORmdENVRz?=
 =?utf-8?B?dEY2RkQ1TGJQM2NWL0VWN3YweW83ZjFhcEtvMytsbFFZdVIyR3RPTzQxbDJl?=
 =?utf-8?B?ZkRsRmVmUlBJbnRsMkhCWGl1MEdKSDl2VTJIaGFzZGNoNkhZOUNCOWEwdS9j?=
 =?utf-8?B?bkZzM0pQMGd3K0ZneW84Y2Y1RHFKL1NHOFY0NUtEN2hvNTZUcnFYc2JpcXMz?=
 =?utf-8?B?Zmp5SFlSOGFiazdkMnB0MnJsZzJ0ZUZ6MWY0eXBkL2NRYm9jWkdOZ3E5SHBz?=
 =?utf-8?B?Sk5PelluUG9VL0lUUEM2RWxhWGRuT0JXanZUZy93aHZJU2xzSmhZNlJ3Z2x5?=
 =?utf-8?B?Q1kvOWtkQ0cxcEJzdTZNRHg4YU54cFNuRHRRaWhBWWpSREVFMXUxYmFjdDJu?=
 =?utf-8?B?dWNwN2NyQ0FpUldaUFVkbjRSZmczVG9jVTlRU0k3dE9pMmJlWUFNSTY5Yk9I?=
 =?utf-8?B?UmhRR3N4VllQV3dDRGwzbmN1TFBneUxMV0owNlYxWFk0U0tmQ044b1ZjUHFa?=
 =?utf-8?B?S0dnRUJGK0V2MzRBczVMWHdCbXdlREhBOTM0RVJEYkJVZlBsSWIzWXA2bEZY?=
 =?utf-8?B?K0wzT2NmYm53MXFEL213SXBWc3ZGMW8zWmxBcko2ZTVCV1dERnNqN1U2TmtV?=
 =?utf-8?B?K2NHbzJBeDRGcWRqRVpkN25ZYnRHRjJhaFBIVE0yV3JZNnlhSGdSTjBkN3I0?=
 =?utf-8?B?OEppN3M0WVFEZ1BDa0xnK3pKTW0wclRHZUJuT044cHBrd0UvYmptakdlTVlL?=
 =?utf-8?B?Z0JFRTZzWDhLL25TYkNTUDN2WnBOcmh1L1RiWlR3WmVtdXFwUmNBMTMvY0F6?=
 =?utf-8?B?OXBsbTZiMnJwRWlpSnpsdEZMUmVRV3VlanJTd2JmZnNDTUtRTDFjRUE0K0lI?=
 =?utf-8?B?dFJ1am95OHd0N1B5TzhVWUQwcUJEbU82MVBnNDkzYlRlQVFHRHRmM3J6a25a?=
 =?utf-8?B?TGM0K1JBbmthK2tzbmRtS0ZzTEVFV1JQUDdjYTNzb1R3LzZtWDYwYXhNQ1gy?=
 =?utf-8?B?UXpCVXRkMmwyNTZrZnYvNzlrTjROSzRpMXd6TGZ1TGVYcVFYR3FsWmtPM3Q3?=
 =?utf-8?B?d2xPKzY2WnlpSFVVai9BZHBkdklYSEpXMUNvN1BmSGdOVG1TTVQ1VVlVdEtG?=
 =?utf-8?Q?gTaT8fju26GCldIoDXNZLJQ58?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bad9774-940f-40f5-b5ec-08da866cdcf0
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 07:38:54.8949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhgaF4GDiDz+ocX2zMfE5eAmVYzm84xYRF2G2GXErcTwkPRzLveCgzinKAC9k8y0INx+jZiV3SstSxXfRHtp2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8570
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.08.2022 16:26, Juergen Gross wrote:
> The error exit of privcmd_ioctl_dm_op() is calling unlock_pages()
> potentially with pages being NULL, leading to a NULL dereference.
> 
> Fix that by calling unlock_pages only if lock_pages() was at least
> partially successful.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: ab520be8cd5d ("xen/privcmd: Add IOCTL_PRIVCMD_DM_OP")
> Reported-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>
albeit I wonder whether you did consider the variant actually
reducing code size (and avoiding the need for yet another label),
...

> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
> @@ -679,7 +679,7 @@ static long privcmd_ioctl_dm_op(struct file *file, void __user *udata)
>  	rc = lock_pages(kbufs, kdata.num, pages, nr_pages, &pinned);
>  	if (rc < 0) {
>  		nr_pages = pinned;

... dropping this line and ...

> -		goto out;
> +		goto unlock;
>  	}
>  
>  	for (i = 0; i < kdata.num; i++) {
> @@ -691,8 +691,9 @@ static long privcmd_ioctl_dm_op(struct file *file, void __user *udata)
>  	rc = HYPERVISOR_dm_op(kdata.dom, kdata.num, xbufs);
>  	xen_preemptible_hcall_end();
>  
> -out:
> + unlock:
>  	unlock_pages(pages, nr_pages);

... passing "pinned" here.

Jan

> + out:
>  	kfree(xbufs);
>  	kfree(pages);
>  	kfree(kbufs);

