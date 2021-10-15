Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B67F42FDDC
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 00:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbhJOWJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 18:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243168AbhJOWJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 18:09:57 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91228C061570;
        Fri, 15 Oct 2021 15:07:50 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id e63so14996214oif.8;
        Fri, 15 Oct 2021 15:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xwyxqSAJIfZLrdvZevgmoQx3BrVvft0MSXUPK1Wrd+8=;
        b=k3TcJxpFB6wHOYdwaM/ePi5wjrpxi2lHmY7QCuT9MXpdLEjPtFrjvsTfY0wNxpGdpO
         cEnXJagbkGTIWzk+OcRx2G2JvPPojX9pMWOmW1evrPAR1nQZdgsX4dtTWop+OHmDeZ9B
         v88rBmHzMvmOOA+U2pnlJlOxkXAzbI72YLLv05Mca0deeQ2Riutrz3WKDMU9moJCD3vd
         RIT3ddv3RZ8nGCS6IMSrxk7VGr/ew0FjvUIHsp/8PNEBL5s/YQuwa4Zf67K04WulFGYE
         cc6Ck2Ut8/2xbVWOWmkJRbx1u9I1DxZf15FrfaSRR7SsFZhLGTXNxQ3KcJqXH1S1BBL1
         IFjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xwyxqSAJIfZLrdvZevgmoQx3BrVvft0MSXUPK1Wrd+8=;
        b=M4sUlwcPTAYDDAELcdZw/DzLLI6Q56pyw334swa+ZI0LA4u3oLNRQDTGhIO4Ghfat2
         6l80bPMTzV5gN1R2yChOhp3zx+GGzKS13oyegnQ9srRtU3HuwitxUCV4psxG20OAwPWX
         usr/4QgCA+MpkQreglY+JpvCozeSFyzd31OJyVBHs46CGvhdcmNCNiJ+RsDJ+g/ybZxW
         sxmtvVKLfI5BH7oJrZuh/+F1wAeL+f7tAzMpDPpUdaT6dV3O+yriZc/M0WgM2FW+H3o6
         8UBzLP6/BrNAh4UYZTpHsrY9T4SJuihoWr/UlgNH1+NCDb6jbkA2bg1f/HtwQxL6R9we
         mhyA==
X-Gm-Message-State: AOAM532ilxf352yehaezk60J45BIDYGEVxiyIgY2pX5Q4Rwla4i6PzuT
        451K+X9U0+Xb/ANqo6yi4Io=
X-Google-Smtp-Source: ABdhPJwytitPwFdwIaDFrhwoPBmr9NO8nZv/6g0+HcbrZhp1p/zIWwooMIwWW2+TfQMWNNU1CD/VAg==
X-Received: by 2002:a05:6808:1984:: with SMTP id bj4mr10510297oib.30.1634335670072;
        Fri, 15 Oct 2021 15:07:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j5sm1489592oii.39.2021.10.15.15.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 15:07:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Oct 2021 15:07:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/30] 5.14.13-rc1 review
Message-ID: <20211015220748.GF1480361@roeck-us.net>
References: <20211014145209.520017940@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 14, 2021 at 04:54:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.13 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
