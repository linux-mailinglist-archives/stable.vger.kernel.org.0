Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DA554315B
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 15:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240312AbiFHN3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 09:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbiFHN3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 09:29:39 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E20AC6E4E;
        Wed,  8 Jun 2022 06:29:31 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id h8so454497iof.11;
        Wed, 08 Jun 2022 06:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=nN7RyI2WSz8Sv8vnEOKXCUHUoIMDKd6ExQvrKjutgMs=;
        b=Dr94thrM6bKZQOQ/0Dk51VcgjcMvlbjgzhAnIdWiqnSmvaDRQiclPalfq/qn1cALhs
         zmsOGhhhDl4a+pz5gZOaUgeAySXKikeovmUiN3WHDFR6rjWfZVx1DAalhUsZ09jddDbV
         +Qog2ZCKEvuTgiKbU0DEJm/oG09gKWrd99/xc0xL5uAvWGvODL12JyRhrgF2LzPlrCnN
         +5xsdWh7B8K3EIzImy39CzpKZKQSm9rqfnSaOWJ472C16jaLyJ7ZNkwPFCQC30abCDPq
         vWZq4w6BLCsdSEUJjW4QMpbuAz+pQYt2NQiabc/xwyvA7w1jKRMCdDbGiMxD3ocqOTEb
         clhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=nN7RyI2WSz8Sv8vnEOKXCUHUoIMDKd6ExQvrKjutgMs=;
        b=eJsUYes7wInYKS7UgmZaI0Ttr/pgA1NvuoHzi4LpT/BYvNVR1f/fdxlcrpZP9iJR+U
         Qkpzwk4t7t4ONDM8ox1QGapPgM3dFSlgIg0xepxIWLM/n6eedZtIwRl0++ynJcHNoOwI
         dN/M6vNdv1sf56xC/ixlR4MoRYxOAkRnnl+3FLi4bc/RovkNZFRI2gefDlOymsO6xdDW
         MrFbD08qsHFKBo72cU8U6WLeguOdAlC2Mx9kp31YKHg0xVQJMs73BNfmxZDFoEyOs31V
         15+/0+YndxUmRpdl9l2C/GqXLbXL98piess8wMGji0VTTZhxOCuIbDo5HEtfKN6tlDfX
         KHow==
X-Gm-Message-State: AOAM532lDr8AgK5/qBhkqNnn5Hsc8czdsITitgQalxEevXRoEHeUAxvn
        yY194FIsKDccCuVDG2wXTnwqEGqUj7Rzm5ztgpQ=
X-Google-Smtp-Source: ABdhPJwRg3zFmkgVuDjCSWkNIJHL2v/IuBdOgmadXmKOgsqGxgEXuj//139cYxN24+KFIWHkCTuoLw==
X-Received: by 2002:a05:6638:1a0e:b0:331:9a26:57c3 with SMTP id cd14-20020a0566381a0e00b003319a2657c3mr10551701jab.310.1654694970378;
        Wed, 08 Jun 2022 06:29:30 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id bc11-20020a0566383ccb00b0032e798bc927sm5646672jab.133.2022.06.08.06.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 06:29:30 -0700 (PDT)
Message-ID: <62a0a43a.1c69fb81.3bb10.aebb@mx.google.com>
Date:   Wed, 08 Jun 2022 06:29:30 -0700 (PDT)
X-Google-Original-Date: Wed, 08 Jun 2022 13:29:28 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/452] 5.10.121-rc1 review
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

On Tue,  7 Jun 2022 18:57:37 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.121 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.121-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.121-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

