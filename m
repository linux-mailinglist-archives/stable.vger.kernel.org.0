Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D594DDDB9
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbiCRQIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238750AbiCRQH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:07:58 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7DB2F5124
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:06:29 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso4577207pjb.5
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=khJmslWv0a2E7utlqnjPzMacJa6IuPRCd0mxTYJBh1U=;
        b=0DVxrFONrhR4c/inQBopMuNWZodMHhcPWxPBl0acPr3k2jqQVNVAkqJ4ukMmXG1BcZ
         cEs6cEYAJzOxzJOLdFuDq54xrIICgSz2ElmodP6Q7AvQMBrPJZxzWL8jf+yD4E3tTJZd
         jjsPLmfHD0Cyeka2RzIf3oS1M/ce3QQ9iua1YlG4C9Jm43vpist0yT6hyUshgq6zicUH
         A7bWdOQNvN3e95RcPR+oDtTvgX4P9QUpxYMO5fkgKj3cmJGcIx7nC8PpNP7TNyUJOuJU
         3F///s5EsoVN1kJA1bsjjdPpwJ23/IJmNT2UwaNclr9BjRzaZ6pGN6ZyEkAUhsKW+rL5
         OxyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=khJmslWv0a2E7utlqnjPzMacJa6IuPRCd0mxTYJBh1U=;
        b=vARTk1hQs9RusMHZM9yzNZj43kitDOT6oDuRgHAmtG6/RengM5JG1f0pRb16ZV0umv
         1YxtSMgayOWkuK+8vYUHd0TEvrqMh7paFMIfCBhXIrwgtdIqHkrhA9Bl2zeV5zCIhYRM
         onYuUNEXLgAfOScXeyo5ZmWfC8pLHZl+IZ6K3zXy7f/J8xKjS6meYnweVir10i9H2nb1
         yAAwq+kQMErEUGLEq1BYmiqRkABCuHq3pbWdYdonDUnJHkclTL9w4gcK68Q5zDZ0Qe/X
         BM6KW60Mfep8hK/1BeSkphWqR5xfhNvEfFvCKWU2eEKw25ry99Mq5j1krrE6uVfRL5dY
         Z23A==
X-Gm-Message-State: AOAM53357Ps/44b0MdUF9aqvi/VopDGmJi98F2JoUqRt6uWEA6E6gDyu
        aPCuIocdck5Vrk8f24FrEcGALn4pfTD2KS51N38=
X-Google-Smtp-Source: ABdhPJwfDOnJSDQpHzq+O8AnrE7r7Aej2rZY5B11Sr0G0wpz3wPG2yojeezN/0r2jv0PDltjobYozw==
X-Received: by 2002:a17:902:9887:b0:151:6e1c:7082 with SMTP id s7-20020a170902988700b001516e1c7082mr140839plp.162.1647619588523;
        Fri, 18 Mar 2022 09:06:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r1-20020a17090a560100b001bf72b5af97sm8471411pjf.13.2022.03.18.09.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:06:28 -0700 (PDT)
Message-ID: <6234ae04.1c69fb81.4c966.78fb@mx.google.com>
Date:   Fri, 18 Mar 2022 09:06:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.14.272-15-gd7a314aa75d7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y build: 168 builds: 3 failed,
 165 passed (v4.14.272-15-gd7a314aa75d7)
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

stable-rc/linux-4.14.y build: 168 builds: 3 failed, 165 passed (v4.14.272-1=
5-gd7a314aa75d7)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.272-15-gd7a314aa75d7/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.272-15-gd7a314aa75d7
Git Commit: d7a314aa75d7de0e8d9ea07acfc6cb1638958eff
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
