Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6656ACD9EF
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 02:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfJGAlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 20:41:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45611 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfJGAlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 20:41:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so13059336wrm.12
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 17:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=YbHG9iyH4j0VYIfMA/F37j5Dw6XERcBMiTFe13GZVaU=;
        b=QH/ueNttSFKdOeNg0HIfqLfHz1sgNuLwG9nCaLBAnPHraxXR3nzOgNoxzgEQ241TSJ
         /G+xNgDTbDq8J1XSYPu3xv1MaC1SpnlwT7zuZ2Pfedu2rp1oHNR6Qhf+lhTXRzN5FcZy
         VUNxHykmY5XZnmRvH1zz8Kx/tHXe2S5IQi9YbrihOjE0xmX1PCEpMiEygYN7pPzq6Ty5
         LYQo2KxYTC5T6/mOfvwwsA10G+Z/H8aGksYLUCugXjfqZI2FnjfZ7I+yca4FiA7/uMsa
         F9vBpo+dP1LGdoIkdHKcwfYKJvgDKM3sBYsMMIxk5y6OtqHoWON4gHVt8RPr0UwolRYR
         VpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=YbHG9iyH4j0VYIfMA/F37j5Dw6XERcBMiTFe13GZVaU=;
        b=Awr3GDxN/kgWk+Lozif/2EoL0DGiS5rU/E2qShaHQ16cUQ+vZ/6w+BC6qb0LXw2RZf
         mkqZzVUtGNe7FrCAFiu2si+IDQtEGJVAABSqo6mSXHSjJuCCICojl4zTJPyRW2UyU97s
         BCWYsraL08DzF6TewJl/j+Gu7VHf55flwlGQCQqOxkonhDf/yIWaxl8PJl1+ziil+nUO
         aH8Y/F2Iupni8dX8zhYlj0BX9VrCEpiNWr1fmPxfxBXKEf8jMtBoE8XcagjcVc1h/3xH
         hv4XIlldBBEnEYqvN64/BaYymfEaMIhSSiYcgfpESsBiItF/kT0gv2zoNnzTEvusoBTJ
         m7qQ==
X-Gm-Message-State: APjAAAV3cJyLrLhphl2iRJqowy3mT0ST7WSlpoyowMJ2tGjDKiOVTAZK
        wesKUc6FXE1xRNzKmPIgToQEuw==
X-Google-Smtp-Source: APXvYqzKiWT1xIuq2uklhjWUwVlKxV6Rhs9hAHUfTY4admUXuWNC5POPFALB8Mp4fiTIvZy3yl1kuQ==
X-Received: by 2002:a5d:69c8:: with SMTP id s8mr14269712wrw.32.1570408878265;
        Sun, 06 Oct 2019 17:41:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z189sm13498089wmc.25.2019.10.06.17.41.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 17:41:17 -0700 (PDT)
Message-ID: <5d9a89ad.1c69fb81.c692d.c9cc@mx.google.com>
Date:   Sun, 06 Oct 2019 17:41:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.195-48-gce2cf4ffcd94
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
In-Reply-To: <20191006172016.873463083@linuxfoundation.org>
References: <20191006172016.873463083@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/47] 4.9.196-stable review
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

stable-rc/linux-4.9.y boot: 41 boots: 0 failed, 41 passed (v4.9.195-48-gce2=
cf4ffcd94)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.195-48-gce2cf4ffcd94/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.195-48-gce2cf4ffcd94/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.195-48-gce2cf4ffcd94
Git Commit: ce2cf4ffcd946bd02d4afd26f17f425dc921448e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 13 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
