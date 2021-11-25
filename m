Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F8045D565
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 08:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhKYHaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 02:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhKYH2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 02:28:03 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB734C061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 23:24:51 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y13so21337508edd.13
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 23:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=bBIqQa/SCKGYxoZHALYmBUxaUbRBXjYk9IW25TpdYjE=;
        b=MJpzV2Qe9vr4wuJ45uP4/6kQUaUAe+1JEgQrS7meOE2C/kPqOss0FXhC8o+hONndY+
         Z04ZMXMkhnqY7Io95aHVOORCXB1RpAEjQYYqY1HWjber/4Ee/xDvECAIypFrEkfZqKj+
         GU7qB0edj1ei8ohkGmWoBFaXmwS28qjeHTJWTT/KBPONx1lVFZ1oyWKraxYR2IUchWkQ
         4qKCa5FM357e1suaLAjNy6JYUR/joVn1TOiJwuHClbtyOZ16iIAJoH3MyibKD3gi4ItL
         FZaUF9Zx+oCdsbNGtgt0vQXEso7FMiMQFiOco4dDa9iBReKs0JR/PRVXMrcwi+kulRlN
         6V8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=bBIqQa/SCKGYxoZHALYmBUxaUbRBXjYk9IW25TpdYjE=;
        b=t+xIOR99tZoyKJ8NTZzv+3sBUrzw6f1TrFZ3hTB2BFVZ/yJz81lTVxfIg55blnqAAa
         V8aQ8S/dF4o5ZHYlb/aqfv3j2anIth8XkldXRvvTeEx2P1th/aa1bbxvCD8+UwvbvqfM
         vLzltYCy3sih2bJSa/s5D2LfsCfUJpJi8qrBSCRaM1hcdrBPdeggq1Pnuiagqtn0oD9g
         0fXx9Lqy/rIi66YXqJ/CCUqZIiq2IhYR0GPt6c7S1EgfoEEHVJkEnLRqin0CPh62Nwpm
         oFbZm5ndJ6FV5O5Nw58l2KATybzN9qQTWGt5fvIkmsGh6dSczrymvVGK3h/H3O7aYObb
         MhNw==
X-Gm-Message-State: AOAM532nn9VEah9093auBrkmZinE20xIoTIC6nM7935DSEPljJmCaxDS
        ZCiEkUqfMppru/zoeGT+m2L6N36/Ctl8Xdu6fHc7PI1X+xeJsA==
X-Google-Smtp-Source: ABdhPJyJNjv4g3Z8J2gKC/BAL8Y187NY4+bBadMRsYrxd5CCgBA83znuESc74e4p/az+RHx0Ua+gtDRyyTnUEL9/sfs=
X-Received: by 2002:a05:6402:4311:: with SMTP id m17mr34902350edc.103.1637825089570;
 Wed, 24 Nov 2021 23:24:49 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 25 Nov 2021 12:54:37 +0530
Message-ID: <CA+G9fYug3rX1wKksHsSmnpnkLj+p2JVKYFMFxqT3aAfJGCRYKQ@mail.gmail.com>
Subject: stable-rc queue/4.9 buil arm tinyconfigs build failure
To:     linux-stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

FYI,
As you already know this build error still noticed on recent stable-rc queue/4.9

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
In file included from /builds/linux/arch/arm/include/asm/tlb.h:28,
                 from /builds/linux/arch/arm/mm/init.c:34:
/builds/linux/include/asm-generic/tlb.h: In function 'tlb_flush_pmd_range':
/builds/linux/include/asm-generic/tlb.h:208:47: error: 'PMD_SIZE'
undeclared (first use in this function); did you mean 'PUD_SIZE'?
  208 |  if (tlb->page_size != 0 && tlb->page_size != PMD_SIZE)
      |                                               ^~~~~~~~
      |                                               PUD_SIZE

metadata:
    git_describe: v4.9.290-204-g1b54705bd25f
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
    git_sha: 1b54705bd25fff60b31f9d6db7b9e380f70beb03
    git_short_log: 1b54705bd25f (\hugetlbfs: flush TLBs correctly
after huge_pmd_unshare\)
    kconfig: tinyconfig
    target_arch: arm
    toolchain: gcc-10 / gcc-11

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
