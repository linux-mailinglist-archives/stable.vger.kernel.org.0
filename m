Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4497953D415
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 02:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348884AbiFDAeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 20:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiFDAeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 20:34:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259C91EAF0;
        Fri,  3 Jun 2022 17:34:07 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mh16-20020a17090b4ad000b001e8313301f1so1933281pjb.1;
        Fri, 03 Jun 2022 17:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=4J9r/ADMHRa2VWDoRZONcQ79oJ/Zv5AbYRMCT0dxcKI=;
        b=oBQYyoGuhqud0Uo0G9jJEbWL5XGDdvkOHkOkYNwfynRVfc7bZyiw6hhKcqFaubd12F
         V4W7qwRClvOhDersC3MwfuLq3wY/CB1FVW2JulQBNEJr8gQe5F2BTZZ0g5L7vIdEDWl9
         i9CRo/2wGAPZXVDhlGmwoL/g1fWE13+d/plvJI0C1PDHaMGtzzlAj+dr863IbJh3VaNW
         gq/iqFRpg5xHHPbav7GA2L5tvmuhoIAH3THW8Il7Bw33My/NjSvbk4/j5FTV/afF/jNg
         2dm0IbTZQ08joDiVD5EjrdA66/tJd9kZJXtVVaS9iV1k/bIvxtq9pk15N/2JXAtdkHgt
         USFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=4J9r/ADMHRa2VWDoRZONcQ79oJ/Zv5AbYRMCT0dxcKI=;
        b=uj0owmH0reYiH36UeKUnbIikBFsbcguIRaIS3RIQ6EHZ67MRgtye18+i32vhAijRzY
         em5eCLhY7auP6TOd74nFkj/MbMY3U9F3h/u8wzi/+7eRSfH37MLmMqm6tmJAPj07yNxo
         sicXrcHznkQY4F5z7EqKuTULRSCAYlWE7mP6fDFaGfXM8CzX/V+IxYgaE7tQte3NynBh
         VYtFJk4MFDMDggwpNPb5x8xh3RKPXNCLi2ZMo3UYDvWz+4QbkR8d0W9/lQB/JoP2oVRm
         9YMf9u1N7roQB6Rf+XwY74ptDUUqHnfwRXGyfx/Cu9Og+c6vK/lMP0ajfEumQ0+IaU6x
         DWHA==
X-Gm-Message-State: AOAM532kNXb95e+uDjM/pds0kztSIvk/zNYSWNMK2GAhpK+8bjK+YtIs
        2VFkM3Ql5CZiGQWAnJFSytzcRw/nl0lYpL8wRS8=
X-Google-Smtp-Source: ABdhPJwz+zcP/jbpD3OdNjr4zcbZupr8epwyWSV1FBCKIIbIFaUGIVFkSI++OIwAgcIi48bKhE4nww==
X-Received: by 2002:a17:90b:1c8e:b0:1bf:364c:dd7a with SMTP id oo14-20020a17090b1c8e00b001bf364cdd7amr13224332pjb.103.1654302846284;
        Fri, 03 Jun 2022 17:34:06 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id j17-20020aa78d11000000b0051bbb683cc4sm5212195pfe.165.2022.06.03.17.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 17:34:05 -0700 (PDT)
Message-ID: <629aa87d.1c69fb81.5d845.beae@mx.google.com>
Date:   Fri, 03 Jun 2022 17:34:05 -0700 (PDT)
X-Google-Original-Date: Sat, 04 Jun 2022 00:34:04 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/66] 5.15.45-rc1 review
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

On Fri,  3 Jun 2022 19:42:40 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.45 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.45-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

