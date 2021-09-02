Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D7A3FED26
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 13:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhIBLvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 07:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbhIBLvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 07:51:19 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F46C061575;
        Thu,  2 Sep 2021 04:50:21 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 79-20020a1c0452000000b002e6cf79e572so1221823wme.1;
        Thu, 02 Sep 2021 04:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W+dOKzd6UdN2swvIeOeNM3FcX5BgY72jEZS4lz+OjQs=;
        b=SY+K/XSRATRvwaM8P1p26j93srE7PqAwXZfEoy7aRcHE233RP4pYq7i1UnFZVZ/AAS
         6yP+12g6wAqkNwoIe7U0J9tSDmwJxQC7OUPY+Os6t5RMzXIKTWudfMbg/mHHQfN793rr
         3KI53dEdVxQlw/Wv65DKT46R2+XN5dzObeczRM4dnRKnQtsv6u2H5EPJdA4dhRaemGh/
         7yyys7jEaRc1I9LNTtqllOhAw6Po5BusUTk/C9Gy6b+9t9ADtUUSeuw9DkNBoALmJ8wY
         vsEchIvRhKcxDlJkyHUCXGUrIoZIE41nDKPLhQ4hqbom0UVE+Z1F5sL7VMYP32Eg6mXg
         +K8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W+dOKzd6UdN2swvIeOeNM3FcX5BgY72jEZS4lz+OjQs=;
        b=ahu6mtmNWExhQfZr+jnN0kUIAXmaJmMxgrHspib0+5eIA3p+6S9xPdZqBbFVWcHkY4
         ck+DhEtEHxWHsefLeyFiZ2Twridii5arUXNQoK5NNxQGxUVwlqALa8X8pCCZ85ru7LsD
         KCcEt8DWtX+uwgNsHJClGQV3Y8iV4UwUAaow3UXUl4+oWF8vuqdWmVC/YSm/Yb4XeoNB
         6EY7fruixHRKmlKxFz2jjuaR5xMsVWpEDVwz281ZeGzZEiOePR8jCD7YxxZFNsxDq2SD
         4y5BAMXgE9fSF+emJ7eJRuU5wQqSdA7QHyGJH0CI+Sa9TBGpA+8QEQA2UVvvNnIiSroj
         uvoQ==
X-Gm-Message-State: AOAM530VIl7RQkpOjQCo4OEdgWXZOBFzc5ZR56QmGpgsiv9r1Bqs1NNe
        Gd0val2PnW+OnodCxLIUuaU=
X-Google-Smtp-Source: ABdhPJzrnXhdnCziXIY5rotMYIhHe7xtWapq2QOWpE0tIj0Syl67cC7cx/+c0dPkxk6Weyp4/iveKA==
X-Received: by 2002:a1c:3945:: with SMTP id g66mr2794246wma.49.1630583419541;
        Thu, 02 Sep 2021 04:50:19 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id m12sm1623298wrq.29.2021.09.02.04.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 04:50:19 -0700 (PDT)
Date:   Thu, 2 Sep 2021 12:50:17 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/48] 5.4.144-rc1 review
Message-ID: <YTC6eT+hrXfMv+Sq@debian>
References: <20210901122253.388326997@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Sep 01, 2021 at 02:27:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.144 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 65 configs -> no new failure
arm (gcc version 11.1.1 20210816): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/81


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

