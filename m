Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2014118E3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhITQKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:10:49 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:34604 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbhITQKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 12:10:49 -0400
Received: by mail-wr1-f52.google.com with SMTP id t8so24225113wri.1
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 09:09:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HgT9+sTSSgtKFFtYs7z//eajZPnTNakXhg+ysg7XGi0=;
        b=Bn6O8tDwwsZ6U1JyOOXMfrk6uXLCXhaM2JK4rQQwxLb8qG7GjKUT6r/pYHvr1coyl5
         oGMpbJE5zrwRgZEPj1nrUaodyC9UV7AAy/RJZfBfSyLjEsj8eir7zdmxUXWulexWugPJ
         5wJXMWExYYiEStzxKiVPh1Sh2jFK07NL9B1w4As8QBiM9ZdEpY1gV1DVUaoq3e345WOz
         e2B1tqgzuydE4Wnn3ghiC7vp7lZbJQxDTRnm/YAJLIkmlDBOm4hhlOJyWAg6KEq8N6Il
         5eFT1zBSumpS7dNVEpMeQ2mmbA6cTbExmL/kdxRE5k4qUMab5ofHkp/XEirs0MSYzMPZ
         KkMw==
X-Gm-Message-State: AOAM530bfXBmqn7lnqMPoNAzaiZ/99Bdwm30a1+ju4pH1RrGpRxFjeLZ
        fP6/vwRB9L4I2FllebI4CByX/6IGYGA=
X-Google-Smtp-Source: ABdhPJyAc0ELzIqA7hKTY8RSlXddltTOOkh3ya2o3/Ja33f1bgIu4JoOjlaPmQo1+2jEdIz136XKxw==
X-Received: by 2002:a05:600c:3b1b:: with SMTP id m27mr6645384wms.15.1632154161142;
        Mon, 20 Sep 2021 09:09:21 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id n17sm16521329wrp.17.2021.09.20.09.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 09:09:20 -0700 (PDT)
Date:   Mon, 20 Sep 2021 16:09:19 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Wei Liu <wei.liu@kernel.org>, mikelley@microsoft.com,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/hyperv: remove on-stack cpumask from"
 failed to apply to 5.14-stable tree
Message-ID: <20210920160919.f24xvwd66t4reqow@liuwe-devbox-debian-v2>
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
> 
> Otherwise a patch series is great, git bundles are only a last-resort.

Actually we don't think the problem these patches tries to solve will
cause issues in practice, so backporting shouldn't be needed at this
point. Please drop this patch from the your queues.

Thanks,
Wei.

> 
> thanks,
> 
> greg k-h
