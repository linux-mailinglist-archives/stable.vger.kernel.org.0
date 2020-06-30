Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B8720FA75
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 19:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390273AbgF3RWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 13:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387782AbgF3RWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 13:22:53 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAED1C061755;
        Tue, 30 Jun 2020 10:22:52 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t6so10270693pgq.1;
        Tue, 30 Jun 2020 10:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J6Dvj7NV89wtkvCbV5PS8A6g9g8HFEftK3QgrFtRilo=;
        b=g/s7bBu9AFFOZRsADDL0+VWTuLa+5OpWlhlEMbwDuwqSYh2F/5wLaZPZgUQvk43Hh6
         V8TpWgwJyEn4olTVMI02Fk7GPj81v75E4d1Nm0dskOlxzJDkvzbNfJlPtU39QstaghSd
         mHTjTaV7upKteM00D9YLHN8Pz/GMBdZfNyVEbmKYU4JbFd6GFfgF47SOpx0h/iK7KiBz
         EwDMXMx3Znh50rsvyNHhaQs5nDynWZhrwT4zXK0+0oSvpL/ublmywESnVhdb49ytUfX+
         FyOrpoeOxDaQkj0hmChs2h5V1YXUFXP4XzJfZv67W1H8kQph+2Ole53XNsZcTWvxGEkm
         cK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=J6Dvj7NV89wtkvCbV5PS8A6g9g8HFEftK3QgrFtRilo=;
        b=aGhHSkEgpgDCEsojNUiYRKl1uHeLenqdMJrWXVEWo14r9NNZTKfbtVNZIiIoWAr1RX
         ffdNYGX5p7tTPmKcbb/kH1OYxYSxn34+k0VBkKmg9eLI2vtZ+xEj/f49h/Cwva/8g0Hv
         IDTFtlnv2rcx1D5DEkJMSJhD9ZJNGN1oyTXfC4eCcimcSGNGZmltzVHgc/JE/mnxkEve
         n9MoPb28ulzRlMIESd7oDHH2APTGHPTUbrT2RtZwY/erE0suCvB8WN9skUsXmlyZhUAJ
         /vVFHbYHPrIsC70+0exUtlLKxRpB1ZKHsKVAKEBeQHOH4ex6gFDOtG5m4oT0CBmK2hpc
         W3xg==
X-Gm-Message-State: AOAM530zMgZPG5q78bv/onZ6b3W6HOQjNqNrhO3v8CjBvyH32AqvPBF+
        y9TLdQF4zRRh+e/XWBLcOII=
X-Google-Smtp-Source: ABdhPJy4ftEkmB29eQLApJ31FyqfWRoPYSPTgo7iYHBqvsZ8vLoEk8waL7/bZhnr+ROtibaoSQBpIA==
X-Received: by 2002:a65:6706:: with SMTP id u6mr15844632pgf.69.1593537772533;
        Tue, 30 Jun 2020 10:22:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o11sm2764076pjr.25.2020.06.30.10.22.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Jun 2020 10:22:52 -0700 (PDT)
Date:   Tue, 30 Jun 2020 10:22:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.7 000/265] 5.7.7-rc1 review
Message-ID: <20200630172251.GF629@roeck-us.net>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 11:13:53AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.7.7 release.
> There are 265 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:14:48 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
