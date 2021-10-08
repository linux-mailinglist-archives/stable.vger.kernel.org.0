Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6831F4272C6
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 23:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243299AbhJHVF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 17:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhJHVF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 17:05:28 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D70C061570;
        Fri,  8 Oct 2021 14:03:32 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c26-20020a056830349a00b0054d96d25c1eso13122046otu.9;
        Fri, 08 Oct 2021 14:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tNXfzrOqjsCTIcyBmmpKyVQVTihwPgBjWhnJI/vLWcs=;
        b=Rs3bk0xHqlYeo84qK3ouD5iqnQ0kRzOJM3a+PWuUzORY/HKVI/0H90D9MrklfyH2zt
         YjRfbm2g92HRj6VxvgslTqIXmFRcp9yYnPRX7ZMG+iM6ArezduEvYVlBGKinXWB3Glmf
         diEMCfRltcNOXZsIoY3JyOe4Wbmfn/Y3x1FxbrqO8KJj7l47NHio6L/H7u+Pf7yMeefS
         f8G6wMJMpKv2apdcSp6+i8gMPmlpCT2f4kI/bl91/ZqNC+fM0AyvSGvsGQ2prqLiKuM1
         OvOVvldzPl7yAx2Gn0ulmiPaACR36oSHxq0ou7JL47pZhR+VPUNU/ojV2vy+0YJHZlhs
         ofCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=tNXfzrOqjsCTIcyBmmpKyVQVTihwPgBjWhnJI/vLWcs=;
        b=WJJU/cMjwQptxfIzt/ttLm5KpeWSwbHZHAcl5PS2m81c0Wgnk/QI62lyX+EB0Wdduf
         xcKUcjFlKAUXMtv+8nv6h4qlGm7QUwpcIYlyW6ubQThbVWsUHd35efJu+86OGHXPxwEW
         b1PGF1Pp38nOixqkN7pfTiVdQ3dxmjPPfXhoNszVwhILrWItxVM3MD8S2VCko3AUGlHf
         EsuqFfWIgqQVcSpGdgS3nEBI8gYTS/WfG1b9uBXUIPqui8X4Y/NgA1IiEJit+trbw8Vo
         Nq2bUheG9iaqJlLv0yyWxgOVS4yBdJKUJiaQkv8A7dspyYljK2BIDsrJa3LrPh+Z/KXm
         uRJA==
X-Gm-Message-State: AOAM533wViRddyygSSVDSoiSsg9Iq4kK5mHq+1aGy7PNtzlbIWAQdnoX
        bHxlpey5Ff+O+WevBiXVP/A=
X-Google-Smtp-Source: ABdhPJzchv08Ed8C5VNBYmbOr1G5SI+tjGG2BPw1wUPyYQwfgcangZWgz22OPeh5pP3vRhotV/F69A==
X-Received: by 2002:a05:6830:114e:: with SMTP id x14mr10550630otq.222.1633727011891;
        Fri, 08 Oct 2021 14:03:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r24sm101047ota.0.2021.10.08.14.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 14:03:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Oct 2021 14:03:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/10] 4.14.250-rc1 review
Message-ID: <20211008210330.GC3473085@roeck-us.net>
References: <20211008112714.445637990@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008112714.445637990@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 08, 2021 at 01:27:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.250 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
