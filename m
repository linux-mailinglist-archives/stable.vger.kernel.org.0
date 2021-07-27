Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F393D7A63
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 18:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhG0QBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 12:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhG0QBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 12:01:30 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC35C061757;
        Tue, 27 Jul 2021 09:01:29 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h14so7851407wrx.10;
        Tue, 27 Jul 2021 09:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hrC5tmc1v6QkccLnJLsA4J9k4QrgpqBBH1KIhvLwpfE=;
        b=q4a8QR/DXtOSNAFyNNeMNf6ewk7CkNm2WtIkWL4v1MwhQs486EV3z19O94PO3AW1dx
         +tKNM9HB2ZdbEZ8iM5PQI5w8YmN8ybt1LN3YeI/MvM4ULNqRTvbtPJ7GqF55+LSXcyQ/
         sPWKn00VtbaLSa6kSFfzgO11yjdpl94clszRSJwm7s7TuiPqZyUzI1b/Z7hlIt/IlVdv
         a9gsMDXhqRlGEC3HxbS7CYtSKcU42dbGeg0RyW8aAk46m6Jkuzrt85Wug9+RptvZMmDR
         kkzl3yWuHJM1dqfExju/j1NFFb1Dmk5MAJZwwu8kn6TaSgZMSpRL33aTj51jdeT2umS1
         xbJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hrC5tmc1v6QkccLnJLsA4J9k4QrgpqBBH1KIhvLwpfE=;
        b=Yh9wWLl7W0ZYgZGDumarkor2jQa0vr7EPRMF2YQCxRlSAKUfaSURsQL+n3wxWe64TB
         2qSw9EsmyPXXsi+y2lsODHKcJXJZ1ss4BTW2v/PvJ0AOvjOJ9yMsbCOQOxc42vZfP4dt
         gZ3mjpLvWRzpa93Qzso+y5gTCL7Ev+mGucjumFyG0Fievg2zsGP7oCYlR4267pApeKPe
         miL/tYyZBagq02l3GOLpsd1KFFh/1K7hQ/Y62hzEoZk5VX0Lwn4rMtfHRJGVDvwHByf/
         VvY7hLoKt4nrNFighWbtXqzmZQo6Ajl7M/ppq1LCsDOZvsvUd90+l8d1adGkoNiigzH/
         0+9Q==
X-Gm-Message-State: AOAM533wwdrAMhwyqPlRkk7heOy4jXlVlcM/mC//d2mPXumtwqzybfa2
        8nwf8sbM7moTyRN8U4GDJn8=
X-Google-Smtp-Source: ABdhPJxlvC+VVHCJ4uHqmNiUPzXFmfR9lbm6P1sC7mwyoCCoPGDQFB6kuidT8YiIrVhkzoekmySXMw==
X-Received: by 2002:adf:efc4:: with SMTP id i4mr17230430wrp.53.1627401687998;
        Tue, 27 Jul 2021 09:01:27 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id z3sm3228724wmf.6.2021.07.27.09.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:01:27 -0700 (PDT)
Date:   Tue, 27 Jul 2021 17:01:25 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/119] 4.19.199-rc3 review
Message-ID: <YQAt1f1+Qg8mDg2y@debian>
References: <20210727112108.341674321@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727112108.341674321@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jul 27, 2021 at 01:21:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.199 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Jul 2021 11:20:50 +0000.
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
