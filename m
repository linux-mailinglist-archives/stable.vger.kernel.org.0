Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A507D225E47
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgGTMSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:18:33 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:58923 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728532AbgGTMSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:18:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id DA422580458;
        Mon, 20 Jul 2020 08:18:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Zou6qAflmxW7TQM12J8BVt0wUlM
        oX2IiWZ/QdAdyc6w=; b=npmmPscEfVl5ZO2ikn3bQb/N4pTyVSJ2vHu2kyeuf0n
        w14Sch7ufOxs6SGCWUjJFR1WVBKYIM1wws8FpeOW2Ve3xzl415Mkwr8ytvV2O4ys
        A6kHcOIPSNXCgMojs2HSxveUte3rJb/gs/NQYV6E5D2N9BEg9oV9lDN6LLISMFs3
        ElVAyxnvA5S+vzpx8iuRjWX4cuye0QPQT0H3BZZuOu41TNhdRP6PUsLtfhiSgZvG
        NSQgitjikhvkv6TmV+dQmHwpgsv/PBeiHOiMbQDp2B61gM+BT47nXp5w5AKDMfQs
        QeFNIO+yVdh6DHNlXkGcFgs9B/m7op7lWiEGaW5KWuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Zou6qA
        flmxW7TQM12J8BVt0wUlMoX2IiWZ/QdAdyc6w=; b=fHRc77/VHodwY8LztJRtyc
        irPG7DCEVBhT7wiGzL6S09HFpEIFQvjJmSHxUQ8inp0zNwnwQhSt2ZdttkkoEY6J
        U4kUmSxra9dtv0BIHJK6ZSe0aCFn2E/sRc0MKbyXBDExbyjDNJt5hD8jN5/kmsWu
        R36xXYuzJhhHKzqgNNCSDuB8SMZbxJgJFPxZDoxPkVGjRJXBNVfcKWOuqpIcgrwa
        PP0arTKIilV3Sv7MvqZSK7ZuBWG1fAkqKDFiJcvaFMH4XL28TsGHgOuGn43RnISN
        oKt4hlIBV8X0B8ofhUAEtEphjoY490FVOrPLKt9960rJHGYgiHV/Uh5WI63Z+ogw
        ==
X-ME-Sender: <xms:losVX5hCPh19khmNPb3zPXfCZwsFO5q8MFdqvWJKdHiyWMoYux0cvw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:losVX-AGbd_1MQjVjVNRarCnMDU54x_PSKRwKWOgKlDxP85euYyAbA>
    <xmx:losVX5GFeaPu47-7ChqNyztbRcmzFbrdXW17EtHC0bwonbNhs2oynw>
    <xmx:losVX-SQTe01C_qjCrsbu9kl-fOMb3pO9DT6XU_jWhfL0bstrejA9Q>
    <xmx:l4sVX1n0SJLXV_AQ1CnI41d3QOaJp8O3DfPx-ZuEtabwzPduj48R6w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 424FF3280059;
        Mon, 20 Jul 2020 08:18:30 -0400 (EDT)
Date:   Mon, 20 Jul 2020 14:18:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org,
        Amit Daniel Kachhap <amit.kachhap@gmail.com>,
        Javi Merino <javi.merino@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Finley Xiao <finley.xiao@rock-chips.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [For-STABLE] thermal/drivers/cpufreq_cooling: Fix wrong
 frequency converted from power
Message-ID: <20200720121840.GB2984743@kroah.com>
References: <bc3978d0b7472c140e4d87f61138168a2a7b995c.1594194577.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc3978d0b7472c140e4d87f61138168a2a7b995c.1594194577.git.viresh.kumar@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 08, 2020 at 01:23:43PM +0530, Viresh Kumar wrote:
> From: Finley Xiao <finley.xiao@rock-chips.com>
> 
> commit 371a3bc79c11b707d7a1b7a2c938dc3cc042fffb upstream.
> 
> The function cpu_power_to_freq is used to find a frequency and set the
> cooling device to consume at most the power to be converted. For example,
> if the power to be converted is 80mW, and the em table is as follow.
> struct em_cap_state table[] = {
> 	/* KHz     mW */
> 	{ 1008000, 36, 0 },
> 	{ 1200000, 49, 0 },
> 	{ 1296000, 59, 0 },
> 	{ 1416000, 72, 0 },
> 	{ 1512000, 86, 0 },
> };
> The target frequency should be 1416000KHz, not 1512000KHz.
> 
> Fixes: 349d39dc5739 ("thermal: cpu_cooling: merge frequency and power tables")
> Cc: <stable@vger.kernel.org> # v4.13+
> Signed-off-by: Finley Xiao <finley.xiao@rock-chips.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Link: https://lore.kernel.org/r/20200619090825.32747-1-finley.xiao@rock-chips.com
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Greg,
> 
> I am resending this as I got your emails of this failing on 4.14, 4.19
> and 5.4. This should be applied to all three of them.
> 
> @Finley: I hope I have done it correctly, please do check it as this
> required me to rewrite the code to adapt to previous kernels.
> 
>  drivers/thermal/cpu_cooling.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 908a8014cf76..1f4387a5ceae 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -280,11 +280,11 @@ static u32 cpu_power_to_freq(struct cpufreq_cooling_device *cpufreq_cdev,
>  	int i;
>  	struct freq_table *freq_table = cpufreq_cdev->freq_table;
>  
> -	for (i = 1; i <= cpufreq_cdev->max_level; i++)
> -		if (power > freq_table[i].power)
> +	for (i = 0; i < cpufreq_cdev->max_level; i++)
> +		if (power >= freq_table[i].power)
>  			break;
>  
> -	return freq_table[i - 1].frequency;
> +	return freq_table[i].frequency;
>  }
>  
>  /**
> -- 
> 2.25.0.rc1.19.g042ed3e048af
> 

Now queued up, thanks.

greg k-h
