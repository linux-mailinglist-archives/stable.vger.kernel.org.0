Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683D53EC02A
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 06:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbhHNEMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 00:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhHNEM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 00:12:29 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBFCC061756;
        Fri, 13 Aug 2021 21:12:01 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n12so13887217plf.4;
        Fri, 13 Aug 2021 21:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=eBW0wqywVPtJyizjVPvYiP3EQu9CmjdQCVIOtRLCVH4=;
        b=LFO9PqJpSal+uzekkeMuSCOZmkZlbvlSyK9/T3c3w1ly7LlaldCEpN+XI8rPLCBwtt
         mhu9zkHi1flgoTmQP5stt5K/l3yL5npgPbH5IfJLjlcVv7bWSMcooJFIfyiTLt4EdTQY
         RelmJk2TWrxRCA5fsYHq6goe+CXUUbdV/DFlqHGOxomm0e6dJaT+XmSqFImzyWeuONuv
         uzs5ukGOhQjrad8Y+FAdnJZ+fgNRYZ2JcwtOlfz9BXiCIILIpLYGXzbcUnBB7vs5XXvF
         +VoQbK4oN9ZRc4oaaFqSF0rtOWXYYCvlzdvMGh/8WHzzHqv3a4wbsNC/CKp+viRHjf5M
         VIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=eBW0wqywVPtJyizjVPvYiP3EQu9CmjdQCVIOtRLCVH4=;
        b=fQyFJr+abhogoA3jcRU9ShRWArRCXLYziEzHBC2CRLYkW+8FOmLVE+JVcC4wdr1aXm
         qF4YuaL4N9EYahXrzXuWptouDloMQp1KVOPjbxNHs/3ne4VEof+36FCWZpzzhygH6gSX
         EdvHF3oISsDxc3a9xjOM+Qt6N+BUsQIqVLGxAQ3cY7xT0qLMJNkcxEUYDDfeGV0Tc79G
         vTPDII9y6dLTwW6IEfOA5/1Qz14Iq9xP4+zxPLMuobK7nA7vWY3evOLnCpYJEGzl/pVK
         85ecHyWB0m4hZ85GCe5T5nDIpiNA5mqdrfynTEzviWSeKp8Ck8lGrsW9eev9Sc9Udnv/
         7F7A==
X-Gm-Message-State: AOAM531fRU4iHBzgY/dsVWm0WOZ0dkS0oPizOWnrSXVSR1kVBmAXnBnU
        U/WtgNuOTi5n3lDbhOCufIberenQ69D2E2Y6lkc=
X-Google-Smtp-Source: ABdhPJy5uTI8MBE2FCleE/2BPmKYS5KCtFwKMpz1G6jGea0H8jNdnsrgR85VEt/ZAMGN3W8T9mlepA==
X-Received: by 2002:a17:902:7005:b029:12d:691e:bd87 with SMTP id y5-20020a1709027005b029012d691ebd87mr4492800plk.36.1628914321031;
        Fri, 13 Aug 2021 21:12:01 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id h25sm3748943pfo.68.2021.08.13.21.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 21:12:00 -0700 (PDT)
Message-ID: <61174290.1c69fb81.cf7af.aa7d@mx.google.com>
Date:   Fri, 13 Aug 2021 21:12:00 -0700 (PDT)
X-Google-Original-Date: Sat, 14 Aug 2021 04:11:54 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210813150520.090373732@linuxfoundation.org>
Subject: RE: [PATCH 5.13 0/8] 5.13.11-rc1 review
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

On Fri, 13 Aug 2021 17:07:37 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.11 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.11-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

