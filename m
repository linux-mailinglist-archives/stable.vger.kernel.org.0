Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E2DCC17A
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 19:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387428AbfJDRSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 13:18:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39997 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387458AbfJDRSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 13:18:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so6630405wmj.5
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 10:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vSCZRVvC3+lS/m/5VhPoHlx4NxXLOc81DvV+LWIfkdI=;
        b=UKFHFnh9nN+i2/PErPuilwj+wf6KkqJ5eSEQfnkwsiErh2Cp8GNwusUj9Um2+lsLX8
         6KoERYmVrab3mD5lTArBoghMq5cl4UJRdZKorqbseQNF+4TeK9LlHXpp9PM45sc+Yd2C
         yOAlqyDrJvwCm/wBxyrtHB9kl1BC0y5ND9uwn5Zl10R74/uFkwUzptxlF3WkgkvuobwG
         epXXflVYZWFZRHG5u7KldMPKHFi6OcM+1e8uL1a0z/EpnrNUJHlwAGryzxsN/7gFnLaP
         gIEkxB1SlymZj7RwRO8VCnwFTrUQoSMa9bMXjuXYJShL3VZAIg2EQsR+KNON525tX9ZK
         Lakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vSCZRVvC3+lS/m/5VhPoHlx4NxXLOc81DvV+LWIfkdI=;
        b=KsQWCY04cUxd9vdAVPSpuZm6gtO8XT4pGm2Q2/EWDcGYuHGiKI4Dn8y0/pXJzHsXIi
         /ca9ekdXqAAO8X+Wp8Pwm96Lss5Lu7+fwD+fqaVfNZujl4TFthkJnIxgZ9i8feynMidR
         bV3Gq2RRSDmbFaYFJES2CX5ul0a9m8/9FPCzaxISYMA8pnDKMmvQhk8Du9rf0rsmBV3x
         FXNxK+qrKrh+psWKpt4YHxKHJ1xKVBv3AHULtKWadhCpzD09tnSc/u77VdzhVyS1+oNJ
         0h3bVdfZL79WR/9xaI4OSlMJttba7cSdJ427L1x2+subEuecXR82nKNqLfTggtgjvuRp
         72kQ==
X-Gm-Message-State: APjAAAWdyf8UPz7X5f5Kx2/c9e4o/opBRwKJOB9byz4mMiSpPXdFaJaz
        LAyJF6q9lUoKJCEvpr6Dr2UgfROFD+BEAA==
X-Google-Smtp-Source: APXvYqzo2LIr6Nv6Jq1Puhg2AP1KpQ0WEZJhTcMNWgrlJC9jvp51DUh09RQZnINK4y8ra3QlJGhEKA==
X-Received: by 2002:a05:600c:219a:: with SMTP id e26mr1607620wme.86.1570209512003;
        Fri, 04 Oct 2019 10:18:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u83sm15648981wme.0.2019.10.04.10.18.31
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 10:18:31 -0700 (PDT)
Message-ID: <5d977ee7.1c69fb81.b5b21.be7d@mx.google.com>
Date:   Fri, 04 Oct 2019 10:18:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Kernel: v5.3.2-346-gc9adc631ac5f
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.3.y boot: 67 boots: 0 failed,
 66 passed with 1 conflict (v5.3.2-346-gc9adc631ac5f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 67 boots: 0 failed, 66 passed with 1 conflict (=
v5.3.2-346-gc9adc631ac5f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.2-346-gc9adc631ac5f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.2-346-gc9adc631ac5f/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.2-346-gc9adc631ac5f
Git Commit: c9adc631ac5f1d6ac4ead2332f2a82c4e199852d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 17 SoC families, 12 builds out of 208

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
