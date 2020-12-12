Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800132D8910
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 19:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389657AbgLLSJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 13:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbgLLSJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Dec 2020 13:09:51 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D4CC0613CF;
        Sat, 12 Dec 2020 10:09:10 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id f23so16895926ejk.2;
        Sat, 12 Dec 2020 10:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kVgdL2B7MTt0Fzgc35wnEsVqokD6iC4w8zTszx314Y4=;
        b=Du9m54PjDwlP5wo1ECsQM6S8frjG935mP18a3g5nrtzcEV+xYnN5xCLt6+sqqS9bma
         hKAgdp0WegfNrDEzBWk5y7bh1Tbrz/fyn7NkB1u3vXH8mT8Wp6R1T/0xjMjndFgJF7AA
         KOiuU00unQgQb/xYtLrtykxXv6GwE6TPpfSERfxhtxwk/gZBqR1iGifOWsQTqg2e3M88
         oAIscXj8U3h0yT/SXHdbSQOB+dDzUM8UU/v+ftUh751M5mLrd7uzNaSnOew6RVqpNgrv
         +4NpVCYYdhRnP/uyfh7CEKllsNCPtZdlAENaU7BPJepX52V79m6PR0sVdM6iaA154bFA
         2Fjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kVgdL2B7MTt0Fzgc35wnEsVqokD6iC4w8zTszx314Y4=;
        b=osUTqAmMwmQ5D66rpDLxfoIq2Jm4/Evzk7y0tohPCQIsw5jMOuhZFY4eQ+3VQW8vkR
         VNHJrFtzfAx+yWRki6Ct9CTlEIZs1A5UW5YxY40KTSi19f8SiFMj0GOh3hBA3+nx8An7
         B7x4ZkdBXvz6sxYINOU6fD/Y7G5D2lm4yxgXDdlxg9EcPjo+QPxjyBVv7Tk/zeuG8T9w
         OY0lvVKZwes1uOvqRL6jlD570Hrb6HXlfiK7LBSsGfmTCjk3zSsgbdXVdVoGUetFyPtk
         0Yj65fq0LH0rh9v/CZqUhyknH66iOG6bh55VLfHdYWNZWF8CJJ+yE5hr8wBwNgMLCsS0
         H52Q==
X-Gm-Message-State: AOAM532rez46OdsqqvYRwNxARA7TfdtPeugZkFIsb2ErswVakqzPHflO
        bCLzP5EVAi9oV49XRnxNp2gt6SO+xtqCKA==
X-Google-Smtp-Source: ABdhPJzpxDZXq2LngrrD2U0C+WNEJA9HPd6RiX8heFfecpVlSOhMcFt2AMLxw0pk+Ea5PJwnHWWQtA==
X-Received: by 2002:a17:906:c244:: with SMTP id bl4mr15408500ejb.430.1607796548785;
        Sat, 12 Dec 2020 10:09:08 -0800 (PST)
Received: from andrea (host-95-239-64-30.retail.telecomitalia.it. [95.239.64.30])
        by smtp.gmail.com with ESMTPSA id c12sm11158312edw.55.2020.12.12.10.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 10:09:08 -0800 (PST)
Date:   Sat, 12 Dec 2020 19:09:01 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        devel@linuxdriverproject.org
Subject: Re: [PATCH AUTOSEL 5.9 15/23] scsi: storvsc: Validate length of
 incoming packet in storvsc_on_channel_callback()
Message-ID: <20201212180901.GA19225@andrea>
References: <20201212160804.2334982-1-sashal@kernel.org>
 <20201212160804.2334982-15-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212160804.2334982-15-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Sat, Dec 12, 2020 at 11:07:56AM -0500, Sasha Levin wrote:
> From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
> 
> [ Upstream commit 3b8c72d076c42bf27284cda7b2b2b522810686f8 ]

FYI, we found that this commit introduced a regression and posted a
revert:

  https://lkml.kernel.org/r/20201211131404.21359-1-parri.andrea@gmail.com

Same comment for the AUTOSEL 5.4, 4.19 and 4.14 you've just posted.

  Andrea


> 
> Check that the packet is of the expected size at least, don't copy data
> past the packet.
> 
> Link: https://lore.kernel.org/r/20201118145348.109879-1-parri.andrea@gmail.com
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Reported-by: Saruhan Karademir <skarade@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/scsi/storvsc_drv.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 8f5f5dc863a4a..6779ee4edfee3 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1246,6 +1246,11 @@ static void storvsc_on_channel_callback(void *context)
>  		request = (struct storvsc_cmd_request *)
>  			((unsigned long)desc->trans_id);
>  
> +		if (hv_pkt_datalen(desc) < sizeof(struct vstor_packet) - vmscsi_size_delta) {
> +			dev_err(&device->device, "Invalid packet len\n");
> +			continue;
> +		}
> +
>  		if (request == &stor_device->init_request ||
>  		    request == &stor_device->reset_request) {
>  			memcpy(&request->vstor_packet, packet,
> -- 
> 2.27.0
> 
