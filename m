Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E6D54A255
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 00:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiFMW4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 18:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244974AbiFMW4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 18:56:14 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187C9313B7;
        Mon, 13 Jun 2022 15:56:12 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id u8-20020a4ae688000000b0041b8dab7f71so1450693oot.7;
        Mon, 13 Jun 2022 15:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7/0QEJBZpzKgCvpCVh0kWaMXgvRlUFPSGYvCQjI1X54=;
        b=hUPcswRRUvGOYWNj69MrfblwjUSCRX16ampmO2ZiH3rwz83u+fEVv7tgpgkfNTCaor
         59BDpBh0j0RINodWcMRY4UMOyvbhu5Uj9Co7bCjHWYUcrbGfjWJ73DVAQW3N4tK+9JO3
         piONt7aFcDQcLbrd+8nrn+KVRilTS7H343JNsHc0pafw2IFh7VSJioLAeH1zAhYD8x3D
         55nyKYrdVJB5iFY4Y7Jwfiz445N9zuu1hmpKU5dABRZWEel/nMj/2Qlfd07XN2r+v3np
         ALpmeGM42tm5Pq5E1d2XeyIppGg1cAPJ05R/Kr3ZCZayN2ZayAcCrbljm0ajCwBkqmHy
         HZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7/0QEJBZpzKgCvpCVh0kWaMXgvRlUFPSGYvCQjI1X54=;
        b=ZrY9Pggs/xxhS4wCSk+Rgq0FHeq570OZ4b8eMJUfBQUsIOQbUvy7pYz5i5cEz9hfsS
         YbOJq5gucuI2af/8+FGI7R9D/22dk7dWKCN3zuBae1RliI6UhdABC4Hq0x4CrchVfLaM
         WxIo6DMS6hBJKOmkPJVKWYmFYOzREuTqDjKk4lkdJu4T00oXEDgQ9iAujmxMWTxgsFyd
         m9CfaQlaVKF0Ogrs3QSYGxGOFRWHzIVQTsfasO352ijlNmp4YMw2xdk1T8nzxO18esNw
         ahwrG4p0olqA7Ikckd1kvKrq87aW2Q6rVUYf4bjQLiy1v5X9f3rZh6YbHcWolkdys51h
         YZaw==
X-Gm-Message-State: AOAM532Q8gVab15Z8nIsge3RAIcpp0SH9fuA+oTCwKj4AHmVpKuGQts8
        hVVpv+kJKnbtEhFfWWELLN5rdIzklwxvHeVcwTg=
X-Google-Smtp-Source: ABdhPJxSrL1ujddhhTihhZCnM5J8sfjjruf82/Ld9GzPkfSAV33oecETo/JmmkyVWK68DL2GSANJIg==
X-Received: by 2002:a4a:de89:0:b0:41c:4a0:c06d with SMTP id v9-20020a4ade89000000b0041c04a0c06dmr852196oou.96.1655160971023;
        Mon, 13 Jun 2022 15:56:11 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id c30-20020a056830349e00b0060affecb2a5sm4056954otu.17.2022.06.13.15.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 15:56:10 -0700 (PDT)
Message-ID: <62a7c08a.1c69fb81.d6ade.9044@mx.google.com>
Date:   Mon, 13 Jun 2022 15:56:10 -0700 (PDT)
X-Google-Original-Date: Mon, 13 Jun 2022 22:56:08 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220613181529.324450680@linuxfoundation.org>
Subject: RE: [PATCH 5.17 000/303] 5.17.15-rc2 review
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

On Mon, 13 Jun 2022 20:18:43 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.17.15 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:14:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.15-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.17.15-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

