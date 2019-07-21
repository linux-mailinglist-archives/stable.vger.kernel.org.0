Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABDE86F351
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 15:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfGUNCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 09:02:19 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:37461 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfGUNCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 09:02:19 -0400
Received: by mail-wm1-f44.google.com with SMTP id f17so32818394wme.2
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 06:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=phEY/60Ws31Whx0gOvXbcZcmEdzeRVr7vfFJIHM7VsU=;
        b=FwtiDcHoaNgIoPNY/yFXHNnNpJmYMolF6HH+URJ30dQfH1a328a354dOa+2F3Yr4JO
         evA4QX1XiplmseBDcGlqdEGi5r1HPP95srfQpLrrel8hC4zxXuy4EISZ7px/Ez2T1kQv
         2jscl9XdshSxXcPyabzjMHj+zWW70YnblFoFScp4c5u+xYQ8hlDWXwID3I0DxkJ1jiIB
         BTfhAdzVWTou1oHV6s1WRJCVaRVp6WvLXR5+rGBXB7rBOzoHOBpAc0gVMr6ToKdD5ec1
         ds0JTFoDxyuQxBloL8hslY1LDstuEq5FLpqLCibZFURdgOnp/u7O2ho8oOp49paQgWUt
         HYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=phEY/60Ws31Whx0gOvXbcZcmEdzeRVr7vfFJIHM7VsU=;
        b=X1DWolTmGikOyh4PmHg5EgNxUvu5DSrntCcT3hHzOFkaDdEvu1SaI2WaGMrguPgzJg
         9A4Xn8lYv6kaD+jwnK2xSeKOamvO7dJneI4N7KcCuJLi/LahPsTFBevQI3Unde+pfSAU
         ISaWdaJP0REVIBjgubyMbk7i6tIz0a8aPIBnEk5L/kBttmnWk6ctG5hoXwLsAlbr7+R/
         jevzb7pCJIaeMuzmO2wUBCZ0Xi3jOE26+7xshYQw0Y4feAxVRSS7W8e5L8KfiRFeMhKW
         BIOoNk7vYk0ZL8TjHsbHaMaN5OqZoogD6XUVf2bU2uLStauibHJhvTmQMCfDf8RSpkmg
         OvJA==
X-Gm-Message-State: APjAAAU0Tl+p2NcjBJ2Uo2l6RWnPjVzK7srBRkVWdN7bTTS1mBkUJGTi
        9/8yezOVQfx1Q7glAeSgyvqDjD1j
X-Google-Smtp-Source: APXvYqxJaU+r2IzopBjmXnZyssi9jhvDpB5y5FF89LHmgpKObk4JArM5pOapJuMGs3+pkPV2f4za5w==
X-Received: by 2002:a7b:c632:: with SMTP id p18mr60498634wmk.114.1563714137066;
        Sun, 21 Jul 2019 06:02:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j10sm34345199wrw.96.2019.07.21.06.02.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 06:02:15 -0700 (PDT)
Message-ID: <5d346257.1c69fb81.89c00.e44f@mx.google.com>
Date:   Sun, 21 Jul 2019 06:02:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.186
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 39 boots: 1 failed, 38 passed (v4.9.186)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 39 boots: 1 failed, 38 passed (v4.9.186)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.186/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.186/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.186
Git Commit: 35c308d7828de5c5784bb75efcf848996b3a82d1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 18 unique boards, 9 SoC families, 7 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-collabora: new failure (last pass: v4.9.185)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
