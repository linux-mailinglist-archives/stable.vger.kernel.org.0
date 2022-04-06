Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01784F6C56
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbiDFVQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbiDFVPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:15:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA5F23864B;
        Wed,  6 Apr 2022 12:58:59 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so6815697pjn.3;
        Wed, 06 Apr 2022 12:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1e0ne29VnvFFFirLHS2mdAf73QlT7Sh7FwqCwuvgb0c=;
        b=iuvqlkv4FTWzjMgI+4Cu12wbCYyY5RF/Dhiqr9u229+Fv3LtiHE3QHCB/KyqHxpLQt
         P39nkSmyyb0k2huYUkkUJN1mVN6r0oNVAc/1WeU7OjlStVfzo7miaVlqKMAaxOpzMa5o
         tJWP+g4OTOZBRFo81sJxWgqKrf64nGrocZJ9ozn4CKV2Bl7V35Ohxqcws9AkOwAjxdyF
         LM++tQY710FaIrYDo3m7+6whRBMDC9BqAgQfzcdL8Pqus9JdU0e06KDrXWKOa0NXiBRX
         qznePqbF0Ocpe0grhVt+LPHj55nMdNfUjKUY9YtUqrLzPBwFtuupdY+xwdlNDTBbZcqO
         gCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1e0ne29VnvFFFirLHS2mdAf73QlT7Sh7FwqCwuvgb0c=;
        b=JbdcMwOz+ApA3+JCJHJjAcBvIQFmB7ZvttN12jEvGIG/2t0ScCUHyj/ezHoxlpebAK
         OQP7HUqrRSKN210FP87CCLT+b7w29A+oIDbUbR8MZjUDAQdvyORU1NCQQjE0KUlsPwM1
         m/wmop1eOr98biJ1O3uJpPNlXt4QnQNeN+OlZ4BRz+QTmrCSOEbbq09+j4uKhMl9pxYQ
         icjgp91G2IvWQqzf8b/fcclQXwKkZ9zqd1Z5Z23vRD+ksG6BcQ+v3sscsuCnWM0FjPq4
         nGriVMrJAenXU2cY7HXK+c3Vrj4frdAaWZfhvItAPowI8p/E+T/rYBtSK8nYiXNzyHM5
         HobQ==
X-Gm-Message-State: AOAM532eeEcTO7ANuXdvw8QlDSBs4tp33FDDdw1qENuMK+u1vk5zJ8GJ
        32P11vfeyl0cJM33U86s9l8mwGhJnrIPL5yruKI=
X-Google-Smtp-Source: ABdhPJyIpYf+2uY4GNQ2AFjn9vAP+kJ5/vZsee0LUhOncTMyXnj2C2wvnEYir3TM9+ELMzd8iaZrig==
X-Received: by 2002:a17:90a:e601:b0:1ca:97b5:96ac with SMTP id j1-20020a17090ae60100b001ca97b596acmr11844150pjy.188.1649275138284;
        Wed, 06 Apr 2022 12:58:58 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id e6-20020a63aa06000000b00380c8bed5a6sm16950083pgf.46.2022.04.06.12.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 12:58:57 -0700 (PDT)
Message-ID: <624df101.1c69fb81.11832.e0e0@mx.google.com>
Date:   Wed, 06 Apr 2022 12:58:57 -0700 (PDT)
X-Google-Original-Date: Wed, 06 Apr 2022 19:58:56 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
Subject: RE: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
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

On Wed,  6 Apr 2022 15:44:54 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.17.2-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

