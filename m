Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C56616B3DF
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 23:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgBXW03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 17:26:29 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33481 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXW03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 17:26:29 -0500
Received: by mail-pl1-f193.google.com with SMTP id ay11so4631966plb.0
        for <stable@vger.kernel.org>; Mon, 24 Feb 2020 14:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dR6iUCm5Vr5c3iF7genBmi2UWEQCe7ju45R+bPQh6CI=;
        b=C5idHMoN78eWoA+ru5cRrjU+zReiMyg5faBzDomNuhtRCyhWyj9XFBOHPFA5Od2pmZ
         j9DdnficpXtwN6B1vL9KRyjqr87HWnAm/Z/0070NJ/xkt44PTuAnaedhucFMkJMltDko
         6qDvkkDPy7Kd7SuoYf0doBWk0bX+vhYI/74xQjlmwQaOUB4J11luo5x7eV5YWnKr/9zr
         YDfS2zJLbl1OUyncIWs1HouYLKWP6I5DYIMBbkOREIWvR9GLD6g28u1sUedSv1lPbrvP
         Vo26IvheybZ3kym3+8RlbwrTMpjy8DYc5h95pnFmhtUa1l1JBPs8FlGBPzZekc5BU8eJ
         UMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dR6iUCm5Vr5c3iF7genBmi2UWEQCe7ju45R+bPQh6CI=;
        b=OZ5JOvLO6qzsuq6IYu3SBojg3BjDMarHMuB6jIzg4t9ITsiionFFHfSNT9RgObXZ5z
         3PuD+aKSOwHwUdzXeURucSB7a4toZEnKk50glVKDM63UZBq777OgMdJZ4P2FxOayRzEY
         AcEvPCKA8ectJW67Q6uxhlZbMXIYZRt18p0zAqbkKqXsgcZh78QjHZ7a2Jhfm031/ATL
         ftf2fjONlH+VHvh1vtkbCBFv59dXDqFiqFk4CLoudu2tz08r2f/28XNnddPRtxcjJxdN
         WNAxMm6C7y49b9ng9wV7k1Ko9tXsBPAttX8XCqK3R8Obb7AmmcBl3GyP2f4jDEzHhzpC
         jxEw==
X-Gm-Message-State: APjAAAVhuJr9vuqagyPqW4nU2ffgbEozQbkg8pdGsDRb46PAXOSeGk0+
        FA1RofWxAx6qW44o3TNTBlqBogGtysE=
X-Google-Smtp-Source: APXvYqwxYnmw5D0t+n7dw+xvqheqdCW7gTtWR8KqNSRgtobhiN0WYaw0ZwruQyRSA9tbkgguEIA1qg==
X-Received: by 2002:a17:902:8d83:: with SMTP id v3mr52995941plo.282.1582583188747;
        Mon, 24 Feb 2020 14:26:28 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s130sm14661580pfc.62.2020.02.24.14.26.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 14:26:28 -0800 (PST)
Message-ID: <5e544d94.1c69fb81.d44fb.73a2@mx.google.com>
Date:   Mon, 24 Feb 2020 14:26:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.106
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 89 boots: 2 failed,
 86 passed with 1 untried/unknown (v4.19.106)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 89 boots: 2 failed, 86 passed with 1 untried/u=
nknown (v4.19.106)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.106/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.106/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.106
Git Commit: f25804f389846835535db255e7ba80eeed967ed7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 16 SoC families, 15 builds out of 205

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.105-192-g27ac9844=
9017)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-libretech-cc:
              lab-clabbe: new failure (last pass: v4.19.105-192-g27ac984490=
17)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
