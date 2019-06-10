Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBF33B5EF
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 15:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390147AbfFJNZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 09:25:13 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43521 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389171AbfFJNZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 09:25:13 -0400
Received: by mail-qk1-f196.google.com with SMTP id m14so5481440qka.10
        for <stable@vger.kernel.org>; Mon, 10 Jun 2019 06:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EP2hZETBNFMkMXQxpC7bE32Nxy9YmYkXCgVJmKFvnLM=;
        b=lwBm86jc/w+BsZQDmX0MTSUYY0dS1P3p1OP7wg9GUju0nDip/kI7LJoL7jWr4kfSHU
         Phwm3GHY+tyW1P+TaAndQb5pOnMlwAxk5YgAIZbH7+3Iyup4eAzfsMQHAQNPOmGaCF5d
         p51sZTVyHQOnR2iGER7aRFAcJyUog3xq9e/5G2MFGIfgXP+HfdC7mlA8x8W0iOH++2Ff
         yll0XK3ITowTFtIcGs6zx9ogZj/wvKOOFse1hG0gUjJF1bEj+hvDEKOZTA+SALHRxAoE
         /s465zAJVDND1Csh/VtU7YvC9dd3dNZ3MMU+OcfCmIT3GtO5eKZKXGPwFy3ljAL1cz1M
         Oxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EP2hZETBNFMkMXQxpC7bE32Nxy9YmYkXCgVJmKFvnLM=;
        b=kecjKfsaRID1GBrePQ79EUWVx8idZtrloegZ3yCNaH6EB/wWJjT5l9ixseyAwpMMWz
         VIYSWc4vELjcix98CbcWqvCnea+2aT8U5+FfYrExncxMqOjFjNu9wkGch1QOV7MQdev8
         ZQqC2/fTKHvW2s9mcp5G4e3ochML4jWf7G1G2I18VRjHG7u/G2LYspyI7fMtiEL3O+28
         9UXsjs1z03wtE/e63fXt37ktAEo07WiaOj5/SfEQPqdiI5Q3RaPLNZJ4SWkQBF+a5KiC
         wd0EAGmvdzKIPH/LG+s6immQebRXmaNvAHyk1USS8MYYHeqluFb8HDaD0cngdlQPXfRF
         Db1g==
X-Gm-Message-State: APjAAAVFUWRynrFIuDWGcNXQx3c8X8V9g+KojSg116FdWyhQZXQCty3J
        H3ZkeNJ0Hsjh5g6iqO8UmjsPKQ==
X-Google-Smtp-Source: APXvYqzk7RRXy42+5AHoey1bLlIiNbMbLEEHBhC8YtTEpNYdxOqj4tCw4fvjJUUqkhmvCT80B9kphw==
X-Received: by 2002:a37:aa4d:: with SMTP id t74mr57138080qke.144.1560173112586;
        Mon, 10 Jun 2019 06:25:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id l11sm5103526qkk.65.2019.06.10.06.25.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Jun 2019 06:25:12 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1haKIR-0001os-NM; Mon, 10 Jun 2019 10:25:11 -0300
Date:   Mon, 10 Jun 2019 10:25:11 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Dalessandro, Dennis" <dennis.dalessandro@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wan, Kaike" <kaike.wan@intel.com>
Subject: Re: [PATCH for-rc 3/3] IB/hfi1: Correct tid qp rcd to match verbs
 context
Message-ID: <20190610132511.GB18468@ziepe.ca>
References: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
 <20190607122538.158478.62945.stgit@awfm-01.aw.intel.com>
 <20190608081533.GO5261@mtr-leonro.mtl.com>
 <32E1700B9017364D9B60AED9960492BC70DA2848@fmsmsx120.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC70DA2848@fmsmsx120.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 01:03:54PM +0000, Marciniszyn, Mike wrote:
> > > diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c
> > b/drivers/infiniband/hw/hfi1/tid_rdma.c
> > > index 6fb9303..d77276d 100644
> > > +++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
> > > @@ -312,9 +312,8 @@ static struct hfi1_ctxtdata *qp_to_rcd(struct
> > rvt_dev_info *rdi,
> > >  	if (qp->ibqp.qp_num == 0)
> > >  		ctxt = 0;
> > >  	else
> > > -		ctxt = ((qp->ibqp.qp_num >> dd->qos_shift) %
> > > -			(dd->n_krcv_queues - 1)) + 1;
> > > -
> > > +		ctxt = hfi1_get_qp_map(dd,
> > > +				       (u8)(qp->ibqp.qp_num >> dd-
> > >qos_shift));
> > 
> > It is one time use functions, why don't you handle this (u8) casting
> > inside of hfi1_get_qp_map()?
> > 
> 
> I assume the suggestion is to remove the u8 cast at the call site?
> 
> The function return value already is a u8 and there is a cast of the 64 bit CSR read result.

Why do you need an explicit cast at all?

Jason
