Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F703DB710
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 12:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbhG3KUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 06:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238352AbhG3KUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 06:20:25 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA53C061765;
        Fri, 30 Jul 2021 03:20:19 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id g15so10669120wrd.3;
        Fri, 30 Jul 2021 03:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QICAhMmkVBelTWVx0cnc5wbAKhBBOTCYwVg6EWlbtGg=;
        b=XTMPqaxEGQkxIESGtBnIVN9CGNZc1sWABGlAA0yxu38cjcRu2QNkySAasQZAeaGTdo
         C/pkXaZZ5uvm77q8H7HDzLXzMSBZ8hjhnVuYGHeT/pE4YwH8btzbLC4zfAgUoVQGKZ8z
         Hbhm7ier5yAyYaqDLSo8XRo7IOzAn6zi27tSfSWUbtw1J1E/S5jPm3yEu6PHVB/WqygZ
         CpduwcYZp22Ea/xVp5mR2gI2aKGVZAFDeXrqq3i4rUgcTmGaiQgn14qI23IS0sznuh8Q
         R8FxzYzL4AYGRrGRszCZbvi+gBftpnWs0CPUqBoJkslfcwID7d5H3K1500pOxypTe5U2
         S/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QICAhMmkVBelTWVx0cnc5wbAKhBBOTCYwVg6EWlbtGg=;
        b=jmF+F3BF7/K6svTSFYFYCGSnGc8ZADMpHkTj0tQl9HY9XBs0eKJ2igobOjZHxXkpK8
         AzaaA6lg0efZMa4v8W+UC7rgm95ObGLJ33r5Yl5O9fWH2Fh6lxY1ZsoDRgIbBb80k0aQ
         9C2rCsA2x38qGL4VVUbwvFElhBCWj4uO1vr9zOeEJdLUiFxvBOgztEWI1nKDRheIOffz
         sIPUZj25tQKXUILHbU1Mtx1w3lk8xKOtl8wMeCrudXLrH14kcYhnULFM38znl7IJmncL
         j9DK3mkxK7D2CZMwHHuKv7AvK5i9Liooa8jTrkwXH3xRDBQ6WOxTYtIAZ12ureHJAWeV
         VOMg==
X-Gm-Message-State: AOAM531zByTan7GOgybreLsHdl0iC75Iv1B9g8Y7ToVicRjVkBi6YAG3
        2FA0smY+6BxYGaLeBmyqAlQ=
X-Google-Smtp-Source: ABdhPJwt9X51Fu0IdE9GbzSnpWRw4j1Re4HV37vXaw3Ljbf4oLoYyTBt18kVsZbCbZ2jACx/l50iJQ==
X-Received: by 2002:a05:6000:1201:: with SMTP id e1mr2125214wrx.379.1627640418348;
        Fri, 30 Jul 2021 03:20:18 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id v18sm1201045wml.24.2021.07.30.03.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 03:20:17 -0700 (PDT)
Date:   Fri, 30 Jul 2021 11:20:16 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/17] 4.19.200-rc1 review
Message-ID: <YQPSYKICaEckm+ke@debian>
References: <20210729135137.260993951@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jul 29, 2021 at 03:54:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.200 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 63 configs -> no failure
arm (gcc version 11.1.1 20210723): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
