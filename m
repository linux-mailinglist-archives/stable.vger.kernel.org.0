Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D1834265A
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 20:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhCSTh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 15:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbhCSThn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 15:37:43 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0469C06174A;
        Fri, 19 Mar 2021 12:37:42 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id u19so4380302pgh.10;
        Fri, 19 Mar 2021 12:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v8FFu4w7ajc54C071qzFJ084aus6dbCbNWWcn/Lqj8s=;
        b=k99NLMwAdJ48xyBFgFR7XN7G2cdL5HwosJH63bmj2rmuRq9xjaaei01/XXxQgw1nWX
         LxkKANicvgkSWjj1Ob2NxbqavekG0GZUYH1Iox5gDa6UajryEbhj51S4o3Br944UFvQX
         CO6CZBkKq36MFEB5MeauffS651Dizu/LJUsXDgON/PktSnMUvwuj0LlZaKny4ENJ3DtZ
         YhBYGzIdUmW6LONA7+Nyrg4Rj5BZbBsuYTnD26WflG8EgvJAsp6Qu0S5ki5s5GgdLiJy
         YOZb2Cw4duyLqiOhyscNt5Q2LMnzCiklZNT41Ao4V7TOTDjcLsiZlSu/fgibrWPz/Jo8
         UIvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v8FFu4w7ajc54C071qzFJ084aus6dbCbNWWcn/Lqj8s=;
        b=QW1sKE9dGNHEkriD4589R2nlUZ2Y0RyEwN4BIxrXhHkgTiOLYV6OgR7fgz1I2UJU3Q
         VqAPxedbjPqmkWoW7fAvSqMdrnUhv2+j0FJ+sgMuLqdpY4KZ4WPFRKuQFJXlz3MNZxOg
         Bg3xfo8v+L58WaeFbHgEKdklyNjMNbsLe0fTOAFhV4ofGEzMcGv1HPblZFU/sOb0QyAo
         6XS5Vqc27WAWSSrx7NUt+MU6UY91msEDLoAHaZoTHAnYiR75So3hkhkC7v5CTr2tpocZ
         mvr9Q+NWxHe6HQE0ghqaF+uJwl0AbLBfA2iW4gePetX6R5HM70PgblypfCukCNLFtLlh
         eglA==
X-Gm-Message-State: AOAM530j9MKklwbwoiiTdGiVnoKuFr6gJleBC/jweGo6oy0rHAzfSYBB
        V4urjeDHR8xw5FizubyMvo0QNJHB6ak=
X-Google-Smtp-Source: ABdhPJzCOl63EPzPWgrvKBOuGr4yF8s6BQhQtgp3NEhLFkYq2m2xNKu6KpFqKOVSGRfodmS1NDZ+Mg==
X-Received: by 2002:a65:4c0b:: with SMTP id u11mr3903130pgq.332.1616182661491;
        Fri, 19 Mar 2021 12:37:41 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w15sm6123488pfn.84.2021.03.19.12.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 12:37:41 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/18] 5.4.107-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210319121745.449875976@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <31cf9567-592d-632f-13a0-567c5c3823c9@gmail.com>
Date:   Fri, 19 Mar 2021 12:37:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210319121745.449875976@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/19/2021 5:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.107 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.107-rc1.gz
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
