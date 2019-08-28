Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD219FC82
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 10:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfH1IC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 04:02:26 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:40270 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfH1IC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 04:02:26 -0400
Received: by mail-wr1-f43.google.com with SMTP id c3so1453542wrd.7
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 01:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hwq4N5VbJ4aVHyh/1uN0EG4YeEnvfyZM0tlvUxZb/RQ=;
        b=DlecZfM/ROeuYrp8zQ9y/MmWiQ0GYc5SQwCJ6LWmu32YLMNjvEVb0xHhvgtEEIVa8L
         phxSTu9DWwcIkj9QDuRjglnLUMJ5okfRzDL+zz7dTC9phO/rbQWg325omZ0VaZHzjcwF
         vHiRJC5U0rqjSBWt+d5GMJrz3ntwkeCQyY6xtIBZKVDp7VGgfGSDkzpeWHqNhXu9WTGI
         Z3n3lsqz/6cQRT8wU0XwYhmSyr2qUqDZiVxq7leeQDiG/1DSvthglZICeuDZ82OPHSgx
         A0OfYLD+9JDBb8i3o0SfQi7uJ/zk5NnSUR3Mta6jACyOt2uvEBntKTXL1JTTKmHMNjFp
         prmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hwq4N5VbJ4aVHyh/1uN0EG4YeEnvfyZM0tlvUxZb/RQ=;
        b=hSghZi1X/wPtarKT7rA6Aql7DlGKmAZZB/fDZE+5NfZvrCqGgFE5DMR7trLUvkHqZ6
         MlXpWhSfco/qJcmr6InJzrrRBWuBv5sf2bbxxRXnvT7QikVbF7J5QKy/sOiJJr+y+0o5
         D9kQlLW1Bn9yQuy8XmapR5sa7bn4+0zxEMnixi+GY9GtIn7uMAzjmM6R+GYbHy9wUmq1
         LrcrE5SjEUbR74rHzp8CxgXFmy1qFSUmDsRaf/jerLJwkO/BySUY9ljvhmWKu6j83MKW
         Y5KJqbZbn4ZFwq0hvYNVyPQKtVVz08YHJ3HfAd4Sf69TPrI0JZflcxD9ueKdog110aJK
         +VDw==
X-Gm-Message-State: APjAAAWgHvcg3vkTSKWleVRiRqAKByulTdvQw/F/dD9OsCJdoiQISjfH
        YyehoCC+5W10O9GALEAKX16WP88BLHD5Fg==
X-Google-Smtp-Source: APXvYqzi24Bkf7jWUF1dV4EbENQPtzidUhnMxI8txjxk+OYmW5yTIIM5KRLGpA988j2DU2LBl9qj7w==
X-Received: by 2002:adf:e50b:: with SMTP id j11mr2863584wrm.65.1566979344060;
        Wed, 28 Aug 2019 01:02:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v6sm2495819wma.24.2019.08.28.01.02.22
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 01:02:23 -0700 (PDT)
Message-ID: <5d66350f.1c69fb81.db095.bef1@mx.google.com>
Date:   Wed, 28 Aug 2019 01:02:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.140
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 72 boots: 1 failed, 71 passed (v4.14.140)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 72 boots: 1 failed, 71 passed (v4.14.140)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.140/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.140/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.140
Git Commit: b5260801526c77496dd8be7d750c20939ec64189
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 33 unique boards, 17 SoC families, 12 builds out of 201

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
