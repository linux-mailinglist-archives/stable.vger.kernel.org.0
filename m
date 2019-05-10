Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F519195F4
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 02:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfEJANg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 20:13:36 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:45857 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfEJANg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 20:13:36 -0400
Received: by mail-wr1-f52.google.com with SMTP id s15so5339361wra.12
        for <stable@vger.kernel.org>; Thu, 09 May 2019 17:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yAAyy3BHNM/31FkJFRTkcNx30RMpdg86sV/KQ+dR8UU=;
        b=LgkxB6I/C/nvl2i9LVX5iYxAaky9eaBPxl0K09GlvK6R4kZPUruSU/xWhaeTwbk5n6
         Wjr+0lBv3BpnwSc/9woy0OBXssEMJG7mW+Dk6GhiHGDXkflm1fR1wJ3bnE8hbROAyw/j
         fToVwgzlBnmpVySrRsYfRLBaKI9AGq9FfJKrMZIUAE6M44vsatwZUEPB+q9E6r/3Em40
         fuNbkmR2osVAS39w2IWeCiQEn2WOcIoyow8zIcUG88onuCydhhoUfE5M4E9exiTcSpJh
         LovUSKdarGewbpHI2Lyyyl7xuaQeA2eVb0V28UK5X3o+MatEiabN8b2cX6E1U5qIB5K4
         nxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yAAyy3BHNM/31FkJFRTkcNx30RMpdg86sV/KQ+dR8UU=;
        b=DpvpX/3Nyay1kbuB4L8GSQn8xjlcXmNw2vWtmRv5JWr0BCarrtZbrwkNeL8/tdKks4
         L2FP2I1rSyIi/SWnq0hPUK9jeYYjbzXBEkjrZjrhAhdlo5g+IZFybdiygwcasdkqMtC4
         bEUh8uzlemjw529xcr1zKTRDEBLQVvpgvKIwPaHUoSNRWeROnm78GsWezq1irlEeHpYc
         Ic9IZVZ3c6bfJ1ZWESM5r/09aLt5vvuU0GGD62uD6EzO/cbR+zkETtlTVDSqzH5Tv69t
         UxuBXnO9buOGq36sjD3xcut2cMJgvEMK1x5N3GOs6EkUhm27bSKlRwPLDKCGRsFS4qGP
         AcBQ==
X-Gm-Message-State: APjAAAV3MfIl7PsUoexnERiLAvPoLJzrY1IrZZ/c01JqugcqfykmPI5X
        YYIhYBCCVZRRWqAgG1jVLP0P4hZ72k1kRg==
X-Google-Smtp-Source: APXvYqwVYuDXhuC/3M0W5ZqgOovxgrSzfRKCQGIy/hgUsGm2z4IUlrKgr3mH7E0bPYGuimvsVg7TCg==
X-Received: by 2002:a5d:674f:: with SMTP id l15mr4994540wrw.41.1557447214828;
        Thu, 09 May 2019 17:13:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s11sm10277595wrb.71.2019.05.09.17.13.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 17:13:34 -0700 (PDT)
Message-ID: <5cd4c22e.1c69fb81.fd5b1.1cca@mx.google.com>
Date:   Thu, 09 May 2019 17:13:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.14-96-gdf1376651d49
Subject: stable-rc/linux-5.0.y boot: 143 boots: 1 failed,
 141 passed with 1 untried/unknown (v5.0.14-96-gdf1376651d49)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 143 boots: 1 failed, 141 passed with 1 untried/=
unknown (v5.0.14-96-gdf1376651d49)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.14-96-gdf1376651d49/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.14-96-gdf1376651d49/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.14-96-gdf1376651d49
Git Commit: df1376651d496484d341d374c3d2566a089b1969
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 25 SoC families, 15 builds out of 208

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

---
For more info write to <info@kernelci.org>
