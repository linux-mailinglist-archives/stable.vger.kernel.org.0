Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E023A1D15
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhFISu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:50:59 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:46051 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFISu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 14:50:58 -0400
Received: by mail-oi1-f176.google.com with SMTP id w127so26076841oig.12;
        Wed, 09 Jun 2021 11:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BueZDl8UmwBvcB2M29g6BnJ10GKINZ2H0CmaSoCgIo0=;
        b=B8x49XDTxgLpJxDvFgR97U5qogOZnbi6/ABQlijOjPtglbF59gIr0AiCro8UL3+EN/
         skhSuXmaUkrshzkasPxX8YqYoj+whRFQThYjRnqLQPDiOMfoXxBl3+IbJaIdzvb7IJlL
         nJDZh5JyaTzD9Oaaox9pgpPJeN+8NWScM5spI68uux5UAci7iOrfxyvYG7X498TCE2AH
         TRI5+vFWCOmQWcB8+XNdiWDFSQ6Xi3+/329sRnkSbeI3wv4gS4uYPvUFtlVnETjR4YST
         x/Wgdd783TsR6/AGeoZWmn1Gqp2XlTSqOjJ24BAamjA3FoUDIEKL5hTTwlRb+871cxt/
         RRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=BueZDl8UmwBvcB2M29g6BnJ10GKINZ2H0CmaSoCgIo0=;
        b=jXr672wZIMCVXo0sCj+T0fFyqC3r5eIjkli7QTkOSzB/PajGp4nc2wc/ZCQ6oQCisR
         hdw1IP9yHquMDxTNi7nBYwk3dM3CGllfwOF0A4dMurkH1co+W7isDQYAKfVcbddcfBuH
         LQY3gJXgJ60KZRazi+ciW37j5NB9sdE18JshDhtdOWW/Ct2sF8oNHNfHf5dt7VoEoyq8
         GiBU6BrxxNBBE27INswraBkeR3ykPBcrnYrxCLRcriJtYIuRj+q3vM5N84HMhthytIEA
         3zt1zZjtw9DKRclCbzMLgnhhiU30kgzFk0P/4X7mkRZkzu9ZA0PLSHzaL9YZYHNm2cCK
         lo+Q==
X-Gm-Message-State: AOAM533qboM2I4DLqW7Sb4cnq3B17g0n4fomkFXlPfloiBCSjcgUbteO
        J7Yo5Z7NxcxGjL274/v4UpA=
X-Google-Smtp-Source: ABdhPJwIAG5gcu1E2UE4mgJk8jmmXWeLHmaIhfzgNwgjbk0sE5BoaZ8KafKSeU2PVG5LvIEqy8noXA==
X-Received: by 2002:aca:650b:: with SMTP id m11mr662977oim.99.1623264470607;
        Wed, 09 Jun 2021 11:47:50 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t14sm107393ooh.39.2021.06.09.11.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:47:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 9 Jun 2021 11:47:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/29] 4.9.272-rc1 review
Message-ID: <20210609184748.GB2531680@roeck-us.net>
References: <20210608175927.821075974@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 08:26:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.272 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
