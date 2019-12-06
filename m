Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026E2114AD1
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 03:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfLFCMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 21:12:36 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:44465 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfLFCMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 21:12:35 -0500
Received: by mail-wr1-f50.google.com with SMTP id q10so6028358wrm.11
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 18:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xbMzPQRrYaEdgmbC7wm4y7PSKe5AgfaOcGyFZGAkh/g=;
        b=n7rbIgCcgClUG2tt3+gGpBou3MpAY9Kt/ter15YIigcbK9Po4FHGlyL7I8Fwse6jS3
         iWczbK41K2FnMtl75B8+JDu6Tsv2oDg4lQEHJRFAUKSILku4OJz5p1/GJlG6CbuwLml7
         c1gN8p9zbGBeoyBgnk4dF8eutNd1DoSJy4LtdemBp6vsn3/I+4gzWLSGkxx2lL26Pm5/
         91CL5TgUUXtr332Q99Z0ZVCatTOxj8gzdIdRKfXeZR+iExoCHgQo/iZreN39hZrFEpbY
         i4lvweh0cEiowolF2XiaahOyNK5aIfzt8wFAPTsnk2oAKtcRdNF1m2B83LJZZ+SJNzSK
         j5ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xbMzPQRrYaEdgmbC7wm4y7PSKe5AgfaOcGyFZGAkh/g=;
        b=bnjiVEmFIgqskl9pAsckkNO0nokou1OmNW6wo+qCClBQ32oAitHv5H4qXyhx3LImsJ
         1UX2JmZmcd4TkIWKQiu81JHrkOXPjPS3IIo8Zzt6kA6FOft0wzq7YWtl6oXv3GWzRzm8
         X5RCoeLAlgg3fkjhi/7tcOmN7wKY+9T5VpeXU8tJpiH8Fr7w6QsOOCqgB6LHc7Q5eHqU
         kOCDtXU8Qx29hcLEbNROI9tfcUbYNZJaRwjljGNqoXafInBjU/1Fvx4uiHXtZa3C1NvF
         mPuWZPNC5Ieqgre5wuEcqTN/WCsxk2WcYiO5xg7hVIwmPQdr3QQXFepA0ZwoLL5b9zrR
         gj/w==
X-Gm-Message-State: APjAAAWoH53sxyMrNPygsnDaUt1W+PUY5NdIUu2wyKcWdsfgkCQO7A1C
        Uu2zoYGAGJipZiFWpGI3pBc70/7fX1vC7Q==
X-Google-Smtp-Source: APXvYqwyyytAZrV16lgVCUszoSmW5nbCdDFCEPEb2c5nz+QcYTHkMI15kApfaJw+qIyQdGTvaP3z1g==
X-Received: by 2002:a5d:4752:: with SMTP id o18mr12556587wrs.330.1575598352221;
        Thu, 05 Dec 2019 18:12:32 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z6sm1775925wmz.12.2019.12.05.18.12.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 18:12:31 -0800 (PST)
Message-ID: <5de9b90f.1c69fb81.d428c.9d5c@mx.google.com>
Date:   Thu, 05 Dec 2019 18:12:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.206
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 110 boots: 0 failed,
 104 passed with 5 offline, 1 untried/unknown (v4.9.206)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 0 failed, 104 passed with 5 offline,=
 1 untried/unknown (v4.9.206)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.206/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.206/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.206
Git Commit: de84c554e33b28d68e09bbd0ce5447b8a85853ff
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 19 SoC families, 16 builds out of 197

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
