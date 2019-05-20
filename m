Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30D624131
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 21:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfETT2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 15:28:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52862 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfETT2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 15:28:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id y3so503714wmm.2
        for <stable@vger.kernel.org>; Mon, 20 May 2019 12:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=1w+fH/v8RBSWF87o1Wwaj3X+JwCU/nfmU+CgH+VdYgw=;
        b=eeQIySQgLbMrJSxJsZ6JOx3D+Ejh4BCO3Y4Qdnke/T2NRm38tXjoFDz/d46/Cp7k2C
         T0Vm/Q0GIA8yDkRmORwFqdq39y8VjKE8BNOgPnopRc41662JICup+Ilf3qIjsUwdXbv2
         5uQ8+wXgnJQsSLHm5IUX3nCE5XD5JS+xl+KmXeOGKf3EDa2dY4s/01kFqPj+4YKFyV6d
         CXM2r3vLWYRqu357RIcE73alx8nrHlxqJ/W8z3bmONPkVbp51zJesKTg5E4MizdlYMcT
         Yk1T1XNlN4vKJq1uHqW1WMm0sVKULdehIcG/5/dpWXL4kw0L+OD4tJzvkZLamF2i2ve7
         bzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=1w+fH/v8RBSWF87o1Wwaj3X+JwCU/nfmU+CgH+VdYgw=;
        b=dC0GRYBNMC57cY3UmbgZolHHMU/OIdHr+YDbECyzqsWkqsXMVF+9V6JzWhik1awJfx
         8jUvrMt6xN/t/bRBEBu/8B84UKfKAzWFJ6M7McvOnqBS4HVTcKfqEHkXUyB7AeRM5dvu
         rqcNrNbHKNFsvDvPbtuWzbcJMnc6cH8Ym7qtLsiyd0ESMMx9ArnG4DXRkFESk8WGW9cq
         PcyiADKuyIDr763n08fUX+jnBA25tBEJ4a5OihOEW4RGfHVYNU4qA3a2mIBu7vmsRRT3
         3vprhSvWoCl1H4byqlDdCE6XMIjiRm4z4mIZSQ+qct1S2nPvuUlvNh2lvtyBs6ctZBaN
         MvvA==
X-Gm-Message-State: APjAAAWDwFSWLch1cpeDzlxd++0PCFqy527T/+6U/bX2NJbJ4xgd8U4G
        6DRA2/saqym7xvQ6HtBPreCXFQ==
X-Google-Smtp-Source: APXvYqxeci9/TiZ7dSAkbs+57L8vtptqQMe2a7YDH/o2FHva9o7HtVHYQTOg5CIhlxZe0WQ8/WQgAg==
X-Received: by 2002:a1c:7d8e:: with SMTP id y136mr481983wmc.129.1558380496475;
        Mon, 20 May 2019 12:28:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h14sm17334290wrt.11.2019.05.20.12.28.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 12:28:15 -0700 (PDT)
Message-ID: <5ce2ffcf.1c69fb81.2ec6f.f3a5@mx.google.com>
Date:   Mon, 20 May 2019 12:28:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.177-45-g1a569b62b013
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/44] 4.9.178-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 94 boots: 1 failed, 91 passed with 1 offline, 1=
 conflict (v4.9.177-45-g1a569b62b013)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.177-45-g1a569b62b013/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.177-45-g1a569b62b013/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.177-45-g1a569b62b013
Git Commit: 1a569b62b013b75248598605647b0c077a399c5c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.177)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.9.177)

Boot Failure Detected:

arm:
    qcom_defconfig:
        gcc-8:
            qcom-apq8064-cm-qs600: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
