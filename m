Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4701F4D0E06
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 03:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244929AbiCHCcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 21:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbiCHCcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 21:32:02 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7164A35DC1;
        Mon,  7 Mar 2022 18:31:07 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id r11so14760904ioh.10;
        Mon, 07 Mar 2022 18:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=zv+8xQ02M3/jLEZMCLTOKrbtWgMA6/PhEBt2sH7N0Yg=;
        b=UnYwEchbKkl2yOJsRBdZg9qTZJZXlSTKklb2M5s63wkE/DQbB4hlNJznjdWVKKEQfJ
         Ws4P6azLhtkmdEF3cY24tEZbW8iAjeAOxTlay1UkxpYytG12PqxBaY4/sNMof8C4U03v
         NZOsqs/3ryXhK/FaJhSaKOE+j7yzJQecGEBYI93sW3gMVpq9UI5Mc8cyhFnCx7zK8ZoK
         h7B+O9jJhuybPHYBDXGLBrpFZwYwGg/T1BsUtLl6a+QSxzsyYiRvEWkO19hDwzGTJr7V
         ckKuJmNvwNwRp/EIZqv/yGKY6/DCQjOpEtP4l88Pp7oCjNPvnOqySidJxPjYnuGY/FlY
         EiZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=zv+8xQ02M3/jLEZMCLTOKrbtWgMA6/PhEBt2sH7N0Yg=;
        b=IwW5zAI40iOPsS5ec48+XYZYP7gvx0zLbo5P+GONPEnixgJxdlz3hGeeKjt8VOUapR
         zZUY/SbaXP5MD4zhtkqa0pJIZVvonWYxQ9DUDLgGHsehrdJ0Q1HLH7AypP6TCNNsTCXp
         d1g4cZfQeP/jIVi0duVTlWpvOfPKtV8G9hzoUdG8RuQJHnBlscDi6luSLongCkqH5ab6
         gxunotDyGGPgnIB8eLwnswMwTyq2A/tgCassTXEGTlY3MVNV/O2kYafciWGFpy7fuhfm
         1NqBEjTMh0AX7M6Ph+qKWkZ6298C6EY1hVOXQ2lPxt/JDZadc/e4SLk2efTFFBTa1V+s
         r1Fg==
X-Gm-Message-State: AOAM530vXy2czJ7rhfZwaWQiZ5V9OqkfMsQ4RUt9dO9UVFN2oge96/lW
        seRqOcngi2tWHYFFKi6gtHZtMXR251j8QUlRGzjEJg==
X-Google-Smtp-Source: ABdhPJw9jbQl2arUpnlbxpWvcQbex08XD5wJ8CGGCDeWW9VplF57FLI8VzlR+PtFg0tjW74shahNHA==
X-Received: by 2002:a05:6638:3789:b0:317:7763:46 with SMTP id w9-20020a056638378900b0031777630046mr13652252jal.42.1646706666403;
        Mon, 07 Mar 2022 18:31:06 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id f9-20020a5ec709000000b00645ec64112asm801131iop.42.2022.03.07.18.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 18:31:05 -0800 (PST)
Message-ID: <6226bfe9.1c69fb81.aca0a.45f8@mx.google.com>
Date:   Mon, 07 Mar 2022 18:31:05 -0800 (PST)
X-Google-Original-Date: Tue, 08 Mar 2022 02:31:04 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220307162207.188028559@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/256] 5.15.27-rc2 review
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

On Mon,  7 Mar 2022 17:28:50 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.27 release.
> There are 256 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.27-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.27-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

