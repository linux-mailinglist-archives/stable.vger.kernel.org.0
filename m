Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB0DCD93B
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 22:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfJFUqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 16:46:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35186 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfJFUqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 16:46:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id v8so12863776wrt.2
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 13:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bJzb06C+f8FG/g4VzDhge8ezS0zpLD2R/+ZX67qbM5g=;
        b=fxg52evHKWxsP6rUt5UTCbaWMOeqlZQCyQU2fYfPhdSnI8UmSh8y7XATxohKDeRbw7
         z9T6rN0Y5St+VLFcGFJz2sEkB+mwbB6lvWqSdGpdT5/9HETXVl5vQfoec3wCtMoRsO5/
         Vt8LWDdzC2yQYLwrglbOQ//wHYuAzcIQyOOWHwiLp2hEvOZnYERyKjH2wDLIHGZAQxj9
         g56Dn3tKuRaZgsY5cM6ksQq8E7Pz4kxfpjWyQSnPSQjFFlxUTpEMkv4fK67xWlHS+BF8
         JSNulXwF8TFfukZ9V/GlwNRttOUIKPZK0RYJ15ZCtTL+f7C4pTdDA5sdZxBf3zbAFYo1
         bPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bJzb06C+f8FG/g4VzDhge8ezS0zpLD2R/+ZX67qbM5g=;
        b=D+k5OQANw5zNcvkGgMbxnb98a+5P+7GHnpmXy3h5viyG5ywJz8BQs/hU6lmqARhQqg
         AeSa9bfrbZPGnhpRx1GW1jjBEIW/+au/iJWV0AlPeqg4cJVZ8Xc5pcH8G2NVDl6FQhGx
         XRPqBxna1+vOXldA/9eeZ47DRpsofaVFgb5VC0tr0dBAm4pQSjisY5XXaPVSneUWnB/5
         +mYtsaQFIwzBa1aLkzhI0Dq2CzKOz1zOjYDSWZWOR3C+3Jfe3kFNU+mdwjgHvT9SQoRs
         J0GqO142oJiQMVwfoz1bDans73Um96A/oKyGy/YTamF5aojkL3LDdTv6YG8iZoB5ihbU
         /s+A==
X-Gm-Message-State: APjAAAXUblktDa5Zn4qmkZe8IaPIr80e3BmRdnVqnyvgDO/K2nr1Q+uq
        VqwYhh9Z4DZI4ETzdjpYr3IvQjqJkkU=
X-Google-Smtp-Source: APXvYqwwYVedrAR/nU4RbKXPiRhB9amrv8vJnj4L7N7OBSsUXETHhUFnSUMgulbbhGoNfh8Rc+puww==
X-Received: by 2002:adf:fbc7:: with SMTP id d7mr3001963wrs.171.1570394790859;
        Sun, 06 Oct 2019 13:46:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b7sm10757247wrx.56.2019.10.06.13.46.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 13:46:30 -0700 (PDT)
Message-ID: <5d9a52a6.1c69fb81.d744f.f6fd@mx.google.com>
Date:   Sun, 06 Oct 2019 13:46:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.4-162-gde3c43ffab53
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 62 boots: 0 failed,
 62 passed (v5.3.4-162-gde3c43ffab53)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 62 boots: 0 failed, 62 passed (v5.3.4-162-gde3c=
43ffab53)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.4-162-gde3c43ffab53/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.4-162-gde3c43ffab53/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.4-162-gde3c43ffab53
Git Commit: de3c43ffab538a8469110a56af71eb7aafe789fb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 17 SoC families, 12 builds out of 208

---
For more info write to <info@kernelci.org>
