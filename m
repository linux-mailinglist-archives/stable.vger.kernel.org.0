Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2984D8AD8
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 18:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbiCNRex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 13:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbiCNRew (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 13:34:52 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3389D5F76;
        Mon, 14 Mar 2022 10:33:41 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id w7so19166649ioj.5;
        Mon, 14 Mar 2022 10:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=eBGr3EYVnokIXBZ1ivLXLwjkCHVmPG/SGV375op3izg=;
        b=Yri5H9BjpRLyG5xBvAORHMLFFU574INQGOGlqdxvi99/lfQh0kbGKh6c483jVQk7z/
         d12PXnebuWxr4eDHRmOdGxhZCwRfy6NOlvCYTW0X0vv/Gf+wDxwQ2KduMYt/hFQESjc0
         7W8MdC6HVt1lHPg4gg8VNQg8H7a/MPuoaNcmJpLuY3SNLTG8AcBCX7wxofQp9q9NaS3/
         uLew7UvreOLBxFKS6N5bXKw2fsyDRRzccYHAqLR4U4qLtDRNwwLsY+ciDq7ICBww06AP
         8K5NxRYahZunnQ8H+s9RUMUJwJw3waLnF5mspnwE9/So8j7SfE6a5ixpqo1dH5dsk+D8
         lphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=eBGr3EYVnokIXBZ1ivLXLwjkCHVmPG/SGV375op3izg=;
        b=RfZOOcmO7X32vMq18vHSOVgyUWSAKUfz8xy1h3Lg++gpXASLNaiS8WtKkUv/6L27gz
         jJcMsk6vfwbZpNEraY708QJlyi6Vt6COZMpTpcRXh6AJUgNsSmMngnnWrZ4u/Qq3b+Np
         77S9T9pGk6Y3EWEGoI0JEhBxFOR/NiWPDeCid3nNO9YphsuoVVxiXgS1bsHKlm5fkkNi
         SQGDZqhDK9euxhK+X6pxH13pkD9++9lJ+QXE4rqyjy/gaeB4cJYrvp0HgPhNwO2sIvz6
         vPZsdUKuRYGgAUso9HLzdRKAFT4WPAZp4iUHCGiQcOiSGH6gEq1ZJYWBocCD/2liQpVW
         oXrw==
X-Gm-Message-State: AOAM531vnn2PqgfWjspKtAPiYgu61fLuyW2xyMpj8iQC7ZQzHNuAHVSK
        kVfk7sVxCr5x/Bx5BkjCAebdIfXofye2IETrX2CBqA==
X-Google-Smtp-Source: ABdhPJx8ZD8JSMbw5k93UnuCz6taMEHoNc2IrTv4tTz58ahIcruugzpDBjCFKLYmtUEFPxNT8nUy+w==
X-Received: by 2002:a05:6638:3051:b0:317:8a78:7be5 with SMTP id u17-20020a056638305100b003178a787be5mr21532199jak.142.1647279219972;
        Mon, 14 Mar 2022 10:33:39 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id f4-20020a92b504000000b002c21ef70a81sm9470504ile.7.2022.03.14.10.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 10:33:39 -0700 (PDT)
Message-ID: <622f7c73.1c69fb81.aef87.8a56@mx.google.com>
Date:   Mon, 14 Mar 2022 10:33:39 -0700 (PDT)
X-Google-Original-Date: Mon, 14 Mar 2022 17:33:37 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/71] 5.10.106-rc1 review
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

On Mon, 14 Mar 2022 12:52:53 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.106 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.106-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.106-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

