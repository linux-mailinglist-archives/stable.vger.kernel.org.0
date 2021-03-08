Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09703313F6
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 18:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhCHQ7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 11:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhCHQ7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 11:59:34 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1368C06174A;
        Mon,  8 Mar 2021 08:59:33 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id i14so3363216pjz.4;
        Mon, 08 Mar 2021 08:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=od17LthaoolvduGrwEslwJAbWVL76D58PWjWt93m25I=;
        b=Eu0ZFxAf8fLpO0VRDDgSezt3y+zK89Bk4tHm6dfudcikaJ0N66dDvaQHiM7HTV7da/
         dnHyXZtQecFwTH5u4i6NHRXKbyjAvA5rAVhlRHvcYjfMWuGKKmFybuwfDzzJavxQAHKf
         X867rws97ZzCS17T2QnscA+YtK+n15raEJDRxCVIyQLC2QHGpKOswlAY3dQ/XMFkdo+N
         hphKu31ApDg9Xtt3r0VM/B5xz2ZiOrEhE80xqig7hlHmeZfOuNZOT1KVpspRaMo8R2mL
         tgSmCg3Uz2yqPK9I7T+lYPD6Zgh2HSqkXqIWk1scFIj9J/2nQPQkoT2tBPzOhngUpc2W
         V3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=od17LthaoolvduGrwEslwJAbWVL76D58PWjWt93m25I=;
        b=HSLSPEy2+WkC77NIKIyx3tz+pK3GqIVE/xxQZz/DTsuTAwHK/RvCgw8H5IKizTFu33
         mY4LoILt0NivdeawnSixRjhGWjw+iygVxK3G65n9yY4jGK3yh3VA72PGOcHM9qxMvY6G
         RksTua9Y9b5LgLVAxZBPJuIokZTy9dxu6gJ9FOnus8CADFrfBkx9pVglgloc1xj6VTam
         I3mMIpjL26C4gchdsjn4lAArgcn8oEEA9ZAyTURT+2wzNGuOWdrgys0KVwxry5/4vMqR
         SYfauV4SBDws/psSijiOKx15q0T43j1xJ6IGNyEXb+uu7Y3J0vYHaXVPekVj+HpcnKGg
         TXrg==
X-Gm-Message-State: AOAM531GA10TvrFXnnZVRas1g50Fv236BkXf5nXcFUG0dHU2eCPxZkCi
        859rMhMdAw9nTe9CGfVeDGgGHiH3JBc=
X-Google-Smtp-Source: ABdhPJxOQGexRKcYjZkdWkm6DPyfDf+9UFttOhkGVMPP78A5iNTjqF1OWkXsvL7Ua8sXSudkVCbzEg==
X-Received: by 2002:a17:90b:fce:: with SMTP id gd14mr25038689pjb.64.1615222773136;
        Mon, 08 Mar 2021 08:59:33 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k15sm4591635pgt.23.2021.03.08.08.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 08:59:32 -0800 (PST)
Subject: Re: [PATCH 5.4 00/22] 5.4.104-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210308122714.391917404@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <56ae0d93-3e08-1799-6b4b-46f621c62811@gmail.com>
Date:   Mon, 8 Mar 2021 08:59:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/8/2021 4:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.104 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
