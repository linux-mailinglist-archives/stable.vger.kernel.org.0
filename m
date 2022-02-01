Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959AD4A5727
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 07:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiBAGVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 01:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiBAGVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 01:21:46 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C392C061714;
        Mon, 31 Jan 2022 22:21:46 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso1648446pjv.1;
        Mon, 31 Jan 2022 22:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ONtDiP7sXV1WSLQd5CgaOI3IOh6DtrFS82TxpBOOaas=;
        b=XE7wmRCTuqQ9oZn1N8719BDJPEfL/od0fry0CO/V9n0I5JvIbxtVjV6jv4OlOaJoJ2
         KsTeabQ20hNZVbqmrjR6Y7JTTjbL/la8X6mVabAidX49Umc1WIW24LN0U4CYz8sKko/o
         j6F3mJaiKZWzcrAPLG2OranMKpMx8D2XAitVtHKIG8LuSrNCXWxRchXEL6vBgkmoUJ2e
         kIs0ADV5k8nPBUxdtPb2DZumGG/5c6QBTBX003PRGZs5vxZ74vLiKyBcAu3ZHMH0wdhU
         QO/FevawS9WASjTwkophgwdFLB1fEQ5Xwff2oJlUoikSfcUOOGiPTLVRjONtzspS1R6c
         BsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ONtDiP7sXV1WSLQd5CgaOI3IOh6DtrFS82TxpBOOaas=;
        b=rTO28RkH9Na8u1+ATzFUMnd53lu+mXOo8FMqHH+jMZA5DNqNKinR/DkewRqarWD8va
         fcXQDmAW+gNG0LQrh3lMqMQ4ipmNyek426CP95KntIqaXjFsoVaD/uyPSoJoidspaHv+
         +A4xDEV5+P7TArfj3FaD5u/0d3cqn8r1UOBAulMGltKUqav5ebwhZkscDC/AA4nXf1+Y
         F0rC25WZNUm6G3Bf35s8nc9B0y+ikjngfIRHSKhlEiRrD7moWu1i8tle0Cyg/CwyIC0b
         tNVKGHkCu+k1oMQOtqEM9SKkKf1dHrE3phlSWqpiOHdutTR+/dItt9j48DbXF1VtL+BS
         /z/Q==
X-Gm-Message-State: AOAM533dcIg8ccRn+DWoPtjahxIFW44UuSowwEe3J8a2fpgJKcnMn8eu
        R53UoQY/BmI4RdU/fFqxhDc=
X-Google-Smtp-Source: ABdhPJwcEPUqG/7+pfC8WdAkchxCJ28x/ZFvSrFeeUOvYsDtAfbq24wvKAu7WSGt9trKQACxdG7qDg==
X-Received: by 2002:a17:902:b681:: with SMTP id c1mr23883219pls.110.1643696505707;
        Mon, 31 Jan 2022 22:21:45 -0800 (PST)
Received: from [192.168.43.80] (subs03-180-214-233-70.three.co.id. [180.214.233.70])
        by smtp.gmail.com with ESMTPSA id t24sm22083645pfg.92.2022.01.31.22.21.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 22:21:45 -0800 (PST)
Message-ID: <40a528f7-7a09-a933-ff0b-889968409224@gmail.com>
Date:   Tue, 1 Feb 2022 13:21:40 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 000/171] 5.15.19-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
References: <20220131105229.959216821@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/01/22 17.54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.19 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully compiled (localmodconfig) and booted without usage regressions
on my system.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
