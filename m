Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53E243319C
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 10:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhJSI5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 04:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJSI5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 04:57:06 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10770C06161C;
        Tue, 19 Oct 2021 01:54:54 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v20so13199038plo.7;
        Tue, 19 Oct 2021 01:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=P435gZxMyKcOyTUtCTuJzQMHJK0ZqumKw2I8ZZlAPEM=;
        b=YBihrpYDyESPEtQaDyqbCE+vJ0tm2JP8sYmC2j8HLk5AXDDATAC6x+ltG8k2vC7o/Y
         tfHpjsDqD85H/8zmXGF+czRXcojo1tc4yrAa/tCaGW7TiNnRITWKsj8SNlS2s4YyaBoO
         5o/k+3xFZEWKTySjAKOq9UHOtfygnlTb6InRVKBEn0CYFl9ZqAtthtIR7Ovmpq7MAhMH
         hQzFeTTpLA5GHb7zDsn/+PPe0O7Qyg5w7+awxYCGKXYUrQcw9CLlLFG6OrZMTjCJCgB8
         aenUy/b7aM/+zcv3tV0+BPGMhHceJgVo0BZPPEPEjwGG9/NZuzBk4SYL7tOxb/4WWYqw
         1z/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=P435gZxMyKcOyTUtCTuJzQMHJK0ZqumKw2I8ZZlAPEM=;
        b=GtxzximuVRTGUoG/KbU9gWS/BJOGOUq6fbuUeHksPCBiSZj23CEd/oFRMVyuLuxq1h
         m8CgflztW/TvtysadIW5eJcI53dG32XRHvyRGUi94mOOAghAE5kdMlMkr++FDBFkJQYu
         a2X63TTlfy9uisbIz01WsYv1C2deiOeCZBGPF7hb6Rt0sOLFEHHSNjAuL+MaA0TfcK7I
         fnecOxawkJX7jhy53hqEsj3v0Z6h//vT0SxM9YiMTu5KEEx6UXIMeOBEhblKk/Camz8l
         OsNjaJUc8DE4FUTiZjzPRoDoP2UG9h6hvM0RHNOiqcGcJ6AlXI4w/wDRVmRthpYyzzBd
         TMtg==
X-Gm-Message-State: AOAM530v8wcFvME8+YWwnSJrTZvf6XUtHlnOkRvajvcfvS9bHlxmaT8D
        LVLsUQM0hbe+1SOjEwZ7EF8ymSXD0PQtLsIZEAc=
X-Google-Smtp-Source: ABdhPJwxdcAleb4lHyfP18O3RIc3dg/Lq6v3O1aM1CaVS6z4X1IHljXly0bDpElodqMm/oojrOk4mQ==
X-Received: by 2002:a17:90a:7d0f:: with SMTP id g15mr4992923pjl.227.1634633693061;
        Tue, 19 Oct 2021 01:54:53 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id u65sm15451173pfb.208.2021.10.19.01.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 01:54:52 -0700 (PDT)
Message-ID: <616e87dc.1c69fb81.11ddd.aed1@mx.google.com>
Date:   Tue, 19 Oct 2021 01:54:52 -0700 (PDT)
X-Google-Original-Date: Tue, 19 Oct 2021 08:54:51 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211019061402.629202866@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/151] 5.14.14-rc2 review
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

On Tue, 19 Oct 2021 08:28:35 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.14 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Oct 2021 06:13:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.14-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

