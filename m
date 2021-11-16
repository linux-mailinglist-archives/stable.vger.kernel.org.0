Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32579453815
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 17:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhKPQxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 11:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235816AbhKPQxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 11:53:08 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3906EC061570;
        Tue, 16 Nov 2021 08:50:11 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so2886673wmb.5;
        Tue, 16 Nov 2021 08:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hkl9GLVT+49W7M4dmZxynfDH7RpM4kbdzPvjtOxdvFU=;
        b=cQ/X5sHSVk0ycT0r2Dx2S1FCJ++2Xp2XIu5XilRJApmE3M+ZAE40jMn+T2tfvGvlFE
         D+F5ie9IvdbSRilth1ehPESUcnE3fMe/ZlnV0wbu6ELfi7WoHPa9ZfCOAkkRV8LrC/pv
         XNEWiyW1npFxb9ri8nvLkdcr1CPud6sl/6D2lXjAVak4HQLwxECTUz3TTb6UEiU6Dfr0
         CaToNVQuz79Sabo0jNAg9GiiLyiX30KugXW1xF+uo23yvh+/AWf3h8w7N4/dvUnl/KXV
         Fau38Iq7QGOWAvFyZMDtVGI4AqU8xxTcjTCnq4yR3RgkT1NZ6RZ4GxEbrTstcB53tVHh
         HVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hkl9GLVT+49W7M4dmZxynfDH7RpM4kbdzPvjtOxdvFU=;
        b=TCJI00d7JOAQn7iGmuvoQZjrobv/53KW0x0VjAGaoZoJx2iROBp6A4s41fmYIa4I3z
         nJVOjKLsmQ1jb9EJeDHXUAfGV8DV7yv2X22YY5YhVdOSnYtmB9lTFyq2iya2zxLSkNOq
         gUE7iafO5nvuFYhkr+FcXPep0GPkPBA1w0JAbHRRHDyKYr+Zfb0964Oa2z1SwXHD4VCy
         DRMQlscWiBKQZTDW9Zz5D74qpqpvAUTw5QDp2Ra+Spo0f47yRvA1Way+SZLmnz9tuQmQ
         +0eg79WxxIoN7nPW4i2rfiGOyz+fgJ9ia6RAnj05Og2vg0KIT2gZp4NlXjcq8kkM7QS9
         gSDg==
X-Gm-Message-State: AOAM532ZpLjZufiJY6CtNF1t41mkOqxyQYrdiP9MtE30M4y+zgCYBN7T
        EbyHEZD1OZ7PkZJ01wX5qPE=
X-Google-Smtp-Source: ABdhPJy8AsWrbQrIOcqZgTbMAJJLjJTU+7FjlnvZCVzMxEAYX0z3frH60hrX/TODUtBU5491wndn2Q==
X-Received: by 2002:a05:600c:2147:: with SMTP id v7mr9597639wml.36.1637081409685;
        Tue, 16 Nov 2021 08:50:09 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id i15sm3489634wmq.18.2021.11.16.08.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:50:09 -0800 (PST)
Date:   Tue, 16 Nov 2021 16:50:07 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/355] 5.4.160-rc1 review
Message-ID: <YZPhP6C6WgJ211oq@debian>
References: <20211115165313.549179499@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Nov 15, 2021 at 05:58:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.160 release.
> There are 355 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 65 configs -> no new failure
arm (gcc version 11.2.1 20211112): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/391


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

