Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CD3DA1B6
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393444AbfJPWrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:47:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42053 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393232AbfJPWrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 18:47:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so88131wrw.9
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 15:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wprwZdVKHc3kBUUwjzo9tuXQKOU2hx0BUihJyNlajqM=;
        b=aFsDI8VGsMDJhekK5J1Ki7pcyxSzfInUS70fx/Vkvw3UVS5y56tbyMxnbwr97MV9zJ
         S4E8tNXPYRv2P65Q+QPkHWdgmc2Ys8BRXcf26S/J/OrZT++0G9qpjnsuIKjQK7Uaz8Ab
         Bm53BNpD/I2ARtX8bcCisiHLoaPOYuDj60VJk7/rHmSc5Xgqr7FWah2E/bp6/gxz5f0x
         0DF2i9c8aie7CO05n33iw1tRF2fVBymWIwmeY6XACHYcx2TutxK9OQ4Fe7NgFSx8g1Nt
         ZkNbz/YELl1lP5f1Ao+6fcLNX8lcjUaB/l/v1Iqp0go3mBn9VqbUVRXPd19kWzvYeNBw
         tZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wprwZdVKHc3kBUUwjzo9tuXQKOU2hx0BUihJyNlajqM=;
        b=M04kEPryX1jpYvcEvRPRtU/NaK78MzHBPuxjZYqpHRrAcmdunyAY5K2J6s07KfTOux
         1IjHlcLBUakiztZHghpa3GaiwqBsXjGIEhnXXa4ue0fMO4QhtwUBUwwgqpR9bcs8ovyu
         HqAOa1Z7Ra88KNmy3wtWguzHsjivyyRWlTw3d9cEffZGczalVwgV4cyggAFvDtdG7a3k
         ECUQNQP55hE1c1vM2cnEhj+wWZiocV3R/cIVx8yGQT9GRUN+TRUBhyTZ6r6Xr5NQ1o4i
         tu2YMHLrFQjunGrQG05A1lIV7tXft2A4HLlihqztClXuxyah14iDwMHpBY1m+4ae24Wb
         nGkA==
X-Gm-Message-State: APjAAAUq6TO5rVq5MO1I3ZfU5la4eLadM+fJd23Wt9rKVC5uH9l/R2gy
        QynNwzlMvg8qa+hJEp1wTIda/48s/+k=
X-Google-Smtp-Source: APXvYqz9ykc81S8ku0QhikETRLjR66FKw8GnBDOcAO0+6W6M9uXFYW2F4Ib3E0+M5INHp6TtYgZZpA==
X-Received: by 2002:adf:ee88:: with SMTP id b8mr179059wro.355.1571266039809;
        Wed, 16 Oct 2019 15:47:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm511979wmf.48.2019.10.16.15.47.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 15:47:19 -0700 (PDT)
Message-ID: <5da79df7.1c69fb81.e28a2.2a05@mx.google.com>
Date:   Wed, 16 Oct 2019 15:47:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.196-93-ga1b902f708b8
Subject: stable-rc/linux-4.9.y boot: 37 boots: 0 failed,
 34 passed with 3 offline (v4.9.196-93-ga1b902f708b8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 37 boots: 0 failed, 34 passed with 3 offline (v=
4.9.196-93-ga1b902f708b8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.196-93-ga1b902f708b8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.196-93-ga1b902f708b8/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.196-93-ga1b902f708b8
Git Commit: a1b902f708b87c864cbf9f557847782764b59988
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 34 unique boards, 12 SoC families, 13 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
