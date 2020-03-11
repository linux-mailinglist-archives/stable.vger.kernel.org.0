Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C07E182337
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 21:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731241AbgCKUSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 16:18:53 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33071 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731057AbgCKUSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 16:18:53 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay11so1618966plb.0
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 13:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nUNe3VWfKrUo76+6/iH8V3AUPMJ8HMDlw60y5VpHG4I=;
        b=vTW2AXtFEt52j4GgqOtJM6ovyZHj2Womt63AzQomrOKmcs4ja0NB0KRFJO5NjGQ9gu
         vmek23rHB0X1GCXnAX+hjPDPrZYyXlAbJaxQ60SzoN6OnsgsqGNlWbaqwEtpzyzoWSpx
         zukTYfKaHx/Gjj8UZalfSefyljSLirMs5mCzSZGJ14wBj9vUo4+2b6PCK2Vcgr9IRSeF
         2xkFuUX4tgVLf6Aywn61l2bCEH7OD7uS6O+OB5VCm3dexyKdV2chUMg3Xa0agpCwvs+H
         7S6VsgDjLA1SHQ4aLo2IjMdJaFRtm9ldVyO/0eVslrvhG0Lue8QshcZpU9qpzMGDZfuG
         uiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nUNe3VWfKrUo76+6/iH8V3AUPMJ8HMDlw60y5VpHG4I=;
        b=W0gARkk8585sKOJYY9TAu32I2wIbA50b5QawJ3QDyXocO2r8e9JJXntPPLp3a9AH6j
         olGW7dy8cEJa67klOqVwr1wrM59HmHBq+aDLiCh3iHcKYNXrq8yJVKHVyi2ylXZPrzzA
         E6FqasqZp/gEjBmpWX9vzIy68UBGOOYuQe+mdcLEaoNSTYJoTnqwQCHnnS1zTntmK5q7
         nZhxZswwJ2TFipurqDrSEnqQ2UvMgn6f2LI6GY49VVQw7LhfnYoUg4cjIzHgwmCnUKfs
         Q/VaA4bqSXSqXENG8D9jEzEuySxNTtKcFBMWEsqjJPCpeSSO69roTomiwTNBD/yHtVZf
         xlzw==
X-Gm-Message-State: ANhLgQ3MX3CuPOx/BLe/D33mrydga3On0/UCIug34kQnsJnsqAk+E9l8
        b+mK9W8QZYwrG/6th+Th4HcBYawHcDU=
X-Google-Smtp-Source: ADFU+vvfm/eSYkzDCVu3rRr4UliLUf49jXTb++JwZnE1Iu8xT+xoFS1GoMikVufXsVbmGA7TULeKYA==
X-Received: by 2002:a17:902:346:: with SMTP id 64mr4470409pld.226.1583957931688;
        Wed, 11 Mar 2020 13:18:51 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id dw19sm6354778pjb.16.2020.03.11.13.18.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 13:18:51 -0700 (PDT)
Message-ID: <5e6947ab.1c69fb81.a19a5.452e@mx.google.com>
Date:   Wed, 11 Mar 2020 13:18:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.109
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 58 boots: 1 failed,
 56 passed with 1 untried/unknown (v4.19.109)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 58 boots: 1 failed, 56 passed with 1 untried/unkn=
own (v4.19.109)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.109/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.109/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.109
Git Commit: 5692097116094a4a7045abcc1dbc172dbdc5657e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 46 unique boards, 16 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.108)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
