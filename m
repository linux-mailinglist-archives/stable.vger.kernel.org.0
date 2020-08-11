Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AD1241C4C
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 16:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgHKOXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 10:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728614AbgHKOXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 10:23:47 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE73C06174A;
        Tue, 11 Aug 2020 07:23:47 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t6so6799671pgq.1;
        Tue, 11 Aug 2020 07:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FLkI62e01G8i9Z4nEpOLfvBAP2bphCzXzM2KeK75Vi4=;
        b=ABijzsRpFvwPcuVn6QWiZxEFRHYWcFYSxhO5UTvcVRhgypXZa4UbrUpLJG+7jVsXDs
         iqsFKcJhV8QZs7JyLIPA0n3U3uFDX4w/ZWE2TQ509ew0YBjmtdqm2pB5OPlnLOsQDVL8
         5IZZ/Upl3M36XyCGFxnWEH6KB/OMkKXxoHfRzTr9hypCqZaDTuN0CPZvpnFp1rZMcLMF
         0+NeHmUqFp9JDmv3pvdvHt+Ic//0flJNzCZPywURIW6yZsTKkvsKJaY1Np1DybYYHHf7
         bcRaoR5t8qAhZ+duggH/OMue2nyiW946mN4biH9jCvo3Kz/qkRXNZlihcQmOcrQKmLLT
         A9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=FLkI62e01G8i9Z4nEpOLfvBAP2bphCzXzM2KeK75Vi4=;
        b=itR2o8aIka2IKes3o014JM8Lp+uHvQ6Nhe3a51fLqdHj/br3qBpeawcx7cMjVO+QHg
         VddkBVOgtop4u3Pqdnu6EW2JAg0meJltFyT6RCwF6XUjJ597c6uX+XynuKbEo6Er5kvA
         hwklWoHwXp36Y2a1qgLzndugo4TY6wbRxkV2wEDVZb/7sAxbwozAhGdyMD4wgQqfytPZ
         ImoRD9OFa48N9mS+sEGQcgY8N4xoOyldYRKl+Az9xSg45ZNFK0rCoZY+k7RYURSHKx1y
         +DnhzDEfHcVh0cIAuAuELBSxGa0sNQrqLVPGiJTejArtgwLz2ZPIXlLQAt9PptMzLSP+
         BHQA==
X-Gm-Message-State: AOAM532CsZcy9dEYGJZQW6XdPaAQ2ZDd8CtzFponCXvjCh3fdw5LC8Ml
        ayKMUAHypXkVpUMiZoz3rx84c0Eg
X-Google-Smtp-Source: ABdhPJzhGGhjGVTx6QMxNbeeG1+Qt29WYk3Df8XOXoMDjBN2hmH6AbSWydBZvguED3U4xsVHgcPF4w==
X-Received: by 2002:a63:441c:: with SMTP id r28mr1007860pga.84.1597155826581;
        Tue, 11 Aug 2020 07:23:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s8sm2942891pju.54.2020.08.11.07.23.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Aug 2020 07:23:46 -0700 (PDT)
Date:   Tue, 11 Aug 2020 07:23:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 00/79] 5.7.15-rc1 review
Message-ID: <20200811142345.GC195702@roeck-us.net>
References: <20200810151812.114485777@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 05:20:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.15 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
