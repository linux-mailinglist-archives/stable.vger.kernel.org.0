Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BA31C2657
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 16:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgEBO4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 10:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgEBO4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 10:56:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39752C061A0C;
        Sat,  2 May 2020 07:56:03 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id a21so1252646pls.4;
        Sat, 02 May 2020 07:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9bKyIZuYWfBz6/eWBjkSV1VDfn5j9Cr4Tho+Q4ycyFQ=;
        b=u5P7Aweqgqygog5ELQG5Ew1UiJNb7hPl2wKqvXgjY66v5g4dOQdMdLfvKJNy/OgDT1
         h61ETigwqPQzqC/3xWcSA5GpRYr4sV3gn7b8zjgkkPfr7w+2ajnUYcCXF18hNhiMZMwW
         6ofg99kQClMe6UO+6VjFA3W5jJMPUE9DhxbnTc/qTQ4GXvTullt65dPAIkZGzs0cpY56
         +YV46ht77QzGVXRWL52b9K3TxFaKgyAtn0O/ONSqG4kvQ//g6uh9q9tJsfCicpvSneox
         VMzfX0D3Bffw9KQbKqO0n2lKgRCRP0xqZhV/m+uKJrqcHUlAWlKi79HPH3p0/N9CtBRb
         2kow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9bKyIZuYWfBz6/eWBjkSV1VDfn5j9Cr4Tho+Q4ycyFQ=;
        b=C3lBwzJOSgpV2WdsQ+p+njCQOVrKbJOejcaaA7f3ZkFXUNQVMM1BIR4L1s7G5QlJrg
         Vz1uPXJ4FfHVyk7fLAWPLhyee/nqFGjgVco8Z94HtgI6RunuCGZ8FBQDxKvgqbJ5NFvK
         rJc3aAqwn9oZGsM3zu+o3alipKcimuogRTVBVErsPOYiGv/gJ1nmIO3p7UyUqHWqjOq+
         cc3y+aBMz5XigXogw239F/dD1KlKevP6ZAvBt/NTCLVLUiAtZGR0w9WKmVZwRpaXbY4E
         Qk1ikYgZJd4FoT8D9UJkzqrnXSwiMhx+sR9dCBzjNMmgKjY4OafmRAXZ2rmXjdMLyo3g
         vj6g==
X-Gm-Message-State: AGi0PuYXUj76R/Y48YKFzaQrkmSC3gVJGXHKKMZgsnQ2XlR+dneSgEcH
        6wmh/ZWPAK75Fw70Xbcy5DI=
X-Google-Smtp-Source: APiQypKzKnAuihtgv//GzsuhKCU2v3qavCdcPgfcQDcij7m51Gz510FPATDxAhUt7Nm0KA2f63o3Pg==
X-Received: by 2002:a17:902:7003:: with SMTP id y3mr9884378plk.18.1588431362781;
        Sat, 02 May 2020 07:56:02 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b16sm4725780pfp.89.2020.05.02.07.56.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 02 May 2020 07:56:02 -0700 (PDT)
Date:   Sat, 2 May 2020 07:56:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/80] 4.9.221-rc2 review
Message-ID: <20200502145601.GB189389@roeck-us.net>
References: <20200502064242.181724036@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502064242.181724036@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 02, 2020 at 08:47:10AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.221 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 04 May 2020 06:40:34 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 384 pass: 384 fail: 0

Guenter
