Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B9848453A
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 16:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbiADPvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 10:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiADPvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 10:51:54 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B920C061761;
        Tue,  4 Jan 2022 07:51:54 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l4so23530321wmq.3;
        Tue, 04 Jan 2022 07:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uIz2yUqwMyhBuN8YGnETBaxGt3m02AG4Hct/FwHTsQU=;
        b=gR5YA141XiRw1cgI2hkrHAlkROrC/M2q9CYYmt0VLrZ5N19jCyVr4rABC6FC2suEl2
         RYN+fF2uC+tfIakg7Hir1zSwHoRNRRG2XccKnu223D4EvpP8RjXjlbIAf2++wM6BYae7
         9eVOM5338FVpZ0ly/kFY0O1Eacic5nJnLSBjEt4OODJ4QB0amU76LVD0hy6xrMxmy+R1
         y3Hg8ZjAQWxsweu+knW+19fWaQ3Tb0H44orjE2f6AVWno9pS6Oz5yFFVLCtr+885BFxL
         NVD5WwJDqiYY07rfbbeXp3bSAQvtJvxTE9I4FlSQfqjWeHTPswF/zdytIFhEjhMUkAC3
         choA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uIz2yUqwMyhBuN8YGnETBaxGt3m02AG4Hct/FwHTsQU=;
        b=KR/9p4DUgeqGfF6afxwJwUapuKeS27zHUmLlt2KMzfltxaqhJjEpnoW/8ZNJ3mS/GV
         nMO2zJq8Hn5LUHCEMvKziIXiV0TA2iQqp31buslS5+Wm2Oqk0DICm25LuqwAEpa+5dKd
         WN1V56WmK2+O8tqUBOEGMd5x/TxjQoQ2ccxr6XMjuzimfEE5yZG1/9YMyGTsL59Wv1pa
         udrv9yadXVJ2ujOpTKX29TRxCBLSeBSa1Cftk3vW3zrE9aR4iCvB1yr5ZsleBDGgSZuU
         l5EnRlL7rvUO/5Prnx83geY5vd5nuQgL5t9vdq5mnE+9+01DOLe0ymCojwp7JFabXRFG
         LyjQ==
X-Gm-Message-State: AOAM532UD82VeD06JMbii5wzhvOC0qZeK2OfPckHumyIw1WOadlT9kHA
        A1O99/joDW0oU4j/L+wNOKXW2V6t7CI=
X-Google-Smtp-Source: ABdhPJz4nf89nIW0fi4iCrT/EO75BEnTK2ifGpQri3TQSKu4PeGzd5kb0TgS2uQFBaDgsrMVIT8ZJA==
X-Received: by 2002:a1c:4406:: with SMTP id r6mr42576627wma.42.1641311512179;
        Tue, 04 Jan 2022 07:51:52 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id o11sm41171209wmq.15.2022.01.04.07.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 07:51:51 -0800 (PST)
Date:   Tue, 4 Jan 2022 15:51:50 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/27] 4.19.224-rc1 review
Message-ID: <YdRtFob8gcxqEIZE@debian>
References: <20220103142052.162223000@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 03, 2022 at 03:23:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.224 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211214): 63 configs -> no failure
arm (gcc version 11.2.1 20211214): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211214): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211214): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/581


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

