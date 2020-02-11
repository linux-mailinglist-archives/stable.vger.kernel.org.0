Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2CA15940A
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 16:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgBKP5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 10:57:14 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38600 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbgBKP5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 10:57:14 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so13009278wrh.5
        for <stable@vger.kernel.org>; Tue, 11 Feb 2020 07:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SnkKXlprjKGxU9TgXl//wSAyPO/963l/e0OPTghw9RA=;
        b=YViL27DBxcgpFh/fafJiOGevvSEoxHZLlOeKTgxstFa4B8dA2l7EjNKgJcF+FE2VJI
         f6LxMW2soA6XQ+lB4Hd3UmCc5tnqueSkpInVDx8TPLRWUv/z7PItUbN2lMfeFnODDYUi
         zuuU7LVw+axLiZU4+t3gV8jJ5Xy3ur25dI6JnEVG1PIb4j94gFis8A1SvtVv/D2CVsFp
         /IfHn4KOOon9ohk//oADQdzcJRFApHrXEXTTWGFjEEN4IYAtvmqNDSUCZTizL8/QbTFA
         LBl7htCaIRogPYYtHsDQV1sFNcri3XXiJ+HhfGNknWmnFkGYLoLTgiwe6AgZtqzITFvb
         vIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SnkKXlprjKGxU9TgXl//wSAyPO/963l/e0OPTghw9RA=;
        b=I4OhQocZbT4bfvL6YiJgPrqOTdRJyxlTc6sW48rn6FfSAERWF1FxYxNXBkLwBBNMcd
         yW0/t3jq0GcsXUzVbLrJOVntr+gxK6hxl2yhs0JFBZ2u8sw+p4mKtxem+eacZY9l0yl9
         UaeMrjTDxCQm7ApRDHyIlY2MVR64LtwkfD8KqWYIXdsrY1AkCE4pFAUPqAQD9GJ41k/m
         NSp+VHqCtoInltLCsRbwoqw7ZmaxbyUDTuWkThajTbgHiPDowopkdt8pnWdORp4MVRKu
         W/calyKouYfTXGSj4gRDcn1TTDm8JLBIc+gdVOhd/cFjhlPAdZ3016r5ua67cNCY7QBJ
         V5Rg==
X-Gm-Message-State: APjAAAU7bMBsvkLIImGX7IzkXsVlP2NdJug3/gYQ1Hmxt93ytRufgtDd
        XcZS1kOqeAx9NmhE3TroF+lD5zgiYCKKKw==
X-Google-Smtp-Source: APXvYqyonK7HzReu9IrpoGJMBi6d9t3+A2Zlsp6HfjfagpXgCK67vPkz46K3l6UWrncu3WY56IyQLA==
X-Received: by 2002:adf:90cb:: with SMTP id i69mr9365777wri.205.1581436633014;
        Tue, 11 Feb 2020 07:57:13 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s22sm4165890wmh.4.2020.02.11.07.57.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 07:57:12 -0800 (PST)
Message-ID: <5e42ced8.1c69fb81.8235.3bee@mx.google.com>
Date:   Tue, 11 Feb 2020 07:57:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.102-196-gf03ffd764aed
Subject: stable-rc/linux-4.19.y boot: 101 boots: 0 failed,
 98 passed with 2 offline, 1 untried/unknown (v4.19.102-196-gf03ffd764aed)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 101 boots: 0 failed, 98 passed with 2 offline,=
 1 untried/unknown (v4.19.102-196-gf03ffd764aed)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.102-196-gf03ffd764aed/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.102-196-gf03ffd764aed/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.102-196-gf03ffd764aed
Git Commit: f03ffd764aed19a09925f1d0e2df9241fdafbcc4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 23 SoC families, 10 builds out of 148

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v4.19.102-195-g27aadf01=
1414)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
