Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23DC16579C
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 07:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgBTG2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 01:28:43 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39256 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgBTG2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 01:28:43 -0500
Received: by mail-pg1-f195.google.com with SMTP id j15so1400259pgm.6
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 22:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hLnYKZDnrNsPhrEgeYgRm+pbCt2AeY2TuLsVrPrwaBQ=;
        b=OlzTC3BH0eqmMvkOIBbDpFkPtz4lul+h1Nk6YffRy5OVpejvK+wn0dU0tqSrKhDw/5
         NwXYMTWP5t0xvZiM+aRT1KjlWyTeC3ZATwj0ne8h8Jtres4QCWXU9SO8pAIgs1hkpYhE
         kJmAkuxKziUzJk9HmfLYzuqoJ84PHYjoZw10Q3lk0LUQ44nkyFFF9wFlV0VhfQAq2aUu
         fRh62fObRh/P5eiaGlhOSFXbK3PeqhU1PaVCU8+w1srhpmgDOA3wkQ76eHn9qqp2x6q1
         mU8r8epBGRY0eWQ6yNvv3LE18hLdV6pJuWIds+jkGlNg0zcCJf05CK8dsrT79HQQS4a8
         HF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hLnYKZDnrNsPhrEgeYgRm+pbCt2AeY2TuLsVrPrwaBQ=;
        b=uVLhTgmpwfN82YRtIaNNGXaQ9y+aqxxxNGe4arY860cOtVPnPQ49uXdYCygc+htyTR
         zJLqLBI3OZO5H8pvSRm+4xb4Moy93WOr1Ajgy5YisR81roqdveYTPg9yloR1YfbvMGin
         PY01NmkM97qyK4O3XRNBaemadHIrNFpYTK6BNIgROkNW3mbVQ1kr1KGjkPOiihg+cipf
         c4JXSU4xG64gmcByZfmwk+lF8x7PjXVlzh0H2vwzFoB6zwpVHu88fLeOrR+FJWizFhFb
         iQ2LLCObv2SFue7XYF88lEvWpqac4MB6Xp9JeXzKqlBK97kiYfn9gMhwQehO89mk7pW9
         UeWg==
X-Gm-Message-State: APjAAAWmXPk40vb+LkyYoZT6JpdoOr9a98yp2dC9DelLPyqA2+XFHfSm
        2QHj0eC0KgTW7vJSNrxbj930nzp00j8=
X-Google-Smtp-Source: APXvYqyykDtG+PIDBkPZSBrlU/5wvIPsxzW2XsjB1W0gOTuhNirWh2NaP6YMzMFctzQ73TEm/NSjyA==
X-Received: by 2002:aa7:86c4:: with SMTP id h4mr31241750pfo.209.1582180122125;
        Wed, 19 Feb 2020 22:28:42 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b21sm1927695pfp.0.2020.02.19.22.28.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 22:28:40 -0800 (PST)
Message-ID: <5e4e2718.1c69fb81.a0b3d.6a00@mx.google.com>
Date:   Wed, 19 Feb 2020 22:28:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.105
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 42 boots: 1 failed, 41 passed (v4.19.105)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 42 boots: 1 failed, 41 passed (v4.19.105)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.105/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.105/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.105
Git Commit: 4fccc2503536a564a4ba31a1d50439854201659f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 11 SoC families, 2 builds out of 15

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.104)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
