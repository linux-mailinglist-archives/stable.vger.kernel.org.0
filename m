Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907A8390B47
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 23:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhEYVZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 17:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhEYVZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 17:25:11 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF63CC061574;
        Tue, 25 May 2021 14:23:40 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id v19-20020a0568301413b0290304f00e3d88so29988057otp.4;
        Tue, 25 May 2021 14:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IIcqwQfjzxWvDCbmGoc+kqvFRjn55jb3v6f5hVFR/ik=;
        b=P8QPN9FymYEks3GVwX8khc2Cuh656Y7wbIOlJgZQO3g+xoxDzaTVfLNzjf+upDQZiq
         lOQxixr2tLCkmIJFu5DkWxEGrXnAbc8d7iQb64M5zNYNNgcrTOzR2sCSmY0LajOWqQWb
         iyCfE5kF1i5RWFAoXaP/xoSNkgyLCHZfFakQkXsU4Lft20ilCfZ3ex6u8nzanUu3Calf
         /Ir1kOn2Gdg7XYshQJ0owTcBMyMsbeeWawcQD6qfGUIEI6aIV1fq1PNf5cHznKYy8jkU
         KaohHq2IGZ8SgZWsgWk8QD991QFDsd2z4FxgC2XwDU9WLSm/DZ/rgZXcT5i3qdA+6Qkj
         Cldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=IIcqwQfjzxWvDCbmGoc+kqvFRjn55jb3v6f5hVFR/ik=;
        b=l/3Q4N1+orMiSuiHFyIZ6GiswDa4In387VEDbOJ7qL/klhIVgI9ByoCGsvFNyShV9M
         WgMCZI1NBiPuzNaQnApKOsZ8D7eNrdmYIycBW1NbYScCH1i+hYPSJ5LEv5cyowcBdR3F
         gNejaqgjMx8q6YKdZzGhWlZUuyeciFwu40VVCTtvSIOJ+TB7f7qt0G519K77spnpuw1Y
         MTr1CdN1FwC/ZVRBsvtrZsUDTR6rkV6xf5W9CmnHWYFaSvMgCeA6nqj8FY5r1LXzx9a+
         6bMIjINbzNA6xrfMwYN3aAgz9JPMikBUuFviZNsChaZwwq24qzLLlv8qlIXnR1lqMw9C
         nF1Q==
X-Gm-Message-State: AOAM533u/x1VAtk2HI2q40MSAT5WBR10Ive2YtefTOrvgYBKa4riwXMm
        cxy3rMyffjQKTtSs4novPVg=
X-Google-Smtp-Source: ABdhPJwbCFe4GxybFgLhdJNNtvBPxKsdhOQ5VgWtL6DbxDNPDC5EtEM4wOvyUns48P6qP+wSufd54w==
X-Received: by 2002:a05:6830:200b:: with SMTP id e11mr25057401otp.349.1621977820410;
        Tue, 25 May 2021 14:23:40 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w198sm3407107oie.26.2021.05.25.14.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 14:23:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 25 May 2021 14:23:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/49] 4.19.192-rc1 review
Message-ID: <20210525212338.GD921026@roeck-us.net>
References: <20210524152324.382084875@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 05:25:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.192 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
