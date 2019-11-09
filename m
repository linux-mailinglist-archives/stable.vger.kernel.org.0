Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C0FF5C87
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 01:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfKIAtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 19:49:51 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:33577 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfKIAtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 19:49:50 -0500
Received: by mail-wm1-f52.google.com with SMTP id a17so7753942wmb.0
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 16:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HbWqXty6cqaMv/LTlNURbDS2LNWnKiEuBM4m7cwJBAg=;
        b=Alxfi3w/YJ2Ivree5H0uLfYWhBo7CHP2BuB44Bq/XQTxkG9WgZ62dqU70wNo+tG8jN
         kYKh0vNxWKY80yMFTfpCFjjWAdlFn/AOFqb5gOkhWWH3k0LvPljeCs58cAXGZUIPeAIX
         ZGg6Ks3DqJvuIXO8qg/5o+ZGDTp88vUdOSEZGb0JjEqtvI/fL/PPJgyR5oPc+Sn0D5iP
         oVwhr/0Dnuq3suxc0BY9smN5odUahzhMtJheQfd8EIJ0rryuXEbTRZT+0IW9lJDuxF/E
         yPhwwraRUrKJmKix+j7o+F1LZY3BYXw1ETg4+0+6DtcPYfxx3BKZb3RcoMNKk5Dcg5Ka
         K95w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HbWqXty6cqaMv/LTlNURbDS2LNWnKiEuBM4m7cwJBAg=;
        b=NH+qJyUp2KSOTMYJ3XH1XHGBtkuHDNJpuV8+BhxjI0puUnsHGx4xZoEvAe7vIwko88
         aOyyCbf+sekCTCjqfr5iVMVkbefwkzzFd80l6x6HcWT9LTNZc6Wo4oTXa8rvzNBLax8q
         i2rV3AR6Wk23YfJhB2c41vImwjsK3DvpPG5dSojttNaNvl4zLe7ikz8/2lk/0ZZ0LYyz
         rViNBlnBlsagCix4LnoyJbNi73lFa4SfY6Cd2sWgMTcPAULW4NQGdtEQ8HoRZbniCybb
         LhgYwckzZJ1d2vSc/73IU5KgWMhBl8MqdID/RRUcs7l37eyffawE0I7OeZ5FlPe2F854
         CS0A==
X-Gm-Message-State: APjAAAXskdnsLB/SfaZsi7bkfgGA3HwB1lswjkYFiYndsD60VsCLh3PQ
        EGUpr+8Cj2VIQsAUCdCPSiCEEwX41synMg==
X-Google-Smtp-Source: APXvYqzjzhTMnOnQCzIyluub/LcvNpnqZsWfMrOP4bmwowHhqEZwRKdHf5MwtwpTmopVlZsEFKjo4A==
X-Received: by 2002:a05:600c:1002:: with SMTP id c2mr5232399wmc.79.1573260588469;
        Fri, 08 Nov 2019 16:49:48 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g14sm8473860wro.33.2019.11.08.16.49.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 16:49:47 -0800 (PST)
Message-ID: <5dc60d2b.1c69fb81.47e59.d59b@mx.google.com>
Date:   Fri, 08 Nov 2019 16:49:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.199-35-ge0ad85ece397
Subject: stable-rc/linux-4.9.y boot: 93 boots: 0 failed,
 86 passed with 7 offline (v4.9.199-35-ge0ad85ece397)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 0 failed, 86 passed with 7 offline (v=
4.9.199-35-ge0ad85ece397)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.199-35-ge0ad85ece397/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.199-35-ge0ad85ece397/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.199-35-ge0ad85ece397
Git Commit: e0ad85ece3979aa8efb65ef7e22c924cd63dc859
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 20 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
