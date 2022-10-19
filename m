Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3163603A50
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 09:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiJSHG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 03:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiJSHG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 03:06:58 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E4B7549D
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:06:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c24so16107668plo.3
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ERNLQo/LHlcjLcS9hvMmRlM0aFZCtBSGR2KhWHung6E=;
        b=gYN/TEgGyWBL7EOlcnBWw9YvHnqJU+3ngjQuBGeSwQZy8/ptjHFF9kx6DRYEcB3lBB
         MiEkxo/kaGoXrQ2pEzuwaLPK0o/sFS6ITam2Vxixc9ta67/0unIAL7oYjTM9SiGgC8bL
         qKWvfws8I6zo78WKZungDvdv4a3ECSIpAycNmz1d0SDguT3Rs2ZnlqHmxabXw/1mbRsn
         +PpbgurrobOSrYSGwzlCa8tzZ/Z7vHn2eFRZBuml/EUD1iP/in6PDriaBBkVLgAs+Qc/
         M1IbkexBC1AQ0Oobvfpx2QFWVx8fzsQpVKV8VPgMKGmv5YQu5tEdO/Kb1+OfFkzM5Gm4
         V1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ERNLQo/LHlcjLcS9hvMmRlM0aFZCtBSGR2KhWHung6E=;
        b=B4mo1Nz9p0Pol9YNQCiNJriRG4tSVD1OcLnCQ5OWYaXtG9pxHDQ6/Hh9Cr9OlV7iEe
         IIxPyemvbMZoDCpvals4j7ibekHUsfqYL7o0Ug3MASrGX6oKO82hwQYAp3O4/Mi8sQMy
         wzoY8Q4HAesCvL3YbQX058MSA8Yhvvc1VBEpmOKIoPIaiN2q8rc8yWir1BGNJh+iQJjI
         mPpc+wno0y6T1ved830xtc+rOecvuKUSc52hTi3ky3zWYcfj5+NwvcinsUaqR3goYTRP
         VnstU8NMovmP5wEpDO2xx7lIGYGT4a6H4DEeXv8PSY5y571CWxnBZBrMauSAlyOfxuo5
         wQKw==
X-Gm-Message-State: ACrzQf3SO1uA6KVZUdPz4Am2zgo5hmAbdotfkeBb2JRJZhZHksrYn9MX
        R6BJ8Gf11KnJ8JzdLngl1My1EF+exd/mGIG4
X-Google-Smtp-Source: AMsMyM5HLMBWAjnyLxNCva+cxSNgi2K0Y+Xa3cFOH5eHJzv2bOzmlgCEauTKXq+GM4Ke8pz8/OKUwA==
X-Received: by 2002:a17:90a:c90c:b0:20a:7179:b14f with SMTP id v12-20020a17090ac90c00b0020a7179b14fmr7935456pjt.58.1666163214434;
        Wed, 19 Oct 2022 00:06:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j5-20020a170903024500b001853e6d6179sm10005310plh.162.2022.10.19.00.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 00:06:54 -0700 (PDT)
Message-ID: <634fa20e.170a0220.ee5f.2ba9@mx.google.com>
Date:   Wed, 19 Oct 2022 00:06:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.15.74-600-g23ade3cda2fe
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 build: 180 builds: 4 failed,
 176 passed (v5.15.74-600-g23ade3cda2fe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 build: 180 builds: 4 failed, 176 passed (v5.15.74-600-=
g23ade3cda2fe)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
5/kernel/v5.15.74-600-g23ade3cda2fe/

Tree: stable-rc
Branch: queue/5.15
Git Describe: v5.15.74-600-g23ade3cda2fe
Git Commit: 23ade3cda2fea45f82e070d74ba41df7a1e390c1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
