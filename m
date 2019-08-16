Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C97A8FB26
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 08:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfHPGha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 02:37:30 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37437 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfHPGha (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 02:37:30 -0400
Received: by mail-io1-f65.google.com with SMTP id q22so4179700iog.4;
        Thu, 15 Aug 2019 23:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fzC8jfQ1OGMdqSb4g3Fuzgu+v9wMvoR2uJu7TYBY2ns=;
        b=sWf5xXrTM9uvBuvhgXEu9yPeDYWukbNoieD59X8z1TMjFKKdXlvV4PdYc+CIvGifO7
         w/MxZfyc7i9dbMYQ13RKOdJfL28sprkkfqV5uxXfsGugV3Pom/vhZgVAU4Ni62nHgs0x
         u93f9BJYRw1eQIkpyqLuKNSeVbOta1nXYHot5xYoMJEsimgIWB3KTCQ5PX5ydKesYpBx
         XzYPjDH4XfU27rzhSq3NWmifDlT1RWj3vA5P11qXN6wIha41JQ/un6kIFr80HENhhlMO
         hsbghpQVicEmABsCewMCEYTPid+lNBBa5RidOjphmVaJd1UX7uWTbCGeb0aN+xo+tdA1
         Bp8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fzC8jfQ1OGMdqSb4g3Fuzgu+v9wMvoR2uJu7TYBY2ns=;
        b=EnYkj9GrOqT1ySIWFEDapVjOYUJSA6qopEDCX6SG4QXqwTDW21TPF8xhvBDEn3E/OR
         2UlnbDA3jSPpkvlbUsavPT0m+MyIlwl2+Mw49aV23yXMz7j+XxLVp4tqosj1CZpSNCbV
         2DiyUD8caanb2ZAbLa7T9Ye4EMakUQM1vKX7oQ7ybWCbcPYfyNQSqeFvbGnoDWyFO3qd
         HuI9dut0jOeiy+WnFz6n1hlO8VCtKk+6Cqt9pGSme20RlrYJ/CXxlYRFBLGx4RAhnrT2
         cDZZahI2MBbfkghSgUKnA1NB1uWKYFBGYqLSricVEud4W4YrvHAHqbcoAmEvKwB4lsGx
         UqZw==
X-Gm-Message-State: APjAAAU63O7rhoItDIJbjHMWBIF6J1+VEw5WaVpyaJ1iMONTZ6tXFuY3
        VAmmjHk48CzTxuHyF6KlgQM=
X-Google-Smtp-Source: APXvYqx+SNQQI9FtPa/7mvM4ejYIrxXK3IEABCgxLhaFeLDXZs42g068xB9f0WHXypisL6ojhppp0A==
X-Received: by 2002:a02:a405:: with SMTP id c5mr9299468jal.54.1565937449463;
        Thu, 15 Aug 2019 23:37:29 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id b20sm3430349ios.44.2019.08.15.23.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 23:37:28 -0700 (PDT)
Date:   Fri, 16 Aug 2019 00:37:26 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/69] 4.14.139-stable review
Message-ID: <20190816063726.GA3058@JATN>
References: <20190814165744.822314328@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 07:00:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.139 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.139-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Compiled and booted with no dmesg regressions on my system.

Cheers,
Kelsey 
