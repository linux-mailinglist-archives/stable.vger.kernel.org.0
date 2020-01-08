Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179ED1343A4
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 14:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgAHNRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 08:17:24 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35384 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgAHNRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 08:17:23 -0500
Received: by mail-wr1-f66.google.com with SMTP id g17so3365763wro.2
        for <stable@vger.kernel.org>; Wed, 08 Jan 2020 05:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wCyC5Hq4KdbYrxctn/UX8R+GFVfGLQ9/1hzgrXylEkA=;
        b=LJ85RPJURmWw+Nf2zIsY3Q4k6Mh7+WumGTMBCmXfSDRezHIopKNxFRRYFxv6lsoyRJ
         9qSPRCTyVlZgZqlbCrX30rqsZHddJEVMfp0/aiG13RXAePZTM7M+21z1Lpzek6b/b9Js
         ayEkCSu8sDOmkzNBoOhUF2av2Cyiartvu7z6/pGQLyZRoLa6Jk0FaYXE2eorjuRqYArl
         VSB5FSydLecEd6KH54P7M2zWfWFTakw1ANYEKJjhso2HlVLa09lSZNOqXSvKdUJZjIeS
         McHDBLI6ZHb50gq0hzA4dxNBz3NumJR1gaXDIpYJGzF4af2MVRmdhcF1KRddF5ZUgsYJ
         EA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wCyC5Hq4KdbYrxctn/UX8R+GFVfGLQ9/1hzgrXylEkA=;
        b=PY1wr2rzTQuoCXXvtaeJRbMY+4qEUtSXb9Py9Y8EafYJpomkzXptocb++LTupri4Fq
         ajoXcgNt4jEe2ToiPT2VjkONc6lEPLB6OUKsre8kVomwYQuNGpuRFSsF3AoiW+MoRKg/
         pbGKilpkfFzAWxxJuTKXcyUQAqdaekzE0WYqM5hDvFhordvi/lnTzYo+w/qfIPaSE7Ml
         I4OuA5ALNtdrPoqaFRpS9+aT84Ht28qzBtLaq5xeJ5kILyVTpQLnUu6XaPK+/rN8Akht
         6JsbR7+8zeIWI7kN2/qStI664tYk4zLmJ50QbKVxUpsFnHU2SyUyOGKF6kT652oR0nrW
         goZw==
X-Gm-Message-State: APjAAAWfxCQhEcP7wMqx+ZnSzTZOvr2sWThmWd7UrbtSrULBpjVlOc8P
        RFyIgXIQToKVSiMl69/xXHdgVSf8te126w==
X-Google-Smtp-Source: APXvYqzAngOvh6Kt2vzHjegR8pGP8Mkoix6ElhTalvnXiKLmZ3ljFgjU8xzxsQ7A4mzNmf1YGtqn+g==
X-Received: by 2002:adf:d0c1:: with SMTP id z1mr4688885wrh.371.1578489441972;
        Wed, 08 Jan 2020 05:17:21 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v62sm3907630wmg.3.2020.01.08.05.17.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 05:17:21 -0800 (PST)
Message-ID: <5e15d661.1c69fb81.29d97.1b8a@mx.google.com>
Date:   Wed, 08 Jan 2020 05:17:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-164-ga95271edf2c8
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 60 boots: 1 failed,
 58 passed with 1 untried/unknown (v4.14.161-164-ga95271edf2c8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 60 boots: 1 failed, 58 passed with 1 untried/u=
nknown (v4.14.161-164-ga95271edf2c8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-164-ga95271edf2c8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-164-ga95271edf2c8/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-164-ga95271edf2c8
Git Commit: a95271edf2c848d84e64808d46ce2578be984c6c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 13 SoC families, 12 builds out of 201

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: failing since 1 day (last pass: v4.14.161-141-g=
a62afa8ee549 - first fail: v4.14.161-165-g3cd31bc7c111)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
