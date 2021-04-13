Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C70735DCA2
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 12:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343607AbhDMKo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 06:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343609AbhDMKo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 06:44:26 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813DEC061756;
        Tue, 13 Apr 2021 03:44:06 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id w186so3928962wmg.3;
        Tue, 13 Apr 2021 03:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DUjjvJhOnAVNzZJRBjh3ALmadkWsbvwrLZD7acnS8NQ=;
        b=kk2enuTHW1YvyaZwZsX3xyzvFbvCyj0DdpxomMDWT35Rp/NeWTqjqxMAq8HzPqzYJ/
         bZMm2X+MbQw/OP3vpN6oliAa2r614756zT/1gohFbtH0VeYQtdDOMUjkoIAxiUJ8Otjb
         3VbymZBx+bRyvbSlWXQGhoXWg5k3jQ1ug8jG0qjhIMIx0mpU4jKLWheU2shiYqhvrEyD
         OEsgKO2Hi8xsgsGfGk3X8oz8RP1E0lERn2rN9zSeu21dKA3dq41rAqRdeDd8lLIzXzv8
         OVeYgx0J1GavrIJRzo/xkShLVN/rCxlMEK/Gdr2sxBZy1LbRVlTQdjMrDdRk72UYL4EV
         8tJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DUjjvJhOnAVNzZJRBjh3ALmadkWsbvwrLZD7acnS8NQ=;
        b=UO6WZELr3uUaz1cyk2hZPwFZ4tW3EPihUbGrtcKnTQxNp55y9rOzQfO4BzkGJ0+Ju7
         8Y8bpNBg34lelYeBlbjoVGd3t1hyFCZYFdoiP3N02R7tVGPKbKJ/qY7IiXv7Nl9RwVmK
         /JWZ/Z9rxtd/sbxtkIwkNn88l15hasoXUMTKxyjmjhbf8FnU8P495JdRQsPrB/EsJkm5
         cK5JT9IYE224gIe6rDEwW9IP5MFCIV6IGH2R1jVIx5rrMfzPv5MVb8UVts/1sR8QBy7r
         l0nMiDMTUVgT+v7pD5NiQISy9SqjMF8/1J8fUkJQcHdwy9LkQqx2aEut269U8bzHi8EL
         UC6Q==
X-Gm-Message-State: AOAM530mxXNMgkz1cU8ph8LDvIA6lv3A/KEOGgFO2CA4fUVVGT8iKcVs
        aQb+ugIrnLsDzU5bxvc5lPk=
X-Google-Smtp-Source: ABdhPJw90OLCtGg1Cl0CXxDsinTIKaoR3GyXwqGjqBSB8Fz6WiYJR9hLzUf8KZMSXsCtxoXG0Tlv6Q==
X-Received: by 2002:a05:600c:35c8:: with SMTP id r8mr3544257wmq.130.1618310645285;
        Tue, 13 Apr 2021 03:44:05 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id n6sm20484934wrt.22.2021.04.13.03.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 03:44:05 -0700 (PDT)
Date:   Tue, 13 Apr 2021 11:44:03 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/188] 5.10.30-rc1 review
Message-ID: <YHV184FJ+RPo1UVs@debian>
References: <20210412084013.643370347@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 12, 2021 at 10:38:34AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.30 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.

Build test: (gcc version 10.2.1 20210406)
mips: 63 configs -> no new failure
arm: 105 configs -> no new failure
x86_64: 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
