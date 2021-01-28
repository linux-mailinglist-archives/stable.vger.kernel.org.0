Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEE8306A74
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 02:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhA1BfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 20:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhA1Bez (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 20:34:55 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D14EC061573
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 17:33:59 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id o20so2950542pfu.0
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 17:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=csr+vubEtxZXL8yZ0qw0LhP81IqAfO9jQ1ONZwxJeAw=;
        b=kxykKAiVQ76RxKm+5xK0wGATcsMAaZODjbMyP5IvjmsOTcs6Qy6u63ewC5O1whqxZV
         aUIG0M30udM7TeDnuzIYYj0byAwzGjaBiUcHwTlKcqPhNoP90I2osjFPFHggbagQG8cQ
         cXtID4WOooFP4u2IGsbiwaEUW2EQNOSXjlTfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=csr+vubEtxZXL8yZ0qw0LhP81IqAfO9jQ1ONZwxJeAw=;
        b=J9syVYjPt29purVGPtjbnUAATsmunS78Ghn/AqYRrnXsm12pXtd5VQUqPTQdAxR4Bt
         hlbP7kur8MXSz3+Zo/Mevi2PX7V/12MX6jx1w9BNgLl8yUUGf+6J7LP9nEa6R9GTeEsA
         RrLOouwXh229KUuT7agDZ506n5FNltVG8GqaG4bGdNprMuxGxLfyKQ5mPk7lLapJslu8
         RN3VspSLeuXrTEg91EMLgOsrmDqvnDJnBHvg/P6pNusjdMfbA0zU580mpyq5cJCbHWeY
         nu+hJM6kaPTRE50vkE+EOmSQZGcLZnw/pRx7bT79p+ySrBCb0P/KUKa6mrotceTGug90
         pmCQ==
X-Gm-Message-State: AOAM533+EMFez0LAx8I83Adsd1BTrVC157GEyUF+F3ACgXoTuXEhQ3QA
        ZIFjnGGk7owyS4LD7hEDVWJu/g==
X-Google-Smtp-Source: ABdhPJy8yjNZJLeagHf8FZWyZhguvfYXVGj36VnR+uX+d1l8/ax2fWk04OBCFHHy0aTN+3BSmKpVew==
X-Received: by 2002:a05:6a00:86:b029:1c1:99a1:fe2b with SMTP id c6-20020a056a000086b02901c199a1fe2bmr13885025pfj.29.1611797639088;
        Wed, 27 Jan 2021 17:33:59 -0800 (PST)
Received: from chromium.org ([2620:15c:202:201:304c:5453:303a:8268])
        by smtp.gmail.com with ESMTPSA id r5sm3487125pfl.165.2021.01.27.17.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 17:33:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210126150241.10009-1-saiprakash.ranjan@codeaurora.org>
References: <20210126150241.10009-1-saiprakash.ranjan@codeaurora.org>
Subject: Re: [PATCH] watchdog: qcom: Remove incorrect usage of QCOM_WDT_ENABLE_IRQ
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        stable@vger.kernel.org
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        jorge@foundries.io, linux-watchdog@vger.kernel.org
Date:   Wed, 27 Jan 2021 17:33:56 -0800
Message-ID: <161179763694.76967.7406861246436700530@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sai Prakash Ranjan (2021-01-26 07:02:41)
> As per register documentation, QCOM_WDT_ENABLE_IRQ which is BIT(1)
> of watchdog control register is wakeup interrupt enable bit and
> not related to bark interrupt at all, BIT(0) is used for that.
> So remove incorrect usage of this bit when supporting bark irq for
> pre-timeout notification. Currently with this bit set and bark
> interrupt specified, pre-timeout notification and/or watchdog
> reset/bite does not occur.

It looks like the QCOM_WDT_ENABLE_IRQ bit is to catch a problem where a
pending irq is unmasked but the watchdog irq isn't handled in time? So
some sort of irq storm?

>=20
> Fixes: 36375491a439 ("watchdog: qcom: support pre-timeout when the bark i=
rq is available")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
