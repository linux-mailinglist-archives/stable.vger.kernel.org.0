Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D85B3DC363
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 06:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbhGaEns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 00:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbhGaEnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 00:43:47 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2A4C06175F;
        Fri, 30 Jul 2021 21:43:41 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id q6so16180400oiw.7;
        Fri, 30 Jul 2021 21:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=63UJPytDmWSmeZ+lKJGSFrNIn1Uhf2PcgWbxKjkIOgQ=;
        b=Ers4H5hjBy33yC2S8taUistlG3bu1QcgkOtrAx2UupIRv0Ek0CK4Wmq4p2yooINN4s
         n25UeZK1YOmvNdfYk+S+Z63jh7qklK4uFAlDFkco4J2iVi/JrU7QY3OYD8/KCrBEl5d9
         HisugdodxtpXwgbn4LbbjLt+wBWmKiGgXU3trJfRWboLjNQMj30r+huMqJZ0kpxJ2IgG
         bOoaIFi1OpPEskvSbTHQBiV3CK9y1PwWf4wZnlug3NG//bPh9+SqP+hAmshYfDBcH0SL
         IeMZ2QbxRM9Sy5jW+Rs8mvcqGmISbKulxJEqPXlRzy+7AxH+9nH9CpuHbnWK8pZpVIkx
         YIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=63UJPytDmWSmeZ+lKJGSFrNIn1Uhf2PcgWbxKjkIOgQ=;
        b=jq3GAs8jf5OUu1q+3Vc+lGin00QJQHYz/eCG46WOck6RXU1AHFFcOJJz6f7wod8OWr
         7Rtnubwm5302bD0ZpdE6PJ3Pr/mn+yozAPUnZaTmYEjQQ2Gp5qXOrBMePM8IiZ1w7pNZ
         tYF7kJ3xlmPbs8BXKyZ301ibBOhy2k3kItSr8Rg2fKrlaIpkcYpJ1lmYqAD4veXTZmAM
         dLJ8k5oaBoMiaC1fqslI4PSlx0kEF16vzsWkGvvvXI03OHRI07nEZLFLU7n+wLFDrPjd
         9WAAV9PUnaDVNFCXYNEqnjOxW2n9/Km5rfE/mFf1Gk+xu7CHQ/ha03RLUGiLqtB3WUUB
         Enkg==
X-Gm-Message-State: AOAM530yzc8wnaWWBfpXChGacRuGHOHbNef2MMPdvm+bfK7iJPW1y5IU
        seQUie/bnMlepIZecDPE6k0=
X-Google-Smtp-Source: ABdhPJzcJcQGuOysxdTf7G0xB+Wm2pmJtlloBNyPTVKfc/ofbu3mm9WNVVf2u9MqcEdtXbbuH2zwVA==
X-Received: by 2002:aca:4b8e:: with SMTP id y136mr4481139oia.48.1627706620703;
        Fri, 30 Jul 2021 21:43:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a24sm694530otq.72.2021.07.30.21.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 21:43:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 30 Jul 2021 21:43:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/24] 5.10.55-rc1 review
Message-ID: <20210731044339.GC3455442@roeck-us.net>
References: <20210729135137.267680390@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 03:54:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.55 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 463 pass: 463 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
