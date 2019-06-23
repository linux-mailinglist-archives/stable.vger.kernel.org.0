Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8D14FD08
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 19:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfFWRHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 13:07:34 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:37650 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfFWRHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 13:07:34 -0400
Received: by mail-wm1-f41.google.com with SMTP id f17so11026713wme.2
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 10:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7lwTyoUpU7JxCGFPfUc9orPScE01PvRnX9ebs+Ze0ao=;
        b=oNyqcQTDk7AeVW/03UtQp5pP/8BDEMcwr4bzlx+4WnlXBdY0pTVlGVIf5KTbB71AY0
         YACDlB6mKI7ZYI8ylbbn76GDQItJw4gd8BhQzBF7yovbhb+8b8DfWrIF+tJ9fxry1q1K
         6kt1PkTqwTvOubjrG08VJW+KY9XOchjsR+ACxnTS55NsJEMrmty835A4FDTLWQLFKu//
         UuoEW5lT8MjF+7g0uZREwArJTVbEGiQt+N6OFF7L/X+zRcE+r68jKxExLwGLzRe9E2Yw
         3wNm8wofCra3SftyuQoVKitTionidoPbnAsQQbtJcBBmz/diH7JtxAWgrfMXu2/SFQiN
         Gp0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7lwTyoUpU7JxCGFPfUc9orPScE01PvRnX9ebs+Ze0ao=;
        b=f5aQB/1Oej4Xm4OTyxzvsJUFguR6nOjI/9sjrJz+hMbWv97NaweVXqwqbPg+cKKp+S
         cwUd9/THcoUFmq83bitVX5WKOnbdaKj+kVmAj4Nec2/vecitqoZFQbs4hhLm468TqVre
         ICcaCoInXT3EoKIWPkWc2whl/eIc4nZzjUCi5f989iMO15hNh3QuLAS8KNeoug4dSRUs
         Tp5FwQS3x4BiQrUe15uSWy+qKfIE4VbRRIVWMtaenPxEnG2BiEjU0sS/nRq6hKpybGuD
         GjW4YHIIE+lpkpaRrzwXgTa3DI1pkw7UNxPi8R5LlQp759uPQYSMGbeQQQtnW0gIrjBt
         OGuA==
X-Gm-Message-State: APjAAAUbDslYDPqDWdm4/5CW54Vcm3s/YaEaMKqwNtMS67jutMxNHHnY
        DjZXUyVc3pR3JfiAbI5iQWPETB6Bx/Q=
X-Google-Smtp-Source: APXvYqzC+HH8a93yevP3alsH947TghdbU2FznqUdMofCakupksDxHw3+Az5moQwpkqgqc6+gkt4pkg==
X-Received: by 2002:a7b:c774:: with SMTP id x20mr12119819wmk.30.1561309652004;
        Sun, 23 Jun 2019 10:07:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z5sm7111649wmf.48.2019.06.23.10.07.31
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 10:07:31 -0700 (PDT)
Message-ID: <5d0fb1d3.1c69fb81.9fa91.619a@mx.google.com>
Date:   Sun, 23 Jun 2019 10:07:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.183-6-ga6e116dd70bc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 6 boots: 0 failed,
 6 passed (v4.9.183-6-ga6e116dd70bc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 6 boots: 0 failed, 6 passed (v4.9.183-6-ga6e116=
dd70bc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.183-6-ga6e116dd70bc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.183-6-ga6e116dd70bc/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.183-6-ga6e116dd70bc
Git Commit: a6e116dd70bc0d38761484165b517372d88aa76c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 3 unique boards, 3 SoC families, 2 builds out of 197

---
For more info write to <info@kernelci.org>
