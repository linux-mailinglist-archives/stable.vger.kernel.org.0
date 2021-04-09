Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1D235A849
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 23:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhDIVVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 17:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhDIVU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 17:20:59 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511B1C061762;
        Fri,  9 Apr 2021 14:20:46 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d11so3002583wro.13;
        Fri, 09 Apr 2021 14:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tJMx3joEzDkhqOdTLxiBP2TD6ATdYz9StpsYXzOK1QQ=;
        b=UpXbR+pOLFN5fqOn6JcqFmuzUuPGt0W5rryRsUzW2iE8ZNb9SSeWCoezFDkIpBxvd6
         oHVpX8uDlEaCUbwzXd+XhA3SmfpnsBUO2RtLTq0vwIIXcVm1tkUjXbiVSOfyML5Zb1BG
         5yTF30SWUk7NLYA2jPHEn9jJq/55fULsj61yn4J7S2Udaheq1NNBjO51Xk6za9RnKZQG
         kx6ugEu1LXiOSBylxSyxfUO+VP5hN/pVWtQfIw3vOldisxcxtI0BSvx9IWgr/yn0Jml2
         dG9ftXl3VJ2MTd9RSgGnudVFf30lTAeQUyORcspM2mDBL9Qnr42TojhqH0pMrcB9dzuB
         cgyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tJMx3joEzDkhqOdTLxiBP2TD6ATdYz9StpsYXzOK1QQ=;
        b=VQ2KkyHCyCx5YNavf9g+RvqPZk6pXXOuoF1W2whLt/3aAOugP7ZxVxMCvc59fTJmi1
         QxIJkiwsBckiRWfo0dovB7JxSpPkt62O1UVEJs8rg7iBlUyZCRdJ3y5fOmAr8/ff2fTP
         VLXpMLPkuvDLfdJEe10kgzXrwRb4ZVRmkU0E9nca1SteMs/Lo42/Qi7GktFpqYrERjLZ
         pSWbp0z64pXaJ71S0KIxxAEXTEno76CdjGw1vH3iF/rrlNArCdyXFumjsAJnf/T2+oQl
         kLKvu5UMgNILuveAAmYXXkG1HQ3dLs8bp2ySihC3j/QSS+PuPeKbuq1qnpFXRNR2myzn
         jgNg==
X-Gm-Message-State: AOAM530dIJhNgHXtZKVuzHCWn9YG2yz6KWGyPVMwZue3qpGH0Kg6Y+4M
        9619HFl6dVy9ljtWSjtY4oIziYNX3ij/qGdl
X-Google-Smtp-Source: ABdhPJxch+iZP7gI7QDv0RUho5LDfhsXf1rqhrii+pJULVdhYn4KkzTcQ+Yk16N8YPMxMPvLjfYRaA==
X-Received: by 2002:adf:efc9:: with SMTP id i9mr1774929wrp.173.1618003245126;
        Fri, 09 Apr 2021 14:20:45 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id p17sm5260124wmq.47.2021.04.09.14.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 14:20:44 -0700 (PDT)
Date:   Fri, 9 Apr 2021 22:20:43 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/23] 5.4.111-rc1 review
Message-ID: <YHDFK5IYfxvlC0L5@debian>
References: <20210409095302.894568462@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095302.894568462@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Apr 09, 2021 at 11:53:30AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.111 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.

Build test:
mips: 65 configs -> no new failure
arm: 107 configs -> no new failure
x86_64: 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>


--
Regards
Sudip
