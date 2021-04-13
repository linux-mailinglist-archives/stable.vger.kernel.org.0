Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D23A35DC92
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 12:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhDMKlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 06:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhDMKlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 06:41:19 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8646C061574;
        Tue, 13 Apr 2021 03:40:59 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a4so15942966wrr.2;
        Tue, 13 Apr 2021 03:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kCzMFTslwZ0FHFaA644gqFVxHVu0D+cztPdfP4+Oe5g=;
        b=LECObDYK8QBh1yA2LPybvVCvK0dUT1Bu0jYpI4c5yW8jUvimEoGKQs84WprcuIQotQ
         8jE8SX3frLv81mFedLenAfb9StseRKgKhuU1I7D/kZfflFmgnFgA3wcuvdFiAlV3oPIw
         GRKlvkGcnS6twkNAbMwNUUxjwTtX29ODAAysOcZwHPQ41NVhKaYWrlGw5NxI9WTVRD0G
         ipmKV7YmuTEkHvR1tgflVHChvwHa+OQ5I868GyZeuDN2jvwS05F7XiYyQ5V1MDw9ZZWZ
         fgetVjO3tXPmbIahdJxG35hkYbDsZx8rwGbRYKU46/Tl5UacbWokvBsEz1gAaqhJTDt9
         ZTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kCzMFTslwZ0FHFaA644gqFVxHVu0D+cztPdfP4+Oe5g=;
        b=f3/j/U0tTUGCfTdNKxSDFCGouuh5kmbeWKNhVwbAzyHWt3hWeKruCCUqFZmSQkfjqo
         0lwW7+QZD+JGKg7RW3pbwstUEzltDfCK/nyADh49SUxjJleR9V7209UX3zTaJkxCtzjg
         hiPqQFy211DZJcDCd8UZm2vjmWM4vyucPvtS5C0eH1rDw9FxwSDP/hnyriyS5GCkboj3
         oY+DSPSmzIylsPswEvzrY/+4r70oINEyAwNXb2QxEjoFa5zMlIoWw9kyWi50y5utSzAf
         zGumgMhxbSV7QVSg2i9o3V842hzEDlNmuPuUhiLhFZvJycX3yv55OEvhefN/+Ps8GCoV
         A4Bg==
X-Gm-Message-State: AOAM532ylc6NKj2B/Z+zgvJh0YLDXZa9d6Ma1ZlmBWxbqH5WBC1T5IxE
        t7BpBx5Wxcrv5v7F8Xl4Vfg=
X-Google-Smtp-Source: ABdhPJwNGpjn3SkNaTttbYnlBaSdno035BOIIFvY93XVbIRVjfqTunNibFQbeDxMgRgxDlAYQ5Q5ng==
X-Received: by 2002:adf:b301:: with SMTP id j1mr5571423wrd.301.1618310458676;
        Tue, 13 Apr 2021 03:40:58 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id s20sm2032709wmp.48.2021.04.13.03.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 03:40:58 -0700 (PDT)
Date:   Tue, 13 Apr 2021 11:40:56 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/66] 4.19.187-rc1 review
Message-ID: <YHV1OG5nefU6wXw0@debian>
References: <20210412083958.129944265@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 12, 2021 at 10:40:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.187 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.

Boot test:
x86_64: Booted on my test laptop. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
