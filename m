Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB9DA67EE0
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 13:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfGNLm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 07:42:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35917 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728259AbfGNLm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jul 2019 07:42:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so14217683wrs.3
        for <stable@vger.kernel.org>; Sun, 14 Jul 2019 04:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6AjXBPC/3jTFjZ/fvkUlCGJumsQeUvtnWPB0qk87wQQ=;
        b=VeVvfVSbU/Qv7xGTKUhOBSdOyg6gW1QdCKjSJNenPAwe2qcukZwnQsaZeKDrJIDbvh
         CqBAwGe9v+eFuvHVhfNPUDbNKw6d3wG2Si96b73T/pAeY75kcGKXbtMh4yq/wNcRT6pB
         C2TThEHcXoJ50S/5yY32uRafaUqSG8Pf5iVIhzZORag7ZuVo0PBpAbfOP/6uEz6aIFE4
         VcbfOjIkeLZQLdi9iY5ru6oNwg6Y4NPK8o92aKQAp/ICZQgqguyDfAs42ff9hkCP2VJr
         ZlNIk60365ZAgJ148EEaX3knlcWtUsvvNVvP1ohe5OC69+WN1pJPZy2chYuoJa8NpN2x
         o2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6AjXBPC/3jTFjZ/fvkUlCGJumsQeUvtnWPB0qk87wQQ=;
        b=T15He9jCirX3EVNqfUfn7VsIwtnfUhnoRPlQtdqV6YqH8QRMG2EVcT7ZS75VBVG+/H
         cEHKCUCpUsxlAtYfouXomBliaX20lcGbu+vFBoyVQNXe0W3KXrwKxI7Bmk9l47nlBNMJ
         ananJWfge7yyCxtqc8c9ocxtQei+9LY/oNXZ8YfMnKsUOOSLUruUg2eo5BV+cnitAzHn
         1/5WgKmRGHvNs8XKNw6ztd1EibofVFjYlvftBuqQQzgHbAW4mixmdWrsIFzGSel+jVHc
         ik06jkiZfGqfr65bqnS504XqmlIEO1fPE08q+zWKJk6inKiGzxXUXicPCoC9F1NHE5bn
         wVlg==
X-Gm-Message-State: APjAAAWbtQKE2ymD6kol3459fbxT2qeO/wKYBQiZlLXh27PnUSWbOSwI
        Uh0F8p2w3Yt2cjKDDi88NqFtJL5S
X-Google-Smtp-Source: APXvYqx20eAEaYg3rQsxXbWgwWFaonxNdEoATxQYVkN64888seMfu4OT2/5mZmK+dL4ta76t9FH9kw==
X-Received: by 2002:adf:e602:: with SMTP id p2mr16257355wrm.306.1563104547314;
        Sun, 14 Jul 2019 04:42:27 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o6sm25686593wra.27.2019.07.14.04.42.26
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 04:42:26 -0700 (PDT)
Message-ID: <5d2b1522.1c69fb81.409b9.3613@mx.google.com>
Date:   Sun, 14 Jul 2019 04:42:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.59
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 122 boots: 3 failed,
 118 passed with 1 offline (v4.19.59)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 3 failed, 118 passed with 1 offline=
 (v4.19.59)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.59/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.59/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.59
Git Commit: 3bd837bfe431839a378e9d421af05b2e22a6d329
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 27 SoC families, 17 builds out of 206

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
