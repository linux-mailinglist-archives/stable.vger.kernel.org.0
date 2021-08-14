Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D033EC45C
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 20:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238863AbhHNSPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 14:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhHNSPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 14:15:05 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E4FC061764;
        Sat, 14 Aug 2021 11:14:36 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id o185so20766244oih.13;
        Sat, 14 Aug 2021 11:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QOiftqgvbImVUv1mEUfkL2wosmJ7LXw5rCPg1vCf7X4=;
        b=JJlrmr8cpd00ilaSwDl+vgAPGG7Hm0t8dPl2FEdf0MbabeYwrHecdGHFqSmPotClcW
         31or+jUz9sOynwOmo6T0rDZH4ECjmJXhYypouCV6l/RlOEQrcrFVUgJ4wKlD0nh5Em3a
         /kBRW+X3UVOm3bzV5HJkEJsuMKwsOLOywrBoAsijIejQrgOU1JIDI2curFUsmUNm54ok
         Hmp2i1RDj8SRVydpRJOsU3D20JzPrXULVmMGymyrMo+vyzOOJXN5F1Q6FuKEJq4THmP2
         zNBDU7zIvBlVvx4sPuML7wgTCapglsDMv4x05WvI8kbDRhJ2WPSJoUrK8YvvmvJXYnBA
         pTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QOiftqgvbImVUv1mEUfkL2wosmJ7LXw5rCPg1vCf7X4=;
        b=lsbSZXGaEDSl2BMDtlG5i5Ou2rWqLTxff0mztwFobG5UIIUpjRQoUfRfMQjJW8frrY
         icf/mfrr0bFeC6ZYk/ODE7TIKBN0sHup2aH+p6WRQemJACT+nswLIzHXGvDq76m1P2w9
         fuj6cFUvDNo32NwIWiYt24mkZKDDlsEoaoX67u01+yxLW0jyrvJpnCCXRehHlr9N1LA7
         bFnHUe0iF+CFhbRMLevtZUx8sZA5W0J9ekBC2sSy3u4UYpYkB/pJKdFe3MTA0OYm8+po
         agY4r1QQJJuUhOHC03q7NUCVruBKw6i+bH3dwF5fgfJWuzYvg4PZEEgVNDSFu+2Qyv22
         y5Hw==
X-Gm-Message-State: AOAM532BJBGctvo5bUbfenqmu4yO3YyMt0fjbGjrgaiDjFxjjoPe7Pyd
        nR6AEqqcD30ZELuYAUM6+GI=
X-Google-Smtp-Source: ABdhPJzYyxQsjDc3+DpQ0CQMn6/H61jWnEYrh1C4Zf0vG/UlbXIyjTufxu4OBlfpWDBzanTd9WLqMw==
X-Received: by 2002:a05:6808:13c5:: with SMTP id d5mr6175098oiw.56.1628964875932;
        Sat, 14 Aug 2021 11:14:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h14sm1010095otm.5.2021.08.14.11.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 11:14:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 Aug 2021 11:14:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/25] 4.4.281-rc1 review
Message-ID: <20210814181434.GA2785521@roeck-us.net>
References: <20210813150520.718161915@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813150520.718161915@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 05:06:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.281 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
