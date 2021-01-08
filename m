Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113A72EF6A0
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 18:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbhAHRkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 12:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbhAHRkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 12:40:14 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EB4C061380;
        Fri,  8 Jan 2021 09:39:33 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id 9so12179791oiq.3;
        Fri, 08 Jan 2021 09:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=muw2471r0dUroN6luRjStWhvHcdpoDUi+xz9M+bMVRU=;
        b=OXvMEFn42ZKVSA2byj+xK/pDLuoNy3laLSrprmta0qvpWu0/EoK+qUmFh8h1okR2Xn
         0j5uQHeEN4LZcnC/oe6zjxdnk18JexQFXnXASwbSeKm6fl/S5pyoSZ/NNKVQDqv8CLSS
         thnmfK2Uykktoi1Ub1J+yuWA9cxrJK8G+t2f5R1RH7C0uUa8kN3pyE1as9iFWMktFEdE
         vu75T7QUbuKbM5vulGjxR9uAzAyWSTFhR1pDQ9N8iLtchIRZgwF7bBfZDrxzBUgwdvj2
         lAL0xTBPDqiiu7MC5Jm6nhsWA09678Sr2L80/xtFtb0J29dU/qBM18G18tcLcXMF47I4
         VxVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=muw2471r0dUroN6luRjStWhvHcdpoDUi+xz9M+bMVRU=;
        b=aHYexZzH1Ab1+A1EaCOiwZshCfL22P0b+lpIw9My6KsrhDdh0BRblwy6Awrd8a9XuP
         5RbsRgNXbMPP0hYdlu67LBz4/R8IJlPW7tV/XksAP86P22hBOLG3+mqCIY7gIFTbKujL
         /SoNmNSh2uAljVS1/JLTpfstdCB/Qi4gpZqMVKeHovLB/Hs2Ewz3QeqrM51bpPnfOemx
         /DyQVN0MyKbYSKOH66Sx8NMyeo6lhwFuvkvIUUxqrzbh+WH4+/CItEmdKU8MuaH1irV9
         b4mA94QoQOl4+tgaGXArGA/fTjz9yHEqqyj2GN/PX6GXH2OWxSgvnpYjByaE5CBP1qX1
         SfAg==
X-Gm-Message-State: AOAM532s+PdijVCFXi3P4J6yq97IgmrvoD2KraWDhiTMG6GAwtS8Mn79
        R8RXPlk2K+HUyi23m+Vyr6U=
X-Google-Smtp-Source: ABdhPJy9UOLRclZUQ2WkJcxEZWWEX5r4zAVmDUKw58zZX2waPMJkT2eIih5bB3RLblTV6YXl5p7MWQ==
X-Received: by 2002:aca:75c7:: with SMTP id q190mr2978209oic.129.1610127573359;
        Fri, 08 Jan 2021 09:39:33 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r14sm1909521ote.28.2021.01.08.09.39.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Jan 2021 09:39:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Jan 2021 09:39:31 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/13] 5.4.88-rc1 review
Message-ID: <20210108173931.GE4528@roeck-us.net>
References: <20210107143049.929352526@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107143049.929352526@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 03:33:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.88 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
