Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CF3417D4F
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 23:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343742AbhIXVzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 17:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343815AbhIXVzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 17:55:18 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00AAC061571;
        Fri, 24 Sep 2021 14:53:44 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 17so11123934pgp.4;
        Fri, 24 Sep 2021 14:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j8QRx5b9SQT+MHJznooERmkKkPETrJ+cdeDXoHwawpk=;
        b=ZeMxqh+QGmJfHrzOwzXY22mFFdr8myDsWpkhufAXXkpI0pGOLgkC1j/P22tDi3sMoH
         4FzO449zFEYT17mLVilGRh4h4rJy5diVLfNknHLjh/lMGXGu+0CKDSy/9nGvXt6PRaPm
         WWQq8FdM9toXSCD5bqDpGwbfYRv05ORyeUpIawjpwiPJHiyT67NMpqbwmtVQ+jiKN9Pb
         29wcME/WeWqOyEU43zNB2xGF4pi6VUb+wiGeI4DMj4BLR8QAEB1DZa3gG5e8HXwHVX6/
         KxkhaF1b8eTioH+iPy3E5OusRBMsIydD88cLfnIVILZQdRJbZfIQeJotN1NIdETOR2pW
         RXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j8QRx5b9SQT+MHJznooERmkKkPETrJ+cdeDXoHwawpk=;
        b=uUlTb5r21kaTig1nOOvJYKhGB3/rUDIxSQLlzwIK+qvXzTbzR8wH6al5HjlXCcwRax
         eZID4PnnXjqFAi/CKVi86j6a5kO7QyHB7f/USuLkL8nlS+v+59A+Wx45ioTACce/zCk+
         NBjoxa1RyMWfrs++Pci7CPzT0Zdt8vrKOxHr5ocvMSnVawsJ0MyrT9UYSm61iyTgBV/m
         ZynUuGwcQZMGFFg78wp5kgR2W34tPwkOfhYHfQPzhjzFsDmq+c5xAnTdHCXlNoo8SDW/
         OcUdL2oPjpCnjvchScu6KJ/7xqsq8wPDSEfMmrW+SfpgXQ78s1YnL/9xq7m+3ZFrFfQY
         6WRw==
X-Gm-Message-State: AOAM530plfkOEwcWJaRwRExjdgk5nku3LKnh0+uNa04Rj/Ahlt3H4BY0
        21udPV+1igY1u1L8PKvY8+xq23OVL9w=
X-Google-Smtp-Source: ABdhPJzkBsptcojiawFz87WWiu9Cck7aqgPiAugk5dpKDXiu+jMgCn+yCrTvA0cGENXDpNNL28fMCw==
X-Received: by 2002:a63:4614:: with SMTP id t20mr5630428pga.372.1632520423907;
        Fri, 24 Sep 2021 14:53:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u12sm9934724pjr.2.2021.09.24.14.53.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:53:43 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/26] 4.9.284-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210924124328.336953942@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <eda4ee8c-8c10-030c-c65b-be601b0115ec@gmail.com>
Date:   Fri, 24 Sep 2021 14:53:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924124328.336953942@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/24/21 5:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.284 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.284-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
