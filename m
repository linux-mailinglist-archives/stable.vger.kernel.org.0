Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FA96A9A83
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 16:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjCCPVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 10:21:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCCPVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 10:21:11 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039F528206;
        Fri,  3 Mar 2023 07:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677856870; x=1709392870;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HJeQbsyfQzmLyNqlG9cYmi3JUJH6+lp5q3VWHrRXnNc=;
  b=PcHqbc2YlVfwm88Il0vcF7ZBGJVJIH6xbRwm/v+xMzUzF54iboaXNZ5l
   VIu80g7Pp90UHLzkvKyZYSadG10aUA7/Dw1j9peuxIpAgjtNa+zWqaqP2
   YUhRrHILb3kOfVLiQdNC+BfiBYaz4sSDZmgeub0OR6qK6OzCym69d0KxE
   q82QbBDcLkDnTQYDwChmHgfq2kwh7MDzTS8uIo1jdhUmm10W/B0x+zB6R
   nixCngqEmspABCTIvYriKl5esgKYXPjCXojd+AF62qgZ214Pzi+rSiIhN
   p3++zIHMqO2Fc5XaghbIcPmTYK5Uhw192425c3d3TMDywKhcsUT16x588
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="318887787"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="318887787"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 07:20:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="675406119"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="675406119"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 03 Mar 2023 07:20:52 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 07:20:52 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 07:20:52 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 07:20:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nk6oCjCoz7/5gp8ePM680kieMvVMRP4hgpNgZaATbkNhd2YVnJS+3hViHdA+O+d4JCQfPHE4HJB6TDnvvUmi8qL2ke/AyFvQyhcfHOiQPlzNmA2aoMrRSpMX0Pd2lC6rQneOUzQDNIKLJYbDfAQob+ngihZR5Q/rWilVEZiwuTAyPjlzrpciV6nFeYJxmyBXbnV28pQf1IwQJJDLgATqTxZqVitz3YRqdhoytMzYbx1BB3SN/9A+8afovrNVUzNy3unZTsUhmbPVefAn5SwWZ6I31yk3foMtrX+NlYmV/WTZ/Djr+RRmV8fBk/MuiPf1UWlKn4UjqQyU5rWMqbh3iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDO1hsptfxJm0LcgzUt+pKKQwQ1Yuny81oxm2AKrZlg=;
 b=TctrVPMY9kLfoczgvxUACPQcUljhaiatn5G6XQRIwWehw3Xf5EjyoYU+A4lOE91iyft7cRQehkFrqo/WJ4iwZxcqC6ZFc/NUhr/finmIRLExmqM4sYPEsfmDLDK4ikOCJs5L1e+2A9eDKoig/9NSbOKDk6Lj2H9T570n+nhe+9VDSdJ0i8Xr4TSZPos1x9p+3h1MmmrP2EAmGZngC1PhXe3UX14upNOHAZ70213OND3c6gSmR+ixhz0WpG5zLRlIXio+/cCSkoSy21MzBrlXPcE3G/EEWcKt/gKcZB6WWQcU1kJNocN/IH9Q11WqXrn6MbKW8XPRotLOvGKkrlNWjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB5361.namprd11.prod.outlook.com (2603:10b6:610:b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Fri, 3 Mar
 2023 15:20:48 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.022; Fri, 3 Mar 2023
 15:20:48 +0000
Message-ID: <89e3ecb6-0e1a-3d86-cb05-cbb034c68dc4@intel.com>
Date:   Fri, 3 Mar 2023 16:19:51 +0100
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
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230302224946.never.243-kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB5361:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dd9f3a2-8aca-491d-39f0-08db1bfadd93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtNl1etQFbz7JmD++uwLHiF5XHFJ0UxuS5xuW5QG8Kl+Wjgn/Al8bFk2r9+xdXlhoq10sBdHzBefvJ3rV+aEUb8bfypG/suRNlTdCJ8s6LmR4UcNiCbvhzBfw67gUod2YmlXpppEcHNW3frNY0XxsBXa1lDwbmF07UTgUq5y9D7Y9SjogNCmWXQ0Yypd/J5jr8KtKlFJDu7yUfp0NzwFnQL1/6wc7mGGsJNY0T2qsTjiOQtPelJ9a2uVX+DXWaQ2kC5MpzQSTma+88/VxmSXTA4ClVARWgkTi5BQLdRc4n6SWBUbtGop2DkIvYDLe4uCb8B3u54/YaKc2naew5ve2O7qGGpXRB7Za14Axu//hxXroVSKCCYAOSQiwclbnO+8NpEz0f5vlo2ckr0ymuPAV8cAy+HLmXSbNH3NCpgH9gmNt96+rJpCBp6q1OYZOErNvFxsE66Ho2hRF5vhkKrDzypsePcxHo+mpIbEl3hfiIK3URCOHgYpFuZGVgHkvjf3PwIET4Cai6nVnp5umsWany12by6sZsc4cYnHvLIlkbEgFR8BjDYEvPwTgCAEknMh3cOS1Mz+qNWuOjbj4+rB05H/naYcqrci80mu3rLXaYgHgUUphXNUKZDj13oyxT8ahaJaTki3EKFnfmeLT3K0XYsXDWuNNbzevaXlpHZxxACCOtJqFh5c7WeZf4W5oBqdODZ8ctPnlEpIgo3acxXotw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(366004)(346002)(39860400002)(136003)(451199018)(8936002)(82960400001)(31686004)(5660300002)(8676002)(4326008)(41300700001)(6916009)(38100700002)(83380400001)(6486002)(36756003)(54906003)(2906002)(478600001)(31696002)(66476007)(2616005)(66946007)(966005)(66556008)(6666004)(26005)(86362001)(6506007)(316002)(186003)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blBIZEN3OUZkQUJPejRaREF2ZXNwaXZtQTlyQ3dOYi8zVWZGZkFMMjl1NlRQ?=
 =?utf-8?B?cDdTeFoyY3RaUERYbjFBSTNpLzV2SkRYSFRLdVR4NDFjNjlSQnUxc3BvSWZH?=
 =?utf-8?B?eXVNSDVZekJZWTJHSm9wejBZdGVJZFgwdlFsMHBHbFRxM3MyNWdNRExoVW55?=
 =?utf-8?B?V05FSk9PMDlMT2pFQVFHYWkycEhGZTk5ZUl3V1k5YmRlR21Qb2hxVThteUlC?=
 =?utf-8?B?R2RjdzFOdDFobEdadjhPUXNDWXJHSDJJTFBob0d4VGdtOFJRdThBM2ZTb3hW?=
 =?utf-8?B?dm54MzJkSU5ZSzJ0bFNNZ0ROUnNPNDlZcFVUWWE4bGFqSk5ZZXBWV0JreXJl?=
 =?utf-8?B?djZKeW5sNXAwMHNwNGZNTzRqd3N2RU4zKzg2NDJrR05pYVpQcStETUwzUTYz?=
 =?utf-8?B?Q09Wc0JodHJDZUhSNHg4YXBQempET29VbWJBRml4d2ZzTDkwZnlLejczVmcy?=
 =?utf-8?B?ajJDMUlZbjhkOXBMdGdtbXM0NW1RaEVLcS9ueG54WTRLV0tVU2t1UU42Vmw3?=
 =?utf-8?B?ZFlYMFF0YWRvWEFhNFJpcnc2Tm96RGlHWlAzNEpDNGNYdmN6Q1hocFcrM1RF?=
 =?utf-8?B?QmZ6UjNScW1jTmk1VXVsekNVOTJGdGhPNTFBZ2hRa1JkaDB4eis3OCtDcS9o?=
 =?utf-8?B?aXB2THRTKzhOZ2FvcDlDOUtJUktZY2x3RDlzSzJkUVlBR1NpRnNSQzNIWWpS?=
 =?utf-8?B?Y201SDduRy9tUTlJTFg3V3YzSUJja2RPV0RIKzBUVHowYVQ1Rk5MTmtlT3R5?=
 =?utf-8?B?S1dlUlVMTlo3ZU91UVo4TzVmZlcrQXc5NnROOEM1eTRad1F0RGdFRFNOZWg0?=
 =?utf-8?B?N1U4SCtIVFhJTnc2enBZV2lVRE4wekZRVG81b3c3cm5xL2lsaThkRUZIWis4?=
 =?utf-8?B?K1ZieDcrUGtibU93bXZXano4am1hUytCUk5SSUkxSzhkYm9wRExMTTJ0UmUx?=
 =?utf-8?B?eXBqRGxqQlhrY3JPS0MyWVR3UFZFa0FhaFh4bytkMUtLaDRidkhONzhTdVhH?=
 =?utf-8?B?THJKck5ieDYrOW1seEZDUkxpMnFjVGZlSUV0UFVhTENHZFk5a2RrOW12NVhk?=
 =?utf-8?B?VU1JUXhMSnA5YXVyUmtMVjlsQXpVSDRPNy9GMnN1QzdWdkZMSTN3TWtycmxi?=
 =?utf-8?B?L1MrenhDMldjN2g3d0VDd1hsb0lqWXV5Vm9DRng5NTJLNXo2TXFEWXRLSnB5?=
 =?utf-8?B?dEN2dzBpbG94dFl2K2RjU09nZFdvdzR6UE5ia3UvQ29yQnVSay8wUGRRcFNX?=
 =?utf-8?B?TDRXbEd0TkFZTU9rSE9PRUNHY2lRV3RKVzVzUDZWNHJEYnVBbUpuOWxWQ2ZY?=
 =?utf-8?B?bnpucTdsN1JGOFFJazdKd2JEbnhIeVlBbGlMMWlxYTNCY2pGRTYwUDVDL2xs?=
 =?utf-8?B?Nno2cEgxQjdtMEJNL1Uzd0xxaUJ4V1ptWFVoY2UxSW1jQ0JMWVZ6UHh1aVRn?=
 =?utf-8?B?N2pKT09wdlV3VndBWFRTVTJHK3BWRFZJbEZScUpWdmp3Wm5JSlBwb082ZVRr?=
 =?utf-8?B?VzVUdnlrR2NvQStCVm9PQVc2a0pyQ25oNHlKVlIwcVpxU0RjaGVjZVdFSVM0?=
 =?utf-8?B?b0Jac3VxZDZhOS9oZ2tsZHo4dnA1QW94MDlIS0xJZWIwL1VYQzBmTG5jRjEy?=
 =?utf-8?B?cnNrcTNGci9DdkNTcjNSVE5CU01tRC9pNUVUcmxPU25WSVkzOXFncVk3cGxH?=
 =?utf-8?B?dVZ1VStIajVhWXVnK0MxSklKL3ZSckxmZktUcW5VbWtCaG5nQ3QwYndONmR1?=
 =?utf-8?B?cEU2KzhyK3J0K0xQR09waW9TclZLQVl2M3ZPazUvMkxMcVhHQ2xlYzhpelBQ?=
 =?utf-8?B?R0hHVUJrQWdxbGE3bXBPM1F3TkZVaUZWVFNxUDRmQkxkT2N6b05DU2ljWUtK?=
 =?utf-8?B?d3M4cUd6aGtPRlVSUzV6SndBQlRRUlhoR2VudlE0c2FVc0VCTGJDeTJzdi9T?=
 =?utf-8?B?WnJKTzFJdEU2YTFCQU9Td0J5SmZ6RmgzWUJmY2h6Y0lDSDZybFRWSGRCVHZo?=
 =?utf-8?B?UmtVQnFrZDZ4NzYzVGNnMjArdXRPcktwMUdzUFV4WWtOTWtSZUJNcWx0ZnNI?=
 =?utf-8?B?S1hIR2lCbmV6SnFTK3llaW1EYkZBeHQzTDJQSTJUcitlVDJaZ2FoTG1qLzBJ?=
 =?utf-8?B?UWpRWUJHVTQ4dERxWVdSbHdzUEtBeWVzWkI5WEM5bkZSMGlGbFZkVFdMd1R3?=
 =?utf-8?Q?Jl207H/pQ1UowE+f/ch05sk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd9f3a2-8aca-491d-39f0-08db1bfadd93
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 15:20:47.9056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xXccnoA64RQpCN2JcvnmHcWlaMc3oNYXEZ8PlTLWziZQ21y5tEI17T/qSifpyk7zhMXyszAQWNeddEOrFK2JVLI7frjWs3LGHcoOcClQw0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5361
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Thu,  2 Mar 2023 14:49:50 -0800

> Under CONFIG_FORTIFY_SOURCE, memcpy() will check the size of destination
> and source buffers. Defining kernel_headers_data as "char" would trip
> this check. Since these addresses are treated as byte arrays, define
> them as arrays (as done everywhere else).

Yet another array-as-one-char, I wonder how many are still here...

> 
> This was seen with:
> 
>   $ cat /sys/kernel/kheaders.tar.xz >> /dev/null
> 
>   detected buffer overflow in memcpy
>   kernel BUG at lib/string_helpers.c:1027!
>   ...
>   RIP: 0010:fortify_panic+0xf/0x20
>   [...]
>   Call Trace:
>    <TASK>
>    ikheaders_read+0x45/0x50 [kheaders]
>    kernfs_fop_read_iter+0x1a4/0x2f0
>   ...
> 
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Link: https://lore.kernel.org/bpf/20230302112130.6e402a98@kernel.org/
> Tested-by: Jakub Kicinski <kuba@kernel.org>
> Fixes: 43d8ce9d65a5 ("Provide in-kernel headers to make extending kernel easier")
> Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

> ---
>  kernel/kheaders.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
[...]

Thanks,
Olek
