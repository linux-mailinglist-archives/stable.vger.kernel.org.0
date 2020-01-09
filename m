Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBEB135F68
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 18:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388101AbgAIReF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 12:34:05 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36940 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728220AbgAIReD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 12:34:03 -0500
Received: by mail-qk1-f195.google.com with SMTP id 21so6757308qky.4
        for <stable@vger.kernel.org>; Thu, 09 Jan 2020 09:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nLZ40X4AYSx/4IufI5neDGOXIt1DrkaYWqpJijj50lU=;
        b=YtRa8QvPTdA4j+IGrYzf5ipFgbr/DCJAJVWKc8q8BT+ICZP0hiqMU61CEmmNrt9Kor
         1IedsTdhwZO2biCYk5RspEZKHbssaZuGMTwt1u/nTHu5kT5nnZ8RqSpE8QD/CJybCbMQ
         60ASxWqybxd7rDSd1T7Q9LX9QjO3f0AB9nP/g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nLZ40X4AYSx/4IufI5neDGOXIt1DrkaYWqpJijj50lU=;
        b=kFLO8mnqOhzE5bImALlGeyCK52PQUMNXGQkDWNp+AdPiUdCqDdi89lM5A0aa+d/Sou
         mKg6yMG+91VoN8jsLHTqLZClCcYi9Jn1nmNj9dHIdqY93Gpqlop6jo9dJMaQMnm2vLwa
         g0xPjPcnZwOYA9jafajIAvNkH8tMMeruxS+aUz8XU9lk2mu14XWzLBiiYFoQ15tG5F4K
         nE33U/CMFbENmgESJUGjNMRIim8JXq5ZVXaA4rjqb2c6ITAUwqH0t3+k6ZfZbYMaCIWu
         toY2E7pBKHRQqxhw2wpEvf2b+Oukd+4puPNzr3+/7G96lZPXKgM1P73AHZTsrtGI55JB
         89yA==
X-Gm-Message-State: APjAAAUeN0bpLCjnh9TrWAi/l9nfNVcQxkO+72ext1OY+uEBtl3lVDML
        XzbaKGnGtXusTK6vUD34T94oRu/TsDs=
X-Google-Smtp-Source: APXvYqxtv+bg/VJChO4C4jq6pIxePorZzQuEi8dSpldTtAT8KqSZgBBcQreH+vyDyn1PsZdWEgdY3w==
X-Received: by 2002:a37:4141:: with SMTP id o62mr10332371qka.282.1578591241754;
        Thu, 09 Jan 2020 09:34:01 -0800 (PST)
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com. [209.85.222.173])
        by smtp.gmail.com with ESMTPSA id i23sm3395502qka.113.2020.01.09.09.34.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 09:34:01 -0800 (PST)
Received: by mail-qk1-f173.google.com with SMTP id t129so6718151qke.10
        for <stable@vger.kernel.org>; Thu, 09 Jan 2020 09:34:00 -0800 (PST)
X-Received: by 2002:ae9:e40d:: with SMTP id q13mr10878417qkc.2.1578591240318;
 Thu, 09 Jan 2020 09:34:00 -0800 (PST)
MIME-Version: 1.0
References: <20191227174055.4923-1-sashal@kernel.org> <20191227174055.4923-8-sashal@kernel.org>
 <CA+ASDXM6UvVCDYGq7gMEai_v3d79Pi_ZH=UFs1gfw_pL_BLMJg@mail.gmail.com> <20200109152925.GF1706@sasha-vm>
In-Reply-To: <20200109152925.GF1706@sasha-vm>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 9 Jan 2020 09:33:49 -0800
X-Gmail-Original-Message-ID: <CA+ASDXPy+K2DGYAy+8pXbDQ3e87Vd+KazsS7JneCc5CHa_NaKA@mail.gmail.com>
Message-ID: <CA+ASDXPy+K2DGYAy+8pXbDQ3e87Vd+KazsS7JneCc5CHa_NaKA@mail.gmail.com>
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

On Thu, Jan 9, 2020 at 7:29 AM Sasha Levin <sashal@kernel.org> wrote:
> On Mon, Jan 06, 2020 at 02:51:28PM -0800, Brian Norris wrote:
> >I'd recommend holding off until that gets landed somewhere. (Same for
> >the AUTOSEL patches sent to other kernel branches.)
>
> I'll drop it for now, just ping us when the fix is in and we'll get both
> patches queued back up.

I'll try to do that. The maintainer is seemingly busy (likely
vacation), but I'll try to keep this in mind when they get back to me.

Thanks,
Brian
