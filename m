Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A279C42FDCB
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 00:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbhJOWH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 18:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbhJOWH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 18:07:26 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0660C061570;
        Fri, 15 Oct 2021 15:05:19 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id g125so15009716oif.9;
        Fri, 15 Oct 2021 15:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m/qt8itWXFvcvJZC5K5PYKJk57hbuNLxD8AtWl1TC24=;
        b=VuofXawIEVLvP60RwwPcjr2Q0q99kj2u/uAp74AnD/Sgy4nKupxrgD6jTooVmBZdnA
         IS9BbK1qqzq7rIvryyCch1MraHhFKckHb1u9YTcN8kSSwhAMm7J6wOp0LVc/FHPhO2k9
         9QEatPWFwmrbp4JV048PV0GqlxvyoAh6f2JZo3Kav2FV5IV/bikGglOD1JgACd5DUZn5
         vgAKZC923dp+h0dNbf8fFCQUyHTiEKFpk6nWDlp0jTuLFvAKHk1xAg4kXRtdS6EYgp8u
         eyDxwmesTxSuIi8xOAQo/m7RM851pBz0CH3v7Gf+Tl4iFM8nfpRj6qySjThSZybZ7FMi
         JN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=m/qt8itWXFvcvJZC5K5PYKJk57hbuNLxD8AtWl1TC24=;
        b=flTP16thAzyMwi8Z1yjB8r56FWesvm+5c4KZ8S+CdACk6rX3NcSEfejN602sAvXu8u
         QvccqrvHVyr7UCgYNPwH+yN7KRi+Dnp8y2VqMsOsgE9oEKzO6hZkQDgKInv0OKJAhn+9
         TjB2HfS9dJUI+1UuqwOtwzqSnduCm5ZUl26u1ItTJBhJGDcMgjJD3J+kFBXH3tIpxV/F
         NttKQB976CZT9snZjYgaM5i5lkedKmj0R092zalGDH4gj5+cPa5r36yIKQ+fdjZ+/bj+
         /YVEkmPBd8TwAc8lv7A2JIQOgbaVF+IM2G/ohubJygetub2Q/ZX+dexVqVrFd147hrC7
         4hog==
X-Gm-Message-State: AOAM533kjxtht3RCQRBc8TSwJ5Fco8m7dl+wkCxRGdW08N0rbBO3kezX
        gr6fj1CzlZqOWTR63tbCf+I=
X-Google-Smtp-Source: ABdhPJy/1Afr+JoVXYvYVk8kK0WrVMvYyP4jcrdpuuU3pOzNmHtANtWJO47JtCRrypONT3otfIbXqg==
X-Received: by 2002:a05:6808:243:: with SMTP id m3mr10678031oie.14.1634335519087;
        Fri, 15 Oct 2021 15:05:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e2sm1204330ooh.40.2021.10.15.15.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 15:05:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Oct 2021 15:05:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/18] 4.4.289-rc1 review
Message-ID: <20211015220517.GA1480361@roeck-us.net>
References: <20211014145206.330102860@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014145206.330102860@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 14, 2021 at 04:53:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.289 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
