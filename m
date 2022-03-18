Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089454DDDC8
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbiCRQJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238748AbiCRQH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:07:56 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254E02F5122
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:06:29 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b8so7752418pjb.4
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CxINv4//sUGgFCA5fAUyEVDyCkoH3Bu8pwjG9TTzphw=;
        b=DuRM53VkoasLU1dhFZuAeqpkUQKHbZdOaPUJy6te7ctuVwlC9jFe43PPeXZ8wu05jM
         PyDUqVUjDeGOnml1q8fgIfBwpslvTWL87K40X4Bo8G2jdQHH3fuCKizK78P4TKIhm/bG
         PzhJgPhKm5RzFe43XAix6p4Mdgi6kWsdSglKQwwodFsMQibiGfCPPBsGrB7wm9LjOxmR
         egXCJMZ1/HaueS9BycIbFbRQqae+sep0fBXXMN3Sd8s6LRTXeDq6jPZVDijpcPFSxAlk
         g56Nf42UT8U67eK3XaKzvx7oCQJm6RwPiZ0c0wAx7a5Zu7Yf5Jy4w0+v6df9r2qKBCzw
         uSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CxINv4//sUGgFCA5fAUyEVDyCkoH3Bu8pwjG9TTzphw=;
        b=6cpOYRfL7TtaaCN3C2CfDfbLag6XRlb+6fgVQGtUZcjNZ08fRn/gaaAzzUDDlzZKsg
         JPyA58B79gG1lOuzx3a7xgWcKoldWnnYppdydEenQ3+B5mGiN8hBvYAm/OoA3u3sCcSg
         BpcM0Gbs+PcwgHvdeDbdJuEl7N2WuFEqtZOEfeoZB6uU1KruRlEh+E4n2QBkUL6uSj7z
         GwKYryTF1aYejo9QFYyZQrB68E7Gu9UNtYkAWJU23Y0+6cxGhs/LNiUaibTmZPaJgBcZ
         39Fqvli9Re96QVbWznkDzHkVPX68jNW4j6xZV5oJH0836zkM0rAyqp7i9mXpsljQWcoj
         w3/Q==
X-Gm-Message-State: AOAM531sTjZbNNJ2ddzhOG1RoqjCSaPTFwAHB2oYHLVj4xuO/qqbQVQy
        V9tEcRhykbZwz6rFabfXRE+Y2Yhe6ZDWbLeTzgA=
X-Google-Smtp-Source: ABdhPJxIB3OgTkyHGLFar34gAn2fxNshr82rLQEeF1WXgEnVvaL9crX/xUolj/TZ1BUb/F1x6DGMQQ==
X-Received: by 2002:a17:902:e881:b0:154:b33:f30c with SMTP id w1-20020a170902e88100b001540b33f30cmr103196plg.161.1647619588336;
        Fri, 18 Mar 2022 09:06:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004f73278d1aasm9712369pff.138.2022.03.18.09.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:06:28 -0700 (PDT)
Message-ID: <6234ae04.1c69fb81.d8e38.b8f5@mx.google.com>
Date:   Fri, 18 Mar 2022 09:06:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.15.29-26-g1d4b468d2e8df
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y build: 179 builds: 4 failed,
 175 passed (v5.15.29-26-g1d4b468d2e8df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y build: 179 builds: 4 failed, 175 passed (v5.15.29-26=
-g1d4b468d2e8df)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.15.=
y/kernel/v5.15.29-26-g1d4b468d2e8df/

Tree: stable-rc
Branch: linux-5.15.y
Git Describe: v5.15.29-26-g1d4b468d2e8df
Git Commit: 1d4b468d2e8dfe717ff4f4991fa8f8decad564a5
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
