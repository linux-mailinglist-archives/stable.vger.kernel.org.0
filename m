Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B98B456205
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 19:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbhKRSOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 13:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhKRSO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 13:14:29 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A256C06173E
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 10:11:29 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id r26so16068038oiw.5
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 10:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QHs/o1VF4UePb94AuaZPR0vuN4n+OlR0qQG0zLMkrBE=;
        b=KrjP/wOurQil1rPN0t7fsBM7AwNsR5RW8Bym7DeTgHWEBnUKojUmJ284TLrQDO1kFQ
         msCdDsClg6YA89vmAZwzArHwOkp1oa7YgUu8aEvaqPUYU/VRdfG9y3gQY20+A0Qv2SXG
         qPAqqNmFrhbk0Ano8vprmQOq2ZOPAv3L8QSsI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QHs/o1VF4UePb94AuaZPR0vuN4n+OlR0qQG0zLMkrBE=;
        b=5GJaB4mxW2cB+5oQ190nSimiPvyneJU6lwLQj0Ehbe2Jpi4lImvxSpihR7NUde8P2A
         Z3gUtC38JsNj7t8AacLa6G9vdiLtmF/XGwo88ROZgPZ+PuUKHGGQjl8tegydMURoVM8r
         HAKfYIcBI1ebenCw/pBgLkMI2TGVC8QhwWt+PIU0+pW0aaK/HzmjrrjSLRZdkEQHjB1n
         WXqqLXYCgwXdAvft/jKJBvmARp/4DSIlkPWr/2YN6OMY2vWDHtbN0VBhkh4iCLXyIgId
         lpsx+pkVeJXNw0x0FYUV+CxYvrMGxZlbt2WBY3nhXMzNtU+uWdsv+UcwCtUYOiQ9ZWDp
         qNgQ==
X-Gm-Message-State: AOAM531g1M4qWaQxxbuD/ETTOYjy0orFlDzJzyXNZbmrhY4BRID5nRLj
        MC79CIvE43F1JiAygx8F+UEopg==
X-Google-Smtp-Source: ABdhPJxJBkGwS/uacWur35R4KyjchFaWYRZspFnd5PM0lFXTXhNx10cTG3iHJxptti1uUtsSB0w7/Q==
X-Received: by 2002:a05:6808:1914:: with SMTP id bf20mr9863269oib.7.1637259088592;
        Thu, 18 Nov 2021 10:11:28 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id f12sm94041ote.75.2021.11.18.10.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:11:28 -0800 (PST)
Date:   Thu, 18 Nov 2021 12:11:26 -0600
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/920] 5.15.3-rc4 review
Message-ID: <YZaXTsCYYrKC+/i8@fedora64.linuxtx.org>
References: <20211118081919.507743013@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118081919.507743013@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 09:25:58AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 920 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Nov 2021 08:14:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 

Tested rc4 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
