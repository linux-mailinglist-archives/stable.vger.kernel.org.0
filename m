Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEF2261F2
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 12:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfEVKgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 06:36:45 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:39102 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbfEVKfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 06:35:44 -0400
Received: by mail-wr1-f47.google.com with SMTP id w8so1692336wrl.6
        for <stable@vger.kernel.org>; Wed, 22 May 2019 03:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AAG2MS84ZrY3cqfmzjEQBlDy9A3NdyZqf4ZZSJ3lOw8=;
        b=lc720J8yHGu1IJ674vu/gDkDSe7zqoo2NVpqBpK40PYoQyRP2gP4QNy1ViAXsDbt66
         l7ouYT2StAkv8QjYRBm8vheuIEM1tO8SIFR18oa3PVM8P8yqz3BxgVuvs0LOHfknxOVl
         bq0uu40sL08G2e7SiAUNpK2gkzdqAvPDjyZm92JtL6vsJwI7xeSH04dT1vBF0pGs2muB
         1tw/R+1OxCTLzemWNsFj72LxGcVCjtHZSBMyIP941rO4m4h2K8EsHoUXGpzw3W2BQ7Tk
         Apadeyq3jm1DpKwChK7t6d4rqMXTebopplN4pvlwU79w/wWCWu9Qh5rvOYug9vf/4Xvn
         OM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AAG2MS84ZrY3cqfmzjEQBlDy9A3NdyZqf4ZZSJ3lOw8=;
        b=PqTyn+l4LztjNQk2s2/AoV3DLSvrLj35JBT/SlWK4XeQ0fNta/WvYbBDMxtU54J7zh
         Vm2fKnyD25Tj/vlVPtJJlmSFhIX/AmQnlsSGOPvKGhHJbkHFVBiAtuXOiOdm1TF0TUEp
         KzmdH1s3t29ccF4BGlKDs9BZqh1WPNGn+JVai7k1Dwnel+9eHRafy/B2ST5zLsJ7F7gp
         CirIOJaAg0rK6BqbijZ5GECY/eUJya7QpwMlijiTxIcKmTkeho9DTJ93QhoBdiFL+re0
         6zFWUI8B/4S/JreWEh9jeuJf80PXj0yv0KG/8j+E74kZfISg/4r8RbN4eci+LREWKnzJ
         0rng==
X-Gm-Message-State: APjAAAWuhnyqe+lXd5ob2EPQkLXzAxCP1odiqk1MO8BGJtj6bgM8uGqX
        ehAGjCp59S1O7NajmtYRsajK6oQ2i5KE2w==
X-Google-Smtp-Source: APXvYqxq6qSZYAHkEankD7V7UL9egkdl0Oea6c2nJJDJOwukO2i2o6GFmBN9hqeo+0sbedlmED3/AQ==
X-Received: by 2002:adf:dece:: with SMTP id i14mr24028895wrn.138.1558521342247;
        Wed, 22 May 2019 03:35:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q9sm5506577wmq.9.2019.05.22.03.35.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 03:35:41 -0700 (PDT)
Message-ID: <5ce525fd.1c69fb81.ac855.afdf@mx.google.com>
Date:   Wed, 22 May 2019 03:35:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.4
Subject: stable/linux-5.1.y boot: 54 boots: 1 failed,
 52 passed with 1 untried/unknown (v5.1.4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 54 boots: 1 failed, 52 passed with 1 untried/unkno=
wn (v5.1.4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.4/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.4/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.4
Git Commit: e0e8106a6cf13b6abfccf6dac15bac32c9513f3e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 16 SoC families, 11 builds out of 209

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
