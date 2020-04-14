Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06791A74FA
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 09:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406774AbgDNHll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 03:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406775AbgDNHll (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 03:41:41 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F54FC0A3BDC
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 00:41:39 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id v8so11800068wma.0
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 00:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4UC/ij9V9HTGbymoL1Qr6xP5GpVTRxV9hoB6uH5KWaA=;
        b=VpDz6CL4MIsNSMM4weddDjKBvZF5Aw943yijXiAUMkzMYu9QB8EktEbM/ty47yEzsX
         hofdgfCIId20e6no7s+QDvranEGBGsuLf1SYyaH8UVQg8jDz/T0gW5F0QDIVddAsx1PG
         8EMjTX0EfreFJPBFA3ZQryxB7FR44Z/Uix/EW6hKQ8Vjpa/Ecphx4n+zVRbkbcvev0Wp
         VEi4En1h/X8yKHT7BtM5iuBL4M23AigyBn6GnfgK9kbz9Wb2+LNywg3mpsHjAHNtzDMp
         ulgxfuHJw6IMr8PQCCfPbRoTaPDBs6mxs1o13EwCN5tDhZHjUB3PMSLry3OWrjurZ1+p
         UXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4UC/ij9V9HTGbymoL1Qr6xP5GpVTRxV9hoB6uH5KWaA=;
        b=dn6A7xi4urqT2th92WvUwRDEz0saV97A8CdGN5CB9PIf4Lg2ysoU4ycIHpZh1ZgC0y
         Q6jjipypHLeUoOVnhN+Esbn0M26O3wgoHDupk3DX5p+iD1zs/DgNV64Dq0sncjQvq9ye
         hb/KeTgsfsnUEoQjTMuZElBHE9juqmFE/Kfj2RvYlbPMh1LhXOOMI7ef+bYIyFpldSZL
         o2YLhRKTk0rn/duyHC6ELtESyDfN9oArzf9SrXDD57CZaNxR3hwKYJnsS83iII5gEjHv
         BlGOgEMinhCXvw47aW5YOCcplpz+aIe90RATKwAm1Z7ttUfVImVp7KoXva9/ja6J+ssB
         4b8Q==
X-Gm-Message-State: AGi0PuZfYxS1ZJTh5Zfj/1j+KSpOVIJIIwgVk1FBhIxej6a0bOwfQVBB
        TrRaPRmcwZP6JR0LSjitqoEgBQ==
X-Google-Smtp-Source: APiQypKNcNNAQG7XG13twZ59E+h+CYa0cuFz1zl59biALZRFNcvbFb57eJViiE+a1zq9UB0Z+g2snQ==
X-Received: by 2002:a1c:3b09:: with SMTP id i9mr21669290wma.19.1586850098027;
        Tue, 14 Apr 2020 00:41:38 -0700 (PDT)
Received: from dell ([95.149.164.124])
        by smtp.gmail.com with ESMTPSA id n4sm17271807wmi.20.2020.04.14.00.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 00:41:37 -0700 (PDT)
Date:   Tue, 14 Apr 2020 08:42:38 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org,
        Karthick Gopalasubramanian <kargop@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 4.19 10/13] wil6210: remove reset file from debugfs
Message-ID: <20200414074238.GB2167633@dell>
References: <20200403121859.901838-1-lee.jones@linaro.org>
 <20200403121859.901838-11-lee.jones@linaro.org>
 <20200411114753.GF2606747@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200411114753.GF2606747@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 11 Apr 2020, Greg KH wrote:

> On Fri, Apr 03, 2020 at 01:18:56PM +0100, Lee Jones wrote:
> > From: Karthick Gopalasubramanian <kargop@codeaurora.org>
> > 
> > [ Upstream commit 32dcfe8316cdbd885542967c0c85f5b9de78874b ]
> > 
> > Reset file is not used and may cause race conditions
> > with operational driver if used.
> > 
> > Signed-off-by: Karthick Gopalasubramanian <kargop@codeaurora.org>
> > Signed-off-by: Maya Erez <merez@codeaurora.org>
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/net/wireless/ath/wil6210/debugfs.c | 27 ----------------------
> >  1 file changed, 27 deletions(-)
> 
> Why is this a patch for stable kernels?  debugfs is only for root, and
> can do much worst things than this, which is why it shouldn't be
> mounted/enabled on "real" systems.

This wasn't backported due to security issues.

It was backported since:

  "[The] Reset file ... may cause race conditions"

Final call is yours, as always.  Please do as you see fit.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
