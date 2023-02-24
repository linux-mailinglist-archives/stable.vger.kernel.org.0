Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0A56A1B4A
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 12:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjBXLTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 06:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjBXLTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 06:19:12 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765B41689B;
        Fri, 24 Feb 2023 03:19:05 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id p3-20020a05600c358300b003e206711347so1546114wmq.0;
        Fri, 24 Feb 2023 03:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tGKVuSFSyIN+VYM66MS5xfSSck4EN9wYEzt34f5JQKw=;
        b=mbpUlxIaMa70rNVw3Md4WNc09iKHmlkQCkPddVUBT0+YOJ/yAxJxXxOIaFN8SyoQm0
         mDcSt5M2nz9dvoAcv+O0r0IwPAJZfEVqg7x7Lls+5el+UN7AyLVLSypjY2AQ64NOKG/O
         6l1Pg9nWe0DtZTAQKG3FfOZBlmldflIW3Nop1OvHkS3Pb2wz0BqK0NYrG5G0fdbBnSvs
         wqO3ZD1CiEUfs7GE2/MWARsSiGRvgQewZP4u1z1W0D2Ip2L5dgQyrjQCU0v55ltbqE4+
         +M6GaEJhTSDKSWkdYMPFzwcUOc3bFWW1oRJJRwi82UPdp3PxkK4mxQInN0ak0IhMZMnM
         DHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tGKVuSFSyIN+VYM66MS5xfSSck4EN9wYEzt34f5JQKw=;
        b=XQOiT4uMnQKpwALt98Kw5IFttX84+0s5NrsyRwBcZnK1ROJzAizk1gCZmzaWxSeCW8
         EVU7LZ6m+hpZigTak62xIfdY7kpYLkUn50yPa9DTZybo4W+6KC27O7/FrN0eXdn3pZHn
         PyUrr+xuiH56jQJr0j1gUrIik77f5ayaTSOiWy/QtkadpbLTk+p31mKb/Q8hgHaAACwa
         Tv4zSdqAFvc/jnA1zTA6UmLvc4dn5Ik9mt+IMhLGcGIosdKfUkDXcNr/apuZvMFATQs+
         +GCbUFbr4AyC+Bcj2kMSOArqtjJYPa7tdAK1oLEBR4VnGo1bwbS0eivdC5XqC4WVFRBc
         C8XA==
X-Gm-Message-State: AO0yUKUij2Q3egDRiPrwUDWHqs9G9RxOTcqtuDfI3vgwl2aTNZrlFxLS
        USNRbla7ZyCY3emQgP2bSefhWCg1oOM=
X-Google-Smtp-Source: AK7set9016shcJwzv1sEkMvRXsfcVre9z4DYTDp5dJ5uyQivdg69nbvGWEM+K9Vb5w7ajvlRu5CpmA==
X-Received: by 2002:a05:600c:3b9e:b0:3ea:f6c4:5f26 with SMTP id n30-20020a05600c3b9e00b003eaf6c45f26mr2038589wms.17.1677237543966;
        Fri, 24 Feb 2023 03:19:03 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id l1-20020a1c7901000000b003e2058a7109sm2451956wme.14.2023.02.24.03.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 03:19:03 -0800 (PST)
Date:   Fri, 24 Feb 2023 11:19:01 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Message-ID: <Y/idJSMkcMrmTg0I@debian>
References: <20230223141545.280864003@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Feb 23, 2023 at 03:16:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2932
[2]. https://openqa.qa.codethink.co.uk/tests/2934
[3]. https://openqa.qa.codethink.co.uk/tests/2935

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
