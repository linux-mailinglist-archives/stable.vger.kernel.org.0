Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F30EA49727
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 03:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfFRBvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 21:51:15 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:45204 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfFRBvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 21:51:14 -0400
Received: by mail-wr1-f48.google.com with SMTP id f9so11997251wre.12
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 18:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QdfSFaHZxqOQnZpuak6zWlNXji2dmIrBwGxFI1wS7+U=;
        b=lsfY4zNbRfVbNV4z6KU+inl9oPftYsn8rLFneIEFhNHCA2MqpVD3mpN3cJYKyK7ia4
         r2EWqsxTKSFwzUsJQPVvQIq+b61Lq5yVJmXIT7gCSI+T4uCuH5pZ3xcalal3dQGp9D/J
         1v5gcUW9Q7nHgqFfRvGnaVU47eb0YCd+jZgNOU7DgiBOv8Z7ySQTmbuNolRUrk7KUg/M
         moMRHWZj1l0hnX9609tE8A3hDQXQK3WRt9aTOeG874W2BQVNLAxTW6OKC8vjvc6YkHoZ
         NuFNgH+biepwrHc6pX/4qjzsGv12ihdRGUyVFYMamDwcNcOlwwfRpYqgVEBB5PfVYwUP
         LnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QdfSFaHZxqOQnZpuak6zWlNXji2dmIrBwGxFI1wS7+U=;
        b=M9sbJzn6FRPPb8RoXewA0AHRKjQW8gcJ8SsIj6jEJ6wnybsV9nr3RyLyyFP4pYbI7L
         A7s2AE7D539Weh2uVQ9MRdBTfZsqJCAo0LIFsw/jc8vW9tEdKR9apdvLzvtofOUNjgro
         KBw5+2PstMgOafKC1UFYimV95U53QvxpRgZH12lcAseykPOzXFwlcFb7H+SEGghWcPIX
         N3cxSqiNW+ufXunv65jv/5zYRSmKlwXDbFDYFeJl4o7tvz7mTYdO7DLzEWaUKslYHIYd
         fWidj87R8bTVaWVZAQZFfOov6TBRtVXeOIpJGIUY1YnW0Mrd9gEBaoj0sbQJPV2Tv9UR
         tk1Q==
X-Gm-Message-State: APjAAAUV6MH929gIqKdWAwRCmqsVstqrTKQDc52W7oz+WPYtCRfx+896
        2qqCTWMqEpWIZpwn/F5RdbAtqeJ3dfKLTA==
X-Google-Smtp-Source: APXvYqw20mS0BLRxKzeRkuKO8t2w3o7Prd63pEK+ZWCJc+MPxhdmaicAcpXG3rr5pA63inxijeVoJw==
X-Received: by 2002:a5d:498a:: with SMTP id r10mr79738842wrq.28.1560822672676;
        Mon, 17 Jun 2019 18:51:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 5sm730775wmg.42.2019.06.17.18.51.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 18:51:11 -0700 (PDT)
Message-ID: <5d08438f.1c69fb81.fb944.4192@mx.google.com>
Date:   Mon, 17 Jun 2019 18:51:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.11-116-ga1610563f19b
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 118 boots: 1 failed,
 117 passed (v5.1.11-116-ga1610563f19b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 118 boots: 1 failed, 117 passed (v5.1.11-116-ga=
1610563f19b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.11-116-ga1610563f19b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.11-116-ga1610563f19b/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.11-116-ga1610563f19b
Git Commit: a1610563f19b8c84324c5b490e57ffd1f1bb62be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
