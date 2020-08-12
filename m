Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FD8242A9E
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 15:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgHLNwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 09:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgHLNwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 09:52:20 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C92C061383
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 06:52:19 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id s29so632316uae.1
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 06:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8InXO4IHlwCJ/3LHKr2wC5cvoqCeqc4wxbX8rXjUiPg=;
        b=N+kSkmDigJZm9bdYj2CCq6cRuTJusMts4MyrYLhaepzh1SFeONS44pX8HelNsXmkpt
         Sar1XiJvk4yffabWSLuwN6z7snQ+dFjiNxSHvBEnAwmsfgNATsdM1HHNgVZ0t9hUvslm
         ipOuT2PSmwUT1HfAGS8oOlizyFM9mh0PMN6DY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8InXO4IHlwCJ/3LHKr2wC5cvoqCeqc4wxbX8rXjUiPg=;
        b=PQsYhL81GOPeUaBxDPBuZmi/zB3O5gkwEC3fkrsqCfM97s6z2geS/WSFkopRV8U66r
         xT3JPlQlAilzpnqkeQFaD5Vkh4OdUgAWJTGBma6pBSKk1o4GeNHqKVeQk+CKuYMDnFWw
         2kuBB4Gvl5Fh3KvXtkA/gDIKb2un5GotdNAU+d9kW4Bwoi8ZHxqWj2JBD+TXbewa04pr
         2L3q+y40rcqwPO2y2mPy5Scldsu2HXdQ0hbI++lA++KooNgVtQR/0y9kYwKvRbxJHznN
         yZZqUHvAfUbfgrIv0i4Gu89E5GDWq/aiK08J2VDbreBIii9A7dRFxBqnVODgkjWzC3DG
         lXtw==
X-Gm-Message-State: AOAM533e5zii3LZZQQpgnM1NBkLd9zdCJ6tS3MaKZehaVVoiUM0P+/03
        0kmpfEHrVwNkFrAQMTOCNFlVWuWoQJg=
X-Google-Smtp-Source: ABdhPJznYXSj0UUElHK3IfcjJ9tFGpF91KVcCtupelYEIvlCWVVOoEQ7d6OQrN34GgbqRW78dCnvzw==
X-Received: by 2002:a9f:25c1:: with SMTP id 59mr27073091uaf.49.1597240338658;
        Wed, 12 Aug 2020 06:52:18 -0700 (PDT)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id u24sm276402vsk.12.2020.08.12.06.52.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 06:52:17 -0700 (PDT)
Received: by mail-ua1-f42.google.com with SMTP id g20so620151uap.8
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 06:52:17 -0700 (PDT)
X-Received: by 2002:ab0:3114:: with SMTP id e20mr27858800ual.104.1597240337098;
 Wed, 12 Aug 2020 06:52:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200215021232.1149-1-mdtipton@codeaurora.org> <158378825407.66766.14135857856613969751@swboyd.mtv.corp.google.com>
In-Reply-To: <158378825407.66766.14135857856613969751@swboyd.mtv.corp.google.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Wed, 12 Aug 2020 06:52:05 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WsD7w9oqbUUKJwWSRsfZ9qTLy9KyNp8i+BShi7S-R92w@mail.gmail.com>
Message-ID: <CAD=FV=WsD7w9oqbUUKJwWSRsfZ9qTLy9KyNp8i+BShi7S-R92w@mail.gmail.com>
Subject: Re: [PATCH] clk: qcom: clk-rpmh: Wait for completion when enabling clocks
To:     Stephen Boyd <sboyd@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Mike Tipton <mdtipton@codeaurora.org>,
        Taniya Das <tdas@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Andy Gross <agross@kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Mar 9, 2020 at 2:11 PM Stephen Boyd <sboyd@kernel.org> wrote:
>
> Quoting Mike Tipton (2020-02-14 18:12:32)
> > The current implementation always uses rpmh_write_async, which doesn't
> > wait for completion. That's fine for disable requests since there's no
> > immediate need for the clocks and they can be disabled in the
> > background. However, for enable requests we need to ensure the clocks
> > are actually enabled before returning to the client. Otherwise, clients
> > can end up accessing their HW before the necessary clocks are enabled,
> > which can lead to bus errors.
> >
> > Use the synchronous version of this API (rpmh_write) for enable requests
> > in the active set to ensure completion.
> >
> > Completion isn't required for sleep/wake sets, since they don't take
> > effect until after we enter sleep. All rpmh requests are automatically
> > flushed prior to entering sleep.
> >
> > Fixes: 9c7e47025a6b ("clk: qcom: clk-rpmh: Add QCOM RPMh clock driver")
> > Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
> > ---
>
> Applied to clk-next but I squashed in some changes to make it easier for
> me to read.

This landed upstream as commit dad4e7fda4bd ("clk: qcom: clk-rpmh:
Wait for completion when enabling clocks") but seemed to have missed
stable.  Can stable pick it up?  It has a Fixes tag so presumably it
should be easy to track down where it needs to go.

Thanks!

-Doug
