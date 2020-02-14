Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED6C15D84A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 14:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgBNNU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 08:20:59 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:39485 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgBNNU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 08:20:59 -0500
Received: by mail-wr1-f48.google.com with SMTP id y11so10876486wrt.6
        for <stable@vger.kernel.org>; Fri, 14 Feb 2020 05:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ff8ME5Zj09yIw/dHmVX3kZYJhgshkDj0oaup6VTqqLw=;
        b=ftewSWg7YQu+AxnFK3BamzoYB7XQTwzs+qrI0VJF8ZP+p+p28STowknD27EUSNSPq9
         fjK5VTQ40egDnlAD3gjm2y+2XxEpra2qsuz6p68fMZpK6hXwVtq7zv/xZNunB5VWZb6m
         Ujz30ZBr0XSZQdU+VNV/gx7siQ6hM2K4Hl6nBCQq2jU4BvFszdWMe2y8YRaKgRzWi2BF
         +7IfT8IIy6Dj679E14mB4K6jzsH5vdWN8Gz61s8tW2r/rO9HGTIJdryCEeaPOlQ8tl0y
         mOhqZ3wxYFgLKYoSpF7LbdT9++wR0U6AA/F/+cbu5aN0Yl4NUb5Jft2bVUDTxjlU0CcL
         UVuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ff8ME5Zj09yIw/dHmVX3kZYJhgshkDj0oaup6VTqqLw=;
        b=Qg4OclBsk7C90nrYqRfN8eycw4y8GnzbQ9UaK+Ba+7GhB+o77sKdl6mzoyrWlB1r0q
         bT58zs3wmSsgBmnlZOjC8VRzopHLky3Cf+eM5wY8NC9Yl2OCiryXYOvTcsrY4B96cENq
         G3SFNd2ptXxVErzpm/wQU3vSIUGbQYESWoUeJgi2uBqQnZEjBwO2gS2mM7c7sN5RQun8
         SOZyHdlA8xNlwP0c2/OBBF0eAE63jitrl9zkjetLr3gg8YFWlPOl7liLf8KWb208FWlq
         lfX7zlzeO2aApEKuG8w4EgHEkVDLW2qWMeLAzN8DZOTfMqO6k1UPSCocyPuZoYCrUazp
         Abww==
X-Gm-Message-State: APjAAAWEmsAENQGPUnVzqd2Ls3FrEY3Nyulw/2G3jyNTrk16TtGSjV3r
        Jo53lweoGQpYGd9GGgCkCr5iXAprKctI2Q==
X-Google-Smtp-Source: APXvYqylQgPtq/a0EJONddvdzBET8JuZ4gJ7GEkb9LnLH43g57Zx20jim3UGnkakL4ryfSSGSrRRcg==
X-Received: by 2002:a5d:6151:: with SMTP id y17mr4021511wrt.110.1581686457691;
        Fri, 14 Feb 2020 05:20:57 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g128sm7169594wme.47.2020.02.14.05.20.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 05:20:57 -0800 (PST)
Message-ID: <5e469eb9.1c69fb81.96844.ed64@mx.google.com>
Date:   Fri, 14 Feb 2020 05:20:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.19-97-gb06b66d0f2c4
Subject: stable-rc/linux-5.4.y boot: 59 boots: 0 failed,
 58 passed with 1 offline (v5.4.19-97-gb06b66d0f2c4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 59 boots: 0 failed, 58 passed with 1 offline (v=
5.4.19-97-gb06b66d0f2c4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.19-97-gb06b66d0f2c4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.19-97-gb06b66d0f2c4/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.19-97-gb06b66d0f2c4
Git Commit: b06b66d0f2c4879cebdf5de3d93f4245d1470a70
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 15 SoC families, 10 builds out of 133

Offline Platforms:

arm:

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

---
For more info write to <info@kernelci.org>
