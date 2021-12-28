Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA7E480982
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 14:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhL1NUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 08:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhL1NUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 08:20:37 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DBDC061574;
        Tue, 28 Dec 2021 05:20:36 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id bg19-20020a05600c3c9300b0034565e837b6so6252710wmb.1;
        Tue, 28 Dec 2021 05:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7FUkdvJGNxKGVQILwNgD77NHubBmu0IRPeW8D+iKZDg=;
        b=WYM3oQBw9UhKGnTNxJOLsUxkyzspC1DPfUe33e7iq31PQGxOz4e6WX4gJ7x36M1G3U
         THHZkcu+cKYOnGZgFzHmvVyMNYJ1QzycwsF80ifwAKyt/5PBMffjEYwxVnDYvRZD2rHM
         Shb3pqSvFZ0lE14/67cDMxTQZTTXZ0sNsUEcBnjsrth3su4xKUgKF+r19gtQIPyFBdJU
         hw4yudVQ0w3EHAX2J/SFFKFeISx1Z14DQRcUT9VnVxfEB3Jprh9cQEWNFlmoRKtCD2O5
         U3gxrTX8SaU0gfRrUJ9NgTngzM5gnT+jyK8biF6dsMQuuT7zFI0k6AK0JZFPjFMdPWm8
         pWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7FUkdvJGNxKGVQILwNgD77NHubBmu0IRPeW8D+iKZDg=;
        b=34eeM9rUElEONhctpDz6WZO2sqFHRkxDBuSmoJYqklLDhab7nE7hckU3BzU6vQOcfP
         QoSwJdeE/1rFvExaw0lEapunThlozo4zx1Mq5080lRbcv/oxOQFA4if9cM1+p66S7cse
         aQHMArEU2wMR7r6xOt2FBHccXfTMqLn9WkmcDep1HNyg5Bf1FlQc0Y9i10yiJlDOMy5k
         MY2unwqJ1b9TrdTjuMUctjT/YV4J5l192Dfjm9/FxJtSlm/Y165/+kS1KSC1GAstUl6l
         6NI327tcIGzr2hFYXFeSOEPloq16WYccWsWFu0nqJE1YIVjikcP/r3GpvyNpNEN/Av1G
         Lf6A==
X-Gm-Message-State: AOAM533rBqRuIv64EKywVls+wps/7lN/YiM3ygQteY74zTVuqVnL3UYX
        15uA3gTM3yRRK0vgaBhoz3I=
X-Google-Smtp-Source: ABdhPJx9FcJCfnhV1O77mJ7rOUYtloV3Sl1FNM2SY5WONAq4wb0NTav4yPAyanTb8a/apuTxT6ggpQ==
X-Received: by 2002:a7b:c198:: with SMTP id y24mr17060280wmi.1.1640697635353;
        Tue, 28 Dec 2021 05:20:35 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id p21sm19146554wmq.20.2021.12.28.05.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 05:20:35 -0800 (PST)
Date:   Tue, 28 Dec 2021 13:20:33 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/47] 5.4.169-rc1 review
Message-ID: <YcsPIVOKRSln5xRC@debian>
References: <20211227151320.801714429@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 27, 2021 at 04:30:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.169 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211214): 65 configs -> no new failure
arm (gcc version 11.2.1 20211214): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211214): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211214): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/557


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
