Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D73407A4A
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 21:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbhIKTi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 15:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhIKTi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 15:38:28 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BF6C061574;
        Sat, 11 Sep 2021 12:37:15 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id r26so8226925oij.2;
        Sat, 11 Sep 2021 12:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hRNWUPpmCjy7m4Rp75teMEByk49mDZo7YIztrFkTy5M=;
        b=KdMf41xL3k3dY4OCJ3WFnbDjXsqPZE5S+VfEfsKnFqtOjEXDkW97qmFkefR9drOfAk
         E7HC9DrY3Y5EtKGVAajqQYk9OlmxDZsFVdo+0rL6lPjxEnGM5uY+LrDeCL4z+bXv9MbC
         1UHiugHb3SksocvtE83MEMpOgvswLyC6bvpoCuV4zanoJwQlUTt9XIZ4oiHAql3baZxJ
         lswTpMr/UN1nZF3EjVllHY3e8qoE9cfrZ+G1Tr1OUWGraeLGDkGxiQyW8fi276IvLA+V
         bImyAEpNVUzhsX064BoC4kg4GcL5H6BOiy2Cf9E9kee74HoXO40JPvL2RxNvZr0HDAm6
         EDcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=hRNWUPpmCjy7m4Rp75teMEByk49mDZo7YIztrFkTy5M=;
        b=5CRSO/tfsBOUhgYELCJYF5kGzyXWPIUgB3pUPzBqMXi/bweA352ZuqURCjTNi5H27e
         snq2nAVj8afak5Zb7CAiABvxnC0DxEismHxk3YB2TbOuKHzpECNOsoR6RcWdDU0wAUoo
         8UOZtzkDF0GUR7gW72p3zw7d81VgvVPndNXotar++HxkO1z6/oQAR4gC1u8eB1RL2cED
         UoK+6gMFrepCIIO+ZlnEVdOeXznzNulh6sjFDP+vzurYP6mAOtbWgNKVOJ52XLVA6Amt
         UQbuAu4jar3PKkbVsME2z72Sa2V79HGERX/4RhJlSJofZgkb+db0GM/DGqV8L2GN52T8
         sS4g==
X-Gm-Message-State: AOAM531sndnp9Gi+CGh6h8cDQNWebDd5cS9LAloiemGMRRYeTTHJiLnD
        ApLtTSbj05irQ0IEqFDnZPA=
X-Google-Smtp-Source: ABdhPJwKkYQFkuSdbUv6HE6WYcPSy/vwqZRLwaA1FYPBMST4ISV+nJC3F3nSX9/gblkztRJcYDEG5g==
X-Received: by 2002:a05:6808:199b:: with SMTP id bj27mr2702364oib.118.1631389035280;
        Sat, 11 Sep 2021 12:37:15 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z1sm635385ooj.25.2021.09.11.12.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 12:37:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 11 Sep 2021 12:37:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/26] 5.10.64-rc1 review
Message-ID: <20210911193713.GC2502558@roeck-us.net>
References: <20210910122916.253646001@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 02:30:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.64 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 471 pass: 471 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
