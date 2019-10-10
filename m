Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D15BD2B7B
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 15:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387525AbfJJNgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 09:36:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35832 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbfJJNgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 09:36:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id v8so7953079wrt.2
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 06:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VyfWGEOeCQAdLrUxN9PTKnVR2g5+cr08VH7QenTXKRc=;
        b=Ej78yKqY3jkGUaZ+viFZbZ9aWdlPAxdK3Ui+JBTpVno/tkUWHYB15whtVgbTyDnFA8
         jAb7OmnUYBiXF+GgoCtMIfodGUb/DUX28yI+Ao8klhRx3szlf33Ph6HDtB2nGxnQ3RkO
         i12JGilJCy01kE3LueyyrKe8rpwdqng8g8U/qXFCvaWk3rMDr0CdCKscF754GU6g74EF
         cHonMtdZnkZLFmHKdwqUNpK53IkR4VGiHfVyP06xi2CSEEHx2ydGcbO778EIac9YssOV
         9HY7PXFrVdgkxamtQKTrFRD8o0eeL7V2qrv5aripIfQrbzkLL8CwXofDg90XRa7/R72C
         MAVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VyfWGEOeCQAdLrUxN9PTKnVR2g5+cr08VH7QenTXKRc=;
        b=uJETPS+peve+tzPAMdj5Kc29D972+oHPt8kKKgmFp+sBXEwcQk4T59ZRSRnLClMCI1
         YFv0lT0YhuSDKnVD8b54m1ppBCcOmmpXj89I7+GWdNLIVf5BCKuFtpw3CEPGzHZQk1nK
         uzBeEEwB9HM0dZVn76PWJ/SGKeuHMl1l9VbwutASpzb2erOV9FLUosBUhwyJ+c6MSU2p
         yF+nviLb32g212pI60tMQnXzjhx3x6RfdtE14Ano8icMni0Ut1uO8OMTHT3UpANO7JqZ
         9ctKaMdJlm6Oe9aIzmZ67opreXNmxv3Spitct086NhD81omIYtWCp2C2y+UqgyaemPM6
         c3dA==
X-Gm-Message-State: APjAAAV9HvmOZvr5xIiXhTfUnAOU6v5z/m1bdui4AK6x6uRXNyl9A3pZ
        RJ+9nTFk0HUVKOJnedIcj+mlr30O1WBR3g==
X-Google-Smtp-Source: APXvYqzOfybWHqX65suC13LLhtqfSGPpd90C6RUNo8egYXWvIknhDf4WFVnNmNNPBeDHdV+L6QNhbw==
X-Received: by 2002:a5d:6447:: with SMTP id d7mr8722868wrw.247.1570714595701;
        Thu, 10 Oct 2019 06:36:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r20sm7722478wrg.61.2019.10.10.06.36.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 06:36:35 -0700 (PDT)
Message-ID: <5d9f33e3.1c69fb81.8c71.60ce@mx.google.com>
Date:   Thu, 10 Oct 2019 06:36:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.196-38-g78f8600d5168
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 46 boots: 0 failed,
 41 passed with 5 offline (v4.9.196-38-g78f8600d5168)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 46 boots: 0 failed, 41 passed with 5 offline (v=
4.9.196-38-g78f8600d5168)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.196-38-g78f8600d5168/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.196-38-g78f8600d5168/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.196-38-g78f8600d5168
Git Commit: 78f8600d5168e90b240788cd2d5c3b46a4724f17
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 11 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
