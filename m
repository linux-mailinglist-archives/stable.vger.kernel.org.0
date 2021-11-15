Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7FC45051A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 14:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhKONPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 08:15:37 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:47438
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231706AbhKONOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 08:14:35 -0500
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6A7253F1AD
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 13:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1636981899;
        bh=Ek/Fldzw6HQOPZj1XYTC44c+sdFSqm7+VnT8VkD8Rfw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=drAtQ3p+a8aqyMf0Bb1S9H0Fxbf/UDGo7qxusuX8Iwjzmk3Aut48tOe6Aty2e2N6Z
         gYBNSJr47ZEhiS+V2cfb3sjU6Sl1Ab7CLztVkhzUkII7mP1m58WXA3wzUp/nwTmLGA
         FhfavO12MeAAfFub1PBmtGb2roJ8oa9X5tJTE3YMfOdn0zDfVxxF+Kn33CIo4JGKhn
         WvVJhaxDFJXHJ3k9ra5vZ9qCddVSi14tqBSmxBYN1/KP0/qOpLdhOus3NAaUCsgAQa
         x+qmuhaCxcl6REge/haKJhVxHcLx9y63MXvPC+XXGt0TF8Q2nADXgQ8oKjJXWh0eEn
         +vjXkRlmzCsNw==
Received: by mail-lf1-f72.google.com with SMTP id s18-20020ac25c52000000b004016bab6a12so6726548lfp.21
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 05:11:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ek/Fldzw6HQOPZj1XYTC44c+sdFSqm7+VnT8VkD8Rfw=;
        b=pIF6U7aP6ploTu8Rv+kg9OWb7zO3QkepUfJD5QHgfNRxdXKwHm8kCA5ukNEopDIhDT
         E94Fg4LrcRNJlJO2yHGb2ajsKrw5tG3Yel292XSd7o5Kg+yUNVPxrZ9KAOGvgTWduxVu
         ptWvtcNMEJd4KTZsb2yOL8ll0Q3vwxHsDleEQuAKU9NNWbDHuOFClgQaK7riNrmId83h
         3EJlK0VlYdWALzLgSujVhbieLv1Q89YBKGnN5EIDjey3zOT0E8VF4IgabNZZWJGpGi8f
         iqlTiGdHp8eh/ifQUCLvWkM557GLsH69ywxRmfrle/gCTv64Q/LDTx868QWkpz+TpwnU
         /YXw==
X-Gm-Message-State: AOAM533oQ4HX0cj5wa8anf2mFHBhIBgNdnOQIhSBZBjchFd4aTfBlPoz
        dbB/NK+BGCtLW/+X/zhArRd413U/Z2ragwko3iiCLkyG96n8cAW9jTVhH+PpE4M3dI0PfEhszd0
        MEgeP5Zs8bDUtEjFEw3YH0E/XZ+9AwztTeA==
X-Received: by 2002:a2e:8143:: with SMTP id t3mr38123511ljg.18.1636981898877;
        Mon, 15 Nov 2021 05:11:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwEgeHAM0nYXXWQdsOhrhSNd86XLgS1t7Bl6YTvfQwwvZk1C4SUKQ+X8kW2UH5L8O81hyXlNA==
X-Received: by 2002:a2e:8143:: with SMTP id t3mr38123497ljg.18.1636981898738;
        Mon, 15 Nov 2021 05:11:38 -0800 (PST)
Received: from krzk-bin.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id p21sm1411254lfa.289.2021.11.15.05.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 05:11:38 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Paul Cercueil <paul@crapouillou.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ARM: dts: exynos/i9100: Fix BCM4330 Bluetooth reset polarity
Date:   Mon, 15 Nov 2021 14:11:33 +0100
Message-Id: <163698188786.128367.17376497674811914207.b4-ty@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211031234137.87070-1-paul@crapouillou.net>
References: <20211031234137.87070-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 31 Oct 2021 23:41:36 +0000, Paul Cercueil wrote:
> The reset GPIO was marked active-high, which is against what's specified
> in the documentation. Mark the reset GPIO as active-low. With this
> change, Bluetooth can now be used on the i9100.
> 
> 

Applied, thanks!

[1/2] ARM: dts: exynos/i9100: Fix BCM4330 Bluetooth reset polarity
      commit: 9cb6de45a006a9799ec399bce60d64b6d4fcc4af
[2/2] ARM: dts: exynos/i9100: Use interrupt for BCM4330 host wakeup
      commit: 8e14b530f8c90346eab43c7b59b03ff9fec7d171

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
