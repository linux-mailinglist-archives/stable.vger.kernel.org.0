Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC35E131BD8
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 23:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgAFWvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 17:51:43 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37682 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgAFWvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 17:51:42 -0500
Received: by mail-qk1-f193.google.com with SMTP id 21so41061264qky.4
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 14:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DcDJpyHhT/zuHt9L/g76CdYSvylHBQA1EbFEZdNVtEg=;
        b=d35htZm0gVCK/o7dbN8yxRvxzIEDYFhUfHYTtCUanbQlAQUMbA7D9fJQ7sI+7YkUYI
         fpuj36oPW2PXPysY4rVwdiRH0I2zfeUYPpyYdP1pGpAM2VHM60s2z5fmvIrfO0S+4CcN
         lOApLOvozrkfiXp8w2ciqEbwqOGsPZ9cKipyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DcDJpyHhT/zuHt9L/g76CdYSvylHBQA1EbFEZdNVtEg=;
        b=X9TG/5VT/UjnYa+IZl7TkwBQXFi9XvG1h+TnAw7027T4PmWBSOPnUzGmPOhJHaWzAG
         YRwi5ONXt4qcs/YLBbZt046CESHlFJM5O63nxjLX3Vyb/Id2T/n9TjvfgqFh9OjXK8Eb
         u8sfHu9e7EALZ3lqXLfTiZc8HNbXA4RraQ434goZTx6U3SPgoP5wk5Zk0y1+tiBFyLfn
         /jnnWNMfsu4rrF8M5OY5TUWfGT96gTcNkMz+y4/akCZXb5EghIzBB3sga04yXdcAh/UG
         Dnrlp0FY5tAcgMMxM2xvQXvwA3Uh6Wn2j4ByWxHsUNvoEj18URKpFB8Xd8q1scuqxuq4
         3wgA==
X-Gm-Message-State: APjAAAViNZgRkgEi/tao3vgR5IcupNQw/PthANNbGBq8oAqs/9Z1tvFA
        dUSGMIXDk4WMbzYV3JasrhlY7zJo0kE=
X-Google-Smtp-Source: APXvYqxjvR7FEOwiXZAvu9PVV/BDQRQt+Cj7rEd5wxkFMqa5yUDOyNjTaPhNXlBhUq4yKyBDFa0CCw==
X-Received: by 2002:a05:620a:1114:: with SMTP id o20mr83942067qkk.128.1578351101125;
        Mon, 06 Jan 2020 14:51:41 -0800 (PST)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com. [209.85.160.175])
        by smtp.gmail.com with ESMTPSA id q126sm21486563qkd.21.2020.01.06.14.51.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 14:51:40 -0800 (PST)
Received: by mail-qt1-f175.google.com with SMTP id d5so43839650qto.0
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 14:51:40 -0800 (PST)
X-Received: by 2002:ac8:678d:: with SMTP id b13mr67296866qtp.213.1578351099829;
 Mon, 06 Jan 2020 14:51:39 -0800 (PST)
MIME-Version: 1.0
References: <20191227174055.4923-1-sashal@kernel.org> <20191227174055.4923-8-sashal@kernel.org>
In-Reply-To: <20191227174055.4923-8-sashal@kernel.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 6 Jan 2020 14:51:28 -0800
X-Gmail-Original-Message-ID: <CA+ASDXM6UvVCDYGq7gMEai_v3d79Pi_ZH=UFs1gfw_pL_BLMJg@mail.gmail.com>
Message-ID: <CA+ASDXM6UvVCDYGq7gMEai_v3d79Pi_ZH=UFs1gfw_pL_BLMJg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 008/187] mwifiex: fix possible heap overflow
 in mwifiex_process_country_ie()
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        huangwen <huangwenabc@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 27, 2019 at 9:59 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Ganapathi Bhat <gbhat@marvell.com>
>
> [ Upstream commit 3d94a4a8373bf5f45cf5f939e88b8354dbf2311b ]

FYI, this upstream commit has unbalanced locking. I've submitted a
followup here:

[PATCH] mwifiex: fix unbalanced locking in mwifiex_process_country_ie()
https://lkml.kernel.org/linux-wireless/20200106224212.189763-1-briannorris@chromium.org/T/#u
https://patchwork.kernel.org/patch/11320227/

I'd recommend holding off until that gets landed somewhere. (Same for
the AUTOSEL patches sent to other kernel branches.)

Regards,
Brian
