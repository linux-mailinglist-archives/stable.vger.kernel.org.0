Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAE04DD1DB
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 01:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiCRASw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 20:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiCRASv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 20:18:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3E82D6CA7;
        Thu, 17 Mar 2022 17:17:33 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a5so8207713pfv.2;
        Thu, 17 Mar 2022 17:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=qebUdgFjM5+Hx0YB0YMaZpuJiqQ2qPKiktA5TFjAZro=;
        b=aDS83qpURUkLXxa3oXLnf4ZEZk+V45Rqd/Ej/4mjUQhqE8Hinc6vcnp5oUrHdf6QbK
         mzh5q0j9sgwisUmwXi3H5/7faVxUALLb3wPX9XGrzy+sR5eBPluzFTzVt7scDNG7VOWU
         Zo/Gh7KD7Rp46Zbw32r/daVsWAmnCPrkmH7bMg+5YCOMKf9JCRSrMAWqJv7BHZWeNRQn
         hPLr8Hp610CTsDn5zRX71KEiOTNtC5Ht4jxKCeI3hmIXPpwxFQoN8VrODvPJUq/ItnyD
         oxuCbo5KW8+6q9m9nJr+Cgw8hCxGQEILZpT7A1ZzIEAWKxwMF82GvICeUTJ8SmkDJZQq
         uLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=qebUdgFjM5+Hx0YB0YMaZpuJiqQ2qPKiktA5TFjAZro=;
        b=j2OTBeZsqG1JaoU+qlQiNhzUoHCbqcT8TK04HLmnkPMu0WEbreRW/fDT/BmDp6bq5c
         mj1ZjdDoQWFlUWY6T2rqzGWIS0Czji9i0auwyqIiVJwH423HMsPVbo9niOMVYgVwj7xx
         Qf9ZZHn8YYcPJ0EAheXcnbqCWpYCX3PYaSp4EJXig3UIgZja2CX8n4SVu9lp2gNAnpxH
         r1HtA1aPQ7Y1qPs/CAcC5vcS/rO7NT2eNplP33wUdc3PEOQpiN9c3dN4K6442feQwruf
         ldf31qwuWY+t4WDxTBWo+ErwB9TKVU2CZUSNiONfrJthams2qgBNveod22D3OI9TMHbb
         yt2Q==
X-Gm-Message-State: AOAM532jUE/dPa1pkZMiKs957KsREbQ9WR1NA7xU6WR1Y5eISxVYc8hd
        Yql2YI8gFnk4WuzX9gvp0kotYloWTpgbyOeI29k=
X-Google-Smtp-Source: ABdhPJxsiFRIcJxJw1QoLULGnhPPd8lAeWxz0P5x5mNMc8r41NZw+j0oQHKk7BGM0UaR2EfIJy0p7g==
X-Received: by 2002:a63:2d0:0:b0:380:b9e3:fa1b with SMTP id 199-20020a6302d0000000b00380b9e3fa1bmr5654185pgc.43.1647562652778;
        Thu, 17 Mar 2022 17:17:32 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7820e000000b004f7134a70cdsm7091583pfi.61.2022.03.17.17.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 17:17:32 -0700 (PDT)
Message-ID: <6233cf9c.1c69fb81.877f5.41dd@mx.google.com>
Date:   Thu, 17 Mar 2022 17:17:32 -0700 (PDT)
X-Google-Original-Date: Fri, 18 Mar 2022 00:17:29 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220317124526.308079100@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/25] 5.15.30-rc1 review
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

On Thu, 17 Mar 2022 13:45:47 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.30 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.30-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.30-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

