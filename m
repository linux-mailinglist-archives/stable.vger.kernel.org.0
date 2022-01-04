Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03A04839CB
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 02:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiADB1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 20:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiADB1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 20:27:51 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5290CC061761;
        Mon,  3 Jan 2022 17:27:51 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso45359002otf.12;
        Mon, 03 Jan 2022 17:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Sb5pT0iNGAozL5mU6x3zpaGMkVZ/7kk73JpP3l9SuA=;
        b=MCggA5Bd/HZ9KUo5HX5s9day7o24UjbNEwRI42i7ivfzgcSIo+lgCJTjNxe/K3LLi/
         9jDg7eBEren57BadB7EKUkSWzgGR1tme7OExBJBG5TqQJlZ+zCJ6jeDWW4Pch6fu7HN7
         czty4iuXYcWh+CaGpzKBZxVvw4HW3zM8IPBRK8no24EVUfH4cro5817pJs4spncgQS6a
         vyUug7THRLi/FPUp2vLfDb29RhmE4FYDHSyt/FyVYKIyc65GmFv1p3Mk1NR10sJbX1FM
         1pTk+DXCVn9Cx6mm+ZFq++JddEpB1rOVqmGyeElDO1EGprBwjy4kaWqct0hi2JDigiVb
         hHVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9Sb5pT0iNGAozL5mU6x3zpaGMkVZ/7kk73JpP3l9SuA=;
        b=UB6hJJuaS4HRCaYZfKmoM5CCiQwIgvflOCmly9rhP88mR8DBf6uHh/wjs7EN72RXn2
         PpZW3dMHGi7Ddc9/eKCCehpRrBdN/zDLdVHjVARta5NX2Ygua5SLG+Ga+0jigw3c0q79
         R7snZJLBlp1tY4N1sKy2VHn3jcgoBhYzLMcVz37Gr2L0kQ8EEJZTAEyGjjlfuD59RymX
         g2XrIKxXKR48Sh/lYjpy2xPA3REu2zvlNh9dD9TDk+c0pwQFGochoVbqbWtUKWnzsWun
         gCTci6bY3DUh/1I/nJ4/nG2AEgv8hLWobx/I4+BvSMeW1yjQsPsXLsTQnCMthnCqcP/D
         kN6A==
X-Gm-Message-State: AOAM530HyHjUnp2g/NSR9ZN1NajNuBC3+yOXEJnQslIxkmIDupQ21vsT
        pd1399S8J3aQ60IgZqIlXms=
X-Google-Smtp-Source: ABdhPJzLHeThsWwJuncIJWSaZTAVp6gWK5gppYIL6ETxReoznZJVGWNmGbnfrbn14hA7OfHcvO1iog==
X-Received: by 2002:a05:6830:2058:: with SMTP id f24mr35127838otp.288.1641259670736;
        Mon, 03 Jan 2022 17:27:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bb8sm9611143oib.9.2022.01.03.17.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:27:50 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Jan 2022 17:27:49 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/48] 5.10.90-rc1 review
Message-ID: <20220104012749.GE1572562@roeck-us.net>
References: <20220103142053.466768714@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 03, 2022 at 03:23:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.90 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
