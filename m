Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD0E128A24
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 16:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLUPQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 10:16:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33366 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfLUPQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Dec 2019 10:16:23 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so12253976wrq.0
        for <stable@vger.kernel.org>; Sat, 21 Dec 2019 07:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wOSgqqwISfcrkrHwN0lSKA4VD3oj2HRuFTynq+NThUc=;
        b=LS+qceAdfHq+eSwHbMIEXQAIQAzIsu9LMeWUynUYmByjMnR/ihyy6QxlJMZp/oqBR0
         RrtMqW0b3DFJMRCBR5RWpD8zbZRIdSIBjXeMgqmPtGbaPcIbgtH9k+6wqPBcWvCZtZay
         HKjjKCtQtUyOK0P12qfHvt42KvD0xt7TV+x/GTL4crJJ1azhUGusgP6ox327vq5aMrLo
         MbyOVyCVUlorV9Mx9uDUcA6BWEQxW/TIZpBmIOW+c//kiUbp30ay/qvxJC0C9UKmy49J
         yjKUmhKoZUfxhNPuEUxPwn/akY0exsXwhT10dBZyghWGDnxjSURDPzSq9R/EHSnkMiuw
         bzHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wOSgqqwISfcrkrHwN0lSKA4VD3oj2HRuFTynq+NThUc=;
        b=R8heKr2PfJ8uFGZU4Q9n2NhUmyY2M8BC12QiZzjlkxFdL6M/i0jlQxUVKjcgegnz+Y
         56lApE8izMCMRXb+sqRfHBGN6KCImIdMs4F5xrq1Hs1MNe4qh6m8Mi5cnLnPdxcY76Re
         V6CWIZMR6TmhQFmzC7jOiarrWavz4DI8ZwEynkA+q+39ZSJXD1ClmPgVYyWmQSRUuUYP
         mTI+xQgVweJFqoEqaApAbCTFtoacK5IoFTRTZQqAvBeMii9AWnU+hWlyzjkJ7A3gZace
         xvksLabZRNlqVdf1XSfZEqG8aQx2lmWmfMPLt8rXJOfrD2rgJ2RFsxIR3jUQUWJwQl9q
         dv5A==
X-Gm-Message-State: APjAAAVcwM34e4YdCO0xNpBKdQK+g1EcPZw25uScFx2NL11FQbg+9fNw
        Ti2oa4HFISkPdYpsrf01C+Yr8n/i6TSgxg==
X-Google-Smtp-Source: APXvYqx8w1f6WdUIL50lNYpoYGxr8l21incwsrFFqQ30svOhlHmX9d9sU0WAZWOBJBO4MPXA7yf3QA==
X-Received: by 2002:adf:82a7:: with SMTP id 36mr22268118wrc.203.1576941380983;
        Sat, 21 Dec 2019 07:16:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x11sm14408030wre.68.2019.12.21.07.16.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 07:16:20 -0800 (PST)
Message-ID: <5dfe3744.1c69fb81.3393.6f2e@mx.google.com>
Date:   Sat, 21 Dec 2019 07:16:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.160
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 69 boots: 2 failed,
 65 passed with 2 untried/unknown (v4.14.160)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 69 boots: 2 failed, 65 passed with 2 untried/unkn=
own (v4.14.160)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.160/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.160/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.160
Git Commit: e1f7d50ae3a3ec342e87a9b1ce6787bfb8b3c08b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 44 unique boards, 16 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.159)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
