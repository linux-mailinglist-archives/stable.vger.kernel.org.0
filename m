Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7255E11BFC6
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 23:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLKW2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 17:28:22 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:41654 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfLKW2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 17:28:22 -0500
Received: by mail-wr1-f48.google.com with SMTP id c9so406299wrw.8
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 14:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cElD9geyzs1oKPwtyEIlsWnU5Na+Yt/fD+CgM+ggJaE=;
        b=zOaq2fxn43JJ9qUqA0GHmH4q4TSEMW0Zvd4WiS+FXh9Wx/pL8DNiDoGjHG3nwGnQjZ
         zK9/ikXYRVbIwAxFcVtsfS77BGferge3+pxmL130HwcWDi9DbbS4eK/MIJkCz/98iA+u
         CJYIR5H/MPWyNMn/nLTocgA/2RcwBkG21N3WJ0FwnBYf/Yf9B7PaDvTUVpnsqFZN5cuF
         4erbsh2tMAQ44czIfK/wFd1KiLyS9oM0x08nfMf3fNuE8IWHQM1sjZGgw39Y5Zeojg/7
         dv9wL+QvJqfPSa0bgT0EsHdfiz0OEbBi7qQ3zlgXes4Y6p4nRLW1GWzTYPeGiu14VpXe
         LzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cElD9geyzs1oKPwtyEIlsWnU5Na+Yt/fD+CgM+ggJaE=;
        b=aZwWYDfFX2l/e7/M4Smb76sOpgfYOVHt5a+5dtNB5n9sagJ7WQCTAQIcXXR4nQb6po
         O/yDyJ/uPivfeaYpA1QD9nxt+0kZuLxjWH248dyq7A1KsWv6iJWyA1UxCO6FySYITk2t
         v+SlIc3J2VasYzipSmfco5Qd1h9gQBeDLKUMUX1dqYSYnIERI+JxDCyXz3Oqn1kbVz7Y
         TnOSOSnO72yddSJq7bDTbZPhZ6mEiP2lA/6qVCULIKMR9KzVlQWYldqhlCs7qklKRVVh
         2uJSQiOkGkWziZ3+RzzykNCv0LcOMzI9U9fz51npMMEBwUDFAU5m7rFGLQ8qXVI7kxMJ
         BL3Q==
X-Gm-Message-State: APjAAAUKvpPjfgvw3V6iNGJPp9NymhydfUSufukuMhg7ESue7kTu7rdX
        rFtJiS5ksjHc4Rsp+pzMKbXVjq/rLBjy8A==
X-Google-Smtp-Source: APXvYqyzZjVKimq5zEyOozYcqEdmXNXEF1ByixWUNaMglnwFrBVT7gtiaFI585RQS6vXLHzx/llAKQ==
X-Received: by 2002:a5d:540f:: with SMTP id g15mr2266411wrv.86.1576103300030;
        Wed, 11 Dec 2019 14:28:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f5sm3877489wmh.12.2019.12.11.14.28.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 14:28:19 -0800 (PST)
Message-ID: <5df16d83.1c69fb81.a209a.3b43@mx.google.com>
Date:   Wed, 11 Dec 2019 14:28:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158-153-g1fe060c1745b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 41 boots: 1 failed,
 40 passed (v4.14.158-153-g1fe060c1745b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 41 boots: 1 failed, 40 passed (v4.14.158-153-g=
1fe060c1745b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.158-153-g1fe060c1745b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158-153-g1fe060c1745b/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158-153-g1fe060c1745b
Git Commit: 1fe060c1745b319a539c8c4224e414224655a461
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 30 unique boards, 10 SoC families, 12 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
