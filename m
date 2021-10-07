Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202F6424B39
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 02:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbhJGAoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 20:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhJGAoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 20:44:19 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651C8C061746;
        Wed,  6 Oct 2021 17:42:26 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id b5-20020a4ac285000000b0029038344c3dso1391805ooq.8;
        Wed, 06 Oct 2021 17:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xJ0Rv2sc9hnKOcRfFUVv/t21F8ZVStH4Udt4rcWVLEw=;
        b=HZG8kQxwCTcRLe5rxQ679vaVXEvp51JplKvgkFdaEImYd3XUjFaf6eYek52y+uwNKD
         prjsO0YD3Ha4+CsI34DpC0BrHP7PPjpODspVJsEyJJz+hdUXKNaKDG7d6oBYbOVdNUN2
         tip4B+GAiaRbPPR9J5xYbs/RrPP8T0oTBvL1i3mI99mI4WkVjOC4XPVbeduiFmjN+Hrp
         gbB0bHc5si9HLB4R9Co+xgtVerpc4EdNKG8I5LY8yzwkxFM2F9q0k+JzkBcaOZixTnSx
         lN07xp03kn0WuBzuh6lPy5X+P7sC74RpckeLfrDr4GDFZEnScTdnOzuuU8/8iVlr9ptA
         JJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xJ0Rv2sc9hnKOcRfFUVv/t21F8ZVStH4Udt4rcWVLEw=;
        b=Ff3cLcc2iTeQ4Wain3jLHrON2g2z5tBJy36uJV6N1LFZ3F8cEm3L8lr06OgaIdt8jw
         cuIPoWrCUCGeXvw3r3+okSSlpTimQvZoCDgE7N1lFeJ9HMuyTnYXPvj3GSBMBZS2aQdh
         /gPg/IbGdTXNM7IToRZsoYNVfMhBuOmfZnjhfVvo8sTO0rGQM38dJn9wz+MQ10yQZYeA
         o9NWJK8jA58lsETMPznsHOYF6VoharYG0icVKZQLxOCTGJPAXRlEPWvTliEQhwDbv6b9
         j3l14Rdt5smoXShHWIDr4BCM90dPVbPYCXSVQK/4nspyN4WLjCqCLdikKCRVhf7UHMt6
         faiw==
X-Gm-Message-State: AOAM533A1I8aDP2Z3BbpxNGdar3jnKYj8GW/VljfJoCPwQFDzfiKdele
        gaQ+dXMR80YwUww2ObbThbns+Ug8k58=
X-Google-Smtp-Source: ABdhPJxCtRYY5HkctchJmQFyEUaZKIt2EfhRomeiViQjZnRWcx8HHrrZuW9qe1HJYbmD/LXRDDfr1Q==
X-Received: by 2002:a4a:bd8a:: with SMTP id k10mr1100323oop.41.1633567345840;
        Wed, 06 Oct 2021 17:42:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z10sm4549549otq.64.2021.10.06.17.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 17:42:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Oct 2021 17:42:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/75] 4.14.249-rc2 review
Message-ID: <20211007004224.GC650309@roeck-us.net>
References: <20211005083258.454981062@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005083258.454981062@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 10:38:08AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.249 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
