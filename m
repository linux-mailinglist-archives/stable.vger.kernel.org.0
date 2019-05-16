Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 779FF210EF
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 01:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfEPXKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 19:10:10 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:38311 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfEPXKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 19:10:09 -0400
Received: by mail-wr1-f47.google.com with SMTP id d18so5107046wrs.5
        for <stable@vger.kernel.org>; Thu, 16 May 2019 16:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ez3Xi8aor7OsNBy0VoFO7PCibb5HT2g1sLZK+P2Ib/Y=;
        b=0VGn1PzG3v9pnhrt9uiel9XSr4DHos3psVx2+TjNz8iVKkdwxy/tD/fLDDbZhOg/tY
         j9FtF9Miiab3hrW0c5K4BkifS/zSpKCiCmnDdLzUc5KJrNSEQ4XXyGiENFNhSeXltxxA
         RDZ9hsySFqjXOyTXku9B1YtUoE5+iBa9igwkgIF4xp96PwbPDq3ZLHar14ylEdjlWzSN
         hFzZV3IxXZNgjwDqkdjVDOIX/ski2SHmqfyFnR7YnjafrOd04dBY37b2zmhnljogQmvQ
         y1acdvFOJObEefiOIPTN1aou9W5NoIXRFvab3mf6FD05i9lFrQqO3QBNSA/uKkmEwJyr
         Tfcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ez3Xi8aor7OsNBy0VoFO7PCibb5HT2g1sLZK+P2Ib/Y=;
        b=pg48Sq45ixD3ydquhhItoIh7w0v0cqLBbeFM+E8YRcRftgms3iOaICLr/SwJgVcvC+
         Ve/EUWceQrWVti1uN6C8iNUjMNt2yxpTklWuG99sXY06EQEPZhEwYeBfzv2P6Ih7kYga
         H6s3VcF8jSlUhIIyc8Cz4EK4Np063gtPOhrivBuNvsbsuMhCKlPsmcKu4ZAtM/M4k8yR
         jihUQbXGGeqhvnAqQ7aF62frK3WZKR0t3MgygA5IlDBqL3f6isczzPwjuZeKbuICrXhI
         ba2ZWW71AXbILaiajt3KrPwSKtiwiDwn7RQa5ylu5ANhHugvJdiCX3wfpZVdYt+xdQZb
         sTBw==
X-Gm-Message-State: APjAAAUxAISzds/9XL/u6JGE01paZIWgGey+IQ3mkWOl4vC+rApZGuvx
        1KQXorZVIQutYfgY5G6EjcJXvIkir+fsfQ==
X-Google-Smtp-Source: APXvYqwC2Lg6jwiNYQUUQxHCkMh41Y1dXgut1N/m4yhefmNovFvwhx+nQA0GH56lL1vklvpxRsEt5A==
X-Received: by 2002:adf:db87:: with SMTP id u7mr21083533wri.245.1558048208385;
        Thu, 16 May 2019 16:10:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f2sm7122921wme.12.2019.05.16.16.10.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 16:10:07 -0700 (PDT)
Message-ID: <5cddedcf.1c69fb81.4824.98d5@mx.google.com>
Date:   Thu, 16 May 2019 16:10:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.177
Subject: stable/linux-4.9.y boot: 47 boots: 1 failed,
 45 passed with 1 untried/unknown (v4.9.177)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 47 boots: 1 failed, 45 passed with 1 untried/unkno=
wn (v4.9.177)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.177/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.177/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.177
Git Commit: 8baec4ebdf084961516f17cadbad14cac082ee4e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 13 SoC families, 10 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.176)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
