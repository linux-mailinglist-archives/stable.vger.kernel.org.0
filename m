Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E50C2F5E15
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 10:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbhANJwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 04:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbhANJww (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 04:52:52 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03355C061575
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 01:52:10 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id m4so5056048wrx.9
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 01:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YX6PamiwCgUncE7TriVUPjq1AHS9z14mVYnK1/4JUfM=;
        b=rjffKJ3amb7udCniXgN9WTpQEKEZeccVTvkPDvr50z2Mcgb91E5lwAkppSRW4DMmYI
         zL0MBvOt2geQ+vaA1kGHvLI7BM3KJDysBh81ibCc0z9h1hEkrv1uVyWlESeKylZVNfuQ
         9E1UiUBbxrZHKEx1gx/7vShHGTPvwByfiasMz8TFQUvqxakpeJrs8RkRH8BL4id/j/+6
         UgAvKaq+Mk967nEA7v8nGHUA+bKhr47SZq5sUFwpGJDIxqjJmQN50iFGPEw/sRmiie4G
         iWB6ShXWWoc49EiVRXMg/RPYY1Mwqtv/Cnm7eh0CRpdPAIEXfbOZFiELLS9/eL0Jb095
         bCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YX6PamiwCgUncE7TriVUPjq1AHS9z14mVYnK1/4JUfM=;
        b=l4tB8ltH4+Vi2oWfv9ZOXzVRmEXs5lVMXse7ikwDwAumrXaiJ5LH3KHSvnfaYR0RRt
         UfJYa8qf9JDRMVFuIPSG3JEbT/Jk/U/4EcQKL1mQRz+tm0Fx9iCMEKOY+6iWoQpKvjng
         sEkVnT0q73Q1MFU4Z8ho38ubB0DNSGKtwmGsAX5OlymrLywA4IB7dzeMgRhSMTcKMsdM
         rg8feFhUXFO8f0S2thMiKRxu5B6HIfkOtYQmouY82kjb3+Lcm5ei859MoeevC1AnnxTn
         FybsNQqcC4YtbxuUas5LYY5K1+s9tyraUAhqi9IoDDA9/14fVNUgEryKgsndSBmgWIQm
         qKGw==
X-Gm-Message-State: AOAM532r/nID7PpxlnPOBcNcgm3xVZNDdljDaAmJcvDxvbNQw9HQt7GZ
        go46eMudvuhnSgDaLV5+YcUjQBqSReLthNzs
X-Google-Smtp-Source: ABdhPJze4t0cIH0OuonP0XqjVI/aiELv74oKCuYwkluZ8PHvgQiNRaqfPFriRvpKwBLQKuy0XeqsGw==
X-Received: by 2002:a5d:42d0:: with SMTP id t16mr6990914wrr.230.1610617928247;
        Thu, 14 Jan 2021 01:52:08 -0800 (PST)
Received: from dell ([91.110.221.178])
        by smtp.gmail.com with ESMTPSA id t1sm8820010wro.27.2021.01.14.01.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 01:52:07 -0800 (PST)
Date:   Thu, 14 Jan 2021 09:52:05 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mfd: gateworks-gsc: fix interrupt type
Message-ID: <20210114095205.GJ3975472@dell>
References: <1609189804-10039-1-git-send-email-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1609189804-10039-1-git-send-email-tharvey@gateworks.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020, Tim Harvey wrote:

> The Gateworks System Controller has an active-low interrupt.
> Fix the interrupt request type.
> 
> Fixes: d85234994b2f ("mfd: Add Gateworks System Controller core driver")
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
>  drivers/mfd/gateworks-gsc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
