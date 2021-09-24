Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FD2417D6B
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 00:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344195AbhIXWEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 18:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344520AbhIXWEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 18:04:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F88C06161E;
        Fri, 24 Sep 2021 15:03:10 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso8569640pjb.3;
        Fri, 24 Sep 2021 15:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=410YRMs86cIX3D05JqDxKx8eH5A0VmVxMwXye5Avqlg=;
        b=TgS+1JZ9atfV81enJggPHZndmNayyrN9CKLS/6qdueXpFX+tVN3kG1ElHWRt+tJRnB
         d7y/Q57kuhN84AITxHLI/e9Yy4EnIrpN8/Zw5GcZ/8S0P3h9tqcea6kOAOfLdqjZDEx9
         rokoC3j+dH9Lds5JvFlSViiZbdWZTbmi/FptALNwQv1EHfQRZ3kZsTPszm8ByMlIJWkg
         BpALO8aw32+de1rhdALnAOYoHgcyacG/OadudF3NiD1ShqSx5v+PWU3L/Xq7w8oX5FTU
         5MtcpbaIG5IJ+SOaadjt9dzHlFB+6LvIZ8bDuNHdPDiOiA0z3IpcOGxlMY96dU7oATUJ
         0/OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=410YRMs86cIX3D05JqDxKx8eH5A0VmVxMwXye5Avqlg=;
        b=G3uU2lIYDcnf6EhXsRRhr7vqNNNpx1VrJcFVe0Ek8W570Zw9YoxNRKR1wdTHTZjblm
         X0Aco7JD1eWjdzN+wTCOEfznyXlVEyBxwJsKit5ehyXOBaRR6sO004Lah1Q0Y7pICLPO
         rS0fiol3kJbZC6vu5QB1m2gVriSg/FecHWsIsZdnFhYiMsIb5hQyd6hZp5CLytpLrqtM
         3Gc/QOYNkyJlOftJeFLE4d9qNvSDHPFYxmbNcWnU/RigzfemWkUhBi4rvqJFWql1pdQB
         qHjhmY8J+NggOKj+PljSZ5bIYC3azKQ4FtGWDafazpvuX2SySjEC9AE+zQlE4IxzhoWU
         h3vQ==
X-Gm-Message-State: AOAM530gJ8qdRuOnFby8HvsLf7vCV7ppQPD2IgM5m7XRlVfms5BWU+nP
        JMoQXcP7mi8uUci5dxB3+QI15+wmf+c=
X-Google-Smtp-Source: ABdhPJz7LGdWe5WmandekYOructLBRSuhQE1dJrM5iX6KNnVZf60PZVyEp8LarQ7EwCS2p5uA/OV0w==
X-Received: by 2002:a17:902:e892:b0:13c:9ce7:af60 with SMTP id w18-20020a170902e89200b0013c9ce7af60mr11071543plg.41.1632520989119;
        Fri, 24 Sep 2021 15:03:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v12sm786065pjl.1.2021.09.24.15.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 15:03:08 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/50] 5.4.149-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210924124332.229289734@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <05f54dec-f20a-0850-fdd1-bb728f6bb640@gmail.com>
Date:   Fri, 24 Sep 2021 15:03:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/24/21 5:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.149 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.149-rc1.gz
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
