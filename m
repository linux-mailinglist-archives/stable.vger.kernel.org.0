Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3F32C839
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377123AbhCDAe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387976AbhCCUIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 15:08:30 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6221C061756;
        Wed,  3 Mar 2021 12:07:50 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id f3so27365334oiw.13;
        Wed, 03 Mar 2021 12:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aJK9QhuRdbIh/7bh1oGUFuSe4sQ4S7G5eFP178WQDvk=;
        b=vNfuusYwO8ucv5mjzC0aXZj3rMvj9faj3ZZZl2GZ2CN8m2oSIy9sBFDNSnoMGtnfMS
         ArV17hYrd4oJRLBxK4vW1rKb9e3hyGLrUyzVQ37uashCAGqxTybS4m1dDoYnwQ/hhKiH
         hTvck7QOI/YxAUBSo7P68JfkxzJ4hBsRqnAXf1zbtYggQekeGnX6Q1lMuKapeb9IIf7C
         w6+71vHYy4XvDsZ4FMfOJSqo/gM8EL89C99WZQVRrQQFbylcuE6i8v4AYPZVISrXZiiL
         ijS0gs4Vqus5hlj8cC6yUgLSSiowTuU1n9YG9JjiBk0yEium6vzZcleRxcSKjossPtLv
         ttNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=aJK9QhuRdbIh/7bh1oGUFuSe4sQ4S7G5eFP178WQDvk=;
        b=YeozWCeavkeVFbcqs1cl5FzdDqBAdhX9R162bqk3xPdPKPgSQt7FF5PX8hwl2G6oec
         qLVqQ1y0V3MXL1fTj3tf44fEmyOdZ6QJuUxxmtDjibwsn+OAVAvtOVxudPFNNN11Y0qP
         ni8OneYHil1Rkqdk8HUJkUXsJPvpUJkQq2YnTlBFO0PsvXxASjZ9J0iDLTDdtDfQfdT1
         7wSAHKqb2IR7cIEeViO1O1oNASwqM3HPmDhMxF4Xl5vTMICuTr6CTVB3GbT2J+dtVtzF
         ufZUV9oVcf/p0tI+N7MimoLIco1f/dj4ehe29CMLdPXx84s84hpS/M1UxNWTdvGbwyY/
         Smsg==
X-Gm-Message-State: AOAM533C5WiirwuyN4JRW5HWOjSW1Ssz5VvUlXL+8OjbRwJEY5CrlpJd
        HjkbUmer2QVJCzIn7gvLtm8=
X-Google-Smtp-Source: ABdhPJxLMKbcDtbO/1+H04o5fhPTsg4jbhXwqtr9uS4A5xXNQrT0odPNJIBvMeVhCcRgYaMAqOsu8w==
X-Received: by 2002:aca:4454:: with SMTP id r81mr422329oia.129.1614802070320;
        Wed, 03 Mar 2021 12:07:50 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u110sm778255otb.32.2021.03.03.12.07.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Mar 2021 12:07:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Mar 2021 12:07:48 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/337] 5.4.102-rc5 review
Message-ID: <20210303200748.GE33580@roeck-us.net>
References: <20210302192606.592235492@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302192606.592235492@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 08:28:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.102 release.
> There are 337 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 429 pass: 429 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
