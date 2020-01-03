Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B245012F473
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 06:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgACF6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 00:58:17 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:51173 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgACF6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 00:58:17 -0500
Received: by mail-wm1-f42.google.com with SMTP id a5so7448842wmb.0
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 21:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8gjyCZ7kS5s+GdAhCutkDM5ntVrhUmT2G8S1ifhziwM=;
        b=iUROVd7H16Ra9WdYwAHdWoqHcRs/z4ermZhK/zhrpqcX+JgK9RsGljJ8cQ+EMP4jfw
         DVqf1EpBh4aXxGIyUZH8nn6945vMUN2qvrs/a59Z8NQeqV9B8/6IkuWRSfCyrW2ls7ry
         dnH/KrhIBXLt3uhQEWX3GKS0ZRM3XWqaB3mHDleO7v9UoewNAn/NYthbjOsvVTGtlVd+
         hTnMwMN78p+hfkeaZmI0wzeW7x8s/IsgAl4E9dX3ubJzxWFri6C2EsGSpnfhAgdJH+DE
         zZFWz+b/cOhydL/yXN6sASGeIuF5Cg86Y/+akZ+TfQfnAg2GzlPk5i6qrbJQ9helsCKI
         Bz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8gjyCZ7kS5s+GdAhCutkDM5ntVrhUmT2G8S1ifhziwM=;
        b=lTV6aDakLbR/Rw239DBH+yebEpw9mDGQHi6xMrc+q/4XcF8EtiSDVkYaKrX0x5p8EH
         Y6bY53Q2kPIpu+I98hnHVXPAhUHHt8r53nQowjwLA1r4sNJg0HdA0EZzhczvmGSWs5lK
         uoO+n9NTeqIZponnTQ6T6/JMMtSysDFSZ0hQdF1et3ekQMoNu9CaOJbdkfkkfUeE1Fys
         7JbOnZ7L1sXtiKmOYc9/DUDaRe35ppVHr7nTJaOGdapvMDYILKF1szPt+q0Tb/RWnqAV
         yKIGQIM8rHpTnR/qMvWetF9Gt2cS0+6EN++da8aXU5FgBzz+4FCCguhOnmn3KF1WGJvF
         Z3eg==
X-Gm-Message-State: APjAAAUrxZvujHw+EmFmjtGNaj0bMBgitTC7rOlxqwtfpEXL8s8WyAB/
        iuIyJejeVMUvITl/YXE1SUFoaQXU0a4BxA==
X-Google-Smtp-Source: APXvYqwIWOh3CdUA3vSf1FDjPBqcskCICXES/rlRQfeTJOumX+S/wMBXjG7nFwqQq7EcbP9BxaDkoQ==
X-Received: by 2002:a1c:6a13:: with SMTP id f19mr18650421wmc.20.1578031095857;
        Thu, 02 Jan 2020 21:58:15 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g9sm60582855wro.67.2020.01.02.21.58.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 21:58:15 -0800 (PST)
Message-ID: <5e0ed7f7.1c69fb81.3be54.6416@mx.google.com>
Date:   Thu, 02 Jan 2020 21:58:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207-138-g8eb04883f217
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 32 boots: 0 failed,
 32 passed (v4.4.207-138-g8eb04883f217)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 32 boots: 0 failed, 32 passed (v4.4.207-138-g8e=
b04883f217)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207-138-g8eb04883f217/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207-138-g8eb04883f217/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207-138-g8eb04883f217
Git Commit: 8eb04883f217f38b78d9fc0ef9044a5259b5e815
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 18 unique boards, 9 SoC families, 9 builds out of 190

---
For more info write to <info@kernelci.org>
