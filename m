Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D94F383A80
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238410AbhEQQvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbhEQQvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 12:51:16 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36472C0612F3;
        Mon, 17 May 2021 09:37:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso201567pjx.1;
        Mon, 17 May 2021 09:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Ku3CeTnQSRaVc2X1/GF1fGNFdAKhq49AjgponOMKyJM=;
        b=Yqc0/wJImvABIgC8VqFgCTvjU4ZTPZxZ7VTxDs8BIBr4JzW6N4SDUbAJN77IJwBMTU
         ekOAYGgHImk9s5T3bw6W7d+gnv5ZIvbxIn1AEq8omiDpbz3t58EgTMC0nDzELhAYckH6
         sdTnPpN/K8LILGmB5BgkdUyX3m9ABNbnrIpofY22x5BXbxUvaB2DuC67eLjo2GU4uo+M
         2QEkBK/BBT44U7QH67nQA01348kfQL2FnAeKre5h2R3uM5+vSKiNLfrCy+mWu5SFCWXK
         tN9skvYnin4L5p9JQwyBAJ6twfbi2VzINvuPukTMKQjaN7doKLlHe4OuyQoFDzfbt1FG
         j3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Ku3CeTnQSRaVc2X1/GF1fGNFdAKhq49AjgponOMKyJM=;
        b=qPtmr6hfuYh0aKb3NoJcQVyZmfF2pfhqQt3+HHvb/f3RORj1eYEU+IrDosLNWwpX0y
         3LdfMmTtZjjifzeBdwNT8npo+iJY2v/OlM4nAVw4Mek+AQX52rSorKMBIeL/rIl3+ki7
         lDz0+nDkGK9ptho/mhf7Adc0dJnM90bexxbN8hEdiIhifoBZaWRTR5I1w8qTLZq7z9UG
         JmQ5n4eXaPbL6mqtF6dfVzOQtiYy0rLRWr5XeJ9GuYfCdfaxUDVrbPHQZ+R6cQK2VXzb
         25h7B8TdHwS0RBQNApR8uYS4ukWzPsgSLTrPR4W406G9XzPHO0g/nMqVPngjVDGfLt8y
         SCiQ==
X-Gm-Message-State: AOAM532UAT70DwNwMAgYB3y9Sa30iO5lE8Bx1lLjO/ZPQIsgK6tKDx7r
        gW8vbbpcCJUGK8jZDUF/CRr54LoBkCuicwvW
X-Google-Smtp-Source: ABdhPJyR0akPL3Xy1IHIRGiXb5liXXG08IUodzhkOki7JgWAlaWTR8Qlim0CgsEG+g1GLrLrB0sPEw==
X-Received: by 2002:a17:90a:dc82:: with SMTP id j2mr14063pjv.138.1621269436141;
        Mon, 17 May 2021 09:37:16 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id 35sm2255422pgq.91.2021.05.17.09.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 09:37:15 -0700 (PDT)
Message-ID: <60a29bbb.1c69fb81.f06d1.69a0@mx.google.com>
Date:   Mon, 17 May 2021 09:37:15 -0700 (PDT)
X-Google-Original-Date: Mon, 17 May 2021 16:37:14 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/289] 5.10.38-rc1 review
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

On Mon, 17 May 2021 15:58:45 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.38 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.38-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.38-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

