Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC1C151ADB
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 13:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBDMzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 07:55:24 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38479 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbgBDMzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 07:55:24 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so22919117wrh.5
        for <stable@vger.kernel.org>; Tue, 04 Feb 2020 04:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D6sPB35fUFrFu7yHT24chUXbfcu8vnoHruOhcrnWa9E=;
        b=fyZD9mjKKJqBvR/evc25+Wt8Dcxnj03lT0D3c5zFs27NvdwGvP56Q+HVtE9QNtOGUU
         TnHRm89uep1X8s0h96QQYQN08cIYqZ4fyph/pUfghXynzoebw6z5mW1X5uAPq/Yt5Lsl
         +VRlpMeyda6UUW1P4Lp979Je4TIN2REH3PDqKTTaMiS1ip1RkZBej9NaFsxEfnhUzeLF
         LrmfJtVgjVlGOewJu6SAYxP1N27Z89UBuma9zk59wPrW/ue7YczhkeSVDCsUAKEcUlp8
         4sx+aeXmppnyzFXQZdC1P6axDLJT++zcBISlXbbeUsrE0II2iiyz1Cq77y/sNUthQM3R
         0v7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D6sPB35fUFrFu7yHT24chUXbfcu8vnoHruOhcrnWa9E=;
        b=IA5+5/Kpyo4Xhjdy4xzb6uixH93PZTJ9Duhi0L8R7199/M1jRJgMyTi7gsJPhWcabM
         wUBylKTvxOlB5mzY03nbFRiva/3lKTatvqLwuj9jhfuWc/R0RfjjMj3Ns1T1/6p/Lt6J
         hdWIwGmiRRHcVjI6cBR5kGiLj4p05LJMi/vYq160efpU1hpGVfHk4G8NrKRZAUAoEVnf
         VxqHskczFOlmn/uR5MwHXYUmVft73sx/jnAStXI7aC+gZqeY2JCZyOQofWjhO5SfFY0m
         3Ikphu4nwpXAb7D0zQO6hvQb8BTZ8JNancWzPd7TNrMAVJapEzrcxOZH4qaKjE7Vg3rY
         hurQ==
X-Gm-Message-State: APjAAAUvwGGaLFCZ1IiRyIWjXkRymXLNB1QxVJrPEhheRoXswMPoGAEM
        wPXGB8yAWam+vbhWIkDhx20OL0uURfIHHQ==
X-Google-Smtp-Source: APXvYqyoxmYltJ2ccIENLXatuzhefwNIPgG+Nw/G7J9RFLB+j9BLn5S6BgFtUixBffXZouLZ7uUB+g==
X-Received: by 2002:adf:eb8e:: with SMTP id t14mr21794599wrn.384.1580820922871;
        Tue, 04 Feb 2020 04:55:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s12sm13256691wrw.20.2020.02.04.04.55.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 04:55:22 -0800 (PST)
Message-ID: <5e3969ba.1c69fb81.9f222.89e6@mx.google.com>
Date:   Tue, 04 Feb 2020 04:55:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.17-102-ga59b851019bc
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 61 boots: 1 failed,
 59 passed with 1 untried/unknown (v5.4.17-102-ga59b851019bc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 61 boots: 1 failed, 59 passed with 1 untried/un=
known (v5.4.17-102-ga59b851019bc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.17-102-ga59b851019bc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.17-102-ga59b851019bc/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.17-102-ga59b851019bc
Git Commit: a59b851019bc15226d5c7c31ac4e0452e9a57d13
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 15 SoC families, 11 builds out of 150

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.17-102-g9028ac4fc8=
37)

arm64:

    defconfig:
        gcc-8:
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.4.17-102-g9028ac4fc8=
37)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
