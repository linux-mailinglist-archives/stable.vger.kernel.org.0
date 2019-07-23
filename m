Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C1F72267
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 00:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfGWWco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 18:32:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36907 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389559AbfGWWco (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 18:32:44 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so19711928wrr.4
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 15:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BxHdqwjk4dPlAD+52FqOjNl7/hld18Q2RzBnk2HNv6I=;
        b=GzNfO8S40LplcGz1L6a2XjGpTBIMWm8fQyUvvTz99bV4pEZTN3oIxOK35UEo7Kc6OO
         kAk4RsKfE8MgUAimMmMf4t/K6NWFm+DajsHF58cIkaE6WcsmqhlkFy7ezxIkylAbK+zm
         yId/GAHeFgzHE6o71EIro5/qn+2DjOdPhZWB6r2M3x3BieplO27aOQ5UC37vpNX8BCUW
         QA5teACDJaE7S/Eo9gyvAk11pf+ftQVWiRmks0iMXE9fSNtDDQZW9Ru5xfyUhwkjUZZ3
         p+Fn+MFkPyzx1HONAlsU75jSQVyvjz/3R04kru4reBydvsmkPM+dZnBlS1+m+TDQTpLy
         678A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BxHdqwjk4dPlAD+52FqOjNl7/hld18Q2RzBnk2HNv6I=;
        b=GzRk6UOja+go8zUd4h7pW9bVC1K4UExJvkBUN5cPgjtQ088pebeBsvpicuM5wA0yFg
         rVv/yPR+k1xGgFPUBYsUjQTeii9qF37ck4GOninFS8O3cyM3v0hRB9Pkx9NIkWsCogiL
         gkVKmqmUt0gg2dJ2XHqMJ1hScRoktIE7x4SvvV0F2DUrVaPdMzdqqKIXCD1gVFRcDGIu
         a8mKnZhW0kfl1GXCrLZrUTAqT9xWITAM4O8SFtw2vzsg8EQ+OBpFMvbYRIoLgUZjChs2
         TCkNuCNKuiwl7Q2cJvROVO2qozDptD4kPY0C/sXrcDRqrhtzd98CXBuqNtsLLveGzSSe
         3RPg==
X-Gm-Message-State: APjAAAVx1mvZbGY0aoooWANifLtmo85CkJ6Vu7L0cW5fPcDKfvO2/gO4
        03eEOKRz5TDxDgCZrIlo41TCjNAss5I=
X-Google-Smtp-Source: APXvYqynulT74I75ujiFoQt56b2HYWvIgiq1F9xULffh2UGXgQ+vuFyfznNdTQwrjsle+GsHbhj+Nw==
X-Received: by 2002:a5d:528d:: with SMTP id c13mr819058wrv.247.1563921162044;
        Tue, 23 Jul 2019 15:32:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n8sm35447293wro.89.2019.07.23.15.32.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:32:41 -0700 (PDT)
Message-ID: <5d378b09.1c69fb81.ae52d.399e@mx.google.com>
Date:   Tue, 23 Jul 2019 15:32:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.60-243-gb06e2890aa3d
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 91 boots: 1 failed,
 89 passed with 1 untried/unknown (v4.19.60-243-gb06e2890aa3d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 91 boots: 1 failed, 89 passed with 1 untried/u=
nknown (v4.19.60-243-gb06e2890aa3d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.60-243-gb06e2890aa3d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.60-243-gb06e2890aa3d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.60-243-gb06e2890aa3d
Git Commit: b06e2890aa3dbd0caea255feade21f86d2333cc9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 23 SoC families, 16 builds out of 206

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

---
For more info write to <info@kernelci.org>
