Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C1BED660
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 00:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbfKCXW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 18:22:59 -0500
Received: from mail-lj1-f182.google.com ([209.85.208.182]:44521 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728144AbfKCXW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Nov 2019 18:22:58 -0500
Received: by mail-lj1-f182.google.com with SMTP id g3so9470258ljl.11
        for <stable@vger.kernel.org>; Sun, 03 Nov 2019 15:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=A7f7kc4Or8nejtGZcNFcOsvUo0Y1VRFgoBZiZOLsbLc=;
        b=XYP79ta34j0pD2uxWxo5iJSMjy2VPx0GMlmhNO+XFSGajwFAYduTtQ3wNBK8ewpXmK
         kjMv+IOmgj5jdZ4ztwnoBddz7XKGJmfjVbVULzW67g3CFzVrhOuq9jQp/kdLWuW6+Lm6
         apTp4FVP6zZZAYj49XMYj90Hwn4sFj6uCDSm9t6ylMlvunivFUQhbM9rA/OZFMVA654A
         InYuxme44Ws7d29EX5tDJ89/2r8hQv/qe+eH081HHXBvnAexGYtEEWmQhI7jgSJEbsgP
         gwlsGhyIZ1TNnkxxp7t+RGO0UlrUjMoTJ/zS2xSgZ2I7jJzVMQRjYCc1gvZ67D5tnyAa
         A2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=A7f7kc4Or8nejtGZcNFcOsvUo0Y1VRFgoBZiZOLsbLc=;
        b=MLOyHWjX5TJ8RQSb1lFfyvCEuO8MHq0kENEWQJXQEKcNLZZsoDt4t+KkmHLLStupG4
         Gu5NNLHFYFCHrZO5dUpMl75wMg/8EMmrlJk0YZJuZalKREkhHbe7gKGK3/xdl0ZaT/0Q
         uOrsj7yc/Ej9aXPbzgNA7FqVnf2hxn3GPKVHqNIyZjLjAbQarNBKZ08xBxzJtAHy+Ujf
         E9dXZUlv2+wWUYDYP8z53lq6FQYpfQIbootFyucosUUH3k/2qkNGLbtvPIwca0EimNWs
         3F19V991/D9Lan/MnV+j227pK6C8WvEjWr/HCY04nweJKX7Iok5w7BA5NN2w1BvJLHfB
         NQDw==
X-Gm-Message-State: APjAAAWQjW0eLd9XfsJYUaxxyhrm6qhrqq1+Veem9JRFExhQ9imte2vD
        G1LUeUra4VaHqr3HKJ5QX7HPBhdHSr4jY2yodFL+wQ==
X-Google-Smtp-Source: APXvYqwX6VK4SW8IcAEXtL4RSvaL1lf1vcXSiHNSDs8/E3XSjpO1za9Mwf5F70cn9ZAtvWejPgwT2Elwgqlb82FKVN0=
X-Received: by 2002:a2e:814b:: with SMTP id t11mr16972488ljg.20.1572823376318;
 Sun, 03 Nov 2019 15:22:56 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 4 Nov 2019 04:52:45 +0530
Message-ID: <CA+G9fYtoODTuayzXdsv=bFuRPvw1-+dmZxHqQePy6LX8ixOG5A@mail.gmail.com>
Subject: stable-rc-4.19: cpufeature.c:909:21: error: 'MIDR_HISI_TSV110' undeclared
To:     Hanjun Guo <hanjun.guo@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux- stable <stable@vger.kernel.org>, john.garry@huawei.com,
        zhangshaokun@hisilicon.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, andrew.murray@arm.com,
        Dave P Martin <Dave.Martin@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, suzuki.poulose@arm.com,
        will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable rc 4.19  branch build broken for arm64 with the below error log,

Build error log,
arch/arm64/kernel/cpufeature.c: In function 'unmap_kernel_at_el0':
arch/arm64/kernel/cpufeature.c:909:21: error: 'MIDR_HISI_TSV110'
undeclared (first use in this function); did you mean
'GICR_ISACTIVER0'?
  MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
                    ^
arch/arm64/include/asm/cputype.h:141:12: note: in definition of macro
'MIDR_RANGE'
  .model = m,     \
           ^
arch/arm64/kernel/cpufeature.c:909:3: note: in expansion of macro
'MIDR_ALL_VERSIONS'
  MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
  ^~~~~~~~~~~~~~~~~
arch/arm64/kernel/cpufeature.c:909:21: note: each undeclared
identifier is reported only once for each function it appears in
  MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
                    ^
arch/arm64/include/asm/cputype.h:141:12: note: in definition of macro
'MIDR_RANGE'
  .model = m,     \
           ^
arch/arm64/kernel/cpufeature.c:909:3: note: in expansion of macro
'MIDR_ALL_VERSIONS'
  MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
  ^~~~~~~~~~~~~~~~~
 CC      arch/arm64/kvm/inject_fault.o
scripts/Makefile.build:303: recipe for target
'arch/arm64/kernel/cpufeature.o' failed
 make[3]: *** [arch/arm64/kernel/cpufeature.o]

Build log link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.19/DISTRO=lkft,MACHINE=hikey,label=docker-lkft/331/consoleText


Best regards
Naresh Kamboju
