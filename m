Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB2FF90308
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 15:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfHPNaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 09:30:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36979 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727277AbfHPNaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 09:30:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so4088906wmf.2
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 06:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SwReG1DyNphs1XLeTm6/HgrPJm7P/9yRbKBPdTugKNc=;
        b=PWT882scOzZ4z2eeiAX2TVmGAglPOMuasrevcOhApiFtpTC1tLKW/Xd5LT8bFpWtRL
         PDbkha4C23thjVQNRnuhTpv77z7AGpSBfCVoGga1BhB/7OqWa302byuIKgcNHPfeQGc2
         XqC2to4Pn78Ty6J9sWHBeLotgpFntg/3ke61PJN4N2mP2U/G60KhsCGz5DZeqZPI5iKO
         fQvAWHDA0nUj2uIH9xQVVb0Sv3odg4yX12+jOTPt2r2ok6RaIyehAqMMO3uQR6rv2Gm3
         8v76zSbLOlQt3uPazJUshSYmK8QZ9jzMlhIzwIk7NS8cwPVmAaYkzsnW1/FoaCSgstjz
         58uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SwReG1DyNphs1XLeTm6/HgrPJm7P/9yRbKBPdTugKNc=;
        b=oogv3QM/n6jvFOLZYUH5qW4vfTskbljPhNImOBsGKtSXQoOvbEYHR2GwUzPpMUT33P
         r4aIDarFz4Tc2jyne8V37vSNMej0NepqxwVgYi1yrYjUBYti+GBNsxLVAec5yW3OH8Ra
         vfbj6bB89+SVHN9ovYjVTzcbUFb7sGoa2qSVATGZ+KGvxG2QwxZB5d9w/GRb6tOGnbN8
         vz/pY4EN59h1nISCLcwu6dGBMrBZzNeVSyYOX5lxrfnwXuOXi1WMitrDAjyDHWXJCSKB
         GtTKeY1q4ZyZKFy58lALWxMbyIjkVFWp2HFdnRbgHG89nDW+PrxHh4dtyfh0Pd0GyBe0
         H2Sg==
X-Gm-Message-State: APjAAAVdmoR/zLwKCNV268rt0OCVsTV1QXoD4rG8/2MSqhy1YgJ6B1P+
        D1mN8hRRQUze4ehBlrwYkhU6QKj2AQU=
X-Google-Smtp-Source: APXvYqw3oLJxteqoZVT+pJPjHzE+c/9qWWrrDfa8E2M+0ldU8yc+EE8AdcqoxRscxgPLGGBMZ2VBnw==
X-Received: by 2002:a1c:343:: with SMTP id 64mr7852526wmd.116.1565962203904;
        Fri, 16 Aug 2019 06:30:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 16sm7886760wmx.45.2019.08.16.06.30.03
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 06:30:03 -0700 (PDT)
Message-ID: <5d56afdb.1c69fb81.ed27a.769d@mx.google.com>
Date:   Fri, 16 Aug 2019 06:30:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.139
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 67 boots: 1 failed, 66 passed (v4.14.139)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 67 boots: 1 failed, 66 passed (v4.14.139)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.139/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.139/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.139
Git Commit: 45f092f9e9cb31486db546e39bfe7cc0b3f57099
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 32 unique boards, 17 SoC families, 12 builds out of 201

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

---
For more info write to <info@kernelci.org>
