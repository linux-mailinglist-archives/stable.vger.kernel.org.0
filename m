Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249CD153FBA
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 09:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgBFIGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 03:06:04 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:37056 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgBFIGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 03:06:04 -0500
Received: by mail-wm1-f44.google.com with SMTP id f129so5796167wmf.2
        for <stable@vger.kernel.org>; Thu, 06 Feb 2020 00:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YI/v4LRQgKLLP6pY2DUTootcG7VBbYFzW1olEeLqjQ4=;
        b=SX+bnVF9K+vLfxz2i3PwfOP1lRY4E9hhKls33WTrlhOQ2ViFbSLyHmLXlEKhrM+RA6
         jZSCcJB3bKDc9UdxZuYTgZvVIMbTUNeh7ri9bhxbOvnBI7iv26rQtS3yBjSHDOLCxp0a
         USqKvDtFq6zCxDxmDpUQJXzUtqO/7fOzHL/A4TKkNG2v7FD8s+v3utxjV/S6Rr5v18Sp
         IyWW59k762faBM0J5A6pt7fj4ifxzSMfwbvSfEV982gz+1NZXMtnIPoDKer3gvjXQcmm
         6jJMAyoYOsPq3gssG1DgebnHJBpR0Iq8/9GiOT3KmhavDsbdZj1sPBz88/lA4y0WCiKj
         Wrtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YI/v4LRQgKLLP6pY2DUTootcG7VBbYFzW1olEeLqjQ4=;
        b=UWfTpNioH3qpiV6iXIr+i3mGsBni0WsIKt36CheyjhOjaNnzIbcNwK1eEp1WZOEFyr
         PtnWEdcRvgVGlRLuzDxiQ5oyFetwXe3utORgiHoWNsTeM5qP42A9Xc1iQ1MfAPeqGGcg
         Wjx7dZ5CFIlKxNSIZIDlcK7DJ6fVuIvQU0p1QaWzjr2/fz7FNOT+7+DxiRh3JQwoW34S
         DAz54jCu5QAUk4E4bhvYvsfaRmrb6u8K5QcfeHaGjmiPo3qv1dl1ltDcO0nOWEzjNrLR
         KgGqIceF8z2tDO8SIs0xclm3xP5EdwQLy8g5KdWVVH1YoEJntCjI7kp81MKIzD4geKxv
         heUw==
X-Gm-Message-State: APjAAAUmj0ZHd+Twdux6zhrydGUUmkggQX4JK7PCzJcXhdVumVpYFqcS
        RumzCDObUlIFAYyV5VQiHH7XOiYrMGozAw==
X-Google-Smtp-Source: APXvYqxvpUJMWqZ6jURBAtIH0Yn5tpinoV5iq9TZ3TVYgD8KkEqn7Ki6ukPnCgE3r7qUHA/IJVsciQ==
X-Received: by 2002:a7b:c8c5:: with SMTP id f5mr2845113wml.44.1580976360718;
        Thu, 06 Feb 2020 00:06:00 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v22sm2637131wml.11.2020.02.06.00.06.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 00:06:00 -0800 (PST)
Message-ID: <5e3bc8e8.1c69fb81.38f3a.aeee@mx.google.com>
Date:   Thu, 06 Feb 2020 00:06:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.17-99-gbd0c6624a110
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 4 boots: 0 failed,
 4 passed (v5.4.17-99-gbd0c6624a110)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 4 boots: 0 failed, 4 passed (v5.4.17-99-gbd0c66=
24a110)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.17-99-gbd0c6624a110/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.17-99-gbd0c6624a110/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.17-99-gbd0c6624a110
Git Commit: bd0c6624a110d0f667cd2f3636f88e8de9b75851
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 4 unique boards, 4 SoC families, 4 builds out of 27

---
For more info write to <info@kernelci.org>
