Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBB33EC244
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 13:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbhHNLKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 07:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238221AbhHNLJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 07:09:58 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199FFC061764;
        Sat, 14 Aug 2021 04:09:30 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id a201-20020a1c7fd2000000b002e6d33447f9so875047wmd.0;
        Sat, 14 Aug 2021 04:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UZ6D9s7xwlNnsXuRAJ2E+vlk3QiSgLfdu9NGkH838Ew=;
        b=mLg1pItM1UD1mmy9cuCS16xf+9ymMIG5/yJ3EjleVby+Tnds5t/aqwkCJcvxzx8d7E
         4IxChCBURe9XB2nkoBYWyl3lbE281QiyWCeArDzIHrmL/39ZzuIle9lygr3GqN0PPqPy
         zFtZ8l6k+8j8Mx1p8j8iCdT5cOTSKNVdhjHePiOST6U3f3NZL5sL+4U0LbD8TF2Ih8B0
         D/tDzH7knDht5fF6JK2/w/P0ApFj+EqqtsrsAEC7EnTA7zFN9uBv0oTCQqaMWTGZfFy3
         rvrwcc9bKevBrO4oY4gfpKBgeiUtzWhty+vYbJI8jEM015GBXHmF4vAh84EEpOyL/eFQ
         Bf9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UZ6D9s7xwlNnsXuRAJ2E+vlk3QiSgLfdu9NGkH838Ew=;
        b=VklsCkjHSL/pzx2TGJQ3rqkCRNdCrEfiTS+q3/Yf7XNVt8PI8dh5R6VNRDMlw3w1me
         F5pl3IMaxQ3LMQSN7FBFK4kfnx27ru31GjWVL3mTmIwVSngRu6rBViaKrPJ2N2ICiDT6
         rgZQ8k94XUIbrgfAxsLD0L5lpRjlKbzvAAEiBbul7fEn4STYylP7tkPMbbx70n+qNGzP
         4E8U0jiUejLqp80i7IW+HeBSpNB5mo2wSE5W1Xlb2RJD/z1igl4Jnwp0FN7Af2fNSenN
         HT3dKIrRib4G0z3WATNaCF0RVFpCmEMU+MkeMEchghCXNJ+x/APOYi/rszD0QK5Wha0E
         QmDQ==
X-Gm-Message-State: AOAM5324hGwH2A84RaBgGQhJvIwNEoe0aC5PAJnuGLccM+Jd8yx2LUAR
        eKGN4/CRfKfQDeSZYKyRHJE=
X-Google-Smtp-Source: ABdhPJwWGCbz5ao3jW7elRwVJEyd7SBqMPEhF1ULfNvDkCfnDJ04tcu1iKxwJ8F595P3S6gCwVc+hQ==
X-Received: by 2002:a1c:a543:: with SMTP id o64mr6542072wme.13.1628939368685;
        Sat, 14 Aug 2021 04:09:28 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id h126sm4143799wmh.1.2021.08.14.04.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 04:09:28 -0700 (PDT)
Date:   Sat, 14 Aug 2021 12:09:26 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/11] 4.19.204-rc1 review
Message-ID: <YRekZuS5KchudVlb@debian>
References: <20210813150520.072304554@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813150520.072304554@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Aug 13, 2021 at 05:07:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.204 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 63 configs -> no failure
arm (gcc version 11.1.1 20210723): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/27


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

