Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC6C75EEA
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 08:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfGZGTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 02:19:51 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46674 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfGZGTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 02:19:51 -0400
Received: by mail-io1-f65.google.com with SMTP id i10so102434069iol.13;
        Thu, 25 Jul 2019 23:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eZvGCKap3iwT1mY+8gPdtvKT0nqN9NBBfjvGVy5N5Hg=;
        b=vDyWyFS8OQsVACGHtk57th5hDCLw5TJkJGWNUdcBZlRVaBjRXbjcsxDj0y9R9y4pbJ
         OUfsnfi5iCUuXJ1M4DAHeiD1+DgzCbktfiHDLixY3xCc3RDIgUQHNXXdoMctU/IoYI6S
         JPBdcVUdiQoggRPgz2j7v1j0CLzA4lDd+cQdnOiGEw/QU6/IM0f0sQlzxKqp00EuVcPm
         rxjF7DWoks6U/5MN4BgXiwZx46ziB5H3I0P6yfWAU7IOsTHsnBa1r683hQFN5H7dYjxh
         odmTZiZjGSwFNioIsg7eUgf/BNeSbPXVjQm5xx5ihuoIALDz95Habuu5P29xUGXisF7N
         b3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eZvGCKap3iwT1mY+8gPdtvKT0nqN9NBBfjvGVy5N5Hg=;
        b=Sk7fTHGdt9yaHFR33EEUn0aWYdxNHhtO6k8TZi+bTmiWwN2KIzlLDT6HeC6I1sNF5R
         VOZGbfQAzvGTUuO2dGvRQIok7VnI3EQHPDrY7L4h/GPuXimjn8oe787r24sj9AYWTGBd
         D/w+rEM2KGuLqauXY8L1dCLJWcDgZGW6TFg5pEAWyXu6B9x7uXxQyTjiha5nikb5JgFT
         0aRi2HHZMvvA1Az8GV460tnniNCWoSsgKcb3evvOYLsUlNHPmxlD3cjylZeya8HMTAFe
         ZyxchmIx983LeoToOy/Wj7UvdNfq5UmhYSP3OtOivw1PML0s+uQo2k8igqc87wm52TtR
         L3Cg==
X-Gm-Message-State: APjAAAXYeuP6epQ+2SPmXFd6V6/YIUpuw/DvcCLFYUfcNSqxaYA9ZTUd
        gIFtiR8tZ5FY6tje9htElIc=
X-Google-Smtp-Source: APXvYqxh8+4fV1zcuxBG6oKL4ssWPzKsqMGWwXfSzg66z7BDE4ipgDxgWhmKXTDiN67z8MaUyvYIFA==
X-Received: by 2002:a02:3093:: with SMTP id q141mr96057778jaq.128.1564121990202;
        Thu, 25 Jul 2019 23:19:50 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id f17sm48414057ioc.2.2019.07.25.23.19.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 23:19:49 -0700 (PDT)
Date:   Fri, 26 Jul 2019 00:19:48 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/271] 4.19.61-stable review
Message-ID: <20190726061948.GB4075@JATN>
References: <20190724191655.268628197@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 09:17:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.61 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.61-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted with no regressions on my system.

Cheers,
Kelsey
 
