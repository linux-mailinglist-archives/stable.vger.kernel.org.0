Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788902B56FF
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 03:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgKQClp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 21:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgKQClp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 21:41:45 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B966C0613CF
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 18:41:45 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id b63so12476569pfg.12
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 18:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h4FkQfIkrN0f6UC+MX4yH5yv2MukgdjUnmi4/PokAuE=;
        b=ANRHGtnMtce4E7fzU8OlGkl78ydU8pZjLkzQ/31xafYtZCbLqTbjTrZO9j4sFVjof0
         Q21MLNAXnKOhM/OL7QeEj21ye588k3T4qp4gbk/yxaBR7rImQLoxwNHub2VTyr5NLoj5
         5Wi3ugeXYgbXZxhrQm65zJOq6v7WWaeBPxoDhw0SJQOEm8LgsfabEEty0Gvfc16UReEo
         reNc+Z9rRLLJgIw0bRJNNuOOdhwMwZjDN3acuqmTlCoWfSaM9HVPVOHTxSKJE4U1zCJP
         ed7QOhahqa2Eu/WCxSe44hNFKu3t68PW38cA1VR/HWU3r2iBBHq6oFfTO8PpbS4uHDvc
         Z70A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h4FkQfIkrN0f6UC+MX4yH5yv2MukgdjUnmi4/PokAuE=;
        b=CXRb2tB053FjTd88J89/nqpUQOzs9aO17RFW2m7H3+jGswj387AaxuU4n828czl899
         d4hJfDgY/o5g+cUUf1cmQo0aIbf1uM+3ZmIAx5fLKk5F6IT7JvbsuRQAhKQ4teXh2+lC
         FzZqYRTZKAb2RAbsCAxLGscpz4hk3rZi+gEeLN/odseOe0AJwDj6if097I3UPeezMlBG
         1iZInFs7P0ITuH0qRP6NR+5k07frCkU++YCVt/pNek5nVyMobwtcK57ePBjRy8OkycUs
         Oyntgv97vnyZOq2ij2lIQWygKFbdMHwMQZ8du4ymkJ7FEDpIoYGhwd8APvFHFRGuf6bR
         U8/w==
X-Gm-Message-State: AOAM533/8UatTr8bM+VEwbWL7Is11DovHUJwB527gyAFsfbQo1yCh6Vx
        Si+BNgztwc6gcjeVr4x7rnHGPd1q6Va3og==
X-Google-Smtp-Source: ABdhPJyGGN5kHvtUy4HikFwfboe8mvG7gFLxzwhTa2P/ypiES+CnAOloOwiUmgV8fFcjuEpIMAXdhA==
X-Received: by 2002:a63:c157:: with SMTP id p23mr1827039pgi.349.1605580904262;
        Mon, 16 Nov 2020 18:41:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm19699319pfc.84.2020.11.16.18.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 18:41:43 -0800 (PST)
Message-ID: <5fb33867.1c69fb81.28d13.cdf3@mx.google.com>
Date:   Mon, 16 Nov 2020 18:41:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.4.243-41-g75498c12fce0
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 build: 4 builds: 0 failed,
 4 passed (v4.4.243-41-g75498c12fce0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 build: 4 builds: 0 failed, 4 passed (v4.4.243-41-g75498=
c12fce0)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.4=
/kernel/v4.4.243-41-g75498c12fce0/

Tree: stable-rc
Branch: queue/4.4
Git Describe: v4.4.243-41-g75498c12fce0
Git Commit: 75498c12fce0d400d89cf310841ed46844936e6f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 2 unique architectures

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---
For more info write to <info@kernelci.org>
