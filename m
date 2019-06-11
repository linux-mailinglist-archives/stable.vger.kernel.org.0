Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6553D0DF
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 17:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404803AbfFKPdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 11:33:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33167 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404990AbfFKPdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 11:33:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so13608566wru.0
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 08:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EGj0OqKMfl9B0Boj50an+M+4IeSiiiW3bsDoupjK27Y=;
        b=mX1DeuI6uL6labgyVavkZSbmmaDerihBX8BP0gdry8BJmbOtOt6xPxzlSm1AcJwPGo
         eYuVsnx32k81VzWCJE/B6Z5gCm0vx0M2EmI3yG/DmiyGeoeq4LWqAQTMYi9TIMLSYx2q
         nWqzsTQGRWa7tdUgZhwz5RFzQe6Y4q8QE+EkVUlK3T9AxZUiKtwCC6TIraWL3fwTvsA6
         Reng/ob99rDWIzT4/bqGWxHwK8wd4yJtW6yFhJZDIUZpUuXy6wTb6lTsGhjcOb7G9fYz
         nZGNUZe4X/WcH+vAB5vFfM/V7OSWKRvutF5clij3vUafR75+qeTKr47TuOCrYhqROJOW
         oxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EGj0OqKMfl9B0Boj50an+M+4IeSiiiW3bsDoupjK27Y=;
        b=EXHNTET4au8c/f2s3Mkhrs2IgG/RU5SEgWoOpGb0hDwnR8eZMGS5yG7qxT8neG2JXA
         N5qONMi+yj3s/g/2iFrWHPqbgJYvVsoyEMNkEGpLS+fiFGQ3VoMdb7opb5txwteR0TuN
         Z6CNbGGWCdaMt3ADVTc+NvZ32Omc8GSqJNgfYsvfS42tA6Uny1s5DaAeeNoeqlLYrokK
         13uJ8AnvUqECrZ9ciHCXKV1l8X8vbC7XGtYhnST3D7PVM5kescV+Ta0nEXbBA1pTVwLQ
         80sdHVfSjefQ5tktIBGSLcR+eTStF15qwl39z3jiKMlOpbY/ZfHpRUumJBhlv18BatUM
         4SGQ==
X-Gm-Message-State: APjAAAXUmWXBtBilUTJA02Y5z5ENLxWKVuViPMupRs01J/49ZhxYEcX5
        FFBcuQ1LiqpkWKzz9kgU0kQmnnqag3eUrg==
X-Google-Smtp-Source: APXvYqyWM8Tg2hJxUxin2NGRYpCnkiVIkGZVJHQX0TUXRjnLz90jHzgnO0HU3OOmedOqHc5MaXnR2w==
X-Received: by 2002:adf:f2c8:: with SMTP id d8mr23318788wrp.221.1560267215907;
        Tue, 11 Jun 2019 08:33:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 67sm3451420wmd.38.2019.06.11.08.33.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 08:33:35 -0700 (PDT)
Message-ID: <5cffc9cf.1c69fb81.d34c6.3edd@mx.google.com>
Date:   Tue, 11 Jun 2019 08:33:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.9
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 70 boots: 1 failed, 69 passed (v5.1.9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 70 boots: 1 failed, 69 passed (v5.1.9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.9/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.9/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.9
Git Commit: 2df16141a2c4ab648b5eceb6cd1ca8c72061c51d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 37 unique boards, 15 SoC families, 11 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-khadas-vim2: 1 failed lab

---
For more info write to <info@kernelci.org>
