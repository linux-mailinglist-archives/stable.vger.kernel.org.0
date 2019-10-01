Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A02C3F84
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 20:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbfJASLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 14:11:50 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42222 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731461AbfJASLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 14:11:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id n14so16639661wrw.9
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 11:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q9ef4k2qxziQt8G+pZ2r55i1ohvI8EhcmqpTW7XwevM=;
        b=NKgxhLUYHIUXvDOQHxrgpNOEI6KrB0Nyb66ha8IJTzTVloBrDs8jynpnRJ0ZwKNGE4
         +utzsubB3tqoNDCOeEbPGZTf4Pb3y9UzakFxNX4sa+GnCu8KCkJPn9R7brGcbmAfQKr0
         xCHsaqBWErs+ApNP4YMNJkt8/1q03vhgLcRakSS19OCmW/wTTWxCXi1x3OuSI1DDShNb
         GlnFcTQpsnKFcHS6ZaibKzl31H7XrFGoze7XcPZ+THeiNNE3IMErcxBDoMEMwDVCq1KB
         QgwkTXkhZ+bt1XkVcU77q7VusivDdJ5t86Nx/Uw++FTfR2FcINny78Zw/7wp7SLHpwDA
         w6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q9ef4k2qxziQt8G+pZ2r55i1ohvI8EhcmqpTW7XwevM=;
        b=rUAJ0La3JLzg4ZMQfBDmNCbRoTFMkr9y0WhzmhNjTrD8CjoGiJ+2VtrRyQHfms4/5s
         TI/SGebMDxLqyfZT+Cq7TfshdcHnvtWttgy8wOxlvBi9Sy7xwR5A30h6BynJY0971FWC
         C1SUgypWzDwTyDaXBIXPkAj2nag7qR102g7LadNzcqJb0q+49mRP53t5LDAWs+M1EySx
         /fdk1FEI77sxagWYw/PQvh4ytX0v7qDUJfCJKFksrcymk1WOzSX/KHp2mVs4nCqDEQGj
         k7oDzyxyg5frWWvs0UqbbsS9U/K7MJ9G6ORPq0exteEpdvbR0xiHOtyo1az6CW4Ku/Q5
         7xcA==
X-Gm-Message-State: APjAAAW9YyG5eeritQfBbbfDNv05MoBjEVykNG2pcCntuYZpSa1sl6FA
        hMABoYPNYQ8oWCYsugUiFzJnuCqRr1ZV5g==
X-Google-Smtp-Source: APXvYqylW1mSRyvdqZ1UgntY6nFdCRrf/2vh+TOep5gbcIfyWp7h8aruhrykXFGG7yacVJV3q205fg==
X-Received: by 2002:adf:e988:: with SMTP id h8mr2019467wrm.354.1569953507843;
        Tue, 01 Oct 2019 11:11:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d9sm20923841wrf.62.2019.10.01.11.11.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:11:47 -0700 (PDT)
Message-ID: <5d9396e3.1c69fb81.cb054.186a@mx.google.com>
Date:   Tue, 01 Oct 2019 11:11:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.18
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.2.y boot: 84 boots: 0 failed,
 83 passed with 1 untried/unknown (v5.2.18)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 84 boots: 0 failed, 83 passed with 1 untried/un=
known (v5.2.18)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.18/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.18/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.18
Git Commit: 0a9d6a58b4acfa52384b3175bd3d0742467bcf65
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 16 SoC families, 14 builds out of 209

---
For more info write to <info@kernelci.org>
