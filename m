Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5888348ADC1
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 13:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239056AbiAKMlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 07:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbiAKMlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 07:41:08 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158A9C06173F;
        Tue, 11 Jan 2022 04:41:08 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id q141-20020a1ca793000000b00347b48dfb53so1759539wme.0;
        Tue, 11 Jan 2022 04:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FdY3Uf05iOtULWJ08nJaAOMwfULFR6YgDx/ly0U0Ey4=;
        b=HPNE981wB5nj3n9/K8iYo2iFaQgTCAhnOoHSODzLoztghDQgEn9/EWneISe7WblRpu
         fJxalQM3H33FioqEEnDyDxboSSA5i2e6Tyad07gxiE5Smz3CE1vq2kWplef7aIXC4fza
         UkWITtO/zp7MuXt8m3fTe8E1xYBVQ7nhPJ5A9IKmdRXNiolA194wI/IsZMlTJWbpaUve
         Xva++NeWvbnyQvDM7QGCRP0fljxtd8yGZvxtY9RMt1zXChzGnfCThlXzUdEEQI35bsRR
         8e6lLCEGRanugFIVkKY0tsaPPt6MNN/+XwTMR2m4k4lyLmIuhRoiwgknJUxKpdfPFa7j
         45kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FdY3Uf05iOtULWJ08nJaAOMwfULFR6YgDx/ly0U0Ey4=;
        b=lio7GE7R+aBsEr6QduUPzjbWBeKFOcNfYBnmRLynQ9XT7/llKgnHR+xqZ6u2VIpezn
         v22ds55y3AzLM3PJad8cEBTVC2kP4jjH/hXH1GLSw7Ixu1iX1nnIePBHrMM/lOkA8iST
         5FmMcNJwkUy9L90NxTf6UbzplmnMqoDwMCBNe/2aqg9oojmkZ1VIXFG34S1fRRJkpY2e
         XIUbkZYNsPGvMwc8aH7roPCcIs82ciWAbi/3lAP1zyguqk0shdZwAbsAactw2SAGQRIt
         lwbPhUilLdtlMpJYUU25UnvmBg6tOgkPQm1cG1GasAyMLFigc57W4hkNhMcJQamLgxnJ
         unBw==
X-Gm-Message-State: AOAM531cUde9/y+OOjmbfoSTBKU8Sa5VWFOXnFicB6MzG60byc59GQux
        r4a9qPJqCRnOC8A6aSZQOng=
X-Google-Smtp-Source: ABdhPJxMsVDVt9dxhfBzRNqnveeLZ6tpw06JqYVg7t1Cunrg1OHK+XsD1Ps8no/0szvbP+/fqkiRWg==
X-Received: by 2002:a7b:c246:: with SMTP id b6mr2272509wmj.168.1641904866678;
        Tue, 11 Jan 2022 04:41:06 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id o3sm10697113wry.98.2022.01.11.04.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 04:41:06 -0800 (PST)
Date:   Tue, 11 Jan 2022 12:41:04 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/72] 5.15.14-rc1 review
Message-ID: <Yd164ACQIDCb5ny3@debian>
References: <20220110071821.500480371@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 10, 2022 at 08:22:37AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.14 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.

Boot test:
x86_64: Booted on my test laptop. No regression.
mips: Booted on ci20 board. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
