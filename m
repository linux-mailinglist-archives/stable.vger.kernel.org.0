Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F737BE98
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 12:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387801AbfGaKpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 06:45:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38927 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387800AbfGaKpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 06:45:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so15968242wrt.6
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 03:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vhGRz8eaW5GVDJl1UVCCqCmPHpH5t48YE4na3VEHC6A=;
        b=c0qKdZKy/1TL+g4yaRkrmpWjZkXR3UAzfrXnCmdGTJW6gzh0cgtU2YMDxiUxsIxD/Y
         4K+S4or5ucG6dt3TmGExCltTtp7R58MEYt543LThQBzH1bEaWj5S4U1/GTfcifz9abOT
         uZ0PYNAeLVnjF56bRYWWFaAESs5EKTZkn5Scoe4MHNEe2KFf0OBmOjpJf9TfJgBRw7Qs
         5m2s0vtDQUYPMtDUVo4u15y2KGPvik5b0OGbqcZEBVwk0M7OxV1gYuHLcBC/jDhkjkBc
         6uF7Db3lv4mQ+Nu4DhJurEKqv9Fm4BgMXoE23nhVDKX3XRtzvQQO8obluVFNiB0ANDex
         v1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vhGRz8eaW5GVDJl1UVCCqCmPHpH5t48YE4na3VEHC6A=;
        b=cA6ihjDArh4oXlmpuisR866INtrBZihoPBKSsSmvBdqZthvSa5qalRqUw2avAN1iPn
         p8iCyXjm2ktYxnpp8M/d4b4jfI5ktKaJKWdZ0ZgVHPCgDItpOS36Uy1lehw8tqCade5x
         vnkf+Mm6dkFhv+mqf40jTqBJ0fLZVKnLJc5DPrbKSrMkVi/pbb3/x8g41NE6zD1d+/sI
         kAtbhLYeFho5EtBO6oJhaZGhPg9ftmGgHGN27FecjI2S1r7CXJUvi9BKZ4zTN3X2o+0I
         jdy/Oi3P8bxOXWKohAhBqpbnDyFHEJf9xHEBLtwgskl5g02LtW5xjgIuPw55IwDqUBuN
         mCmw==
X-Gm-Message-State: APjAAAWQSQZWEv4/H0emlvO4liRH87v7vwleMiulJgeTbk4mV1BGRGGJ
        SsI5ekiLfBpnMCMCPeKEredWEYbSquw=
X-Google-Smtp-Source: APXvYqxvCjN/8MYpIztrHP2zgQftjDPMZDk5XgJSoJMxr6vIRiAJT1yaddZj9yei1XG5uIdoIRXJyg==
X-Received: by 2002:adf:ed0e:: with SMTP id a14mr135941019wro.259.1564569948597;
        Wed, 31 Jul 2019 03:45:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e5sm63874559wro.41.2019.07.31.03.45.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 03:45:47 -0700 (PDT)
Message-ID: <5d41715b.1c69fb81.4bb98.cc68@mx.google.com>
Date:   Wed, 31 Jul 2019 03:45:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.63
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 67 boots: 1 failed, 66 passed (v4.19.63)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 67 boots: 1 failed, 66 passed (v4.19.63)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.63/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.63/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.63
Git Commit: 9a9de33a9dfaaf6628d63c56d58ea5cbfe707739
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 37 unique boards, 17 SoC families, 12 builds out of 206

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

---
For more info write to <info@kernelci.org>
