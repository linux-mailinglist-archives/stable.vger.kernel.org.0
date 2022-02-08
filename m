Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EF64AD9E6
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 14:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbiBHNbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 08:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378148AbiBHNbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 08:31:01 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD3CC0085A1;
        Tue,  8 Feb 2022 05:30:10 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so2063940pjl.2;
        Tue, 08 Feb 2022 05:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xB1NXJm/hSKDkAp5uvY7mCj2m7DP3RBYPb/PrnHZ/F0=;
        b=U9PDIsquqkjhFvbqaVGOsHi//xTum/Othq5fIF5gO7qTVFAazvz84mdHt9EulDmD5B
         4+uaHBh9uLS1Gf5se6ZWe4nVmgnRqdKIzbL9vNSdGR347jC2w/e4g5Sjk04GBDeSRk16
         qCEn1V9RUi4ewlLxYhaUGN4GDFUh4jtHjOkn+Y69nLduFTtLVLl9TLd0b5PEswHvxfMZ
         r7lBg7OZ/Ad6agOGUAATJuR4TF9UMoYVQFMV/EM/hZGDsXG4PV1k4Lm9MQzvZ9SURdRd
         M5GmiPhc1vNwX2xwO5Wdq8TZBnCEFd91OdJj7XOC8itYVCru0jtJmx6jwH30Euj4KBRU
         /Nlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xB1NXJm/hSKDkAp5uvY7mCj2m7DP3RBYPb/PrnHZ/F0=;
        b=DLczjz5O7MdAzYT1vX0qht/hxLBxJ7Ccwx41MVro3gb9DQGmK/Cg47n2KBasR86fds
         pmug92DWe2cjTJ3wJpCk3hy1j6KzNCTtEJMhquPoHIye83/01l60HuzSzUVJdx4WP17z
         XeUKUBTbz5v8WzdYFsWer870vzJji4YzV4T58DPKU5530aAjMII/+Yezec6Hr+FspmyD
         KULv2BhYa+Vi8hDkUUTCVWL5W/aUQRNhTo21/3BZuJtAM3QzIWwkWngUM0R8sVVPPW1A
         0id847xQCZFMwQTkX4R+I6+FbRQOjctMZyjogBhbiU8RtcYZBglnIf4Q+FYaGn9YAseI
         bZOQ==
X-Gm-Message-State: AOAM531lRceIjnFDH2up3h5EPDVco/TuV0R54p5I9ieXXrUyA7vGjsXa
        rL+x2KkBywBpxPUMamJNZ2uwU/cB/hIFYLw4mB8=
X-Google-Smtp-Source: ABdhPJxQrxFY5lG5Z7jL/Ry8i/+9mnFdAHla8n6Qy1qJHVR27ottI155JllEx8V1L8ONpdHYn+sDxg==
X-Received: by 2002:a17:90b:3a90:: with SMTP id om16mr1354914pjb.111.1644327009355;
        Tue, 08 Feb 2022 05:30:09 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id l21sm16263274pfu.120.2022.02.08.05.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 05:30:08 -0800 (PST)
Message-ID: <62027060.1c69fb81.bd18b.8223@mx.google.com>
Date:   Tue, 08 Feb 2022 05:30:08 -0800 (PST)
X-Google-Original-Date: Tue, 08 Feb 2022 13:30:02 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220207133856.644483064@linuxfoundation.org>
Subject: RE: [PATCH 5.16 000/127] 5.16.8-rc2 review
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

On Mon,  7 Feb 2022 15:04:44 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.8 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.8-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

