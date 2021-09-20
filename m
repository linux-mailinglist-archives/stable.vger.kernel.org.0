Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5EE4118CC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbhITQCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:02:47 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:34567 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbhITQCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 12:02:47 -0400
Received: by mail-wr1-f45.google.com with SMTP id t8so24151281wri.1
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 09:01:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9PQ9LM8hiZuxfwUa4neoP0OLzb1PbNmqN+5jTtG66Xk=;
        b=wIupgkB8yepeMMnsYfIgDrI9Cnz7tVO+M6eVGRx5jFeictMHKJMFkHQcv9PI/yr6Lr
         NBkFRljj8bEiAta8Vpz+XZz84F5PxR+66Tt1jWbYbHNMmPdHmAb/C44lc+G0jid94Q3n
         dWxrf48JRZVyhuIZK+FQ501b8JHFYP4Eik7rbfgpWBzi1KiATfkHeqBiFIGmQEdtmNZc
         vhsFuzp7uLqslaF0tnXH+BA1Jo3WaOlq5FTxN9ivP42DEeQrKcE7vSVct0Lm5EchYVfN
         rGghOWZsFcc6Yrz6jJ2Eh2SDVusYRiWcDiRaW2JisOFDqDi6XJFSqNJ9WYJfuFLWrV3M
         8QeA==
X-Gm-Message-State: AOAM531TNxhn7x22ArBM45ptX6tQmuY7qh5pB5xYsVfoCH3tlZ6Y5E3z
        1v6iV6dfmQ1xsc+EpQIwD7Y=
X-Google-Smtp-Source: ABdhPJz9/8332eVVF8H2upWV6JkZda8/QQpasfnqfojFTG+nOOGZQL/Mfp6RujxPTPLa4mdVgXzx9A==
X-Received: by 2002:adf:ea90:: with SMTP id s16mr29594663wrm.235.1632153679165;
        Mon, 20 Sep 2021 09:01:19 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id z2sm15175011wma.45.2021.09.20.09.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 09:01:18 -0700 (PDT)
Date:   Mon, 20 Sep 2021 16:01:17 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Wei Liu <wei.liu@kernel.org>, mikelley@microsoft.com,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/hyperv: remove on-stack cpumask from"
 failed to apply to 5.14-stable tree
Message-ID: <20210920160117.cmiwovtdxlkheyh6@liuwe-devbox-debian-v2>
References: <1632128215208163@kroah.com>
 <20210920154447.gess7eb3qho6s2ax@liuwe-devbox-debian-v2>
 <YUiu3KYIVycHS9CB@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUiu3KYIVycHS9CB@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 05:55:08PM +0200, Greg KH wrote:
> On Mon, Sep 20, 2021 at 03:44:47PM +0000, Wei Liu wrote:
> > Hi Greg,
> > 
> > On Mon, Sep 20, 2021 at 10:56:55AM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.14-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > There is one prerequisite patch for this patch.  I can backport both to
> > all relevant stable branches, but I would like to know how you would
> > like to receive backport patches. Several git bundles to stable@?
> > Several two-patch series to stable@? I can also give you several tags /
> > branches to pull from if you like.
> 
> If they cherry-pick cleanly, just the git ids are all we need.

For 5.14, they do -- I tried doing that on linux-5.14.y.

Please cherry-pick these two patches in the order listed for 5.14:

7ad9bb9d0f35 asm-generic/hyperv: provide cpumask_to_vpset_noself
dfb5c1e12c28 x86/hyperv: remove on-stack cpumask from hv_send_ipi_mask_allbutself

> 
> Otherwise a patch series is great, git bundles are only a last-resort.
> 

I will post some patch series for older stable trees.

Thanks,
Wei.

> thanks,
> 
> greg k-h
