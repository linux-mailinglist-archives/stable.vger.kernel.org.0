Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985184F6DC4
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 00:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiDFWTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 18:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiDFWTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 18:19:41 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9129238DAB;
        Wed,  6 Apr 2022 15:17:42 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s11so3203329pla.8;
        Wed, 06 Apr 2022 15:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=+fes3Pu7CKey5YYlBN852vHAhax+j5O+bAVh3kZEG/8=;
        b=SWDK/U8kX134D0kJKweXyCKKzNFDZ3nKoHGYuyweL/IFSOrX2UnyDaWDAzviaCevrV
         TvEDNT4H7RI4WUqFG2UwFvayKihqeHE+zgrDcQLo9it4N9Wj954GetID7AfQvW2Fh8Bi
         zBdT1Jmt2OhEmK0IHyScbIY8judDQZ6tAYXqEVMs7N+g7RrOsHLZE7/7IOd6okMQX4Tf
         GRJh7C5euF3nkFQiRPzwrfhdSvdD8NZHQ0x4PEDiXN3Y82nhhSQgbCcq60B19w0irjJx
         L9wOWqY5eiUJJB2itHj0f4zZlSkzsd/c2TQy73VOGWvkPDWE71uAeTfdWFisXrSI2mF8
         li/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=+fes3Pu7CKey5YYlBN852vHAhax+j5O+bAVh3kZEG/8=;
        b=hFgr7n7JPmAN2jPN1QrVsIVVvMQmtyOHbPwJ/8YEVCBVGRtNeBuqIQyclD2OxTAwou
         WTWhqc3b+TO/t4AcWcK2fhqwCvY3kNMeoI/59WUdSYicayMFu/Tm/j7sORzLPbqF/dau
         U1LbAFcwp18jLo09Zx5wq4b4VscFq1DDlwRoNVPTtcIC1L1Dc1CybhlBTDFdKvUmUSuV
         t86WiKs1ljE+VKnDoJ0S8GlzaC6WLSTTGE2d6xLtG23MSP24TtRV6nPk6Q2CgFXyfAkg
         qPM8CfWJHFqYlG+wQqg7RTcTyFg5CYCnb4+dxAQrImIkq0/kgHqVd2m5eDizg4Ijz+uC
         x5Eg==
X-Gm-Message-State: AOAM531VD3m6eTP43hhVklUtneNHiHvihXqrae1FbbXiWpY+OBRFTCjw
        IDj6w/WMt2EAqhgaOkE0MudjwbOEsG2bQI98uG4=
X-Google-Smtp-Source: ABdhPJxbFMXqPmSzdafei15Lzpkx2AvIf28em8Ynn//BJRQGRPIgKSlvs4c93l4zpjRbqS6b56DSDQ==
X-Received: by 2002:a17:902:6901:b0:156:4aad:fad7 with SMTP id j1-20020a170902690100b001564aadfad7mr10949063plk.33.1649283461569;
        Wed, 06 Apr 2022 15:17:41 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id cn9-20020a056a00340900b004fad845e9besm18586957pfb.57.2022.04.06.15.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 15:17:40 -0700 (PDT)
Message-ID: <624e1184.1c69fb81.3490e.28fb@mx.google.com>
Date:   Wed, 06 Apr 2022 15:17:40 -0700 (PDT)
X-Google-Original-Date: Wed, 06 Apr 2022 22:17:34 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220406133013.264188813@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/597] 5.10.110-rc2 review
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

On Wed,  6 Apr 2022 15:43:51 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.110-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.110-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

