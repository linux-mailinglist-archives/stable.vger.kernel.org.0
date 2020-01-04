Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5617E1303F3
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 20:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgADTDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 14:03:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41379 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADTDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 14:03:19 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so45366213wrw.8
        for <stable@vger.kernel.org>; Sat, 04 Jan 2020 11:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LAmBlKIDFoc7l9gA5tzcuHFi/uNagrA4KpfxByG++Pc=;
        b=a4PTq7WJBnBxQP5G4maho/3b7A6lyYxDB2LrlHGG9Me/vZ4V+u63GJNpGaq+7SfFOs
         07H5smcYbjYJ+wE8NTPrYzj1VEp+TNicYsydmKTNcYGtAxIea1ovqRDwlcBUZcihFgDw
         p/rNztmEpqmA7qgQF6xGveKQDwWSh9xFyUrOrS9ICPOCR9mQJhhcIEsfDE0TDMqm1ldd
         xGvbjuPSGXT1UCeWSv2u4YQvs8hx+a5672YHkSJTuGX10g05LvBKJIbPDI74VJ/lmfmp
         vrISUeFbdsMHxCelFxmZN0Xnk+59fv6jZ5oqxc6J7MtLaO/xexJNlKEgklw3LVimNZP/
         UXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LAmBlKIDFoc7l9gA5tzcuHFi/uNagrA4KpfxByG++Pc=;
        b=MFAa1z8aOKt2FV3nQSAT+wwbsrR3rcTzCkg+w9Fn3NCJz5XQn49iPzOvl3uWUGmejq
         i9UF02ZwBgRnIItd4tCj9UM4iqHuq9N4cYfuqorfO2dzppcI9UbrJ1E9Vsgg24MsJOkr
         EoOwK8HCQmkYcAqew89qFzYN3DkRZ2PZ+tEFbKBGlEmpBQ/Us+XX7zubZMo0bM8ZKdDQ
         B7O1okCXsU9rs0Sn8NTaKIglRsJNQXoaqqCx7Nf6sHJmirVj4Ov6tI9Cha07NpfPVUtk
         /UxwSjQS68b6ZTrRTIsVtY/WcrmhLbbVyBDf0Ls6heZpqe+zpjzA1v2VzyS3cHvxpsam
         5R9g==
X-Gm-Message-State: APjAAAXdvs5fFBDQ9L2HqFKCx/OUFpe6dds2JBjQXw5Wdozlq+Bau6zj
        SWVd9cDeFK62cCpEqJqtkopsi/FpB5k=
X-Google-Smtp-Source: APXvYqzuHatcRkQVUfArltUzrne+6J7EVh6T1CyYYxQ5KRlXJu5Z/I7ZbRub4nW/Boo4oerq3vJKhQ==
X-Received: by 2002:adf:f8c8:: with SMTP id f8mr91515334wrq.331.1578164597516;
        Sat, 04 Jan 2020 11:03:17 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i5sm65346964wrv.34.2020.01.04.11.03.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2020 11:03:16 -0800 (PST)
Message-ID: <5e10e174.1c69fb81.589f9.afb3@mx.google.com>
Date:   Sat, 04 Jan 2020 11:03:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.208
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 21 boots: 0 failed,
 20 passed with 1 untried/unknown (v4.4.208)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 21 boots: 0 failed, 20 passed with 1 untried/unkno=
wn (v4.4.208)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.208/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.208/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.208
Git Commit: 6a60263487c4a8543275bcc707561369522bacba
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 16 unique boards, 6 SoC families, 7 builds out of 190

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.207)

---
For more info write to <info@kernelci.org>
