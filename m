Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561AB4DDE03
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238728AbiCRQKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238721AbiCRQKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:10:39 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE7EBF00A
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:09:07 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mm4-20020a17090b358400b001c68e836fa6so4264745pjb.3
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qGv7LmNxGLFQTl1+9gHfPI/cK984/yGDdgDydxgd90E=;
        b=HPLhLnErCzpr+WI7xtWFeTzy0ASYperLubEOziyMjoR25zh6/2Hxhw/qdGFso49Y0U
         zp60u53eKeqhiuuHVu3vadiKx4flN6nDcbr1qzfH+inEcp89/QZTP84xCDZvlpBR8RTL
         sjlGWqYgMK8fmrgBRtfiMPTruMMnB3RngZkfucC4z3N3KlFSWr/GuwE9PcjX9BdIwY/v
         kKPnH0gcPK/w5uUxytL9jTKHFFL2gAiFs38GMveBwP/Vcs0126e2I2SwdRGWzug+SMHk
         D6OuOuSVRCaB2K+swAcxGfwHJFp1yqSA5AlWRlWlilAd6qjNRqmKy+4CnJ0JUeljpMeb
         QC3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qGv7LmNxGLFQTl1+9gHfPI/cK984/yGDdgDydxgd90E=;
        b=3C5bgGTNaYASmWlO224IYzRuiWOqpHfh/3d67oJ4NHXRl7c91JItWEjNYq0TlglQ79
         MzPZaiIPEVdKj6kwgEeAoiQuNdZCnZsrEL5ib776F2WRMI83uMqF94GFY6ZuYGiyVZX2
         /fFpJWVU0slg4HLY20+SF9r6T2vurQdtsD9Zg0MR5Q30OkzTlUjrG/VaP7oNIoj+vX3W
         HHbfl5ZA+CZhxhcB9jUCGYaaOliDX3etFtZ8asmcdxMt1LOosAYOdsuX4EnoPFaYFrY4
         w6EBtYxcgNTt+RPCMHeUN1zN+Nx+HEz/Q4ZbxkMMj1dp3YTqWdY1I1csUJx1/UelXivM
         QS7w==
X-Gm-Message-State: AOAM533zdRoX1h2wpxPUJIR0tQm4yhLyTvV+sFx4AEVOyRabzc4hTynG
        MSjXGELZKVw7KN/4cRyuDk86EWXLmk8UiBn1G0Q=
X-Google-Smtp-Source: ABdhPJwqAzUZCUi/VL+S9C+4Ud9ioe3uoX0/ZBxnYoN+u9qY0UfZ3ljZBwqSxV7RmmSdAyAlL+kmwA==
X-Received: by 2002:a17:902:7207:b0:153:d860:5c8d with SMTP id ba7-20020a170902720700b00153d8605c8dmr172617plb.40.1647619746743;
        Fri, 18 Mar 2022 09:09:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z23-20020aa79597000000b004fa3634907csm6589050pfj.72.2022.03.18.09.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:09:06 -0700 (PDT)
Message-ID: <6234aea2.1c69fb81.a3aac.3df9@mx.google.com>
Date:   Fri, 18 Mar 2022 09:09:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.9.307-12-g40127e05a1b8
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y build: 151 builds: 3 failed,
 148 passed (v4.9.307-12-g40127e05a1b8)
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

stable-rc/linux-4.9.y build: 151 builds: 3 failed, 148 passed (v4.9.307-12-=
g40127e05a1b8)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.307-12-g40127e05a1b8/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.307-12-g40127e05a1b8
Git Commit: 40127e05a1b8d04b9483455e21ed8b447ac14eed
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
