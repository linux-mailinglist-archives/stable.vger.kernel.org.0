Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C65C18FE
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 20:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfI2Sem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 14:34:42 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42172 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729010AbfI2Sem (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 14:34:42 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so8515311wrw.9
        for <stable@vger.kernel.org>; Sun, 29 Sep 2019 11:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CXT44cU9AFxko8Qj0dqAGlbb/SHq3H2Y20gdR2e2nOs=;
        b=juUlVwwNfy61xf3mfsd4F2ctdKvf6ofcmymVQebLL4BVwXDa1sJTGk4RzbhoSx6S0t
         OM4tQriZlL46G5RpjWc7xRKByWyesIKx4lX++PZ/uVWnJCdAKZEBAZPxVA8fq9RkOBw+
         C8qXvW3lrx5ldL19v/y8kPYthLbsl6mIGYLDCBRF0uh6GKxxK22zqwIEFR4uh+3/iIVP
         kV0AsChqWXxyu+9wBfkSQNVZewPuytm6j+H774JacQs7zLvRF3YW/9ApjZKMJnYuWYGy
         b2j25+vjNcxA0XJJmCMvyM5B8aAkWaYD0FxKqJElzErhLok0nrr+ObNS4Rm8A4pQScLN
         QJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CXT44cU9AFxko8Qj0dqAGlbb/SHq3H2Y20gdR2e2nOs=;
        b=W/83XLTqARQHStY7vwnrpFYEGqS54CX6lS6H8edsbQx+8ZMnJI8ikBNt6KYwcOtO0J
         T5WUzhsH3R4En987yA7Bwb4xp0Cbyeia+OYtzq2TYVAkLn55eV4tQbif5hR+1gcA3GMy
         xCPhmc2BUhBE7x5PLyE780FLB/qDJ1xo0kGQMR4wwcyjm2qdxn0oWK3opjRZev77T0IH
         sPQ9HyB859MiyCVkC3um0ujrlxEHRsn1TT1wfZ7BaEmAjVSwe8OJa5ubLKsVdBZaPOQm
         YPpWwvrC/terZAsaP6Q4PEKJ3olOQ9QsCXgdBMCO+49hSbZeuaKtbXUKb3W2NQ+x4OFA
         YQiA==
X-Gm-Message-State: APjAAAWaPc0Ow9eoYI4wtpj1/SJE4Zad4hL8qV0Pnd8SmERXJlLEmgAp
        kzODiYrYywXUdstfiOvh++/UccwwrjA=
X-Google-Smtp-Source: APXvYqy5EUhponeR1g0a9gBwunSXLi2uQhmtd0tPsoyke56GmLD1iI3QWN+wvsaqw81fuYhn9z3Pcg==
X-Received: by 2002:a5d:4290:: with SMTP id k16mr11426348wrq.265.1569782078993;
        Sun, 29 Sep 2019 11:34:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z1sm21145226wre.40.2019.09.29.11.34.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 11:34:38 -0700 (PDT)
Message-ID: <5d90f93e.1c69fb81.e23e4.009e@mx.google.com>
Date:   Sun, 29 Sep 2019 11:34:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.194-23-gcbe81cf61bed
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 63 boots: 0 failed,
 63 passed (v4.9.194-23-gcbe81cf61bed)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 63 boots: 0 failed, 63 passed (v4.9.194-23-gcbe=
81cf61bed)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.194-23-gcbe81cf61bed/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.194-23-gcbe81cf61bed/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.194-23-gcbe81cf61bed
Git Commit: cbe81cf61bed99b73ba6fb37613b2ffe40f28a65
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 27 unique boards, 13 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
