Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C4A46A307
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 18:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242829AbhLFRfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 12:35:06 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45342 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236887AbhLFRfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 12:35:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A920CE1727;
        Mon,  6 Dec 2021 17:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C500DC341C5;
        Mon,  6 Dec 2021 17:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638811891;
        bh=UExTbAcwtusBcjfrES6e0PL8FPZ22caLLzYUe0aM3AE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BFLjX6LwOpdOErKEJrXFFvD/2ymeaWM1QVz5hqmBCWY4XBp51C/UwyAd4ga/qOivn
         ira00gu66SAzm8CURLuC68PeQIwZWGzYAl8MEYOHn6EjyS5aI3JLDX4eKhRzSVvL1V
         fN+Ad7MKLFZPfvTWCXID9HMLsxJKo1XuXj5emrRZ9HmnwLypIz8Ti/iAPYCyL+bxKx
         qsbHFaw2QHbKBvuogoK8I64XvDAslEkVh0jz8HbGFdSwiKX9qao3MNrn70QbVWVxo5
         POdCTkA6HIQrr/dLiXxclNA96W2zVoMDAF+mOj6umu9aPjkwxD/WLz1EyXcze3H4dq
         eIpDke6QmlTtA==
Received: by mail-ed1-f49.google.com with SMTP id e3so46299889edu.4;
        Mon, 06 Dec 2021 09:31:31 -0800 (PST)
X-Gm-Message-State: AOAM532ox5rdOAYp5goam0gNZh8joX/WtACZa+Whq3KaloTJOOh+yrsl
        /PAtlnaEon0zTL47Aq4bqLQDgUjv25TD1luLDQ==
X-Google-Smtp-Source: ABdhPJwMJboY66dKuBsQJ0ILn9EJr6LBVdXqK48WrKrv8Idp93dxzB/pCTIBE4pdjUlIi8Lr1yV38S6zFwV0cpQCTRE=
X-Received: by 2002:a05:6402:5c9:: with SMTP id n9mr638402edx.306.1638811890020;
 Mon, 06 Dec 2021 09:31:30 -0800 (PST)
MIME-Version: 1.0
References: <20211206124306.14006-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211206124306.14006-1-krzysztof.kozlowski@canonical.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 6 Dec 2021 11:31:18 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKSm48Ts8faUo_T1_Bd0NhGdFbdMiaBrCSdAHRqUSLfaQ@mail.gmail.com>
Message-ID: <CAL_JsqKSm48Ts8faUo_T1_Bd0NhGdFbdMiaBrCSdAHRqUSLfaQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: dt-bindings: samsung,s5m8767: add missing
 op_mode to bucks
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 6, 2021 at 6:43 AM Krzysztof Kozlowski
<krzysztof.kozlowski@canonical.com> wrote:
>
> While converting bindings to dtschema, the buck regulators lost
> "op_mode" property.  The "op_mode" is a valid property for all
> regulators (both LDOs and bucks), so add it.
>
> Reported-by: Rob Herring <robh@kernel.org>
> Fixes: fab58debc137 ("regulator: dt-bindings: samsung,s5m8767: convert to dtschema")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../bindings/regulator/samsung,s5m8767.yaml   | 25 +++++++++++++++++++
>  1 file changed, 25 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
