Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744EA6299D
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 21:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbfGHTaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 15:30:02 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46025 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbfGHTaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 15:30:02 -0400
Received: by mail-lf1-f67.google.com with SMTP id u10so11699478lfm.12
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 12:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MPzcEDCZuXPGubjh6Sd8DCFOXlYzZGPKEL93jdAnvFQ=;
        b=hTUyICoZlzohR5KUnkPZd9HNVqrSZLHvHnuHK5hAr4jqjTN/yBLsOlaKsLnXiaDbWm
         nAjK9CaL47BF/QHm2LthJhnhu5hp5fXH+mLLyAopaB7Neol5MKw1HhcYpRSyZYSC+1ok
         k3Pe6vOIfk5iWhCRGPS9x5k34uSCrr1w2woNw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MPzcEDCZuXPGubjh6Sd8DCFOXlYzZGPKEL93jdAnvFQ=;
        b=bBzvgYuDEYF4kee0E2WGzzQAfdbpHYifddszr5paMFFRVg3+3ExnYT7QStT6rQd4U6
         Ie6C2GgVZsxeUHIzcrPHghYuBIGwMGaJk+rv8MPBn0k+hryFUfbRj+H7ds0QHulJXCyU
         1McP0XT0+r1OkbzzutJM6acSsabFbakjqSj5fuhvlzoPM/9zW/lNIRvKRoO2/vXIgij3
         AwQoXEajs6pJ8YdE5QtYeSWdEBB4gUAUhOwdPErR0JNcQmaAGvbom0QdcZK2f3nrgMrp
         fElaQPaIzwYt/LJN6YwVcAX0wf4N7gbPcZfLMiBaG4ZFWqWEerZZ35soxzrZmpX7ieLT
         pLzg==
X-Gm-Message-State: APjAAAWuTcfrltyS850CS+p/c2ee5a5xNBQDLh1wDIywmM8KWP7ZdwD5
        KCXS0e9y19J6uZ5yafCNrcnZxw==
X-Google-Smtp-Source: APXvYqw3oox6wJoy0L2nP7j3fKkgl7VOj9pwJZlbYw68swnfF/Hrw82WFeIy4bb1OCfK3m2qQuJ5Zw==
X-Received: by 2002:ac2:51ab:: with SMTP id f11mr7543144lfk.55.1562614199914;
        Mon, 08 Jul 2019 12:29:59 -0700 (PDT)
Received: from luke-XPS-13 (77-255-206-190.adsl.inetia.pl. [77.255.206.190])
        by smtp.gmail.com with ESMTPSA id x67sm3821622ljb.13.2019.07.08.12.29.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 12:29:59 -0700 (PDT)
Date:   Mon, 8 Jul 2019 12:29:56 -0700
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
Message-ID: <20190708192956.GB4652@luke-XPS-13>
References: <20190708150526.234572443@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 05:12:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.17 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
Hi Greg, 

Compiled and Booted on my x86_64 system. 

Thanks, 
- Luke 
