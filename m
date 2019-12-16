Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 556B2121BE5
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 22:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfLPVhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 16:37:47 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46116 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfLPVhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 16:37:46 -0500
Received: by mail-wr1-f68.google.com with SMTP id z7so9019202wrl.13
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 13:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TMXtcPtV0yAprIXnAcrExsmwTUh0CQuQ3631vlQT3eA=;
        b=xWJWHaoLPCi92V6IbefZcUpR8dz0EXCdH5JJnlKDsYlQb16iMq65zCVWWAt3C8Q1Sk
         hNqu0DBW1odSPQ7gKSudn5Qr9BB3Rpy/Qo2A7gJI2eFm8ekW9rJmVwhWyiUnBi0haVI8
         O+LQyfRrlNb8hGQe+NWXUMvNg3YqnAEwGnkC4aVZL8mH4n5MD+rmdidZ6gZ6HFCCtz12
         J0Pxy8KAJAQ4vHrX4dCv4aTwMhuFEYx2fGJzmKDtZYCYircSuxRU6tXCf6nzzjtqc2/b
         TdWb0vlHbJeXoB213X4qRty0wazUEN7YB7EAK40/CPcN5HgEny6FSAtiLlP3nPgmHZDo
         ZJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TMXtcPtV0yAprIXnAcrExsmwTUh0CQuQ3631vlQT3eA=;
        b=OqZL2Nk2Nw4sZvsyqCWoZbxnKkQA51UYKlbzyNavUb0lQMedinXEW2oncN6lQOOn+z
         gYijbBvyQPA4GCWj8+9O9UqIxhPJaaWsawvOkxknGY6Jzj7YryljbsIrkG9JGB3WHWcj
         uJUG6JwjOa4xHmHcOZqffCxWmMgeOFIfAyW0IHJYcT8d7zYllcVegDzN/WZFvS0IK4nS
         gATxWXLqABw9NWpg1SiprBv9MeNFkH9sq31O2AZe5qUj4a4JbPdIwIp2/yNBN8xc66s5
         ip4tI+XpgzTREXNRsdIq8CTmuliERJNxLFLQUNwuzeQChrgboEulmywZHIH1/r81pusm
         4CeA==
X-Gm-Message-State: APjAAAX5ZjMeLy+DA0OrN8CHPPEpxxKAqFqbMKUWMU3k6qMkiY9w6SXI
        7ZCl01dvzvnYWh0lFl07afzU+1kazPo=
X-Google-Smtp-Source: APXvYqxk0bc94Kl0JJU7WSvzBlVdX/w7/kkh/TB6y9pmHgJlYnEDlLUY7GfRfMCu1/YQKHbKdrd5Uw==
X-Received: by 2002:a5d:5044:: with SMTP id h4mr31735175wrt.4.1576532264679;
        Mon, 16 Dec 2019 13:37:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 60sm23363850wrn.86.2019.12.16.13.37.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 13:37:44 -0800 (PST)
Message-ID: <5df7f928.1c69fb81.ab643.9823@mx.google.com>
Date:   Mon, 16 Dec 2019 13:37:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206-139-gaef552ef4557
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 43 boots: 1 failed,
 41 passed with 1 untried/unknown (v4.4.206-139-gaef552ef4557)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 43 boots: 1 failed, 41 passed with 1 untried/un=
known (v4.4.206-139-gaef552ef4557)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.206-139-gaef552ef4557/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.206-139-gaef552ef4557/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.206-139-gaef552ef4557
Git Commit: aef552ef45579de7a98d2c64d92c260c1ce9ad20
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 26 unique boards, 11 SoC families, 10 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.4.190-34-g13e40d47f2=
9c)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
