Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACE605EAA8
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 19:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfGCRky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 13:40:54 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:43052 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfGCRky (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 13:40:54 -0400
Received: by mail-wr1-f52.google.com with SMTP id p13so3750096wru.10
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 10:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+POINp1kn+cBO6mqvPMZAnsq527ncq5tLX3E27oCWUA=;
        b=bbYHvRSZimS3wzyhpXj8vWDT5xwo54CPSl/0d3Q0rCglx4rNR/av9XfbhkKaD1PyuH
         qU3RNhnlX4RaRHtkCEUNY06hXTaRb/aneveWedIh6qq63UsUCwePqQDkIiZm3QieHS9u
         dMs4BBlxuwBYicaN5QUnKhdSP3gG8B7TdE8MCV1YRPG9U1K+uTLSutJqonpc4mtZP1Vz
         5TyT5KVurwWhM8t/RiCcxBFLTIXcuBjrmmDzsumBMs/MeQgxn8FykqXEg+7r8bs8l3Tf
         pUnB/McIa2vafzN5CSv0MWvcYySzbf4/qOlv/Cc38QsqqmeMdmsYdqQZTVQoeu1tYcDD
         NV2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+POINp1kn+cBO6mqvPMZAnsq527ncq5tLX3E27oCWUA=;
        b=V3/8lJkxxufZNutK+vpvuUx+jlLpq45tOby56WjgBnSnhW9pXwI1SXmbGInw8Le+kH
         ozLfgarYHmq3h6DfOdSWp7qKBkm+KJ9q7rWZxom8ts7TrUDEXbxPqgzYdMZYsLK4N0Y3
         /Fa0v62RV+eZkYb7kj4uSXc9jvRTt4TGZ+tVfFhsunYkuWI20GB+rEvtiTFtPH+O3Uhu
         fKVap+EjApIgh+exE22YEbP6cmnl2rWQgQgp4gQ2CJbeBsibsrE+Nm/TrvqjHh42C6VP
         54giRZXo4NAKerdOHM9+Ce8G1/C4eMxMek953AAzgGpUkFNnO4t51Gh2wi4kXwQLzyWi
         w66w==
X-Gm-Message-State: APjAAAVOO2Jk+6AUD3y0u5qEWbhpsWc4EbgE4UObWroABPcqZu3przGJ
        HyWB8S0g4gGhaIUaDX+Hm1TGesaf/9th8Q==
X-Google-Smtp-Source: APXvYqzp9kQNKTBsVVeeZqFzVZHSl6cJWkVuPm6G06xvJLiJ6tDLFJXc9VonNjTYAno/Vfq2EzDvtQ==
X-Received: by 2002:adf:eb89:: with SMTP id t9mr28890326wrn.120.1562175651947;
        Wed, 03 Jul 2019 10:40:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z9sm4092585wrs.14.2019.07.03.10.40.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 10:40:51 -0700 (PDT)
Message-ID: <5d1ce8a3.1c69fb81.20281.7f8f@mx.google.com>
Date:   Wed, 03 Jul 2019 10:40:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.57
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 69 boots: 0 failed, 69 passed (v4.19.57)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 69 boots: 0 failed, 69 passed (v4.19.57)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.57/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.57/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.57
Git Commit: 1a05924366694d17a36e6b086d5bba1a8d74b977
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 17 SoC families, 11 builds out of 206

---
For more info write to <info@kernelci.org>
