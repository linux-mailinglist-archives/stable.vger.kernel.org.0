Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CE41A11E6
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 18:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgDGQke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 12:40:34 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41090 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgDGQke (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 12:40:34 -0400
Received: by mail-pl1-f193.google.com with SMTP id d24so1438760pll.8
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 09:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=30q3lwONA2j2jj7Uppm89r1T3SRoxARPr2aHVgtJJYY=;
        b=cs5Q+JbaBblu7r3Izj91wPr5Pynp08cmEKxAtHrLyfJTHZJ/C/vjU3N7Z96EPRTWlF
         VAKGBp32mS810ch+JTnYlHSboRVcvzUEauMuovCjsybuvQOcuXxB1GY80inIKYFucC8f
         MBXekQzf/Is8xoReEjIRnWASJUiJb2ES0g1dkrLjzVrFIHGz0BwB3HhEcnKWM8/Q+yKw
         0zTxqfu3D+NJwCUHs/PieiExim1lvxbWt0EA6K9EeZg6+sJhC0W0yPUhJNSdg2t2FsFN
         CzMSJDQh1uXbXmnWa7P05gIU7LKSqaMjcjG3rQ04KddU0hduAM1KAU7cg3/IFdJT9Fwc
         UduA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=30q3lwONA2j2jj7Uppm89r1T3SRoxARPr2aHVgtJJYY=;
        b=Q0mBM2ArAeSd/vDwM7gZ8rHFUidDVAV2LofKzQQT6sHKPq3WmsIsa3wAYpy5qR7sm7
         8HkvofhpmDQVNMLvcgPz10Z+me2uJiqu25iBi3wan8PhYLfcPnnlbWsf64RMt5Com9RZ
         /REK3Xuhp+dCuls7ul14T5aLpVP7DqHDEwKdcj4dRdBnLCSNfDovlnnDcoJASCQj5vKz
         Ar3R2OHWCpLLJGGUfrCU6g17X1lRySwpTgyilhKL9eMBftKtljPo+bsfhwBl9ziQt2Iv
         cbu2mbgCezIXk/bod0E5HxNjmvmGwwkRcbf65qUv+oraU+80Qcl3RpyFC3XnobSrWTgq
         keIQ==
X-Gm-Message-State: AGi0Pub4kJ5UKA4m/QRudlwGHg/fp3jlU7/V65JluPd0hjXCXAunIYqX
        zl6zJVPNr6f07kbBg5GQJdiqTByP/9Q=
X-Google-Smtp-Source: APiQypJVcr6XFsy+OSTUV6F7HMiSJm/VH2oOaoUpzJnvfrUDQHcmL4SNeAZR7pyqU+PxDOkR0ZGwCQ==
X-Received: by 2002:a17:90b:4906:: with SMTP id kr6mr211065pjb.13.1586277632679;
        Tue, 07 Apr 2020 09:40:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nh14sm2082928pjb.17.2020.04.07.09.40.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 09:40:32 -0700 (PDT)
Message-ID: <5e8cad00.1c69fb81.8dd99.7f07@mx.google.com>
Date:   Tue, 07 Apr 2020 09:40:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218-14-g159a08ef7209
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 89 boots: 1 failed,
 81 passed with 2 offline, 5 untried/unknown (v4.9.218-14-g159a08ef7209)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 89 boots: 1 failed, 81 passed with 2 offline, 5=
 untried/unknown (v4.9.218-14-g159a08ef7209)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.218-14-g159a08ef7209/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.218-14-g159a08ef7209/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.218-14-g159a08ef7209
Git Commit: 159a08ef7209654321cc5f716e6fb73f41172c9a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 16 SoC families, 18 builds out of 197

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.218-12-gaf9a53bb4=
e1a)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
