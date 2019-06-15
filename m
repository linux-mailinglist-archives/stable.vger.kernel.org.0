Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5514247093
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 16:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfFOO7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 10:59:48 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:38875 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOO7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 10:59:47 -0400
Received: by mail-wm1-f54.google.com with SMTP id s15so4969045wmj.3
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 07:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C49r+onSFcX+J+fRcvD/v3A/reTd4PLzIbmNuzfmN+4=;
        b=QG6IhtLdvpUAEIkCcTav1jCFP/X8oCZ2MYxlnt855wIiFCjTGKkMSKF39GL8AmfNfy
         qdyU4ijKWyNtVv1jdKduKYwbngXlfchkUyF6S61rl1ffRfFouGo98Q1TCqYoq06xZrLt
         M09OCPmCB36BEdfBBLfg0bqAme2UMuYu+5WRlnTWJxDCBP5lH8f6xj+23N9zmuSPcLPs
         JaDGVXFWyrx+lrJ5kPRCd8IjpJ59ZQAFvqmOKvCyDcWSji/xreh5V85FfNzxd3KK8aYd
         0znYgRstZ6/TF5T6v6O1s7YbPo7z1diJwLSbBVdlJx8X9rj7bOu67qQendPGp8ChTg5M
         rQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C49r+onSFcX+J+fRcvD/v3A/reTd4PLzIbmNuzfmN+4=;
        b=J5F5kNAKdVZEck7tetWfTLRDH3ShEhoZqSMWOJVL8v4gde7U15KZuvvVLu1L1D+m8G
         Shvth5iil1E/Ht7Wo6YEuxOQooefDsj5FYgUWWySGij3ANg74s2IOnjEevxMYcQ/2yhC
         7fC3lvNLUitVEpwgKqvwKlTa7mebbMPG4c6LUIScFiN8SgVoCyB/cNg/3mx9Z0OuvJNf
         ZkHPqV91d5I2tDWE5lN2sXnVyREBNptM19JWhYALi+yVpdvVXZLJkqhquvqZ4VaDpPyR
         Sr2ZopGzoc93ukx7hnaRfNAac04pqGEMFnn1UBIszbYZZ9M7PzELSgVTXZPK07t9zNL1
         +73w==
X-Gm-Message-State: APjAAAVRZj5BH7/psK/GimC/aUbFVYb3AU1neBRekkO+c6nImw2D5TgL
        Op7XV3Oov9ZKCKe/VEYB8SY8uOm3OAtKPQ==
X-Google-Smtp-Source: APXvYqwu0Gt+TUU9SddGztlLJ1FybqJnisuUvaeaxIXFx57GuVTXc/OeSS4czdA04jQiaDECdXcdlA==
X-Received: by 2002:a1c:1947:: with SMTP id 68mr11987057wmz.171.1560610785567;
        Sat, 15 Jun 2019 07:59:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b5sm6223762wru.69.2019.06.15.07.59.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 07:59:45 -0700 (PDT)
Message-ID: <5d0507e1.1c69fb81.bb601.128d@mx.google.com>
Date:   Sat, 15 Jun 2019 07:59:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.126
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 51 boots: 0 failed, 51 passed (v4.14.126)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 51 boots: 0 failed, 51 passed (v4.14.126)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.126/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.126/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.126
Git Commit: a74d0e937a3acaea08ec0a7bfa047b8e0a6b6303
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 27 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
