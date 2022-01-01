Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD31948276A
	for <lists+stable@lfdr.de>; Sat,  1 Jan 2022 12:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiAALye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jan 2022 06:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiAALyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jan 2022 06:54:33 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0FFC061574;
        Sat,  1 Jan 2022 03:54:33 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id q16so60257183wrg.7;
        Sat, 01 Jan 2022 03:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tb/v9e8J7+Y4o1QXUsk8zIuYvgtfoFuFtb3CftFORZ4=;
        b=X8Kio1HVxscnz4si2+cRkMEBRcPZ5aCgWl3KEz0RJZdwKLK6PC7TNHFYOONss0vnan
         qE0JQvZrZFFkFg+sEauFFx9sZreSdXEEBVr+6yNWljKP5eULOH2yOTJPkI+QuMdc15cz
         m3MwlIyxrLMqzAYvPb3WjhLJ/js86oBhVuXu7RxjPkWeRTwNOoUEQRM4xlNFZQwXdp3N
         oUEpuliweE/XWawNDVicWgolHK2y3tDWiuXmiPxvs1XbxAl29Gt2r6KKFOWfAVRGn2y9
         gvyOcDD/Be1VFAH3yRnUlDqXB6lmDhXwKPROeiVWCoaGNv2dFsuxRB4mz9nKLuqcl4tb
         2bBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=tb/v9e8J7+Y4o1QXUsk8zIuYvgtfoFuFtb3CftFORZ4=;
        b=IVpADJv4eHobRtUao5t6ktjIGD/U2/nTC4IkYRm/mc6pt5Lt+Qj5liES/th39tKwzg
         PBXa26mpXgdEbx7xaPZgaPlVdWt6NH+MIryBHATifKKJS3DhOtJENLRi6pO0jXHT6kXg
         pL7Man0cqkC4SyLw4Qze1HYrKK3t/Qr+0tO5NRBF31YpY+/L4JK92gYShuw1+wwSiYU5
         xgGZxXbcHGpuF9SUCCeHMMNzyoYNxDD2B3WdEjLXkEzMsXVNI7+W9dptwz4evO6fTtKA
         IauQOBZjJH+u4x/C5KQKWFc8DfcoHLmEdcvFDT6EUXl88wRoA2oe0SDz1yQMykEVA/jn
         /Jew==
X-Gm-Message-State: AOAM5337Fef5zpe70ueqFkyXkBD6oT94ucblcVoXTrJmMaWFdhydnDH2
        ePK71U/NZkpv5swpHGs3wRUKKp6TOgY=
X-Google-Smtp-Source: ABdhPJyxMDvU6BP4XaFfrL7euVFSCXXbo/+uui+AFwDmj7iCF+RXvMk+ahYDLVofzj30/H+OQdtKtg==
X-Received: by 2002:adf:f384:: with SMTP id m4mr10705709wro.524.1641038071824;
        Sat, 01 Jan 2022 03:54:31 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id h4sm29707730wrf.93.2022.01.01.03.54.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 01 Jan 2022 03:54:31 -0800 (PST)
Date:   Sat, 1 Jan 2022 11:54:29 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 26/76] sfc: Check null pointer of rx_queue->page_ring
Message-ID: <20220101115428.5mxenvq5k2cmzjlt@gmail.com>
Mail-Followup-To: Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20211227151324.694661623@linuxfoundation.org>
 <20211227151325.595242432@linuxfoundation.org>
 <20211229111730.GB25195@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229111730.GB25195@amd>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 29, 2021 at 12:17:30PM +0100, Pavel Machek wrote:
> hi!
> 
> > From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > 
> > [ Upstream commit bdf1b5c3884f6a0dc91b0dbdb8c3b7d205f449e0 ]
> > 
> > Because of the possible failure of the kcalloc, it should be better to
> > set rx_queue->page_ptr_mask to 0 when it happens in order to maintain
> > the consistency.
> 
> This is confusing/wrong, or at least not a complete fix.
> 
> > +++ b/drivers/net/ethernet/sfc/rx_common.c
> > @@ -150,7 +150,10 @@ static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
> >  					    efx->rx_bufs_per_page);
> >  	rx_queue->page_ring = kcalloc(page_ring_size,
> >  				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
> > -	rx_queue->page_ptr_mask = page_ring_size - 1;
> > +	if (!rx_queue->page_ring)
> > +		rx_queue->page_ptr_mask = 0;
> > +	else
> > +		rx_queue->page_ptr_mask = page_ring_size - 1;
> >  }
> >  
> 
> So we have !rx_queue->page_ring. But in efx_reuse_page, we do
> 
>         index = rx_queue->page_remove & rx_queue->page_ptr_mask;
> 	page = rx_queue->page_ring[index];
> 
> So index is now zero, but we'll derefernce null pointer anyway.

Good point. I've posted a patch for this to netdev.
https://lore.kernel.org/netdev/164103678041.26263.8354809911405746465.stgit@palantir17.mph.net/

Thanks,
Martin
