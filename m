Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE416F3C2
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 16:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfGUOtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 10:49:53 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:42485 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfGUOtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 10:49:53 -0400
Received: by mail-wr1-f42.google.com with SMTP id x1so21769737wrr.9
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 07:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pj1KaszzYeEPg7Yw+lq5K/ReLm2Ulob39wle4PVhCyI=;
        b=fFjy+ndAW4KTh05tk21fGw6Fi5BSlHE+tZhlEyLFLMDaVKtnhdFpI6SDLpDeTKT86V
         6459lY3ptcuwPOItygLHZZvh+RNtyDg+zpSR+gFvSWk5t6NF5eslb9J0t8z/Wwqdupjt
         77B5jCazCLnc5ZUR+o97kwR+jD7vE4TTJIaUFx/IgoopOramg2gCaa/Owve5p8eQRCtY
         sIKkbyWKfoyHFc7EaVy4hAFVNZH48sTfm5JJxZMnHIEOiaQzP6QOrDYVj9GYdc3AosYo
         Z3OfYBQVjQ2/sMT2p5c09ggLv1nT3XZOaLRMO2KAAEAVEPzdHElJqFJOhac4gjzYg4m2
         IE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pj1KaszzYeEPg7Yw+lq5K/ReLm2Ulob39wle4PVhCyI=;
        b=rnL436q5/h3bZsekKt/Zd2bOI5ddMuTgFKvxcJ1BF2wXHFSdmnQStlyB/K8ijzPmm9
         WfRsQb7B4nQJkSiq0CBwQMnV2jAxllsDXt2Hwr/Pr9qJCpdJHOzmeS9PTWadOkcz9WR/
         9bb2lXop9oSc0a6XNOkoYkFlBH+5vBpZOS/dEveVJdWroIhLKr2Tfa83TQLn1ZdEbaeR
         VLbtdEuIGutJirdNe91w0hojArFY0PCtukGxN2QOagg4ZwOeAtGk7gIkh5nNf7B/YlM4
         FEAtJl686mgGG/bTwsaNohoDU5VtWl4s7abI8WHryLpRaLhz5RvD0eTS9IVBsQOK0hJi
         Gw7A==
X-Gm-Message-State: APjAAAXQ8vk04EqSwlgb3ggAMo9nrB30fYBqUz/D5XxSuOrLb4z7xX2R
        a5d66pDBOQE0Q8RRSDTrQf+lXoIb
X-Google-Smtp-Source: APXvYqzfowhUkqpRE+04rj4pJ7M1ME9IHoo2sFm8LnH6FoEhc+zTYWKeFbQwV+Xi3hZTqQHfnp6TAQ==
X-Received: by 2002:adf:afe7:: with SMTP id y39mr67645662wrd.350.1563720590932;
        Sun, 21 Jul 2019 07:49:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g8sm34516049wmf.17.2019.07.21.07.49.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 07:49:50 -0700 (PDT)
Message-ID: <5d347b8e.1c69fb81.5c064.fed7@mx.google.com>
Date:   Sun, 21 Jul 2019 07:49:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.2
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 107 boots: 0 failed,
 106 passed with 1 offline (v5.2.2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 107 boots: 0 failed, 106 passed with 1 offline =
(v5.2.2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.2/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.2
Git Commit: e9b75c60f91a359cb0e1b2d0a9ed1c81485215e2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 25 SoC families, 15 builds out of 209

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
