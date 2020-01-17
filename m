Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23981403AE
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 06:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgAQFrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 00:47:24 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37173 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbgAQFrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 00:47:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so21483871wru.4
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 21:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EZuuCw+eP4H8SIntOsFDbm0ge0sKKYVP64vITI3MQmc=;
        b=fTPKweKrAx13257D7RAbEVp269G4HZhubedM5py5hrcwbjriSqE7gV6ywQ/rkmvCmf
         erZDkpiBJu8s+wtBiAbbt+qklExXQbFbXKgy5+pfUWNtWO/6ll0K+VRdGmXHeeGJ4X9y
         4us/DRPMMk+H4q3gSIVHl01bE4ZUpEvdREDYqQs9FACgkbkpKsJid/FUdtCIi3gjrW/a
         J2lQnJ1DFBYgEl1S+ewl+fwMHepJvbqD4at5VDYDJmeIQRsYJzkS1qRBm2mStFk/5TKL
         3I82pfl66Qljq/UM7VwY8UCaxbYQfH7b2zmwC2TxAijBbco+S0/pEm0RyykPJQgOWiBP
         KD0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EZuuCw+eP4H8SIntOsFDbm0ge0sKKYVP64vITI3MQmc=;
        b=S5lP8PRUT5ZHkZ+HrJCIplZf96vdMQ3Mrzc73tNQW9S4aIZw0U+FcdtO203lpa0r0c
         lO23HPHJJNmsGAIUz8DFt8RR2QbmJRe5aRgJzc58BYSbO/52HVel3W07teQ3BQaxul87
         gP6WX6GHQqEPjDZxpM153CvIvD7N3Qd0vOOhvfNvyQ3e2BQZHbf4NSltC8ZIXZFDODdf
         4c1D6uIRioeNINlQNqn0upg8kM8jh9/gmBCRJO1PSRBsulvKQGEyiHlLVajD6hqWEiu5
         84/Tf98BxQ9UA2D1kaFYkzb7Ad0PTFY+RmbRySdLKAEY0YR+/C/j3MFKguhxnKmsGjQJ
         mdBw==
X-Gm-Message-State: APjAAAUVWN5HDzwBavALDUEfWRKv/fYF7lYYcR7Hf9wT0eGhPzlbnOcp
        zsH7+PPBAOVn2SIoKL+a9Sdtvh6f30/Sxw==
X-Google-Smtp-Source: APXvYqzcFCFaJNnxhBDUrbS9R7i16sYQ5YyYb0sMGRSvLrbGfD7MQ7y0+M60PZx88r3QjsYZRVMPQA==
X-Received: by 2002:adf:8541:: with SMTP id 59mr1101494wrh.307.1579240042692;
        Thu, 16 Jan 2020 21:47:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w13sm32425165wru.38.2020.01.16.21.47.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 21:47:22 -0800 (PST)
Message-ID: <5e214a6a.1c69fb81.ef5f9.4730@mx.google.com>
Date:   Thu, 16 Jan 2020 21:47:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.210-51-gea9d393b74c1
Subject: stable-rc/linux-4.9.y boot: 57 boots: 1 failed,
 55 passed with 1 untried/unknown (v4.9.210-51-gea9d393b74c1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 57 boots: 1 failed, 55 passed with 1 untried/un=
known (v4.9.210-51-gea9d393b74c1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.210-51-gea9d393b74c1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.210-51-gea9d393b74c1/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.210-51-gea9d393b74c1
Git Commit: ea9d393b74c1b6575db4c77c74dfbf398e95b646
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 31 unique boards, 12 SoC families, 12 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: failing since 1 day (last pass: v4.9.208-80-gad=
5b4ae368f7 - first fail: v4.9.210-32-g2e5db6b9d1e9)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.210-32-g2e5db6b9d=
1e9)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
