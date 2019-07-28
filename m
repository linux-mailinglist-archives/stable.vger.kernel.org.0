Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4FCE77F51
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 13:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfG1LzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 07:55:23 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:43744 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfG1LzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jul 2019 07:55:22 -0400
Received: by mail-wr1-f53.google.com with SMTP id p13so58797867wru.10
        for <stable@vger.kernel.org>; Sun, 28 Jul 2019 04:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K2uP6RqdIUWDPrcF/GYO8B1QPgAQ+1g9zeJ4qUwFpO4=;
        b=IjrI/MzutY5lB6YUzo6TQZMuGBcrNK7k1diDkoyECZALdR/TsJm4Ikxq92gIbZTXYV
         jP/7Hdc5/WgzDd8q6+WGdr+rtofOl4LCz0uhr8qfIv1pcItYrvW6SakCYZnZHCx8Ei/k
         pdkFx2U67p9XiMr/fIDLemhU6P1ltuI4Mb91bSeeJLCgKr8Kb80dQ/j7TRiiFSVYbx1A
         b2pAkH7kl1eT7Urh+RfVIR2CZnenp+UrlvEIDFy4Svxw5jD5LkXAH6E28MF9/aXozvEO
         Z1nt7q1h6z3NNTs90VmzB21q0Q0U3ZMiY+YJFDY+EKvQRHvClT3DRRns99GOzlzdHsb1
         nKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K2uP6RqdIUWDPrcF/GYO8B1QPgAQ+1g9zeJ4qUwFpO4=;
        b=gclEE8jDZtCz1EXdSfuNCC9z2TR/3gWPnLOlhSuqXiD2aHKxghbfWmHyof7EL225r4
         QAqXiacCelEasYRe5///XlPh8WDuHr7GzsPEix7ZOY511ChAPnhAten7awtW2wiOHM/x
         yOE5nf7b7LxnhpEM01adbODxcUnUuTgSpUqzJMO62shLVoqpNBNs2p7Nelp7oGgeK82o
         PNCwogM6exa3sI/UoDUCmmQMLtqcEg23su+QrjuQXvKXHiT+hmKiKzRJM6zyPwQ1wd++
         od2WSe8gXtwwqxzqnN6Rnipj2eKmjRRFIbRcGEvkQF60phhEMWQJDUgyf3Tir6q6nHIG
         +e7w==
X-Gm-Message-State: APjAAAVOQ7vnTE7q2UQRBJdHGztqFGszRdIXFnTg4fRbYj+KZUk/Dy5P
        l2iUy+527BrPWo9BkCnr0UQY4ynF
X-Google-Smtp-Source: APXvYqxnx1YImSkECuybmETqkM76h/ITMhH5YE4GPax7aMH1TgI0jdSo4aQGe7wc4FKkKPU3KZhuXQ==
X-Received: by 2002:adf:9ece:: with SMTP id b14mr64876652wrf.192.1564314920401;
        Sun, 28 Jul 2019 04:55:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y12sm38622423wru.30.2019.07.28.04.55.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 04:55:19 -0700 (PDT)
Message-ID: <5d3d8d27.1c69fb81.629f0.4c48@mx.google.com>
Date:   Sun, 28 Jul 2019 04:55:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.2.4
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.2.y boot: 35 boots: 0 failed, 35 passed (v5.2.4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 35 boots: 0 failed, 35 passed (v5.2.4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.4/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.4/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.4
Git Commit: fc89179bfa10dd243fce24af71cf622267f31f2f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 19 unique boards, 12 SoC families, 7 builds out of 209

---
For more info write to <info@kernelci.org>
