Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BCC65BE49
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 11:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbjACKh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 05:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237509AbjACKhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 05:37:20 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A6B232;
        Tue,  3 Jan 2023 02:37:18 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id b24-20020a05600c4a9800b003d21efdd61dso22751527wmp.3;
        Tue, 03 Jan 2023 02:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mUIViT8791qts+nexw/1+egrl+ZnCa7TzReiRjS06ww=;
        b=GnDQ5l2G2OTnTgTh4hH030GOYlThjBkEOy8nGBFa0TEVdsjCykbjSP4IE91yJr0/mK
         dedCmMUvSvIqFqszD1ypz7QgwScD+hgKTQmJdVDgQnU2Thv1Y/4kqrcSI9+BDdML4+YI
         kfme0UPVWRH1CSkeOaxZcOCYuI6RWEB1nlJt/k3znarKHDHMq7wzrJYrYVb/EABkMBF9
         5nOFMSnZzG+x5onPULD/mzTS3dXZdkvvfqAhTS19eRMZBDuQ/exHNlLZMvuSx7+D89Cl
         07YaaqbK0tDk89vZ9aSnMg+vLn8xuBPHJWWPAUZ2PASLOsKktpznElDSVESUiEh10MBE
         /yKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mUIViT8791qts+nexw/1+egrl+ZnCa7TzReiRjS06ww=;
        b=7OdJeXIYI50n1ccbHy1PSqJoUuDVSAE1CXhNVyfOW+4+bd+8eNkMpFMSGVO3tkbQ3G
         +VR48AcTQbhgXk/vJMPyAugMBCRghfZvwiBQd6OkbKOHMgVv2nJ9UKM1Vlso61KONVCn
         xJPQgjJZR04huCDDx/wOk4nuVUO9LKlKGSysV8pMMMN9uJsh2gXY26O/iNp6e4GNOKIF
         zb2tKLhQ4GCet68w3eipC5L06pYriSGoQreqki3o5UFJZmS6MUaln+2+/VjJrapMqLAB
         UhdcHINoGpkqQT0sTnUfqZLuwk8VfXO/WmUVxpggGYh5aE5C0NlmEgypWF98Hc6X6Ksq
         A5JQ==
X-Gm-Message-State: AFqh2kqaWudX8jn7EcEEjTQOcu72ivaL6bkuMy/HKSeRCSlIehMfvSvP
        qUqrTufp4974awQQtdFDE3Q=
X-Google-Smtp-Source: AMrXdXv0IheT4f3sV3DIZkz22C9Fyt1o3xyEVBlqHUqDDLM+HPntFeYFdO94wriA8UsbktxlOdYGWg==
X-Received: by 2002:a05:600c:1ca3:b0:3d3:591a:bfda with SMTP id k35-20020a05600c1ca300b003d3591abfdamr33959996wms.27.1672742237317;
        Tue, 03 Jan 2023 02:37:17 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id k31-20020a05600c1c9f00b003d22528decesm50587836wms.43.2023.01.03.02.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 02:37:17 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:37:15 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
Message-ID: <Y7QFW7O0xqSYTzyl@debian>
References: <20230102110552.061937047@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
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

On Mon, Jan 02, 2023 at 12:21:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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

mips: Booted on ci20 board. VNC server did not start, will try a bisect
later tonight.

[1]. https://openqa.qa.codethink.co.uk/tests/2541
[2]. https://openqa.qa.codethink.co.uk/tests/2545

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
