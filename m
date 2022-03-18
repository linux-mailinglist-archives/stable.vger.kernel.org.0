Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963B74DDDC0
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238543AbiCRQHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238505AbiCRQHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:07:21 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A805D103B8B
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:24 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bc27so5347324pgb.4
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZQxuTZD5FiurqR9dA+mKTZ4EzmXDyqKCYv7yVXGkV9c=;
        b=vtknCJzmIhrr1941YgOwoMeWPQJK9XdJZpVlxnJfqFIn5bEWUVnmkpBmxkR6HChSOb
         KBDj7oNFvz815eCDs8C72oLRQxcMrdr3rzgptMA/ON91nPB1IJhn5NruXzAw2uc8NFZu
         Qj3txRO9RRTa/a8N3u5k3oj0V3y3r/ZUUtYo5USFxiBGNGNagmjRCYPEu5A1wmNIXCs0
         m4OeAj81NwM/pm3M/HuPaLXczZLqsk3qJST/p5czShXyiP5MjqOgMNZi+CfD2y+pjnyJ
         Dh3TY8liGkxlgAPdetyiHdRT8f9OAFHey0lQ5HWvLCL54Wo1pKH8baAK11xCK6jfU9h3
         aKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZQxuTZD5FiurqR9dA+mKTZ4EzmXDyqKCYv7yVXGkV9c=;
        b=L/XYECEB1ax+JzouGtnT5vfUAQj7scecAwpJdINX8djxpbiEfoxYJm9J1WvWnwSj8t
         Gg4XUOEPZFyrGGSoL6Nah4N5BVgbY6MGTMhlNHFWHG86os2HK+hjCvUSj4x8GRU3L8iD
         6VEQ9vJQ1oshT4FD6nJDnFpwtH+5SjT7a2R2n1jx/0gBgZ64UFgMou53IlfkXAOkYTx3
         MQ3WCnefwesND8pba/mCgb1IA8NRFxb4qGXWg/xl+9ZmKvIeUtFzJFApAC1biCF5mob1
         c5Is8jvu9fFxf7RqwDqFMBsnGeJvmOZJPEzlh+F/MoobFSrbv2I8MttILJqW1KkmqMiY
         Ek0A==
X-Gm-Message-State: AOAM530mK0nrS2/jxpZyBxEPdhrmsMd6FOzkMg8g7FaIbmtL8T0myG6+
        IuIr24SPM4hDdAYWzN/N7I13qdjtgPeoWZ1UlIU=
X-Google-Smtp-Source: ABdhPJw5UmPICPE29jteBLxoyEweBoxqGkWqrKgLnTv/EUQB+dtI13CqeqoeOenmPhzD5wefKPho7g==
X-Received: by 2002:a05:6a00:b86:b0:4f7:8a93:e84a with SMTP id g6-20020a056a000b8600b004f78a93e84amr11107745pfj.74.1647619523994;
        Fri, 18 Mar 2022 09:05:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s25-20020a056a00179900b004f737ce5c1asm9832473pfg.73.2022.03.18.09.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:05:23 -0700 (PDT)
Message-ID: <6234adc3.1c69fb81.30ba5.abe9@mx.google.com>
Date:   Fri, 18 Mar 2022 09:05:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.9.307-12-g907431a01b501
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y build: 185 builds: 3 failed,
 182 passed (v4.9.307-12-g907431a01b501)
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

stable-rc/linux-4.9.y build: 185 builds: 3 failed, 182 passed (v4.9.307-12-=
g907431a01b501)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.307-12-g907431a01b501/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.307-12-g907431a01b501
Git Commit: 907431a01b501aa43a2378f95507ba89f652a315
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
