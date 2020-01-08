Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75AA134911
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 18:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbgAHRS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 12:18:28 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46516 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbgAHRS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 12:18:28 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so4166943wrl.13
        for <stable@vger.kernel.org>; Wed, 08 Jan 2020 09:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LjBuLiGu5fRc42Tb3u7i91KmqLjHCFPh2ZHSVCn/Kio=;
        b=Yy+FtfckL7NZnzm5HFUiyukXy1nWqeVdtFIx1JsVG1quo7DY250LPTnxBdxbKQP96w
         NMEkafLMkROnEpzrbfDD8MytuN/9nLMVP0ccx9wqYmciKp9ZdXYD5WmbvlWPzMfBZh5n
         MUipt0YZrkCMDPlSzBQ2W5mPB/G8/zIaFeKWV2nOmY5iiAVO664Z+57L/WCPD7Ai5gif
         drnXsz/EB2EUlQolRuaWmFQaeQGl2G97Lou1XegfWbsjZ5pht0rcXDZnvcuKPDaAyzv6
         LIX5ILZhZNvpwy3JTWiLaNc9OOeXVXsNozbUB7Lnb2OUDa+3QJLK1ZXA8dKvNx2zB7De
         y/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LjBuLiGu5fRc42Tb3u7i91KmqLjHCFPh2ZHSVCn/Kio=;
        b=umw5zvjiKS+MwzpomivUUgYOvXTzu5FpWXLuPOfODOJvCrEV3SV4YPQ4Vu4eQu3vWn
         vicFW270pP6UHBEieGfFXvyeb8Ez2QaRqRk5lpRg5qmB+nmHLV7QxSW3adE+QSsczMQ4
         TKANHRoR66P5fIVIY4PFcSqRVSVjx2NppiSeZ8mbEQCVdovrsQvZ/c/OBEhUawjnZqGH
         +Thgr1YdbErBfyUmci9rTivlvsrcGNq4JpbaNbu/iUS62z5O7Z8bx0vMYDc7zcmbGW9o
         JNZBt88ormPkT49u1A/0PHApwjmmHaepxx00sADvZsKzvigqn1ggRCVICmb10/mDZHx7
         3hAQ==
X-Gm-Message-State: APjAAAXccUaGdLskZrKghLVC2221zt7DZENfnmAhiPDF9ISidFGLCjpx
        MZUMlbd20WzwxrR/v3pv0hwxXXseZCtiIw==
X-Google-Smtp-Source: APXvYqya+O1g1SorsicfY9+YiiClkP5abjLYFu+LXyptu8ssRdhlSz4TEM/nFUbs8REFe/Kg/lvrow==
X-Received: by 2002:a5d:670a:: with SMTP id o10mr6045501wru.227.1578503906442;
        Wed, 08 Jan 2020 09:18:26 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q3sm4306414wmj.38.2020.01.08.09.18.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 09:18:25 -0800 (PST)
Message-ID: <5e160ee1.1c69fb81.a89ff.442f@mx.google.com>
Date:   Wed, 08 Jan 2020 09:18:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-163-g404399b2e7db
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 42 boots: 2 failed,
 39 passed with 1 untried/unknown (v4.14.161-163-g404399b2e7db)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 42 boots: 2 failed, 39 passed with 1 untried/u=
nknown (v4.14.161-163-g404399b2e7db)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-163-g404399b2e7db/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-163-g404399b2e7db/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-163-g404399b2e7db
Git Commit: 404399b2e7dbcae8377bff92324178718f9574d0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 31 unique boards, 8 SoC families, 10 builds out of 201

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v4.14.161-164-ga95271ed=
f2c8)
          sun50i-a64-bananapi-m64:
              lab-clabbe: new failure (last pass: v4.14.161-164-ga95271edf2=
c8)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
