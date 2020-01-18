Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC701416AC
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 10:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgARJAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 04:00:32 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54274 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgARJAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 04:00:32 -0500
Received: by mail-wm1-f67.google.com with SMTP id b19so9589327wmj.4
        for <stable@vger.kernel.org>; Sat, 18 Jan 2020 01:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O/8qNbmFz55Bk6WldKnQLSxf5yQ+XlqeDyt/Uf3IL7k=;
        b=06LWeq0/vs05TgwSZ+rdSq+XRdKHAOJYfJ17l40k2U0UJYcG/FVSmOd3KFVFEY1UPG
         EI1QcNltwCOUyORnSQW2ij5Bn6VX0bxKEJfcqcA3jyMn8naahaUqCkgKAA2rpGloKNfg
         wXHCqYpx7dImrawfOr96O+GdyMpVQw8YDaRCtXqTBONayLzS2Tgi5i/pft5GfhKU6cvT
         yW2rDvoxuUgtY7EMdcwfMqktfzPJxOnToEw9eL33NPZ/w1x80akanWcbmKKTv9onruiA
         NTS4CMEVLKUu+ULUlFrFyTf6qBKIouEUxzkuBj7SsP4l5fPZX7xxEZ6w+E9vo/nTDrV8
         oREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O/8qNbmFz55Bk6WldKnQLSxf5yQ+XlqeDyt/Uf3IL7k=;
        b=pLTGkPmvw+j8Bpba+q2CBJ3awTUJxvoOup4WAxGIyXRDHBrpC8LoGND0XyNElm44dF
         3JAwUm9SUYROWU8E1vstvWf7Puq/p97nZ1hKd9wl+xjHMyvCgd+jMjW8VSw4hbB0HkdX
         1hmCWhxPsoewWQF3zCrvvzbwZn8M2BxnDydvalXbPh4+EN9e2/GV1N0OYW+Kt4X7IbLx
         hPOOShj66G27+uwl7ZH7JaCdEiuyksRv4zm5qzD+/68di/jCOYWLvnfEIYDkAP1FpraX
         ge97DkAcgBQ4RdHYK+RzQKEfdGr39Yae7o8GrxT4LR4NJaJyup1wrZeB8GfAj3EnX0qK
         z85A==
X-Gm-Message-State: APjAAAVBdiH3VPcFngWBYhlTqaP3Hmoa5XWpoYlUqPWb74OAGRDo8l1J
        heQfRSWU0aP1Z3FxVXebvyYWXg1f/qxCeg==
X-Google-Smtp-Source: APXvYqxli2nKZ+9yoQ8cisUdGmFUDuXT7HZwPnzTU8N2iIYcipkcALrjMboyMwOsH4hqn0lbLlhjxw==
X-Received: by 2002:a1c:964f:: with SMTP id y76mr8564443wmd.62.1579338030311;
        Sat, 18 Jan 2020 01:00:30 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a14sm39552356wrx.81.2020.01.18.01.00.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 01:00:29 -0800 (PST)
Message-ID: <5e22c92d.1c69fb81.f3667.15ee@mx.google.com>
Date:   Sat, 18 Jan 2020 01:00:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.97
Subject: stable-rc/linux-4.19.y boot: 62 boots: 1 failed, 61 passed (v4.19.97)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 62 boots: 1 failed, 61 passed (v4.19.97)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.97/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.97/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.97
Git Commit: dc4ba5be1babd3b3ec905751a30df89a5899a7a9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 11 SoC families, 12 builds out of 203

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
