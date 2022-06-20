Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AF755265D
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 23:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiFTV31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 17:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiFTV30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 17:29:26 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3250112AFB;
        Mon, 20 Jun 2022 14:29:25 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id j9so3974506ilr.0;
        Mon, 20 Jun 2022 14:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=bLsi37feRIDrIrL8QhRCbJ9MTM9afnBNA1o8C1A8Fyk=;
        b=HPqUxrH5Jzht/dhmssnhD4G4uRE7RzTtHwlXmUJFDlfKhP9j9NgzwwnEHD61Qg8fCV
         y8DkpGjxKdUInlOVeYn1gih2b5wby7V7czYxUFHDGPLc6zyU9fZTaTVwa+nQLcDq8jC4
         S+q2nOGDtKugPuLLSeiL3hr0IDri5hBUXeqC6J+17dtRxKYeEosQYwvnJsxytx83Ikcb
         aIrXnMFYx6UhAc+8WB84AmQSBKiuF9/pqw6nfWmGhHDRLZxcn0dNphKwultI/G3dD0eE
         7FoFaoV+vdeBkbaDDrH3msPwY4dEpJtkOlRCBvZpRvRc7ZMcvIKF0xnI0trJDiyuEH1g
         1f6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=bLsi37feRIDrIrL8QhRCbJ9MTM9afnBNA1o8C1A8Fyk=;
        b=QFKG9gyd6aJHFStQvcLe2PTxf8TeFR8EtEusjBEhecvX96MckZwZiV5XEdKMEp4Ar/
         uSr9k2lrtxEdF31eto7GW+qobDRQF5wXEvgRvXpOr6LHG47VzCyyh3OsJnecGBiUsGEj
         8gpoH9sAOLTOvVgS5eWhWhIzQE2aZL2mDj0zMLP8K9TArOUS197DxAApcrk9m7PuGOtX
         EzLrcDf+w6TnOJ0R6DHFdK/NE6AHlcgURxhIDfLXZvN9lVHlucYBUR/io4kz9zqVIu4d
         t6K0tZ5Biun1Xgb3YryW9yOMcTSKl/Pp8egNCQzyUU7t5BA62p9GK88huv2uwV/gusaa
         ISWg==
X-Gm-Message-State: AJIora+m1W+/gFlGnHJS0zWBFvviWJ+NqfUilvmLQKBswF3OAITZjAT9
        lriDB4nIQx9M3mOHo1LIFNU76PYQnVOzc0h6
X-Google-Smtp-Source: AGRyM1u1tHNe5GW6jHjLuhlxZ+OhM8pFiWzQFI1eKi7EX92Mur3ZVi1O77qwFdp1NEZtg3D46zirwQ==
X-Received: by 2002:a05:6e02:2185:b0:2d8:f742:b276 with SMTP id j5-20020a056e02218500b002d8f742b276mr7497061ila.140.1655760564199;
        Mon, 20 Jun 2022 14:29:24 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id z5-20020a05660229c500b0065a47e16f4esm7383991ioq.32.2022.06.20.14.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 14:29:23 -0700 (PDT)
Message-ID: <62b0e6b3.1c69fb81.3c985.92e4@mx.google.com>
Date:   Mon, 20 Jun 2022 14:29:23 -0700 (PDT)
X-Google-Original-Date: Mon, 20 Jun 2022 21:29:22 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/84] 5.10.124-rc1 review
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

On Mon, 20 Jun 2022 14:50:23 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.124 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.124-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.124-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

