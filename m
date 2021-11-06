Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE06446D8C
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 12:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhKFLL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 07:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhKFLL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 07:11:28 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC26C061570;
        Sat,  6 Nov 2021 04:08:46 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id e11so160371ljo.13;
        Sat, 06 Nov 2021 04:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=zMuuOZVLGa0E0UsdiohXcrvg+oupE+t+eZvcTwF9xFI=;
        b=kWvsnE3ALeIBQ07UnrlAvwTwFHD2T357nhWqYF4zKl8NKy5dG/RO4Wgoi22lvd7HzD
         pqhwxxrEYnt5V4JHUOMB4zncwQaoqXE2guve0RbzdhW/RwmGSWBube6TT5l5sfHQxRVd
         egQj1BpmkPMV1X0XT7Ng8IM5tnEiheHNh2KLs3zoaeJi01uU2TTbgW3L7wdg8st1Icku
         IojjsH1RawlOx1bDB+iewTicoPkifly2T1+LxkODWKgAWssqi2I3FFuAv/7RNhNclZFy
         ZrJhrTr0H+sS1FXRm4PI3/lnJ2d9MBCun1xgLALjkBWz1i6ExHVPv5QXqn5WtKOSsjP5
         yTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=zMuuOZVLGa0E0UsdiohXcrvg+oupE+t+eZvcTwF9xFI=;
        b=iMcEK6iVSOGqFvU6dRSuYxB79qfisASRZYqnfNWGRKp/+BockPVSIQiFKN2w/rzeIU
         XqnBR2SsWvo7tGtZFg4uCl1VvjZOzWJaYSaODfVSt4ZIBnIChfXIxv5l8wCA0DCfG9D7
         IyE+7WwDzE1orb5AD2rH5a8W9/IDLFRIC2n4caYYsa0I2zzgDf7bxWysGzssRd+/IH7j
         p8BSqurzyu9PvXgD+ViO2o1J//+azKeX30NDcJrm9q0Iq+pA9SrfRQm8DO+5/BF3OI9F
         gkV2agBrfu12Nbm/eKA5REXcq0BtrQuKgmyTo7ePg80diAwmZLhQzbt7Gyftoj0CitSb
         fI/w==
X-Gm-Message-State: AOAM533qPLZQxJJiCe7opo47+oZ5wxN9T+gZwVfBRdFKq5mH6mx1qQyW
        jwuqQudX8GrYWhYPpBRt6GnPvUgIukv30DrKcuE=
X-Google-Smtp-Source: ABdhPJx+IoVkSSXDnqzb7rfEv5dnOu0it48nzyhzGte4S+yZEymQ7eHaxCbxszEzoS0AW7wuPenbuQ==
X-Received: by 2002:a2e:8748:: with SMTP id q8mr3579709ljj.163.1636196924954;
        Sat, 06 Nov 2021 04:08:44 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id b17sm215875lfv.264.2021.11.06.04.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 04:08:44 -0700 (PDT)
Message-ID: <6186623c.1c69fb81.7481d.0fed@mx.google.com>
Date:   Sat, 06 Nov 2021 04:08:44 -0700 (PDT)
X-Google-Original-Date: Sat, 06 Nov 2021 11:08:39 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211104170112.899181800@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/14] 5.10.78-rc2 review
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

On Thu,  4 Nov 2021 18:01:35 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.78 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 17:01:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.78-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

