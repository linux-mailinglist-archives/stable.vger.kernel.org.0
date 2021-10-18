Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A28B43257D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 19:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhJRRw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 13:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbhJRRwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 13:52:25 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F285C06161C;
        Mon, 18 Oct 2021 10:50:14 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so15012858pjb.5;
        Mon, 18 Oct 2021 10:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YCRPzhILJILJMHYWlZqks8ujFk8yx6dho+4gWq0JYB4=;
        b=P6BshYM8XD3WpCPFD0zheiHp43U48FNWR+v2T8EUCOiTQ0kqpYtyxieabq6KHYdjgZ
         nY7byZwUkUt+i81rC7bLl350OMcGBWJYBvnmnbh4+Ddgr5JaWRJYf5P93t0Z+fPtakBt
         81iZm5d8Ft9zNz5V6ez8HQCQ3p30bcZTTuDWEpXcv9yYpg+xnuGhhZj24W/poCPCQJWj
         M+ISQAVRJCxOXSj/64IxtKbWtxSjebSGh1A0BVZpxktN63oik9oJIyFdciSqh3blm375
         5Z7WiBSYCORgHYm5KkBYrwuPBNlAj+F/bxbQW3CN+Qr5P7VsnOPsEbyR0oOJCMUlY5bt
         7o7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YCRPzhILJILJMHYWlZqks8ujFk8yx6dho+4gWq0JYB4=;
        b=esgxlHqkr00wY5X9y2mSSj78MUG/aDFYHcxZzRhgr4UDQDw9PoPRa0E2HwUtmD038Z
         4zunjgajrKLMj5blXyLFkLnrQOIhhP3gWsEZNXWP3Sk/o3f/Wt156E7FRA0DKJ/EP4r6
         v58JfqPaG8m7xGUAW93H8B53JdjFvVw1Ibywe67+sxZgTN9un87bkrC6FsM34r01TZQG
         ausPiX9mXIepPBrTyEIWwIa5BcMAB458hFCDgydSaQx1xgZ3T4rrl0rahbkhLapgRKbJ
         +kumywv9KN0Gyexk8I1upTsJBbra2wcZSzfs7r32mkv8jm+IORN/oBx4lw9F3p2dqONN
         zrkQ==
X-Gm-Message-State: AOAM5329p8NjTxpCjtr+GuYwBtQcVQvfMMXLiuM7jOZ18BSPRGeB+zmd
        0e00u4ZgnxgAQ5GgjVI9DhqqRpBrP19NDEXZY3o=
X-Google-Smtp-Source: ABdhPJykAINHQDimGQCT4Rp6tvjuyxfLc4GpsuXb/anHgnjiewD2qM97Cz/1Dgk03SjNTTXpZ2GwMA==
X-Received: by 2002:a17:90a:b783:: with SMTP id m3mr326221pjr.183.1634579413110;
        Mon, 18 Oct 2021 10:50:13 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id t22sm10152278pfg.148.2021.10.18.10.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 10:50:12 -0700 (PDT)
Message-ID: <616db3d4.1c69fb81.81f2a.9116@mx.google.com>
Date:   Mon, 18 Oct 2021 10:50:12 -0700 (PDT)
X-Google-Original-Date: Mon, 18 Oct 2021 17:50:11 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/103] 5.10.75-rc1 review
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

On Mon, 18 Oct 2021 15:23:36 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.75 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.75-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.75-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

