Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C9413D16D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 02:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgAPBVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 20:21:54 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33459 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbgAPBVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 20:21:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id b6so17545205wrq.0
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 17:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZFA5P9pe9OsydLegNxLPxAM6fXWmwY0gHRVh5vDDebQ=;
        b=ke4LgOlAJfpUVrn1C9Eb2KQtPFKGXlfG+VWZwrhqvViKkG7OosiNf+JhIegaFtFYQX
         JYHDVetDBOg4hhz58k+ZrwFwSGtiUd4+lAXhdxwRPWJc08OAAfrc3n4SDMbst42bT5/N
         RRkbpSE9bloAMm0Q0nmWtj48X+xtnClPxvfprSPPjDSC24SxPVpH1cXLZmv/kGHh/pkI
         EZx2zKyKDyRqkWh7bR5aZargRN4IL/0iRoy78RPd8EXk6rho9YkYJSwPoV2QAFxevnUL
         xxZA/+MIDERZcVLj+rSQrpp8Q6IvpZ8+zsc5rZtqF8F41ZMM0qj3UlwgszbcpgpBWaNA
         tUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZFA5P9pe9OsydLegNxLPxAM6fXWmwY0gHRVh5vDDebQ=;
        b=hwkwDASHjkrCKOzlNhFMknAGygAwHqR2A3QmsM5S9lbWdXnyu//f1ZeWCp1QOHcLHm
         5dWbbBGj6/RJ47TsUvYvz4J3vfqoUkjmO9kSIriSd8pARhbpW1o5khyyeLOp8HLuPAbZ
         Lti52CUFNzy+cDtSbtS54gpJrQ8e2xX58Ly6yg4FTq3f6JK4e0EBdxuMP4R9hZ2LNXen
         pEsCUO9kjarUPb0mJtDl6JVWNyBBAllo7QUYnzw8ASp+4UnKaC0aBHSEi+D4RXwBHDP1
         ekhicS+e3w/2aB88YGgr7Rx+7MR2QQU2SFXwauqUNh9j9sXYpru1ZIKKenXzJDrSho+F
         sM2w==
X-Gm-Message-State: APjAAAUyVs7ASVYfdZLIZsH2KWE3ecjL3VYN24fYAj0MCX0k1OXsAYJ8
        Q+RgXie6L8xTT9wdM98Y96VsWKreOYFPsw==
X-Google-Smtp-Source: APXvYqzSe7Aheys+ixbuzCgvR4kWuN1Q7LTN4w/VKtblr2KCwQ7aCcEh/D6IIDR6LyQjmP37JNsBtg==
X-Received: by 2002:adf:90e7:: with SMTP id i94mr162185wri.47.1579137711636;
        Wed, 15 Jan 2020 17:21:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s19sm2231213wmj.33.2020.01.15.17.21.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 17:21:51 -0800 (PST)
Message-ID: <5e1fbaaf.1c69fb81.7da2.929d@mx.google.com>
Date:   Wed, 15 Jan 2020 17:21:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.210-20-g51bdd63ddb66
Subject: stable-rc/linux-4.9.y boot: 59 boots: 0 failed,
 58 passed with 1 untried/unknown (v4.9.210-20-g51bdd63ddb66)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 59 boots: 0 failed, 58 passed with 1 untried/un=
known (v4.9.210-20-g51bdd63ddb66)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.210-20-g51bdd63ddb66/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.210-20-g51bdd63ddb66/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.210-20-g51bdd63ddb66
Git Commit: 51bdd63ddb668c133639e0a05f8d412bdad2adce
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 31 unique boards, 12 SoC families, 12 builds out of 195

---
For more info write to <info@kernelci.org>
