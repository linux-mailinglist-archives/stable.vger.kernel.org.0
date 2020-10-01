Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B25280235
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 17:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732391AbgJAPLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 11:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732104AbgJAPLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 11:11:43 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABBFC0613D0;
        Thu,  1 Oct 2020 08:11:43 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id u126so5886471oif.13;
        Thu, 01 Oct 2020 08:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MBxlVxFqoyXiOhmICxBHE/pyGit/aqf2U8NISaH/8pM=;
        b=ZlxKhec+548O4/soWdhiTWi9ptadvg3adPyCaH5ppzFLD7AuFB0eyXnBjb0FYFed1x
         fblkeoFon6pbPl21KcgbR3LtqYKDnYrVehaeN5pIh2tT4jTkGQNp5Dzw8xuLfqLXsxFS
         gAMkX7Vwg2Umc4AJWVv8g20pMoIfXUDX0XmlwafmqSfbS81NKaU9S35VVXxkahsudzm+
         QcnycxNIWNfSHb/zdz3JlLVveD15rG6onSW8Y2UBjKfs136NEWZa94P5P2Rye30IfC+i
         2yM4QgvoGzl8LFh0HF0bfLVa1BxgXRQIqkJS4yBH/ZkvvGpKlMyIM1ra2svay9yam0J0
         VkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MBxlVxFqoyXiOhmICxBHE/pyGit/aqf2U8NISaH/8pM=;
        b=mRe5P5tenig7GGqyWSz5zjpNTQCjuaErBv99cPi5aDqW0l8kqZBl1G5pk+wDd3GBek
         5tS/nSNCNpDIh6ELGnz2H2EGMOGjmmA/x6pOp3Jk4y+Dt4a6SwDOU7vs0TGFE8rkp+4X
         W6mSWlFsjX8O3j+kXiQSZe1zwwcHLtal+IKd4xDz64EwC/6G8Iw/FgnPkZu9UA7QgB1V
         hUM4KppQhSOb5kdv4Fid8Ha7FXOCOOipDoHCeTtycjTjZr1OtYiqSu/tPbBocggCP8E+
         y9jzVvWaIgqoPqD/l7a8ZQowsW9JtrfM4IMweEBDwsiL+E0ew8rQ4sTq78BHNMAOotsM
         L8TQ==
X-Gm-Message-State: AOAM531zyfCgUfppcw5cGA4nwncWqRCHqZHdWXVunCubBBuOIOwLfM0t
        DHndBZyg5IOLFKvX1XXq+mY=
X-Google-Smtp-Source: ABdhPJyyS51NFFIqhOQxS+Yj27wlPiSbhbhzppqGdn/rRdkxbjwzH5+RhvMs6O35IsHPkVTsNVezOg==
X-Received: by 2002:a05:6808:1da:: with SMTP id x26mr257915oic.161.1601565102877;
        Thu, 01 Oct 2020 08:11:42 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j21sm379416otq.18.2020.10.01.08.11.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Oct 2020 08:11:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 1 Oct 2020 08:11:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/119] 4.9.238-rc2 review
Message-ID: <20201001151141.GB64648@roeck-us.net>
References: <20201001091034.685078175@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001091034.685078175@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 01, 2020 at 11:11:05AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.238 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Oct 2020 09:10:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
