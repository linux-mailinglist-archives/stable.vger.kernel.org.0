Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7859C1784FF
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 22:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731790AbgCCViP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 16:38:15 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53084 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731337AbgCCViP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 16:38:15 -0500
Received: by mail-pj1-f65.google.com with SMTP id lt1so1946853pjb.2
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 13:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YfhxOncd720Gb8AGr7mU9yUWRBgAfy/0zur5I1JX4ps=;
        b=ehK/xEMIfwIpxSjzTOSguQWzRGCqUzRNCy14fDzVinsZyIsW7jDhOM+2P+wgzia6io
         W0YuhHMZhT0yglPErtsXvdWakOMwHSYQrEL4vcQaLML3XfxhEtnyIwfwIIYga08KxkK1
         w+xNK3WK1SXz0fpoHDptIMiDSfoQh92kNMqVc++PL9YP+1eLrWjhP7wgmfzpMrPGX34x
         hOPLqAvs6QsDehoARVuVpIqt8IfTW5RLLY1De+mBnPlaA6aO24SC2YerSNyVCe5cKsnI
         G9iPTRjHmjjLET7+l3JvzbaYG18X4J9tRO5UQQzFI3QbESJwRzkmC/6hNTbuImSnn8v2
         KL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YfhxOncd720Gb8AGr7mU9yUWRBgAfy/0zur5I1JX4ps=;
        b=VhdZyUsQ42nbm+WikC1UZNJhoDmH177VsjxniMegdMv84Edlo7kwuWeNNXLl3rrZxn
         XUg1WR5ovtCaCB0JOgW+IgnlYLyUf1ixx0mEvtb46qiILce0kgdty6pT7G/HDKYzdwbp
         NshYROyhzvxa++t87g9GNVtPBl6++LZQpvSAII3QNp2/cibEqxdRo8E9U39/g1FCZvPz
         nMqw6gz07uSYh59A0koHso7IEEmIvk7WrcpJnDGthRi+vSEsQsIpj21PktlJNs7zPyYb
         bP8zCOSobE80vYCBzTy0yX4QFtBWDCiPqIcESv5GHcQszMVbokOjK9DY2wak9ionV3tQ
         Nzrg==
X-Gm-Message-State: ANhLgQ0G3anQ8jR3P2Ns+35f2vIGIj/gdSVOTKbOODo5rTvfvjOoG/KU
        rvvrc7LphjnMXE4uNuoonow3DTIpy/o=
X-Google-Smtp-Source: ADFU+vs7RfxNsEwHmVfPbEYrcdKYxDyx5r9fnnFBQOMs/aMrnYjzY21wGgZCExQH0m2pgUFDZZrNdQ==
X-Received: by 2002:a17:90b:30cb:: with SMTP id hi11mr103981pjb.112.1583271494362;
        Tue, 03 Mar 2020 13:38:14 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 15sm19577225pfp.125.2020.03.03.13.38.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 13:38:13 -0800 (PST)
Message-ID: <5e5ece45.1c69fb81.2a65.3d91@mx.google.com>
Date:   Tue, 03 Mar 2020 13:38:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.215-47-g3a217fdb36f6
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 34 boots: 1 failed,
 32 passed with 1 untried/unknown (v4.9.215-47-g3a217fdb36f6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 34 boots: 1 failed, 32 passed with 1 untried/un=
known (v4.9.215-47-g3a217fdb36f6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.215-47-g3a217fdb36f6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.215-47-g3a217fdb36f6/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.215-47-g3a217fdb36f6
Git Commit: 3a217fdb36f6c6bd3bf5fcac1860e54549bc062f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 25 unique boards, 9 SoC families, 11 builds out of 197

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.215)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
