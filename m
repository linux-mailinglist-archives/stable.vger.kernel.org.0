Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8866B3936BE
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 21:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhE0T7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 15:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbhE0T7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 15:59:00 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24A2C061574;
        Thu, 27 May 2021 12:57:25 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id m190so771171pga.2;
        Thu, 27 May 2021 12:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YyAQZekssGZ/VXdKwUTM6zN6hKBkGqWKPEl3CLarnwo=;
        b=iRarBlE4NmlNHjKmktC9LaI4Vi3oZ4GZ0ApiT9CYpVUmdEsef85fqrqhh2MZv0AVW6
         aqDkV4v+EyREWcrnKOrPRrHcH3uxs6oJ96w5kuHkQCaSQsGBEgzok8RdePIv9DkCFcMT
         HYx6mhuGh2tKwWR0vBfPb+9wIP8uEejuc03d2O9zln4wAduqyzAAY+0slf4HW2xOcFNW
         4lQw4mthk7l5q/VQlpl8HgJfqOE8YrxzmRA+Nx4fhEgMQtyGnZQP9H0jM0d1M9gw9pwP
         9LAjRCAzM5BKZHrp4p/VcGSVYP/6kII5sinocBlOrv9rUSGGIQB2V5XHMDmD5uwjfi9w
         QHYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YyAQZekssGZ/VXdKwUTM6zN6hKBkGqWKPEl3CLarnwo=;
        b=aeRTyTq11cV4HASClaie0YG44HSJcGf+nszCAzL9ZyFYPQcOQ/M28SNO+tmnerhvac
         GgIaaVINzVPDij5AvNMgioZeYrsB/gdWFCUAjHH8JGcI5MuZ1kt+nF5dIcEHAhUJiAI1
         ClJ+to0LcoylWcmysbHsJ4Xe12nj1oqaD5APipyN+td3w4r45OsXr12j8jlgMu0pChlk
         RXH/vz+kB6Pp02ft4ZsXMKf+eWypF4KYYEu0p8HpLEz1AK/5XXD0qvs1DIJxkfryYR34
         8NfCE09LJOlhUZ5igYtnpMIzVFaKuIrpq+/ZXoowb0H5RynsEb1DEYFt2Hn0TJcEgcmT
         qUvA==
X-Gm-Message-State: AOAM533J084CwUf2K2HWNn4Ex04ALG0KcGJBJmRA2els83cAsNYfJWBT
        UPisRlj21tWBDslUKNf7K61B2mygJG6Af6NRjUY=
X-Google-Smtp-Source: ABdhPJxWkBCoUFdAcZC6WwOtpir3urIGJT5tKhNSH4Rw83bzBofB3o4mTXs3taL7AMHiTt+j0KvKfA==
X-Received: by 2002:a63:d30e:: with SMTP id b14mr5215508pgg.237.1622145445043;
        Thu, 27 May 2021 12:57:25 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id r13sm2563946pfl.191.2021.05.27.12.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 12:57:24 -0700 (PDT)
Message-ID: <60aff9a4.1c69fb81.401dc.9159@mx.google.com>
Date:   Thu, 27 May 2021 12:57:24 -0700 (PDT)
X-Google-Original-Date: Thu, 27 May 2021 19:57:23 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210527151139.242182390@linuxfoundation.org>
Subject: RE: [PATCH 5.10 0/9] 5.10.41-rc1 review
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

On Thu, 27 May 2021 17:12:52 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.41 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.41-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.41-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

