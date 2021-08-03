Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C32A3DF531
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 21:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239504AbhHCTOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 15:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbhHCTOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 15:14:39 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1699BC061799;
        Tue,  3 Aug 2021 12:14:27 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 21so29367915oin.8;
        Tue, 03 Aug 2021 12:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WsOIlck4WDEeui/ypVh4fsNG+79VnbCX//ORMHcCEvo=;
        b=Vw+xN6G9wHEYq6uSEyNhjieZn6k75WMcBjEEEU5vCQicRx3/EPM2HUmHdbYiltxGCb
         9zWldcH6Vk7N8m1jBIhKmvmE+DX266jIhFFeM9vMRZCwnrVP5/iDf86mVOtIKuZhmmaV
         ffSdLJoa4JIj2tJCwD65sqDrQ1mTnGzT3OxaPR5lW+DlVmRvBxLKkHGNloqaNYQ+Kr7K
         NmolgvuqbSUOmUcfZiv+/K/hxwrag7rAC2AzqaeccWOLAgLf2bfeQRRpmIzc7FFMuBxj
         zjiw8stUQ9n0OAGGjUzxYqP0UtGfwxraqELEZtg5wn+rF2kI26GyqnPm9gsR/kDFeVqN
         dk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=WsOIlck4WDEeui/ypVh4fsNG+79VnbCX//ORMHcCEvo=;
        b=ZN+lTpevEutzSzzr622+IekVZwEJzmhgv3Oo3AePR06l6OezQJTNzUDxoRErzME3LA
         eIqGvGKaCSGUafa370H6HwjucgrqpnEo5i+dTzfj9h49j61H4xew/4X/yUGVK5e4OPJ6
         zxjQItF5QrSHNHGTmmFFSZURIIsinWazsIXht4/63NW64iGwYJ4IpMid74hPaumXFpt3
         bub8CFykljA80WV+C4fCG4LOSlymE0Tl7CEkEuq0pf7NkhvNnxdtKZX/chse/3z2Ggyg
         O9e2xFSqIZrCVGhVNBaKva35ZWx6gF3usTZ9R6XDLZDjx0HAMyfkY+ucxQurTPbIJaFD
         ZFzg==
X-Gm-Message-State: AOAM5306856LNxDPRmPetPFDw2bDBvEcaE46bYj8DrMHzcKrQzZAbs9n
        hNwMS7S6M2iahgq/1cNI/4WqlxERmXQ=
X-Google-Smtp-Source: ABdhPJwEzw3tIZ2oEmlBP0VPX9XpyJKMGTZQ1LytlnNoLyukGc8hBcxSrkjFmHQowy3+4+1k5WUQOw==
X-Received: by 2002:aca:afc1:: with SMTP id y184mr2315280oie.14.1628018066407;
        Tue, 03 Aug 2021 12:14:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g16sm2391612oos.31.2021.08.03.12.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 12:14:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 3 Aug 2021 12:14:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/26] 4.4.278-rc1 review
Message-ID: <20210803191423.GA3053441@roeck-us.net>
References: <20210802134332.033552261@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134332.033552261@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 03:44:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.278 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 336 pass: 336 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
