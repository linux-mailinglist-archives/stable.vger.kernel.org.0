Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273D312DA6B
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 17:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfLaQwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 11:52:54 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38576 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfLaQwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 11:52:54 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so35613565wrh.5
        for <stable@vger.kernel.org>; Tue, 31 Dec 2019 08:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HoQnw5uz3nLhPDN6sExnhRdsN4LQ31NX/cWftIRXwZU=;
        b=EVmqPkS3ApjU/vJJgt2WqlgjT9rFRcfSE8tVCjfgXqzedZXKIEX+qxZpEPsnGO/moU
         6PiqiAIZvhCCL3k8t0M1C4h4/TVoJmm+qVCAvi73CU42wbgi0foW2Jjb/H+BC3dgO96D
         ZNNJjmfTe1PlteQfl8LZp7y44npaAM5GlwOxIi9nX1hRbBOzCLK8v4Q+e3Qj+68nkqMM
         JqrR6TKbmVcOMfCSSB8PRTKajS69lgl+7cAowR8kfQ4lJMQrlZ8czVZvoyRVLPRgEV5e
         p9C3xcrJMwrzQztzaBfpvavbFXibFnXeiY0WROKkccpK0S6LOZAEFLkOP0QLwb+7IdL3
         OS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HoQnw5uz3nLhPDN6sExnhRdsN4LQ31NX/cWftIRXwZU=;
        b=k/MyHU9+KvxlPjG9GxEeNzydA5DELGcLOWTNlpNyqX7aQG6BZiwWgceXEl6pEJnHXs
         LC7jwcJRyc3cUOrti6SY2LdGKlMxI19UbXKRH0TzqTl4zunRkGqejsjySW+QEFUi9VX1
         IqoMUQVbUbbROveoKIdJUo2I03B7dlsOPbSKNcLnfSwOzP65jnC2HrlZldVzhMgv1Nis
         MUfkXGLLsasp3KJ8DCZLJyWkFQjYYREW6kBtnSrQgAE4enc/zG4MGbR4cAjofpZcdHjK
         iE/bz7yAChlZfAyrSV8Csm9k3vzGQxtyFgQsNaq0wp4gU71kOuAAGZ7FvcRdUUJGdY27
         3R2g==
X-Gm-Message-State: APjAAAWidbViYYeVIvsmqnR99VZaDbL4A/UARV03BO1u2k3XJiyZ8VFw
        6XhPbXdUs54JqURSN9udNjBpWnOjxkfJQw==
X-Google-Smtp-Source: APXvYqwYYUeHbDvIL1jAqncgSKFaCO+my98M52ZVigFbb1ewo3DHabDs9yg4PNxImmeDTNbs08w7UA==
X-Received: by 2002:a5d:6b82:: with SMTP id n2mr72649798wrx.153.1577811171747;
        Tue, 31 Dec 2019 08:52:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e6sm48914050wru.44.2019.12.31.08.52.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Dec 2019 08:52:51 -0800 (PST)
Message-ID: <5e0b7ce3.1c69fb81.dd8ea.0afa@mx.google.com>
Date:   Tue, 31 Dec 2019 08:52:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 66 boots: 1 failed,
 64 passed with 1 untried/unknown (v4.14.161)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 66 boots: 1 failed, 64 passed with 1 untried/unkn=
own (v4.14.161)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.161/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.161/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.161
Git Commit: 4c5bf01e16a7ec59e59a38a61f793c5d1d5560c7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 40 unique boards, 14 SoC families, 12 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
