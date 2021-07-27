Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91713D7D02
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhG0SCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhG0SCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:02:09 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28148C061757;
        Tue, 27 Jul 2021 11:02:09 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id k7so13180743qki.11;
        Tue, 27 Jul 2021 11:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=liGCrLVWcgFbeb/2PefcqCQBk6MuKS833W+URDB6HTA=;
        b=EcjjLPLHUgwNveaTkpZudm9XPOUplUwV3NW8uPDSH02GZiCOHFIoQBrNoBzD2XyHEU
         VMmYKtFIX3sB++GqNhCHjlzpkby7FTITNnlU0zYsEtChDELQWm4T4jLslHhRPn9lqbss
         4aGI2kPwPjTh+o475hurhvPyQzeQrVf5xc6LqexRa0zB/kUQGqV+ZCi+g7wVHXKre+2/
         3B3SNTODXl/82vfUKA+IY6vvig/cZzjHc9MirCIfbcRnhdlf/LzSOHa9UH22ajRBYOcz
         Ut6KxIVqJ1FMRQf50KkaH/wy+ExLb1PGiTSIFo9WiZhFrz5pc02UevTItAuGAtAAOlKn
         7tww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=liGCrLVWcgFbeb/2PefcqCQBk6MuKS833W+URDB6HTA=;
        b=jAJ1ARNbDChoZMzHMy9UVR9+3kjSEfkMKQ8SUFRdJzsbGo0X7/ME1V478vkfxeJKqs
         MsNSAe8yOhUgpEjAmsjnTW5QKlb8jmqpLb1/bVIGFf/LXRYrN66otbE5xvop/O/FPDyB
         xqspEfNyAJSMKhphQaMSmNmpgu345IN+8wext84XbQ2fEyWK/u61tTDElHbTk3AvZyZu
         3BIizPSaavo4xu11EfVEjIDNKZt9fJAPjRWH+48qBbpLtjdYKyV8xea/AGG4RQuHPWXT
         Ualy6p5v6G4FI+3YpMzVr6KXob+FJHIckknFKJHYrI/sxbiWIrM5w4XDXN7O/xi96Gob
         KsuA==
X-Gm-Message-State: AOAM5309SPSqdnhNh0qdAfl2gyphg7ME3w7G3XrNIL+zygu6aBNzUHD5
        jKYzwM8hwSjDhXuJFmdEi9s=
X-Google-Smtp-Source: ABdhPJwfuTvC1Oa1Znl5VfxEvrje+zKSyHaXW3bdvaNaieCAhByBYWUZ8wmPruzy7xbK6tWXDs1SVA==
X-Received: by 2002:a05:620a:a19:: with SMTP id i25mr23186134qka.426.1627408928418;
        Tue, 27 Jul 2021 11:02:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a5sm2036982qkf.88.2021.07.27.11.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:02:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Jul 2021 11:02:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/108] 5.4.136-rc1 review
Message-ID: <20210727180206.GE1721083@roeck-us.net>
References: <20210726153831.696295003@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 05:38:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.136 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 436 pass: 436 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
