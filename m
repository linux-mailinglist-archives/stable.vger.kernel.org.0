Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E8E13A0E5
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 07:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgANGQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 01:16:24 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39972 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgANGQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 01:16:24 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so10903689wrn.7
        for <stable@vger.kernel.org>; Mon, 13 Jan 2020 22:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o+XIn93jQPR1f93XrRqRlB8rXGx1f5sAP/ByZYAWGt0=;
        b=Gi0OYpYuQkgDlpPSkxepIiJS9dqrHWX14Z60sVABlPhS6OqnqbIbTQ3f4hJOZ7lKlu
         orp4dQvkRlVRGMJrzm8KWCkf+Ppduz7u7HYMzTxH/BEuzWjA6Wt7hdTYbOzt42DwAF37
         SUPNC4+wFBIGSiNRLy27Ai0hotZLOHlRI4Q1B3MRm7wjz2S49FAP3j0Lh573sHpUrnN9
         G2U3oQ1H30GBD4Osz4RrXizCLnTMEVRH7IHcLLNnjaQL7fFgFa8XiUdXwtIdVz6mgYom
         1ZnL/kyi0hfeiJBiYX5rpnIYNmp501Vk5em5akxQsLkqvd2bRUQ2OZwivAg1BGlqA2As
         fqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o+XIn93jQPR1f93XrRqRlB8rXGx1f5sAP/ByZYAWGt0=;
        b=k89xVZU/dqYrYviY5QfKkkwhPcRdtTapjTukjk9DYX1FcHqo+4zikjIG7el9/Lu5I0
         X3GuYSW7F0KKvVs/i0iCWN3rVSgtA+AlCPqMcNMfkTy0RQpnXeRLmJmsRgDlN3K++OoV
         hr4RKbciDt6IPqNtA4pUwmZsk4wD4ZJDPOEsOEhIaiTYy49fWabR8b8NEdmBGDd1iiND
         HpGLBZVnQHFilbDfjhGBKyYJ+YgGs8WiU9BUn3OfyKd0BX5EiJuUzVq5NBfAK9Eyyxv/
         /iISkz1ZhbgbUu/442UGZLZ8+/oCBiudGHw2+VyD7kPwvcelOVj9rLF30udQrCBj8H6D
         sJrQ==
X-Gm-Message-State: APjAAAXvSo/sdlpIuqY/Q7DQahK9puTE/0RcGayyz77c+5rdjz3Jym3B
        VAhf8GO9iwE+TW8uOfAbur+Dvrgo6aJObw==
X-Google-Smtp-Source: APXvYqwV3/cqLbR+Gl+wJOcGmVIrVGcQOxHgpAABMrbOhBJnYJO5ItkfABA1RruHgbSpJh0V67f2FQ==
X-Received: by 2002:adf:b193:: with SMTP id q19mr22902749wra.78.1578982581921;
        Mon, 13 Jan 2020 22:16:21 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g21sm18725244wrb.48.2020.01.13.22.16.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 22:16:20 -0800 (PST)
Message-ID: <5e1d5cb4.1c69fb81.4f04c.dca5@mx.google.com>
Date:   Mon, 13 Jan 2020 22:16:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.209-25-g575c30651ddc
Subject: stable-rc/linux-4.9.y boot: 55 boots: 0 failed,
 54 passed with 1 untried/unknown (v4.9.209-25-g575c30651ddc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 55 boots: 0 failed, 54 passed with 1 untried/un=
known (v4.9.209-25-g575c30651ddc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.209-25-g575c30651ddc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.209-25-g575c30651ddc/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.209-25-g575c30651ddc
Git Commit: 575c30651ddc0c430cbcd6891c0a2d9fab1d1e69
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 29 unique boards, 12 SoC families, 12 builds out of 196

---
For more info write to <info@kernelci.org>
