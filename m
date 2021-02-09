Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FD131560A
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 19:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhBIScQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 13:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbhBISYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 13:24:45 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B610C0617A7;
        Tue,  9 Feb 2021 10:09:58 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id h6so20415160oie.5;
        Tue, 09 Feb 2021 10:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3/z3GxOXiRLOViUCc5mf/Q2YmJ+mvY1b98stIWw6iV4=;
        b=fGeuQHIW9sovDzLcdYdkp/HxnpCbRRn9myV/JHBemowA+U6VM2Ihxapvt9lfs695lC
         Y8q9NNH4l5I7I9n5vf8oz9chTV82GHaey27XLgsmcRJBYwWCQvQ+yy+XD/CR1KfxLWtk
         Tgj4BcRzAQXEqzgRckhDQ5Q8yKgN2xzaASIDIOdF6PnahS8eGsIeMhsEyxm0c4+1pYNZ
         LRp3Y2QvRVfEiEM5BDhDy1eenQn4IeGB8YU5iXDnspwm3cKdRVifue5WceIXhbWydjTV
         Q/a1GdZsMms4bQDOt4zGRk22vno2bHasTDFs1uIMxAmhpJdyHrqZAhFNL73vz4MfvRKn
         EM5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=3/z3GxOXiRLOViUCc5mf/Q2YmJ+mvY1b98stIWw6iV4=;
        b=pXF51+dgaUoreMx61y/rwnvYccZvBc/1S1zFcIF1bQww/PshxRhKxGHgZ1D+LeAYln
         8TYhUbj2SbBIl6oP32Pzb3aB0qLr/Gl4uKxIEK7OXUHm5G4xv1OruidPYCQUCoyupC9W
         lLKEKGU1GyK3eWAfcfyMKkpiPg79UNdTFpycqyEaTDvxpuUwqIqPjX3WiT0FZKm7gKI8
         y89FgmuFISuVr/9Yw9XF2cv23tHSbUDG8AlRLUiBwc7HPK9aGYIPNHE1wYuZPSqFZaa3
         ji2m7EAmp0Wyg9frtspQj4piwaI0humDv4Ve05dytvnc9AYs99rir7nM9OqPOhh2bFrd
         z1Uw==
X-Gm-Message-State: AOAM5321KXe+nfsHTFOUeBS1ZLWzMNVvAJl9Rm1FHM5Hi8f3PhWppELr
        dM5K7qlO0FL266BbpZkB3zg=
X-Google-Smtp-Source: ABdhPJyqIcPNfXEiDGAtBTJwW2MwJESp7pGpYNoMuIky9jUfbJVIct6vqk7ipqfuVwtCnz0ooTkDvA==
X-Received: by 2002:a54:4482:: with SMTP id v2mr3323396oiv.121.1612894197680;
        Tue, 09 Feb 2021 10:09:57 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w13sm22271otp.51.2021.02.09.10.09.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Feb 2021 10:09:57 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 9 Feb 2021 10:09:55 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/38] 4.4.257-rc1 review
Message-ID: <20210209180955.GA142661@roeck-us.net>
References: <20210208145805.279815326@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 04:00:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.257 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
