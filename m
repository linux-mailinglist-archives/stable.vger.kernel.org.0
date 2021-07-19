Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F793CEF81
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 00:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbhGSWQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 18:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385237AbhGSSwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 14:52:33 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC01C0613DB;
        Mon, 19 Jul 2021 12:24:20 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s18so20094423pgg.8;
        Mon, 19 Jul 2021 12:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=6aY2YbuT7xUf6O+8ltbhpcZXeyIQys9tAde50mNMUYA=;
        b=p5rMoGpBO43mv18GlT5lhmFiJ/v49OtpjKtOQ8Iv/Q4vk9lVNR/Z9TLFG68/LZMsLX
         sWXrqmxrp5TnEhY7F/PE57s7nh2kRVCoLkaVqRwgPl/Zdjm+SbPRZHlSN4w1rWAsk2mc
         s3OUOf8q2qMT8txgXRmmkRDOSiRFhOdTocJ7oEi479VGKWEDzQ7kPDYFLWWJ71jDmKMd
         lsvz3q/YOEfw4TaeNS2hLsClZ9Ad62aLfuKgYVWU9b4ZTqD4Hkn+WJsp+ryZgoJX3szB
         Fq3OySTS+yIwRncl0evRu7IcDkZh8NvoganPAJxZOOMXWu/b/ewWOLcPZSddzWGYBjNB
         x0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=6aY2YbuT7xUf6O+8ltbhpcZXeyIQys9tAde50mNMUYA=;
        b=AFKHh7zg2/osd2ExsAS14on+zjS8k5Y0n1ZbE/j933XPVbQbr1h0RvXXi2vnxtbcEK
         OMTtlMUjsUGPaYh09nQzpL5Ngv2AcsDIuW6pxdCCtGaLzTwYumumYJO2Ad+tdaEPfbHs
         sa6oLFePPQI2sDT38mIaqwXVDtshSHlDEZZRCkzOgDloKCY7FXyCJMtuKLoyYTLmf4L2
         zykScRD/4nFkMJLlgEBOjePjUGoTXu+mw3WN90fsMqz/b9HTV1IysvThbuFSndVWbKTj
         fpBVAvaRATsZitDz81XD/LkOTQNUM7hMqDbcVPJxZ3MuEDx5T49yW8wFByXbxaQx0gkL
         H1JQ==
X-Gm-Message-State: AOAM532WamzBBm2Yws+gbTtKtSl4S19Jode7YXH7iW9gvyashCjRBujO
        Z5rjj8QLiXyDNHcB75oPhJG4bpcr6BDUTvi47+lzZg==
X-Google-Smtp-Source: ABdhPJyeZPu6z/bL31CWT1fIk1PYuDHG4GUnAl21x6nZEx72MaYwUQzdcBDrfayw0T3Vp6ExeKC+yg==
X-Received: by 2002:aa7:9a4e:0:b029:32b:34a7:2e4e with SMTP id x14-20020aa79a4e0000b029032b34a72e4emr28214763pfj.20.1626723160813;
        Mon, 19 Jul 2021 12:32:40 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id r10sm20498867pff.7.2021.07.19.12.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 12:32:40 -0700 (PDT)
Message-ID: <60f5d358.1c69fb81.9f313.db55@mx.google.com>
Date:   Mon, 19 Jul 2021 12:32:40 -0700 (PDT)
X-Google-Original-Date: Mon, 19 Jul 2021 19:32:38 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
Subject: RE: [PATCH 5.13 000/351] 5.13.4-rc1 review
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

On Mon, 19 Jul 2021 16:49:06 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.4 release.
> There are 351 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.4-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

