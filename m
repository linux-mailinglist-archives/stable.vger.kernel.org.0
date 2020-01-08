Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7100133B6F
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 06:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgAHFw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 00:52:56 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50212 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgAHFw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 00:52:56 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so1161862wmb.0
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 21:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QhMzc+jC2qtlnWC3Cv6VjsJhu7Y1AxTeoyJrt2HDVfU=;
        b=IWfAxkoLpNbZmjs+4vrDBTWv5ofL62/sjzbuYoPuKG7xZPSAOP9g0pzy2aE1p+L0UR
         UulmagUZYohPBI18IDzsPg5r1a1u1iNkYPbbiWqnd82uopXQYb3YIRG0trjPS4M2zPfH
         BDNiffmT75SGBjtIgOKF/AZaq9cvmu20LoD/Cy7qio9A9Zh7ewhBLjxAbVomWr+tu52y
         RZyWH7G75sMY11xK8GuI8w83kBdxUn3nnPM65UWBxPiS65mUlo+bWGIigtRit/3RrX3Z
         IQHnNeZ5IEQp+pATBiB2svDt7oP/Yawtk3WUMmh4OjLvK3MQeoxoX297FSQbJTXePbu0
         Q4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QhMzc+jC2qtlnWC3Cv6VjsJhu7Y1AxTeoyJrt2HDVfU=;
        b=GvkTaTIrZCI3Sj5tHIvZ33YvwW+0BwbN30mszPzjCamNwt2XJwNm2M2zCpvz2zel8k
         z6l+5PXa9lJPCh77a/ef4g9mIqYfAnWxPCBVmgzCctrwFgVTNmxR14qQXoehVgUQWJ1V
         q/MeXy1LvCAyC9l9Af2Hr3CZ7rw7l9Z9bskVB1zx5dpP4jAujb4siVii9pwuC9tMgESI
         72e1m/sc3NaK0tNVU0+P+ykutbFHg8YVzTbyq1acx/yuLkUf3WzgyTX9BX2RU4c84OjN
         eTGND3dqXLwGaFvP4nxt7AA5Stn+yBb8svjI/g4Wc1WVFDn9GXBiqMUdDrCxCiF+1xli
         ijXg==
X-Gm-Message-State: APjAAAWeKAsxo6Tn9kLgRovC0QLgNuyPctjKsudKxa5QjvuDVJ1p7zbH
        KbJUOd+Cm7qHlnwUThx8v2kUsaVAsu9TSg==
X-Google-Smtp-Source: APXvYqz8S+JNVR81eJ0xwuVQEouH8EL54KpS3QlEObAAIxb4rcjEsO7XZ+nOgoKJRUmypGVqTulVTg==
X-Received: by 2002:a7b:c3d7:: with SMTP id t23mr1706473wmj.33.1578462773152;
        Tue, 07 Jan 2020 21:52:53 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 5sm2968143wrh.5.2020.01.07.21.52.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 21:52:52 -0800 (PST)
Message-ID: <5e156e34.1c69fb81.aab7f.d442@mx.google.com>
Date:   Tue, 07 Jan 2020 21:52:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207-228-g70893fe7c2df
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 56 boots: 0 failed,
 55 passed with 1 untried/unknown (v4.9.207-228-g70893fe7c2df)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 56 boots: 0 failed, 55 passed with 1 untried/un=
known (v4.9.207-228-g70893fe7c2df)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.207-228-g70893fe7c2df/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207-228-g70893fe7c2df/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207-228-g70893fe7c2df
Git Commit: 70893fe7c2df755d3c19e94c41e339f85f9276ed
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 31 unique boards, 12 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
