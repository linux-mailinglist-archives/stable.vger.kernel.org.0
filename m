Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D897C3E36FC
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 21:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhHGTvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 15:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhHGTvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 15:51:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4250EC0613CF;
        Sat,  7 Aug 2021 12:51:25 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a8so21692308pjk.4;
        Sat, 07 Aug 2021 12:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PUpPOWxL045CKRo2uxohAQk+V9FMO9Xk1/XrIbM1nk8=;
        b=YfsqI6kzLUEA/4W0wphMzZIcGh5p9MLUcmNr2h6AhMxbpb5iVfpNtJIG0tqG2YLClp
         Iog/Z8FiFRROrW6pNwKlS/tsFCKX/DFEFVPOyrAzBvBU2cxvPLP394rHTYiU8Rhzt2Rt
         kuJhMCv582ziAd5xgeDEpiSZkMGq3Q5jt9PliwJzSdWYCTjDLb8lnJD1xUwUCmSNRSx/
         Xs4CMRagEjkr7k7MWYYy5/SvKXvbbxNiEmgIxI2e766vD4Rt78Jf6D8gEUq+5c12ye/L
         Tl6nys2V2YvqaVGQ8NNkP8tNOe+SMOExbuIDcOPjthRevYnPHDmtGkMR/70njK73cf2l
         NCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PUpPOWxL045CKRo2uxohAQk+V9FMO9Xk1/XrIbM1nk8=;
        b=HqX42K3MzO+fE61L7atc7EAIMw9D+3zP2XTfRWpExcxWIztKSHDwNed/z/ZfEQT46o
         RTsldVqA6ymb6fYlTFEJM4AOWFH2HVHywI8vGNm9G6NLRp0yr0eRFrxpzBdrVLj2ahOh
         eIaMTt7AptpQLhgr3NFSc+aejXD6oaOn2c0Tc49Rir+tr9eAWnwTEB3LVMatcJC7iaUP
         haF71eKHgnwt+faIF7NICsnLzx+/ZiHaLp/g3Jiof4m3SHBW/yLgIFnIjI/vDSdcIZxV
         Sx9WU1Z/oaxhHemGa5CtX8Z4CjLxFO+uIQD7FuB8XzbOHVTSbapMrwfV4jbtFbxzZEMI
         N+jQ==
X-Gm-Message-State: AOAM531cEMwAoX8yfI7aNSnW2BQDIN7qCyByGWNDPt03X6NAMtq8Wdps
        LDlTzWirUdi3ZhVKilRNJzcEkYs29OS87Uta
X-Google-Smtp-Source: ABdhPJz0Q8RaphBE6dk6xq2EXZ71TGra3pL/ru35t+5Vcw7avkuLgY965olotCMD9AOmKeO0qFIVXw==
X-Received: by 2002:a63:4b1c:: with SMTP id y28mr179565pga.219.1628365884602;
        Sat, 07 Aug 2021 12:51:24 -0700 (PDT)
Received: from localhost ([49.207.135.150])
        by smtp.gmail.com with ESMTPSA id s23sm9126989pfg.208.2021.08.07.12.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 12:51:24 -0700 (PDT)
Date:   Sun, 8 Aug 2021 01:21:21 +0530
From:   Aakash Hemadri <aakashhemadri123@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/30] 5.10.57-rc1 review
Message-ID: <20210807195121.ezbazpq3xacmuuab@xps.yggdrail>
References: <20210806081113.126861800@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/08/06 10:16AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.57 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.

Compiled, booted, with no regressions on arm, x86_64

Tested-by: Aakash Hemadri <aakashhemadri123@gmail.com>

Aakash Hemadri
