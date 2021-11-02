Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7A5442E73
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 13:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhKBMw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 08:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhKBMwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 08:52:25 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8974AC061714;
        Tue,  2 Nov 2021 05:49:50 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t30so8294493wra.10;
        Tue, 02 Nov 2021 05:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ytoWqyexX702uHHJXEHdk5R8SK/usWpYcg7llKgkC7E=;
        b=V304nIDVDQYX1sG42utEQQ2IDURSQA+F/tK9q26wTyorIKRMUK7V+HEwgYkg4YOMPX
         gy8sGw8Oq3wZfzuLXInyfVarfWE+qjvunVYGfAIgK7jIakrcAvnagTpqbClgN4IX+Fhl
         V0MGIvNT6RgT8s+zK2WSJTmTKTcaINjhP1cMVGrlGzce3vET7dgFonc6eraf0rr2NsLv
         kCy/FaDJ9S22AGq6V3+ifsmWKcAb+jWbcAjXXyw3lVZcJHUIJg1P9fH8fNWgxxblA/d6
         n8yK1uzTE7LTENiMmczbx9Nq+0Zz0jE5jNaL26CFHOPP/RJhc+5KU4pQYUg+UtA2VwnT
         0QNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ytoWqyexX702uHHJXEHdk5R8SK/usWpYcg7llKgkC7E=;
        b=4hr0QCw1dWzTHo+0wPD7nnScU4XGN7gNWB/O0eZ8WxA/CIpe35x8MKIDH5Ii6wpwbe
         8HF2TqASHXHjkxN2G3tt+8dKrMRCWbeERS++u4dK2tcGb5bUtiFQuSkGGxmh4ZTlI/yU
         AX5bFWYFeg/nh75SbCwlQnZJXtt6tF1UHLavNbfWn0DUnoySwh4w7Gmyx8A8pozvIxKP
         KxnJqt9D38Ey1wKH7/n8i/vyLGt91zz5LqP0Ey+75Ht+b97yz4LD88eIQxqUjg7o0/y1
         8zSaUuOIMch43vZlWOcObdO1Ye6Gw/5l0PuiWW3eJtnczZ7dZIv/x6oL1aeBK88Gbohi
         BIOw==
X-Gm-Message-State: AOAM5336eonQatzofEDCcMIoR2pUeRBrSF5Aj4Mmn0IlMohCDwS+pYEK
        I06j90xS/2WF0Wt6EmGbWwE=
X-Google-Smtp-Source: ABdhPJxxKkA/EXvJy98CF3TN7KHawgsfYw0a74rvnk88VzBiQi8Wi522IZDp8IiGmvJOnpsQy1FVnw==
X-Received: by 2002:a5d:51cb:: with SMTP id n11mr24843029wrv.278.1635857389171;
        Tue, 02 Nov 2021 05:49:49 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id l124sm2507909wml.8.2021.11.02.05.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 05:49:48 -0700 (PDT)
Date:   Tue, 2 Nov 2021 12:49:47 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/35] 4.19.215-rc2 review
Message-ID: <YYEz6x5KaIH4M8RM@debian>
References: <20211101114224.924071362@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101114224.924071362@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Nov 01, 2021 at 12:43:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.215 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 11:41:55 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 63 configs -> no failure
arm (gcc version 11.2.1 20211012): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/330


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

