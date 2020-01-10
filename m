Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211A7137857
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 22:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgAJVMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 16:12:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33935 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgAJVMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 16:12:25 -0500
Received: by mail-wr1-f67.google.com with SMTP id t2so3132382wrr.1
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 13:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rxCqT6gvrvJoiXdA6marh8/xysFvKU7/qmNekPAeEiY=;
        b=BPhZiUFMmDt0VbMyfH5Aczr/bWAnkJVQqU75VadW1tIIuMWlFz7tVTjYlvxUfOTCgq
         hvT5C+gYyAiHB4tjiicZVCFFv1Tp1A6XR9WRF9gWOa6/tqk6T1bP+ESwNYSMNFLjeAEo
         wU53mt7B7IjS+TSshUJfnxLfz/RgVbi8N2N8IgBS7NxP2EoMkB9++MHbaN33XTcj3dVg
         395ltOAiQuu08DB+QmQlDmYbvAsVhJcybpXJAng3r9YmwpQXf++AnYKD3h4PDdWpTDbZ
         MivzjgZwkaW02ccxrkdW3uMf41c46VPlirQ3FGnlZ0aD9uAn+PKXrBjlM/mI86//yNR1
         JzdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rxCqT6gvrvJoiXdA6marh8/xysFvKU7/qmNekPAeEiY=;
        b=CITsshVgP7G4srRcntP+V/UtHSJDqVNtq/2fkMtSO4DeqFUTPBw66kPe+7qKmbiLeo
         J8lym0pZQGDC9GOJEFrm3d0LITNO7QLNt+pYPdzWp6UQhvd2BUQ+6QZjwxLYBheY2Lk8
         q5AJUAB/TW1FZ0ySy4nb/+OPF6W0hH16mUjIYi5GE6XSD6MDYHTbT+OeyMvG1ofcPckS
         Dheu4vYgIvfQnzPybH+wdhLryRY+kDo9x1J+h1wkeGPM9laGvYLNmHtrXYxcYfz8+23A
         sJiozP7pQpB5nIbIqo6dYQ6IkwA5WmjMSwV/1RPMH6razMynckk60XaRM8GJ5XmTB7Dr
         Ts1Q==
X-Gm-Message-State: APjAAAUuQOkrf75jJNvw5BCrG76mvcE9dzeUePh+schwJ7yuL/BvZZgV
        +tMTzZjYAJW1PumSABYK8uHQCHRmK8cDtg==
X-Google-Smtp-Source: APXvYqz3g3y7llxrqbPfLqVTGQ2EzdKA06VzJDJyzK0it8gzqapEAMshE19PGCf9nFfBE0GAb3+w1Q==
X-Received: by 2002:adf:e2cf:: with SMTP id d15mr5329828wrj.225.1578690743251;
        Fri, 10 Jan 2020 13:12:23 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s8sm3481111wrt.57.2020.01.10.13.12.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 13:12:22 -0800 (PST)
Message-ID: <5e18e8b6.1c69fb81.38c15.0e0b@mx.google.com>
Date:   Fri, 10 Jan 2020 13:12:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.94-65-ga9b05c4e2c9e
Subject: stable-rc/linux-4.19.y boot: 81 boots: 1 failed,
 75 passed with 5 untried/unknown (v4.19.94-65-ga9b05c4e2c9e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 81 boots: 1 failed, 75 passed with 5 untried/u=
nknown (v4.19.94-65-ga9b05c4e2c9e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.94-65-ga9b05c4e2c9e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.94-65-ga9b05c4e2c9e/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.94-65-ga9b05c4e2c9e
Git Commit: a9b05c4e2c9e96954ae9bafea58eb23cff45fd9a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 17 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.19.94-64-gc6052d0e86=
3f)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre: new failure (last pass: v4.19.94-64-gc6052d0e86=
3f)
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.19.94-64-gc6052d0e86=
3f)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.94-64-gc6052d0e86=
3f)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            alpine-db: 1 failed lab

---
For more info write to <info@kernelci.org>
