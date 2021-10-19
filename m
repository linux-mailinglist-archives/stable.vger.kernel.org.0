Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90DD4335D2
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 14:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhJSMXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 08:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhJSMXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 08:23:01 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D32C06161C;
        Tue, 19 Oct 2021 05:20:48 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id i12so47295822wrb.7;
        Tue, 19 Oct 2021 05:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HIYCHBTIK4PyzXlMJSYD0ICsSQ1KS9BVG01K7TMsEtw=;
        b=pFU4ZiptoFqJEEaWX7E3selPixqv9gWWVSoI5PgUF19P6C/TYrPKnLpiQ8iTELxyBL
         mkmSKYR6It/ka+KZjp5P5Ph3QcFzIFdiWdVi2oWAQLPrML2opPfyX9ZaIuAW2MYGR7Sr
         nmZRyZKLbL/iYaa7ilYDsPXirJwgdnjSsQFZG+ECT7r+2MreKfRPnUambceR817Lgl2C
         1V0AkVeLYgyqLJKr90a305n684350nEvcZ17LoXzhjRPk8gISTj25mojoc41ydSC+Nw5
         Pd5V6irzETtWm6JM+V3T0I1skfIUlHn+l2PAzWCUCbWMfB9EMCLeveRpRkMoByRrGfc8
         DA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HIYCHBTIK4PyzXlMJSYD0ICsSQ1KS9BVG01K7TMsEtw=;
        b=e0iCJ0HnJBos9HlTLW94zUbMkrLrYueHIRLsvUufjgieghVSO355YxTKMcA3gg9UwV
         2T6soSb6D74SJN84p7AaSq8gha6Cri7T2vETPH0lsyRPF3BRpjJJG9ca6p9PmDXvTc/N
         skh+EnrPEkJm2jAr8VQPeA1wXYvCTmF5iNFoKm8gBxD0/OpPQn7lSpnaWA8AXeNUj4GY
         Z8yZL8Q4wQBKzq4fohXWc7UyJrchBWGN1C6zWntBuyXcdzQ4kQk+oP4HTsw4SiKRMFlX
         +sOW7NYHq42E1rB+62ZsGL0eIKT0v1a+sYyX+8X5U7EGKjcvqCoEQpFjva1eMCTD86FK
         JqaA==
X-Gm-Message-State: AOAM5303/fqas7yq7OnIUVnNh5w1vV+b8sdLtdWAMVGCg8VUjL+Uxzkn
        ACWjO55g+2n8Jkx5qdyYj8k=
X-Google-Smtp-Source: ABdhPJwFxa9m/kwKkJBN4Grh5yBocQZtiwrOrI4hoN2VY2sY2ir68PZf9u1YG0Me+vJhk9r9eG+LzA==
X-Received: by 2002:a5d:4a0c:: with SMTP id m12mr44238921wrq.27.1634646047046;
        Tue, 19 Oct 2021 05:20:47 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id e15sm14942767wrv.74.2021.10.19.05.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 05:20:46 -0700 (PDT)
Date:   Tue, 19 Oct 2021 13:20:44 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.75-rc1 review
Message-ID: <YW64HASCBJLrbO6r@debian>
References: <20211018132334.702559133@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Oct 18, 2021 at 03:23:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.75 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 63 configs -> no new failure
arm (gcc version 11.2.1 20211012): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/288
[2]. https://openqa.qa.codethink.co.uk/tests/283


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

