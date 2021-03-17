Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3418A33E759
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 04:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhCQDDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 23:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCQDDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 23:03:11 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D01C06174A;
        Tue, 16 Mar 2021 20:03:11 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id r8so136897ilo.8;
        Tue, 16 Mar 2021 20:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NTfw5SCxLygEoa6GNConM/IkSokNjS6CipSRiBQTe+c=;
        b=RK76gHFue0appQRcff+TLL9rWLs+8veSe+2aRzDVX+19ZaX+7AHqKPTVmLWPTK6Bnx
         bVog1cYmV0xLRN+rxTdbbYJ4yReCsff4+xCpYoUPE5pRdNVa9j45yzs5Jo+P66BDbRXb
         L3JHJhh36hdEhZlx7LM3XmS8c5nUDC7x1DLhfGoUuaR7j+U7e9khVd5F9jEbfIbEdszx
         EGDr4Hwj2iRniI1NFm1rtqQgZ0rYUGfFW1xD06WZDR3KKwAju2TBXNurRZIxPnlFmSnV
         Plqni1uvLcDKSH1DXkQ9US26XYXClOXav9X1dyW2TXPVL5I/jjiekmE0vL1ihie03iqZ
         AxfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NTfw5SCxLygEoa6GNConM/IkSokNjS6CipSRiBQTe+c=;
        b=bCSAeptEBcuyVFi133duo/d/N3N4iVz/K4285eKYLEyNzRFY3rJ8pnk9vb7cWPquld
         /eTOH9pFKDuKdS4a9Ltv64BkORflUsDYLoCeECgpm5EXZsyIjPL14zYG5xo5i35pMBMB
         MHrT8jm+egr6n00IA8USGJS8DbMRtqtWVfRidDxHlEpXnitnbI+AaIlBiWZLdeW33A6U
         TL+5D8ToaH2fLak+80gNSyBxW3Mao9221bvNoSYSWjDde4nXL3LqklB8uIkPSDWVDKxV
         xYUyTULSbDlV1UaeSpJy7uP1xJ+/AfE5OEP3w0ZIts/7z0tjiq1ly81srbjcAiujO8+Q
         MNKw==
X-Gm-Message-State: AOAM5333tJX0jKk8QF4CtslOBRX+1PBVoEMTQ4RBn72aWsPIebvM1IUb
        TAWKs0gdTzdh/JjF82Yf7xas0O6zWomnlw==
X-Google-Smtp-Source: ABdhPJyc45szgDOzKTPq+kYdy9XMGrNXS5DEPY75CPh8dlc+kIMnIE3/7O0QB6JMFO74YWz+RjdpOA==
X-Received: by 2002:a92:ce4c:: with SMTP id a12mr6006763ilr.258.1615950190498;
        Tue, 16 Mar 2021 20:03:10 -0700 (PDT)
Received: from book ([2601:445:8200:6c90::4210])
        by smtp.gmail.com with ESMTPSA id a2sm10670262ila.81.2021.03.16.20.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 20:03:10 -0700 (PDT)
Date:   Tue, 16 Mar 2021 22:03:08 -0500
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/306] 5.11.7-rc1 review
Message-ID: <20210317030308.GD6466@book>
References: <20210315135507.611436477@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 02:51:03PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.11.7 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
