Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D582FBAB0
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 16:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbhASPDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 10:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404343AbhASOl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 09:41:58 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E3AC061575;
        Tue, 19 Jan 2021 06:41:18 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id b24so20003137otj.0;
        Tue, 19 Jan 2021 06:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6hwPc1zulu3qNmdQAj6Nn0ezfGSwNaLXRa/RHUMUqQE=;
        b=MdelPICrzzRHOXUuXeujeCQeP2EQZ4c4HSqUao5w791u3+1haM/0xWEm4qLVkqWspG
         GpQ1EpFCTbaPEn+7ccm7ND/s33FjXUG02y/ab9Mt1oXNwERU+glq4fxoZSbqluJCZGeA
         R7e4AD4Ho/L3cezbPi6ob9mCK9iyJ0D4Ei2BOG7wAfXlpysm916jmMhEfR2XZtc1E8JE
         SHGgTM7WAxmddeyvRrfUAUI+0VZH1q7cZv6Fg2lygHT/0ndgHYKd/eBXkf85FyJaGeW/
         8+7MgdMGJ9HPFgupWFJQzSoG81EICSossc3e8xVtNpLFd4lrtnM9QyF4SKY+jfbIaJk9
         IxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=6hwPc1zulu3qNmdQAj6Nn0ezfGSwNaLXRa/RHUMUqQE=;
        b=NlJmUiFAUAu2IK8eAAF6+n0kKLPD+9rdIQIPQHKMxDRH1IrqrEbqHDR1eduARpMYgO
         YGveSa5E+Dslct28b9qgbp8grFabPWp+T85GpVoX3ZeWSIxvsCvEWayAdzR+HQcJ5uBG
         xemNa6sfaHol0U9lAMioTO0S6T4yzmhQhpn9OLNKmJ/bCGnLdVe6SrGTAptX5l2yB0CA
         l6BK42fDu7xKMpD2Zsb/jlQlUjuVCGnZ5Qp35DoyS6s7jw1PN+7ZytChQCzPR+CYOele
         hMxJypoN7WFf1VUdml7RCv8I/OSFb4KuRfpmoUnbUg0B2YokV7F5+FJEu86mHDW+wXv4
         MQRQ==
X-Gm-Message-State: AOAM533hMy/56dhUj2K18v9h+80MlEDRGIy4GOjWBa7eGbVO5pXwAin4
        gaB/PohmH3YZ735GuaUHtBxMZg/1Ix0=
X-Google-Smtp-Source: ABdhPJztZ0rZ+gOV58IzFHsobCVO6XohJKCn6LZzRRc7qibv1QEAX5bVkT+WkX0h8IWnr0rQqGEi2A==
X-Received: by 2002:a05:6830:1650:: with SMTP id h16mr3704277otr.266.1611067277979;
        Tue, 19 Jan 2021 06:41:17 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 126sm4255434oop.30.2021.01.19.06.41.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Jan 2021 06:41:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Jan 2021 06:41:16 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/75] 5.4.91-rc2 review
Message-ID: <20210119144116.GB54031@roeck-us.net>
References: <20210118152457.528300594@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118152457.528300594@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 04:25:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.91 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Jan 2021 15:24:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
