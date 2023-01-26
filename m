Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FF667C84A
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 11:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbjAZKSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 05:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjAZKSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 05:18:21 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F188A2B607
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 02:17:53 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d14so1228553wrr.9
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 02:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gX+LKNBBd0TCFQEbM+9w1gF9bM8Fn+Ho3vWnyUzdN9U=;
        b=UNeJC4oLGxGV6K0b1cREoESOX490a9RyUKFU2tYqhdRSeiZbK+6WvYIXYoP7mPcdzy
         c7L3C7Df4h9rhDdgmceAxXXAbnTCbveCYosqBzw9H55cTQE42NGs2l/hPjeBUydSy3MJ
         8i5Uzur0+Vqy5OhXwBoH4ZOLkxKn5AsFozMiCVhhKFduASVE9gBFvdLNWoOlJVc7jR1B
         bi2izNAotFTgGY0hEj+/5slLXcS3ABW3VaAWOUZmfCB6Gx4MpLSzA50ii1zX2HbvyKtw
         xuZuXzCq46+P0AYKZijs0qmDaiKiWsLTgEGT1KlaaivUBIGNpuaFBGqqoi+OYA2M/b2P
         TA9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gX+LKNBBd0TCFQEbM+9w1gF9bM8Fn+Ho3vWnyUzdN9U=;
        b=QtTFLTKfkKCnTptE6CLNY6uwbs64Q6Yur0GiKBCt0XYEkDpkTDgKXXkdsY2f/3fnbQ
         8vIg0Ij2gh2sLhX7PATM1Z5UURPav25s3yzLlN4tksMpfkA1zHMPdhoMZRfJdZ8FdYgw
         NRIuZU4m2apuMOdPRb0oeo+rOKq8HS7eZExvVVguBwHmdM7LjaSC1QcT4PhqGn0GJPE3
         g9kXNhFnCADkFyklx3mu3rqLFEGXvKj4YjO04ZfJV0+sgOP7MibMzeQZjSXl/EPQ+ZDy
         uXvRSAOmAIWVPhTLfnMLOU+0uWQ0HCC276OSpMgnaYJYJaexu8nfX97Nf95p5cEoiKXb
         1qZw==
X-Gm-Message-State: AFqh2kqC41vTrTfL9lx8d7F5VzrcqfCusLY7CrqPDD4P2610HTq8Niva
        u/Rq2iMWZSzsWfAd5UzBK/0SIw==
X-Google-Smtp-Source: AMrXdXvEFI5TvxzETFU4jNAsX9qS5b6ju5otetH3GyAo3/sRdU+V4D2C4D9H4GVT8bZhaue5/z1xDQ==
X-Received: by 2002:a05:6000:549:b0:2be:184a:5d5c with SMTP id b9-20020a056000054900b002be184a5d5cmr26978558wrf.59.1674728269636;
        Thu, 26 Jan 2023 02:17:49 -0800 (PST)
Received: from krzk-bin.. ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id a17-20020adffb91000000b002bddac15b3dsm868315wrr.33.2023.01.26.02.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 02:17:49 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Kukjin Kim <kgene@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Cc:     =?UTF-8?q?Martin=20J=C3=BCcker?= <martin.juecker@gmail.com>,
        Henrik Grimler <henrik@grimler.se>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        phone-devel@vger.kernel.org, stable@vger.kernel.org,
        replicant@osuosl.org, ~postmarketos/upstreaming@lists.sr.ht
Subject: Re: (subset) [PATCH 1/9] ARM: dts: exynos: correct HDMI phy compatible in Exynos4
Date:   Thu, 26 Jan 2023 11:17:43 +0100
Message-Id: <167472826059.11433.4862099125133476526.b4-ty@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230125094513.155063-1-krzysztof.kozlowski@linaro.org>
References: <20230125094513.155063-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 25 Jan 2023 10:45:05 +0100, Krzysztof Kozlowski wrote:
> The HDMI phy compatible was missing vendor prefix.
> 
> 

Applied, thanks!

[1/9] ARM: dts: exynos: correct HDMI phy compatible in Exynos4
      https://git.kernel.org/krzk/linux/c/af1c89ddb74f170eccd5a57001d7317560b638ea

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
