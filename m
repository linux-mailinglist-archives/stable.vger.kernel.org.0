Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC6D480987
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 14:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbhL1NZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 08:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhL1NZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 08:25:20 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26ECC061574;
        Tue, 28 Dec 2021 05:25:19 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id k18so1648711wrg.11;
        Tue, 28 Dec 2021 05:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I55eO8jlwqW24o+DIv4Pntj9PmHbu85zleTL6bhf0lo=;
        b=oL/Cclyh9LZPqB4cWhwPrf1irUXCVyYt/x/kzChqXjKu5yp0a2T7fVmZJD4eJCUCoA
         3i6Y8o9Z5AGPGtNABhDvdGyUOnW9qW1ZMeMbbRB5FOJC16gQ641K+KfQIn0OhWaNuyL+
         5vfE5/h0wGeyWYSuCNwKFFudgVEpjaKJqf9hNNGVC+7GjVnp2en8QlWruRT5/5KH+RYe
         3siYlcLHEwGpwYyc6gvUYkO1KqLL1nGwXmzLEbV0xhKc8CV7+UcGECo7NI+mGGzjy222
         v0Xr46Xs96wk1YSfDbYdrIh0YS5kg4IQx7NJmtHDX2cRuOk21QGc+ln9TUnwXrqURKE9
         p8rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I55eO8jlwqW24o+DIv4Pntj9PmHbu85zleTL6bhf0lo=;
        b=BRwcSHNuHvtRr4l0rs+jlhzIXUAVuM3aqF01J/hZ8zenVvngeC1gcn5BJXOVuklJzb
         5bR1kh+iZyrj3sBFRmtVOQ86gLMNkjsU75Qgv1UO/rzHHktCs/tLNsLC1HAZgzVCKB+J
         fqOSNS9Hy9H7yCAy472gEnzwcPwCFHfgnIASj8GS0DWJnaJHLUpS68isFkIAlu7D7M6C
         qrZkOZlgZPfAICQXD1MMEum2hLsSgD+Jh68nC+Dv/66bhGTapyLst8Zwmsst9gookTiH
         n2ERETA7BbL8+dJLby4pQasZHaNevj/NfN+IxqGlKLwGdZD9o+KSWe1V9uQigGnX+Ybn
         HGww==
X-Gm-Message-State: AOAM532S+hjifJITyfXwGcPRZXN7z4KVq/f1Gw+MF3AMF/5J2FWPUrqj
        APRD4obEIZl7qGf3H3U23Lk=
X-Google-Smtp-Source: ABdhPJyT/f1zpytcqc/MlT3AQwuegTbh+S0eid1J5dPcvHDgkTdQ5JTDyeC63v5P1n199rSvD/3xoQ==
X-Received: by 2002:a5d:6050:: with SMTP id j16mr16278937wrt.175.1640697918550;
        Tue, 28 Dec 2021 05:25:18 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id l2sm18197821wru.83.2021.12.28.05.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 05:25:18 -0800 (PST)
Date:   Tue, 28 Dec 2021 13:25:16 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/128] 5.15.12-rc1 review
Message-ID: <YcsQPPU7PHPsViLh@debian>
References: <20211227151331.502501367@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 27, 2021 at 04:29:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.12 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.

Boot test:
x86_64: Booted on my test laptop. No regression.
mips: Booted on ci20 board. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
