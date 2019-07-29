Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE10D797EE
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfG2UEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:04:13 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46259 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389710AbfG2Tpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 15:45:44 -0400
Received: by mail-lj1-f193.google.com with SMTP id v24so59860113ljg.13
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 12:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Xj0KmdFEesb0An0pvpoI4nRdiLfdj9xAiXwnPK4NLM=;
        b=i4fDxC9jgwYfkwAabdzbHKdotQBa5S7C9sw2mTATq9cGBTlThSmyjKilRde22eS4EQ
         J1y54uKk3TdvfFz+IZixYBhYEDQKK00Yr5LCyxsLkgEpzD2QrreBz4/IrMb+XjkyZi4f
         6P+ywrpTxBuWukUHucrzU54+yZN5I364s2E6o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Xj0KmdFEesb0An0pvpoI4nRdiLfdj9xAiXwnPK4NLM=;
        b=QsmzpVtJO0phxn3YdlJgiCTf76LDvpIHZ4eBDvEEyp7Gzdtcazw4TN5/ho1H0rdxvY
         KWLbmH6iJgzYbdagNoacy6GFGggSpLg+PkXLTJreKTfEsEH7BBNHXTjPpjd1HdiW1ny/
         04fgvSsUs7sSmaVWb+dMix5Obe8zN0bVqKO3CCEAbgeKBr3CWEUzCcItfSiOGmrfhgYp
         7oyac5EvQZoPI7iOR4inal4+ug6tAvOoK9Ue/tc9nNtrWxR/5HBtdnPpUlN3b1z+QORS
         2mkJLcjoG0iVnJJ6OaqlNqzNxSL0ykG2lqqCFezurhtUBcUiG5SYT/e8clW2RHDTWcfo
         dpvw==
X-Gm-Message-State: APjAAAUJfd0NWreu4QyUKzEVqTpwKl/J7RxeyH9Z98g6EkuHx2aRmbuz
        L0LWIbTkf0iihbIQ091NUUR6dOeMSLI=
X-Google-Smtp-Source: APXvYqwg0rnmb98vL0g9+xr4eeECXFnt1bYDF+8d1j970u9jC0FLWtwXitKxmqxjhIsnH5BzF+JYCw==
X-Received: by 2002:a2e:63cd:: with SMTP id s74mr58097468lje.164.1564429541848;
        Mon, 29 Jul 2019 12:45:41 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id t4sm14359209ljh.9.2019.07.29.12.45.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 12:45:38 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id r9so59749751ljg.5
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 12:45:38 -0700 (PDT)
X-Received: by 2002:a2e:3602:: with SMTP id d2mr407913lja.112.1564429538156;
 Mon, 29 Jul 2019 12:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190724194634.205718-1-briannorris@chromium.org> <s5hv9vkx21i.wl-tiwai@suse.de>
In-Reply-To: <s5hv9vkx21i.wl-tiwai@suse.de>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 29 Jul 2019 12:45:26 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMEFew2Sg5G1ofKq-0gfOTFEOhZNjfyNJMRzRjv7ZFgXw@mail.gmail.com>
Message-ID: <CA+ASDXMEFew2Sg5G1ofKq-0gfOTFEOhZNjfyNJMRzRjv7ZFgXw@mail.gmail.com>
Subject: Re: [PATCH 5.3] mwifiex: fix 802.11n/WPA detection
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 9:01 AM Takashi Iwai <tiwai@suse.de> wrote:
> This isn't seen in linux-next yet.

Apparently not.

> Still pending review?

I guess? Probably mostly pending maintainer attention.

Also, Johannes already had noticed (and privately messaged me): this
patch took a while to show up on the linux-wireless Patchwork
instance. So the first review (from Guenter Roeck) and my extra reply
noting the -stable regression didn't make it to Patchwork:

https://patchwork.kernel.org/patch/11057585/

> In anyway,
>   Reviewed-by: Takashi Iwai <tiwai@suse.de>

Thanks. Hopefully Kalle can pick it up.

Brian
