Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB7F49B749
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 16:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581506AbiAYPKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 10:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581504AbiAYPH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 10:07:57 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4852BC06173B;
        Tue, 25 Jan 2022 07:07:55 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id k18so20457312wrg.11;
        Tue, 25 Jan 2022 07:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q/fYKtq/uNf0miY8CtdiX8sLBbDL2BMLOTm05YpJTQM=;
        b=CbydCRkPrgyu1CJCN2XMMm5A9DbRZp8I0x3XANUUCYcj6A2hdojUL3yDx6SSL3mGTt
         ZGTmca6lkB48QwjeFZ3y8CcfcvB0+Q9IZ4FOhq9krgOVORSprKeiV9LtfUFtmDH4xxNZ
         TrKcfNm1KzvGR7Ms74iXv4c2MjGZcpG/C/gbXwjEWHuwj46iVitff6wqqT+OWarQaBED
         1BZScYr8Q4rscmPXmCx2xPCMdehBB4liaKI21pIQopgLhtkkk05SQWJ/vcrAfHClOiAP
         gA2UY+1063GTVyj7C/RNjhhNaHI7XxcQu8PtZVy7Re1TlwtB0H6xeuEbhqv+Vpg8vgt3
         5Jtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q/fYKtq/uNf0miY8CtdiX8sLBbDL2BMLOTm05YpJTQM=;
        b=qFzd0i/Ut+H8UIiStblgSAV0xMtNAr8vXF42GE6NZoWpSvQHTyRhCQN/FjdV2dcEuL
         fGsQ9/rJbyHmKVishpnjHi6kfNbcuUb7SJLokZFWHOeXjaxV763WdgPRjBcQAxHnaJhY
         sOEsYJLkyh6a5SYGmTIOsvdxL0bosMh4/qwsPAWlgQuYbGs+srrABDqrEHQ228QIMoAm
         E0G538nMN4Hj79z86A3ZQjpS24vGCeHEfeL5o34H1LmqtWM9p4azWl20ipawoiJLv5Bd
         PzgJ5Lt+hFbHXqzKvRDVfT4LqoPC44y94JwbNooCWDnfQiZeYu98V1xbdunEQzpTcu+m
         Ypiw==
X-Gm-Message-State: AOAM531XQOZ6N0YsZEDtZ2nIacZUKabDMX6OTyf+/n/xKj8vA9RRnRnv
        3Nc6G8d79pfoq+Bon1KwN6o=
X-Google-Smtp-Source: ABdhPJytssNoYrdxhSp9bU/5zbsjnmIBG7CPAKSfSeYMNNA0Ue87xjlMTLE0IH/WRYTdG7gdYxEwag==
X-Received: by 2002:a05:6000:1e10:: with SMTP id bj16mr10440979wrb.536.1643123273741;
        Tue, 25 Jan 2022 07:07:53 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id l13sm21868193wry.87.2022.01.25.07.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 07:07:53 -0800 (PST)
Date:   Tue, 25 Jan 2022 15:07:51 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/239] 4.19.226-rc1 review
Message-ID: <YfASR0DlU4+Y2vOS@debian>
References: <20220124183943.102762895@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 24, 2022 at 07:40:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.226 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 63 configs -> no failure
arm (gcc version 11.2.1 20220121): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/651


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

