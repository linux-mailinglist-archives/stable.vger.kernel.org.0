Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA113112211
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 05:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLDE06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 23:26:58 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54944 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfLDE06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 23:26:58 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so5510698wmj.4
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 20:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SRdEYLWMmgsVVSm57GuRlDkgW1kFE2G81WKf5xFV59o=;
        b=G89Yw0rO2R2rpWT973iQNonfTYcNssp+XMAp4AV8zippPwUV8VYtITmAzoOZIhaJy1
         BzZTDunWiCUkvL5HOQQbn/cCEz+WTCwJtE5+ohXZpR7kybIYnoSRI1tPUCIEf79xLZTA
         uI9JUEMhghs/7efJWRwcTGSlPYOuBFHdv6Crza6JOLIVGn5xcaOPKYHeqodI3/EnM+ka
         IiOJ+ZnjRqC5VdrJQ5zv+gNHFfv7rWKI69Allma9IzKLlm6nh5jXZ+hM6Qn6SXayR/yr
         vkTgTjYvprUEzsWm/7aCGXFnY5rlzPG+ojrw+UC6h2i5uAD5E1pnX93/0HxdH54lmv1E
         8xKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SRdEYLWMmgsVVSm57GuRlDkgW1kFE2G81WKf5xFV59o=;
        b=NVu+6LgZhm9xdxpbPPN0abBKG+x1seYBIK0KwgTa0l1dKDa7r7j0qiqB3lBm/rfzKH
         CuBpjQL+dbm/NAJugmKx5kjg+QrNieXokNCBdQIydM5rkVDcL/77wOk4b6216BVNeh79
         vCAtlKXTx9tPqJHT92Nofzfxf9p/AJW4qdEAattUDBFtO6vG/9vw7qaNbHUCvOchtDcr
         5rfn5kLPWqSeqsJePYmJ2kP7GdLlrmlFe98/9WohFICXA8e0hIv9WsKZmSU+uJ8oRoys
         Z/s3GiEkpD8aKGP9gwjI+iYeHdey0bH51qsuykunMuE6tMq0B60394k0fgB92dD7doHL
         q58A==
X-Gm-Message-State: APjAAAXu4GptBL67cl53AAVexF/Ym8SJkX9bfF08paRXBUU4b7Kg0b0N
        dKPBz3I9ANIiIC0JgFRBIDNibarZnlE1Sg==
X-Google-Smtp-Source: APXvYqw9WgcvA800CXYRmXqkzk6kulqwCTaNcNwuIj730CX2FbtmfrAwh+C2P9lrOJLPGLoo4oIGlQ==
X-Received: by 2002:a1c:1b15:: with SMTP id b21mr30294819wmb.104.1575433616302;
        Tue, 03 Dec 2019 20:26:56 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u189sm4025206wmg.40.2019.12.03.20.26.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 20:26:55 -0800 (PST)
Message-ID: <5de7358f.1c69fb81.69a0b.3ed6@mx.google.com>
Date:   Tue, 03 Dec 2019 20:26:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.205-93-gcbb4900ac29c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 52 boots: 0 failed,
 49 passed with 3 untried/unknown (v4.4.205-93-gcbb4900ac29c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 52 boots: 0 failed, 49 passed with 3 untried/un=
known (v4.4.205-93-gcbb4900ac29c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.205-93-gcbb4900ac29c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.205-93-gcbb4900ac29c/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.205-93-gcbb4900ac29c
Git Commit: cbb4900ac29c9bb0cbc873b0aa78f60a9760aaca
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 25 unique boards, 9 SoC families, 9 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.205-90-g6daac5f965=
98)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.205-90-g6daac5f965=
98)

---
For more info write to <info@kernelci.org>
