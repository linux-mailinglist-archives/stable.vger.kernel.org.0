Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DF23E2B0B
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 14:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343865AbhHFNAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 09:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343864AbhHFNAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 09:00:07 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E086C061798;
        Fri,  6 Aug 2021 05:59:51 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id nh14so16541136pjb.2;
        Fri, 06 Aug 2021 05:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QV8+3vxOb9JThgWsgTPyy60jjUFyxGwn5YBsNirDpJ4=;
        b=V2aQmuI1Li4HyKLsJmJAy3RB1WEgkNcZ0PpvmsniElHeDuF3uCPHnjfJRBmYNrgYpl
         0z2jwMiC2gd5806n2k/A/wkbS8qDKeLQIr+83g3oPuh4RQXcyJT7I0kvAH8xBvuJyn6X
         Nqc+kJd6//RJf/6N6P2wk6G/sakmbsdCkaGx1Hz/Ah2IhVu692rxAxW6wg6MELJaFzAM
         CWnWhIl3COKnAdERmHw1zRh6pWYK312Egg96aCSmY9wFDXe+nZ9MbYI8pqJaB2CoZezY
         SVxfV5J/9nO8UCrFBOlYr6HZRe9+nVjmHbxNJ/quDEp/9SlTTGj4eNpoy59ECrfhDTlm
         ZLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QV8+3vxOb9JThgWsgTPyy60jjUFyxGwn5YBsNirDpJ4=;
        b=MNUmp2YXQZxEJTc/jY2XVuKWcXsxFr1eS3BrlbALr4c+kiJ+NTpIpgctDtpE/I/QxV
         OtyzcLEGysdK/gc7xcQOy0pUhS1Vwkelq/zo8c8H6BzM0VuqDJtBcNRzvU1xdGbu7BLg
         rn9UPLIblKGsYJl6Lcuff18hoJEazaLlcMnWyQEMYJDuTSr0wi6GNt2B3peA/6A04Tof
         ZSZD1YI/z+AIwRJZ+K6jZ4EdeAnuWEVya0pEFI1mCW87+rMZF+ow/BptJqTKQMf4qE44
         n2IAENji6n/EMomkSb76EfZmHmLajYhMyiA6HcXW0le7ikakAEFzreMsBCUOW02XzHPH
         ctEw==
X-Gm-Message-State: AOAM530h/8nCCW8zASphxRMb24RZKJYdi4iydIt8sEutUHZ7x9Nagd3d
        3B4sdbJNsHBUxZHIDCs/d3W5fDWt7lKRwlYhAzU=
X-Google-Smtp-Source: ABdhPJzVEYLb9xsccjSNAw5fPzp3ODozg0bM2b0LChJm1rRb1E4dIWMZXnAiYHfQ7dI0KBo1OOdaKg==
X-Received: by 2002:a65:63d0:: with SMTP id n16mr737682pgv.432.1628254790482;
        Fri, 06 Aug 2021 05:59:50 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id d17sm10347201pfn.110.2021.08.06.05.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 05:59:49 -0700 (PDT)
Message-ID: <610d3245.1c69fb81.5c341.f18c@mx.google.com>
Date:   Fri, 06 Aug 2021 05:59:49 -0700 (PDT)
X-Google-Original-Date: Fri, 06 Aug 2021 12:59:43 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/30] 5.10.57-rc1 review
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

On Fri,  6 Aug 2021 10:16:38 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.57 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.57-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.57-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

