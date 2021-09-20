Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E76E412AE9
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhIUCDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhIUBwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 21:52:33 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76760C0386F3;
        Mon, 20 Sep 2021 16:17:03 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p12-20020a17090adf8c00b0019c959bc795so1146369pjv.1;
        Mon, 20 Sep 2021 16:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=eNQBS9qfblRsdVqWYJD5x+d4uzCNj7MCyUPZAo2uzlo=;
        b=Seuo7VGOqHpbCnei1QTVBP4oxvEjox/bWM+gsFCQlYiYqttK+J2G6Fi/b3PJRII6m5
         NVtUG+wQZb6S+kdSzUaZ3MuY2MdHBNpcYKxGcmkz/oA1ZSK9BKaQtNm1YLoPVtTRAWo8
         LfnLVpbhNmESkJkv6bbWY3HgTaWt+h24ltZUAsYNkqZ/JoDfL+LKLRiBDt5Y0CaGzjoL
         T3vCm6Hf6xGffZ95IKgkoHAvyy+8AAKJ0x4LcJmZ+MhCfUrbaxvTHXIhebeDaAPJKpt3
         RzR2qxj57lZCUCX727NuzJd6iCsKDCMtCY0AKgvFFvcNbURpPA0CMkQAc3hqErzDSvJ4
         Ikiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=eNQBS9qfblRsdVqWYJD5x+d4uzCNj7MCyUPZAo2uzlo=;
        b=5/4Wm0nRznKI2y/xJfkJtPXaG+CWzbTwYRwVAJeXKM6NCkEPqA2bWy8qCASmrUI+Vi
         Grz8MHm8Cqlb7e3fclEisryVpoO2Q7JPHIgK0Ky3G7QUiAP/grr+1qoiNPvDlZlXkrHB
         W6CHwRgTBMw0FGcCg9lbcqYfHysOV5NbotRJzxk6HrBU5HO3ekab3SrX0t8ETmgeOzQY
         NjVI+GUBwD9zrRFNXZPSHBE2BiHGIz/Q8ojwFyLOViw7HKaLJWNw2mku9BEu30/gu4CB
         RyGxKQSj8vCANGv+FPUrMJmUTi7VOXpQjO01Y3xw9RQWhRP0pMqJMlunmpN7ukEz0Gsw
         ZOlA==
X-Gm-Message-State: AOAM532s8lzeYa+QT7H43LaBOZOT4uyCHI3fr2yk/JR1IToDTQJW/hFw
        /WauyoqMe5mULQcbRkREfv0VxJ7hrqx2fzCyKTg=
X-Google-Smtp-Source: ABdhPJzx5qKUH0MnMU3pAOrJOBfIhcDYEyxGfHhUsYi/6CJJfLHjEWnnpLC/llwNP3N90KFaU/eRDA==
X-Received: by 2002:a17:902:e80e:b0:13d:bb71:b1c0 with SMTP id u14-20020a170902e80e00b0013dbb71b1c0mr2477301plg.29.1632179822263;
        Mon, 20 Sep 2021 16:17:02 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id j5sm11191790pga.52.2021.09.20.16.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 16:17:01 -0700 (PDT)
Message-ID: <6149166d.1c69fb81.9375f.8f63@mx.google.com>
Date:   Mon, 20 Sep 2021 16:17:01 -0700 (PDT)
X-Google-Original-Date: Mon, 20 Sep 2021 23:16:55 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/168] 5.14.7-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sep 2021 18:42:18 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.7 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.7-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

