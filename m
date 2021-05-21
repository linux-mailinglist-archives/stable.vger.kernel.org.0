Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E2E38CD17
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 20:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhEUSUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 14:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhEUSUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 14:20:53 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FF5C061574;
        Fri, 21 May 2021 11:19:29 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a4so21978625wrr.2;
        Fri, 21 May 2021 11:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bP1OBfDs4KD+K4cD/AOVe+nQMXQTA3h3ZXpDwh0Qrew=;
        b=TvLdG5Y8ImoaU8uF957umePYhVTazuleMDhGMglTD8kZfUWaNs3lRZ0BFlUk+gE/V2
         fvgEImKPi5Tf9yVAJFx9UeB2QYAKCgjgrB7T4Na4RdgfjLqkGqio5t02J86gzZzBsja2
         FTrkeBSAdoyyTbrVPbJJ2rNQ7+E2a7OnYno5ZztasIc7f3mpG17JN33MQ4oinKqZpvXo
         MGGwyR3B9VG2d7NNoFG5QsLIrGZ3Y7fZyOTysbRNmo3wL41pdxPtD5Uc3NGUj9v0/X6C
         q0r2kFzV6ikvZQyxTdPLJ4OTUNIjx13ICc/DWKsPN0lSMUXEarmElJryWdVU2pDDKnP7
         aS/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bP1OBfDs4KD+K4cD/AOVe+nQMXQTA3h3ZXpDwh0Qrew=;
        b=JzaBvNAsk8dtAUYkHy56/YYFrhEwavl+JkNbhHOrRZcuuVaomyxsyikBZ/KQFqR9a5
         LWBWirlhaxWh6AF8tyb74uqLoPeREF2/B0l72FlYXec6+OkBSPqV8UWv35MqhsUfd0+U
         2AzHs+yNTTOeetzNgMfRTsTiBsE2o1FxILKWl/qX8L+bY7G7JeF4yqVuktQH3+3P6Loi
         zX69q1Kh3syFcaqUfwoI5PHkpN2BDZTVW86h6Vr8RaWjQa29VAW/2GQufJNhRZZ+E/7Z
         Cjun4YYu+7zKie4q4FKsJTriT391o73ACxZs18zW5VoD2vHG8lsP0he6FB/lQMh05WDC
         +DfA==
X-Gm-Message-State: AOAM533V5fZkfUKfBNy1kN9rcgQSAnGRdddiYY+IX2Fj1cAJAjquN5YL
        UV2VXkuzFfw6SO5WwXbJmUg=
X-Google-Smtp-Source: ABdhPJyqaQROlMr+4NgD7eQqfiPz92Dm2vJuO+1OHno5ZcpYTIsx+FRvHqP6SAai4+8HqWDlKuBFJQ==
X-Received: by 2002:adf:ee89:: with SMTP id b9mr10723902wro.139.1621621168150;
        Fri, 21 May 2021 11:19:28 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id i15sm2872180wru.17.2021.05.21.11.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 11:19:27 -0700 (PDT)
Date:   Fri, 21 May 2021 19:19:25 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/45] 5.10.39-rc2 review
Message-ID: <YKf5raJ+hth18BsH@debian>
References: <20210520152240.517446848@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520152240.517446848@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, May 20, 2021 at 05:23:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.39 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:22:29 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 63 configs -> no new failure
arm (gcc version 11.1.1 20210430): 105 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

