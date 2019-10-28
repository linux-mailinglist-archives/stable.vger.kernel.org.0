Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C058E7869
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 19:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733284AbfJ1S17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 14:27:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54352 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733276AbfJ1S17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 14:27:59 -0400
Received: by mail-wm1-f65.google.com with SMTP id g7so10573342wmk.4
        for <stable@vger.kernel.org>; Mon, 28 Oct 2019 11:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OXZjwZMcbtN1nQHKUI6x2sDOK9o4nPzSxKg89KFvOBI=;
        b=FzLRbXZLRBNxPne2Nnz/KBbtjDt1IPsgOMuCWc+Oeu0EKml4ZvWXj7rqq+iXoKCb4f
         Kt3j9HV2RviDaMNCvFmzz1NyXfLuVuhBAbL4l7NXLg4sAiWjAZGlCGXRYqm9jkg+kDnO
         Bh2BlNhvt5lSmTKqyMwY/TmskXuy0MljV4iy0vDhO5FnF2TxnC2Os0TphnKf3eNxBe7w
         mXiBixgXFi/GG+XLM1knnPTiWfGO0Q1g281oY8hPM+vbfo9iuvzlwdYzk26rVVuXnMsI
         PQABbKAMG+V4SD4nKT9eQtZWNUriz4wsCNwEcfbUMZdm4/LFnXeD1DoCGm3PYk0enEoN
         YqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OXZjwZMcbtN1nQHKUI6x2sDOK9o4nPzSxKg89KFvOBI=;
        b=Re7r381OS8mdCWpdg3Mo/tU+D/TNmlrh1TraZowxXjGy9CuEKwv0PkhIA1AFK69YWg
         aBh3LfHJf6sbVvSqDDY1IIYj8GHwI+LYIl3jLBe0pRrqIdyeZDVwESYNA8230z+A9JIx
         dKiQ2X30/ZaSw34PZERooRCs6S0D9ubGuxHZDosVRQlvprsHHbTg1NtZoWV3OBrrKeBv
         UehcNLnmbkQ/HKAzGvLLfENe2GyQiwVp1knjuQxsCrZVum5lyb6cN98x7PX2IRf9OHTr
         v1wFiiisHl43S53c0eP5vZ9hhBYcRT+p9cFw2NM5xMpWbisJEMRg+fKrTNjmXkHZeSpT
         8pfQ==
X-Gm-Message-State: APjAAAXghVlUbwaZyqesGx9FeHDAyau/MsqUZhL30Cf+ifyr8R9mdmHo
        fGYB5963CSUvl7phXtEMsevWUTjJM1L8Sw==
X-Google-Smtp-Source: APXvYqwDoCFVLxGgn0++mS5KgHsCwEHoUOvfeM4bjK16OAAobyNZskz5mkLperG+gb/1ou6q0yX6mQ==
X-Received: by 2002:a1c:7c16:: with SMTP id x22mr631449wmc.46.1572287277560;
        Mon, 28 Oct 2019 11:27:57 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q6sm13308993wrx.30.2019.10.28.11.27.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 11:27:56 -0700 (PDT)
Message-ID: <5db7332c.1c69fb81.4c895.5a9d@mx.google.com>
Date:   Mon, 28 Oct 2019 11:27:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.150-118-g80117985de06
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 120 boots: 0 failed,
 113 passed with 7 offline (v4.14.150-118-g80117985de06)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 120 boots: 0 failed, 113 passed with 7 offline=
 (v4.14.150-118-g80117985de06)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.150-118-g80117985de06/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.150-118-g80117985de06/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.150-118-g80117985de06
Git Commit: 80117985de0635c8d7fa58fa198b7bbbd465542d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 22 SoC families, 13 builds out of 201

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
