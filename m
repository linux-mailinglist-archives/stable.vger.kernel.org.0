Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CB740D75A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 12:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbhIPK1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 06:27:30 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:40302
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235196AbhIPK13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 06:27:29 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id BB5E23F077
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 10:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631787968;
        bh=INMMbJweLKtfIFqOp/z9nDfacvXLONpOGUN41e2Lxa0=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=PBKB2WvI17sQ6wgPR2MfLynZNvg+lJLU7igwaI94hHDCUTqiZ/fJbcYQwMaMWRHkw
         xj2qN9x+7Al1CDcENZDp18URw8P2C02R2zaa6m92sbO/531dBXr7YVEOR+PCsKgEc2
         LIU+Pke4NDf44fns34n8lwzMCxxy+Tpdc7zf7qFbjOIRlKUirylwS5CbRjIXyPjPMp
         PfCVVSNz+YFYMjCXd8ef+MSAZ43XljyeEVsT+4UOmhFmXX24BrLb1cg0OR4yyJg7QG
         Pnl6UM8viyNLNGaIeJkWZtFH533xFInNWY7XQsnx34uZOAWa1vTh+hg+yRzuYQpLJZ
         P6QKbwri+JgSw==
Received: by mail-ed1-f71.google.com with SMTP id l29-20020a50d6dd000000b003d80214566cso552086edj.21
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 03:26:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=INMMbJweLKtfIFqOp/z9nDfacvXLONpOGUN41e2Lxa0=;
        b=1BWqaA5LwFwZFM+PDqj3Nf0ogM3TZJUDlOwbzoOK7CBoeZU8tBtgCQLK+bUbegrcml
         ZayZkt9mSSdLzqvPwyb+UQ6IYAqUNjX6eQ7suB1zd6zuMFqYtP4TR3lcpjD1nYOZz9cS
         JYeaSYAz2teXp9d4m5aAYxiXqsmPGPghitqdoX73EaGDTCTY3VQiMaBL7rerlrLnoXht
         1Odr9wJMjWP+I9wc61mBxM/dbSoTyEjnsT+B8CVDu8JgMxi8kbF1sy8aY6pG0BceX391
         SyWJGtdvsOPorgXUaHi0209OyZIxocVuTTqEOTfsPLkClJmzZV4tLxjEMbhKIxcGKxaf
         si9Q==
X-Gm-Message-State: AOAM533rdj4qrh17EFXGnlO25h0uMq6OJL/kd99alHdGvBeK0WVK7uVx
        6+6+GXgATQ+dl6HPag055Cm27uNp/y7qQY/lecRoyU/HTwdoQg51ZIX/+Dyy9mIzB7EWo6O0HS0
        X6zq4x1d6p9KdHExk77Qo7xvsu4/xGJ8gYw==
X-Received: by 2002:a17:906:52c5:: with SMTP id w5mr5356763ejn.567.1631787968304;
        Thu, 16 Sep 2021 03:26:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxb9N/GLWxTk0KNEb248UKXPfMbCCsC1PbReC6Ab21JP1EcUI71yB8XTalRhNhya3VMa/vctA==
X-Received: by 2002:a17:906:52c5:: with SMTP id w5mr5356746ejn.567.1631787968167;
        Thu, 16 Sep 2021 03:26:08 -0700 (PDT)
Received: from [192.168.3.211] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id b14sm1221085edy.56.2021.09.16.03.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 03:26:07 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] power: supply: max17042_battery: Clear status bits
 in interrupt handler
To:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>, kernel@puri.sm,
        stable@vger.kernel.org
References: <20210914121806.1301131-1-sebastian.krzyszkowiak@puri.sm>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <42c74aa4-55ef-194b-b26c-945399d16a4b@canonical.com>
Date:   Thu, 16 Sep 2021 12:26:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210914121806.1301131-1-sebastian.krzyszkowiak@puri.sm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/09/2021 14:18, Sebastian Krzyszkowiak wrote:
> The gauge requires us to clear the status bits manually for some alerts
> to be properly dismissed. Previously the IRQ was configured to react only
> on falling edge, which wasn't technically correct (the ALRT line is active
> low), but it had a happy side-effect of preventing interrupt storms
> on uncleared alerts from happening.
> 
> Fixes: 7fbf6b731bca ("power: supply: max17042: Do not enforce (incorrect) interrupt trigger type")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> ---
> v2: added a comment on why it clears all alert bits
> ---
>  drivers/power/supply/max17042_battery.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
