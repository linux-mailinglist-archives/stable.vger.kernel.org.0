Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F8942AEA3
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 23:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbhJLVTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 17:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbhJLVTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 17:19:44 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91418C061749;
        Tue, 12 Oct 2021 14:17:42 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id w12-20020a056830410c00b0054e7ceecd88so1046399ott.2;
        Tue, 12 Oct 2021 14:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A30TN9X8JcgX7nuRlLGrE6qPYiu6AkAkpplmawWA7Xw=;
        b=PzZGTJ04UyfHi8IlsgI3YGNa0o+C1DYL7wGakgP8hmZV+kwd4H3Tuj4BeGAVtU43gN
         lP0BzcKQAoVg6Dc/PCJH/DBlH2dW0wQNUDtRN/qsEFTFHj8aOGZj9oiVhaJ1qiYuYNfQ
         w+7A4J9RpPNTtfU9I3+K5A6zWTvnh9FfBCzfhNOLNiBYujsmiJpNp0tavfZgbR9UXipL
         i490JVCVtG60NH6W4Qjof7QiYeeNXYzwSCwFxxRg1p26eC6UbGfW0fSAHcsMdS5/DPwU
         XFq5p5GFHoyms7Ya+MP/kLx2I7QySEYPtAz+uVkLsOENvuDnaEcxStlWzsZdFqwB2e2r
         cnew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=A30TN9X8JcgX7nuRlLGrE6qPYiu6AkAkpplmawWA7Xw=;
        b=0fZE3m03UU/TCbB2vrHYgWGrM8vZi+Z1b+Pg4p9veajSHCs2OypefR9iFcWnF0F+m6
         Kw4lG86H6r9YiTL7MQIfolJJYq6h98ueC8WUbgjY3Z3f/Dq02PzQaBI0XOEQOlixuwD9
         keT0AWIephs0dm+8EA+qfl7TzLILcCp6RccO3Xu+Hut22EL3ABVqmI54vjnAB4IoTvVA
         9cFleDNqoekg6Xxwra/qNgYUzCuVKWy3kOi69FROQCvSqwyhya9ctR+22Z8PmSTfMxnZ
         YrH2NehnR/8C5e5XvdxI8hpS+InO6FEwXP+mmQmDv8kLtJdZx8CJ4dAaGCnuLMkag3pg
         dYYA==
X-Gm-Message-State: AOAM530TnYmyY4/yht7u3I7gTpEbrnEdSq6E1ZWrQuxdGs6r4J5O/6am
        MS131K0Hpx9kd+m0Imx6Pxo=
X-Google-Smtp-Source: ABdhPJwP6QzOVjnonRsj/gkTq8g2fyswxd0vNlGsBWdw8NPKMZGtEULKKXplT4xLx6QjWrbVaXfcFg==
X-Received: by 2002:a9d:6088:: with SMTP id m8mr14857424otj.214.1634073461980;
        Tue, 12 Oct 2021 14:17:41 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l26sm2034224oti.45.2021.10.12.14.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 14:17:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 12 Oct 2021 14:17:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/81] 5.10.73-rc3 review
Message-ID: <20211012211740.GC646065@roeck-us.net>
References: <20211012093348.134236881@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012093348.134236881@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 12, 2021 at 11:37:11AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.73 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
