Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDF46ABD10
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjCFKkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCFKki (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:40:38 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF9E20565;
        Mon,  6 Mar 2023 02:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678099237; x=1709635237;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RbMfeb3EhcnLDppLc7Y6vnj+Rl1W70LaRR1v8cWEhJ8=;
  b=ZE8lJE6OzMIYh0NE4FFe85ZNdyeJm4PXJZEYvK8P/U0dKoLPDbbNiq5q
   k4FPIRy0tpwoLGgYmF00ogDsaSSAqvcMa9KxxNxkaO40wxmT+CEP6Un7+
   Mb80d65vFt9BnJwU6/rUPPwyUduOYOtIVWlzJ6Fi5dnJ2/tI7yQD1a+4O
   LfCoLoIxSBuGscFOqwSYe+2l+/HXiz2isLTtEDo17LtIaY/VsWGAhAYgB
   n2KPEjB4zUxdGNBbyJ5v4PEYmaX5P3eNahVJa1J3XvZaxuD1XOEOtIJkI
   9cG/UjOV/ots4CQtzNkOiOpH0BCwi9rMYUODUr0cABXm9x2vi+/3FTmk1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="319349377"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="319349377"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 02:40:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="653563130"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="653563130"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 06 Mar 2023 02:40:28 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 02:40:22 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 02:40:22 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 02:40:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MujdLfUS24rehRs3gloReEC8LGJQ0MiyPQ5tBKLxRxjSjnAer6aEAKLompH8vTG3PY2F2ilB1SmJcQuYlVbEnJZtefODg/Rjvc/LOSJGjL8eOBnFABxB0gnIjoJNfd15Tb0SLKDAzIjIwz5qdIEYjsReKb9o5uTReR0TDaeJGTLRU2zUgULVVTLBMEK9yC5tZ7FDy7c6SF+DHgwvJ3e8NnoYh+mua7dqmZKx5imwi1tX8HULcm4DbET6bFxz+qupzc56UtzLLiVqGisoqtVa77MW97E9qUBurbTEiAzJyYfggjRb7aLLrmdZle1l+T5WuyUm6oNlOVnMir0orAkH1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oR019CyBosXX0LOny2zcPgbXq3i+WjDz/aPNDmWem+o=;
 b=hb/aFKCQIbuIKEBgGgNty+i+FTpTBDDWISEDOkxiSOWdeXZVnBBkaDjyGXo+N6S3FFPT0ITSxzpKir6pITFnaCX2zx+04Qi9KqFlVu79UTq2jo8/seOdr0T8SKI7HThQp67QSGWZR7nt5LulUzhfnRBH2XVJbUbR9SnK+ZJ5XYSd9/rrmP0fouH7l2v6oVhQYrwgQRreH7gJ2eRYjZBm3yodHRCG8R36U3vrq50n0WK0Xi8Nl9WYkyAvi8zGpEWy0qWerdOJ4M4VJBht3hi81+pPoPdA1uks9f+2HT+HyTmBnargrjFl6ima2VFldEL0YDZ6ka5t3RTr62iQ3Dzp3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH8PR11MB8108.namprd11.prod.outlook.com (2603:10b6:510:257::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 10:40:21 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 10:40:21 +0000
Message-ID: <d0fe6542-b786-09b6-0657-8c47fb19e0fb@intel.com>
Date:   Mon, 6 Mar 2023 11:39:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] kheaders: Use array declaration instead of char
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>
CC:     Joel Fernandes <joel@joelfernandes.org>,
        Jakub Kicinski <kuba@kernel.org>, <stable@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>
References: <20230302224946.never.243-kees@kernel.org>
 <89e3ecb6-0e1a-3d86-cb05-cbb034c68dc4@intel.com>
 <64025a3a.170a0220.dba96.3fcf@mx.google.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <64025a3a.170a0220.dba96.3fcf@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH8PR11MB8108:EE_
X-MS-Office365-Filtering-Correlation-Id: 1564dd4f-d746-4c36-5497-08db1e2f2f27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXIB4JcQotJ1qFRYiEszaVxDGsLD/ihqdgeh+PsierAESRXO64B4rPyfE5OuOwvoT0T44O6UTbUhFb+mm3dYaCqnch7zkvPSSBHdozdwoZPmpxyy3lI7f+l0UFO6/YTYg5ZMtcG0H1gxd6J4kmknl1kllz0D7Y7d1kImKfpYA+xLiF3/K1ph+AiphmkfDsRUwp8JmAKRkdj/flSFITzoZApVnnEhDXNcyGDz0Mh+x4rtI8iEpYLjoiVZmciMhRhqXTQTcpAqB+/zY62NIkslu3z219TaP7Oifl87cIRbFFWQSe9ix0CfsJUF0YN36m91PvlOvqcSoAU/M0RVnRvfFXH1x84/KWgtiUw9Wm/YMhloZXwCDogSYMrVFdBz3+/je9eVCi/xX8/HhMMEiAyKaB//ZIeo1JntVYttBrnpUHSfTKcG9XIS/iNIDpS8Q6gDl7QEhfqWaTw6CJcFcyzEJRszVLyOzcdMtTvMgJT7lzUHbu+xMfND6+AYa4B4tpZDBRCAHYxBvEVJC1udLVnr5HmainuZpWqg8/6zKPG6WF2xpsKJDFiB7DwWrREq44eyvsWwD5zyJsBSSFWjdsnySo9xdQGlDZeERdvtNC3n4/XAP5jAcP05wVonkOtRYgn5Od6rY4/EdG4Nz5eR4yxCIeOylZxbR7NSwBoiMAqSvwUZ2tv1m8wUQue+plguvl3/8ISUlzfnp4caQzWUU4S8fIkhNm3Wy7iU71bc9EllEIQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199018)(31686004)(5660300002)(8936002)(66946007)(66556008)(66476007)(2906002)(6916009)(8676002)(4326008)(54906003)(316002)(478600001)(36756003)(6666004)(6512007)(6506007)(6486002)(26005)(2616005)(41300700001)(31696002)(86362001)(82960400001)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTdJYnJnWWhaYjR0SkZaUGNVbktDQkppc2t1K2dxS0JKSHhzajZyU0pWOFRt?=
 =?utf-8?B?aDFTMENSSzdPcDFweUNWMnIrc1ZYaDJGalpIUXBVaFBrQWM5QWd4SHFYeUw4?=
 =?utf-8?B?bWNqeGhqU1R5MlUySUNVWnNQN1pHYzJDbGhnTkhEWS9COVRxL3YzZmw0OE5x?=
 =?utf-8?B?ZU5QTnYvTWxFakhxQ0ZhVjV5b3pIdWsxb1F2VlNEWC9RcXdyaGZ0VFJac3Bx?=
 =?utf-8?B?ZjFmb3MxajNlZUxPc1p2aFpWdGpkNHRMa3N2VnBLbk5mYXBPdTNJVGMvdHZB?=
 =?utf-8?B?QkZaRXRuNVBDeHo1WGhwVDB2b0FYcFR1eGpFSHhaRzJvY3JyZ1RENlhBZXdH?=
 =?utf-8?B?ZkZic3R3MVRRUFZNMVo3L3dLaTBEOWdObS84NHlDYWt1ZmdyMEREVEpycTgw?=
 =?utf-8?B?TGJiYW03aW11bHJxaWtYWWlYREFaVWJ2NUNtVWVsWGgwMDJXNTQ5TjVMUGdl?=
 =?utf-8?B?UDBQNm5VcVpJRm5SRUhxc0ladFczVlRpR210LzVTZWZsOEVseE55VkN4eHF6?=
 =?utf-8?B?NVBTdG5hZHpaNU9PK1RTdlRNampLWldLdGZGKzYwamRETXo4RjNUSldkc0lW?=
 =?utf-8?B?ekRtaktxeVF1b2JyWDh6aCtLM015T0hEZzk4U3F1T0gzSEZBOGtWODMyb0Fa?=
 =?utf-8?B?UEV1MWRIRUZrVytKV3d3czZlMURVZFRvRzJtbDhnWlM0aGpwb09uanN6Ujhj?=
 =?utf-8?B?ZFFza0F1Y2txcXRKaUdrbHl6V1Bsa3dRbEp5bUVvdFRMMjlZL0RXWTBaWmE0?=
 =?utf-8?B?UDV5bFd4cEx4akNxQ2tobHJEZnNpSkx1dWVKcFNJUmd3c3B4WkRBZmtMSFVz?=
 =?utf-8?B?RnlkQlVOc2t4YS8xU3hHZFVmZE1iaUxSL2Q0REFac202VnZHVnBFcmNWeEFv?=
 =?utf-8?B?SWFrTHhmbHZBVDNOQTUrMWhwT2VlQ1RjRHFJTDJSZTNnMlpTaDNBRzBSVTBV?=
 =?utf-8?B?NmZBN3llZ1RzVEZ0TitUeVFITUdKTVJBbDVzUG4yZ29EQ29UM3lNTVRWcXF5?=
 =?utf-8?B?cWEzZ1lRczc5aCtmQ1VRRFJFL3prcmpnOUE0dWxjME9FOGhmMnUwU2xiRGtu?=
 =?utf-8?B?eEY4eW13ZWNOTG5VMVZmRWNqTy9xN2RQVE5qTThoR1ZGSW9vZmlqVVhTV0d3?=
 =?utf-8?B?d2NsNlFicW5zd0xaOHNYbDkxMHRCckluSi9jeWQ3MFRXbkVDYjdVcktLOGE3?=
 =?utf-8?B?bW5HTGJNM1p1TjhSelFzY0ZpOUljMzlaVC9wMjQ5ZGlDMGJHUWxrMHVRa3RX?=
 =?utf-8?B?amo0RDBsckxDbG5uMTJ0cGRsSzFnUVBMaVNYZXlKcndqZWhsT2llRVVaNFp4?=
 =?utf-8?B?R3JLamVGKy9ZS3FKS1pjaFRVTS9oZ0ZIUkhhZHYwb2xBcjh1S2dkOGErRFBr?=
 =?utf-8?B?d0NDNi81d0lCWGF6ak5UNC9WUEJKSjlqWkRyTDJVZE9GQmYrbUdCdWNISG5i?=
 =?utf-8?B?cU9KbXV1cDdySEh5dTlTOUFOTldVUlRzUFpwSmV1dFlRTVpQa1JsUkJNbkhS?=
 =?utf-8?B?TnRSUzZmNzN1ckFVeFNHTWZSQVlQWTNWNlJIeUwvQWQwWUd4MGVkTW1veko0?=
 =?utf-8?B?RlU4bytDaUNpaW4xTS9iV0IxL1JDQ3V6Mzd0Q1FkVjdySHdMV1c1UTdDZmc4?=
 =?utf-8?B?RXRBdU5wc3JJNmxqOHNOc1BMaFJvejNKdHdyU04zYTNZSW1DakhLa0JrUnly?=
 =?utf-8?B?TU1KaTFrMkozb1FPbFM2aUJ2NGN6Z0doM1hNcDdwLzFsa2lRbXl2VW55ekl5?=
 =?utf-8?B?amNuUWtWRkh4S2RxK0xWWGViTkZLRkpWM1Rtd0o3Vk1xSGNWN0FSNmNWRG5a?=
 =?utf-8?B?TnFWL29DSG1xWktqOG9zZHJSRDYwYUpDMTZoYkhrdHNMejUyNjlqbEtmRDVT?=
 =?utf-8?B?OFpMcXNHbFlvVWZnUFVBNVE4ZzVsMUI5Mjg0ZzJJTCs1SmU2UmpKL2lHZHIx?=
 =?utf-8?B?RTBPR05EODUvSGNiQ0d6d0U3UWc0d2N6eFdMcEljWjM0NEplN21kN1N5RkpD?=
 =?utf-8?B?cnN5WWdwQUtnU2NEbENrMlBOZGEyYXBOV0xOWjVvajN4VmZFTE1rbWNPL2R0?=
 =?utf-8?B?NWcxY0ZCZGxvS3locXdmbExycUx0N2MxV0sxTzRPeTZRaDVTRTZSOU1NY1RI?=
 =?utf-8?B?V0ZVRzFuQmRucnNuUlhJL3J5amQ2TlppbDBMcy83a013aWdqcmFzb0lXNERh?=
 =?utf-8?Q?eKkNgLtWdfU4ns1Fo3coYP4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1564dd4f-d746-4c36-5497-08db1e2f2f27
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 10:40:20.8491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lH85POuazNHIThF4gGIORcFpQGPBueE+tZ/1mIRScpz93C3tO7V30JaLr4KmKAMoXzNNeR6qCjOcdzeK+EhRVDaZYBRcEobV6V7+cZDYw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8108
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Fri, 3 Mar 2023 12:36:09 -0800

> On Fri, Mar 03, 2023 at 04:19:51PM +0100, Alexander Lobakin wrote:
>> From: Kees Cook <keescook@chromium.org>
>> Date: Thu,  2 Mar 2023 14:49:50 -0800
>>
>>> Under CONFIG_FORTIFY_SOURCE, memcpy() will check the size of destination
>>> and source buffers. Defining kernel_headers_data as "char" would trip
>>> this check. Since these addresses are treated as byte arrays, define
>>> them as arrays (as done everywhere else).
>>
>> Yet another array-as-one-char, I wonder how many are still here...
> 
> Yeah, good point. They do tend to stand out; we could find them:
> 
> $ git grep 'extern char [^\*\[\( ]*;'
> arch/alpha/boot/bootp.c:extern char _end;
> arch/alpha/boot/bootpz.c:extern char _end;
> arch/alpha/boot/main.c: extern char _end;
> arch/arm/mach-rockchip/core.h:extern char rockchip_secondary_trampoline;
> arch/arm/mach-rockchip/core.h:extern char rockchip_secondary_trampoline_end;
> arch/arm/mach-zynq/common.h:extern char zynq_secondary_trampoline;
> arch/arm/mach-zynq/common.h:extern char zynq_secondary_trampoline_jump;
> arch/arm/mach-zynq/common.h:extern char zynq_secondary_trampoline_end;
> arch/hexagon/include/uapi/asm/setup.h:extern char external_cmdline_buffer;
> arch/ia64/include/asm/smp.h:extern char no_int_routing;
> arch/ia64/kernel/process.c:     extern char ia64_ret_from_clone;
> arch/mips/dec/prom/memory.c:    extern char genexcept_early;
> arch/mips/kernel/traps.c:       extern char except_vec3_generic;
> arch/mips/kernel/traps.c:       extern char except_vec4;
> arch/mips/kernel/traps.c:       extern char except_vec3_r4000;
> arch/mips/mm/c-octeon.c:        extern char except_vec2_octeon;
> arch/parisc/boot/compressed/misc.c:extern char output_len;
> arch/parisc/boot/compressed/misc.c:extern char _startcode_end;
> arch/powerpc/include/asm/smp.h:extern char __secondary_hold;
> arch/s390/include/asm/kvm_host.h:extern char sie_exit;
> arch/sh/boards/mach-ap325rxa/setup.c:extern char ap325rxa_sdram_enter_start;
> arch/sh/boards/mach-ap325rxa/setup.c:extern char ap325rxa_sdram_enter_end;
> arch/sh/boards/mach-ap325rxa/setup.c:extern char ap325rxa_sdram_leave_start;
> arch/sh/boards/mach-ap325rxa/setup.c:extern char ap325rxa_sdram_leave_end;
> arch/sh/boards/mach-ecovec24/setup.c:extern char ecovec24_sdram_enter_start;
> arch/sh/boards/mach-ecovec24/setup.c:extern char ecovec24_sdram_enter_end;
> arch/sh/boards/mach-ecovec24/setup.c:extern char ecovec24_sdram_leave_start;
> arch/sh/boards/mach-ecovec24/setup.c:extern char ecovec24_sdram_leave_end;
> arch/sh/boards/mach-kfr2r09/setup.c:extern char kfr2r09_sdram_enter_start;
> arch/sh/boards/mach-kfr2r09/setup.c:extern char kfr2r09_sdram_enter_end;
> arch/sh/boards/mach-kfr2r09/setup.c:extern char kfr2r09_sdram_leave_start;
> arch/sh/boards/mach-kfr2r09/setup.c:extern char kfr2r09_sdram_leave_end;
> arch/sh/boards/mach-migor/setup.c:extern char migor_sdram_enter_start;
> arch/sh/boards/mach-migor/setup.c:extern char migor_sdram_enter_end;
> arch/sh/boards/mach-migor/setup.c:extern char migor_sdram_leave_start;
> arch/sh/boards/mach-migor/setup.c:extern char migor_sdram_leave_end;
> arch/sh/boards/mach-se/7724/setup.c:extern char ms7724se_sdram_enter_start;
> arch/sh/boards/mach-se/7724/setup.c:extern char ms7724se_sdram_enter_end;
> arch/sh/boards/mach-se/7724/setup.c:extern char ms7724se_sdram_leave_start;
> arch/sh/boards/mach-se/7724/setup.c:extern char ms7724se_sdram_leave_end;
> arch/sh/kernel/cpu/shmobile/pm.c:extern char sh_mobile_sleep_enter_start;
> arch/sh/kernel/cpu/shmobile/pm.c:extern char sh_mobile_sleep_enter_end;
> arch/sh/kernel/cpu/shmobile/pm.c:extern char sh_mobile_sleep_resume_start;
> arch/sh/kernel/cpu/shmobile/pm.c:extern char sh_mobile_sleep_resume_end;
> arch/x86/entry/vsyscall/vsyscall_64.c:  extern char __vsyscall_page;
> arch/x86/include/asm/vvar.h:extern char __vvar_page;
> kernel/configs.c:extern char kernel_config_data;
> kernel/configs.c:extern char kernel_config_data_end;
> net/bpfilter/bpfilter_kern.c:extern char bpfilter_umh_start;
> net/bpfilter/bpfilter_kern.c:extern char bpfilter_umh_end;
> samples/bpf/task_fd_query_user.c:       extern char __executable_start;
> tools/testing/selftests/kvm/lib/aarch64/processor.c:    extern char vectors;
> tools/testing/selftests/x86/test_syscall_vdso.c:extern char int80;
> 
> Of those, it looks like only a handful might trip FORTIFY:
> 
> $ for i in $(git grep 'extern char [^\*\[\( ]*;' | grep -v boot/ | awk -F' ' '{print $NF}' | cut -d';' -f1); do git grep -E '(strcpy|memcpy|memset).*'"$i",; done
> arch/arm/mach-rockchip/platsmp.c:       memcpy_toio(sram_base_addr, &rockchip_secondary_trampoline, trampoline_sz);
> arch/arm/mach-zynq/platsmp.c:                   memcpy_toio(zero, &zynq_secondary_trampoline,
> arch/mips/dec/prom/memory.c:    memcpy((void *)(CKSEG0 + 0x80), &genexcept_early, 0x80);
> arch/sh/kernel/cpu/shmobile/pm.c:       memcpy(vp, &sh_mobile_sleep_enter_start, n);
> arch/sh/kernel/cpu/shmobile/pm.c:       memcpy(vp, &sh_mobile_sleep_resume_start, n);
> arch/arm64/mm/trans_pgd.c:      memcpy(hyp_stub, &trans_pgd_stub_vectors, ARM64_VECTOR_TABLE_LEN);
> 
> 
This list looks much better than the first one :D

I remember I caught a couple fortify bugs due to such array declaration
on MIPS only when testing with `KCFLAGS=-O3`. The thing was that a
pointer to such array-not-array was passed as a function argument and
that function wasn't inlined on -O2. So I sometimes use this optlevel
for sanity-checking the code :P

Thanks,
Olek
