Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5694DDDC3
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbiCRQIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238826AbiCRQIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:08:07 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626072DF9
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:06:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id m22so7813411pja.0
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j33W7rZo7rJqMmfZzwJhmoZ6lWr+VkgAJHd8pEBXfH4=;
        b=wQwGaCtmPu/wZ4gMpI1sKG2hDkkm/btTnqWTqSXeIabRFJWJV+lB72N6vAY49OBLgY
         qmvYcUn5iVWyDqUha6L9Tct0InB5E+Ox9trcEvMojmSnyzak5YWM7d2ceVLl3Zm9CmeB
         gcTHepldGB72FtVcprIC1NAYT4DBLG2CT5jvenB7d+qGAFEWPhz8KxFgYbi198kYwKhS
         vM3zt4Q9ahHYW9F/KsocmGHHmzdtYSsZ3DY/NhB0ER7vokjSn54A9gHj/U6t+Z+svHR8
         b+9+QM6J8SnQs6BjEELX+bMEA5EWjkwuDCc/f6oPP/acbz2Qh9PptiqV2KRy4TYUadpd
         JP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j33W7rZo7rJqMmfZzwJhmoZ6lWr+VkgAJHd8pEBXfH4=;
        b=G7yEgs6mvY1wPwn90Ev8QLRwpmqoIW+8+ekLpI6a0WIjLL79AB9sDzGUy8O5xENuEh
         sdEHyquFR2YcTrWnpggIkJvHM2dKyhPePMBcpt80/f5a0+6TsfFGlAPTAX4jn6BIvYmt
         cNiGXsBefS8Mx/Lep7fX0gcsfGUFE0TM8FJk+nTEl6043a4gd9FD9SRrimbMiW0rBLSd
         4+Rxef+O0tUwCB1V1Owk1sySH+9n0j5hvYRIIA4rbBivvNTR2nD0DQ+3rAYDRhM6/s2k
         CcKtOKFS275b8swwj4gGpRm16/Zq8P78jIEQs7CaMS2D6JmmY7TyV2XOgPAcTJERQh56
         XEmg==
X-Gm-Message-State: AOAM533Zd+kKO06g4p0xXxIgdARpJYi8WiH8HnarsXbziIdxwB8adSJ6
        wmpeMhrCXvvN+SCeWa/FDj7OwU3LCaVzpdEsKQ8=
X-Google-Smtp-Source: ABdhPJweXtXENm5bSNg8U3Q+96qUo8BwOiR+CQXQWpbV/7M3fNN7gWtFndxDL85wYc8h6nABmiTDfg==
X-Received: by 2002:a17:902:9043:b0:14f:aa08:8497 with SMTP id w3-20020a170902904300b0014faa088497mr116057plz.109.1647619608812;
        Fri, 18 Mar 2022 09:06:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w8-20020a63a748000000b0038117e18f02sm7869806pgo.29.2022.03.18.09.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:06:48 -0700 (PDT)
Message-ID: <6234ae18.1c69fb81.34657.5865@mx.google.com>
Date:   Fri, 18 Mar 2022 09:06:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.16.15-29-g106ac438092e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
Subject: stable-rc/linux-5.16.y build: 152 builds: 4 failed,
 148 passed (v5.16.15-29-g106ac438092e)
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

stable-rc/linux-5.16.y build: 152 builds: 4 failed, 148 passed (v5.16.15-29=
-g106ac438092e)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.16.=
y/kernel/v5.16.15-29-g106ac438092e/

Tree: stable-rc
Branch: linux-5.16.y
Git Describe: v5.16.15-29-g106ac438092e
Git Commit: 106ac438092ed9bef8fb4c61ec6ad5aa9eedda32
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    qcom_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
