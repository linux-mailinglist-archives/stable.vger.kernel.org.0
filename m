Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF862F724
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 07:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfE3FkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 01:40:19 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:39535 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfE3FkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 01:40:18 -0400
Received: by mail-wr1-f50.google.com with SMTP id x4so3251916wrt.6
        for <stable@vger.kernel.org>; Wed, 29 May 2019 22:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JMEyUWmXaaJsTdIjDAGpIIBvFDGVzyT1a58p8wvMwLA=;
        b=trCd9l/VXLZxm5VkldbkwL4pHjTySiRYVVhcjG2sFxqeJiGqk3FdnlPdIWTQrVf+8C
         J6RB+niCRc4okChvhLD9M6XrTyM79WNMNzoVun22D5MQhaBDu0whVsZnnMuspIWaULVa
         Lu4EVbatmpN4yR0nNaxTL3BnJMLYEP0bv1kV4YdZqrpGGrz0Nyo+WPJafGzWPRxNjny4
         /ttp79IedwRaMFjFwwtSnbnOU4ZAx7LOxtQc+WTozRilgjd5+3gCnMlaWRVuPQLwjohw
         GU5WS675vZYEVmDDW8dq96VZGmArULZlN4a/HBrXi8EdAJTy/QsbMKp+LF//ZSsB+Uz7
         iovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JMEyUWmXaaJsTdIjDAGpIIBvFDGVzyT1a58p8wvMwLA=;
        b=WceSTixSqVvWdjwrkrftf6aW+KetIzVh14dBw9rAG6iJ5MPR2CfJJ1ls9RMvkoTJQ4
         v0zLGLTF68YqkWrs1FparL2ifapSQqY5VLzb/OqW68oHnDF5aRwH0uwQeb1LE8KyKpHc
         WnK2eHqHUmPj6w0gvl62LOKQsZz6Mo0/12k5OHxXc8P0QRD8muvf5fHUlZWHAC6VzQ32
         gL6433lmgN4gk2anccIZEnKIO0/L6pf0jxTdqrh6VG5/mCbKSm+8VPZZigF4+GbTiJis
         GjhAi+2Fsva7SRl9yMW3kIzgi4fCfzaJRCd7f1ZUlJZSpBoyRGwg/FPdC2y6yOH0eSC6
         vvaA==
X-Gm-Message-State: APjAAAXnfcI2hBcVnGcFw2CeN+LLhuz21pwJNTkyJJxR521zV2dyGNTA
        J88yIn9d+qRhuqSvb6BZprqyFLFQJt2RYw==
X-Google-Smtp-Source: APXvYqzs9oWDgTOsiYS+qwvQpVpnR7bK6dq4kFgHkknyo4ATrxLJ+PsHYl+a99LtlLX8tV90OZwRfQ==
X-Received: by 2002:adf:f9cb:: with SMTP id w11mr619227wrr.314.1559194817301;
        Wed, 29 May 2019 22:40:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u19sm4760710wmu.41.2019.05.29.22.40.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 22:40:16 -0700 (PDT)
Message-ID: <5cef6cc0.1c69fb81.87093.6392@mx.google.com>
Date:   Wed, 29 May 2019 22:40:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.46-277-g9c8c1a222a6b
Subject: stable-rc/linux-4.19.y boot: 118 boots: 0 failed,
 118 passed (v4.19.46-277-g9c8c1a222a6b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 118 boots: 0 failed, 118 passed (v4.19.46-277-=
g9c8c1a222a6b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.46-277-g9c8c1a222a6b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.46-277-g9c8c1a222a6b/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.46-277-g9c8c1a222a6b
Git Commit: 9c8c1a222a6b10169a5d95dd02011515ff85f709
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 22 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
