Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3CC248E52
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 20:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgHRS5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 14:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgHRS5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 14:57:17 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCE1C061389;
        Tue, 18 Aug 2020 11:57:16 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t10so9635052plz.10;
        Tue, 18 Aug 2020 11:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ej4UqIAprE2+xsJohUSl+5oS77TiMP+1sLd2WqMbAgI=;
        b=IV7su6RfANo8beFpgzQPtRbp2iftLsuEoPoxp4RIi5lYb/euHAR+qxhtsBPtQ2qco0
         ol9yX0+Ho7Ny1++DJwkhn8WrFNHPHTOojbjlwQ11rb2QgEaf+iP5QImoYEWkDgUZ3sDy
         5EP3ThLGWga5JLPnGpCE6rib8uJuDkqxXbKZSkbn1Ey2OalCRZ5uNfu89lBHVgqQ+Wbj
         N+9WarubLGmEjY3kAQ7z+5N4TjNY/WTKclquBMCOss1I9L3BEsDMLg91wilHx0JA87+H
         PgFQIiS25iv7P3zZua1VlFMlew2WdrB/Qoha2+jBB249mF6zrsWr9LDCVG4eqIoCcF0U
         kZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ej4UqIAprE2+xsJohUSl+5oS77TiMP+1sLd2WqMbAgI=;
        b=D8Wo9QsYt01BhnZg0hLqrvMVoZMjp6HEpaukIEUvKXPib6DPTQ77tdDO64hnAIkn+l
         N2K+1GGTzOneYuSNh+4ps0yF8HKQnq4aPrq6nr09zntsJJNvSGgCf/T3L/1LTUbYznEJ
         ZoFhgMa3QbIlwBALSZecPy/MvDc/v4TcrtfS/ne0oQ8NwYYa+1h3JnpXWmWCAHSDdHDU
         Nbd/aq8yAWYS46CdaHDpX0cjMqRIEHLpPoGBixH8IbqeFxfm65yunoGXZVHRUoByE6sa
         KvxSJtnK9zV1/xVPJ1+GlIW+GqEgQ8esZrXitLffM9Lx+5aUl7s5vYEDNMvgqkoouXXK
         HbYA==
X-Gm-Message-State: AOAM533KzbrWKBVIbvxBgg0q0atLX5hEbHQa8mnO1Esny9Aabr/2yBT4
        BylW9ZdKDO9uGSKcEfJpTvVOAGhVryM=
X-Google-Smtp-Source: ABdhPJyMQk5nw/jTTpGsT9SNbi3VG4YV6ePOx6EnGX41AoSRmAOtpx+XDbI1YBmxRhcFei3QsrnMkQ==
X-Received: by 2002:a17:90a:c781:: with SMTP id gn1mr1017299pjb.151.1597777036264;
        Tue, 18 Aug 2020 11:57:16 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m26sm24822289pfe.184.2020.08.18.11.57.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Aug 2020 11:57:15 -0700 (PDT)
Date:   Tue, 18 Aug 2020 11:57:15 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/393] 5.7.16-rc1 review
Message-ID: <20200818185715.GC235171@roeck-us.net>
References: <20200817143819.579311991@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 05:10:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.16 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
