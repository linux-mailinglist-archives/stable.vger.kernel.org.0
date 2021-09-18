Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27B3410355
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 06:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhIRETS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 00:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhIRETS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Sep 2021 00:19:18 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229D7C061574;
        Fri, 17 Sep 2021 21:17:55 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q68so11510262pga.9;
        Fri, 17 Sep 2021 21:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xwwJvPhqHZHRLMb9IQ4eamYZKhBF46wUJmae35NjNpQ=;
        b=OlDgdue4eArXLYvPGJjBWb3zhWtipI4FoVNcOENquDGAWw5vY501t/5GiEBGFhMESL
         CAARpRKLMme1PEDKNgBaC1BI5iDC7B11zJDVun76b757DqlmFJrYiHfbDJHCcXlvLzjG
         HAgrzBmtjoiBlfL7ZzKRsdJiP93Y+svjbYpwPszK9tpbluJ6cjRx/OhfXIsdTVLj5srJ
         3aefvj8clwYg0upSaRjNpWh606Qx+EGU7m6fNmaFWZRYq4zGlFwY5fDwUwzr8CBCBPrr
         u1bvC8H+6KQ2zTwvIIrUVw84EPfDOdy0Kcs9SEUgt8Gc2rZOkjzkxtR+vBT6Zfx9vjj3
         OYLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xwwJvPhqHZHRLMb9IQ4eamYZKhBF46wUJmae35NjNpQ=;
        b=CsmgrNRE7gxDVZL8nIlcMK2SlF0MCNZCBtTZa+654bKcsE9WZ3kk7tlFj+1k9nVR1j
         4DDn2A9DjIsc8eM2TEQs1sL7pPMT1LTIlQXNroeWT+CYQp2Zb15TiRgNiBEm8lCPz4t8
         TAzivNiYjAR4xosf7l2khrICNwvHAtSiYG9CZqc60wTzMUxfkPnYT8JI6xBlccQjLhBs
         KNyzvvQBtj5zVIJsxb1M6uBJ8T2VN5P0qeub6CzdP+bYDfOERy06AGJX/rI4aK9chg4I
         ph5ktr6J69RScVJM8xD2vekEWSqZGgKaWVZxioPqHT6Lw9hJiuUXnp2vhHe18qD7LKrb
         hrVQ==
X-Gm-Message-State: AOAM533mHSX8tpP38fI2886R2Xqug6/APsaeLCxjwLyA7vjbBLjMxlh6
        VEo46nuAhzyZLjQwpD5RLHfiQgJ0X5Rl9UiAsvE=
X-Google-Smtp-Source: ABdhPJxKC8G4QDbsYEtLURJBNGs/mp+VbTy1zmH+hzfyFNsGPcE0K/Up0q2YX2yoIihCOh+eZZH8dQ==
X-Received: by 2002:a63:784d:: with SMTP id t74mr13063108pgc.112.1631938673978;
        Fri, 17 Sep 2021 21:17:53 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id c199sm7439592pfb.152.2021.09.17.21.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 21:17:53 -0700 (PDT)
Message-ID: <61456871.1c69fb81.9363.e92b@mx.google.com>
Date:   Fri, 17 Sep 2021 21:17:53 -0700 (PDT)
X-Google-Original-Date: Sat, 18 Sep 2021 04:17:46 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
Subject: RE: [PATCH 5.13 000/380] 5.13.19-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Sep 2021 17:55:57 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.19 release.
> There are 380 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.19-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

