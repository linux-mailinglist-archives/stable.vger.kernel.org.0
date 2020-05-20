Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378131DA681
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 02:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgETA0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 20:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgETA0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 20:26:36 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F22C061A0E
        for <stable@vger.kernel.org>; Tue, 19 May 2020 17:26:36 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 142so1924693qkl.6
        for <stable@vger.kernel.org>; Tue, 19 May 2020 17:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nE9yGKuHmyTdmxhrXXfxST6XxOah5ElttRSkoHJZ5qU=;
        b=eTdF25Z3gw9qjHPYw1NkCgy5PcHufAe72jf5rpfeYRZbnWUzny5qGdsN86FOpL0vNc
         KP2DPKDVL16AoIp1y7hkFUJz8uw9FXe1G36AXs+Tr7zz3BtyT49u2pi+lq3KGOfvD3ia
         l3u/YTaVwqVV7dpZfJgFIXn8v1n9bt4ylSPVR/8+f3xsRNEDpyEP+03lQQCdrz8N6RMi
         6AYOgx25V4i+EkPJOrghohywsxv4YuI3ZYzxvp0+24h1oWC/tQNaEVGH+Lss6NQx3/b9
         Uy10SXfuNN0ZH5+WmyxbR2gpDkcYImsI99/+03RDz7YBx4L0qsx8WKKeCydSRd+nNcMM
         N+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nE9yGKuHmyTdmxhrXXfxST6XxOah5ElttRSkoHJZ5qU=;
        b=KwwDkRxg9fIcRlBfAF/JzeBLBozQuT5SLUZDDVM1UjK8yKS11M82r0iR/LV32T4ysd
         fEU5f2W/fhRQxLsES2tZlpr4OcZPr6V7WJuUSdK6c9gl3bq1YcFUn9EHElXbWy3hA8DJ
         8ZysI3ynsnkXP6qdVYfRL8J810k5CqsY+5YGEaISBa5L3vbWoc3087/3fGU0R4flJsl5
         CxCqY+HGjLAvRwA92qrI5XVlgRMPhKQueLKtRMhQqm3Wt8RvCBypO1DOZEABmNVPk1Wt
         ZimQ7l98u+0Ab818lZhzhZsXkoCaHvw2mAHs/QqGLuBh+WYZGVr1sXJi3ZPL0o7XchK/
         zdMA==
X-Gm-Message-State: AOAM5338klF26/nzBHjYEysq18KZhrF9x9RZjpPctBc7sbYq8kalR1b4
        CewrFeeuC1yfpyTvxeFfCrj/lQ==
X-Google-Smtp-Source: ABdhPJyV40iO2ET5T/0qUojJK8xg7Xixyujhd49wVC+crumicEgK3ik5uVhjo+1eTNCC0zsjRROrHA==
X-Received: by 2002:a05:620a:1e:: with SMTP id j30mr2238850qki.470.1589934395246;
        Tue, 19 May 2020 17:26:35 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id 23sm912470qkf.68.2020.05.19.17.26.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 May 2020 17:26:34 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jbCZ8-0003YU-Ed; Tue, 19 May 2020 21:26:34 -0300
Date:   Tue, 19 May 2020 21:26:34 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Subject: Re: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq when
 the device is shut down
Message-ID: <20200520002634.GF31189@ziepe.ca>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
 <20200512031315.189865.15477.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512031315.189865.15477.stgit@awfm-01.aw.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 11:13:15PM -0400, Dennis Dalessandro wrote:
> From: Kaike Wan <kaike.wan@intel.com>
> 
> The workqueue hfi1_wq is destroyed in function shutdown_device(), which
> is called by either shutdown_one() or remove_one(). The function
> shutdown_one() is called when the kernel is rebooted while remove_one()
> is called when the hfi1 driver is unloaded. When the kernel is rebooted,
> hfi1_wq is destroyed while all qps are still active, leading to a
> kernel crash:

AFAIK the purpose of shutdown is to stop all in progress DMAs.

If devices are wildly doing DMA during the shutdown process then all
manner of things can fail, including kexecing into another kernel.

Do you achive that with these shutdown handlers?

It does make sense that the work queue would not be destroyed in
shutdown, but I'm surprised it doesn't flush it?

Jason
