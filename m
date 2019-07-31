Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 778F77B90E
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 07:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfGaFbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 01:31:04 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38819 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfGaFbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 01:31:04 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so13796886ioa.5;
        Tue, 30 Jul 2019 22:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uWJCGab/Pr45O7XBllE2e+A6zxOPgE9Q7WsmyRQ4epE=;
        b=b58hTByi1+qqHy1GWinO6qh4tlv7NUvN1AEMEW+7J9uYWd8HF621/R9BdGpZqvAti1
         k0ibEFUqO9FrMB4hOFYQkdsacOn6WxbAH87f+Au+MTAx3emNAFyTxhqUKKRj51+8VM2P
         omdyrnd5uZ/LwV1wEQkeqms4Nqn8DXbYqGg+niOd2udp6e2hoRK0D2gBUYLEvimLVnkp
         DciuHF2bjHuBpNZcYzP6NZX0S59u9MM0nLC6uBMCt9RkmJ6q/H2qG3q+B+NooE+zZA9Q
         w7tuABKfroo+p2mC0/4IihJQxa31OSvfdXcjlUvcuLs/CH9iFLSXnVDQJ16Evf2Gw2rH
         S41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uWJCGab/Pr45O7XBllE2e+A6zxOPgE9Q7WsmyRQ4epE=;
        b=Vl1Qlqb559MgK97ck33XOtbNVOsc2eYvYqDtpgNOgAGEwHdyA1A1KzoA6q2ACkgsQu
         7tVMizKsifhd0TSJfgaokOYLWa2bOiwEDD0fKy5MLiaKDvGrNbB8M/n4zi0AcgTS3UAK
         dVxcB09oeNf3UTfYHPHKoHJ4inzgcy63tkz/vpCf/SCEddRZq0NTbWrIkM9d0yz7J4GW
         envGEUH5PzmOWWF7zhi2LgI3SXS8pRni9syTBdNJihdzXocTIvmeCnUJQijgN1n3N+Cc
         FDmQ+wuulW+TqriA4MX9hv5wrlRflJhhxf24nJrA3lXvsfnzvsiD8TKm48crByn19/qP
         BQ0A==
X-Gm-Message-State: APjAAAWTJ26V76Wefxo2Bnxy1VERFTKk/1DUOaSrzyPvbvF2GOMbpHJy
        f15/jruYFFLz/mhECMNB4tI=
X-Google-Smtp-Source: APXvYqyfDHAJEuOQHD8Aq0EvHvBQgiJB436RsGGd+VDODvEspfNjFSmI/Q/WTRCosKdTySzIwx3b3g==
X-Received: by 2002:a05:6638:627:: with SMTP id h7mr94205450jar.33.1564551063605;
        Tue, 30 Jul 2019 22:31:03 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id e22sm50991878iob.66.2019.07.30.22.31.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 22:31:02 -0700 (PDT)
Date:   Tue, 30 Jul 2019 23:31:01 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/293] 4.14.135-stable review
Message-ID: <20190731053101.GC4326@JATN>
References: <20190729190820.321094988@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 09:18:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.135 release.
> There are 293 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.135-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted with no regressions on my system.

Cheers,
Kelsey 
