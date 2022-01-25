Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEBC49B111
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 11:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiAYKBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 05:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238249AbiAYJ6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 04:58:44 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CDAC06174E
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 01:58:44 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id i1so1058795pla.9
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 01:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vn0L6RsHRKBCiKCBWNgL0pspPE5cNVNqyAIXzD4B2ac=;
        b=WCtmK8sexON+JqmlN+yhbvbUSA+hHCBa3kTTazQSI34b1IWbDnw8nUyEvS2ReTPIB0
         lUeYI0D/neUse7fmGnV7JyyEx9fXrDQKOKiiLbfvPjSVZ+W0cM1brgwrgzgg5rZvScMx
         GEj2aw4jFbxLZCkJ5ndXOoV/i45sGVG8uIrkAASLErvgitI41Yq56BdeJytdoDqW2K7g
         I+MrqSNzlpb2QhRnFBsH3zL0ElvdRZrJOoGYMLarZQiai/1xSJ3Y1LQhLETAUq9eMPGm
         aDwzFniyrzMn+CwOfSlifAkvrcGcaIQ/I2c9Ef4MPHmxO1JoNKdZGNFpFAd2BCk5K3y1
         1mxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vn0L6RsHRKBCiKCBWNgL0pspPE5cNVNqyAIXzD4B2ac=;
        b=2sR8CGWFTi6SoFE9MfHL/xl+sWmmxs1v9/lSMNqDdAYsOwfzZIRRLEKkfGJSYVVavn
         ovmXaiUyfQ03CATx7UUxbvsk5c6mdj8ZAFLO0GrbqIxEP6fErCBgAonsya+KQDMV4Crl
         zhiW2zJVuXq4OxPx9F/C+J5YkC3uEuhH78bebmiuZpAFUX63Js3J6WqaacfGBCsvR/GQ
         Ey6lBse/cyx+uddu/F1i5CzpXK7D/xnlWyDnCfXaosSeQn0w0uGL+mwqxrccywtvAO4g
         4buLTh2oW8cQ3A7asPBzoqP8GSHvmIT1PDg3emofXYv4ZrlbaPfruXpTW3DpCfzFrOYi
         cHIA==
X-Gm-Message-State: AOAM533X2j1QYsA526jkgLzjwMfBRWpQFXqOR+mKUDFjHUycSyLZ/CtD
        A35rvanTnz8cV/bPK4UDjcu4RcNWFfr2nCwS/GQt9Q==
X-Google-Smtp-Source: ABdhPJy6iq38+iVsvEVuWBX5xlN0nG0obSDju74J6kON/LOkH6qEpvX7weUZ3u4f8T1088Lex+a6kCIupWO6SbhgX4c=
X-Received: by 2002:a17:90a:53:: with SMTP id 19mr2702386pjb.159.1643104723636;
 Tue, 25 Jan 2022 01:58:43 -0800 (PST)
MIME-Version: 1.0
References: <20220125004046.4058284-1-bryan.odonoghue@linaro.org>
In-Reply-To: <20220125004046.4058284-1-bryan.odonoghue@linaro.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 25 Jan 2022 11:10:19 +0100
Message-ID: <CAMZdPi-1Ts-wuvkBozuPGv5DRxf4wMFTrfGcK32TUFdN8v2CKg@mail.gmail.com>
Subject: Re: [PATCH] wcn36xx: Differentiate wcn3660 from wcn3620
To:     "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        benl@squareup.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 at 01:40, Bryan O'Donoghue
<bryan.odonoghue@linaro.org> wrote:
>
> The spread of capability between the three WiFi silicon parts wcn36xx
> supports is:
>
> wcn3620 - 802.11 a/b/g
> wcn3660 - 802.11 a/b/g/n
> wcn3680 - 802.11 a/b/g/n/ac
>
> We currently treat wcn3660 as wcn3620 thus limiting it to 2GHz channels.
> Fix this regression by ensuring we differentiate between all three parts.
>
> Fixes: 8490987bdb9a ("wcn36xx: Hook and identify RF_IRIS_WCN3680")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
