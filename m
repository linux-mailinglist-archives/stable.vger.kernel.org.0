Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4421043B96B
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 20:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbhJZSXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 14:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238400AbhJZSXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 14:23:33 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A5BC061745;
        Tue, 26 Oct 2021 11:21:09 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id s19so20752584wra.2;
        Tue, 26 Oct 2021 11:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Igkagg8xPaxTeFIKiQLEb4avmN5kAJxnhobYoqtxotc=;
        b=PtnTvHPz7OJQLg+pa+unZTdF+rslWVwkhTJUQVVAF3lCuPJEeknGojwt3xWc7Ds1Y2
         D7jI4EK+4rwJbecZ1MfXFODKvn8JqxZO0oJ3Aec0NhODq3O05ConQZi5clGTCKIOiOQ2
         OnhY8M9HD0rAEA0e1t6c7V3GCDIpykpUr1uDnSmqRIvfCJP1b7kb7/Lf4MpCH3IV7o9a
         LMgpXhQbykOvBtK3SmErwJELy+rlwJIpKjqfcHzXpiAIJ3xbJjkwMRUPi6UT80qLYOuZ
         I+Eo51/LjhR50rLMGqqCdf/xsEkbMS3/nLJjgzU4rY+gaCWkNv0H+DW+WF9fiiLzH8YC
         Stsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Igkagg8xPaxTeFIKiQLEb4avmN5kAJxnhobYoqtxotc=;
        b=dMVfsjKMXHrsneVLksDgWnl+1AZ1oLtendAzoQN0QojpZWhX2R2BUGb671Dl9nBbgX
         6MtSfz6pB+BZa/EVDwyfHUeJga+JDkP27KNm5CpY95jVWoKdUMwar164P/iEHLtWsfE2
         0Zlx8+tE47TGfqQjtqFngAA4CUkFZi6WTLWgKPNNgnuQ+GnDAARm3jc4KitucgBhdRaO
         EHQyo5XM0TzQrLEgHCmaRphNx5R00UO0HIpU8bv3kliJvpoyz5UGBtOmtmKYZScrI1HG
         jmRcQSfxaum4CVZstLSKLJetlFZPz48NtP20BDU4lr+TKK3Ejxma2TMucOxyurTG+dEO
         2zJg==
X-Gm-Message-State: AOAM531P8Hbwr04BFotKJP9i6+Kk7G5zqoI8l7AqD0fzWjPWAN0sZKVW
        l6vmJIijPTSqCcZIIeI5ESz/WAE1i1k=
X-Google-Smtp-Source: ABdhPJxbjQ7AaqjsiPyu+Te03vcgPfgmDzHkK0G7ETZDHTL1Cq5dYZdu0HZtop3GitLqrshSv3EwBA==
X-Received: by 2002:a5d:47ca:: with SMTP id o10mr33639147wrc.360.1635272467746;
        Tue, 26 Oct 2021 11:21:07 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id i10sm2339527wrf.8.2021.10.26.11.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 11:21:07 -0700 (PDT)
Date:   Tue, 26 Oct 2021 19:21:05 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/58] 5.4.156-rc1 review
Message-ID: <YXhHEf6ZcU+Htx7S@debian>
References: <20211025190937.555108060@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Oct 25, 2021 at 09:14:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.156 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 65 configs -> no new failure
arm (gcc version 11.2.1 20211012): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/309


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

