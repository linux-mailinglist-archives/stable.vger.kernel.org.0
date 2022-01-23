Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937B0497376
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 18:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbiAWRKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 12:10:51 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:59302
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239167AbiAWRKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 12:10:48 -0500
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5D2983F1D8
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 17:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642957847;
        bh=la1WFYXOpR980qBpdVlXWePzrUe/p8xwwZIz/t/dobQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=qBxNMQeLQGHuY2T2ZXUlGYSyZ78z/Q1nbwNE1rN3rRh9fy/rmMNYi3doJYgE8ImK2
         iRD9lc3CHamYtgJhH5uvx4GA+Deqmy41bKzKrEBMZxLZTarM7Zx7s+MCjGGWpqX7S0
         JRvPxCp4NXkIKtzOMEmkriix/8v6tZMHBb26Gy8Uzpypt4C+X0sEWyCL5iDYUnf+7C
         O5cprVExNq2e5zpHFDsaRGNl/GLEJ1HSXZqSl+c54+9klyMjVYoGq7vEJ6qcEfXoCt
         GHocSt9qmc+C1+ZeS0B51jWKcy6f/uRidJuNwLE0PwER/91v3AdXe0PygWYGct6HDS
         lpucwI8XATmug==
Received: by mail-ed1-f72.google.com with SMTP id o10-20020a056402438a00b00403212b6b1aso11515115edc.13
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 09:10:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=la1WFYXOpR980qBpdVlXWePzrUe/p8xwwZIz/t/dobQ=;
        b=s1QU0qk2Bc4IjOD+NzckvgyukH4KgNtQja02TVM7B8vuL/EZBVkhEXtKMAKry+ytcq
         d3lldimY5OT9lOKGnhemi7xkgXDX/wL3o1ZAEcQqQpoR+G5ADXVG9U2TLWfX9oJ41TaR
         mC2Uc86ZZXrlmBZYHkMYNkrOWhlJ1jnURNMH2zgJftM6HUPw+kdCJyNhUdo1b9DhJ9aB
         kmy91+zwHAi/a3duZ1Vu5eOBEHFb6csfcrWihEVTBHfqspXc9JDDQ8abUWTsbi6o7tEn
         Cjk+CPU0iMY96HcenWfxz/uv6D4BqNkwk9WZzCh9zx/r2KHBSu5iUeXqaLaB62psGRYh
         EixA==
X-Gm-Message-State: AOAM532JsqfCh1YBaFt3YvOIMaLzkVsIQdYsRsEftdBWGjK6FlNGvoFM
        LosIbKhzYzMBHkQAnYU+BADQGsPViFdALA3lBsEcCE4VikzrXRmYCCNeZ9z4YY85o85+vyog8P/
        jktApz7i42FREtOFoGFYH2bDf4Ewv6vkIyg==
X-Received: by 2002:a17:907:97cd:: with SMTP id js13mr10256956ejc.196.1642957847121;
        Sun, 23 Jan 2022 09:10:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxl8TtHBHfcwF5UxjxV3/HnBay1hEnttjPhYwLLhuOy7PgFM4dopOI0Hwjx40uaPmIRHsxnFQ==
X-Received: by 2002:a17:907:97cd:: with SMTP id js13mr10256950ejc.196.1642957846981;
        Sun, 23 Jan 2022 09:10:46 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id l2sm5208665eds.28.2022.01.23.09.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 09:10:46 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-samsung-soc@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sam Protsenko <semen.protsenko@linaro.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: (subset) [RFT][PATCH 1/3] ARM: dts: exynos: fix UART3 pins configuration in Exynos5250
Date:   Sun, 23 Jan 2022 18:10:39 +0100
Message-Id: <164295777263.25838.13469745668860262642.b4-ty@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230195325.328220-1-krzysztof.kozlowski@canonical.com>
References: <20211230195325.328220-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Dec 2021 20:53:23 +0100, Krzysztof Kozlowski wrote:
> The gpa1-4 pin was put twice in UART3 pin configuration of Exynos5250,
> instead of proper pin gpa1-5.
> 
> 

Applied, thanks!

[1/3] ARM: dts: exynos: fix UART3 pins configuration in Exynos5250
      commit: 372d7027fed43c8570018e124cf78b89523a1f8e

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
