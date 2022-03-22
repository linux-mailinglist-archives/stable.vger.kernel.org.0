Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268A14E3601
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 02:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbiCVBgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 21:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbiCVBgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 21:36:13 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7A4DB;
        Mon, 21 Mar 2022 18:34:46 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id d76so2247789pga.8;
        Mon, 21 Mar 2022 18:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=n2oV9MElGgYRSiGSEdNM0QHimJx4NnNNqG/E9aAlQu8=;
        b=kah8ETXcIea1fXwu3WlyAUHeDv0TiFZU/yVK0wznhY6mKd43gAb2USW/wLaQ+YViNr
         P1c/IuZ5PgwDJ9/dwJKTHtjq6RGJNhCG7dEcfiXH/jAqi9ZC9kyr27GG2+WvqZDXP5z3
         kLDFnz1tNBp5zs5dzT22ZWidxfMwcbOXCfuVC/z+mSxkqjktBb09hCaMKFfV1Pru2X/O
         araCUwWe+4jUYd0uEm6ZKSB7TXOTb1UdmzujVbi3rQYHLUqdSJFM8ti8mliwJmTkYCz4
         PiAEPfiP5bvtu6tokKWfIZFwXPBjDSa1lgtpLfT297iKgOK5W9wFZTpG1ybqj6u6xCqJ
         oflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=n2oV9MElGgYRSiGSEdNM0QHimJx4NnNNqG/E9aAlQu8=;
        b=Jn356R3qKhw7nywlEn/mPxe94YvEXvDcKi1CkWvHtOISMXKLkidwTuqdnc9VS2R4H5
         UdDg7Qteim64YMpgmUjA5bvYZ4H0LeJ87RS15IsE0xDVQANAHa5RLc95sLPQW/2ZQEYz
         vwZgHyOO2YOZL2mqzOpUpNIZ5ZTiL7FmBNae85F6cjRdAslgYZ5T4YP0OafnqT289w/J
         WTo8lvp32DdQZsDD4EsgqYN+FB9UPi6WJSvbgpm2uDn2qDSJsigbeMjduRL7gCgCtatM
         mvo6XmQodNscM1nAfwrP2XIlgaR9JQqTJPHmo8UX+y8LteE/7qDgFqZbektF8zhj59CM
         RL3A==
X-Gm-Message-State: AOAM5311ULuiV1nk98Amp5mMveS2ESSpH8j4zKdzcDVE7sxYYfXH/l+a
        KxquvuMQ2HBg9M/SzMhcyegDkhTMtz587DQb6uM=
X-Google-Smtp-Source: ABdhPJy4hfd7DLySPxMh2AOZU406wxkl64X2373nV/Yr5ew9MEdYCcgBqhNaJkjEoBhkeZrNreSKbA==
X-Received: by 2002:a63:5822:0:b0:382:34ec:82ac with SMTP id m34-20020a635822000000b0038234ec82acmr13675533pgb.99.1647912885706;
        Mon, 21 Mar 2022 18:34:45 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id o17-20020a056a0015d100b004fab5b95699sm968070pfu.71.2022.03.21.18.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 18:34:45 -0700 (PDT)
Message-ID: <623927b5.1c69fb81.f168d.44a0@mx.google.com>
Date:   Mon, 21 Mar 2022 18:34:45 -0700 (PDT)
X-Google-Original-Date: Tue, 22 Mar 2022 01:34:38 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/32] 5.15.31-rc1 review
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

On Mon, 21 Mar 2022 14:52:36 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.31 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.31-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.31-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

