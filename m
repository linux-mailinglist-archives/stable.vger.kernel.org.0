Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6ADE536F25
	for <lists+stable@lfdr.de>; Sun, 29 May 2022 04:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiE2CsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 22:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiE2CsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 22:48:24 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98017092F;
        Sat, 28 May 2022 19:48:20 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b135so7641127pfb.12;
        Sat, 28 May 2022 19:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=+iiDE9gQ82NeNczZtMEx7dCNxOmpnVmfRlZ0PqhI1MQ=;
        b=csXPrfumova6aI5QVPgrAOFrsewGzt/nUzF01j9D98JcE84xNoSAsnUrPBrmVqT07l
         F4ja7JK1hlJuP3lZykIuOKK5uCPDLEozMgC1f7bwEZay8qFGkuTVPsVS0HBsC+EPgsVR
         mvrx8a4Glsgpq1H/clVV18IkBWxgH+Yr/fGHaARB4gAPGqg1MAX9tyMgckakk5uPuNmZ
         NyBjbLtBfSXlIp+CDdJzgH8+D77q1B8BxGtFievUCJevWoqlcRf69cOblDdkfon0i8gx
         UK7366cM4T0MORkPNHSU0bnU+nUzoDqSnB8a10ra3q72F7xvZzXsVgRun6lLh8yICME1
         WQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=+iiDE9gQ82NeNczZtMEx7dCNxOmpnVmfRlZ0PqhI1MQ=;
        b=G4P94ssssastt1H3ROBlJvFZUZDlqJgffJxcaIFHAPBHMk24AJa7cr4ES/xjlVnHm9
         29J9z4FjE2aGBEtdIv9vH5kylJG/ySfA3QmzpFXkwO42TNh4wbP22joyCH8luw9eOxyZ
         5o4Vam+E6C49/ti4rTFubOwLpLwUojaOSsJwDsxLDm1fpB3LnN2QGfamOsXGjPYa/KqI
         hychUW5qUsTFlWThN7uFkFUJigwHC1Kk38fNt2jRdotXhflgl9Z9tNZcoRJBEUVsnqH/
         s1HJ9uYfUNraBpDJBUuiY/IR5mUK0ptaD+6VHXbhr5sd16cxzNagN1kCqShtq+ZLW7/U
         VdvQ==
X-Gm-Message-State: AOAM531db32XBMyuKzbwoVbHzrboV7niaPKP758Nfu48HYmfQOIoqpMc
        srmg42+S/Uq39S86ki0M33C8PY6z1dF0fYar
X-Google-Smtp-Source: ABdhPJyoVwBUAaaDaBjwGi0RGics4YQOvibKH1ELzFRjR/u0UDK7WCeEaADobAyj4vcJ0jyTiO2vyA==
X-Received: by 2002:a63:f108:0:b0:3fa:34e0:52c7 with SMTP id f8-20020a63f108000000b003fa34e052c7mr29541655pgi.302.1653792499915;
        Sat, 28 May 2022 19:48:19 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id lj12-20020a17090b344c00b001e2da6766ecsm319544pjb.31.2022.05.28.19.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 19:48:19 -0700 (PDT)
Message-ID: <6292def3.1c69fb81.90237.0f8d@mx.google.com>
Date:   Sat, 28 May 2022 19:48:19 -0700 (PDT)
X-Google-Original-Date: Sun, 29 May 2022 02:48:12 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
Subject: RE: [PATCH 5.18 00/47] 5.18.1-rc1 review
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

On Fri, 27 May 2022 10:49:40 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.18.1 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.18.1-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

