Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C18CC23D
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 19:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbfJDR7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 13:59:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35814 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfJDR7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 13:59:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id v8so8280630wrt.2
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 10:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jgnHuYOBuQgRMCSGhOSTLXGvVsE7sj4jNdIwjE0D7jY=;
        b=wGK+BXTmLp+/3nc/WMDVFuo7eZPlirrJkhY1ZA8fK+SUHJhcvzrINJNXdTNUUsL3SH
         MzqGCo08yrAL0ZwR1577zNAgCLplE3MKEUWNQ6RqZfuzEHEcQ63xsUrm2xc9LaQJAMbA
         OkZOH0argRI6TRsc6uGveIxmjzhmFEinNbgJPRl/F3T4ahgaXKU3fwkxqzJFIMbV4aTU
         7MLfJFCnXde1m9U61aoGpPdvfn9gGjcGo+S24hZN1DSKCeAeyQmXr9mmzrrBVPQGIWRN
         eJ414WInRqmtXJbzrKDEBUX348ODh5i2mDXv43gCIwXZxXFM5Mbm3lCFqltDTAO6HOWG
         xWlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jgnHuYOBuQgRMCSGhOSTLXGvVsE7sj4jNdIwjE0D7jY=;
        b=elDyS9X0t/YOKmPKjY7/GbxLCp1B9g65LqzP/s4joVGNVzQCMQBmrKxB4RIaMsDg9m
         3heC/31Wo3E2GG3wgqYrXdEl0ghFTNtAb/jpn+zWgi1ET7qQyc5EpTGw/0xT0S93MRgV
         XcGZ5xEtxECXnO19vbGKG+eKf7c2Dlegx4IT6wkoO0DkCoqNwbzWHmK5Wrt5U/VmBPOt
         2vTR3xjwh2DjiqRv2tQVNJJ5WKp2lc2/fVE4ZtSrIt1RCDhdIVQ9CrRsR2fgzWNH6v90
         fI8/U4AO/d9RGrCjiiEieDJXf8hPbKyCm3P+trpTXNqJSyYUNSGad9s6J9+8Su/HK/98
         /zhQ==
X-Gm-Message-State: APjAAAVrX8u88j2JtccDdRjRGWaLErwn0EIBdygBKwmfXN1wrLdS2EK2
        1CLAIPlej6QBAOjXDOnkndXyZ9//zMUqzg==
X-Google-Smtp-Source: APXvYqxvN1xVN6VtjkFC4vvtSxmeRbytXA92dG6OXThPTRAhc/IcCxlDDZ1XjL/zc9j34bOqT1pHOw==
X-Received: by 2002:adf:fd4d:: with SMTP id h13mr12639900wrs.66.1570211945801;
        Fri, 04 Oct 2019 10:59:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a13sm15771328wrf.73.2019.10.04.10.59.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 10:59:05 -0700 (PDT)
Message-ID: <5d978869.1c69fb81.11cbb.8c32@mx.google.com>
Date:   Fri, 04 Oct 2019 10:59:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Kernel: v5.3.2-1-g9c30694424ee
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.3.y boot: 73 boots: 2 failed,
 70 passed with 1 conflict (v5.3.2-1-g9c30694424ee)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 73 boots: 2 failed, 70 passed with 1 conflict (v5.=
3.2-1-g9c30694424ee)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.2-1-g9c30694424ee/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.2-1-g9c30694424ee/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.2-1-g9c30694424ee
Git Commit: 9c30694424ee15cc30a23f92a913d5322b9e5bd2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 50 unique boards, 18 SoC families, 13 builds out of 208

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab
            meson-gxm-khadas-vim2: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
