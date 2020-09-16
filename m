Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C9626C144
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 11:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgIPJ7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 05:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgIPJ7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 05:59:30 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC66C06174A
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 02:59:30 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j2so6222903wrx.7
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 02:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3+5MUINgS/3kXupUIpF5UdrtH6x938/qY5ueTCYuS7A=;
        b=b5lDIFgqmTLviC3gjjGxPQgnNyy7XbQrAKuUwxP7Ku2nwztn3YYPq4PyP1978qIyYk
         aZ9aF1s/XUmkYigIJofHDOR5G0Pm5UgjznZZPJvg+Q74Bp4CxPB+YI2qHnfTpJ0AAkYL
         cl6HbP8W6pCUhLbAVWlNOwhI6qy54eZgYNgc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3+5MUINgS/3kXupUIpF5UdrtH6x938/qY5ueTCYuS7A=;
        b=GQ9JZVw0SLdId5rxlYzO6+7iBUvraeURRffcoTmY2rwgk/Rr9fEFQoDPHQmpOCqd+d
         r6iCSxsWEvie5Pmx+qhnTdP1uZy/dVxDXsn2Kko7LA+Pc3A+yQ3jk4khatU0sO/laYhB
         7gDpVFMLS7zX/DJfTS6a9YUJnycIgiCZVskAk2S0cSv7Z1WMekE83Onjc4crOqEBzzW0
         4RgCDakLFMkCOLLRddKuAPfquruKXjjk44/7iDffOBBKKhT6kzAzQkXkyAcZf0YSRElp
         MiPImE+ImsSpk+rxewcABgVXcTECH5E/8cPXP9Tm0n49ZsJcWK8oQWLr8qW+K2TDe7sT
         Ky/Q==
X-Gm-Message-State: AOAM530d6+nyeZRIXMQL8OoYTB8wGmiqMUamNsNM3P4Dz5T4YsRDy3P8
        9NEao9IndPtQxOQFxHi9Jbn85A==
X-Google-Smtp-Source: ABdhPJx4rSat5jYIT6/IV5uxY2B7ojnvbYPfcJNaB1zF5LC7sG7GGRH9n5yFXUAfnCZDnFw96E4KSQ==
X-Received: by 2002:a5d:608f:: with SMTP id w15mr2952652wrt.244.1600250369082;
        Wed, 16 Sep 2020 02:59:29 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id o16sm30112339wrp.52.2020.09.16.02.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 02:59:28 -0700 (PDT)
Date:   Wed, 16 Sep 2020 11:59:26 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alex Deucher <alexdeucher@gmail.com>,
        amd-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        christian.koenig@amd.com
Subject: Re: [PATCH] Revert "drm/radeon: handle PCIe root ports with
 addressing limitations"
Message-ID: <20200916095926.GE438822@phenom.ffwll.local>
References: <20200915184607.84435-1-alexander.deucher@amd.com>
 <20200916063300.GJ142621@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916063300.GJ142621@kroah.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 08:33:00AM +0200, Greg KH wrote:
> On Tue, Sep 15, 2020 at 02:46:07PM -0400, Alex Deucher wrote:
> > This change breaks tons of systems.
> 
> Very vague :(
> 
> This commit has also been merged for over a year, why the sudden
> problem now?

Unrelated rant, but one year is generally what it takes for most users to
upgrade to new kernels, through their distro updates. Especially for older
hw like the radeon drivers (since 5 years or so amd gpus switched over to
amdgpu.ko).

So surprise that bugs only show up after 1+ year shouldn't be a surprise
:-) My personal rule is that I put a 1 year spacer between a risky change
and any cleanup that enables. Too many regrets in the past.

Cheers, Daniel

> 
> > This reverts commit 33b3ad3788aba846fc8b9a065fe2685a0b64f713.
> 
> You mean "33b3ad3788ab ("drm/radeon: handle PCIe root ports with
> addressing limitations")"?
> 
> That's the proper way to reference commits in changelogs please.  It's
> even documented that way...
> 
> > 
> > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=206973
> > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=206697
> > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=207763
> > Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1140
> > Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1287
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Cc: stable@vger.kernel.org
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: christian.koenig@amd.com
> 
> Fixes: 33b3ad3788ab ("drm/radeon: handle PCIe root ports with addressing limitations")
> 
> as well?
> 
> thanks,
> 
> greg k-h
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
