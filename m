Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1694E3D0FB
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 17:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388277AbfFKPgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 11:36:42 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:40187 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388863AbfFKPgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 11:36:42 -0400
Received: by mail-wm1-f41.google.com with SMTP id v19so3422747wmj.5
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 08:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1GWEv8FCBxWI9nauzK2b7kpjUTYGqenC3xKdDbI0CQY=;
        b=A85wTUId71HvfFjbf71l3QI6qn2E40HxlkXKY9Xa/Jzz0/DBvYKyGcRx+y/1uBr/Et
         D9gQYLZri8TEqFVrAERGf7D5rE3kaH1pgnf9Wq4h7pN/ZuzZmTQOpq9a0Av98MwZu9Iv
         TRNOP/EuctAsxYHk16Zn7qLqHAxmN8ilSMlJjBr/9CxXCb+YXuC/DlbE+q37cJfpiwzG
         YNI/pJydHCXltRP7bcde4TE6dfDLeaBHt2VBPjjVN0dHC60kKAPLKfFTdaMeIJhqbN0u
         6U/Jp8drJDm1YZYRjAuZ3FCEB+Ua8QKFIy4S7aWbHShhRPjqbO5B1PQifxGsB4fqAId/
         3Fyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1GWEv8FCBxWI9nauzK2b7kpjUTYGqenC3xKdDbI0CQY=;
        b=bC7ks/POYSruFWxeaWWyyjk3SJgJRNJR4uT0hDsOSO436Yl9Rzp0wLj9cJDEpUdQy8
         iDBJ/srhOqq3XRZBvRqI7ayFgOeiN7l0uczx2IKO/XyM6q5beKWtZ19zZsEcYHvkVTOm
         RINDUxPEcZEhInFy7N+YucNpkqVI+MPIhS8pGXS4POEmJRdIJNI7/r5wz22V5Boj/4ql
         XTwIUuPtXvobPW2XOaHWp0Spwd0rkIPGALpD70BtnJ5l7ndvj7SXRUJ3Q1AhVGFzeroO
         +RDk+hzqPXvHX1FuYUz+I4HyL3c2n/cDI4meRpZETa0Eq4nTCPg5Pg9PDU5Jkz/+hIe3
         XPjQ==
X-Gm-Message-State: APjAAAVuBmTFOXszKDKUyHJjzqvXxGuv7Ph6tlDHmUrIPWcepsscPxdu
        9QNVGcEQpSJJLZcwfU/DTDHlFkvsSse6Yg==
X-Google-Smtp-Source: APXvYqwuhCY45VySb8cd8dlVwi5i2KFsyQaKde3IgEXuZ9cK30bHQRnfOycENFmXsb6hNjV2nA+goQ==
X-Received: by 2002:a1c:c011:: with SMTP id q17mr18638921wmf.105.1560267400113;
        Tue, 11 Jun 2019 08:36:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w23sm2661566wmc.38.2019.06.11.08.36.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 08:36:39 -0700 (PDT)
Message-ID: <5cffca87.1c69fb81.f8b2.f389@mx.google.com>
Date:   Tue, 11 Jun 2019 08:36:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.181
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y boot: 47 boots: 0 failed, 47 passed (v4.9.181)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 47 boots: 0 failed, 47 passed (v4.9.181)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.181/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.181/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.181
Git Commit: 3ffb2407c545c389a872c3eb12e09eab34432b12
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 16 SoC families, 11 builds out of 197

---
For more info write to <info@kernelci.org>
