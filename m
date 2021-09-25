Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B09341832C
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 17:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbhIYPTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 11:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbhIYPTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 11:19:53 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F941C061570;
        Sat, 25 Sep 2021 08:18:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k23-20020a17090a591700b001976d2db364so9776000pji.2;
        Sat, 25 Sep 2021 08:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9G31pxTt7kn4vMuJzxFODcXlSWRlmBXIyO/URbpwaTo=;
        b=JPZY7w0pR0t2ugiiOW84bP8Oq7lKD9Ohk/EX9C2WFJ9/86/66ytuDnKSYJTIaLJFJv
         PKDoHBSkqUv2Uo+6aEVnql70grukoOxvsukctWzcSlcGL3OiBErFNtYdgf5K5V8w/45/
         N+jFYT52rUrEatVejfSEUlIdiNQbZ/VWWSg2hFZS0D9cs0xZmoWcy3F7l/NbyX6p9zFP
         sPzeNQWwsch31RMshaCicVwuAQsN7pgUTiInVjK7djvwFT+f9qS8BKkiAIQdEexMQ88m
         5TTDS2ppV76AoUCQqdJIJHJxoIX+gak3tHnzztz59SCozrnrrsSsPu0hAh9EfwZ695UT
         pZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9G31pxTt7kn4vMuJzxFODcXlSWRlmBXIyO/URbpwaTo=;
        b=rXN554AFsWzFi9VAp9M/E/e6/XZBWAwMQYyU0ykNgJBcpoEBl9HX6Qg6INvDYQljH1
         dRCe7oNzs8RMd/jUW0WrFMtIP02iiVfLgpSzjKXB3ZerM0aasA8c0QqrojmnKLwP5Z9W
         ho3CpFVMUaiSVXXNsoM0cJPENTzkvflcxtS+8ZKv9qJZs949NF+AFHVgUR0tbKZz8//e
         Hubzl08JdzUj6ZiDW8BD7+BJnqQVVRcWDf2dG4/XhdsLakjcIFaaIwWQwR2Nfh8dmMOl
         1Jg6/0o3qEgMZxz9LcoJwI1hg6QOc/45SYPvG7OQowUh0+RhdHIyX/neheK3jGizuXYd
         V5mg==
X-Gm-Message-State: AOAM531AaSge4GZ5y3Ccv8Y3NIoTW2Oboc8LJpN1yp6QVnTIPThE/HBi
        14PjRctYIuAADAoK8SInc20q0IeHH2uRNlxnVzU=
X-Google-Smtp-Source: ABdhPJz2S35JJ/YQGS28KhtoL2Howeq+PRz9yd5pv6qlQhC8Jf1PSSblnzBvHRyK14rI0ucl9j+1MA==
X-Received: by 2002:a17:90a:1b67:: with SMTP id q94mr9028671pjq.246.1632583095341;
        Sat, 25 Sep 2021 08:18:15 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id k14sm13301053pga.65.2021.09.25.08.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 08:18:14 -0700 (PDT)
Message-ID: <614f3db6.1c69fb81.73656.82bf@mx.google.com>
Date:   Sat, 25 Sep 2021 08:18:14 -0700 (PDT)
X-Google-Original-Date: Sat, 25 Sep 2021 15:18:12 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210925120750.056868347@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/64] 5.10.69-rc2 review
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

On Sat, 25 Sep 2021 14:14:11 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.69 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.69-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.69-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

