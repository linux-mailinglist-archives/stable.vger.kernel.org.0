Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9352F881
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 10:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfE3I3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 04:29:08 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41879 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfE3I3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 04:29:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so3553365wrm.8
        for <stable@vger.kernel.org>; Thu, 30 May 2019 01:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=WtCAXTwAkrdeG9KNtGkpEqVQZWYFaR0KgJ5gewK+STA=;
        b=grcgzb/UzF2ls0EnJzcideiHokQRVDVYCYGmMCvfKcs+7W39Tnj+o0pIyS0Bm7y075
         /Pug7pPRpNyr49yzNY/9ZbGHvcPqv5d2rAkktHJjZvu54/iPW+myVW67C5iqzoK1b1fG
         t4gURqB2gHjljY/+86c6Y5Gx1AvSaC+Scwn4xvd7UcfDgXlWKCefPOEMhfeDDXEq5Sq+
         rqlkHuhJ3hdjWZiA7UQ9w9T8Mik0sN4jWOMlOcH4qXxa/s+TO2xBm+/hpRB02CwpBHwx
         bO+mi8T89eDPdmRs8x1C617mGH91oIX1LtR+De14ASMwR+t8Fqgiz+CA+NaRvgleGa6h
         9uGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=WtCAXTwAkrdeG9KNtGkpEqVQZWYFaR0KgJ5gewK+STA=;
        b=t2mwl4uHGtOevY1cVF8/sTcUOgrAunfaNqfq5rMs6sqI8yN2utFJ/aOvzwjTueVOEa
         96BAM+nkzQGesMAIMXhn4YA45OVn7/+C8ULDVb/weuyNDuJufbpKpNEo0E1kq9MCg5qk
         fcirBUdO1XRC3NwRz498AQoDN/E9xpzBbXtFZ47oaoF4QHy9GZe5OxH9OYP4tnYdv7PD
         aV+zHnk/O5kJxgXFqRzEkWAHGRz48hHB2LiS4HJ8UZY0y5+EQBJ9oHpwmOUV6FJUABKK
         xoCul3E54Dp9taDnS0WXeBP5dE8Yipge+5L//iBe2yvPU0W0XyiRXRMkqgP1ccyJPO9E
         Inuw==
X-Gm-Message-State: APjAAAV3fUM7x3jYOvvg4S4vSCVDoLLGwsbYrWPpHh6XOimnySCheqEH
        9C2Fn2QRwtdV1gHvqtn90mlPsg==
X-Google-Smtp-Source: APXvYqyDX0g+5H2piWndoNx/n2oKxpNw4/2WQvGSl3zp6MJmpGEElf9g+/b63V7Al/iOEXPiwO2cxg==
X-Received: by 2002:adf:e705:: with SMTP id c5mr1736190wrm.270.1559204946458;
        Thu, 30 May 2019 01:29:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h200sm2849400wme.11.2019.05.30.01.29.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 01:29:05 -0700 (PDT)
Message-ID: <5cef9451.1c69fb81.5e0ac.e557@mx.google.com>
Date:   Thu, 30 May 2019 01:29:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.122-194-g0352fa2fdaa6
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
Subject: Re: [PATCH 4.14 000/193] 4.14.123-stable review
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

stable-rc/linux-4.14.y boot: 115 boots: 0 failed, 115 passed (v4.14.122-194=
-g0352fa2fdaa6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.122-194-g0352fa2fdaa6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.122-194-g0352fa2fdaa6/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.122-194-g0352fa2fdaa6
Git Commit: 0352fa2fdaa68f3e27866e6f6a5125aa9efcefe4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 22 SoC families, 14 builds out of 201

---
For more info write to <info@kernelci.org>
