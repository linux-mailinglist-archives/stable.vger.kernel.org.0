Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D983177A
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 01:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfEaXLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 19:11:15 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:41671 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfEaXLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 19:11:15 -0400
Received: by mail-wr1-f54.google.com with SMTP id c2so7490341wrm.8
        for <stable@vger.kernel.org>; Fri, 31 May 2019 16:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l2mWtOL6BB9rfnlMDNZBg08V514Uo/ZqMrSA8qxz9aU=;
        b=unTamcb9m6iaHNyJXpWr808KgBLvAT06oQNEkyZV/ethADYuM3P8e5xx82ug6i76AX
         RWIU5gqkQrUCscQ6O2aMppB8SqQEaa8SGiMtEipAu2FhkPXJ+7xioapXF78ygfR1rhnH
         r6Fwd/EMlfY6Ked7JKKGf0eaCtkC0BW4BZEQ9AbEdK7cboOcxW2r5LUIS098m0IQ6WLY
         G9RyyKur18JlpzT2YWOehDwsFoy0bczxoCpMKJ2LPqIXG9Br0u1fCjjNYKoV8YVCGr68
         qGOr4FpRQyFjHRgEl9E64VLPVkdSJhay8i5bB0WySuG/FNS/rYkVl5DTxlMZj8bk4nlP
         8wSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l2mWtOL6BB9rfnlMDNZBg08V514Uo/ZqMrSA8qxz9aU=;
        b=X5qQN7rgnCVqsz22w6oKVZWwpoAHl7XB9pz8wuQuNmzt9oX4YPdVxD5zPB2WAHrHTY
         aPLrRE+YFBsPOamgv9q2G3SUzFFUJ0vcHGT8bg/d3oXHyqqy6LPzUqD7InGlJI4IENLV
         SaC4RElQxk2Gm7JjpbWlweb8+Tj2lFYw6w0e2z1FNrn2MI2OZ7zP3Dn7irDpTnJ2kc6H
         DvON9gkeD0DfORMevmZR7V7LLt5RockFMbFwkgHiBTXV5P96sxGNKv/+DE5CTrWbPs5r
         9bmRqJyrjmqutKvhQI2mmMeSOalJa2sIxLhlUi12lU+oGFshBXP4iKD8cgXkyud4SmcB
         AHJw==
X-Gm-Message-State: APjAAAXjYuoPJPTzFuhP3sy2ibzr4g5vTkEWm8fAuYQg0uU5w3CtJ4Kn
        dY5SxmDGJcVhXmuj5iJ14zuJW1+39bwjbQ==
X-Google-Smtp-Source: APXvYqwHZ6+eQSVT8Dw1ZDB+BLvmzdrdh+eITk4P/sBKkg/ur0GlAPHZVNJthhkzjfCTzK2qq7dsOw==
X-Received: by 2002:a5d:53c7:: with SMTP id a7mr4365931wrw.91.1559344273834;
        Fri, 31 May 2019 16:11:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i17sm4602876wrr.46.2019.05.31.16.11.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 16:11:13 -0700 (PDT)
Message-ID: <5cf1b491.1c69fb81.83e3d.6d6c@mx.google.com>
Date:   Fri, 31 May 2019 16:11:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.6
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 61 boots: 0 failed, 61 passed (v5.1.6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 61 boots: 0 failed, 61 passed (v5.1.6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.6/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.6/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.6
Git Commit: 98e4b991db5ac04be8c23cb2dec277ee31fd22f3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 16 SoC families, 11 builds out of 208

---
For more info write to <info@kernelci.org>
