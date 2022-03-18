Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066EC4DDDC7
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbiCRQI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235648AbiCRQI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:08:57 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03028CCDD
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:07:37 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso4579845pjb.5
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kqSaOu7NmQfOM32pREeoi0gDUJjrzLBPsR7wNqtKutk=;
        b=A0brUywCJONXggK9boC0XUpvGrTqEeoSwOp1U3KwsKYkh4LbdBFNkJhFciWybiZJO0
         raGST5vc1gt16Ln4oF6sxweGczdDbPmcuXjFKdBfbi4mNb+buXW4t8OdEUyEUeqjOQNP
         lHWEKetOHmJJJixjK8ErnDo7QprYcMc8nJesvTXM6qdShTGmBb06ZZGdlJg99cClqjrE
         XisjUzRXr6YqdcaaITNAvsA7M93BuXSBbq5r1AjmPBWreGcTDSoPF1wUdfztfp0NJzod
         GNEVG/qW10VCv1awFS8UF7Wpu+KXJxTTrCDFrullR26qaDS5xBoxFtPlpAzacwPUGKnN
         HOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kqSaOu7NmQfOM32pREeoi0gDUJjrzLBPsR7wNqtKutk=;
        b=MKE0MTbNl/6Da3lMZmvUmRziQVtN7rdCCrnx/fCJEjZ+YNBNgAPCWBJ0g8BL7nloHq
         d0nuFHxOTp3aJ+7HSp4jUvzfbO340wWc1FsdHHCrkNL9L9xNR3evEdQI9OHsglYAqqZ7
         EWqovtkCYQve+IHi0cdfaNTLfjHpqYuxMoG17ey0TKWWgE42XWWgZLKoxznHgDr09SAk
         +cRHv24Al8VbedIiNmab9vcGqoXkVTOWFg4epQBu8nX4zHInRc6Pso4sV5VY1efb5NRu
         DuU6oRHmOkXyCbtPNOUeVFub3OmVj6aTgkzy06pYpVWth9AVNjRPwOzJeO0W6KZrdGiv
         lQBw==
X-Gm-Message-State: AOAM531JQPuz7ilQ6LQncqSuNHqzhv1Ot+HqeK5zCeStQvgiOUf13O7Y
        4RhkMOxmQeBj5lB8D50R+5KihVgwT0J8fNeW21Y=
X-Google-Smtp-Source: ABdhPJwKisrQIWyRtH2XRmFbLNuOQ/uKg0BYWawc+IajR5+Y4OxsYjeuDjODag6+LJfnYNphltzyfQ==
X-Received: by 2002:a17:902:f549:b0:151:f9ce:4ec1 with SMTP id h9-20020a170902f54900b00151f9ce4ec1mr139672plf.3.1647619657150;
        Fri, 18 Mar 2022 09:07:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm6187369pgf.17.2022.03.18.09.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:07:36 -0700 (PDT)
Message-ID: <6234ae48.1c69fb81.2c1bc.1213@mx.google.com>
Date:   Fri, 18 Mar 2022 09:07:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.10.106-23-g791a445a0751a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 build: 166 builds: 3 failed,
 163 passed (v5.10.106-23-g791a445a0751a)
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

stable-rc/queue/5.10 build: 166 builds: 3 failed, 163 passed (v5.10.106-23-=
g791a445a0751a)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.106-23-g791a445a0751a/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.106-23-g791a445a0751a
Git Commit: 791a445a0751a5bf3f0388c73d51d06657c0e94d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
