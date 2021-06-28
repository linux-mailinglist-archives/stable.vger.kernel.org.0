Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8303B6864
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 20:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbhF1SXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 14:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbhF1SXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 14:23:31 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AB1C0617A6;
        Mon, 28 Jun 2021 11:21:04 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e20so16189624pgg.0;
        Mon, 28 Jun 2021 11:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Mze86rq/HH0+Jr0eUT1QFEQw7aT+jWIGpimAmIf8PD0=;
        b=HSDGzKRXQiwKjjZ3soDbhRmvOJBcPXB7ZwkOkxZeEy28cn2m3pblSV2s4Qwb/gDpfi
         dDsDbYOXDEWFluzlP9v9+70kfBu/iX8j/Nwnigy5t6vMML1M1NHmHObegmfR5HKP/SR2
         wi5TePs+ymXabLpJsMW1wf2rctVFMBtMzu8b2n+gCQpqLHQwptjCPQy3W1ZRRRXJoIHR
         Cxsfg+ae45KG7Z+uG+dAbVsc0w4daZ9kVpq1HeEIISuCto//3MnJxjT3bqLAjRtgFOKO
         6jxGeJROS2A4Kg8XiZlxM+pr3ZSizeTWJwU5KBA6pQy0emmdfJI2ovYUypeBkvJSUf2q
         00Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Mze86rq/HH0+Jr0eUT1QFEQw7aT+jWIGpimAmIf8PD0=;
        b=msZ8unUAVeraET4F2ZbC8VlpcsdClE7BfjTIY0Jhz5NStnIxgRgTyXSJbeDLZXIqSK
         68Iig7dpr8ZEWXzIX4AH8RLAWaVuM7+59Irc/8eDclhZkp/6EzuZF3uYhYDwOEFYB4F0
         3dBTaQbY2710RE/RXIibfoNoiAlNheJjSlSRLWgLzZd9QnVbgHr97bMl72xkThjoLfJx
         ne+vadt5qBUmzZ4Vz4PBOJF7F29N7Myq/a9/AdDj8wBj4yGml+0s7vi4FN2KqiaB1Ylj
         s2TEEActoGJAw7KStMW8Uf7Minjl86pFab0aLrx9QTUShqoGrua7YTPyF7bZ6TH6gl9i
         jMzA==
X-Gm-Message-State: AOAM532trOpUPtFgmgkC4bL0Zis9wnXR/favx+Mzl6iHMEDZnGRJuw7e
        apoA+68zoSmmGPIHW87GfCTSo3qpX8P7gHIXalc=
X-Google-Smtp-Source: ABdhPJwOSKxPnXcVk0gwTtpR8c/RIQr7cDNDr4T4D8LtQKDzf2nafNBBSuxwc4GGkUqVRTJZM533YA==
X-Received: by 2002:a05:6a00:15d0:b029:305:1ef:8fbd with SMTP id o16-20020a056a0015d0b029030501ef8fbdmr26508643pfu.64.1624904463388;
        Mon, 28 Jun 2021 11:21:03 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id g141sm14753650pfb.210.2021.06.28.11.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 11:21:02 -0700 (PDT)
Message-ID: <60da130e.1c69fb81.c638f.a74a@mx.google.com>
Date:   Mon, 28 Jun 2021 11:21:02 -0700 (PDT)
X-Google-Original-Date: Mon, 28 Jun 2021 18:21:00 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
Subject: RE: [PATCH 5.12 000/110] 5.12.14-rc1 review
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Jun 2021 10:16:38 -0400, Sasha Levin <sashal@kernel.org> wrote:
> 
> This is the start of the stable review cycle for the 5.12.14 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:18:05 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.12.y&id2=v5.12.13
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

5.12.14-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

