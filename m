Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 311A1F6A0E
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 17:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfKJQQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 11:16:49 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:52001 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfKJQQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 11:16:49 -0500
Received: by mail-wm1-f43.google.com with SMTP id q70so10853396wme.1
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 08:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kIAu27ghhoZ2n5Fu6tTPOrDMD57I3eghld89zrs6+Jg=;
        b=nrRqIeGBfEHLVym35iknlhVxtwWb14yqJmlNRcoH3NfcNhm/q85VxthL2mE6l/kPAV
         RLltLGiBtEYw5u7qVul0Y6oRDtyWaD7riuNt44ltITEY/4rXiF68OSk0wSiqSYOoG9k3
         485p6wMURv0VtJ5oP0RrQ7jLoNgtxQ22/7PRYJ6+NFOj/olRVUZD6HY9jResiB1nXMC1
         rdDGZojwBrcHN9LcPvW0UikzQq+8xJarfcwv7erPNCQxTFuAEM3DG7rz+YhZ6yKBGa+h
         /R5ZtbAcfvACC8zMhVEqnCJsWOlpNGL0NtNPDG9Scfw3SpnxLFyilWpfpVQo/QzGLnPp
         6iVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kIAu27ghhoZ2n5Fu6tTPOrDMD57I3eghld89zrs6+Jg=;
        b=ryWHZjF1UAmyU+grBeb9mrl4MA1ZoGVvZ4WL4/dPAoqEiP7WpKHnc/r/yFAkrWbcWh
         EleBTUyAHUO9ddkhS1gDviplZZRlntjjXo6eKgLLu1bZUve1LyDCsvTf8sUX59A8Yqak
         u5KIzJ5PN8nddWw1LoE0zLCDEG8T9M55GsZWXVxpyxx0G5gK9VFehb5uOGqxdvcxvmA8
         GvxVyxBmQg8VfeVuFdEmT4egMchbgMEKZHr13T28gr04EvEnbaGQdF0QdGeQse/LT9RS
         Vkslt0F46o1UMmJCjBg0anVaLLozM1gNbjfOwjK3bKv7OHBFZWPoFKVsjT2U4WDhy+zx
         9Jlg==
X-Gm-Message-State: APjAAAVfCj2MDzHIbW2JtB81/Z45cNUgKayrdi6yZ1N/ydAe6W9kmYYx
        ySISzGOjE3Ido7yPP2Tty5brwC5261c=
X-Google-Smtp-Source: APXvYqzZNL0zY9d3fQVky2CK3GLt6AfjV1CIoie6mPSHydr+IEA83JFfS3QBn6MXYh2FviVwB6UxTg==
X-Received: by 2002:a1c:64d4:: with SMTP id y203mr16893215wmb.27.1573402605266;
        Sun, 10 Nov 2019 08:16:45 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 19sm26128772wrc.47.2019.11.10.08.16.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 08:16:43 -0800 (PST)
Message-ID: <5dc837eb.1c69fb81.7a6a8.3d8b@mx.google.com>
Date:   Sun, 10 Nov 2019 08:16:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.200
Subject: stable/linux-4.9.y boot: 42 boots: 0 failed, 42 passed (v4.9.200)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 42 boots: 0 failed, 42 passed (v4.9.200)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.200/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.200/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.200
Git Commit: 574a61d201df8f159162bf706de3645b62d75048
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 24 unique boards, 13 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
