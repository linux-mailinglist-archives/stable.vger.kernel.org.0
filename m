Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB07E455934
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 11:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245528AbhKRKll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 05:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245716AbhKRKky (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 05:40:54 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615B8C061764;
        Thu, 18 Nov 2021 02:37:54 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b11so4832855pld.12;
        Thu, 18 Nov 2021 02:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=iYdHm+MRm109WDTnj6ZU0kc4XwL9DOKNcqU+hZbqIos=;
        b=a+e+GmtExsyZ2vF2NGO9PmGKOqWZgaKDbDWJcfN42h6j2uy/PM+dpCABEWK8VNk46l
         d+e6ptRRraU4YS7NJlbr46u2U5d7cXo0xAqw+QU8IsYMizZOVS3qh4j1KxE9HqAW45uC
         V8fD3wth+LVMHQNQ6gPyPiKy8l4YEFboreHXp3t+BIB2Cf0n3KEcqzLjRsme5r9vicbw
         3elYjs7j+cHnfTaRgDdEyQTSg/DX7pcxiAotdn3YJf9JSvVc7fH3fbbU8oR1mfqG4Rli
         1/WQMFCNPw01mmqMXI5pj0gLYQUxSBAEsBbIGSJnMTzk1NsD88eRdkZCxhgbT2IduJ9P
         s9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=iYdHm+MRm109WDTnj6ZU0kc4XwL9DOKNcqU+hZbqIos=;
        b=ZoCAZAzAejJNFbRzjfBF7fdfWw1bMdrXgl9MgqZ+4fMP2yjj5CgKmRmVozAoVeRLZs
         2+pMZp1tdTjD9n3boeaRExJ5Xh3hT2tkmqZ1xU0wIGbGJf1qrnf6B3KsNMAETFw8qIk5
         5KCiNP/cNqdO5QoUPDm2iVcbm9+zCSkSfkbEFA1GmvDx0ipneey7OR1wItuP0s30b9G6
         Bp6UCWumlUFMjDLocZxAjULPj26GjlqIY/AWMK6MTHbh5CuSIjll44rDLgc/BZ5uLT2Q
         u7c6Oi1yu4OcPCX2FQyRm4oa89qHaH00ENzMHC3DtaFsw2j6BWja6XPD6vfOUA9Lxp95
         jIcQ==
X-Gm-Message-State: AOAM533bO6yvDgu9bqIwEwyVbAPCevLFOHXKl5cFo87pk4NkVFslAiU5
        CXw4WS4FFESac8UvTZmlmmKQ30aGF2Iay76xokA=
X-Google-Smtp-Source: ABdhPJwEkBSq1B7Kmbi+M8CfzHOyDE2DUVuaEKAIjs9kUrkG1RegD8/rLh1fMaZdtSojc8792VDpew==
X-Received: by 2002:a17:90a:b382:: with SMTP id e2mr9151888pjr.181.1637231873351;
        Thu, 18 Nov 2021 02:37:53 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id i184sm1938716pgc.77.2021.11.18.02.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 02:37:52 -0800 (PST)
Message-ID: <61962d00.1c69fb81.4ddae.63d6@mx.google.com>
Date:   Thu, 18 Nov 2021 02:37:52 -0800 (PST)
X-Google-Original-Date: Thu, 18 Nov 2021 10:37:46 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211118081919.507743013@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/920] 5.15.3-rc4 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Nov 2021 09:25:58 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 920 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Nov 2021 08:14:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.3-rc4 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

