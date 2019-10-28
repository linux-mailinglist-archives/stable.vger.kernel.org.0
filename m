Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26289E6ACA
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 03:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbfJ1C2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 22:28:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52618 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfJ1C2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 22:28:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id p21so7773384wmg.2
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 19:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sCnueQboB7yjbqdY0v/k1fqToGKy0OAW4/Awe/F57nA=;
        b=zv/iD9ofAyHx0yYokkteVOHAqwuN0H+1OEQ2uRhu6BF+1dcCfgGykc7TXxPaZgxsQl
         SKcUGDICyd+K9TVCVUJeuCzzVCisjKzqFthpUoc+V3kfloD6p0UayVu8G6oHEGPn5Rqp
         mwXHhsBAZYNWLXONKa0L+aopUi2bhKWTsACiYCWvSidtfywjyS/FsvaLsA+CiqB/6vX/
         GuubFzhOvN4hRfdIc4oEs17luezHGT6oj1ZosM87/zedDvP974xGeOAdKr2o4YLyL5qO
         d7WG8mTK5e/QT523rD8L6K60/AvoICkB2jHbpVWN2wXcTo+B6lDjye+fcsiemCDiuvzk
         vYSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sCnueQboB7yjbqdY0v/k1fqToGKy0OAW4/Awe/F57nA=;
        b=NnWdOspZ5WLzXM2T/wSiQzi6XubUKvkZe4T9Y2jkY3CX8ZiaNj7sMCDA7hBVSxmWAx
         tSMesCJ6jID6Euomb8de1rr4QOvIFgpgJPhe8BW4gjFpoq4r8cAiFBYnsMsTKcAoKK7r
         YNJQPbL13hQ5D+8ie1sS+xJeuUj+RAl4QdAq3+iDbeJkXNhUvVlxxXMO7SScGA7odZjQ
         NdExRPZiaPjdCAyZ2v7o/11iTgW+chNFNTZNpTs1EXzY5acBKu4+agHziDWxvcoPlHJ0
         j3AfF7hOGqEFa7vJpvt9D7yQmf58IvuZv21QOoKuLIhzJAvgq+GNXnPB/261dPtyc6XF
         eiZA==
X-Gm-Message-State: APjAAAXsd4JM5m3id9avJSVgcrH6N4WKIJeMnBUrphzUve2YPs5WcGF+
        lvH+BjUMPT9hmdbmBdOzBiIGglv6fRg=
X-Google-Smtp-Source: APXvYqzQgaGGfGGWfixhdWFzIjo9xgy/hL9m19QNFNbaDJZrGLpFXGsDEyVT6oj8w7SqFRPmYjAqXg==
X-Received: by 2002:a1c:a546:: with SMTP id o67mr13560886wme.57.1572229684770;
        Sun, 27 Oct 2019 19:28:04 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c189sm12814281wme.24.2019.10.27.19.28.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 19:28:04 -0700 (PDT)
Message-ID: <5db65234.1c69fb81.01cc.fb37@mx.google.com>
Date:   Sun, 27 Oct 2019 19:28:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.150-120-gea1df089eebe
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 117 boots: 0 failed,
 110 passed with 7 offline (v4.14.150-120-gea1df089eebe)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 117 boots: 0 failed, 110 passed with 7 offline=
 (v4.14.150-120-gea1df089eebe)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.150-120-gea1df089eebe/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.150-120-gea1df089eebe/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.150-120-gea1df089eebe
Git Commit: ea1df089eebe2babf969ff53de3fefe3898c2362
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 21 SoC families, 13 builds out of 201

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
