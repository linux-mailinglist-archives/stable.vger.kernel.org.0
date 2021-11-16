Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B28B453B86
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 22:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhKPVUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 16:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhKPVUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 16:20:09 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83286C061570;
        Tue, 16 Nov 2021 13:17:12 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id n8so295172plf.4;
        Tue, 16 Nov 2021 13:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=wSDMazeZkAebuDljXPs4HUWSPpcFE2DE9iIv6e/lwTw=;
        b=b4AqSAYza9vw8f36W5PwdkplhwMKLvnpo7+5EKkQTvrlM0G+Q+jlVeF8ggRFMWzmOY
         wL6jonCw/NWJ+5yAFo1xEvp/S0le+Jka/VHqILvYz9xTKTThgOGPlbOblc7jv+iByh+s
         /nGzvYgkBCH4IsZzm/a3w8bqPnXULBMvf2fG6nTD5UHTzOEqdaVgAv9gS9Qu3haet05m
         fuDAqUNC4c8OCUIdJfCgUHkwzbS/4GF/Z0PEVizmo8cABtbfWhZbYkhrdDFp1md+70yw
         bx7HZ5brfuX/qV1CNVXGzEhZ3g7pjtBJ/lpx4caP96XQAyquZWGT0gGyTaaaDHDe7AwL
         Pw3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=wSDMazeZkAebuDljXPs4HUWSPpcFE2DE9iIv6e/lwTw=;
        b=JTJgoUBLZM7oBbZ6LsqRrxcwm4E/Ie3XUJvYtlq7DE2hdMRp8LFxpiGprRaHyvTuXk
         1DSHgojm/wHFkXL/9CKXxv8Og/ttaOJjVARTx9Oe+J4LdbL5RcfoAtSR4zKe/s69IvQ2
         2K4eWEhUM6QGbKKtBhaVnyhRcFgrF+i5fflkIIwKI6pmVfH7ULfJv1lIaD6/eHLQAEPD
         NYcOGvHIrSrUAnio4ZSf0L5nny6QFZngYi4IVVqIKYsvz/dZazkCWrVia2Wpazr0qeeu
         xQMHnwRIeFbx0P+LCRfb2k99CGDh9tuoS2I65WIyMwM9ooVG/GvrbohrC1PD+IGxa4CR
         w4og==
X-Gm-Message-State: AOAM531RFiX+IVSx4iSESgcGjR4BDoECT2bIJsF3iss1zgGJGP6QYy/S
        pNo//zMRS7kmQS8yNiq7xNcAHKO91SVx2xDness=
X-Google-Smtp-Source: ABdhPJw5QxI3UVbtb1W6sHzO8go259COcixGDGxeX8gsLR+SpdXIH129d8yUWcebIxzgtO7PRLYB5g==
X-Received: by 2002:a17:902:a510:b0:143:7fd1:b18a with SMTP id s16-20020a170902a51000b001437fd1b18amr49031525plq.2.1637097431188;
        Tue, 16 Nov 2021 13:17:11 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id m7sm14904953pgn.32.2021.11.16.13.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 13:17:10 -0800 (PST)
Message-ID: <61941fd6.1c69fb81.623bd.becc@mx.google.com>
Date:   Tue, 16 Nov 2021 13:17:10 -0800 (PST)
X-Google-Original-Date: Tue, 16 Nov 2021 21:17:09 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211116142631.571909964@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/927] 5.15.3-rc2 review
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

On Tue, 16 Nov 2021 16:01:11 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 927 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.3-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

