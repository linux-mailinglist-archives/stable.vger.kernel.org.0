Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDE53981B
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 23:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731499AbfFGVzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 17:55:18 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:46106 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729577AbfFGVzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 17:55:18 -0400
Received: by mail-wr1-f48.google.com with SMTP id n4so3479040wrw.13
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 14:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9tfl8g/UdIJ3b4cuWXwDX6R+fXLYJszIkKwRsm/1XpE=;
        b=sOpcR+x2TBlgc7vq53wsAUwdeCzCZyM3U/RxNVAYhHncbbYSl4FV+JTjkMTO3WSna1
         FyYLzS6kBQ3tu9IadFDVn9/4/BRTwIdtdPNQDYQdiswhjmzU2jnLLb6jWJl6BySHkCfb
         QjUXQqdm25Km48W+AuNsDnTML0pmBL9kLASierc00NJiCdCZ+JcDhTEwuQ3ucSj1sTaB
         Dd8lh9mnlXHWSD2fJfXI0VB6ZszIVKuaGmAymscinKpgjNjNd/Tzvd91LHb+aWYAveah
         2u5HICjGgnSaXIg/KAceZ+p41YvJm0Aog3Jf7LneoYRtzYsks8yPDJRgqjqniUxWVH6t
         SI+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9tfl8g/UdIJ3b4cuWXwDX6R+fXLYJszIkKwRsm/1XpE=;
        b=KC66YlIUyRx9epBbV0jNJwmjqp68csuNbq+hIbqpUGdQ1xdA37X+s3aTk34KIIQjZN
         CrWunW3jQpOyPOkdXv70buZCLMYIGTTxW+cUESn9NyTT+lN5cjH8G4dplDXnuHfMdGgJ
         +/chJ80qdVZvAzKHomc/PTYytgi6gzRYKtDRqpzpfExAs5GgrvL2iw4eDiEopAT/Wcvx
         b4BpTtyBfQGfQUR5b6YKvcmdT4xccXbnERHnnnAF/x8pRJsHNyK311yO6m/qCxnp26Xr
         prd1XXPKF9Ti/qsxpIYhVZvqCVd2BFRqICNWrG2lGRHLG5ExJDZi7siHQ1NI59fjZRta
         /YaA==
X-Gm-Message-State: APjAAAW1Pk8huKkz1/wec9NiDAtvnksbDgCcMXKOetqNNmktdretXaUS
        nktf1MnEX/KVXWH4RlXafjIkp1Wa5tJv1w==
X-Google-Smtp-Source: APXvYqyYB7S09J2oj6QX+cOA4/x2wXnZrnW4poj0DtOIALLteEIn9DQs275saMR7NN48r/90NIX2Mw==
X-Received: by 2002:adf:9e89:: with SMTP id a9mr21449951wrf.78.1559944516696;
        Fri, 07 Jun 2019 14:55:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r5sm5347126wrg.10.2019.06.07.14.55.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 14:55:16 -0700 (PDT)
Message-ID: <5cfadd44.1c69fb81.d2b1c.14d3@mx.google.com>
Date:   Fri, 07 Jun 2019 14:55:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.48-74-ge035459ea269
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 131 boots: 0 failed,
 129 passed with 1 offline, 1 untried/unknown (v4.19.48-74-ge035459ea269)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 0 failed, 129 passed with 1 offline=
, 1 untried/unknown (v4.19.48-74-ge035459ea269)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.48-74-ge035459ea269/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.48-74-ge035459ea269/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.48-74-ge035459ea269
Git Commit: e035459ea269bd7043037d4ed2b25358a4fa0e0f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 23 SoC families, 14 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxl-s905x-khadas-vim: 1 offline lab

---
For more info write to <info@kernelci.org>
