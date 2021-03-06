Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BEE32FBE4
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhCFQ1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbhCFQ1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 11:27:40 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B960C06174A;
        Sat,  6 Mar 2021 08:27:40 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id z12so760846ooh.5;
        Sat, 06 Mar 2021 08:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BkKfHcP7oTWbfRSVHmFJOX/kwbnSR5KYczn3KXXH78E=;
        b=BkwOkyGC6FrzKStxdQ6Tm3wLGoJO267MGBJhXsXGFQ8SSdpB2fYXMCWObdmkj+wRio
         L04paO92/2JBnqIVNOONOEX9jx4bGLtsCXV1b+Y97enuJNXYe/Vxt/f+ocdAS1OESrOQ
         bZzvWbY0lPiVvBwNS3xUOtsTG/mepHhzJIF6tyHf/t7nKtBnuuTIsgulDgULsuEExWHM
         wjgh+8Uh+7AedkZOOgJ3ZPaE/oGHs6niw+L8OH2Z1n2goajSDWh9gjrC19vvYEAGNxrl
         S6XCCjhq03CHQFDgpd9mEqk6iRtzE6ck5C5HJ3rgG5NtFQoGunhjt5tVGZEY4tkl0mLc
         SRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=BkKfHcP7oTWbfRSVHmFJOX/kwbnSR5KYczn3KXXH78E=;
        b=cbnfXBZnBTagUF8ssZphZisgDLxbL9o4EkG015azNqd1TSrW3RboZoQVzue/K1WDfX
         ppGyFg3lJg9xQjCFlGdlWELfmAQZWi0AeBc5d2yIqo54/a/YciMOi+V1Y6dPjAe7N2bx
         CEzEjFnXFVdLGQ5AijUlh0v6jCeEgw+K3+6G40FOZTzPZ8XQHddCTay5cSppcGAivJbL
         w5sAjPcYCOwHCULy2n9adMIzJMPpkKtrXyKOLlPCwb1dKvZ7rjliACccBew5VnjRlSXM
         QVC6unOrJmnrxfYqLdtBx1UEPlvNgfCsRVkEuS9+rQ/AcofuPQ+yQDqgrDrntTga2A33
         4tjw==
X-Gm-Message-State: AOAM533pLGAOdi1RIu7/1vyQjBytbOLD+5JYjGcxWpzP7rLZlVc6roG2
        7CoPSWYeyI0w0GTl0NOvaS4=
X-Google-Smtp-Source: ABdhPJyiO7J4EK8r6sCXPeHx+g49cBz7qDiZp1BAj5mrA3NufJULb0YdW26vCe37s+cmOmwE3pZf8g==
X-Received: by 2002:a4a:9bdc:: with SMTP id b28mr12372712ook.48.1615048060005;
        Sat, 06 Mar 2021 08:27:40 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y83sm1267733oig.15.2021.03.06.08.27.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Mar 2021 08:27:39 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Mar 2021 08:27:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/30] 4.4.260-rc1 review
Message-ID: <20210306162737.GA25820@roeck-us.net>
References: <20210305120849.381261651@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120849.381261651@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:22:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.260 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 329 pass: 329 fail: 0

Guenter
