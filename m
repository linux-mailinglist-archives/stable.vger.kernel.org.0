Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9011320136C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391893AbgFSQBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392782AbgFSQBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 12:01:20 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E85EC06174E;
        Fri, 19 Jun 2020 09:01:20 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k1so4091787pls.2;
        Fri, 19 Jun 2020 09:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Al8lo1vohaR538nK8K73F1PSw58YXyOEBF1pYFlniR4=;
        b=fftsKWXLIqPq+IZfmJ93m4f0LUAQDvvJhlKujnhkDr71z51FLg5MA4vyH6aR2nkajs
         OCpQxv8QDtvbFFJ69EDvy/UCT02TiSPrV7QYfCyPkWP8wdtJ/QznPUiBNdJDB5CHk3GO
         JwlMFYzjYYCN09eYFHJ6DNnnNv8sDQ/Dzwlmwwdd6VG+TTJjq8+655E8udUvXwu7vyF2
         JV9V+0qhvIVw6w1qr1Msb9pzGBScyBEohHpGQw8lL2iWvReCKlodZJfHi57P33Y5uOou
         FYYgHJAOjd2waOkh+owR396bXsWGI+I5Nw2MLXreSNgXG5ZdvB2pGmIiUSw3LenMkXP3
         DC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Al8lo1vohaR538nK8K73F1PSw58YXyOEBF1pYFlniR4=;
        b=q7TR9sEnRI/hPSO2BYy2zacyN3pQJFxR0/YQ5v8cP/fTj2TsIUlbEj7QCSnSpoX6rB
         7zxol7JwLxKj09J/y5efFky6kpAjS12WcBuveIb55VHOLAiTTN/eQLJUaPVfHLCEJht7
         mq/t+KeZr90MQpkBPS5Y5aXwQcKh/J6fs5uAuo1ymOL9yd0t/vsa0+EReCqJ9F6CgJdm
         JyBYSuAIsFnzJLWNyn7g3qqnUhofPC6yJpBOt3oY9yzgxkCSNvMqBwkJnKlcYmxpTje0
         GfYkpe5OCDXpMGfvU0RBkfJ1/jv/NNIcbcRreaBdkeAY5i2elSydj6j1VoBCTXn0Utlu
         2UMw==
X-Gm-Message-State: AOAM531Zs1KsVPWL7q0deJYQt4unX4rMmhc6hXEl+n2JPOJAC+lgEsEo
        IkJN4wPfvqYB7POPTUjCKQQ=
X-Google-Smtp-Source: ABdhPJz9UVcZvtW383mrRKD0cV4j8Kv0RZmN5hMHiAJxZiNhHfbQ1q+ptp4COAn+YGx5pjx3ina7IQ==
X-Received: by 2002:a17:90a:1ae6:: with SMTP id p93mr4065056pjp.182.1592582479643;
        Fri, 19 Jun 2020 09:01:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g21sm6204847pfh.134.2020.06.19.09.01.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2020 09:01:19 -0700 (PDT)
Date:   Fri, 19 Jun 2020 09:01:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/261] 5.4.48-rc1 review
Message-ID: <20200619160118.GA105163@roeck-us.net>
References: <20200619141649.878808811@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 04:30:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.48 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 

Building mips:defconfig ... failed
--------------
Error log:
arch/mips/mm/dma-noncoherent.c: In function 'cpu_needs_post_dma_flush':
arch/mips/mm/dma-noncoherent.c:36:7: error: 'CPU_LOONGSON2EF' undeclared

Also affects v4.19.y.queue, and causes almost all mips builds to fail.

Guenter
