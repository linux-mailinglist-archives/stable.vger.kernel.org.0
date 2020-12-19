Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A4B2DF1C9
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 22:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgLSVVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 16:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgLSVVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 16:21:33 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A41C0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 13:20:53 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b5so3460619pjk.2
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 13:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=QSYWqhjbVLmtclelJMJcDqpcy4tfKh9PItzr9QwLg14=;
        b=t4QMfoSS3WzTQ927xNBLfyET+0pEVkmYIV983Is/kxvlA4UWlPyNQ256aYi+hjHX3U
         Rud37z36FhvP7j0Ev2GAIsacdfqYyfKLB110OmtKPQz2/+owGw18RNdcmtiD6DEISXsW
         FXFiRj/hVa2GMAk/u7tbu3Z4oHIxQkCHB0yxMi/ASSyNXfd2EdvQUYSXu/monfjCWObQ
         0hN6mFl07a7bU2COr5Zk78fiNXwGLbLDvKwmzpj7U2Cl4rujW2ON1VD9GCfbiQHrKlXC
         3rF8G1h6hidcBQjsANyndmI3XPZpDavrRmH/N4c+chh7bx7tJCSWA9c34+ot4NYyLE4U
         2GVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QSYWqhjbVLmtclelJMJcDqpcy4tfKh9PItzr9QwLg14=;
        b=VG/301gO+46pFHTIlA4QXKtmjFCOTcLsNUgU7T9UMqUX62Wwfi05GfueZc/cACHL+8
         wHaIsUhhvBLEqtYINAwmsr2Y1Fp5JRGlSyb5fmeoUbMrvfDkHCM36/RfOhxSOQm2OfrH
         pT5rEFGYkdxuC2rlUFzIZ8RXHt2c26r0kZ9HUoISihxMpGNpr4HFZbr4Q+i9Rj8CYjOR
         2pt1eUuFm6jGdBpVnuSvQRDxzGFz8qahMOJjQAxtqY6tE+ZrFZoHCc1p1nnYhU6/5tmo
         WFJXWmeXK1YfOQcuUvpvkcZI4NSvrD8cnZw49Elxom9lqve9iCBGP1dcs64WT0tmEQ5J
         0DMA==
X-Gm-Message-State: AOAM530bu7mJJ1UDYZcTPD4zvTqBSc/m9qRVzFbLVmGtRv5nCwqCIAwo
        Uz651GxQqRUqN+6LdT6lf6EKqA==
X-Google-Smtp-Source: ABdhPJyrlaVa3wK/KDK5casWCimJDI128MQgspwVmtK93+4yzOv+5Itu5K9v2MqaOYKtP6KYsxjgug==
X-Received: by 2002:a17:90a:cc0a:: with SMTP id b10mr10430967pju.59.1608412852462;
        Sat, 19 Dec 2020 13:20:52 -0800 (PST)
Received: from [192.168.1.9] ([122.164.30.66])
        by smtp.gmail.com with ESMTPSA id h12sm12324474pgs.7.2020.12.19.13.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 13:20:51 -0800 (PST)
Message-ID: <4fd580a2a147281704e7ae5525a0d892d2307d09.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.10 00/16] 5.10.2-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Date:   Sun, 20 Dec 2020 02:50:42 +0530
In-Reply-To: <20201219125339.066340030@linuxfoundation.org>
References: <20201219125339.066340030@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2020-12-19 at 13:57 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
hello,

Compiled and booted  5.10.2-rc1+. No typical dmesg regression or
regressions

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


-- 
software engineer
rajagiri school of engineering and technology - autonomous

