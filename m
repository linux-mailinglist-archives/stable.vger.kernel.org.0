Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A32322169
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhBVVaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbhBVVaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 16:30:00 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096D4C061574;
        Mon, 22 Feb 2021 13:29:20 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id f3so15503442oiw.13;
        Mon, 22 Feb 2021 13:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yr8JtmlxQn5IyIWg+PvWHOpiJ13b5yvj2aGeupCluZY=;
        b=rMl+5BVPLapZe8idUKXB7hk2cR0bpNh4gaREiaMBqj9F1/Q6cFTB1sO9FFvQY3BPkF
         JK+t1msmwf85mnrekjtOoNzBB2AmBtjZl7EsmIrggiJ+ijhcxaJNAilAapRhCMqZiaKM
         L6oXo83OKJixRyKt/v5/HJ4FeGryO7e87BAv59ur+GhsFtXSj6WvZ39BJEd1I3/Nh5Tu
         Ov4gqoikuSIBRDAUKbvI9fQscHlWKLom4SC4bkYbzOWLi6LejhqOBkbAnSbBUUFI1UZO
         yoMB6i8sUFYdSj1z4AbokXPVRc5zkUGSFw2SFvVkMUQtO74SrprIPOkYp/mPF9Scgos2
         5fWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yr8JtmlxQn5IyIWg+PvWHOpiJ13b5yvj2aGeupCluZY=;
        b=FEIr89jMa4m0M6Kkat8JkQEftJEpGmSOATKN0V59WUcn0aigNcQcwjGcMyxip+R4YY
         xLgC/V3rJ8CXGY6VBsrc7O8EonIDaZV45zQvDTq2+ybKVTGKfLrLKM9GLe7GU1XU8/jr
         17U6PZ2Ce4SjPUSCDLvc8yPmPx/E1E2fZU/NRGEjvwLTfxgoK5lnXjrk2Qair+mHlDxQ
         iVquHYVFBghnkxBKkueaMnOG/SFgQrYLWwiRbaNynt5WrZKpMH+pzS+XWUMWeCU5OceG
         Pr97hWjw4X7JIihMhSwrwxlN7+yNDrTrgNyedwXyoBMh/SXdycXHIj7Zwn7Cj03ap3We
         w15w==
X-Gm-Message-State: AOAM533JH+nYbAQw3n5vzFOeFL8AoV88aYStEROSvit9Ch5o6R9ckepY
        ut6MDaPemPRl2akt8ePKHV8=
X-Google-Smtp-Source: ABdhPJyDqMQo6nPBt0DSFfvPXflesHlXaGk4yIxRQNoMnBfowb6pYe87b+aAe1Aqel0A5nqcGnOrgg==
X-Received: by 2002:a54:468f:: with SMTP id k15mr16949214oic.58.1614029359516;
        Mon, 22 Feb 2021 13:29:19 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e19sm3919845otp.31.2021.02.22.13.29.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Feb 2021 13:29:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Feb 2021 13:29:17 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/12] 5.11.1-rc1 review
Message-ID: <20210222212917.GG98612@roeck-us.net>
References: <20210222121013.586597942@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121013.586597942@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:12:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 435 pass: 435 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
