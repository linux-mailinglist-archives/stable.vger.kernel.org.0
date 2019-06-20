Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 468F44DD6F
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 00:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfFTWbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 18:31:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35909 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfFTWbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 18:31:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so3400474wrs.3
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 15:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=ag++18MM2w6/vpUxW7CWe051RRwuKEh5Ljl74q3jfpQ=;
        b=HtNTWqIJphhFeUQQi3Emsd6LPEQOuib+6khoegibX7KpfSay+CJd5ZqF6U9wWBeOp1
         zoh6NzWSbMjv6dkR7O5USCNougO3CdKkhlVicm2h+UOocGQ427EkJZARCIzlB05fTmF8
         IK5NRx21W1K+lXyfmjmKsU3fq1F/a4KOemnV2Lf9Rvo6ovrpEx14mFtkaI/NviiP5seS
         Jy3CukNOf+Bbf8OoI5pot5CE/loOs03PqodhyuiiDUr3emRMLOrIoiyvQtzMkyvVgtTZ
         5iyiDHHVtsKF2fyXC1oXWteV3DTC4QjwNGvU3Aa2XU5BW/PisEFpytJo1kSYVyHqAlz3
         wxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=ag++18MM2w6/vpUxW7CWe051RRwuKEh5Ljl74q3jfpQ=;
        b=YlCKEE2tK5/me6vcZZitEEYYzNg+ZZ3KT+hjRmUMLHTYlCTefl+yTUirngeduaBs1P
         WU5kXR9PAfG5qj7XlaKUC9sFCOS/0uXXguOXpvlWRBp0iWq8LmCk+oRXaFlzPamcJxST
         ZB14K+i2G1ZVYs9zffATrYLbyUNXh86rcbqfS+ylT6FnQpMTXgTrlVKnNSkJC7c1zmsB
         wmrL+GglTD6Eq0cFtz7ID73J9QHuuWcPJ1lqqwdnrpIEY1DfWONF3bU5vwjJjD9fokvg
         TRDJwbj/qAYJLxT3nifnx5Ryp2u9PgT9YxHkJPyDPHu9rtpYVJIZtmd6uBPUIj3ZPLJm
         YucQ==
X-Gm-Message-State: APjAAAVxlAhdB61fkgjY6Ej63iDpODg9/gCf2xy/+9TgfrfQ8Os9MsEn
        4umf6dlW0WPBdvEvcs9sQJqkFg==
X-Google-Smtp-Source: APXvYqxqbksWbOfkcceNTbehNzpG1EulO4+XmFJK26ZA5dzb/mRqnbBlGbldi4yoANI2Sn8DYl1azg==
X-Received: by 2002:adf:f60b:: with SMTP id t11mr8330788wrp.332.1561069863472;
        Thu, 20 Jun 2019 15:31:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r4sm913798wra.96.2019.06.20.15.31.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 15:31:02 -0700 (PDT)
Message-ID: <5d0c0926.1c69fb81.14f3.58b8@mx.google.com>
Date:   Thu, 20 Jun 2019 15:31:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.182-118-gb2977e94f62a
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
Subject: Re: [PATCH 4.9 000/117] 4.9.183-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 102 boots: 1 failed, 99 passed with 2 offline (=
v4.9.182-118-gb2977e94f62a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.182-118-gb2977e94f62a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.182-118-gb2977e94f62a/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.182-118-gb2977e94f62a
Git Commit: b2977e94f62a4008b6cc418f3af3c1a04ddb8ce3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 23 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.182)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
