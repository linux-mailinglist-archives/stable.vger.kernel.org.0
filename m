Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E784151F36
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 18:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgBDRUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 12:20:21 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45247 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgBDRUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 12:20:21 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so9763220pfg.12;
        Tue, 04 Feb 2020 09:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WWY//bDR7dOKRizlHUPP8Hwjuv57kNIhS0C+f93Wvqg=;
        b=ozRCKwaK4mWYTq/wp5fziHTUoS+jxRCLx45+yuNRFahE3viSCqi12C/q6OLOWDmO0R
         3qsFwQjzJ8EuHb/E0v6cIlH/QVXJW9E8gHvd4Z2S1YfrSDdGk95EbZg+nE+BJOEAhqlJ
         7oiQuTxWav63f4mXuOJCw9wsHFVUZvLiCp998akgtZxPYAjbTGBj0PTX7W/x4wxIteiS
         MR6kpSWCW9DNOccHrzHvc6Q5ltKRH1y0KRs0akKOWVpyDWT363PXjXQv0ofrRlPZ0FKv
         OE1d4/x8cQWYvfzuh4fTKa0Xe2auWhX4Bi9Pk778SvGflGSyZTbcp+EM0Xfhi0QYwM/O
         uDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=WWY//bDR7dOKRizlHUPP8Hwjuv57kNIhS0C+f93Wvqg=;
        b=ladltD4biNlEp2eaZEcRF9BkroZee3It4Y/wBqz6BEIARKeSYf18/cWE5grQU732P6
         uEuekkFYk4aumsG9zIMGilTQJH/VWupih9PeJCgwUZEGA4yOlqtnUOjeKVN2sCcLlU9Y
         7wIpyGUHKiCwmLxDvd6DNbr3ApAhe0iy83YZV7CZ9GTN3hUPsCbWRx/WTgetWJs6HmpV
         jG8ptyWP8/JKZ+XZEG3pxjoxb035Dra3dLFTOBlynspD34Jr4e+jXqMjAZJ2KK6Jrhsx
         KrRXH0hhpHG1Eqru7T4fyKfeiZkAcV5OZgNbfkkHBa+hSFQcz9qUjZPtopEVRY5Kg2SZ
         wSFQ==
X-Gm-Message-State: APjAAAUxMmBkyoUFZfdgKz/5FseP8op8ixe3sP5i/GQt5VCjSpBdqWgX
        FWmdOqy3aWCmi6j8OXSqziM=
X-Google-Smtp-Source: APXvYqy7kDXHnY6fAAM2Pr1NcwHZsX5629MLPURRA4+npvFXsQ/BtwJs++O+00Mp9vKXliemIWpO4w==
X-Received: by 2002:aa7:8101:: with SMTP id b1mr32352393pfi.105.1580836820515;
        Tue, 04 Feb 2020 09:20:20 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f8sm4343465pjg.28.2020.02.04.09.20.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Feb 2020 09:20:19 -0800 (PST)
Date:   Tue, 4 Feb 2020 09:20:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/90] 5.4.18-stable review
Message-ID: <20200204172019.GE10163@roeck-us.net>
References: <20200203161917.612554987@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 03, 2020 at 04:19:03PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.18 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 153 fail: 5
Failed builds:
	i386:allyesconfig
	i386:allmodconfig
	riscv:defconfig
	riscv:allnoconfig
	riscv:tinyconfig
Qemu test results:
	total: 392 pass: 375 fail: 17
Failed tests:
	<all riscv>

Errors as already reported.

Guenter
