Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B89197F10
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 16:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgC3OyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 10:54:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:48804 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgC3OyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 10:54:02 -0400
IronPort-SDR: bVE95S9nAHI880y/LpLOMlmtoIklyC4wJHD1AIj49tGULlfaOccTyU54+PK5QS92KXY78Avsnz
 N+qx/7JF+Bfg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 07:54:01 -0700
IronPort-SDR: 6AZb4YxdwxccLW4pzPd13dyt/rHXVVgzptn6Vdg54LA9vG/5fJTzc+V8sE6REJPm3QXDHa1ck3
 3hn2SE3ALAzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,324,1580803200"; 
   d="scan'208";a="395146086"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 30 Mar 2020 07:54:01 -0700
Received: from [10.252.136.240] (kliang2-mobl.ccr.corp.intel.com [10.252.136.240])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 0BAF25805A1;
        Mon, 30 Mar 2020 07:54:00 -0700 (PDT)
Subject: Re: [PATCH] perf/x86/intel: Add more available bits for
 OFFCORE_RESPONSE of Intel Tremont
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, eranian@google.com, stable@vger.kernel.org
References: <20200308125507.18670-1-kan.liang@linux.intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <0a06d798-c90f-1824-50dc-acbeae6ee18a@linux.intel.com>
Date:   Mon, 30 Mar 2020 10:53:59 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200308125507.18670-1-kan.liang@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Peter,

Could you please take a look and apply the patch?

Thanks,
Kan

On 3/8/2020 8:55 AM, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> The mask in the extra_regs for Intel Tremont need to be extended to
> allow more defined bits.
> 
> "Outstanding Requests" (bit 63) is only available on MSR_OFFCORE_RSP0;
> 
> Fixes: 6daeb8737f8a ("perf/x86/intel: Add Tremont core PMU support")
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>   arch/x86/events/intel/core.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 3be51aa06e67..ba08ad1f560b 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -1892,8 +1892,8 @@ static __initconst const u64 tnt_hw_cache_extra_regs
>   
>   static struct extra_reg intel_tnt_extra_regs[] __read_mostly = {
>   	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
> -	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0xffffff9fffull, RSP_0),
> -	INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0xffffff9fffull, RSP_1),
> +	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x800ff0ffffff9fffull, RSP_0),
> +	INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0xff0ffffff9fffull, RSP_1),
>   	EVENT_EXTRA_END
>   };
>   
> 
