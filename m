Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5479DBD75
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 08:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbfJRGDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 02:03:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36499 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394009AbfJRGDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 02:03:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so4820062wmc.1
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 23:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9Unze797F4OAXVu9/Ldiobow7V8413AVee7evFeR1uM=;
        b=H6t/EsvcgNMsVvuijfJ1uxY3osHMneCXtQQQrlzZN6rXaANC+BXEZDM0tIOkRwmYeQ
         MtpX+AFi0N1W28L3rQenHTBi7Q9BPuZDbRrWNEvuvYZWCoecskZRIEFOHFSQldNEUTlL
         xe2DkAP/LViRCqr+7zQfhJ1GwjSa0as8ubohcyC4Cezi/ASv/+iOtUSeN+a7TKz67qs6
         lFjrVmK0LIFLQOSckKYawd89dE4TPc50OmrbRn0ne46pmlhA6lzY4yDIcbRvc+Zx5ZQV
         0KHLpEz8Q66Zc4XLmyDWCLui5J/+swoRy1lJQ+eMAAbrNtursAtaNsrd/O5rjPl6fqKG
         WAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9Unze797F4OAXVu9/Ldiobow7V8413AVee7evFeR1uM=;
        b=KNIopU1BAPf08Mg6CMIEXn8NrDhdSfIai189YFNeugvz7E6qU4lJ9+xfbXTDjSAB/5
         PsyflCrys5pFPnWy4d0LWqu6S7jGpP2spx6gsT/LasZ32xTsoS0xbL1w0hLY6f9ea8Ke
         0VRrTdMR2NYv7Ij/wfvA8P6MDBv9s8SgvNAzv2dj7nbN8DtmqOeBRsHwIUQztXp/EyTM
         FrUcUiEpayTlUAI7J6fm1trTyCNrTKVoVGMsmvJLciFJuzqeB/IiZ1L9QB/ip2RpV0Jk
         +pwtLfhQrA01iTmbu2nsidWgSVEI+QYrBIw14wgR4LRbpNJJ9C26DhPe/KIFeYnJ0w7b
         MmVA==
X-Gm-Message-State: APjAAAXYIjjlez9buC9cRlFi9zRQFirMuTJnfLTSMn2pyxLRuN2fKzbG
        mee/ioD2PQHzhDGMjaCpknNkT1rw/7tbXg==
X-Google-Smtp-Source: APXvYqyNAvKkQAOe/MqbDFbvQryQBRjh/1DaWR8bla4Lh/BYQjRmuqF0I6fGAHI+6XNGLUbKvdlomw==
X-Received: by 2002:a7b:cb03:: with SMTP id u3mr5901411wmj.126.1571378625795;
        Thu, 17 Oct 2019 23:03:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o19sm5380814wmh.27.2019.10.17.23.03.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 23:03:45 -0700 (PDT)
Message-ID: <5da955c1.1c69fb81.fb1c6.c2a1@mx.google.com>
Date:   Thu, 17 Oct 2019 23:03:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.7
Subject: stable/linux-5.3.y boot: 69 boots: 2 failed, 67 passed (v5.3.7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 69 boots: 2 failed, 67 passed (v5.3.7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.7/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.7/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.7
Git Commit: 83f4462ce1557090edd040535e5055e1dcf36120
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 51 unique boards, 17 SoC families, 13 builds out of 208

Boot Regressions Detected:

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v5.3.6)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
