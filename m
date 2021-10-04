Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FF74218E7
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 23:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhJDVDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 17:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbhJDVDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 17:03:33 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9A9C061745;
        Mon,  4 Oct 2021 14:01:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p1so9507454pfh.8;
        Mon, 04 Oct 2021 14:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N9yHwJ+N62Bg8WWUllfyOyd8NA6iR+DUl1YGeY5PMO4=;
        b=PGRCQQfbTrLZDPXNeasC0IT/+MyOfLCzUL3utCvQxX/A1aH0U66DXtrxad59r1H66Z
         lJXj0GAe5iGDSLj2BQgQt/VSuJgFd4GS4+yG7knK85EO1wPTw/X6vG3cr6h3K7D9D/+u
         TY51wwcp30X4azLNze3cz6MuCr87j0XcppksfiAhYrOsuH+bMrm0znIkF3LEKFnuWi+y
         PGRrl6McRkBp0k+JG0CSoPAdlQtl5A+LoGMFa0ROBBSyvaXKocYODd1VuZXEr1YtNxjc
         0Bnn3p5/5Z2KqhW5UxQAwOczwZmndgobIZpseQ/f2U8pySQAr3rBllQkc5xMgN8YcXu8
         O1oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N9yHwJ+N62Bg8WWUllfyOyd8NA6iR+DUl1YGeY5PMO4=;
        b=mR+lW4JGgaUUo2q3X3ySg48LnpsDAV6YoNl6U4MyhxIAgauLjXP3pnq/YanLaVU94e
         gYxZtyfF9NvHkHxFZoUELPZLcOUf2v0BXmMGwKRTn4qyNBqP3Ro5EWWiacBMJlK5mWTl
         0vdNUjiUlmIBD1ywfTCJrlPbHrKZAsjdMLZCemLjL6eQo0vBqP3yLr+C+Sxt/UsVbOaT
         i4gW0Xf54AAa5IvlVCoUS3ybGcGPmAfKILB0BSkg7XYBL+FcG6laqkb/APTjB3LItAw0
         ko2fzLeaw79s9IIi0wLJbX3/+WFrt7+tVNNy2QqGZNhkODjt2DjvDE5DII0MyFDEmsex
         DlfA==
X-Gm-Message-State: AOAM530MwNOfAyM2/gkOJCfW1r2wQaBNEP2u9Q4sDCbX2+rpgcQL7NGH
        4aq6NPhK+3uWfStzbYGDAMl5BlHp2OM=
X-Google-Smtp-Source: ABdhPJxBfbiQz94cJuWW5L2omeJqMwx4WyEfQHJLrmWhm0JFjs9AplndKc+sdw+9PUkPq0k1QYRoBQ==
X-Received: by 2002:a65:538e:: with SMTP id x14mr1528896pgq.364.1633381303816;
        Mon, 04 Oct 2021 14:01:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x11sm14548914pfh.201.2021.10.04.14.01.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 14:01:43 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211004125044.945314266@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <090e7044-1ce2-4cf3-affc-ea25bf3eaa1a@gmail.com>
Date:   Mon, 4 Oct 2021 14:01:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 5:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Similar to other comments., this commit:

net: mdiobus: Fix memory leak in __mdiobus_register

has since been reverted upstream. Thanks!
-- 
Florian
