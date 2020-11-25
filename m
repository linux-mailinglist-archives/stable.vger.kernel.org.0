Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E192C4291
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgKYPC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729876AbgKYPC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 10:02:27 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4120BC061A4F
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 07:02:27 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id t5so1793287qtp.2
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 07:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=25kn6N7GAyFuh1GrSD0sVV8oM/l8nQ/U6I2FAAW3FXo=;
        b=UySvLo+p1sgfBRX1Ny3emjTtqNUn6Vm6JQo0FJdNFg8Q3Qqc/yHWFNS49v0RaAf9nC
         pgF2DcYoJXm2mKZiHomLnRhriWpvl7ZPFMxvk6wozMC6qYGweFvSjiFWzMJ34jUFKrnE
         CX9YwKHN+6bfZLI8OjtF7BtMNM9EaJVILtsTMadjJwBap6qcSthzvAdlhvjBQeY/d+MQ
         t9vdPo9gPY3wEGSbvD3QDqLKZIDv4wqoAUUExWtcJ070RbA41WrWrV3I6sl2zaJ56Jxz
         3SaLYgYf77VXkTin4pnk2FEu41w8HWw7ftsBUXF4viUHgTCCUkPy77ncR8fU3CgQhgJH
         V6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=25kn6N7GAyFuh1GrSD0sVV8oM/l8nQ/U6I2FAAW3FXo=;
        b=Hm7R/3nNotiXNVAShPOHuIm/4zFOxS6Yhegn4WNPeVcp1YGplVXyh0svIO82SuJMsT
         6yOYa8aOe0vgy+Keddt8IxyibfrbHQZ/9FGE7jzdJj/7ed2yo/gu+RJ7s/lhDpVwFQ6E
         U4ZUWmVuWIPYOkMYAJREbuzNrfppXOtCBwBiPDb6HkEzB7LdXMuXU/8ApGY8k7MlOKRG
         +xPhN4NMepnO5/8oYh2QvYDd3M1n6X+TzacVBDZdbbxwP+2HVwDsO1CUzSWSALTw2jY4
         kvu0eXQT41x47Y9G3hI4zh76MdboXlvYIoLHVw76gHeGJhMTqJrXHDcnmkdj3MkP9cnZ
         D07g==
X-Gm-Message-State: AOAM5319UhBvmPhQEi09QVINTMw4/Ugy325Ykn+mSReAzKagbKeeOuFn
        RN8LPVbFYfF9jwf7O8IjTQtBzA==
X-Google-Smtp-Source: ABdhPJyQLe/6Gp/wsh3AE7EaQ1ssDs3UPK9nNbT6gidQ/0VvXM0dsTznYdGuPojqMf+BK6JsV58WCg==
X-Received: by 2002:ac8:6943:: with SMTP id n3mr3470171qtr.22.1606316546328;
        Wed, 25 Nov 2020 07:02:26 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id 8sm2207396qkd.131.2020.11.25.07.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 07:02:24 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1khwJM-001HER-8s; Wed, 25 Nov 2020 11:02:24 -0400
Date:   Wed, 25 Nov 2020 11:02:24 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org, linux-mm@kvack.org,
        Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH for-rc v4] IB/hfi1: Ensure correct mm is used at all times
Message-ID: <20201125150224.GO5487@ziepe.ca>
References: <20201123165024.158913.71029.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123165024.158913.71029.stgit@awfm-01.aw.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 11:50:24AM -0500, Dennis Dalessandro wrote:
> @@ -133,8 +121,16 @@ void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler)
>  	unsigned long flags;
>  	struct list_head del_list;
>  
> +	/*
> +	 * do_exit() calls exit_mm() before exit_files() which would call close
> +	 * and end up in here. If there is no mm, then its a kernel thread and
> +	 * we need to let it continue the removal.
> +	 */
> +	if (current->mm && (handler->mn.mm != current->mm))
> +		return;
> +
>  	/* Unregister first so we don't get any more notifications. */
> -	mmu_notifier_unregister(&handler->mn, handler->mm);
> +	mmu_notifier_unregister(&handler->mn, handler->mn.mm);

This logic cannot be right.. The only caller does:

		if (pq->handler)
			hfi1_mmu_rb_unregister(pq->handler);
[..]
		kfree(pq);

So this is leaking the mmu_notifier registration if the user manages
to trigger hfi1_user_sdma_free_queues() from another process.

Since hfi1_user_sdma_free_queues() is called from close() it doesn't
look OK.

When the object that creates the notifier is destroyed the notifier
should be deleted unconditionally.

Only accesses to a VA should be qualified to ensure that a notifier is
registered on current->mm before touching the VA.

Jason
