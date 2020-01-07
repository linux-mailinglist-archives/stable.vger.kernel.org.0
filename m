Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3733B13353A
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgAGVvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:51:14 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40725 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgAGVvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 16:51:13 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so1218738wrn.7
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 13:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OfYj014caVocPHeK5U9gv0YfvDsGnZC8VnQiQ0nJKZw=;
        b=fpA/5+Bjz5KY9I48upZ6X7JQTHYMW+ZKj96zNE5/rzVWZWcaQnwRwwVy9zfKMe9crl
         vR4xpDucFc2tW8r1V+xUFIv3HYoLUjtWeJBsgOprmqBpiRAPz7Ke3Pm8MLBD12RrVJPA
         dLmOvjp1mAMqe2u79mhdGvYOfmw3wGgfVSfojRE+PEQLDFi2FzLi9CqxtqsWkqLiImkG
         PbFHjG1CewZNaHk5h/+pSIcbTOqsPnBd4A1JoK5IHj5iD+oUBhHi17CkO7D05uLnf+OS
         ySkfRSCvxGozTa/wwCbSC0uCSVp6/Bqz8xE452lSWNc1KPYwXzGw8OEG5C0ezaoRkwX4
         IbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OfYj014caVocPHeK5U9gv0YfvDsGnZC8VnQiQ0nJKZw=;
        b=RkrGUfE93Aw5cl/we9QkE/MteWps9Z+m2VvbxIcyBPPz23JV48iFyGTMbZ1LVlixUX
         cdotdMvjirgIr0Mrd4emM4dReiSma2kdaK/YGTnYCI4Dt2JsfvIASpwbJBu6lMA5YpX3
         I9grC4QYHgKl1DVz2Fq0kKzxD8+KTP6y843mm/UC6phlWixn37mCRJWoLeWElNQTBUqV
         Wc46xEgcpQGoQdHlLISaUSPdcx4Mow7DkNyFd6CdGQUwb3PYS4gZdDsvX7cTj0TZ2Bni
         qe6UM+QWjWho5W/36XT1fuAdZ7HkrUkF+BtLjGkem28wxfeTDmMBAdGeAnsZsX0Wr6cE
         0HpQ==
X-Gm-Message-State: APjAAAXZWbHtQw4Awh5rnT+xylhSRUAlxmAeAI+vwcv5F9nZh/a9XAAT
        Q//irM2v9OiVZuZ3lhDU+ragQXaS6bED9A==
X-Google-Smtp-Source: APXvYqxipYz1GkhvfGvNl/CAOP2j48HWLUPDHjl6qVStmY5JlZxOTvMDL7aoiNa1K8SZWv7KsxiDFg==
X-Received: by 2002:adf:e78a:: with SMTP id n10mr1226681wrm.62.1578433872093;
        Tue, 07 Jan 2020 13:51:12 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n187sm1141591wme.28.2020.01.07.13.51.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 13:51:11 -0800 (PST)
Message-ID: <5e14fd4f.1c69fb81.c50cd.62dd@mx.google.com>
Date:   Tue, 07 Jan 2020 13:51:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-141-ga62afa8ee549
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 47 boots: 2 failed,
 43 passed with 2 untried/unknown (v4.14.161-141-ga62afa8ee549)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 47 boots: 2 failed, 43 passed with 2 untried/u=
nknown (v4.14.161-141-ga62afa8ee549)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-141-ga62afa8ee549/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-141-ga62afa8ee549/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-141-ga62afa8ee549
Git Commit: a62afa8ee549b0e4824794a5ce23fba7926fb199
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 12 SoC families, 11 builds out of 201

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.14.161-90-g01b3c9bf3=
424)
          sun50i-a64-bananapi-m64:
              lab-clabbe: new failure (last pass: v4.14.160)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
