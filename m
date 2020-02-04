Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3A015174F
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 10:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgBDJC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 04:02:58 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:39358 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgBDJC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 04:02:58 -0500
Received: by mail-wm1-f45.google.com with SMTP id c84so2483445wme.4
        for <stable@vger.kernel.org>; Tue, 04 Feb 2020 01:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y3MFBCmJbAV2NTt28iyVIoEkdhXmr1mPWNzxTm9DC2w=;
        b=ISWzNsioZtkqSbGPdFFVdoxm+ygbqmqdIWLGJOI+/xtAhT5Zv9QBpz4DymgIITMgAC
         h/My2lBROO/6c+gRpC90yxUFPX0YEULP0DwD4Z5q04aO2DrhBftQwYHVOqb9J/GzUga9
         37QLtT4pIC52FJ1yc3fjN3W06hMVXgPCTb/ayUmBLhhRkltadboyv/NV/5PAs85CAuzq
         yXmqalx98YSlZxwHJzZs2g1R5UWodj5mZwmlqauSHZ2a5a8QLScqRSS2cNl/W65PDVXt
         43AeIXAdd98Iou9dzOhuq2qRXTUQ9AAdXliLgdMd3rFwb2xAHzJhqAZ6zGM0Ane9rG8f
         Ni5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y3MFBCmJbAV2NTt28iyVIoEkdhXmr1mPWNzxTm9DC2w=;
        b=oFw/cfzBC3WZr/lIGOQ0mfdO0clNSIyZEilT/bc+UlrS2yHGPcl7ZcYNixKp3Ce17d
         ZxT4UcXu9pjJgt/4TmRFeqWez8oizvFtgFIw/CqGZCtMhczOgRO+XC1Nj0fzluJw2Lea
         kKPZUpr4RHOYGapkdf8nzXPQAU1IUJ1p3wKea6YyNoo9D6KT/LB7w4SrzplwNk8qLyJK
         0DbttqO9nkb46xDcrq2r3Lw4zC7fRyDmMNhO8DCzYyYES6SQXqp6868CzpGEiqWrnJ32
         qu5U2nswfb3rJeofLX1BPW8jMMcHLyptAezn4Nw1baI5yKhCdYLH93hzXnED9CefHPC2
         qgcw==
X-Gm-Message-State: APjAAAUp8BMG7BxWxWzMk4oTfEccPqiVsBTuAIU0FHOf4P/n5zyABYK3
        4Usw3RprbBeUnrBXdQtO/wS55nhc/Su+fg==
X-Google-Smtp-Source: APXvYqz7mMbnDBVPX60XTsxD8pEx8hmLc8kihsCNqIhdDNF8JNU6JbrAqi9QILKg2t1/35Pm60nrKw==
X-Received: by 2002:a1c:8095:: with SMTP id b143mr4413118wmd.7.1580806975773;
        Tue, 04 Feb 2020 01:02:55 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s65sm3002199wmf.48.2020.02.04.01.02.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 01:02:55 -0800 (PST)
Message-ID: <5e39333f.1c69fb81.f8f04.cdad@mx.google.com>
Date:   Tue, 04 Feb 2020 01:02:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.212-70-g1fec4502bd05
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 28 boots: 0 failed,
 28 passed (v4.9.212-70-g1fec4502bd05)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 28 boots: 0 failed, 28 passed (v4.9.212-70-g1fe=
c4502bd05)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.212-70-g1fec4502bd05/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.212-70-g1fec4502bd05/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.212-70-g1fec4502bd05
Git Commit: 1fec4502bd05d2ac63a18e776d588d9fac65a35c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 21 unique boards, 9 SoC families, 9 builds out of 158

---
For more info write to <info@kernelci.org>
