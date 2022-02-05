Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771774AA4F7
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 01:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245366AbiBEASy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 19:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbiBEASx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 19:18:53 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC994DF8E3C4;
        Fri,  4 Feb 2022 16:18:49 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id z18so6256403ilp.3;
        Fri, 04 Feb 2022 16:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=2RZuu+Iw1+YItKLtEPrw6IZI9pvOpPTzzhbgPTW7ZLU=;
        b=U5KJzhCGn6ysyzcHc4dUFOy3fSYe1NSDMUe8wRp5/784Xxmgas0Ofhgf4IPE4LSLtY
         DtSL8CoWzjtSz5NwOPh5/L+g8JhGukGciryy7PBuVbxxWnwGX173F/Ku7hStLm4kOpGy
         iHHiA2bfJI9ImpLMCcqh/o/pDPiX7BAHisgyXn6vdEIgEhkJxPseX85iTvuRf21jTQrR
         ITn9qVXYTAwLxVrq7BW3cBpsNB4JPW9NqEjzC9/7+DzXREODVhmRz3uKsVGf4wNjmMlS
         W76JSDN8qsB36mXk1i7i8QVFfBLnDuI47LqkHOSEXK/XCaFqC5YugeCYwFo+zkO6YHti
         +ywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=2RZuu+Iw1+YItKLtEPrw6IZI9pvOpPTzzhbgPTW7ZLU=;
        b=J8/FpW++N/47I3ylzxWb568jJyUVP3kyjPM8s+cCN9teY6sTtStYqI0aaxdLCEYhYA
         rNwbMtpuPBHE8zZ5ri9jTs7hq2IZj/vpktNZmhI6mc32WNEpfl49XK433x5yHAb2J1GC
         GPbeOeRB+O869fv9Dl7a4/A8PZ/n3htpOgke/vAiBx4ePXIoAnokVQWbbxgxqJu4e3Cp
         V6r1h/u639aN36dQGR8nQkInp3sExByX1j301EvkOLX/uEsm5or0ZnlZomn6vOzbWUpq
         1+HCTmc42s+YJQIk8rI7eEH8rwBdRfyNfgpURdA+Fc0/uxig26runIRwVdT8cMlSU/AZ
         lbfg==
X-Gm-Message-State: AOAM533QFKeN98AZRzr+E9zzxh/5n11TU7P4yD0bOuwKt/uEueFtnaNd
        wx2STnIfyViDcffyam/Er65aot9j2y3gk1fE/uLnnQ==
X-Google-Smtp-Source: ABdhPJwA7ajKw5rcNAainwKf0EbOYtimZNs8j7tjZ3nBqoxL2qfhVux93mHRSXhc4vc8UmQ2l97AOg==
X-Received: by 2002:a05:6e02:12e6:: with SMTP id l6mr802828iln.10.1644020328721;
        Fri, 04 Feb 2022 16:18:48 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id k14sm1796728ilv.74.2022.02.04.16.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 16:18:47 -0800 (PST)
Message-ID: <61fdc267.1c69fb81.dcd7c.9a08@mx.google.com>
Date:   Fri, 04 Feb 2022 16:18:47 -0800 (PST)
X-Google-Original-Date: Sat, 05 Feb 2022 00:18:46 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/32] 5.15.20-rc1 review
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

On Fri,  4 Feb 2022 10:22:10 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.20 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.20-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

