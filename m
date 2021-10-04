Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAF942115E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 16:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbhJDOc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 10:32:29 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:34472 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbhJDOc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 10:32:28 -0400
Received: by mail-oi1-f175.google.com with SMTP id z11so21761334oih.1;
        Mon, 04 Oct 2021 07:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a9zD/WBW5Hz9Wbj7mkvEMcchgoWJqrmdeX9RgY0E/wU=;
        b=aeV1sirvt3QF4KUWKUPkvx/qoekKXFBToOUt7rDuXgBY1mkCcjbzPsnu5nGhkcEgUj
         Wrq0hGo/ZD7mqc35jICmtwtgIe3zrx+8kFsmnvnLJb2X45XArwZeLBUw/g30Xthx5n+u
         cu8gLE6Tnatgp/dQaZ52VnSZS/AQ2+4dYXaxFE4WJE0dSKc8ztdhhyY3jr4TFWC4z/4+
         P+XRp4viW/8veJWAqN3USnOLw0k1Javx0HEzKyN6Uy6+QXyuKSifsPdARk2bLEBa0SBz
         iJS3aAJWJZCYUEzGCfO5INpIrGlMxHGSxGhy82Kzi5eb7rp9BKvKgcIHvxfORIrBQ08i
         yVvA==
X-Gm-Message-State: AOAM530wpRGppPXoW50G1Qp/cKwOda5Tde+a2AkrKfJfNt2k01Qd7Gso
        EAKHhmYrHnyNoA2srFcigQ==
X-Google-Smtp-Source: ABdhPJw0qPkWepgb0uvjHPu9uBtVnZouewBkX0+v9I8COR5y2JIcsHRgXM/4MUSz+0ng2hCnGmcYEg==
X-Received: by 2002:a05:6808:309f:: with SMTP id bl31mr13593551oib.41.1633357839352;
        Mon, 04 Oct 2021 07:30:39 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bj33sm2914658oib.31.2021.10.04.07.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 07:30:38 -0700 (PDT)
Received: (nullmailer pid 1245728 invoked by uid 1000);
        Mon, 04 Oct 2021 14:30:37 -0000
Date:   Mon, 4 Oct 2021 09:30:37 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-samsung-soc@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 02/10] regulator: dt-bindings: samsung,s5m8767:
 correct s5m8767,pmic-buck-default-dvs-idx property
Message-ID: <YVsQDaiRXCYdVy80@robh.at.kernel.org>
References: <20211001094106.52412-1-krzysztof.kozlowski@canonical.com>
 <20211001094106.52412-3-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001094106.52412-3-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 01 Oct 2021 11:40:58 +0200, Krzysztof Kozlowski wrote:
> The driver was always parsing "s5m8767,pmic-buck-default-dvs-idx", not
> "s5m8767,pmic-buck234-default-dvs-idx".
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 26aec009f6b6 ("regulator: add device tree support for s5m8767")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  Documentation/devicetree/bindings/regulator/samsung,s5m8767.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
