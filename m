Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6E536B4CD
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 16:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhDZOZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 10:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbhDZOZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 10:25:08 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B930DC061574;
        Mon, 26 Apr 2021 07:24:24 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id q2so7089301pfk.9;
        Mon, 26 Apr 2021 07:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xmNMkJZAUH4elKp+djkP3azXRQ4L1nhT6jrsRK2DXPw=;
        b=o8W06l/Dei4mTQk1obBjPkv62dPIK9Pp24WZsmZ5Tqm1fBvd/wE68dLmcTyUso+qmB
         2soIe1/x05LlDzBWUBWBjSc6kCf7dLOttoxPjz48CGLhObZP2mjZqzNbzOomczEX0zxw
         uE4VKhqqcuHauhEcxMyVxPoLvwxkd/fPE4w+07tmgT2apIPFIG9vfRZATHptxEBdOB/G
         K3aW8nSqL/m7HEVqcuNLtj4lTWbHzwWdIM07MYqu/GrzMvGSqFgAIGaKYnCGxJzCYu7s
         pgfBOIDFRAEx0R6o5wiOXTzxaNR12yB1KaGO8DhgdKoTVEHZlowFl39+CFK0/EmLfM30
         gDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xmNMkJZAUH4elKp+djkP3azXRQ4L1nhT6jrsRK2DXPw=;
        b=TBYEwbmymfIBAraJN3etU1r4oM543Cn3YFAqbZdXmVwYhlqbbAqC/2uAK8cWGupL7d
         FGAMlguQsx6GjUeREIofpAF3bngip2z62TzZaEOUCEaIsdbhpgQFPIkhFw12AG7aVB0f
         zwSr3r6evqrKXbQO52U158pLM22pOZsvJgPYhDNkciruJ/cuEHsQdVcgxtnc4Kq8fT32
         x2wVYWQYGBnVoQzxG6N3pQzlw0Qb4YXKxykIe6r6NqUZnVVM6P2GdfvspcJwOLUKrBTI
         S4Btq2DzZueInKGoyVLNkeTDBF4df9k+YYTrhtOqJKHwIIG3ZRHjjJmOk4S3TMs+4Gyf
         6EdA==
X-Gm-Message-State: AOAM530O1cLUtBIbsoAjALoYZ7Uckmz2LZuQmG5rZ8rj5DYV2eavL5oY
        0QGpNIsGHLdm486xHq59uKemOIiGHvlf6Y67W8R3Lg==
X-Google-Smtp-Source: ABdhPJzXDUi6WiOcCBuaOYsTTPYmemU+q3DzWq+ySvr3FqdP2r9876j2OoeZwbcEwaT9KWapTA0VAA==
X-Received: by 2002:aa7:8703:0:b029:261:4680:9723 with SMTP id b3-20020aa787030000b029026146809723mr18070831pfo.70.1619447063924;
        Mon, 26 Apr 2021 07:24:23 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id c193sm23492pfc.11.2021.04.26.07.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 07:24:23 -0700 (PDT)
Message-ID: <6086cd17.1c69fb81.b4daa.0104@mx.google.com>
Date:   Mon, 26 Apr 2021 07:24:23 -0700 (PDT)
X-Google-Original-Date: Mon, 26 Apr 2021 14:24:17 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/36] 5.10.33-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Apr 2021 09:29:42 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.33 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.33-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

