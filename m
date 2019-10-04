Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F631CC61E
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 00:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfJDWzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 18:55:52 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35499 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDWzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 18:55:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id p30so2487181pgl.2;
        Fri, 04 Oct 2019 15:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VARRNUXc9LQzSaAVK1UNlZ8Q8MkB326pw9HgvIqlYEc=;
        b=XSTGaQxatGOa0rgS5/fwDLaxdrW1UP50i7JjVQ9E4bltl+qYI55Uz2x039C7ThvG9W
         ugMrDd6iNia9nFMm6hlCgE03li1KLGskLzvLUI2BuRZfS/HHhiEn5jVGWYNkH2EhQdk+
         7QIeKWtnGJLZYIHNm0WuvSgbcn6bdxfOWvw6ryZvGr/ovjwyaCvhK2Uzcs7RNwt7Fdog
         j3PL6PsHDmJU7v+qeroYbcwyY00D0MZQX+1qeDT6S3w/B3Q72/ysxed7DFDt6vmepow3
         s+Q8MVAMCs98fxeF51+X/Jibx9/GD4HOtKHpqp9AcGo5NttaGAXAOVp9oJ2b1+a0buzT
         +0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=VARRNUXc9LQzSaAVK1UNlZ8Q8MkB326pw9HgvIqlYEc=;
        b=OZWRs25Uw3M15w1k3BtjlqbHp8tlMmioi4+D8fFng1M0imUuUrwgKsriFKCg3BievK
         /MkDwBzpY4kj1jMkmlnvODOLJ3WQWqDJhTVOSdZhw+gbi2dQ4kp+Jn5rBhZVXaEpoceJ
         Ka/NTcGiF9NdeRwCsQjSpUvk1xvK3Xsgdggc0x/0UxlcMt9iMMUKAQ4crCT7ZGTJgNg1
         ZTxW3kH2RMfezAAtC+CN5xI4j09kgmkpwpUHWXPBGx5rSip1gYvUk25N16t+KSFgx4sr
         dq8l3fEh3mqnQveWYjKUcMHvub2pqwhkRgmPbM5zAxP0Cj15JdCDFUgE7FZdwgbRU+E1
         RHWw==
X-Gm-Message-State: APjAAAWlJ937/xVfjuUJd3ul5MgproiMnBj5xlSWjmmieu90TsOFseHI
        l1kvJR1uKo6guENiod1w0NY=
X-Google-Smtp-Source: APXvYqxuK++llOq76jfvYL4JeCUoP7uNtCXKMqhnxl+rTaD7dXyNpTSPWwQJWZj2kuSq8HLa1SgGWA==
X-Received: by 2002:a17:90a:9301:: with SMTP id p1mr19967440pjo.31.1570229751615;
        Fri, 04 Oct 2019 15:55:51 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z5sm6690314pgi.19.2019.10.04.15.55.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Oct 2019 15:55:50 -0700 (PDT)
Date:   Fri, 4 Oct 2019 15:55:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/99] 4.4.195-stable review
Message-ID: <20191004225549.GA14687@roeck-us.net>
References: <20191003154252.297991283@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:52:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.195 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
