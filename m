Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B34394615
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 18:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhE1QyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 12:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236551AbhE1QyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 12:54:21 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD19EC061574;
        Fri, 28 May 2021 09:52:44 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c3so3923242wrp.8;
        Fri, 28 May 2021 09:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DbqI7yh1gYf7BO1u8PXps5kbtKhnNfg9iPWdTJDyzbY=;
        b=P5OkV2pBtCeSDhzkTEpNC2GHdmDBMXz4ql0E7L5d5YjFcX3g50g15lbEjZ1oM2N3+i
         v0ntLXYyHLEKtAf6kIqw8bqsFMcQDDGSeWRjw9IdO0TqBUQo5M6eqdUnKS6ou1C5YbtR
         vj1D30kjDSoxnsmD2L4eykQ+yFeIXKywEUIS1/iY0//WD1J5+z7l88iLNKHSNkdOGwg0
         tpNh7ihDplh0wHBRmctgAK08f1Ta7F2EpQORgajn26E4oHzUTWaQjM9sve+z/LoaIy9w
         7T9YSQ4XPlv0tsn+e6/QTQi76ltzXH3zqJdbZh8qZ9iPD2YiwLD1hjEkKEDZEmu1adFS
         Rdcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DbqI7yh1gYf7BO1u8PXps5kbtKhnNfg9iPWdTJDyzbY=;
        b=o+VHG39zfUXrnFYKlhOuY2mQ9n4HUNObAzhhnUVTeMJqwF8HvJsVCdPWSzwbpl9ry/
         TN8tnQFtA6En+M6Q6CJJ0Bhkmz5eRjv35ij3FK1f/Sfs8cnyglcHqhR+71g6+nIGr0kk
         AllMGTUQU3bt3gCt/AcRCtjIhGVYI5HheJn4CYmbL0nY8BvxpiezHzHlPDzuIr+OtuuC
         1szPNfqnCpuoSON7WiMVsqBT0S1Mh3s2AGsT7Qc66TGmQpOJXvCv4l9YsGH+kjLJy+Oq
         Iu6/kNomeVqCpDphmU12j3vpExIf7rYsTCAcgWFN5zLbH/J0avdcyDE+oNuSfMp2vjXX
         7kvw==
X-Gm-Message-State: AOAM530zQlz0xhLpJ3BIT1mqOdxRHSl9ufceoNcTVKImSEbuwtAntaWy
        hrHlJbeyiZaFbjj+PjwUK8U=
X-Google-Smtp-Source: ABdhPJyZu3hSXvc3cYYjznnznPb2J26x9jj9JEefaoi4jUdm4CfkMsvaANVd3Ior4L8Fah2SiE3ESg==
X-Received: by 2002:a05:6000:1544:: with SMTP id 4mr9648139wry.370.1622220763411;
        Fri, 28 May 2021 09:52:43 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id z12sm7745988wrv.68.2021.05.28.09.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 09:52:42 -0700 (PDT)
Date:   Fri, 28 May 2021 17:52:41 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/7] 5.4.123-rc1 review
Message-ID: <YLEf2emlXGs2cNxb@debian>
References: <20210527151139.224619013@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527151139.224619013@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, May 27, 2021 at 05:12:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.123 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
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

