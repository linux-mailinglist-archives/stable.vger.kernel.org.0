Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC5C18B10
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 15:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfEIN4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 09:56:16 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:34168 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfEIN4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 09:56:15 -0400
Received: by mail-wr1-f46.google.com with SMTP id f7so3229445wrq.1
        for <stable@vger.kernel.org>; Thu, 09 May 2019 06:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xm4uFlGSnu8wurocuzHJH/lgCI4+5dNX1CsusfdUsek=;
        b=viCdQ6Wf2vkkrb2++rcEbY3Pl4PAVGuucbcd2sSQjHr/1nzF8f3tOXzFQjF0f3jTVI
         DaxzCoqZimFfWVjmzkEXkfABc3oyuEBtFkgl/6jFGLqyuOfpKaw/hydn7BcKgkPiKzac
         /OKnThhPpoS8kQu1Zefny2BTBKUikIH+XlPp0qdysGIplnFOI+Ep7PDQv0DqwACBVGgZ
         JIUWY2cvXI2aOjwhe/ckqVHI4HshpaA5XdnWcmsnmPctAuPVTbKKKgOAOBnIdlKAFrNL
         JOGCuHVR//oHyEHvqvsGzOUSVv8G8cZUiZM5MHaVWx12GHS5aE9C73iCoIgQ446jFLWk
         tlzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xm4uFlGSnu8wurocuzHJH/lgCI4+5dNX1CsusfdUsek=;
        b=XrH0EeQmRV/p7HUtGN6x1jzDOltWmCz9jvwCeNwUbLJxhycTKF1sM0iuaMqT/GJwex
         rd48/VwHL23hJbWXOcy/hLtYlE1ae3rDWxVSe4Mx1tZDVbOUzxnE6Pg2282/UyRyVFis
         dkrZdS+YSG0aw73l3l2hs57HwvBNdK3guq0q6oBaq1OK1kLNroCSHH2U/bBcLopkAfFS
         TsFCNhtOGbUj2oVdl7nXC3bS4GOU6ZB1nFhko4KNZrzolzuRh6DJ0SNedjQq9rR6ixAM
         1HOyJjhRzFUr695g9wfOgCBHL2JkmyPMFWOZP+ZzsFSuZ7pW/4ivRatdSI5CUBhneX3L
         6Enw==
X-Gm-Message-State: APjAAAUk7mVNo4F1PtsIztHs4sZ/iE8ZxoAK7yN9ru02yxnkeeEknWXr
        IbjOH8/+bUbESGQO5StQO/R+BI+tM3+suw==
X-Google-Smtp-Source: APXvYqwBtsoikgPo7EPzGCaf2IcPO+xO0iFyDjfTOMi2aWbTIsJlL5oEOYWi4RcSSbyzXAOdrjrHEA==
X-Received: by 2002:adf:c788:: with SMTP id l8mr3216479wrg.143.1557410174373;
        Thu, 09 May 2019 06:56:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 17sm2927373wrk.91.2019.05.09.06.56.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 06:56:13 -0700 (PDT)
Message-ID: <5cd4317d.1c69fb81.7807b.e2a9@mx.google.com>
Date:   Thu, 09 May 2019 06:56:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.14
Subject: stable-rc/linux-5.0.y boot: 139 boots: 0 failed,
 135 passed with 1 offline, 2 untried/unknown, 1 conflict (v5.0.14)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 139 boots: 0 failed, 135 passed with 1 offline,=
 2 untried/unknown, 1 conflict (v5.0.14)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.14/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.14/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.14
Git Commit: 274ede3e1a5fb3d0fd33acafb08993e95972c51f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 25 SoC families, 15 builds out of 208

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.0.13-123-g5b4a1a11a1=
8c)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
