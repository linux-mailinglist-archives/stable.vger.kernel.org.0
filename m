Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861D54AA198
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 22:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiBDVIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 16:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240464AbiBDVIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 16:08:53 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB62C06173E;
        Fri,  4 Feb 2022 13:08:53 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id m10so10004198oie.2;
        Fri, 04 Feb 2022 13:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O/re/z+mpmmnmAI6J2bASUDjPz5GB5nbzcNvhdONry0=;
        b=N1HpGYbGwfuPF+PEELGHwyFQKcLei2cZwibRsuADwTlqy9Mg2T6P3oQfNJOwDnPGvF
         aeyc/Tm5W3JvUd/6T7NnDmrS4xAXxOiEH8cD3jBUDD13zl20Fk5TBcB9HJFP6bevhMhU
         8Drf65jDnWoYTWKH03VK5dJDep6b7junqbqy0kFd3M5O992o2A1ovFMvpevoA4wkJeEo
         7ChuKVFRCWrzyKQbeu3rhzFLzkLtr3rnkUBnkMDYkZsWnxxe3GPDHA+R460Aam4CJItU
         BMSxNhRNTZ/OVnyFkzRSm10RTKNhiUB/kzc1MFleK+UdhjQ9sCUBvErQzHaSplfZ3eCN
         kEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=O/re/z+mpmmnmAI6J2bASUDjPz5GB5nbzcNvhdONry0=;
        b=nqBtJ/YnHRtbFqZqh0VpUjEF8UKwV3trQ6mXXnYzH7LM/U0AVcppXN0pAL5wK4dSeS
         FBvrNKbX4wzBY5chw7p91MWFYmUgJuJGW4Nc6MqxUx+b7q5/yRvEXC2ae0nzRbWzPBv7
         a2QnGDQDdQ4NA+FUoZhb5jDcPzjEByMK/bX6rPmXwDazxFctdJsaFzQdLlApyGPml44T
         rr+z6ZBVPoH8xeXrPOOkwvtoEnGysBIO5F70cfDXf+wrbPY1akWJ+9p/NM5QaQNlOFjX
         IXyJs9JBvjjgR4TBI73tz/T+dMwtvvjWDdI52O7KMndc6emNAroUB9/GKVmociiUVMpM
         cDAA==
X-Gm-Message-State: AOAM5307bAtEA4Xn4HPUX0A7Jbnhcz5efrt/BOE5eeuf3mqn3lWql8OG
        7UztGyVDpw7+/1tKrgHnbiQ=
X-Google-Smtp-Source: ABdhPJz03KdOrXsws199fSZiarQj5611e9ZSJEw4KTNSPx1cqahiHeMk9Tcd8wHqP6dWeRurHT3zmQ==
X-Received: by 2002:a05:6808:11c7:: with SMTP id p7mr468074oiv.34.1644008933084;
        Fri, 04 Feb 2022 13:08:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id eq37sm1030716oab.19.2022.02.04.13.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 13:08:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 4 Feb 2022 13:08:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/32] 5.15.20-rc1 review
Message-ID: <20220204210851.GC685902@roeck-us.net>
References: <20220204091915.247906930@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 10:22:10AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.20 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
