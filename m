Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 865EBED687
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 01:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfKDAL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 19:11:57 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32835 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbfKDAL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Nov 2019 19:11:57 -0500
Received: by mail-wr1-f68.google.com with SMTP id s1so15125018wro.0
        for <stable@vger.kernel.org>; Sun, 03 Nov 2019 16:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KfqwqEjcKL8mf246UlvwfplrPDLfA2FqP+X/kDvtpIE=;
        b=Y4jHfX7PgChlJi2hk6vQIrFva5D7wDCdMUuqMK5X2CxsDisair2PxMKHDDBrp4zTYA
         B3LFqjCjmyc3Ew8zjmuspjcojWzRZxrV66c68L2JkbMRlcZfa3kOk1pgtMOSTtwkduJE
         25DTIKXY42GpC/URJ3+dEqtM8v3lhSmf0eC2Otf1RRgB3aOq7AjZn6QXf6nNQM8C56wh
         5SZhX6vKyZd+SeRe6fsaq5UI5N0CVFBR3kD/eulESqua97SMM/afeJ3dnpLr67B2KkH9
         lpUtUc5Q/Xmdf2rBJehqvGI78g0zT07XwpE4wexnqW39xLvHsg1DqHHvHaIzBHNccDFW
         E92Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KfqwqEjcKL8mf246UlvwfplrPDLfA2FqP+X/kDvtpIE=;
        b=dx0CaXNWabpE0B2yQY9/VMQDPzaZH0YpiwlOvOPbc7/qHoJ01NtZVHOKaA3fXbofO3
         x0BX3L8Se/8yE2AJOQ8pVMAYQ3eApSoqatHk3+oVTwc4TxgwZRyGSQyu9Ss5wlu7ka1W
         6egcaiTh1uS2KNO5bqSbrplX7+RA4Ttc1jyKsMqCtCt+Z52cHBmddAlvFwqrg9EudjFO
         1VGNt0dFw5yw+7g1srMX+kvObLxtERDAwdsL39IQFKDYU3RFaW7TaZK4WdDXv12MdoH0
         eOjF77o4Um3QPv8CNWNFYB8TlralQ99PR45KwLZGLibUSwi6LoDu3EtwCVkFgips9IIt
         geHw==
X-Gm-Message-State: APjAAAXbGczd/eOJmX25TMnJw+vepX1hbifwEd/IaMdMgJ4o4hKNYeCt
        sel/JUZx1uTXqRkbZeKWoXRMp7OK28YH7g==
X-Google-Smtp-Source: APXvYqxXKEeIg2yKi4/SIZGazyACtikBiDE5x2V/4vYEHXzuyN6O8gPp9ZvK77x+WiVwnSNDZMt2xw==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr9328129wrs.248.1572826315276;
        Sun, 03 Nov 2019 16:11:55 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v6sm8194118wrt.13.2019.11.03.16.11.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2019 16:11:54 -0800 (PST)
Message-ID: <5dbf6cca.1c69fb81.4a9d.fb40@mx.google.com>
Date:   Sun, 03 Nov 2019 16:11:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.198-38-g0ec3474509ec
Subject: stable-rc/linux-4.9.y boot: 46 boots: 0 failed,
 45 passed with 1 untried/unknown (v4.9.198-38-g0ec3474509ec)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 46 boots: 0 failed, 45 passed with 1 untried/un=
known (v4.9.198-38-g0ec3474509ec)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.198-38-g0ec3474509ec/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.198-38-g0ec3474509ec/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.198-38-g0ec3474509ec
Git Commit: 0ec3474509ec1efc2bc793f65ffdd3ecbbbe1166
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 12 SoC families, 9 builds out of 197

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          r8a7795-salvator-x:
              lab-baylibre: new failure (last pass: v4.9.196)

---
For more info write to <info@kernelci.org>
