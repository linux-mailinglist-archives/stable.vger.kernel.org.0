Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33976407A4C
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhIKTjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 15:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhIKTjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 15:39:13 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579ECC061574;
        Sat, 11 Sep 2021 12:38:00 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id x10-20020a056830408a00b004f26cead745so7281898ott.10;
        Sat, 11 Sep 2021 12:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=syjmbfPPh1/6zebrhHEEQXHQ94zDPjRhHwoaSoqgWWA=;
        b=a5oPb0rRvSuxGyGjxfOYQVPdvO7yTZ+CSBLvUMrtMDGU7ga67Ueg1X9YL0QIeaEh9E
         O/bFHWi4xQJpTGeTEgQuTYddHrEN28UBx/mfdDmOTNa/GDbNCVs66TUajQuttCOsGExs
         vDK3GjrcQHrCFkOkO09fJTnxyDnL5hFtDQTXTi2qcX8zzKuRvtSe3SxVuTkZKeasf6P5
         //T/9bUMbwoEp02XvvmxcfccQYICCZm956qcJrL3MDekkPLxtE5cLBEKlC/NEQNjZzzz
         NDjWxBKEytQVw22VkU4Si7vQAmcq0S34QXB8WfAScx5kVrXh7NfLM49/DzWUXFC2kL5Q
         W8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=syjmbfPPh1/6zebrhHEEQXHQ94zDPjRhHwoaSoqgWWA=;
        b=QEa1A4cDWZ6DFowvUdtfOBVNnPR+gTDnomXIGRAU5KQDnSWTXJbKoA1LlOhaRdN19n
         mKgWN4QqP/U2Kc7OzCAR+/4vHsOct24vzkomvfODaYFx9AFJomi1SagnrbsnGprAiM9X
         ZkHRZ8hWgezLvuvm1HmxJVxIbHNWMXcJ9T9bvMmsk2GeP8s7kV/fPxYDe1HKG5JBGr0b
         FJMWJHhNEkuqsG4mLdvPzB3Ms8+yCnPokLz9c/ZP6gShgwIPQ5iq2Ec1dhIhRPPeDJmd
         Dj5c8o1LZN0FS4rN7l97dbXDdyq51kJ31ODzm6mozNpOnCy0ASKQ+bxzNzR9TayuhkXF
         b7iQ==
X-Gm-Message-State: AOAM530HeyRAoEwW9wPheoMGOIB89/Vj1FvY5sRUQKBf6aWVEr9Tx5co
        qga4R5zHGnpvyzVLq4I81AAp+qxvgCI=
X-Google-Smtp-Source: ABdhPJxNYAxaAiJ3Ph8IYuuVNLHSNPDSWWHYEdiLSQLEwfituV47fko0CV5O3f9EZm1nNJ5p5NoFrg==
X-Received: by 2002:a05:6830:70d:: with SMTP id y13mr3461104ots.278.1631389079768;
        Sat, 11 Sep 2021 12:37:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bh25sm586140oib.40.2021.09.11.12.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 12:37:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 11 Sep 2021 12:37:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/37] 5.4.145-rc1 review
Message-ID: <20210911193758.GD2502558@roeck-us.net>
References: <20210910122917.149278545@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 02:30:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.145 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 443 pass: 443 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
