Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54BD53291E
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 13:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbiEXLgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 07:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbiEXLgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 07:36:49 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D350735274;
        Tue, 24 May 2022 04:36:47 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id b4so3352151iog.11;
        Tue, 24 May 2022 04:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=mkvrcAte7FxPPc+oZsCsxzLAlE1N1sD1MIfr4Pm9EqQ=;
        b=lh0cN/iTNvjdZ+VmBrm0XPJbEsECW7txebxrm+sMRyeWK0MqvVFOyPSqFElWk/CvoZ
         4GIaop6hhU/adXey6F3dQGHnqVzJ2vezdIde+qsBSN/nwhAPNM6hCkiCC8PWymzUBIrL
         rPq4JAsCYATEabgSuno0neiXoh3xbz+11kAGPg4rtKGcxDFgRosEe+IG74iee+SRvSwd
         8yrMf0ZHA58j2m4/cgasmC+xBcmH1sAZPteC4hhgv6gGhLOqbWkR5Z/vFYWgg85ZdMiE
         M2q2H1Dd3J4efnDAN6cJk7rSTdFkbzwnKsDNIagYd56O66ie6kan+0cBICSWuk8YFdPm
         EJbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=mkvrcAte7FxPPc+oZsCsxzLAlE1N1sD1MIfr4Pm9EqQ=;
        b=vh2Janfx2AG8qRNYUNFPuDjlOzQIZhUmPWgYonrAdKDo3AuWnSYGp1F96eAaxA7lCx
         wG0fEYtTo6y3nM8IiuUO7JEIrATbRGsV0mj+fUlwBhVgsq4heOr6QLH7LOD/qlquYzk0
         2fMz9IIkTeaVbIdYM+XUuz5L6RP2rxLAWsHO2sNksiRQlcFQ2vKzyvj48I7JBgHhIF4U
         bKsgqSLRGjjCg4yFbzWOrvjaKygwERM/n1ryULv85G833i3hjW0KMbfRWtSG/C/uRdaP
         ImpJ7o96+tXzKcoEjyfflTEtanbcj+zq3bp28PIiiCNnJa3kX5FGLwrRookR9k+ZBLUR
         zpUg==
X-Gm-Message-State: AOAM531VAtbgnLht3O0M1NDViYzZU663bayOlfr8mR9So5OkXZ04s5Ed
        wuGb/aUWtqVrcrnrkGlAJxZyVcsjzNUalVPjpBI=
X-Google-Smtp-Source: ABdhPJw8aA9WYDdVl8/rhGUtThrS4ESbwHfRLxQ8owMxYT0Z8GDe0kmg3Vt/7ZVCYvwxsGQkMwYaGQ==
X-Received: by 2002:a05:6638:408b:b0:32e:e205:6714 with SMTP id m11-20020a056638408b00b0032ee2056714mr2012819jam.153.1653392206900;
        Tue, 24 May 2022 04:36:46 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id a3-20020a056638058300b0032e3b9e3d38sm3393717jar.126.2022.05.24.04.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 04:36:46 -0700 (PDT)
Message-ID: <628cc34e.1c69fb81.1a7d2.d107@mx.google.com>
Date:   Tue, 24 May 2022 04:36:46 -0700 (PDT)
X-Google-Original-Date: Tue, 24 May 2022 11:36:45 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
Subject: RE: [PATCH 5.17 000/158] 5.17.10-rc1 review
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

On Mon, 23 May 2022 19:02:37 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.17.10 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.17.10-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

