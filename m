Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E563F7D1E
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 22:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242592AbhHYU0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 16:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242614AbhHYU0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 16:26:07 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72740C06179A;
        Wed, 25 Aug 2021 13:25:21 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id i3-20020a056830210300b0051af5666070so559091otc.4;
        Wed, 25 Aug 2021 13:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xF8SzsRTtIqMu4pKCXEqI4o1cCrp2O1VPwPqTUYvhKY=;
        b=B6PCXao/EMSIbEC41PVB1R4bm+2s79z8P1sYonOaWsZEuO7v6CVSjifWZJdWkDNFyJ
         9WNsBjBvyBiC+ScWw8+DCmsWwyauiI03UtWuykbY/nsBBDuEBj7WpqFcUPYMMIIo5bdR
         MNcxEKn7AfZjRh4jPnF58kH9a5e1n5XqfwNajVhs1LFEcJkmwmKS6OIsfHcj5ACihQ8k
         SdbW2UbL/vKmCOoqMDcipoZQvdawUwK/MTwkZaL2Dd+5AyBNYW+MtSRRAcRvSA5IXWND
         Pc1LbvzzaEfo7dz6zIVkO/9yYd5J5PE4lTI/6RMmPsBpd26IeXrsXmfB/S8t3YcAf8rx
         gYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xF8SzsRTtIqMu4pKCXEqI4o1cCrp2O1VPwPqTUYvhKY=;
        b=eqwd0m2jxpXFYYFr34nvEM7D1SsIhgeH2Pa3+nIeZSAT/fNnCpTWBTAhUWVI0Ms49d
         3NyS2KM9IfRGPwGT79OneCzBJSxOs15v6dAz5o4xw9Y7qhTGfPhPviY7QMIZ4SIJQoGG
         dzp4LhA+3dFwtBKgMd+DXCym7KltfW+1NyHTLrjRplVZOuiujTAecQyhY25JF7T/QdHA
         xgXvkuPn9GpLUBTsLf/nvM6WElEA42FW30fO7b7Db/NWHFGQh7fBH3w8P+iEYSzn6v67
         AiWqy63/ellEhhGmblD+hBI+Ej/F6x3XpjgV4+WSQnZ9td0ou1A/FSYR/y2VkwtAd9hA
         wyag==
X-Gm-Message-State: AOAM530mn2zil7jSp5+6qZqD1iuuJW+zawCCmVqpLe/I84v3tlNaGnYa
        edI+jtJu3u7Xua/v3gs56yc=
X-Google-Smtp-Source: ABdhPJw5CVe23WPV0VbQKqF5iqu2+wO4ngmnzLh35RlDFQG9OGBttlWicI09dhVjpO8TdjKFEce5xg==
X-Received: by 2002:a9d:6b8b:: with SMTP id b11mr207285otq.351.1629923120867;
        Wed, 25 Aug 2021 13:25:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m25sm170828otp.41.2021.08.25.13.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 13:25:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 25 Aug 2021 13:25:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.4 00/61] 5.4.143-rc1 review
Message-ID: <20210825202519.GC432917@roeck-us.net>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 01:00:05PM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.4.143 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:01:01 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 443 pass: 443 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
