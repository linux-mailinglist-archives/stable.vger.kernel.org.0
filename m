Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364B336BABB
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 22:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238875AbhDZUdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 16:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235996AbhDZUdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 16:33:45 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E423C061574;
        Mon, 26 Apr 2021 13:33:03 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x7so57189283wrw.10;
        Mon, 26 Apr 2021 13:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TkMGSZCo0nmM6NUwZddekHVpuuPNKJHuZZ1C8mnmjE8=;
        b=s/M0Galxbk6wq2NwqFSc9woht3Jxjp/hJzyLe6qKEtLFwdVVobu7iptPjZbjhq8awg
         KL46zyb8G340Ef7WEwUF71quqmUnkcNng1XBTiYnzsZDQKcG1teZAhYolX00c8BgbcSk
         WaKD/RC5oPsq6OAnDDmPAlll4gGVyfCCSyZbT3mJPrW3jdwAIKr6Re7zyAMIEb/XF784
         /fwB6kGVsGJ5zBKUBkY/gvd7Bw8lTbGQh7qugRrCxrODpqvFGilzrVbeKjnlCHFZwCaC
         jbgmNrMHiInOLEJMBLRswjJJ0BIut5dTbLJ1/cdYnyHOKGzIC5WxPEtFxId0zvieGNkt
         KoJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TkMGSZCo0nmM6NUwZddekHVpuuPNKJHuZZ1C8mnmjE8=;
        b=lUOitGLheTRB/zisgdkJBTVyr06TxarkKJAOhRc4D6VnpS+vBg3zXEzYQJj5t6o/0F
         O7PQCKCNCGzzR1PxTNtqpqfta9GKc43XLk20FA726aAPdLyKPMdYdB0IAu/IaDwlZb2f
         JqCfPZjBVTPQYf8E6C85ZvUKJAWue25rvbNHiBgb3CcGwyLL8vYfo+kEe2YiR/b3V830
         OjtIiAfpqDANmolvlsnpc+4Q18dQVOXYC0EmRM151irnryccIKN997YxeLUqN+toDUNd
         0/vzxllFDcwNkYzmsQmh/+9vc8TDvYNXCiSfQXQ/oD/ssw8l+4uq4vMHV6gTU+/pcTJx
         3WPg==
X-Gm-Message-State: AOAM533xKcvPj95SwYVpnyuCbSCPk6STsOmstxoVz14aZXlxW5uxhfq+
        ckRVm1bsjYAF7IDVSjx7vO8=
X-Google-Smtp-Source: ABdhPJyfV5qAedrzVjJI7DvpSok8bhthWKogdcH45ftGAjwHOaxSbnh0FR29+RwmDN46ZKLwnCXnIQ==
X-Received: by 2002:adf:c541:: with SMTP id s1mr25102671wrf.370.1619469182093;
        Mon, 26 Apr 2021 13:33:02 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id z15sm1415334wrv.39.2021.04.26.13.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 13:33:01 -0700 (PDT)
Date:   Mon, 26 Apr 2021 21:33:00 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/36] 5.10.33-rc1 review
Message-ID: <YIcjfK+IqzCr7nEB@debian>
References: <20210426072818.777662399@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 26, 2021 at 09:29:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.33 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 10.3.1 20210419): 63 configs -> no new failure
arm (gcc version 10.3.1 20210419): 105 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm: Booted on rpi3b. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
