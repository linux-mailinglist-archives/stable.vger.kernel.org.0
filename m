Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEC8102DA1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 21:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfKSUf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 15:35:58 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42208 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfKSUf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 15:35:58 -0500
Received: by mail-pf1-f194.google.com with SMTP id s5so12821555pfh.9;
        Tue, 19 Nov 2019 12:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oPjAPLsPRjf6A0pUYHgKz9Izx+1jsv8j1ia+cNbckzY=;
        b=GxLdURp77/QEjnDn3bxypUVykMSkqSK0mHwyqWgpRyCHRAEQVs16XYsCEYYgmwDa+j
         kBY92adErpNe59VASFZd9M4Ll6CApdwPRU3kwW7a1HYZZTgBcadX1QuDKDhvHhAY2XPL
         b4EDioijEt0HKGlKqdbAF8GE5aBx02WGUcmRrjPcaLr5jtAzErGGdjlt4ksM2zxvaCYQ
         ACcVHu4Xn8HEsnRXNQWxKIaSHR3PsjhvJs17cBuMDsH6xGNivy4oIQrGXfvcWI+dLbS3
         xSZ8LR361gftTwThn6O5yCXOeU0jop0rPkGWaDBWGk43uNc8leIzPU1zXE6tx0gySbFk
         IGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=oPjAPLsPRjf6A0pUYHgKz9Izx+1jsv8j1ia+cNbckzY=;
        b=R/i7PYV0CtFFoE/4ewgmtDkGkeQzR+MM0Pkdk/4QGZN6yIHs7JGlGfWwlv599IqlYQ
         xGf0FzglXaLPADoM0Hm+QMFJmDTZGXRFd0PcO95m/1NNxFTTQVxHcjHzoBzFMcljXN/O
         3WR9T42ogAjbUKfsakS9q9b+W+9e0mVmJCuUJazTQn3jqrdBVMK2xBXdTU7EjtESrrUb
         Hkp+0J0BMQUKDY+kcbooCthwmKCL8eOSU0DxgBaC3O2EdX03Uxnb1c4n+AUifRnejNtH
         osrW67gsBIg6MQZ7EBzYTAo6hAXjmgge0uc5xZutjzaI2wvhRrJO8t+ql8/VFo8LecZP
         trFQ==
X-Gm-Message-State: APjAAAXJ1zYYuYz3TQeuwWpG03cKZUu1eEvBZ+67Cl7gO4Abi9bgCYUO
        9jVFzw//sR4YHTtxhUEWxlA=
X-Google-Smtp-Source: APXvYqwZiAUGY+J6ntbZ5KBBfJoI/BoeFx0bZ0Ea/mxGrXyPYBQ9Yk3WbXS/wZG8LFEjZdwXyKGIrQ==
X-Received: by 2002:aa7:9314:: with SMTP id 20mr7817273pfj.231.1574195757622;
        Tue, 19 Nov 2019 12:35:57 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x192sm29462374pfd.96.2019.11.19.12.35.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 12:35:57 -0800 (PST)
Date:   Tue, 19 Nov 2019 12:35:56 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/239] 4.14.155-stable review
Message-ID: <20191119203556.GC14938@roeck-us.net>
References: <20191119051255.850204959@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 06:16:40AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.155 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
