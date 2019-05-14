Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32CC21E59F
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 01:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfENXdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 19:33:31 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:40665 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfENXdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 19:33:31 -0400
Received: by mail-wr1-f45.google.com with SMTP id h4so570913wre.7
        for <stable@vger.kernel.org>; Tue, 14 May 2019 16:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MxSt3g1TzfGFC+apYkXAIT6dx3OEb4SFcQqIIDnE7hQ=;
        b=AaxP5cqquUYcLk8PL1Jpn392qyaAhw4F9prI05/kUTrwMEgVzQqAky2mvbOkx36YOe
         ZZPYRSpqkRgPqU7lgaRaxtJO550mL6PCLE3W7tdwhr3nw68yXODZ7mIEQyiFasqZA/Iw
         Pg8Vbi+IXOAVL1tqHcXLPGfWVhLF/0XLntufIs5ePa8rxZqRByc726EnfQOjapQG8qUu
         HsIGG22z1fkMgoANaTEuPk4RmeFZOCoZhGaKRs9oi6JPnidCcWS3XYwB116rLtdxos/P
         TUtljbhj3oRYXPHch0Ori+sNrhaqecYAYn2LGKbT5XBS4E+fDAcBFOew1bpNM87zsXwt
         9HcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MxSt3g1TzfGFC+apYkXAIT6dx3OEb4SFcQqIIDnE7hQ=;
        b=aVFEzYyhjMTiKL7WFFH3pJRtg58qEo7ibFkhud4L7i772v5WwOfg8h0t55VaBAgfkH
         MBtDgepO6z8GBkccy7H6iDQLKMar8979PERuWypr8lr4onMjzPHIPCq1is3bFfTD0oZG
         KntYGMw6hf1yyIShPizYQ592hw0+tiJ82WPkH0/BQnUYT9KsamPQ/xd3hpKlA9LhNdux
         7CEqvKhpYTj7uPQ2IDbAFnhsvXMj0vJGaBHK0a8nSVuYQit2qWofuPd1ijgHH8fVvjI3
         PSpB/+cbW06fmfcBsdpZTl6hPYzJRDICVGgi6T5JK2uaDpII9F1bXrvT1EPf+/cVfHou
         shUQ==
X-Gm-Message-State: APjAAAWpw3aOF4/U8jnhYdLwwoL9NUwCJk3Z3A1DrazzaHSmqW1+dwIU
        DwqK4/rOFV1QoRxfJDBlhmqsgmjP/4By3Q==
X-Google-Smtp-Source: APXvYqwJKrQrwllgQHtEbbfnS0g56rTP9RM5o2/fdoRlP4q2F87U+QYwX0/kuQXPbxEkfWf5PjeEiA==
X-Received: by 2002:adf:fa03:: with SMTP id m3mr22676163wrr.323.1557876809928;
        Tue, 14 May 2019 16:33:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c130sm605481wmf.47.2019.05.14.16.33.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 16:33:29 -0700 (PDT)
Message-ID: <5cdb5049.1c69fb81.b277c.3931@mx.google.com>
Date:   Tue, 14 May 2019 16:33:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.16
Subject: stable/linux-5.0.y boot: 68 boots: 1 failed, 67 passed (v5.0.16)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.0.y boot: 68 boots: 1 failed, 67 passed (v5.0.16)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
0.y/kernel/v5.0.16/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.0.y/ke=
rnel/v5.0.16/

Tree: stable
Branch: linux-5.0.y
Git Describe: v5.0.16
Git Commit: 89e11ec0280be9132b81e4cba5ea6c10a8012038
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 15 SoC families, 11 builds out of 208

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 3 days (last pass: v5.0.14 - firs=
t fail: v5.0.15)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
