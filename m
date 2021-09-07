Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1B7402E6B
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 20:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345942AbhIGSfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 14:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240131AbhIGSfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 14:35:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FABC061575;
        Tue,  7 Sep 2021 11:34:15 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso2091683pjh.5;
        Tue, 07 Sep 2021 11:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Op34dHlig24qJZujawPVapT8vHkBbJFl+estZDzyBbQ=;
        b=pKPmnNnEtZwQdzVAEH0j5GvGAfhSJ9XknWK7sT5kpzXDWyMnjDkL05b7SwN44qr5fF
         DWBhXhmAiiKh+KLmSCWh3pif0S4e6QeBXGhShym3/TDfRVC6qJuevlJeMe/pV2SLfYBQ
         0sBjZgGtWXGjxjm+gRmmzRFHjCznx6GwWkyWYa9kJViUTyq4RDbNu+jFboWKuVFQVQia
         vTlGD8Ag093qForFilD6WaQces6KfLR139uQcXjBlWSZf0nmxkblx7ggdEftXsnJpyrz
         PFDxbIhHIfdBW9YOaqs5LahlWuRFimH3tkGfkRuq7B8smsUnbdXQ69BlhOgyMV6ezglu
         wqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Op34dHlig24qJZujawPVapT8vHkBbJFl+estZDzyBbQ=;
        b=uUQYzV4LYJjSsT3cW/bA/FjwDy/vivFF/429yngnoQpcu6nS8Zw/Vn7SArqWiIstvp
         iVrCfHE9WygtsCUBxYUIZ1ylN0TnblpG68Fo9b6nEAqC/bYrSd0HXCldF8KGHtUoi52M
         9xfVmDz4snuZPGplUJWb48N1w0cdjjbtcwQkk+es+63v3bDCS06bzYo9wzRXvBAaXqnz
         sktVimU8KXiZaxZ7Y1rdZ4Hhibztc+375iUWU93/q/lb+h7v912tJ7FRXMFydo4yO/hk
         Kt1lT3Su/McdFviYce9zSVqicP+d9kEmr7JrHYvfwXIyuOclyTzlz6z5mJNU33Dr5hdD
         SK3g==
X-Gm-Message-State: AOAM533GAnlaAB2QFgxFgAkiloUOe/gt/6/J8Kg5ykI1mcC53xUH/PAL
        bku88DxsYQ9T8hHUpgVSGMJ64I/lfLY=
X-Google-Smtp-Source: ABdhPJzK5nt4VyA6ZOnEJo3y5+FKwsiUetG6tZ5s5C9z12xTgxCcgYFX5STQv1Bck8pTka46y+2wBQ==
X-Received: by 2002:a17:90a:ab8f:: with SMTP id n15mr5902648pjq.154.1631039655016;
        Tue, 07 Sep 2021 11:34:15 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id t28sm12004502pfe.144.2021.09.07.11.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 11:34:14 -0700 (PDT)
Message-ID: <9b9c8348-2c6e-4378-23ef-3c4f94dcda81@gmail.com>
Date:   Tue, 7 Sep 2021 11:34:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH 5.10 00/29] 5.10.63-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210906125449.756437409@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/6/2021 5:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.63 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.63-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
