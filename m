Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE6B4978C
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 04:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfFRCjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 22:39:33 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:34546 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRCjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 22:39:33 -0400
Received: by mail-wr1-f44.google.com with SMTP id k11so12149316wrl.1
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 19:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6MlYYspqWDnAWT00K3QK0OmJwtfVEiE/zaEJ7q2XgJw=;
        b=m9qKQxNOu6hruhM8dpmUV6wPZabnCAcauCDr28Vjd5EhIvl/LjSu2JX5DOZw+bcL/4
         6OKHxlCcGJwXjqP9jurh9zUzVov9+AbKBxcRNVOrXs23J09Jr5MdSnL8heHOr2gspz1t
         jXqYO3uIUKHJTZBEmGMLpRNlNnS8UfBG32fZ11APHvmyPU5OS3DTRw74gLr4lw1KwEMB
         dUWd6oBnFAPU8RrBH/s6JGMc7s/z2/qNx/TTYbwgqs9aZrf8NopvwXhjaFKAkMoSBIux
         /ZpPnpZ/fu6RDQYY1BCZpbFF7Gi41DG1yMjt4sk6J1UcQlIkyMEeSUnsmGPCVqd/VO95
         fghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6MlYYspqWDnAWT00K3QK0OmJwtfVEiE/zaEJ7q2XgJw=;
        b=XHz/YHd9DMTTX0R5X/4a5srnHK5cizruwUGysc/wXwXVzEbgxI5PvqXFznik1k3tIW
         jUoTQBHMen/FVDNc234EJn3q+FUcf95M1FQQpRF/mZD3Ze6yHjlvIpq1CYxi2pRdGYy9
         TWXdhuYmKMMGzeMVB+ziTsxgjFul7OwAM9CWiyjG7RWCOjLWseUPCqlwuEd7R9e1HKXF
         CO7mo6yCKYOPlrlD7CtVulVYS765bbXNxj9uRHDUY3Q8yxqermnolqZVcDP0vMCP/mLc
         cSrDJhnGfGJxIMLJNjdQQ+N+a/Ucik5Ih7M9KWP2LJGGTNuI2dnTbn1y2u+bP408ZMzl
         n7yA==
X-Gm-Message-State: APjAAAUATJTI4RWYR9VapMcIIGNN6mAR4+LqXms9aYeJEArBmrJ6Wju7
        TlZf8drJrScSLzfPzJWAF4QA2omZay31rA==
X-Google-Smtp-Source: APXvYqzTc6CIHrDWzKf+Fw62GOg6j1VCia6eel0blZbQ7SCvC67CC5pkO2O7Jibz8/ODzttHTOcIxg==
X-Received: by 2002:adf:f44f:: with SMTP id f15mr11861361wrp.198.1560825571036;
        Mon, 17 Jun 2019 19:39:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v4sm1155016wmg.22.2019.06.17.19.39.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 19:39:30 -0700 (PDT)
Message-ID: <5d084ee2.1c69fb81.466f6.637f@mx.google.com>
Date:   Mon, 17 Jun 2019 19:39:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.182-90-g021209965fa2
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 88 boots: 0 failed,
 88 passed (v4.9.182-90-g021209965fa2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 88 boots: 0 failed, 88 passed (v4.9.182-90-g021=
209965fa2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.182-90-g021209965fa2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.182-90-g021209965fa2/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.182-90-g021209965fa2
Git Commit: 021209965fa293ecd1804422c3c4acc136f03dbb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 23 SoC families, 15 builds out of 197

---
For more info write to <info@kernelci.org>
