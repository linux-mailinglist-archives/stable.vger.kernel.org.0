Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3FB65E46F
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 05:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjAEEKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 23:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjAEEJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 23:09:35 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E89F77
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 20:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672891729; x=1704427729;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=N0Kcvp41Eru0iVlbgzDtN70tM5mBkIsV5zG45CX2wEM=;
  b=VXe68UC9Nm0bK6QApg7fjhhR4gXwJOyla13PtbBGmvhwABAcTjdXtuBq
   sTi5EEZkfMg1QfhxZBAuvPzRPhM79qW3qlSfhJxyggKPcmMPplEvyLO8B
   +3n8Wlb4RZkhKbiLta6Xk5heSLBVAFoC6+Hhc6c4hGsXBpiG9v+CV4Bmc
   RHH4Y9WKUgoDU0VvCwMU0srgYycJLFNutqF3LDC2T8UyHmndvisqm9tpL
   ht9fFQoJ4RJ/wpuywV7nN6IP0IJOMgtI6AV4sXRNc8WTzmFmapMOk89zs
   EAPzgyWuafAcKJEqWIvf2VKM9ugNMXcjQZD+8maKJW1DsYEh/UdxMC/CU
   w==;
X-IronPort-AV: E=Sophos;i="5.96,301,1665417600"; 
   d="scan'208";a="219945616"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jan 2023 12:08:49 +0800
IronPort-SDR: aE7ssNCGCmwq0kwPZTQMoIJQckcvrj62e8g0/J2UXFVtcATuHCFa8ujljacYbRLBU6hw8d5LkE
 Vobb8vMQ+lXih1yQ10CNESVMGM5K4zUrVswg0t4wWtKlIjE4v9Zj/Ldis5znPt2EwCkbXhF2Nz
 a+sptpftycQVQb14vRiqA2aKKhvm40IM+CFKF3UWol5mT6oPNXL7mZYm9F54qI4/ixgaoWfVUj
 LonEfRbPQfKCcmgsXCbqLtXEanar/taA+jowdWd4H+qG4wgoCu/sL0RM1FKRKrYnnMDs7Qy6UO
 mKI=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jan 2023 19:21:00 -0800
IronPort-SDR: gLxXM6tfX3LsnCIWG5dq/6MMTZv8bRZkoSzKAVz2g0faqSMIpiAd6pZN4mWBXBpEimPfDFiumm
 MPSv1XxPpj5WcJH2YDAdUtNdRM6ENVPkrzA7n168iVFapiZUQ221XeRNcuy+g3N0Twma1mep9V
 H69YgKZBPt4FrUmc3yaCLyqULaoURhw6EyyuOc0nga9SHIZUn6+YvE1dumYRJtoAw1uIIbXcIs
 AZX3ivuVPmkS/8LC61+UbrpXw443iryct5QF1hDjfpZuZW49nBEmepCtgEqZEB+R1qm2QgC7eu
 4tk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jan 2023 20:08:50 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NnXym5ZRrz1RwqL
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 20:08:48 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1672891728; x=1675483729; bh=N0Kcvp41Eru0iVlbgzDtN70tM5mBkIsV5zG
        45CX2wEM=; b=F66ot3NGFi+CE1Gk8f2Aq+uQkl9esk6xvM/UPGmHiqu37t41Yr0
        tLFO5MmNyXe5be1LqKMp4ANMoB+hHmz5BV3/I6MRXHxQlya5ZCC0xQ2Vh0RXIpAW
        d1gL7KNm3FACZ5L2nRKHKtolwkfcsS2srNgwpSVlB4ot4gEWH+MaCmw5vhf9NjL8
        T4hKMpiO86JmT87MQ1fbg1uyP6O0jC78UOte0hNLDDVOvfAIcD/gO4c/o+qAZnEE
        LcHJ3k8uJFGgGYYQyYUUJm6t0ng6pTxNVgAofSmW0zakuwb864kE5tQA3faSCjBt
        cNEDzLvoGhR7kEH/a2GWo09SGLzL5DFv5rQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QmW0TOzfKcep for <stable@vger.kernel.org>;
        Wed,  4 Jan 2023 20:08:48 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NnXyl3F5xz1RvLy;
        Wed,  4 Jan 2023 20:08:47 -0800 (PST)
Message-ID: <303876b8-7dc2-d6b9-372b-cb4641d92819@opensource.wdc.com>
Date:   Thu, 5 Jan 2023 13:08:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: FAILED: patch "[PATCH] block: mq-deadline: Fix
 dd_finish_request() for zoned devices" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, axboe@kernel.dk,
        johannes.thumshirn@wdc.com, stable@vger.kernel.org
References: <167284210313124@kroah.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <167284210313124@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/4/23 23:21, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Greg,

I sent you a backport in reply to your email.

Thanks !

> 
> Possible dependencies:
> 
> 2820e5d0820a ("block: mq-deadline: Fix dd_finish_request() for zoned devices")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 2820e5d0820ac4daedff1272616a53d9c7682fd2 Mon Sep 17 00:00:00 2001
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Date: Thu, 24 Nov 2022 11:12:07 +0900
> Subject: [PATCH] block: mq-deadline: Fix dd_finish_request() for zoned devices
> 
> dd_finish_request() tests if the per prio fifo_list is not empty to
> determine if request dispatching must be restarted for handling blocked
> write requests to zoned devices with a call to
> blk_mq_sched_mark_restart_hctx(). While simple, this implementation has
> 2 problems:
> 
> 1) Only the priority level of the completed request is considered.
>    However, writes to a zone may be blocked due to other writes to the
>    same zone using a different priority level. While this is unlikely to
>    happen in practice, as writing a zone with different IO priorirites
>    does not make sense, nothing in the code prevents this from
>    happening.
> 2) The use of list_empty() is dangerous as dd_finish_request() does not
>    take dd->lock and may run concurrently with the insert and dispatch
>    code.
> 
> Fix these 2 problems by testing the write fifo list of all priority
> levels using the new helper dd_has_write_work(), and by testing each
> fifo list using list_empty_careful().
> 
> Fixes: c807ab520fc3 ("block/mq-deadline: Add I/O priority support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Link: https://lore.kernel.org/r/20221124021208.242541-2-damien.lemoal@opensource.wdc.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --git a/block/mq-deadline.c b/block/mq-deadline.c
> index 5639921dfa92..36374481cb87 100644
> --- a/block/mq-deadline.c
> +++ b/block/mq-deadline.c
> @@ -789,6 +789,18 @@ static void dd_prepare_request(struct request *rq)
>  	rq->elv.priv[0] = NULL;
>  }
>  
> +static bool dd_has_write_work(struct blk_mq_hw_ctx *hctx)
> +{
> +	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
> +	enum dd_prio p;
> +
> +	for (p = 0; p <= DD_PRIO_MAX; p++)
> +		if (!list_empty_careful(&dd->per_prio[p].fifo_list[DD_WRITE]))
> +			return true;
> +
> +	return false;
> +}
> +
>  /*
>   * Callback from inside blk_mq_free_request().
>   *
> @@ -828,9 +840,10 @@ static void dd_finish_request(struct request *rq)
>  
>  		spin_lock_irqsave(&dd->zone_lock, flags);
>  		blk_req_zone_write_unlock(rq);
> -		if (!list_empty(&per_prio->fifo_list[DD_WRITE]))
> -			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
>  		spin_unlock_irqrestore(&dd->zone_lock, flags);
> +
> +		if (dd_has_write_work(rq->mq_hctx))
> +			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
>  	}
>  }
>  
> 

-- 
Damien Le Moal
Western Digital Research

