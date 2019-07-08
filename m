Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C3462B35
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 23:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbfGHVrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 17:47:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38516 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732488AbfGHVrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 17:47:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so8584468wrr.5
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 14:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D8es5jaMha7jZw7u0rg62qJdEFgWDLiL5tUvAl16pAE=;
        b=2QACwKfyWa+1J1bV4oMMeLM2I/ePBD9lVBhHjlxTFnLwlBFj/ybYYnB8M7ZRMW7Iuf
         nCJ3+tI0N3JtR60MbXwU51bxnls3dVu7yNtoMlC/f/H9oYukvv/m6qJ/Eu7x14d+urX1
         cZpKuWm18ywYbMRiPkrE/4AseJk+WZNUQ2by4+szzbsURxUi4Ato7Xu5Iv5l8Drx0Vci
         lQcBntLScMKAQpJwPZo0pWJPifkiGE4LVa1S2CWkbYtIYgiVujBpfKdaD4TeorxvOuW+
         2Aik9WPIltbeObok190GiwDs0AI/SMASSTM/hHlzfuuB3tnnKXjsi8UBEuNY2RZ+gXk7
         n5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D8es5jaMha7jZw7u0rg62qJdEFgWDLiL5tUvAl16pAE=;
        b=jlSLDbY7DfCjWQQ6yKye9SY3SPWGn0AQJMOtILcEs5imnDY1vaJd+XR604TSd8fFns
         sNG42CR+aWkZQPrVAPuNoIFTCSaf1hYdXbZmJZKy6y2M5qH6PVFjXAzsB5jDfQvQy+ig
         t7cGYQ0x3uXmoX2mteZ3JBoq4clKl2p4JNaXuv1rqfHyEPlDbe2xz/QuFCEU+j8rowcd
         kQW7pT7100UkysKwwSHZBju8EIEbXpomRuGkR90iqZZSWQryE3WmVAqbbIqrlhTa4Jil
         CmsSkTUziNFFhordOGjDyYnra3la3eaPjgGPAan1Q0/UtgqgIiv7gNGMVsQuO2UFtyua
         3CXg==
X-Gm-Message-State: APjAAAUYvOvxFJ7k8/7DZUfS+uJOxg0qLtUzPTX1DP01c91Ee2H8QyNe
        O25pF7yPiqh0X0MvITLXwPCFntqwEbuEOg==
X-Google-Smtp-Source: APXvYqxvgQz4NucfbppP0f9QyJuurwLfTCgzydRDasdfDMQVs4ICRBWUnVgYa1pW7RbS8aAzJeiO9w==
X-Received: by 2002:adf:de8b:: with SMTP id w11mr20897018wrl.134.1562622466567;
        Mon, 08 Jul 2019 14:47:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d1sm9331713wrs.94.2019.07.08.14.47.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 14:47:45 -0700 (PDT)
Message-ID: <5d23ba01.1c69fb81.d5183.23f8@mx.google.com>
Date:   Mon, 08 Jul 2019 14:47:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.16-97-gb64119f8dffe
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 88 boots: 3 failed,
 84 passed with 1 untried/unknown (v5.1.16-97-gb64119f8dffe)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 88 boots: 3 failed, 84 passed with 1 untried/un=
known (v5.1.16-97-gb64119f8dffe)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.16-97-gb64119f8dffe/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.16-97-gb64119f8dffe/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.16-97-gb64119f8dffe
Git Commit: b64119f8dffe14ab62bbe65e01e72c102be085a9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 24 SoC families, 15 builds out of 209

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-drue: new failure (last pass: v5.1.16-97-g16964bf47d80)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
