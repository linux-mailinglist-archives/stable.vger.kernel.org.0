Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946C4C327D
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 13:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfJALao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 07:30:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45409 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfJALao (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 07:30:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so15005060wrm.12
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 04:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MUU/1m5I5lEPteHDny9On722tmN+uwvwqTWhcZBdumg=;
        b=0yl3ZK8YQJ4V7RMY7U3556M3UKFd5n4fQkCy3LWz8api9RMf6Ce5yq6Ee1TLwWKKF8
         0MfQU0JAGojmgLmjgkMLkxZISoRjRokoxbn91e6I5RQXUW7Odzc+KZIKCUbPJ77xAFJL
         sA+xVxC+nF1Pfi0c7i1JqdB+vumUBqyWqw3C4v5h/RNycgV3QS8aLdTmEdPu4FZbf89g
         2TgJ9AbSMl/M1frs/61HPUlD7/Zifq9hkGJccvkK5eleweXkd8pbHIJt8a1S95OtxREz
         1YOZe4K1NXypN5h9He6dlgRt/2LDyDi5gZXCpdxXy99y4IFIwT5lIYHwi+YlhBpkK50o
         JT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MUU/1m5I5lEPteHDny9On722tmN+uwvwqTWhcZBdumg=;
        b=YWXl//+aWY9js8QAPOQUZc2t07/BSP3xZWJb/s4BB8KAV8mIriw9ZC8W4tyVLJwZUa
         Vq7WRSqKJvfK1BBsMKmVdcsaCiCUXOhi01P2zI/0YQ4cuYg2sam10A584DkokPBBl1KR
         PSkOZ0q799F9tIYDCFfmxoUEpxgxEDmoiDk9/3uc1f0Xf/iHZtCP3HaAg5hrdAAunWv4
         8aqLbOqDqKzdaCR9SvaPnFAibizHtLJJp3kiKfQlllu+IOv8sj6oojn6lsLl9dahtHrz
         +xr1/g46/+/Mw1YTfDvx0jdiaIqalWikvFBIKlG1DvHLiLhoVmqLse5MkaMroCYgBQ5W
         /vxA==
X-Gm-Message-State: APjAAAV+a0lfoQEnryyo0VCOD6vc7/rXJkqPMcAndeD6nedLm54UF0rq
        KJtr/o16h4p5mxhR484yMNU/EFmdw+GCAQ==
X-Google-Smtp-Source: APXvYqyTJZimlkH0rWqB6+nlXy8EJkUZ1ZMqshRh5bGDiSLZq0iEugZ8QReTf4YFTj5kAzLkqWImzg==
X-Received: by 2002:adf:fa10:: with SMTP id m16mr17062036wrr.322.1569929442090;
        Tue, 01 Oct 2019 04:30:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a6sm14976001wrr.85.2019.10.01.04.30.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 04:30:41 -0700 (PDT)
Message-ID: <5d9338e1.1c69fb81.e2e71.42c7@mx.google.com>
Date:   Tue, 01 Oct 2019 04:30:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.76
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 84 boots: 1 failed, 83 passed (v4.19.76)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 84 boots: 1 failed, 83 passed (v4.19.76)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.76/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.76/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.76
Git Commit: 555161ee1b7a74e77ca70fd14ed8a5137c8108ac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 47 unique boards, 17 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-cubieboard2:
              lab-baylibre: new failure (last pass: v4.19.75)

Boot Failure Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-cubieboard2: 1 failed lab

---
For more info write to <info@kernelci.org>
