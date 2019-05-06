Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F5A14984
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 14:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbfEFMZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 08:25:51 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:34210 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfEFMZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 08:25:51 -0400
Received: by mail-wm1-f42.google.com with SMTP id m20so5340349wmg.1
        for <stable@vger.kernel.org>; Mon, 06 May 2019 05:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7AJCMX9g0HExhNMTLILYdsvczoVxjrS66v3cm5IGwjI=;
        b=olvgSN7p7ezkFd2E4U2rBhHTUrAKDjdxunxX9HhQiId0h8Gs/ENxF3C2Xi//krksNH
         7ZhpRgMRa8actbsinkyWjREFxY6yS/za/aa5nc+96TngGRdPcuJUIILz9AU+fs49Pmuw
         voMyYeLnKk23phVSqC6d3GcPVA7+91AevrV86ujB0EeWFDKRPviwKrAP6XKg0hJR8KAY
         aB2OjzV8rwCe5Aq7yX5tsDIdeMZwKXWhWPIqZRIZyiyT/sCKP1fp2bkUrmsUJ1M9sJr1
         iLMjWe1aXnJTAY7JB9Um0GyX3+rKQc/nNi7iselGMU9ecF6ATsrumjS1evAW8T09NEIa
         +t0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7AJCMX9g0HExhNMTLILYdsvczoVxjrS66v3cm5IGwjI=;
        b=FLrk1UfVcDu2JR8CK1r07pZU5I91NgF+iXLYbjf39D+HzN8zwYdRf3QVIY+v15mOJN
         C1Y2iy0FRBuNXl2nBWBi4kfFrYNH24g45x8ZRXvDZEV1qixUAqPmbl3yxf5Edv8FIXaR
         njBw3IYLHF8bZeIuwjl+AMP3DZgf4OAoLQ358wv+Zq8WQlSq+699SM0J6+0YOJqF5Hq5
         3FuEHoeBp1DdQJcLg+rDrcbFCzmZW8YaGWUK8ZkNd1e4TScCJsINlqokkGAoSIOa4C9d
         yEaCE6TUyzBL3cCIQalFOGDdXwof68tNMm4hq9sCG8Fe8I51P1WRHLIrerVLGGorh5Vt
         tpFg==
X-Gm-Message-State: APjAAAX+T1rwGwh4M2U8CRYuN+5z0q73/G3ws87IfMIERCIQ5RnV+ylz
        LOKtlknlzIhl+1FmvEN1xxfsR9TkS709PQ==
X-Google-Smtp-Source: APXvYqziuna/+0pApzDEcIGyHT6r96GQ3nASZkRDxY+YksjJB2hvqPM2p4JAav6ygkYizno8dFhtAA==
X-Received: by 2002:a1c:a914:: with SMTP id s20mr16732161wme.55.1557145548962;
        Mon, 06 May 2019 05:25:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s124sm16045414wmf.42.2019.05.06.05.25.48
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 05:25:48 -0700 (PDT)
Message-ID: <5cd027cc.1c69fb81.fb56c.61b2@mx.google.com>
Date:   Mon, 06 May 2019 05:25:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v3.18.139-48-g512b47264128
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-3.18.y boot: 53 boots: 1 failed,
 52 passed (v3.18.139-48-g512b47264128)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.18.y boot: 53 boots: 1 failed, 52 passed (v3.18.139-48-g5=
12b47264128)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.18.y/kernel/v3.18.139-48-g512b47264128/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.18.=
y/kernel/v3.18.139-48-g512b47264128/

Tree: stable-rc
Branch: linux-3.18.y
Git Describe: v3.18.139-48-g512b47264128
Git Commit: 512b472641289b457482279f90895d5687743cd8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 12 SoC families, 13 builds out of 189

Boot Failure Detected:

x86_64:
    x86_64_defconfig:
        gcc-7:
            minnowboard-turbot-E3826: 1 failed lab

---
For more info write to <info@kernelci.org>
