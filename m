Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3B04F0E50
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 06:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348221AbiDDEtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 00:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiDDEtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 00:49:50 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE87D338AA
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 21:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649047675; x=1680583675;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BHBZgHUefmELj0zgzevbpSPnLm03EOEynOhd680wClc=;
  b=HcuVqsQ8VFUgAroAnGwgm13PrnF/EAeBgaC46x/i/fq5aO3eyRgzNXFY
   OpRJ+u6oliqwkrj5ACtXHRXmvC36MyRR0vRmIzYFq2mYICPrPRy6OEa2E
   DORZ4uzl9VPBaugh7ewniTTSlTp/phLvQ31YwQY7dF1a1b9RUFI43t+eD
   dWRL/Fn9WiaM3Ox/yLE2/YWlFwjtIopr2saHqWyQTpa9ZDHk8q2in6FR6
   oBlsX59YNKxxyyTRHhVj+SaJLSjB1o8rTZzj9a9dAPJwbwKgLBO/VXtiG
   zqAXghEKeu3UK1OSRTHwUybeI2c464VQ6GdoGGuAlB3XysNjX7WMKJ5Y3
   w==;
X-IronPort-AV: E=Sophos;i="5.90,233,1643644800"; 
   d="scan'208";a="201848448"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Apr 2022 12:47:54 +0800
IronPort-SDR: ooXrZdJD2rB5TynppexmfKiq+d5Y2vm/QW583L75Dc7fM3bomFUsbu6PeOYxJtRvqESaQrAAuL
 4EdA3ee6asL+c0oynyO/+4jFaL6OXxF8pIDBFMFdK55LhL/zcLW9VUlR5fwaRn1/WUoz3pwb3T
 f4+kMTiQMyR0sNEdZrHZw6/gla6j8Me2nrJ3YlWRDpwqQLpP0uzR8OFFVoo4mdmRKAB43RY4kJ
 hMf3YgD65b36byTWPHLFT2aHtOd0EWul+nVUF3QRZnWdvgrkBkz9iPHLd579ByAXesOs+Y3B52
 ZTECYHs9n1Q0fC/jMM5jib/A
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Apr 2022 21:18:39 -0700
IronPort-SDR: h854/TyfvaOxxZveT9cAriuczjuiDP2xtC7ZEFT0dSMdRR9bExn9hXYCse6CP8Rv+gvXuNl/hG
 7Ugjg14h2lfhEixOQS6mFnI8hJO2UESseGBxtAlMDMZbKW9/9adNEKH7wiRVveZ6eVabyk0nHM
 NrKGQ8g3BueOEDOnBbNhAWQzC7CrGcAgWePgUrqi1gpqAANTb45p67NHy6k+Eo2OVQ201Q8o1Y
 c28l1rikyapOZUNXlssl/DLh0fLxYztTGSGTa28Y/NdkyvEy+2t9l7f3RwOXCJrNXNkN3zXygB
 Jk8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Apr 2022 21:47:55 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KWyvG4HgJz1SVnx
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 21:47:54 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649047674; x=1651639675; bh=BHBZgHUefmELj0zgzevbpSPnLm03EOEynOh
        d680wClc=; b=KXpSpE2ORdrUh9uCjJHul6jJd5iISMHwKIW4DgkCz8NE21ehQe4
        wcc0/pcdIcRWmPpsI5/c++5XD0lWPjEhWmW9XTgA7mmAg7iRM8nson7ieE7OzKCP
        XKHr6OZ9gJGWdHu9GA287/OgwlIT0YXBOt207seb029BUA1z6JAgyCKewE30nUEd
        XblKmt4VNLgAYmz5euV4fOxhxVEsaWU3Aw5S0wd2NMq5fyM98ULDkagrb+4Zo5VN
        2yEsglWN2FhMdd5j5NvcnIa6vtkK97bliAAlYcGh9aZep+CMqyQQ6oQWSDeDNfjL
        nEr3XtkB67miixeh7Cy4BiLPZwEQoePfXXQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 2nMunnLJ_xWG for <stable@vger.kernel.org>;
        Sun,  3 Apr 2022 21:47:54 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KWyvF3j8Vz1Rvlx;
        Sun,  3 Apr 2022 21:47:53 -0700 (PDT)
Message-ID: <21bdcf98-378b-bf00-3148-b24a79ec8be8@opensource.wdc.com>
Date:   Mon, 4 Apr 2022 13:47:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: FAILED: patch "[PATCH] scsi: scsi_debug: Fix qc_lock use in
 sdebug_blk_mq_poll()" failed to apply to 5.17-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, martin.petersen@oracle.com
Cc:     stable@vger.kernel.org
References: <1648827046150105@kroah.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1648827046150105@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/2/22 00:30, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.17-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Greg,

b05d4e481eff ("scsi: scsi_debug: Refine sdebug_blk_mq_poll()") which 
this patch fixes is not in 5.17 kernel, so there is no need for this 
backport.

Thanks.

> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From 3fd07aecb75003fbcb0b7c3124d12f71ffd360d8 Mon Sep 17 00:00:00 2001
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Date: Tue, 1 Mar 2022 20:30:09 +0900
> Subject: [PATCH] scsi: scsi_debug: Fix qc_lock use in sdebug_blk_mq_poll()
> 
> The use of the 'locked' boolean variable to control locking and unlocking
> of the qc_lock spinlock of struct sdebug_queue confuses sparse, leading to
> a warning about an unexpected unlock. Simplify the qc_lock lock/unlock
> handling code of this function to avoid this warning by removing the
> 'locked' boolean variable. This change also fixes unlocked access to the
> in_use_bm bitmap with the find_first_bit() function.
> 
> Link: https://lore.kernel.org/r/20220301113009.595857-3-damien.lemoal@opensource.wdc.com
> Fixes: b05d4e481eff ("scsi: scsi_debug: Refine sdebug_blk_mq_poll()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index f4e97f2224b2..25fa8e93f5a8 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -7509,7 +7509,6 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
>   {
>   	bool first;
>   	bool retiring = false;
> -	bool locked = false;
>   	int num_entries = 0;
>   	unsigned int qc_idx = 0;
>   	unsigned long iflags;
> @@ -7525,11 +7524,9 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
>   	if (qc_idx >= sdebug_max_queue)
>   		return 0;
>   
> +	spin_lock_irqsave(&sqp->qc_lock, iflags);
> +
>   	for (first = true; first || qc_idx + 1 < sdebug_max_queue; )   {
> -		if (!locked) {
> -			spin_lock_irqsave(&sqp->qc_lock, iflags);
> -			locked = true;
> -		}
>   		if (first) {
>   			first = false;
>   			if (!test_bit(qc_idx, sqp->in_use_bm))
> @@ -7586,14 +7583,15 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
>   		}
>   		WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_NONE);
>   		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
> -		locked = false;
>   		scsi_done(scp); /* callback to mid level */
>   		num_entries++;
> +		spin_lock_irqsave(&sqp->qc_lock, iflags);
>   		if (find_first_bit(sqp->in_use_bm, sdebug_max_queue) >= sdebug_max_queue)
> -			break;	/* if no more then exit without retaking spinlock */
> +			break;
>   	}
> -	if (locked)
> -		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
> +
> +	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
> +
>   	if (num_entries > 0)
>   		atomic_add(num_entries, &sdeb_mq_poll_count);
>   	return num_entries;
> 


-- 
Damien Le Moal
Western Digital Research
