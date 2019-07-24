Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8326E72404
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 03:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbfGXBtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 21:49:52 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:33527 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfGXBtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 21:49:52 -0400
Received: by mail-wm1-f41.google.com with SMTP id h19so32302444wme.0
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 18:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3aGFgDhwTA5wUoFDDDNJ3JyhUvO9qoBI4BoGsRPQfaM=;
        b=iHe0ZB8urMZE2Un0GISEB6JriUGfKePuj+rsD5psXJq/NS5IhNbAv0U0Kj73hceW1C
         0jzh3IVONPYsZPiVlIyFaIa4AAnmB6HPTWDHS5hew6b+b7TDNFLnScOEAENrTedFWyfb
         SnKLrDxNfQSVu0dsFCityZ0NfnoCCzGUaTeRBuYXM3XwRU6QFWoAs6vi3mLoh6c6+yVu
         xqZgtYAawQcjmT9Y8dQtLRkpmRyuHzl2Znp/fFuw/uGilB2qqz4rZguKA5Vg9eJ5zWP1
         UktEvvrzT8V1QwQzVoLKSKbvLO7+B1AsM/1Ij7X7kyUUvqB3AIhKTeFnYCP8CpQLC6pV
         n6lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3aGFgDhwTA5wUoFDDDNJ3JyhUvO9qoBI4BoGsRPQfaM=;
        b=QZ9bNI19qv+aqQlSKCutIRk170vRE9F804qEf/XCkt/Ma3r8DVqLME4IpzXKcdlRVA
         CmzVEBMP2w3UfcjsUUD7vFj2glH+6c/KnZm9uNUpAy1zlJ3WjFK5taxgZq0UMLlC4Auz
         WiKs/D0wGs0NJrXOxnR7xVjSG/FNAfP144rO9HLECcXarYR8Oya0OsbMw9df4overLe0
         5Lw43xdf77Y9CJs9AgN2loVrz9KprH7u87P9n4zMGoT9pMUR/taxi5UbAnrz+kBUZhBQ
         AbxNcMHy27PP3Fpsktf0bupI6Eq1LTVW9kx2PoTGtk2XWleyVRv8MOfPqrcp/ZGUNJ1S
         JBig==
X-Gm-Message-State: APjAAAWnM4j+2KWl1cbU17FoQYAdXYMwNKfCYHZI/pCC1td+9yN56YR0
        KFJIOE7WQNQCfTF/NGUbfOALx7nVhXg=
X-Google-Smtp-Source: APXvYqyrKFZgb3+FysUwsW40vlEU0zrHbaP7vG6ARSsk2rBtCKmV21YanV/k6BH8YCUeqOUpOXsLKg==
X-Received: by 2002:a05:600c:228f:: with SMTP id 15mr66213934wmf.60.1563932989919;
        Tue, 23 Jul 2019 18:49:49 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z1sm47047504wrv.90.2019.07.23.18.49.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 18:49:49 -0700 (PDT)
Message-ID: <5d37b93d.1c69fb81.32ef2.66a3@mx.google.com>
Date:   Tue, 23 Jul 2019 18:49:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.186-108-g5b3c7cd16340
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 97 boots: 0 failed,
 94 passed with 2 offline, 1 untried/unknown (v4.9.186-108-g5b3c7cd16340)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 97 boots: 0 failed, 94 passed with 2 offline, 1=
 untried/unknown (v4.9.186-108-g5b3c7cd16340)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.186-108-g5b3c7cd16340/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.186-108-g5b3c7cd16340/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.186-108-g5b3c7cd16340
Git Commit: 5b3c7cd16340750b459a835cbd35f9ce852ed1af
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 23 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
