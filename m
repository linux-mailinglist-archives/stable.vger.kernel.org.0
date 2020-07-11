Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA32021C3C8
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 12:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgGKKq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jul 2020 06:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgGKKq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jul 2020 06:46:57 -0400
X-Greylist: delayed 2696 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 11 Jul 2020 03:46:57 PDT
Received: from hall.aurel32.net (hall.aurel32.net [IPv6:2001:bc8:30d7:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1E7C08C5DD;
        Sat, 11 Jul 2020 03:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
        ; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
        Subject:Content-ID:Content-Description:X-Debbugs-Cc;
        bh=Brj2Uur/vWw8fobBoxnPCAHoheyz+8lGCkL8KGgE4kk=; b=T3rF3OsCphU2NAQsomSG79Gt7G
        toOUn6F5KjoMhxsr7qwX0TqKajhOBb5Yiwwk7CK6VeFp8KlTLYtmadtvGpULqvEEUVGwymznvessY
        5skk9TM12Wf3h47kZUDIbTMD+cCSJKHfCtijxevGHedRQlD857qWYp3owOp3DlgxEyGEfxGy4830G
        gnkd1pPeUZxEgirqLUdI96a9Rw8nnJCgofAUmv0QwIE1RbxsMZ1HBL1dUTMt182DuKbQuKqqducmU
        BmSvsX7hSsF8s3RJnoBcSCU0ZChdIhHvDUwQDF85JjEsXYUhEK2eAq0gPt7+eFVxbqotky0YlLYOj
        IDry8pzw==;
Received: from [2a01:e35:2fdd:a4e1:fe91:fc89:bc43:b814] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <aurelien@aurel32.net>)
        id 1juCKN-0005Xf-Iz; Sat, 11 Jul 2020 12:01:51 +0200
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.94)
        (envelope-from <aurelien@aurel32.net>)
        id 1juCKL-00A3er-Fn; Sat, 11 Jul 2020 12:01:49 +0200
Date:   Sat, 11 Jul 2020 12:01:49 +0200
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 080/106] mips: Add udelay lpj numbers
 adjustment
Message-ID: <20200711100149.GA2397222@aurel32.net>
Mail-Followup-To: Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20200608232238.3368589-1-sashal@kernel.org>
 <20200608232238.3368589-80-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608232238.3368589-80-sashal@kernel.org>
User-Agent: Mutt/1.14.0 (2020-05-02)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-08 19:22, Sasha Levin wrote:
> From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> 
> [ Upstream commit ed26aacfb5f71eecb20a51c4467da440cb719d66 ]
> 
> Loops-per-jiffies is a special number which represents a number of
> noop-loop cycles per CPU-scheduler quantum - jiffies. As you
> understand aside from CPU-specific implementation it depends on
> the CPU frequency. So when a platform has the CPU frequency fixed,
> we have no problem and the current udelay interface will work
> just fine. But as soon as CPU-freq driver is enabled and the cores
> frequency changes, we'll end up with distorted udelay's. In order
> to fix this we have to accordinly adjust the per-CPU udelay_val
> (the same as the global loops_per_jiffy) number. This can be done
> in the CPU-freq transition event handler. We subscribe to that event
> in the MIPS arch time-inititalization method.
> 
> Co-developed-by: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
> Signed-off-by: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Paul Burton <paulburton@kernel.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/mips/kernel/time.c | 70 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
> 
> diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
> index bfe02ded25d1..1e631a484ddf 100644
> --- a/arch/mips/kernel/time.c
> +++ b/arch/mips/kernel/time.c
> @@ -22,12 +22,82 @@
>  #include <linux/smp.h>
>  #include <linux/spinlock.h>
>  #include <linux/export.h>
> +#include <linux/cpufreq.h>
> +#include <linux/delay.h>
>  
>  #include <asm/cpu-features.h>
>  #include <asm/cpu-type.h>
>  #include <asm/div64.h>
>  #include <asm/time.h>
>  
> +#ifdef CONFIG_CPU_FREQ
> +
> +static DEFINE_PER_CPU(unsigned long, pcp_lpj_ref);
> +static DEFINE_PER_CPU(unsigned long, pcp_lpj_ref_freq);
> +static unsigned long glb_lpj_ref;
> +static unsigned long glb_lpj_ref_freq;
> +
> +static int cpufreq_callback(struct notifier_block *nb,
> +			    unsigned long val, void *data)
> +{
> +	struct cpufreq_freqs *freq = data;
> +	struct cpumask *cpus = freq->policy->cpus;
                                     ^^^^^^

The policy member has been added in kernel 5.2, so kernel 4.19.129 and
later do not build anymore when CONFIG_CPU_FREQ=y.

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                 http://www.aurel32.net
