Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6F144D849
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 15:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhKKOdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 09:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhKKOdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 09:33:36 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A38C061767;
        Thu, 11 Nov 2021 06:30:47 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gt5so4300846pjb.1;
        Thu, 11 Nov 2021 06:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=79DoY9Qj3E/W4EIJde2rtZdzgiCf/lCRPS50IAItn7E=;
        b=BzGDB54s9nkqX8085q/fu0bBjVNjHCLgPBb/OBlu5DqYZ+tyYvQNPIeK3ln4ctspHb
         vUK68av84uHTqOX39KzYz6pSfiWvoaU6jM1b1iCMMTPcxXQjxzhUsXb0634zV1a4+OwD
         o9F18ymK8CvL+W1CZyVUee3eRDU5hCj48I3QuOUTyoog8kVHcegYIYQAFHoOKqS77Ude
         Nsiasx1zmBlykujPGA+z/j1NcIO/ZcPhmQEm5Qgqz4ibsHJ/fye92o4RlHlumzEQRELb
         O+CNNx/HLPQoxZdD3oeDAbSHRLuwKete9gAUO7WqtZQbARKVs2g0NTSuHfzoPheCbyrK
         0izg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=79DoY9Qj3E/W4EIJde2rtZdzgiCf/lCRPS50IAItn7E=;
        b=mAhG+yVjpK+rcPi/wwuT2b5hkqE0RIvJY/Y62VK8TwO7YlxhmOnHhpZL/PFPoTaFKc
         orPGNSiJXLoS8xMNyuLM072JQblfuWUZw+Z6adSgg5Bk1BU1K9thXwRM/4swRyUzGRFY
         tb3hC9aryOVr84A7FCDR9OMwduQDI9dvl8eauxIdfm7r1bDTGd9bmiJhXQWsXdV0qCT8
         S2D2+MbEP8tjtDm8gVJzESVNYnJlOkKHmkiR01heQuPjLW/D0k0xyUdKzWrr8Luhs3lO
         Wm4gggGsjs8fmtv1h6WKs4rxC78o3lOZu6rXJ2+aCKWCQ3AEgYjz5xFIxqOVBJTrqFAq
         3tWQ==
X-Gm-Message-State: AOAM533Me14nJJNpcGdm2KQa7aD9HTTtV9q9Qp5ozmGwT6zWJ6EnnfB4
        rIIig498fz7O1WeTy7/WlNNWbzsb+WEAWavzJKs=
X-Google-Smtp-Source: ABdhPJyp/Y1K6M9v1TF4O7uoKlqqFPIdz67W4bw2BpApkNUiSe6UDCVg26M58fNmOpVkb+0w2TlPHQ==
X-Received: by 2002:a17:902:8302:b0:143:6e5f:a4a0 with SMTP id bd2-20020a170902830200b001436e5fa4a0mr8617831plb.20.1636641046213;
        Thu, 11 Nov 2021 06:30:46 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id s6sm2575632pgr.85.2021.11.11.06.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 06:30:45 -0800 (PST)
Message-ID: <618d2915.1c69fb81.41542.6fa9@mx.google.com>
Date:   Thu, 11 Nov 2021 06:30:45 -0800 (PST)
X-Google-Original-Date: Thu, 11 Nov 2021 14:30:44 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
Subject: RE: [PATCH 5.14 00/24] 5.14.18-rc1 review
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

On Wed, 10 Nov 2021 19:43:52 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.18 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.18-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

