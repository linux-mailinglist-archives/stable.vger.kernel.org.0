Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962A0CCBD3
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 19:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbfJERvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 13:51:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:47008 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729608AbfJERvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 13:51:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id o18so10619287wrv.13
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 10:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3hv6DXdoOhDv6oJ0idkNH1cS2Vh6cErtx/vjGVERgzA=;
        b=ct3MFlUn4DKwcWLHAqXfSH+95rgJMV05Dh9FamAC1ak/aL8Y5K3Qa1SZAe/cyURjcw
         Fm736eTJ9ymjDkYcAWchevWtod7pBiSTYARZNo1f+tMfzMyNKRQHFK0TWt7pq7JbOPJv
         /C24sVHohgUbuRjkgV/XbzCl5QBe8oyk1Yc/ktAoMCX/wym53XNJoKW7mgN+XMLn/rHL
         D9kDxOT4BGe/FPn3/WCQ7ZC+cbuiV4HP4e33oyVq6SmUnhzljCJH1xRiXxX4d+HtgE5E
         3HReN2IBVIDv/f+ak+vh8cnmlIUMWZJVQyxnGM+1dAgyHfW3Ki20TkoEQilYzB/mD0vq
         wchA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3hv6DXdoOhDv6oJ0idkNH1cS2Vh6cErtx/vjGVERgzA=;
        b=QPj9XXX5K4yzFb1qz56LV4x0tBhj7oGNjhFsM8UaaOTpowzIoI09RCuWfu9nOc8O2M
         Fv+ZTdE36y8T3Cl4JrXWzpPIHuwFlaIaB3VAHxENRd5q2KIMJgKIiNvywMzUZrozbFa4
         G/r26PbPleF7K5daKrO3KTJqQxIfjFbnyQf8qTKgBFTwy65UgL+pZlBk2we76ISEVHmG
         /NIrL44g6JctEh5GRR/C/o/R8vQBOmTuU2VToQA08U3ANo29ospzAS7Z3n4Gey2As+H2
         hrKqLOpczhGssKFHhK1DKdPVULKwEsssJ6VciRDIsu15ujYf9fGR+zwxVum15kwr8sUY
         bm+A==
X-Gm-Message-State: APjAAAUdG9Vd4s3x4KJfx57usgQOG03bIk9KjmXr5B72LyrMetoRe3Ws
        YXIh+AJ03yancBN90mQZ0btljoiC8QM=
X-Google-Smtp-Source: APXvYqzeOv+SK0EL1bisMfhxJNpy7flgNkDjHBSwe3uOq+Nkl+dW690wZZWrhGakMaAa3+ph4OV99w==
X-Received: by 2002:adf:cd86:: with SMTP id q6mr7374280wrj.153.1570297866425;
        Sat, 05 Oct 2019 10:51:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c132sm8345004wme.27.2019.10.05.10.51.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 10:51:05 -0700 (PDT)
Message-ID: <5d98d809.1c69fb81.b64e0.5055@mx.google.com>
Date:   Sat, 05 Oct 2019 10:51:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.77
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 57 boots: 0 failed, 57 passed (v4.19.77)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 57 boots: 0 failed, 57 passed (v4.19.77)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.77/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.77/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.77
Git Commit: 6cad9d0cf87b95b10f3f4d7826c2c15e45e2a277
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 16 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
