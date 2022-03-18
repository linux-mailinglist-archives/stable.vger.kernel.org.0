Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0ABC4DDDFC
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbiCRQKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238675AbiCRQK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:10:27 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2269A954B0
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:08:53 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id o26so5358625pgb.8
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jAER66OF4cRcWE37wZcbZN00L7scL2/saewD2bkOgt4=;
        b=ljwrndoqpiPW1uk3azxna5m5cYJ4Ojm5YsLi1zaEr5FhE//HE3DejtlHntvry7X21i
         KiC+IBwWuSmwZJ/JG8iJDMwl9y6zy+jq6M9DOceyH+doWKzcLHHiMivlmq28ytICUXug
         UQSROdqcp7JIMBMjunEzyJSe4Hq6NfWffXsty9Em6xMh8+/2MlqKxmqJuUw+8VFY1bbb
         F3XAilrARCnsyxxH1m7zeVkIMS2Aqm9QcOUYNN2yD8JlOUduZy7DJKbOn3WNo1hfLIuF
         c8eNMO/MiPd6NDe6x+HXaonvCcOyz9ocjlXyFxxW/yWIn3Gv1Sq+HODwgMn2422dkNPI
         OmFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jAER66OF4cRcWE37wZcbZN00L7scL2/saewD2bkOgt4=;
        b=YZZZysRnDoMIkG0VdsT2lvYNeXG4ekqeGvT1wI7waDQoayj/VGUqbTOYZrLHxmof3P
         0h6n7UR3SBK/D7M1wX6xTl/PYlyGRZHkP++E1bYdaGqY6FTIHp+OF6dBDbbzrSkIaDZg
         o8Dn7Bg0XhI/EkQIIaDQZlo0KjDDPXhTXRIIYk3/AsbPm7Bukt9bc52OxHndoU33Jn5F
         4jDf8adR/WYiWlhn/tTNQ/uaL0g3EKOZDs+RgOXfyzgXmwXWSrZ/j18l20TFt4td3aIV
         D39UuACp+WL7LEhYIyFB4HbmC71ls+h4qMB72aFK5h74hhXLSOVL/HFNR/1g+gQofPq1
         t/QA==
X-Gm-Message-State: AOAM533whGanRKXGfp8vEyJ0e6bWLrzvDgaUjPLoCzta0ewOsbF2BnEg
        0RFXNrUwu20FVPlnFr1dHGoyZ0MziF5tFgVAR6I=
X-Google-Smtp-Source: ABdhPJypiZKEPAcnLvcYcN5ieuRO38BwDOg4cPU5OWgQtnoYCeWC0b46ukNN1kgzSXl8d2TPRQoWJQ==
X-Received: by 2002:a65:6d8f:0:b0:380:8b0c:a5b0 with SMTP id bc15-20020a656d8f000000b003808b0ca5b0mr8591539pgb.558.1647619732417;
        Fri, 18 Mar 2022 09:08:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mq6-20020a17090b380600b001c6357f146csm12851250pjb.12.2022.03.18.09.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:08:52 -0700 (PDT)
Message-ID: <6234ae94.1c69fb81.2b3a8.1bac@mx.google.com>
Date:   Fri, 18 Mar 2022 09:08:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.19.235-23-g354b947849d2
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y build: 186 builds: 6 failed,
 180 passed (v4.19.235-23-g354b947849d2)
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

stable-rc/linux-4.19.y build: 186 builds: 6 failed, 180 passed (v4.19.235-2=
3-g354b947849d2)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.235-23-g354b947849d2/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.235-23-g354b947849d2
Git Commit: 354b947849d2f1edefdf8ee4e59be400040363aa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

riscv:
    allnoconfig: (gcc-10) FAIL
    defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
