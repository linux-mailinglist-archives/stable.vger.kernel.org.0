Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F24212542
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 01:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfEBXxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 19:53:44 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:39975 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfEBXxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 19:53:43 -0400
Received: by mail-wm1-f54.google.com with SMTP id h11so4668640wmb.5
        for <stable@vger.kernel.org>; Thu, 02 May 2019 16:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u9fjAdS4qdgFfKFlDRvvkJV9M4g4jVaDIHEILhziWRQ=;
        b=WapqDcOjOc0oFDG8AsVbUTvNmIxkV0ksgJFWo2hIahqiox6IsvHWTJF7TK0InN6Cia
         /+YocKKTDG5xbDYjMsmxH4xt8WJOiIkUiyjgPi81G2VKgGOJMfpvpweN0eassSNdM+rs
         y9YbXXimFuWePSQLnYV0hEp/m1FuJc2cbpJLK+HimLIRcPcs7CmT1UqV5s3mghnuR3zS
         bNmFCYxnu6YDoZJE/rwWEDNOv49gPX4grmVbZ2jJ90Omz1UMss7MxbuGlryZIufErtie
         SsnSDBaljpOYaTUTbpev+IMqrUkRbF7e3TXytsWRWnvQgeuLGQjOfthUGO9SlImLsu4X
         wcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u9fjAdS4qdgFfKFlDRvvkJV9M4g4jVaDIHEILhziWRQ=;
        b=ntFJj2F8zjI3oaYtYo3Xim2/zR/NrAKK5cOfzbcINKiuLNgh7D8It9L87f1KCouc2O
         i/9cadIMFLOk4OPoHSgkD8brXJrRt5bfjpVTvGjgYYCbBsx/cgDHz29s1rKnrSIOxzkJ
         iC/Ca9tJyubhrTbkRtd2+2nwI8Ft2l9UrfzIqfAuw9l8/cSYnrVeoDd1brDEO1XGYWkP
         fE061QD3XN7PK9uAs4IQ8vmX0BGkEegNbGOsMZQZa3QVEd/dsKvDMok5GxHlu7R3V1U9
         SfXfR6MhUXrZ9wRB4t7w190/ehhHRgca78ZRfnZofDVTQMFDB/+9phN7nzWobzXSMZ+P
         wX7g==
X-Gm-Message-State: APjAAAWmn80922JIELLa/60qZFAvSnc2aIFI7KvOuAHfhR/ojcpuJ9sz
        a7UKbm5zLt53fpJt3VmIdvrpiTlPhyyqJA==
X-Google-Smtp-Source: APXvYqwtyzfP6lvtuCJrlnmGeyjUTitwdE0jYm0IA8BLkaiEyGPcsLhDxMasSJBafQ43nXHsikdCBg==
X-Received: by 2002:a1c:ed12:: with SMTP id l18mr4428803wmh.13.1556841221876;
        Thu, 02 May 2019 16:53:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z16sm445195wrt.26.2019.05.02.16.53.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 16:53:41 -0700 (PDT)
Message-ID: <5ccb8305.1c69fb81.af1fc.2ad4@mx.google.com>
Date:   Thu, 02 May 2019 16:53:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.115-50-ga4aa5bff0752
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 122 boots: 1 failed,
 121 passed (v4.14.115-50-ga4aa5bff0752)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 122 boots: 1 failed, 121 passed (v4.14.115-50-=
ga4aa5bff0752)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.115-50-ga4aa5bff0752/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.115-50-ga4aa5bff0752/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.115-50-ga4aa5bff0752
Git Commit: a4aa5bff075214a024ba945abb791813e33860ac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 24 SoC families, 14 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-7:
            rk3399-firefly: 1 failed lab

---
For more info write to <info@kernelci.org>
