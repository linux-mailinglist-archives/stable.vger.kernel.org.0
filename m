Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF4552709B
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 12:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiENKN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 06:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiENKN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 06:13:58 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95D03BF;
        Sat, 14 May 2022 03:13:57 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id v11so9119017qkf.1;
        Sat, 14 May 2022 03:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=O2k3CxYQ0rfRbsvdbusSGajTyuBodyEoE5/3tvshlIs=;
        b=IvTNI894TPDgcvJRbse04Az38GCR5R5XuJ7gF6OhsSMZFBjuU53+7o8SuSJ3UeEDXt
         YznwLlEMdhLmq9tao9wkatdbNxwE/5BzNOnWfl09oRd39pd3MDTQN9HfdCC0XBJL5Ur2
         5iuMMAMZgVIT71slP6+LWsv9SXhmGtfnU321+xrHzT4g4TC/AlQd9FU3ZyYilgKm0B1Z
         6TKWcjaPPVarmKM0i3qbv4rGNsfTz353HiO/j0pcCvEixa9aOfx1LU/YaZiUrxtwhkmc
         Q2D2hoR2J/zo7sVAhxvGtd3UFPKJrMyhmvUqezX8tPaOFwTmT0mj6NUPbhtbI8fCyTjl
         LHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=O2k3CxYQ0rfRbsvdbusSGajTyuBodyEoE5/3tvshlIs=;
        b=LlfTwyeZTFYlRsc0p2GwPU6Bc2eDDyyYm3dX4RQzYYSN5500oCnxdp/3v/HPJ3i19i
         vt9cfNcA9/7vjrjngAVOrO+SmUCmbeNaxD6lqXI8rXHhknK709iTn93iuOhAEt5u0JLU
         oSRK50do6eRTkyB8gFhf9Z6dsE0VlltzH05bABplSN5vH0tGlXnIwX/P2kCmLxKDdROg
         979v2x4I552pU+icnsfy3TiVutq8iZmKiHqcX7j6EmoL+0JbusYrm+eAPrDGvyFQpoKN
         4dq02Z1pR4x1Om1gthEX/ql2BYmFIGuZU6XA2uHVkCF376tYmz0BIXQk1DHGKS1Vrye6
         KkoA==
X-Gm-Message-State: AOAM532eW1OTniLVBjDmBt6P6T27D4wykFBkLXgQ+hXPsAEQveCbQNvE
        RiayckjgnOWwrVQTl/vUCnERaaLNSFH8qXALsnY=
X-Google-Smtp-Source: ABdhPJwLVYVZTMLDWOj/rvxn3OwaEGiAug8uZAoIm3BhI2aZnM1YWgYaraNOSsG0IJI2qL3qGdv2/Q==
X-Received: by 2002:a05:620a:4448:b0:6a0:68da:20bb with SMTP id w8-20020a05620a444800b006a068da20bbmr6426260qkp.693.1652523236426;
        Sat, 14 May 2022 03:13:56 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id e8-20020ac84b48000000b002f39b99f69dsm3031925qts.55.2022.05.14.03.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 03:13:55 -0700 (PDT)
Message-ID: <627f80e3.1c69fb81.37c5e.1708@mx.google.com>
Date:   Sat, 14 May 2022 03:13:55 -0700 (PDT)
X-Google-Original-Date: Sat, 14 May 2022 10:13:53 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220513142228.303546319@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/10] 5.10.116-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 May 2022 16:23:44 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.116 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.116-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.116-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

