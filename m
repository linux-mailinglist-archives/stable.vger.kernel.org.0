Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA08D37F60B
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhEMK6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhEMK6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 06:58:39 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE68C061574;
        Thu, 13 May 2021 03:57:26 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id b19-20020a05600c06d3b029014258a636e8so4451603wmn.2;
        Thu, 13 May 2021 03:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=57Xly+NSWZIBK+8LPQSXeQE/SDWHNEyFnj3/Eukl7lQ=;
        b=W0wlhn44q5/POP63bcpTV2uCJciJ1MEXSUziZNOGew14vqtsff9uZSErg6xSWYU+Qi
         1MbSM7V6vjMVSkqw2EUjimnKgv4uE/ChcqdtHuEEG5Cj8nXJL8oYN/U1nVddNKzQIrfz
         HJAF7f4jqN3Z1V/fJFLsXt2CVNhb6h/bmvPzvTG6Lx8idONyqdIc3lyp18B6YIbHPFGy
         r4dYxF32ujd0AedZudp/SMbYXiVXoFN5xQLoDnTQLjJQ46XRCr6rU+2hPiFTB2gFjguI
         IMim/IGLNUKLyyjYIGWip0hUa1+S6dVFLtfSpAWq+NMAkTOnJwo0zM9Gy75I0o0ISkaN
         mySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=57Xly+NSWZIBK+8LPQSXeQE/SDWHNEyFnj3/Eukl7lQ=;
        b=fujkjIscV+rRZBJm1LwaysDcJDysI6x07J8pWPclUWmpjAPVkm9tlrFcHG+gab60cO
         5MplE3mhwFX9o+MD47OYbTeO8+HtgbXJ5axXGuXBEhNODLMdBcANVPpEZsY9l4xabt3o
         CXPDhYfeFnyK9+8DxgN+ysr5q+V04AWqfgfow9IWW0+GtO6iHP3gnOXztLJSjZ+EcwFk
         ChQKq8gM7FwGtwbEA085tCGtXdslStLZp5yKoneJBIGaBLl2OSP5mQEIZv+s6QIhrrCg
         Hc0DWyZR0VTlNF3rnNywOPGtOkmTtSiLT4Jl20WZEKz2xmLeDMLGzXmOSuehiSGk76xg
         g/7A==
X-Gm-Message-State: AOAM530fKejXAi+cVE9ma3l3S8+nAGtedsyXn6nZjRydOf7GjlevZ7T6
        0ZzKDFMrzt19DZtq+IfP+h8=
X-Google-Smtp-Source: ABdhPJyrT6nCeLPbtpMlQzD8HKBbbuXODuizgGK+hc11Jg8kSEgIAB4XK5iscql6Vp6fyChKGA1o0w==
X-Received: by 2002:a05:600c:6d6:: with SMTP id b22mr15574798wmn.134.1620903444871;
        Thu, 13 May 2021 03:57:24 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id a15sm2988409wrx.9.2021.05.13.03.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 03:57:24 -0700 (PDT)
Date:   Thu, 13 May 2021 11:57:22 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/530] 5.10.37-rc1 review
Message-ID: <YJ0GEnmv6xfoN1mb@debian>
References: <20210512144819.664462530@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, May 12, 2021 at 04:41:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.37 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 63 configs -> 1 new failure

malta_qemu_32r6_defconfig fails due to:
[PATCH 5.10 052/530] MIPS: Reinstate platform `__div64_32 handler

arm (gcc version 11.1.1 20210430): 105 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
