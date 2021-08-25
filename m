Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3568A3F7D29
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 22:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbhHYU1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 16:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhHYU1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 16:27:52 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2022C061757;
        Wed, 25 Aug 2021 13:27:05 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id v20-20020a4a2554000000b0028f8cc17378so203167ooe.0;
        Wed, 25 Aug 2021 13:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=akaDssGlmLQtk/FAqjYPDNsRFEJf1Rdkc5QN+TcfVI0=;
        b=nkwZYo67O3Ij0m7dAmEu5MwK3e03/yH1m6DFv/usN4TGyr5us7hKS3vI9hFYKzdAHm
         swDNZG6ntH4fCZT6q5EUxzyUV6olEwmMm3DU8+F8gOz8/BXles0VUiR2BFakNtxUsl4g
         WuXn2bYFOH2UhApmTE6/RcqbOMM70ilrZ5kH1qT9kEV+xmFv3LFcZ84C2yJaW3lr+GGs
         YS6M9xoucL7Nx+JAneIhVJ3wfBm/m46lVPUAkhAUv/qzk1KaCuQRCE2IAedy27QrNjPl
         Zx5UMrpimPFlqgVKFtqkB9/oANs6g3B0xr0IdXMygGjO9BlL2rB6Dn0CrSFaOxaKW9kk
         z3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=akaDssGlmLQtk/FAqjYPDNsRFEJf1Rdkc5QN+TcfVI0=;
        b=oscyRGrpT+RTU6ykHjs3BVxL0pIutlbQxoMJolHdgL6PkjSqL61ih2+FUzyZblrTge
         CzqIS8UEoYvB/sQP4jJqitfKbcihTMsUO2qq1zAK6i0tqk21XahHY0kgRGLkLQrCAMfi
         ctR9nliZqXL3t8GyWdnTPB9CLMCS/i4FRf313X8evH6l6W7pZVzB6VIzYi3mZZnxiLnG
         AaMLYr9ee18uj9nhd8xs+KJFihhF5DTR5fj5BKPCbRM6BLVA6j9oH3shXk8SYZIeUOoq
         2pqde5DDNuccg1058Sno1T0CCsiSkhF4NhctvH5yAVWU36dUN+ane6EUjx4j+hiyalzn
         fa2A==
X-Gm-Message-State: AOAM5337tYPZW/47yO9LCHuRz/dkIk0cpYMHyKxMQDjuLsX1b5+qc3Ss
        tKeqW1OsavOUgcR0D2dukdVosUPikMk=
X-Google-Smtp-Source: ABdhPJxTL/hZizdWBJ/4INWmcSQxDrSSie66W/Lf9DTPQZO1gWVbZqkjCN/BQYERT4FWWA9LwSq87Q==
X-Received: by 2002:a4a:d752:: with SMTP id h18mr141154oot.13.1629923225083;
        Wed, 25 Aug 2021 13:27:05 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q5sm180572ooa.1.2021.08.25.13.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 13:27:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 25 Aug 2021 13:27:03 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 4.4 00/31] 4.4.282-rc1 review
Message-ID: <20210825202703.GG432917@roeck-us.net>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 01:07:12PM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.4.282 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:07:41 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 338 pass: 338 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
