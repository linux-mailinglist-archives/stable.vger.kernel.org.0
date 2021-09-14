Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3087640B3F4
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 17:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhINP6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 11:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbhINP6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 11:58:43 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E21C061574;
        Tue, 14 Sep 2021 08:57:25 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so19121902otf.6;
        Tue, 14 Sep 2021 08:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=43YjyL0N/rvV3DFPy6bcZ9KhFg7d9xAEZU5KzfliNpY=;
        b=jP32G8plVBZ5xt3uDrd72FqZwlZt9V9wl5oqaaiySzLYETKqJdFqsFUTlEE00jBGo9
         xTNtyw/DkQtm0xTFDN66D8hE/m1GWTS4kFgH2ikGb5NUHTI7WkPeEt6rAfr/RkuN7rwY
         mudDCVyKOkIyR7AWHepIA5cGxeLHIMfQY1YPO7d4C3gt1nFXkIgAbb7EvNRqZBi5PG/e
         pXA3rRRxHB2GG40evEqc16QpHR4595dVU2MYICWkxyv50jxfa06JzDWGfnccSOwKumZv
         v/GjOCaBrp1N17aa58sgOWU8E3Ln/hDfsoNbNBeJPOznXNoOzCjgbu2wXZoIH99SXx2z
         4gHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=43YjyL0N/rvV3DFPy6bcZ9KhFg7d9xAEZU5KzfliNpY=;
        b=6QKHqsjDrKjJfjd6q7ORV2dGakAozVM4+MBO/tJZ15Hu8dAkDM6PUNBetvNj9Dnuh9
         L8P+MMxtRbrqr8rTi6u2ozWGP9r5nOW0wUd7nM53EXPbnPq369JcM8HhQD66Vh7kfAAJ
         TRdBSEKzq9TfvDVZB+dIBUiMpLS0c5Ke/p0NudX0aDFBMPx2lOpvtRFefExBwXZt+VNp
         OdjIu5rf8KT4RCo7XtvR9nS9//JXqSjAZP8COCfIzUrurcCG+oqGuuLoprBWvWGNtsvK
         8h9nDGIg3bLgt6Yr7M/TMTc5FgVTNCYLkngOVaiBnpouVT9UyWP99Trf4lFfVMF+xb9g
         AvKg==
X-Gm-Message-State: AOAM5325hUNHuW9OQOJXTCz4Oyx+nFWw2mRluxtkg+9lY3B64hma8DsI
        iITEm1bINO3KjcBZBiGLrJU=
X-Google-Smtp-Source: ABdhPJyE4me6T2TY+6mH9YSuCTPvCYbSvE/t5wCiLIwkC+vIwZXoGbqy6MfnBL62q5Car2WzSPPZlw==
X-Received: by 2002:a9d:5a6:: with SMTP id 35mr15353967otd.256.1631635045269;
        Tue, 14 Sep 2021 08:57:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q10sm2805967otn.47.2021.09.14.08.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 08:57:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 14 Sep 2021 08:57:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/300] 5.13.17-rc1 review
Message-ID: <20210914155723.GC4074868@roeck-us.net>
References: <20210913131109.253835823@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 03:11:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.17 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
