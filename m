Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030B436B29D
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 13:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbhDZL6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 07:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbhDZL6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 07:58:40 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3605C061574;
        Mon, 26 Apr 2021 04:57:58 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y62so6130968pfg.4;
        Mon, 26 Apr 2021 04:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=E/PWuyhNDls998sTdAd0TWsdtA9IVZe7POWkE3jrtSQ=;
        b=UwrLo6hVylCpXHhQRRIb7xN0KG6oew7i7JRH/BOkzM848UEmC9V7mhGUNSkJkWvXKB
         XBujN5lNbZEfTXVNtUedP9zMFDWkrfMpGmyLOtYQQxqZ71rV8UR3DNk86Kg6c7DTKHBQ
         lEFeQltOI3DcnjgZzfNNfh4AWVOWgh79R65aDcSS2OhiYo8yaoNyaEZR4KQM+KqKobrA
         cfbb5xw3u7IKeLiFNObuwXqpzUHgN6/2/DNnb3nsjKSUFTs5D0tfLsb796WeCW6DGQ/f
         IrsSN2WrWDRnmNWy8/qpVad6qES8k7URXk6j59q+bcd2+4Inxlhp1+hlUcdN5cjYg0JL
         iidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=E/PWuyhNDls998sTdAd0TWsdtA9IVZe7POWkE3jrtSQ=;
        b=HjoBqU0a8Cz78zf4rs0O267kGg4vTgWbwYiTe4mFcjnn4FoSh7VCA7XMR4+pB1js8m
         hAPq8wb8quYFORyiiSPRg5K0pC4wI/1hKWPe+kLG3BAlekU3M1S42tOrDOc63Ush6OZf
         yBjjUzlPhlPd4uK4ALj/aB6hoDhMFfny4RDMmKB3o4CzzDLWhDXzzqmBbaqN5mh1gTT6
         tOZWjRRM71plNrWVyFnrQFeqZxJxjZrNCZ5VWgH0E93gbDVXsOhyxeAUpN4ZOk2u/2It
         Ho2MFbYMsYVEJj6wnVY1rBzdQL8sehE6PDKhhjxiZj3ROaznVNCmsYhDfxpCBFswHiSI
         gijw==
X-Gm-Message-State: AOAM531QIWADvtM1g2iBuE7/99umkgZ75XYy2Bs7WfvwsSPA8ee2U4Gb
        9kjo/oUsssORwio7ko5d1qzuMQV5s7j9y29MGNA=
X-Google-Smtp-Source: ABdhPJwAKrQ3op6LCr2b6YpHqvFIL/1+K+HWp/AbVtwM5/2hGy6Era9IoN4N3ZkK6iXXMhbBdze6Eg==
X-Received: by 2002:aa7:8d5a:0:b029:227:7b07:7d8b with SMTP id s26-20020aa78d5a0000b02902277b077d8bmr16954913pfe.26.1619438277841;
        Mon, 26 Apr 2021 04:57:57 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id j10sm11466867pfn.207.2021.04.26.04.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 04:57:57 -0700 (PDT)
Message-ID: <6086aac5.1c69fb81.a2f79.195b@mx.google.com>
Date:   Mon, 26 Apr 2021 04:57:57 -0700 (PDT)
X-Google-Original-Date: Mon, 26 Apr 2021 11:57:56 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
Subject: RE: [PATCH 5.11 00/41] 5.11.17-rc1 review
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

On Mon, 26 Apr 2021 09:29:47 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.11.17 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.11.17-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

