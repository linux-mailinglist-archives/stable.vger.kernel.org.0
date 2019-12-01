Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C08B10E213
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 14:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfLANro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 08:47:44 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:38411 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfLANro (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Dec 2019 08:47:44 -0500
Received: by mail-wr1-f49.google.com with SMTP id y17so2160271wrh.5
        for <stable@vger.kernel.org>; Sun, 01 Dec 2019 05:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aRukWeyh33CQRV/WAuIfsJAv3cFRGRyyWstI0jlerHg=;
        b=qJyL7vV1R5HO5tsa6v0xEX2wmD5aVwoMmFVzEA4c2y9WL63yd7AWtIBPOxc+bwB6UF
         8oQjgl2gHx8CCB1ML4enUeBrEDRXC2MxenEVA/KV899L3r3LDnY/uPhcCnmDdi7UyU3g
         zjNQMPts4mNSJ7SMtBFlr2iCG0KDicqVabohR+aVuubd1oc3Ubz42gtM250SPa1WGpwC
         EqLUt6fbmJcXgXbVsdwqfllSrfRbuDRG+v1FZSFyNTB3qpxLbvFAnJQLtawPAK4Y6mh0
         pTEGq7hfLN2HRpH4JInEEIGUUfcmTw/WCf9HlBJny3fjCTLe6/jf/2OGpjqHyQilBRj1
         pPpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aRukWeyh33CQRV/WAuIfsJAv3cFRGRyyWstI0jlerHg=;
        b=nWvF8FEtVFEXhIdfscmvpi0vsyijnWbj1OX6Psv5rN7wI6g8sUoOHKzaEHvMz8Vwu3
         mOadqB3HW+14uA6Ar33lDtUKwMsjqW99C3AfQ3wz4pjw9TlraCpcT0OK4lgOt/v0hYtk
         gRs1i/zKuhaQ1GrKByidGM/j7dA6Ha68IjOwN8/1QHbuFdYPLUbZKy+vtfGKqbFSH215
         jygnGjGwsKb5gJ9LG4SKLnllS6lbv2Su3b0ccAQTpjFs8YKnJax+yC8/F2Ij+HPxgw6D
         49TJo6Fyl2h9MyM6x/cQDEw0LBfFQ6k5u0NdKkl74j57c2qax4INGCUkcOjrIByd/1WH
         C2Mw==
X-Gm-Message-State: APjAAAWd1bC3lr8C+M8l3m1SQZBTcR3r/yzrLt9anH8+lkQ8wfLhcOgt
        PwIMURVysdaLgrdk77mR4j3vI1pQwuw=
X-Google-Smtp-Source: APXvYqwGYguKzPVYgYx9EVmPOol/IwvuG7/2s8g3a0ZvioAOE3QLl3myQD67mqZZVX6G1uPCG1NkOA==
X-Received: by 2002:a5d:488c:: with SMTP id g12mr424897wrq.67.1575208062264;
        Sun, 01 Dec 2019 05:47:42 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c15sm36075391wrx.78.2019.12.01.05.47.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2019 05:47:41 -0800 (PST)
Message-ID: <5de3c47d.1c69fb81.963e6.af3f@mx.google.com>
Date:   Sun, 01 Dec 2019 05:47:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.87
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 81 boots: 0 failed, 81 passed (v4.19.87)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 81 boots: 0 failed, 81 passed (v4.19.87)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.87/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.87/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.87
Git Commit: 174651bdf802a2139065e8e31ce950e2f3fc4a94
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 49 unique boards, 17 SoC families, 13 builds out of 206

---
For more info write to <info@kernelci.org>
