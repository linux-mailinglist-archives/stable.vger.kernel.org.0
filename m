Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6D013A222
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 08:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgANH3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 02:29:21 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:41803 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbgANH3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 02:29:21 -0500
Received: by mail-wr1-f45.google.com with SMTP id c9so11041311wrw.8
        for <stable@vger.kernel.org>; Mon, 13 Jan 2020 23:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YmxzQW3/CuXJxm39OD5V8mdPDLMOSsXZ2ZE7qk+rGEI=;
        b=H1moWQkvI0jGUZwcOsKkLwKe3CruY1XvxYw+wyo7UiMv8LaZvsc3PomfHesQl8JEEb
         fKrZpLhHgn0EJur/KJujQnnRyBvlAZOpMjifhhlCg3CtnujKe4hXGWFdKLy7/Jv9zUli
         eEx91x76B0s20TLpETrWveJ9fe2t6gGxWRYvs5p5PMrvIsG1POhBQcb1ID8sNOyDacd5
         E970Zo1JTmfc1R+4+MuvK9VWBZDT7icXvTw52BhI/Rq0ej0jBHCIVTgZpNT77wsUfiqZ
         mnmeMn4Gwa9FwQKtM5/EERIXrFO+ZxEfLamtcoPKezH7Z1Azs5vDAwe4qBUJppc4d3Cd
         ThkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YmxzQW3/CuXJxm39OD5V8mdPDLMOSsXZ2ZE7qk+rGEI=;
        b=rn7suNOgyhyMg1QSks9libFPviNEZsSkmlN7Ih0sYinPxyfeKreK2+LxgT3AMj4QrM
         D4Kv/tAj5RjRYscYj/vqsYh+WsTvRY2RsbS1aFG3ur5zan1xoAmX4K5SwAx8sG/KaR1z
         LXbT5TG/smb+gffVB0BaJ+2W33/r7rWpa5cBrxz9I65GB5c60NEUXrAP7zXhGk8MvO28
         VWli64XI/uvTlf457QQNBZUlKfS1pg0PF4mo/+LPU8gGCfDEhJ9+8UA4CuiX5JgdTinK
         xtXukHcbtEIYpKjjgZEDkk1iIve85pfeA6ql/mdre8E2gHfvJjVGPAjWarC+/T+OCve4
         SZlQ==
X-Gm-Message-State: APjAAAWFYrhkstBABvU8GvdRtq9yAWw1Z1zSmjL4C1NA/5KdA+MSTM/Y
        Kor+t0gzG4osxfGt/BNPw/HyZPTbCOQh2w==
X-Google-Smtp-Source: APXvYqzyNqPwSwlacTlcIBQmu0vE1iimk6zryuYoB7VhACltEGLF7Q7Hc4JwCxxD2DTzXFxmXYAwzw==
X-Received: by 2002:a5d:46c7:: with SMTP id g7mr23145072wrs.11.1578986959474;
        Mon, 13 Jan 2020 23:29:19 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i5sm18702785wrv.34.2020.01.13.23.29.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 23:29:18 -0800 (PST)
Message-ID: <5e1d6dce.1c69fb81.7cbc6.d632@mx.google.com>
Date:   Mon, 13 Jan 2020 23:29:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.209-22-gfbc4ae7c27ee
Subject: stable-rc/linux-4.4.y boot: 24 boots: 0 failed,
 24 passed (v4.4.209-22-gfbc4ae7c27ee)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 24 boots: 0 failed, 24 passed (v4.4.209-22-gfbc=
4ae7c27ee)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.209-22-gfbc4ae7c27ee/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.209-22-gfbc4ae7c27ee/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.209-22-gfbc4ae7c27ee
Git Commit: fbc4ae7c27ee627bdaa119f497844a16da15b8d9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 16 unique boards, 5 SoC families, 7 builds out of 189

---
For more info write to <info@kernelci.org>
