Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD82E2FBAAF
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 16:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbhASPCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 10:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404110AbhASOlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 09:41:31 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97C1C061574;
        Tue, 19 Jan 2021 06:40:50 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id 9so21382211oiq.3;
        Tue, 19 Jan 2021 06:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4NBmLcnVw29sspbm6VI7W8jiNX3UvL9FBZltWW4FgUg=;
        b=Abhu/P8W3bZRLN2HisDNh7H5Xf7J+b4BUAUxrEaqyPIJsYdYigMEtM1tbueJKEZDzm
         C6CfGtQlFtUytAmA2zwkMe34r5w90QiMrjJcJnhR5Qg/eu+40r5AIlKqpy1LNnW/5bE7
         XZpH24NQ9NRLPJnYlCFMvxCL8kbPgzwiW6rxapNumHriWNutu1BQDYyf/hCIRAhMxvhp
         tOxdNZ2f11en3a02PQioZAJg96vGQy+BA21DF2SKAT5C0JQNufOxfXyt0Vajr0VUXr4N
         eXfQKPRKChLYeKSLV7T4BxQCbZ4RfMO8VEviO4mT5GE7h8r97eRnkysfIxT6tNIENhRj
         isDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4NBmLcnVw29sspbm6VI7W8jiNX3UvL9FBZltWW4FgUg=;
        b=K3baHCsTv+CEbeYRZdDUiy8W7Tpq0pGNak+GDaMmf9mvXYg2RSXSe4nI6vKpWmfmTK
         aPGZAdcDDNCsqnk+TmNfOOJCDHmNA9AhmV8g6UHdgMDTLq207lvmQQJM1Fitbo7GY5oj
         HkG9SpyrvPAlNd14R/7mdmai0qUeDAej9nWeCD4cplOfQQ/S+loHMSWIOdiqjaTuQuLO
         LFXcrX3OZwJjft3KHZvo4duCRNPfusoha886bSqF5C3sbyY98gw4+goAlOIwW4zEDFmN
         hHXMm5xmHyiK5huKRGemSdj/IEE4VKt9y/BA17CEdN8/jZ9sMZNdDgvW4ohXjOKuNeG/
         Jtrw==
X-Gm-Message-State: AOAM533WjI1LTxa/Z4pUfYJbqRHoScxkpO4RfowYC57AkRtVgRz+4RzV
        FA4hg0oJCsdXD/ADdJ1JuQo=
X-Google-Smtp-Source: ABdhPJwt1iLpUDIR380X1gMoPaCPdv0Ed17TVAzShkV6sfwunEwJ3Yc7YBZISYqOVhS4/IM5+HQn7Q==
X-Received: by 2002:a54:4899:: with SMTP id r25mr3158oic.28.1611067250195;
        Tue, 19 Jan 2021 06:40:50 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y17sm793266oie.7.2021.01.19.06.40.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Jan 2021 06:40:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Jan 2021 06:40:47 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/42] 4.19.169-rc2 review
Message-ID: <20210119144047.GA54031@roeck-us.net>
References: <20210118152502.441191888@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118152502.441191888@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 04:25:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.169 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Jan 2021 15:24:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
