Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C46323BFAC
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 21:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgHDTYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 15:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgHDTYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 15:24:01 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391FAC06174A;
        Tue,  4 Aug 2020 12:24:01 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d1so23782276plr.8;
        Tue, 04 Aug 2020 12:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=loX7po0+FtS+cNumhzMRPAoQwHz44Foe/ybDr9oCk/E=;
        b=iLh9igxhJs2Lm/KY3cIo3CQGZ9Ph/1mAkPUcKGkWeao0H76G6+BaIm+yLVJfyYQbuE
         OtrcxywkigJyjf4YyJsAg1X1+U4lklX6kRuWmnOh0GBoBL6JqcpUeM/5cA6mmaKEVWyV
         Ujisw1QDddY2V2QLMd7bkx5bJQInwTHBysOaiK+vip+G9PAoxtbU5Nux3YesNjlto/1H
         mcBTYDEctvrCqpJ0g0mtEOgRWNPIJX3AjZCKvDIppL55GtB6dD5tSQyMHdIw9P/496qr
         WDpP9Zuy/aCdbguuyev23KuVab1Gu4tX6ppzogGLFIJCY3FMnfRjz/92qrwSGO4LRj8m
         q/Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=loX7po0+FtS+cNumhzMRPAoQwHz44Foe/ybDr9oCk/E=;
        b=h8qWwlO75NYFH6xS0YX/JMlIrAnXOw4MKGqCuJQR6LtTmTqHjfn4XxGmb/7UDy0IhQ
         UXRPw4alKS836o/j+1pNoqJAm6jzYfU3Gq5p+lNpcpZ0F0TaZpt4A5bztvPIDo2Aioa8
         XFpknh4797jEZiiEXUtpKvLVKCPQNxajHwfuyftSuyz15wbwdbEU5OiIKKru5nmDgrY6
         AZcg4wTMDXKv8YKhd5Qw+6x6ohEuzCcDSLSLQWkFN4ta34HCZW8Zdao1rPrus6XTztNl
         XfxQKT2h7AGQhLPYR1cCxCkULM/N9oLFGd2mSanZX7L/L7euoWsFZ3m+CrqzrcIuJl9f
         +Ckg==
X-Gm-Message-State: AOAM5333J9TncupopGv87fARuQEKO6PqkcUgypuS/HnOy1DVEPk+AUr0
        25PnN8v9By+E3A8YYvauEw0TnCfh
X-Google-Smtp-Source: ABdhPJyZA7kmQTagR6wNCWNa7t99dqpe0Z0uRyLO1fdHTi5dlocituwdfxBrUZh2DLzH2zpOhCe9Vw==
X-Received: by 2002:a17:90a:7c04:: with SMTP id v4mr6316041pjf.191.1596569040861;
        Tue, 04 Aug 2020 12:24:00 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m62sm3657634pje.18.2020.08.04.12.23.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Aug 2020 12:23:59 -0700 (PDT)
Date:   Tue, 4 Aug 2020 12:23:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/86] 5.4.56-rc3 review
Message-ID: <20200804192358.GC186129@roeck-us.net>
References: <20200804085225.402560650@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804085225.402560650@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 10:53:41AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.56 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 429 pass: 429 fail: 0

Guenter
