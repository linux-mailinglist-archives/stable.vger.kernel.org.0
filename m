Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B3F3A1D2F
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhFISwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhFISwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 14:52:17 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E647C061574;
        Wed,  9 Jun 2021 11:50:10 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id r17so15865404oic.7;
        Wed, 09 Jun 2021 11:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jo3zkaVre167PVOcWcJgjhWeDF1nsY7cQ7aHMY03MHw=;
        b=leHCOPoU4FsUwoXSAuE5exszK+CfJMeOmDUP1/IZEng3URkegtHUh3oyRUBKgKqrY5
         FNTBWarrkjOPXQsqqUa7VFwdnrVLco0o/PEUxEV9VpID//1Fgo6BQcqKRaLYDul/4dmx
         ZGegAv6GPkXXEDg7pVFoVv5IVh9O25HIuBVa20ve3eBFKjPOTqg3g3uDZPV665lt1Ipf
         t4LLEHbIG5jO6dxVSbBv5/ggi9Yx6WKGr5hkln8IAw9g2iGPR6PJCCaRGm8egcbUr3S0
         VKnrh4OYddngbbJRgfWGpC8NlcAJrCM7Kv0wyhREG9Dr/QuaTGo/AbXXnvx3ZzqzNVBo
         ZDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Jo3zkaVre167PVOcWcJgjhWeDF1nsY7cQ7aHMY03MHw=;
        b=eeBwa3ssYhsXqK31ERkC6z3bKLaAP0P4EixC5mEnpsMQVM75NsR+rdU3T8MjNhNufo
         1dC/2tNSi7O5HjV+AMNWAhRyNnemiYciDGGPx1tZU+V92+XPCEX6xQkJmMLSDbJa6Sww
         iTE3zQYZl7ABOZuP7Be8htyDdhbqc00YgjXzr+vRaw3t0+z74Dxh3YwTMGliPXsXs0v8
         zp3dVAzuT2l/Hds6aRtJPXcnIdDjIgY0HSZAxKBfPJPd/fla87AeWkSe4PS0JpmtL7/x
         LnbB1ZccalvbSeVRyIRURoEdytOavoMyz0+tDm6cJYJN8eD2jzqZIPZkh/dd2vfzM8b8
         obvw==
X-Gm-Message-State: AOAM533uLQoYNFogIb+jGO26WK1SQ1JWkpsInaA0uxx0V5Jzq74BE87S
        n/AD5ifwm777dmECqUemmeo=
X-Google-Smtp-Source: ABdhPJxwRGthdc3xAZ9sCa7E97KcZBrMwMck3mPzYbd94ZSqkCATvSBZyBw7GI+E9isCu2GJZ+oevQ==
X-Received: by 2002:a54:4f99:: with SMTP id g25mr7487460oiy.132.1623264609974;
        Wed, 09 Jun 2021 11:50:09 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d20sm159134otq.62.2021.06.09.11.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:50:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 9 Jun 2021 11:50:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/161] 5.12.10-rc1 review
Message-ID: <20210609185008.GG2531680@roeck-us.net>
References: <20210608175945.476074951@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 08:25:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.10 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
