Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78E7ABAAB
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 16:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388441AbfIFOSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 10:18:11 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:45762 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394395AbfIFOSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 10:18:11 -0400
Received: by mail-wr1-f44.google.com with SMTP id l16so6730693wrv.12
        for <stable@vger.kernel.org>; Fri, 06 Sep 2019 07:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dB2A4TUUWSyB5MXXKh0d/0fejbGEueSFnXQMDl2OdVM=;
        b=GB5AXfE6VlloxFq/YsFYIX/0Z5lFfKseyJe1PKgquU6NGvKuVE43XrksT6MsXmoljN
         ZnBZp0JSCYkQZlWALl+2xawfW0TRzmu3yqn5Fj9FTU5wNS/eq068LtmUgfGBALP1hNNr
         KYMBLZJEtPHYyUfZEeO8u0tP3hBKH/bkjALtZI3hFoQe4mJDhgyNiS039CIt5+L7ZPsS
         WZWOcugzhdld58DsNJI2WfmX50Rn/O4JTp4ZJB4/+ZhjqUvEd7qaQK8WbJi3EhAOxWWL
         tkDkGEBUJU8/K3WyNa5Go4Iv1ltWoBUq0KsBZbJ2ZeY906PAu7q6yEoTO1GE2PO6L78w
         jTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dB2A4TUUWSyB5MXXKh0d/0fejbGEueSFnXQMDl2OdVM=;
        b=kIMi9we0QroTeCZH3wSqwvDVSOzIUyr42lYsBNv5P2a+tQt2q5+6Eb2zC8k/Ye3SqF
         VWnftvMa+8eNohE69ziPMKRsElUqeElA/glLCUWz8+lauGgOI07GgS8CVQlZfBE9TnV8
         erUOWkAh7Iiq4I04VPQLle+XvVJFkZptAbDPKRcxEgJii9IxVxR8cqtQYLiD5OcfuO/b
         FDzKDH00VVUtEC0PyjjAG8vZdwlJflojfv2vjV+jwPWISjzfSpn301Tr5Um6GMIRCyUh
         tB2vzeGKzJUxwqJjVwnzLJq2ADCfJXZV3jdzY8fxrX5MiQHv0Bjz7hDubz9dOqGfHxdI
         5wng==
X-Gm-Message-State: APjAAAXGSh/mXR+sMEV5F7nA0v5tDjV8QSDB6qJY04HDedfvHSuS75ZD
        d2TD3m0rK3Us6qLZFoJmSGX8Bo8ZK9J0rg==
X-Google-Smtp-Source: APXvYqxSkLQmXfig63j+m+S+XvCsNXFNplzZG5bCVYLSh/48nMuGNm/T3my2W0bPhw9tmvsQlXednQ==
X-Received: by 2002:adf:e605:: with SMTP id p5mr7244033wrm.105.1567779489091;
        Fri, 06 Sep 2019 07:18:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x6sm9631489wmf.38.2019.09.06.07.18.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 07:18:08 -0700 (PDT)
Message-ID: <5d726aa0.1c69fb81.7b900.e8ca@mx.google.com>
Date:   Fri, 06 Sep 2019 07:18:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.191
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 74 boots: 6 failed, 68 passed (v4.4.191)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 74 boots: 6 failed, 68 passed (v4.4.191)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.191/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.191/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.191
Git Commit: efbc4a364bd5469a616668127439e7cfca4c1d7b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 24 unique boards, 10 SoC families, 9 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 5 failed labs

---
For more info write to <info@kernelci.org>
