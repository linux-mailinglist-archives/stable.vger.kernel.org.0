Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE133B9749
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 20:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389956AbfITSgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 14:36:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40911 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389097AbfITSgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 14:36:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so4297209pgj.7;
        Fri, 20 Sep 2019 11:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3GXQgaaS2sy1W5W2FLcg/NQNEU0JYHdyJXAPPdzLI4Y=;
        b=USxMSiwpFxpY4Vf5CqRHZ8w4WLouzZeewcNademphQzyr8A1WXvVNCwesEABUumyOA
         iFMG+ELYyc2ZfP0SxOKUwX84v4pls8VgcklQynY3N93UvvrlaH/Oj9oapdHp75eZe+gh
         JV12MIx00gFZJEpsIsg8v8EHdixsnfCGUEtRj10Nmx8VKCLUNIwWNpjXoeLM4EQuW/xH
         +w6LC6F71smfZUq9X7IlIIEU4wuevAwEiCyERRnfYp1SfjeDoadMi0tFsmfcEim7jQFa
         wZ4kwAmDG5doGK9jTpmd85PT5B2l1suxIifzcJpW/mvxTh0+IeejIPWzuQXkPp0HJRtV
         yP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=3GXQgaaS2sy1W5W2FLcg/NQNEU0JYHdyJXAPPdzLI4Y=;
        b=KB3MsHg7GEsg/oVbHT7YsLkNpsWTSBSJ9SMeGD1uz2hUB5nP9jKr8CBMec5JTt38Lw
         LUmTuMNK/NOU3NhylM/XShni0T27zIJSlAJ8gtt4K84Fh6beEOKtShuohkjnhvuqKw6n
         gQPE9L3O9rg0CWgaUl3Yty6clwn97niRDavVFhnzU3VneAc3Hz8a8iolqIkJ3E1oVvrr
         ChrNQ/Rs8Wv0dZ6Q/KkJk+dXamy+zdcXOkHG0rb9OtEI9BekoLBy36uTe+rFT0H6VfrJ
         vsmnzS88s01VwphERQhGcUUQDau6iZGTo9+A9MvfLEgNyl0JK9/vZ1fF6BXER9zLv0av
         D5Kw==
X-Gm-Message-State: APjAAAW8E/UFfFgw0fGflwvdbmbS2hln0uuyQDj1kNOTzNrOLaioof2N
        m8q8NDD8N0hsEX+Yavre/SxqOThP
X-Google-Smtp-Source: APXvYqzr30rEmTGmGhPf6t4we0ciT+x4zAqAomPGop3jZS/WWGCGOM8VUVcpCu02yqHWSHK432rdZg==
X-Received: by 2002:a17:90a:3462:: with SMTP id o89mr6344677pjb.2.1569004606018;
        Fri, 20 Sep 2019 11:36:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o67sm2956545pje.17.2019.09.20.11.36.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Sep 2019 11:36:44 -0700 (PDT)
Date:   Fri, 20 Sep 2019 11:36:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/59] 4.14.146-stable review
Message-ID: <20190920183643.GA22818@roeck-us.net>
References: <20190919214755.852282682@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 12:03:15AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.146 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
