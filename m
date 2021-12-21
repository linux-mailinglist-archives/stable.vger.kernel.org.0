Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA6547BEC3
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 12:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbhLULTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 06:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbhLULTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 06:19:12 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1414C061574;
        Tue, 21 Dec 2021 03:19:11 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id a83-20020a1c9856000000b00344731e044bso1853379wme.1;
        Tue, 21 Dec 2021 03:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9VEVIxWootkLFdHlqMO79BwCcniF3kvSEBlxJFgQGGI=;
        b=QiIQdXavPUWWP9Sr/EovjzkqFYr9iy1bFUlsTZv5CjzCXu+RfCoZpcEMkDGAZhl9Nw
         OxccapTlQnefpsCHyk9G1gtOGj6sTSlQbrYQ4XKtoQZW8+wEQRNTJepB6jfVcyHVJKL4
         LxqufSjvhEk1QEwY77z6DDthS8xJo+3HYfUni0iU7WeY4vUp6nOvR0EBre4JCINhgFGU
         eti/lKzXJQOXZxHgqa2CIx0n+PrMnMkih4xWPlX8YrkdlTYQ1LipXuuyrK06vTlLc+pO
         WBHsRgUspEwx/kIuC+2ra8I9p9xCS1m5jtBn7zCSeJxI/RgI+GtCpkjEmOTnZ5d3pbVB
         D7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9VEVIxWootkLFdHlqMO79BwCcniF3kvSEBlxJFgQGGI=;
        b=v0RwM/3JqLD6lnKmLK18l1nf84M2zgDnULg0Zx7DAjKWWrGyasDLeF6F9VxI3PXPW/
         V6OZmPcKMWv6OY0HsGnX/dMIM26t+Z1m+uStxPXRhxZxEeiPu0BE7/ptWH8h4JAg4Rzz
         G3iDcbaILEN/KuB36i+NKY6LGu/CaPbQNCYtgrShh87gcoVSBfyArp7+u8xNGDn+kZvx
         0iKaHKhMe356WGiMAjiTLCREzTE1bm/4nxeYRpSuoPGc0AhoQlrCAZuzS7/JCPi6PzBq
         Z7CzEcIf0uOJPHWxDpJ03b3KommtS3N7Q/5454KC6SYGAX4mnGoz4nKHblCfKLHpRXKF
         W1mg==
X-Gm-Message-State: AOAM531INHU6hIV59ZeXy8E342mt4XvnWCFNyqVdexaTMbRI0iCEaFIY
        7jkcTYhlu0leYHsLO8/gZarfjWbHFRg=
X-Google-Smtp-Source: ABdhPJyR1a2t3zWsVlPnrUquVAxvSmgzUIIcqXtxS84YM6BQcD6LMe5ZXDLHbSeM01Zf1gIYAOFdMg==
X-Received: by 2002:a05:600c:3657:: with SMTP id y23mr2253741wmq.160.1640085550326;
        Tue, 21 Dec 2021 03:19:10 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id bd19sm1955046wmb.23.2021.12.21.03.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 03:19:10 -0800 (PST)
Date:   Tue, 21 Dec 2021 11:19:08 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/99] 5.10.88-rc1 review
Message-ID: <YcG4LPJtT1GkX07s@debian>
References: <20211220143029.352940568@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 20, 2021 at 03:33:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.88 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211214): 63 configs -> no new failure
arm (gcc version 11.2.1 20211214): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211214): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211214): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/535
[2]. https://openqa.qa.codethink.co.uk/tests/532


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

