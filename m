Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC5E14197
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 19:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfEERmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 13:42:36 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36715 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEERmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 13:42:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id o4so14319859wra.3
        for <stable@vger.kernel.org>; Sun, 05 May 2019 10:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/X0XwL0ZzUOpX4SXUpuHqLjSlrpGCaXz7cU0lVej27o=;
        b=ApTVD43l7WeXCA3I3euUPG3tUDxrJu3eDc70SzGBLQgDvdgUqT2m6ibh69Vvhz2Pim
         cLxOS0ggDlEe6bQFHNxlZTACIVxxiB3QDdv8uuH3rrQzBr4sZyZg8bUQbqVgRkQddHOm
         oTLUczRYGyXC3QoaEjHeboVy3RUsSsY73jk6d4E+1HBWhvkYWhDN8KEXMqCScsjIFL9o
         aA8d2gLN/9gzOHUmRRl05Nl/fG32OZHAVUkBPF+IEYqTomj9sMsFBQ7v5tMh9LcjBXqN
         n36L7VqTGuVf2QmsqeR3Y2va+O8a9kp1oc77dXdvVlg+TUaIea9F5RQ3Lg31QWUo5Q9b
         XY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/X0XwL0ZzUOpX4SXUpuHqLjSlrpGCaXz7cU0lVej27o=;
        b=QM4kCLDmNyhB5B5d61rX+RGTUN0QdczDaoWlsKDpArDsKcIWJ9Mt+BR1ImSE0qompt
         nmC12TiHecathxIhqUDrVP1lFqnxJxNWuzVt46m5XAun7ynss7zSOWzBiinLnabMenGt
         evY7W6Htyd9ZIGtML2cD/5ZJi1eIkAThNS4npuH3adgi2ksf9NAiqsnrgWLRo+qo7ao8
         5l5yzglZHtStu8AKI43VKA5KxrZRHfATSasrLGmS0SsW86hOISsXjqFDKPDDCa6FYvzT
         VRtRQRA0VziR3I2u9S0UjhZl/6eh/MeYjFwci/XZbPJYBc8lGHlrq5KV2Gqx/Li8q4Z1
         5sBw==
X-Gm-Message-State: APjAAAX/lX6pD/Ds2Gt9WADBceeJwCe33rFTrLuAH9QQ3XdOQO8B8hFh
        Tfj+Mo/JuiPU0Hk2/9pNlvmly41x9nU=
X-Google-Smtp-Source: APXvYqy409h3hQkOYF+tuczNxv3GjMcuPmVqUaqXBZKP7gJDc0ikiSTjlnMjJv23Sq2SF7lLDtlQ2w==
X-Received: by 2002:a5d:638c:: with SMTP id p12mr15124473wru.61.1557078153983;
        Sun, 05 May 2019 10:42:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e14sm1426901wrt.58.2019.05.05.10.42.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 10:42:33 -0700 (PDT)
Message-ID: <5ccf2089.1c69fb81.17765.69ee@mx.google.com>
Date:   Sun, 05 May 2019 10:42:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.40
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 62 boots: 0 failed,
 61 passed with 1 untried/unknown (v4.19.40)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 62 boots: 0 failed, 61 passed with 1 untried/unkn=
own (v4.19.40)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.40/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.40/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.40
Git Commit: 1656b14572090df53ff096f158726c1d1355f5ca
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 15 SoC families, 10 builds out of 206

---
For more info write to <info@kernelci.org>
