Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3A7402978
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 15:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344579AbhIGNNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 09:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243976AbhIGNNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 09:13:30 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E817C061575;
        Tue,  7 Sep 2021 06:12:24 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v10so14390655wrd.4;
        Tue, 07 Sep 2021 06:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FgS+MIH5N3h8N+LQXoZfHIEGWm1MmwH0CNQRBpzXRKg=;
        b=AZmqDj/66mdp+uMYJu3wK2CgL8REQ2tSE43LMDNDBFEuD7HoSikQC0lpOpWAtfez/a
         MlBsy2x4xXO9jqw2YNZmqbVoQeYdHLHXtBQQasb3xDFpCiOrY3IlPw9ZkzjgxjtY+NUc
         ZmOxIEuLW/E/1XAwyCLwINQLPsQRovywddyuykk9qoiIFxmAe6mLShslBwbBBeGLO4VP
         xCbgSsjZZ5ChfXx2m3XLkfS0h5tMs2Tm+n8A+8yVP8pCX8NVVwhv5dA903cwYYwe8sCm
         pllA8p89Vy783h6g80cfuJw6t7Eps3neCv9l6/OwaR9NN7On91e0y3DexezyN0tC4z2F
         /kEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FgS+MIH5N3h8N+LQXoZfHIEGWm1MmwH0CNQRBpzXRKg=;
        b=VKHeIU8YNWN+RugSU0iVRNbBCDI8/62TGJO9wjegzzLiJPQsOYX8DWFY4iEsoc+iZe
         Yui9hkTvUatinm3EPODrHc+dKIdeX7X9IG7WeQxGRzvNuJzylCRUJ1Rqis+ChBPWvRw4
         ChPzs+L2plzJNU0JdW6yhiClO+KusYHeruutPqzFC6/NDLNavM6I0rBiYXSWnTHDjCH2
         aQtdtnrrzeZN1QTdtVJ6a0t7CchlCkYCwv9SCpujvbqvQpt0DotPveqE3gTke2F9cPlT
         4sWADsq7DgniFEzn63+nUxcABTEcPGOQwMXgiM6Y+oX8wVY00s9rVoT/IIJjtCAWltzW
         /QYw==
X-Gm-Message-State: AOAM5335vqovALXNHbdehisJPU37pqYGPIkT2n6eqwaSqZFQ1ZT3Cg24
        9Ub5lWcQCFcEVUAVLfyn2A+ufJUjlgI=
X-Google-Smtp-Source: ABdhPJyUt4DFkV971lutP6SfYRPRGBfe7Syb2BSg2e1q+EKUdxzLDxLuKP3FTUG/RK7Fvf2gppmWvQ==
X-Received: by 2002:a05:6000:23a:: with SMTP id l26mr18260083wrz.369.1631020342682;
        Tue, 07 Sep 2021 06:12:22 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id j4sm10708755wrt.23.2021.09.07.06.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 06:12:22 -0700 (PDT)
Date:   Tue, 7 Sep 2021 14:12:20 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/29] 5.10.63-rc1 review
Message-ID: <YTdlNHq0U+uJa2sM@debian>
References: <20210906125449.756437409@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Sep 06, 2021 at 02:55:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.63 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 63 configs -> no new failure
arm (gcc version 11.1.1 20210816): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/99
[2]. https://openqa.qa.codethink.co.uk/tests/100


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

