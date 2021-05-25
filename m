Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D1D3903D6
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 16:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhEYOZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 10:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhEYOZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 10:25:27 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E982C061574;
        Tue, 25 May 2021 07:23:56 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id i17so32450772wrq.11;
        Tue, 25 May 2021 07:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mMD3aBz1XBrdSSYRDQ8cv9/kH29vxyyFxSZhjfDe08o=;
        b=j8nHKhaWjunkQipvPCu5ScBVlKgzDNWoBMlfM2snfa7Bi6VOz+qHhwM2NIGbUoYj3R
         +vpZANKqj7qBeJcSr4LU6e0oXR3XY8qg+mmejDGgGqGEdkASu8C9IvM9a/NaFhBHuLAc
         oCKHmPV9+QlBFcpWN5xiv6GMg8XkKYoacpXI+MTswk+X8ErRPgc8GmTPQtKeu4fflVv0
         dJA84QKzamsfQSEIX+AQkJate8QdyuF1vHzFoH2zHyexigFGdoXylSUD+n6sfP5fKgpI
         ydhqc3d4ZogWIMIF52SfYTE3D/tnp/X4ZeEobSHmyQOkAeNazi9YjStUuzmvDbnbPy/E
         XZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mMD3aBz1XBrdSSYRDQ8cv9/kH29vxyyFxSZhjfDe08o=;
        b=MJsSlctmfiWGIjOqNGIagF4a8WQs6auFwITSRMe8qM4nAd9ee0Jdqcdi0bQEWTCZ7p
         OKGB0hs/1RsZVs0qSd3Zm+0jTwxluNdUeIJQqYbJzMGKRXCQnJzGq8/0KVb0R0J3CNru
         NNRuY8/rxvqTDwxvu3G/WgVhMYAn2DiQ+Hj+NBgK+qRZQ0G7Vj5T3H1UxhkpKYXUEjJk
         E1WGR3vV2tm5d6R7S+mnkGmbHWJ9JDpUzVDiRAcxP7oPAQSyvp2a+sky4srWysZKErE3
         asZ04+ZVQ78iE7NzXkWapsQzIQpKgkJZcNUIw5oePFA6nhaTNpRqMmiGoxfajpFGFSsm
         ur9g==
X-Gm-Message-State: AOAM530ibp3jV7Id7zzSSwmE93IC9n985e9oUn7mWDeTyNPWDUiv9J0r
        PfKbgEWsbhtgRfa8KNFaY00=
X-Google-Smtp-Source: ABdhPJxcHdHDTY5dk8H1CjZokM3rCNW5KdZ8j6IOL33TVn3Wwfk+l0M0pCnURbFHBVJWZraWPD53fw==
X-Received: by 2002:adf:f7cf:: with SMTP id a15mr27106454wrq.184.1621952635243;
        Tue, 25 May 2021 07:23:55 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id m10sm16344243wrr.2.2021.05.25.07.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 07:23:54 -0700 (PDT)
Date:   Tue, 25 May 2021 15:23:53 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/71] 5.4.122-rc1 review
Message-ID: <YK0IedU+PZAe/jDp@debian>
References: <20210524152326.447759938@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 24, 2021 at 05:25:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.122 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210523): 65 configs -> no failure
arm (gcc version 11.1.1 20210523): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210523): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
