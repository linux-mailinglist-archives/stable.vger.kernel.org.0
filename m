Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B753BD9D5
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 17:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhGFPPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 11:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbhGFPPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 11:15:44 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F72EC0613E2;
        Tue,  6 Jul 2021 08:13:04 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso2018323wmh.4;
        Tue, 06 Jul 2021 08:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mt7jarwxn5HTd17RRJ3ovBSMnosPGOk7m7yKgAF9aKQ=;
        b=ZI86y4bZcncPoq79W8yQl8JyYBZR974ien1h42kKYMJJydEyIjrhsK56atYky+60jZ
         AaX4XhY/VEB8IFzWqwORNdmiOwqMC1qcSyxJsxwNPJSqAbk5E0cK2gCV0AH4Svfhfj3F
         bAW7vkzaB2O7uxOW/pTvgiHU+H/MmlqYQHl1bo4iSM5KG4zGMaviqEsuHL8raNIfiUIZ
         HlVAeh/9LvQ+UthhTaXqq+fPXHzA8TnoRKyr20Z+Fz0RHlKsT/eetEVhaYfo3m27+QO4
         DV9JcDPs22vn7JqphxtFEJwXxMJU+JfW1Eph4io0NDs39CrF4GzVJKQRL0rSM/3O+ZxH
         X9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mt7jarwxn5HTd17RRJ3ovBSMnosPGOk7m7yKgAF9aKQ=;
        b=ntbmBW/clQJcMc9wExeAGfH3Mu6Pxw4J0VT2GvvlAq14DERgGwBti1laeZgDTpTXNs
         yVEiM9+s+jokcDZteEsiyKEMuc4r5AHtovTc7gmH13R2NV4Qzn/KoxEv81C8WsFwK41g
         Knd1hwmIBOT7CL/MHUIIKY0vIltDvEUpROEWMjGWLeVjntE0PGOPM6/578Sbu0g+Qrv1
         pLW2KgczrRa2MViiVayP4GUy3nYWQUeZLnHrjmYCpr3ZE5SUCNuKAxtJMEycpzK++bKf
         GmCaKAqPRgl+n9fhFC3N4O/VjtAuPHX1YgyWwjHxmZMpikWEbLafOfesrSKCBjWTr4ee
         AVbw==
X-Gm-Message-State: AOAM532k5Sd1NA6AKBiaYZ+vn6NO9BT7Z3X9uEjqhzfbw7g/JUBqPihV
        1+tCid2sFTqrzbiTehxeUAHzDSUBuoV2nQ==
X-Google-Smtp-Source: ABdhPJzUlWaTxCjP4ULoUNoRD8RiK2sAs38VKQZIduJZs9yUhlreZw/VLzd3szsRUpOnNPetRuADgQ==
X-Received: by 2002:a05:600c:4304:: with SMTP id p4mr1312066wme.43.1625584383021;
        Tue, 06 Jul 2021 08:13:03 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id b187sm3205426wmh.32.2021.07.06.08.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 08:13:02 -0700 (PDT)
Date:   Tue, 6 Jul 2021 16:13:00 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.4 0/6] 5.4.130-rc1 review
Message-ID: <YORy/AzNUdkinYq3@debian>
References: <20210705110029.1513384-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705110029.1513384-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Jul 05, 2021 at 07:00:23AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.4.130 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 11:00:14 AM UTC.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210702): 65 configs -> no failure
arm (gcc version 11.1.1 20210702): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210702): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
