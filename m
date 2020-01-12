Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2647213844E
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 01:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbgALAkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 19:40:23 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38141 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731741AbgALAkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 19:40:23 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so5223064wrh.5
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 16:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pzC6vRjhR0tq72r3MisZb1JLPcE/jvifaqKSwxCHW9Y=;
        b=LOkhIUmbxpoTY7cxI6pTpxoftMGJGmJ6YqWFx/xfhEbBNceGowCL0HSHCtX7Hus5UK
         yJYaouIdmxlssB6jH9wQW5edvwiOrWjWSMOGizWFtMxytUoo6+KeEv/65p9RzdcLhkMW
         BlDmFBqJm6uCMo48TuDeIgVdJBKoG5EEJWyVEQ1nOVKuFCnjH96HIwMq+HvOsnPmoZW+
         lXnIY5jKcGLn6O7YDfIilTjcR0+nazdh9y4oghk9UkW/6HIr0NMNQF0d+mA68Fa+wBBv
         CdmIE6elBMUTpX2Fwxyyr2k7yljki+DtSGQ+0RaVMbmuFCTiXAIhvCyeRFziG168a1C4
         FOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pzC6vRjhR0tq72r3MisZb1JLPcE/jvifaqKSwxCHW9Y=;
        b=RS4Lhl6XuLepFr6BZpWSfIvoPrf/ps+usY/fLm9Mh+F428l2STI7fobJ8t+KTIiiid
         vGbvZcO54Vt37HfFJt8TLz02DhosYjMMLLI8Cxz96Qrgn0pd1DIN0eY/J+3LG3b6CcIm
         zx8reraLfMpd4Q9CGvQ4B7wg3daqzyvrM4U834r5rFPVjmnwWT/T4Vooj4XGO/U0saJv
         POPrpbSS5lDpHg3EW5b3RwkLti3EcUui0nUlXQsfyAQ4fgUFgs8OtWg+JOeLpZahYis7
         Q50ePMxjkDhPxR+NPjfbn4f7uy2i6gwDUbYGIcyS1L6pe1A+iqjdTruvLFdhYpubPh3G
         oxtQ==
X-Gm-Message-State: APjAAAXM6kpUj8aYhjUYLvhPffUzSTM55WRHuurmE8VVvvbYNOHbAIKA
        X4ddp4ZA64fHuHDGlTDYLBy+LChhGInD1Q==
X-Google-Smtp-Source: APXvYqzd6aXS9XcBqwZkpa0Ex4avwIstcPPuI2N3bamZTAMeWAGRynCBsVfE01xMlu9scqH5UWQIzA==
X-Received: by 2002:a5d:4dc9:: with SMTP id f9mr10093466wru.297.1578789620624;
        Sat, 11 Jan 2020 16:40:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d14sm8778706wru.9.2020.01.11.16.40.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 16:40:20 -0800 (PST)
Message-ID: <5e1a6af4.1c69fb81.b9030.5c81@mx.google.com>
Date:   Sat, 11 Jan 2020 16:40:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.208-90-g0dd28c11952d
Subject: stable-rc/linux-4.9.y boot: 56 boots: 1 failed,
 54 passed with 1 untried/unknown (v4.9.208-90-g0dd28c11952d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 56 boots: 1 failed, 54 passed with 1 untried/un=
known (v4.9.208-90-g0dd28c11952d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.208-90-g0dd28c11952d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.208-90-g0dd28c11952d/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.208-90-g0dd28c11952d
Git Commit: 0dd28c11952d3a45280706afe87a14db95f8cf21
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 30 unique boards, 14 SoC families, 13 builds out of 197

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
