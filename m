Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57442041F2
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 22:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgFVU2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 16:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbgFVU2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 16:28:36 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED89C061573
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 13:28:36 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id r1so6070027uam.6
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 13:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/mKQob2TcXV+3bi2u2MxE4v2x49LHk6pqKAA851megE=;
        b=lRzqiLuRgFSf5qcalDvWRL4YbaOQjHCkIkS1z5jnftIuujWTgyicIdl0B3e48B1VQc
         jxfPF2B38RxGI3M1N+8iAp8EJBK/mNFW88o9CRBomgNN3BbrS8IK5fgOjUfRWAReLCVZ
         hXzlEE7ISDIQaPItEDQ0AnroKyoMxwdSONEfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/mKQob2TcXV+3bi2u2MxE4v2x49LHk6pqKAA851megE=;
        b=FCBToVQPobDqQ7FhYEvIZltWd8IumrPv+C0SANpz8Dfag6yCtqpXb86X1SwuI5GyWM
         iFe/yCoCZl0xuVsnWx8qDnlIjXhKRGXsw+KjgZ7kfEbDoLhKd/ayCxub3pKBHFLzD2nN
         KiscciApHgrPavjTts/K9vTtkh1nlqwWjMFkc9EWeWZ3zhv7UAuArzT/FgqJQqxTXY1I
         E6MR7inhiB3N9HhJnE6pH2x1lhNGhTd4njCyApqBAKE6/lLZpyjbTyikv5m8B9TjCTRm
         REspC79F3WaZNJQCY4x2tLuJXJoZZUmddE58vPQWyjUUu0JTNlJWc0Shz3owzwuFF7Yn
         iXhA==
X-Gm-Message-State: AOAM531Ym+eAwgEMvWwdQ782yDhF0ofp23Dz6MF6VBVkYaso7oGV90hW
        nd+gDtCbMPA87Nx+A8A6qi9IX0r9jmk=
X-Google-Smtp-Source: ABdhPJxbsP1LHgcqAJh4HZOfWPMgAALEclI27770pd90f4HOnacb9fgyQjL/3XMiczI0FAGgdlfI/g==
X-Received: by 2002:a9f:2ac6:: with SMTP id d6mr12644467uaj.59.1592857713961;
        Mon, 22 Jun 2020 13:28:33 -0700 (PDT)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id h14sm1852567vsl.12.2020.06.22.13.28.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 13:28:33 -0700 (PDT)
Received: by mail-vs1-f42.google.com with SMTP id e15so729908vsc.7
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 13:28:33 -0700 (PDT)
X-Received: by 2002:a67:62c4:: with SMTP id w187mr15458333vsb.109.1592857712942;
 Mon, 22 Jun 2020 13:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200622121548.27882-1-stanimir.varbanov@linaro.org>
In-Reply-To: <20200622121548.27882-1-stanimir.varbanov@linaro.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 22 Jun 2020 13:28:21 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WF4Sc5yDRc0FgtkqVvDr3brXA7ttTFU6nozCNwBfSQ9w@mail.gmail.com>
Message-ID: <CAD=FV=WF4Sc5yDRc0FgtkqVvDr3brXA7ttTFU6nozCNwBfSQ9w@mail.gmail.com>
Subject: Re: [PATCH v3] venus: fix multiple encoder crash
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Jun 22, 2020 at 5:16 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> From: Mansur Alisha Shaik <mansur@codeaurora.org>
>
> Currently we are considering the instances which are available
> in core->inst list for load calculation in min_loaded_core()
> function, but this is incorrect because by the time we call
> decide_core() for second instance, the third instance not
> filled yet codec_freq_data pointer.
>
> Solve this by considering the instances whose session has started.
>
> Cc: stable@vger.kernel.org # v5.7+
> Fixes: 4ebf969375bc ("media: venus: introduce core selection")
> Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>
> v3: Cc stable and add Fixes tag.
>
>  drivers/media/platform/qcom/venus/pm_helpers.c | 4 ++++
>  1 file changed, 4 insertions(+)

The code is the same, so carrying over my tested tag [1]:

Tested-by: Douglas Anderson <dianders@chromium.org>

[1] https://lore.kernel.org/r/CAD=FV=Vt8je1AtT8id-rPC3JToF_7uGKpC-uDuSpzCkwi3e4Sw@mail.gmail.com/
