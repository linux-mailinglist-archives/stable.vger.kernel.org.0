Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24973450201
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 11:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhKOKLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 05:11:21 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:39153 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230432AbhKOKLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 05:11:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1636970904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b5jtFWyJbg3cqw/Q+xikBVTcUFSXwfvaXTrrJN9N3TM=;
        b=PmKZnBXMAlesj/6RBzgxZDme4adwTo+c3Lzr8jl5Np09m3cYMV8Wm9hMQUKkP2YUERm6kU
        glz1IDOrX2cyKgWuDFbQ+oFPot0YMhJ5qBRYwAZ9szeYNMd0NZKBO5M5jgylWwe0ISZPO5
        WWv7uYL9WDyGY3BMcsqD+Z2SXZEYq30=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-lotXKW-6Nhes8r2ODRippA-1;
 Mon, 15 Nov 2021 11:08:23 +0100
X-MC-Unique: lotXKW-6Nhes8r2ODRippA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S90I3Nh5Ftz5MFKTgiDKR/nkG3VaHNlE8j+4HMyuyqcvQAVdpsBhIuySjuPPykei9LKNoO2Cq6h7d926v38R/ir+QhZbqzKIoLVpcLQT77s2S7I/4wIqyRDM0Vu/LjCqLiQMsMVWX5FZyGwI2PVrI/GFeZau4VGuO9sYiON/LTjGBGbOjdGDeCW9y/3+9g2CEYRguLVBk863XcPZpxqPldEx2nFTIMgz4tP698L3XsTKynyUx20b+YR5AXWV/P6ljTcGCHssSYMyc/qxqFXlukApyKD9pma7W8SbBA/zplIKHL2O4LW7iMqwYzfyQ6E6O0kpPhVqGCBH2iteemvXvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5jtFWyJbg3cqw/Q+xikBVTcUFSXwfvaXTrrJN9N3TM=;
 b=Fcy+4RBBoUJeo5SWP8SFLOgy6fUWQ1WNQxtnWf0gd0DpAliFgPeqfYh+vSf8F/l/cN1LhVXJjdiDHwxtyKCI9O18eMjFEZ8ALQb7WyzdTC6xo76ClMKtYMwP+wS5I+Yei5DWkbXDkH376ZK8cXAEaObIn90V1d3wDBNL2aRHSV2R8U1PmbwPx2Yf2egboTyqVgPy0GlF7Xoy/jgQnrYvWDPRA2btLfNj+lLBtqH195TfHfm5WSRkMNW7zOms94fw1hfvBEPHYygJ4N3yhE1DTi8N5BZbNwiw79eJ7korz5FJZWrb0osuU0LkuxlXhyq9USfZ5fCaLSlzVvPGbgLNsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5587.eurprd04.prod.outlook.com (2603:10a6:208:125::12)
 by AM0PR04MB4145.eurprd04.prod.outlook.com (2603:10a6:208:57::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.22; Mon, 15 Nov
 2021 10:08:22 +0000
Received: from AM0PR04MB5587.eurprd04.prod.outlook.com
 ([fe80::387b:e76e:f981:f670]) by AM0PR04MB5587.eurprd04.prod.outlook.com
 ([fe80::387b:e76e:f981:f670%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 10:08:22 +0000
Message-ID: <6be8285f-6cbe-c115-a826-585664c91022@suse.com>
Date:   Mon, 15 Nov 2021 11:08:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] xen: don't continue xenstore initialization in case of
 errors
Content-Language: en-US
To:     Stefano Stabellini <sstabellini@kernel.org>
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Stable@vger.kernel.org, jgross@suse.com
References: <20211112214709.1763928-1-sstabellini@kernel.org>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20211112214709.1763928-1-sstabellini@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P194CA0070.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::47) To AM0PR04MB5587.eurprd04.prod.outlook.com
 (2603:10a6:208:125::12)
MIME-Version: 1.0
Received: from [10.156.60.236] (37.24.206.209) by AM6P194CA0070.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:84::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Mon, 15 Nov 2021 10:08:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5d1593c-539b-418f-915f-08d9a81fdae0
X-MS-TrafficTypeDiagnostic: AM0PR04MB4145:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM0PR04MB41453259DAE97BE7F0AEF70AB3989@AM0PR04MB4145.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VVnIVMHLYyHCtUxEA1IPOJkRjEdSEVro3GZvQRmRGesawH/Rlm69atrObnp4pddAK8y+nkKp3+uWR6oZbFOLMReQgB/oRluebr+U6Q/aBfT6WHh8V2LFypKr/pKUPAMgnH8YINF77K0YFkb/9iMV0qqIkpqtCsIJSNhZRv66ATj3vP8KMjqAqrK86Y++FdGoNAu7edrYkawmp8qFQ2IriTWHPI6B6K5QdCc5QQ2TEDNNXNTUdmJk1Xfi2PJ1D98GKMksb0ap7dIb/4DD3qHjw92HKY/JeVnIZnhh0XK62YwCE3H061160/xZxD5Ut0qmXh1+fvT/rewyXFunY6OqZdWSqz9gWseSg9PDUnDLv4fzZBzOHvccean063i7enqW9JqOnL5L5CGPp4tes9A6soPvo4Yyk7/LqgGM4AS2garUSCBi7Pru3qXuorX2OgtIOGbUbuXZB/2Z5OepHAHIH3JcuS/3cYnGJKwC4mi+0rQi3inU/g+qlptC6YwBQJM1Ka0S6QK3A44ZK3m4DHEjFd2CAR5/MH5r0ZRfGOk9Q7v2WFAeh0RirheAL0yihrmmtW2A7lPDfjHkraqRvfG0w0M1FGuk9ZKHqtUdt7lwzTiVHER9QjNkGGcgIBMcTTPyEuipS22hNyh+Y8DhmY9Ny7RR9pWJG4Rxa1axsuNvn4EIQkXNhslgoCgdDhrNaxdILNRRqF9eV/cTrJ0HkTS7u5luisrFk29/xRTvkK3Z0VY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5587.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(16576012)(107886003)(53546011)(66946007)(5660300002)(86362001)(8936002)(66476007)(66556008)(31686004)(508600001)(8676002)(6486002)(38100700002)(956004)(2616005)(4744005)(186003)(36756003)(26005)(31696002)(2906002)(4326008)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3VDeDNEYVpkbGhJRUZnMzVja1Z0em9JKzBNbFV3d0NnZVN0aklJUElvS2li?=
 =?utf-8?B?b3BaZWFETWk3U0NWcHViV3QzSXVDWDVNZ0FCVzNzdzNuNll0QUtDQS9jSUw5?=
 =?utf-8?B?WGloQXFieWdEaG9uU3NRajJXbFV2UnBTaFBvZDlNV2JLc1VxUTJ6ZzhDdkRv?=
 =?utf-8?B?WlZsUHpZelBsT3J3Z0FkaGZheC9kSHNySGpIN2F6ZythS20xWWZxa1F2V0hR?=
 =?utf-8?B?Ulc0eVg3UERTV1ZjWHVlbnpMa3dqYnFDeXJjY1FPcXhSME1zbHZxbmVOdTNw?=
 =?utf-8?B?YStSbW53NGt4bUl2c2UyU3VUZjNBaWljRE5JQkFocHFVcGl6QVoyUFVqSlRx?=
 =?utf-8?B?bG1JN0hsWEF2SnVNaG5DbzdsYWlDZ280WC9hdDBOUEZ1Sk8vU0Y5bEhucTRG?=
 =?utf-8?B?RUF2dG4zM0tjWUFsbTFIcmt5TENOOFBHdWtORndLYnM0V0F5dW5ZSkVPR015?=
 =?utf-8?B?ZWlhbU5yMC9IeDVxQ2FDWXVwOU51d3l1Vmk5S1N0Zm41cDRDcTd4cHZEMzZ0?=
 =?utf-8?B?bmpjRnZmU2Y2NzZsdzdxa0R6SEc1SFhlMFdlcWR5SXpwUmdsWHdBbDFxRThl?=
 =?utf-8?B?R3R6NDVuNzlsSktsa2JyU21pM3p6ZE1SUjZ4SUxoc1NSOHpza3RUcXNTREFL?=
 =?utf-8?B?Q1BtZnZWRVBvL3E5MjNqa2FCWnN6bzZJcWZ3S21YdTRQVm1HcENubXB4WEU3?=
 =?utf-8?B?WlhOVmxLakFZUmE5UmlVVHprcGNoUi9UUndiekdQR2tyOUl1OFRSM1ZXSVdV?=
 =?utf-8?B?ZE1rVVczSTViTGJ3Z3dRRCt3MnMrU3pydkZtTm1QQitjbDVzM2pzd2pnVjY4?=
 =?utf-8?B?SDUraExRaUVWcTV5M0g2NmhTUUxWMVcvdFVLbDV3T3VNcm9nM1hMTzkvWkRZ?=
 =?utf-8?B?RDNyWjNsNG5EeDhGd1VVNlA5aEQzYXkwL0RLdFMrZmczMTgxTUIwSkVnbUtD?=
 =?utf-8?B?ZGdiU3p2WXFvRTZGNUh4NEhzNzBKRDYzRFJ1VldkdmYwbC8xV3UrdkJ2WHha?=
 =?utf-8?B?U2dJYWRVbEI0Yk9pUU8ybzh3WExhdkprZVBWbTlqbE54UHVja010dkkveUJP?=
 =?utf-8?B?L0ltMnhwY0ZHNERLYnFtSjJSc2FJUEhwSW9QOFhWSnArZUhoOStaV204Nys4?=
 =?utf-8?B?Q2NNdElPaGRuWnNheWtySFZLQlFnckNBTFhldHQ5V2hxNU1nZnNwR0Q0UGFB?=
 =?utf-8?B?RHJZZm9PTS9XWGNsNWhCRGlaTGpEN1BFMlVlUEVVOXFud0FWdTE2TlJ3TGtS?=
 =?utf-8?B?Mm1SK3BYcFNEdVRndFczamNOM0RJdGdOOTRoM3IzU00wZWh4Ti9Ndm05b0lH?=
 =?utf-8?B?R2tZTkNEVi83TUU5Q1NDMDIyWHJYRTg1UE1ZdUtUVFFFOUhXSFg3Y0lHL3JD?=
 =?utf-8?B?Ti9Zek1CeEVjZGRTQTlzTVQyeWdhV3M4QlVuVjV1Ni91UmhPdHpBUmM2bTBW?=
 =?utf-8?B?N0VqRHRoZHV4M25mWmpFTFZDM3M1anNaYUsrMFlLbG9zMEdjSXZLOTk4R1dj?=
 =?utf-8?B?M2N4YmdnM1JMdW83aVZYd1JGdlRPS05JWk55L2F6T3JsVDRiajlKMUI1Vnhp?=
 =?utf-8?B?KzdZREZoMlZXU2hLQlozdXdRVGx2amh3S0hrUGd3MFAzRnF4WTZUUWlLZFlN?=
 =?utf-8?B?V3dBekF0WlBDaHBFbXk2NnQ0dVV5QmJyZWp3SEhOOUJkUVhhU3R1OG12dzRN?=
 =?utf-8?B?aXEzZjFyaVJTTnNqdzl3QnE5RlUwZUorOE40cnpvdFBKZ3lvbjdsVUFUSXFD?=
 =?utf-8?B?UlVYa3FIVFJDTFVyTktzVUdMUzg3ZkkwWHFVZVNKbGNOL0xLbGZvSDlsSW5w?=
 =?utf-8?B?WHZPRzBHV0M4VEFWV1FITTVNR0Q2SHJSV09wbXFmZ2h1MVRrVXNBQ1B0Wnl5?=
 =?utf-8?B?dFBDSmRvRnNqUHcvc2Z1b0RQeVhVR044TEU2TExwVlk1a0pLSjlHMWxTZllq?=
 =?utf-8?B?ZGlVa2ZKNnh3RHh6M0JtajRLalkrUHlVOVdSMnA3OG9OWWcwd2dwT2RIZTNB?=
 =?utf-8?B?RGtVdWVRcy8xU1NvY1ZJVXdwUlc0UTJ2MUxRbGZFbStUTElHN1dVZERNeVov?=
 =?utf-8?B?NWZiS1VEOEE2Qlg0RmlUNFY3alNlRnZUVTIwdSsvQlIwU1QvM1JQaXBOT3lv?=
 =?utf-8?B?UXR5bGt3RGZFNktpakNzK2tzZVE2ekFLWkdnTE1oWVBxMmZxMHk5VHBpWU5n?=
 =?utf-8?Q?f+rwsoCmNoDxyJk0f/p1x/g=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d1593c-539b-418f-915f-08d9a81fdae0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5587.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 10:08:22.0607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yV5vA0DTj27W3huiJYd7topd851w+8vJMRHY6t4cusjuhtKFdM25sXzvk1LXMeIFLmKZp1xxUUeEDWCbZe2ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4145
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.11.2021 22:47, Stefano Stabellini wrote:
> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -983,8 +983,10 @@ static int __init xenbus_init(void)
>  	 */
>  	proc_create_mount_point("xen");
>  #endif
> +	return err;

Personally I think such cases would better be "return 0". With
that done here, err's initializer could (imo should) then also
be dropped.

Jan

>  out_error:
> +	xen_store_domain_type = XS_UNKNOWN;
>  	return err;
>  }
>  
> 

