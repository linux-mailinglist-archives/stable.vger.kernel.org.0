Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8866214BCEE
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 16:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgA1Phb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 10:37:31 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:37752 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgA1Phb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 10:37:31 -0500
Received: by mail-wm1-f41.google.com with SMTP id f129so3055148wmf.2
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 07:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Dcq9KFeFsAXQWp2YIqHGYKyeXL7NHjUpf/RlYqFankk=;
        b=cEzDN95/h3WOR6YPVwZiVT3qa79KdkXCQUXi786+AFGKVdbPFrjEWD0jN7hf3HFTJY
         1TlUaibrKoA7j9w2djgUbFlqxb+/vmoBLI9+mUpZHQ5u0ERGDR42cHGiVBLmYyQG0fY3
         okoS9aLnF3TkPtW9/2nAj6OkQFOxyNkzbbUBpEDneIgSpWKxv9AT3Xm2kX/HtDKkDsuU
         yWNYayskCPr8pHxG1sfU6zRaeexSxruWvFQ6uEjIZhnBAyCLTl6yLrCTTDE0quSFL+mw
         Nln+QmR+FQLiNWulf/dwrSKZELnlYFL1lA/ueUL1nFCN6pfzfMGKNM8ghpbO4xCICzms
         CzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Dcq9KFeFsAXQWp2YIqHGYKyeXL7NHjUpf/RlYqFankk=;
        b=G8g/xrS/OksHcCBj4WwJjzWDCzZm23VuLj4bQp80oxXSgQQn+bfdaAS3uSz3+hBjd8
         tOkcbt6ba3kpsyKgKSudf+wNJeUXYZ1aER0jxt9+AQfNL3dFRLGlFgJmz6OVpOG4a6qY
         pG9nPyu0MDhu8MuTKc4ueiVlwUhoMUPk/4k4S0MDLeDBGV/Ze1Z75NBcvl1NOd+tBBNI
         qru6GX3ZWZZJIcT0C5s1MTooz2P7+K0XNVDLaUv/apkD3IOn6FK7vUCjfgTWzzK1QNzc
         wDGORR6AzeFPBFDi7p99RtQFhz8Dx3PGLqHR8z/blxbaItgU+2VrGXa/Yj22MiLlaDE5
         Ha8g==
X-Gm-Message-State: APjAAAVw3K/mWmsXcY0DgLzX+GlclJRcqAr0qUVv4ur2mc4RA0mX+V+K
        ROgt4uUXDU7sDOo4/6LvK6K8czEgni4uLw==
X-Google-Smtp-Source: APXvYqxAmqOQG+C/uU99ONgWoAByUP+yf9nnBIeWJDp9TZZHpyCsq7XExAjff1Mc6k40xzIjy6bWbQ==
X-Received: by 2002:a1c:5441:: with SMTP id p1mr6034768wmi.161.1580225849265;
        Tue, 28 Jan 2020 07:37:29 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f189sm3823068wmf.16.2020.01.28.07.37.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 07:37:27 -0800 (PST)
Message-ID: <5e305537.1c69fb81.63dd4.056f@mx.google.com>
Date:   Tue, 28 Jan 2020 07:37:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.211-178-gd2c04d5b95f6
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 50 boots: 0 failed,
 50 passed (v4.4.211-178-gd2c04d5b95f6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 50 boots: 0 failed, 50 passed (v4.4.211-178-gd2=
c04d5b95f6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.211-178-gd2c04d5b95f6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.211-178-gd2c04d5b95f6/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.211-178-gd2c04d5b95f6
Git Commit: d2c04d5b95f6089572603a609fa499f2ff330d06
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 26 unique boards, 11 SoC families, 8 builds out of 187

---
For more info write to <info@kernelci.org>
