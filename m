Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA5434D994
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 23:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhC2Vdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 17:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbhC2Vda (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 17:33:30 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28269C061574;
        Mon, 29 Mar 2021 14:33:30 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id w31-20020a9d36220000b02901f2cbfc9743so13657597otb.7;
        Mon, 29 Mar 2021 14:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZL1jhbLA0RzDKInjdrc6i0vsnwU4zds7uaD1vLNhM1I=;
        b=kBBjDieWAvi5IyN6Ay4Jl1Kq6LAQWFdvF3DSsFlYTvU9JfOGxunkwdOILs0meuC4b+
         YSFTnFVFtU4WDPgvlLmOF4BcZKMeBvECIaG+F5unZBvhTFJt0iz3kkpMGIqV609uHQFx
         NnY8JDW1/rOP+WMuELgqsHLsMRpPVOL87d6S2BlvDUlOzxASfWNcVegwRGP/mSI6piMG
         gqSX4BNLuGhttxPaFdp1aBF7tQ8uXjFO0jWamQ5WK0jAzL7jqshvbgn0nkldTkKhyioG
         wWPvf1Z4GOOHRit5ci0QJjfsFY2IU0xjW9sFMOJZq4chq+YdwzaikQCNcOyyK53n251F
         HlZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZL1jhbLA0RzDKInjdrc6i0vsnwU4zds7uaD1vLNhM1I=;
        b=InawgzdcIv/3q5TXD1WCknT8wblGIKqM5D9gkBZ33dkCoGQbGrd9o5kFF/1+HfeZXR
         Pet1k3TtLUe1x5VKLiII1gOt5q8D1K+vZD5iWGBeClHHAaSYdnCWQyfeKT54q6HeuJzY
         laOctU5L41nrmpMZfub10j8GImg8ldH3PgsMBbwZ3/tc2f8bMvy9dvRMVRkqKMdEDtaC
         FzWdG+9UeRvbOLdHc5nz2UgZ1IM51D5u5MVziIBBpZuuP83ZQ34iWFi9CS/r92Rp8ZwW
         mQd3yijlGw7ez40LFTUz11yWu+ISiRwF7mcmIo1t9KQ/1gDTJOay7+hI8T2tXg81sChE
         FTig==
X-Gm-Message-State: AOAM533BkVIKwyGVcaPUzcbpnJcu/2DTNPCBvoAxkZjoHxMRP1/pQ158
        FXsSH+QXvEkCWXJtinzitKk=
X-Google-Smtp-Source: ABdhPJx2u58A9XcwQRzRrglzXxRLSMOGyNyTPBPIy4/XiuSjy1uG+h6/ckwOcot/amnJyXDIzbSFyA==
X-Received: by 2002:a9d:7081:: with SMTP id l1mr24057693otj.358.1617053609656;
        Mon, 29 Mar 2021 14:33:29 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t19sm4730986otm.40.2021.03.29.14.33.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 14:33:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 29 Mar 2021 14:33:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/72] 4.19.184-rc1 review
Message-ID: <20210329213327.GD220164@roeck-us.net>
References: <20210329075610.300795746@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 09:57:36AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.184 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
