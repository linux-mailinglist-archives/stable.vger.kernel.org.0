Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7801DA5EE
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 02:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgETAA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 20:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbgETAA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 20:00:58 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAE6C061A0F
        for <stable@vger.kernel.org>; Tue, 19 May 2020 17:00:57 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id fb16so537611qvb.5
        for <stable@vger.kernel.org>; Tue, 19 May 2020 17:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oE/Ah52jSj0agjmvQ8lX4jPK/RfpHlM8F3+a9KJkLyM=;
        b=AtrAp4V4qyOMONdlg7yRBoQGQWCUt4QrrpXDcsQOdpeUxxg0bCzO9iESHoIRmne6if
         YYpjY8HKK84DltVXZsMXrc43PN6BcSNfsyiTQwVsDE6cCFzhjuGcxyBl5ds70FyR3D6k
         A2Tutwopig3567YOXAp4WK0+ILjvmHMPM7JjRh0Ia8JGZlRTVBisEDPVOgSaUQQGFuVN
         vA9DSJJ/pOhQyx9SrI4NpketeK1V+OlHah7Ens6SJ/3faQyS92WDYdCD2gpWAAX4ugjf
         pQFtt+CxrqzCAw7uculMWzOKUwu0pt2sjfkFP5NfAFcyIfXzxsmhYJYpUx6jw+KMCyEd
         XlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oE/Ah52jSj0agjmvQ8lX4jPK/RfpHlM8F3+a9KJkLyM=;
        b=EK5TYMbj39L9EIvY1WZm4xDbO6UiesQ0PcPwYnwwvVKvA7+Xv3uzbjE33SOpwVEzbh
         28EhK+1DuCs1uwIq6Ira0u1o/jbQvXDpVRB/f8wyokgfF3gz0IfWrE82eTIL12VeEdIW
         YUdtbkMKp4Cn3Rgp7G1JF1RwiUrok8DkmTBxVrCQZHcxoN+ET3uK1TZ/F5ilDEcn23bU
         YqWBrpOhcfoXZOEdMQp3dvZsZq2ULZbeNe2rnfmeZf5yD5QAc8+LgPeWJYntxSOSlfYH
         dO0jLdpkTU4GJUYdiqm6k8hPFsWDj+Sj272bzW745dRtjmnBZAI4b15DvUbHv5SGHtOI
         QOlQ==
X-Gm-Message-State: AOAM533nkYhSWraXMSGsh5nigauoxGUpPvLIGzujPEiNdaCv7MKQ/40v
        zoK2hhy07XeyjyRgMgAS7rAR8g==
X-Google-Smtp-Source: ABdhPJwkUTtWCGAwdWtVD4Pfac9u33ckw7vmZLGT2Qm6/Epr8GWHFVGiFFpkqYOmLHgZGnBG6kf+Qw==
X-Received: by 2002:a0c:a5c5:: with SMTP id z63mr2362035qvz.50.1589932856167;
        Tue, 19 May 2020 17:00:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id t130sm939740qka.14.2020.05.19.17.00.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 May 2020 17:00:55 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jbCAJ-0001cg-A4; Tue, 19 May 2020 21:00:55 -0300
Date:   Tue, 19 May 2020 21:00:55 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Subject: Re: [PATCH for-rc or next 3/3] IB/qib: Call kobject_put() when
 kobject_init_and_add() fails
Message-ID: <20200520000055.GA6205@ziepe.ca>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
 <20200512031328.189865.48627.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512031328.189865.48627.stgit@awfm-01.aw.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 11:13:28PM -0400, Dennis Dalessandro wrote:
> From: Kaike Wan <kaike.wan@intel.com>
> 
> When kobject_init_and_add() returns an error in the function
> qib_create_port_files(), the function kobject_put() is not called for
> the corresponding kobject, which potentially leads to memory leak.
> 
> This patch fixes the issue by calling kobject_put() even if
> kobject_init_and_add() fails. In addition, the ppd->diagc_kobj is
> released along with other kobjects when the sysfs is unregistered.
> 
> Fixes: f931551bafe1 ("IB/qib: Add new qib driver for QLogic PCIe InfiniBand adapters")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Lin Yi <teroincn@gmail.com>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Kaike Wan <kaike.wan@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/qib/qib_sysfs.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Applied to for-rc

Are you respinning the other two patches?

Thanks,
Jason
