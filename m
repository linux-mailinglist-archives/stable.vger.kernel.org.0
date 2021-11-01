Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48FB442420
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 00:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhKAXjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 19:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhKAXjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 19:39:07 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FAEC061714;
        Mon,  1 Nov 2021 16:36:32 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id w193so27379588oie.1;
        Mon, 01 Nov 2021 16:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IJUmQCgOx+KQzTky6HsCgNRZ1Z2U2s7GjcHApDbwRBM=;
        b=WPFcHjiNGvDUYs8H0mqX/QZS1EaAKMTOvuT1c3dALnDmCmVkIFDwFaMPGOSgCghjlB
         45pRj2Fh+x32lrml9QOid6cIC237Io6iJG0hODG6NHRuiiLTZCQyq5qgRruLYPw8uz1E
         q5sKUZLpnnswc6dIJ1kgiJ9QBpMjEX3eIzWkbUd1BuKHtXhnQ13QiYYZBvtbaT2KQvL7
         k1Ui6vHUUK9dJJi13XH+nNoMxX4tYHwYy80e4+ldGr0fwjjuNBwZk8ryhL4GjEb+g1tK
         dhYkX/DTdkyoK/CgYtCqRW7uiDQ/nWlXLgHbUfvIhXw4C53vrmC1z+o2e4efewOSZLK1
         z+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=IJUmQCgOx+KQzTky6HsCgNRZ1Z2U2s7GjcHApDbwRBM=;
        b=Loi4VbX303IgS4pI024ulkSeyt+/CcJv1CEyg61eB9WqB32g50t7tqwQfyF18Axwf/
         REv42EoUuh3cBVGkCxVrfnsrQP4XQ76NJrGjUQ8/l0UyGK0kk/FWMZT/PXQTZ1F66L0i
         ZsFOExMFCW95eAoqJAPgxme9MyL//0xOHXgxweKgOJIJJ64vSMsYpcr0sjmUURXQgQcj
         xon3PE0NyqTJ+Q+BfDFCDLFnEqVur0LWxj6cHCdeMQpxEdDiBNfMFO2WlSZtl1hyF9aP
         /KUvb306sS8h9V9+3GiF0kguiZKYrdi3H0josvVyzHrl5Ufcw2+jvcjfgAmEthxtk09O
         VeKw==
X-Gm-Message-State: AOAM532PNAjxcA5fOaPiRFHXBmGyT07ln/q6HBOaf4BMmSqZo53yfmpT
        E1hry2Pnc8RjE2COr6UMQTs=
X-Google-Smtp-Source: ABdhPJz6S49+0IAXxdrAPWETRKT5tCNRvUpialYOofXtLFxeDR/Y4nBemHNVNKL7nCNJPZlhsHN5xA==
X-Received: by 2002:aca:bec1:: with SMTP id o184mr1779265oif.43.1635809792380;
        Mon, 01 Nov 2021 16:36:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id az10sm88804oib.45.2021.11.01.16.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 16:36:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 1 Nov 2021 16:36:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/25] 4.14.254-rc2 review
Message-ID: <20211101233608.GC415203@roeck-us.net>
References: <20211101114159.506284752@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101114159.506284752@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 12:43:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.254 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 11:41:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
