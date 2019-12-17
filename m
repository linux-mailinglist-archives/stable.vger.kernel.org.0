Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA101224C5
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 07:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLQGhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 01:37:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfLQGhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 01:37:45 -0500
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE804206B7;
        Tue, 17 Dec 2019 06:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576564665;
        bh=zfgZpyYTrpEBik1kM3Kdi8UuauyCHDxYWQ0Iu8vP57g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CeR0fyXDDV2+gqgU6xdDY5uj/hCrAmfudQISdYzd2xYGHt0xn1NB6DHrGNcE767tb
         2+R6ihhKKGDWSf/WP2TEse+ewZYp8+9C3eB4hGtXdVYoMPmZpW5mau+wDZrTGogDJp
         TZyQzixHdfTACgulc0RPlMBrmy/9S/ZqsVfUX0yM=
Received: by mail-wr1-f54.google.com with SMTP id z7so9945973wrl.13;
        Mon, 16 Dec 2019 22:37:44 -0800 (PST)
X-Gm-Message-State: APjAAAWGISrmO3xD6T6hq8/9g5SqhB/9xsaZdmSOcWzUVdFBTR6eNSEv
        VwVtJ//HlhPLttauSlLAgkaWGxVME984+xoAcJI=
X-Google-Smtp-Source: APXvYqwOzeYFksshtl8cKEZvNg6R+lSFFmbarnDLhVj5qjGMkKvO227EBiMcR74GFbwtbrGWX9VLvGzShqB+eojMorQ=
X-Received: by 2002:adf:ef4e:: with SMTP id c14mr21010657wrp.142.1576564663477;
 Mon, 16 Dec 2019 22:37:43 -0800 (PST)
MIME-Version: 1.0
References: <20191205085054.6049-1-wens@kernel.org> <20191211163647.2F34C214D8@mail.kernel.org>
In-Reply-To: <20191211163647.2F34C214D8@mail.kernel.org>
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Tue, 17 Dec 2019 14:37:32 +0800
X-Gmail-Original-Message-ID: <CAGb2v66jRHQw+ZFtxeNXkOXGfDyXbQ3k26KcHQrEawdZWyv0_Q@mail.gmail.com>
Message-ID: <CAGb2v66jRHQw+ZFtxeNXkOXGfDyXbQ3k26KcHQrEawdZWyv0_Q@mail.gmail.com>
Subject: Re: [PATCH] rtc: sun6i: Add support for RTC clocks on R40
To:     Sasha Levin <sashal@kernel.org>
Cc:     Chen-Yu Tsai <wens@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-rtc@vger.kernel.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Dec 12, 2019 at 12:36 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: d6624cc75021 ("rtc: sun6i: Add R40 compatible").
>
> The bot has tested the following trees: v5.4.2, v5.3.15.
>
> v5.4.2: Build OK!
> v5.3.15: Failed to apply! Possible dependencies:
>     b60ff2cfb598 ("rtc: sun6i: Add support for H6 RTC")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

This can be queued for v5.4.

I'll send a separate backport for v5.3.

ChenYu
