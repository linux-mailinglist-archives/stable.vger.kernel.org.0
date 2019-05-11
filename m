Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2421A7D5
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 14:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfEKMgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 08:36:18 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:35821 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfEKMgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 May 2019 08:36:18 -0400
Received: by mail-wm1-f41.google.com with SMTP id q15so5758878wmj.0
        for <stable@vger.kernel.org>; Sat, 11 May 2019 05:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8w7ybH3A1EMg7uBbgo8WJlqHuSv0+3OcsAOFlYeeXbQ=;
        b=dl1uDZOPgsWqZnp/Gk57ch+PBHoZ3NI9/rE2mWMmjrvs05Hq8Dh5JCvy921gwx1xlX
         vH47jMtbkTJDUJcKtrpvnB/jxRBmU3lExNqg/pTJcAQyBbhikd/1nYzD7kks4M++1vLg
         TKnRk4NG8uxHT6hBlQVdXcMqCvRIsVOSXlqFcV3I4KawQVSNw9OXrAbThCDHFPCiiicw
         cp+wtWS9EjhPPXKzZW/chU5FdSRzk97rhqTlgn8qBkSAhEIGIsCRN8YV/iVALbjk9K4y
         0s3wsUPmBg14IvGWkM+clTppf7uRsQckKF6huP4LaYM6lWv8bH/A9mMC97xdqk3Ndx8d
         uxVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8w7ybH3A1EMg7uBbgo8WJlqHuSv0+3OcsAOFlYeeXbQ=;
        b=ZaiYN6qJ9MgCAPR64lSfJCGcN380rUnj6H9TTpATb1gmBOFgrqQ3pZswVetjBJ+3Bh
         pbfxHm4DUxG0xb9Kh2QACDfm+F73iYOQ4nm+OjCYTKlOPVpvNZUcQCnUlBw67MPd59ex
         N/tulq+knkyNALEwu+xMQU/ffcgH+1DYcsWaouNFYBpeI1PHpzL3ydn2U40obpFScqCJ
         Puz19lbeAfzyZDqUcGykW/DPtFTGsx1dAIQAVWgvPQl0NTLJP4iGhMYrn0mDfMz9LgCY
         /5tjdg9e4djSbGTrAwpZaslniwkB57bQ/+zL7LZfQWOiOGKXMm3QuKwarsJHaBUsDyg0
         yTKA==
X-Gm-Message-State: APjAAAXuZY2vCRVszgXj6rrFzPL5DKCmKsxyONPqZ4+HBkQpPO2fRVXm
        AKhU/V90sHlhv2Fn95uLPwWciKmaldUIvQ==
X-Google-Smtp-Source: APXvYqwbLPkZlCXjfNiIn3vLIdPBfD7CYW+ltEyGCdGuq+R/wISxP422B1dCVYzUw7Qb/T+crNfzpQ==
X-Received: by 2002:a1c:c004:: with SMTP id q4mr9494186wmf.131.1557578176460;
        Sat, 11 May 2019 05:36:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t2sm5828187wma.13.2019.05.11.05.36.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 05:36:15 -0700 (PDT)
Message-ID: <5cd6c1bf.1c69fb81.b0bd0.d371@mx.google.com>
Date:   Sat, 11 May 2019 05:36:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.42
Subject: stable-rc/linux-4.19.y boot: 132 boots: 1 failed,
 124 passed with 3 offline, 3 untried/unknown, 1 conflict (v4.19.42)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 132 boots: 1 failed, 124 passed with 3 offline=
, 3 untried/unknown, 1 conflict (v4.19.42)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.42/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.42/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.42
Git Commit: 9c2556f428cfdbf9a18f4452c510aba93d224c8b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 23 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.41-67-g82fd2fd59c=
ff)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.19.41-67-g82fd2fd59c=
ff)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        meson-gxbb-p200:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
