Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9692F3A82C2
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 16:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhFOO2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 10:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhFOO16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 10:27:58 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D18C061A3F;
        Tue, 15 Jun 2021 07:20:11 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id r16so17959506oiw.3;
        Tue, 15 Jun 2021 07:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pFlr+RLOm1WG8uuE3h2j2F+f4+ZzKV6JFETM29Xi9f8=;
        b=BfDELBRbrruaB0M0FNN4Db+FSrMSOLFYdeDec7OSJXmCIcG1uuxfh4WRZ/MeE/6r4G
         4ziIxPxIzczD866vINtAEXsa8TqThRHpYMEUwStD4hfOAUngjni87dBGSRNctqKP5J8q
         nJtPOIIBArQciMNqsTcwYgFFBh7CAFnTo9rOPHDuBp30qTt4vmkBpo1EhLVwk6lxi8Ew
         sqHvckvE7rg4zR28v5mnbIw6Gn9xrE9RWbbHeDY5N8pcFWwJUKkcuE2kpNn6xvIUu5C1
         Y8682Y9z10RTOrgLX2i/hJ6ysn1zH3oYHZvS3o2Kkg5Qk6ZCdJd1aQWqTl+hM/bvPd/m
         35EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=pFlr+RLOm1WG8uuE3h2j2F+f4+ZzKV6JFETM29Xi9f8=;
        b=DiqJWIBRybFO1bFBpjUDNrMctfVRIPiXtRehdlRJouR4/8k3K3oiH8Ckz4YGAEav00
         LmUXwfCbAC1rXfgwakFbU/WfAfXDei+5+bcNm0DELWCBva6075NDt39bLWUahZUPvfb9
         OVfde8OU52CTmK4ADIGYQPjHq3wCQ70lzXgaZOSvqf/XJX9qja09o6LOfbSFRJAHGKTE
         7m8695hupz6bzOF0Acb4Q/RcXANsfP40fX4jIO31dresysR0BZxGALyhvxOgCK7OOaS7
         7uHOEBxMqZKjK26VOtFKE1OrX/cM5ObbKtOpqx5O/Obhsz8zomYfSSTNb/WvZYRxAKmr
         vzig==
X-Gm-Message-State: AOAM530ghJd7Y4ChQ62khe9hFFxlbw8zLOtcTfHofbolMqrwMI2eYqcc
        MoVVarx0rOWvrkV31Dxqzhk=
X-Google-Smtp-Source: ABdhPJxCOrJExlhaNcKPanKJYtL5ChB9gUq5HPGa2TA2AUZVlkvpho2m/+O+84kvZ3SKFDJ7vnAyLA==
X-Received: by 2002:aca:3102:: with SMTP id x2mr3360611oix.112.1623766810837;
        Tue, 15 Jun 2021 07:20:10 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d20sm4090477otq.62.2021.06.15.07.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:20:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 15 Jun 2021 07:20:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/49] 4.14.237-rc1 review
Message-ID: <20210615142009.GC958005@roeck-us.net>
References: <20210614102641.857724541@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 12:26:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.237 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
