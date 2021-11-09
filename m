Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE02344B0EB
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 17:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbhKIQQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 11:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238523AbhKIQQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 11:16:23 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDE3C061764;
        Tue,  9 Nov 2021 08:13:37 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id p2so550747uad.11;
        Tue, 09 Nov 2021 08:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tzUBCRI0ZEiUTjI4kQ5UxbfpHunrGMBYtyyXAY2lvGg=;
        b=oQhkxKUY2gj5xInLINgKaVx+p/wLVFabBC7fYFCIDQx0W6JIYXvo0jwaHBTa8RYCNC
         dI6AAummztsVAF4+SqaSi0Z6lLliTs/1h9SRyn8Ac3OgKkKfl571n67ZfFPvBqDfJkEM
         uLZ2kp632JLI7bZIBgo514Hj14HaZL2r63V6zpsiStjuIGYcWrs9YigDprMwlPcrwH7s
         mWl5RrJTA49BA8UYwG2TJ6KNE3rC5Cn/AKm+WzVuUv6fEtus64XtW9q3q2R9W91CIF+b
         /gPgH/FS7BPA9hwCuKr88ZrMt7kGoLD0rWVWlLdhPf7xtFcbaoEbYnijSqhQVIdtNaq2
         pGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tzUBCRI0ZEiUTjI4kQ5UxbfpHunrGMBYtyyXAY2lvGg=;
        b=DZsE+xZXzCY1FAxltv6+hp1JJKXymeZkLxRXTLPmpGnoblD4/KxpPweL/Lr92MF991
         JloPp35IzC25koe5EkwCMC21HScb/NUNTG86QrDTX4HiAlnBotI2W7gtoeWCpA1sxKwu
         MdoudCnqczFdx/kZ15Y/0/jThOQZumdz0sZMQ8nJ4w6sE5xHrRJawmBCHC9w9WAsw0ns
         1eqzDHUeUNEfvqPOxUBXsDlZKrWIZm/fqzriBnwfOEznAcESS7SYVgrKpxYt8hoq+cut
         atIlfYHagNIhVuix0BDtDNHCoSWTp58LG1HBfhn7tglXJL0cOIt8+nkRzSBUeQSBlpJI
         qmRA==
X-Gm-Message-State: AOAM531WG1LiYC2xfafEoVLDZrpHoI2OjBflppoo8WZGu4SA3fluMay7
        ZPgZxe70L++NdFcXMdsc/JNB1hdLKBKbjqWZRudtl8q7
X-Google-Smtp-Source: ABdhPJxJsA1OpsfRaeJj56kz8UpgIOw/68ZpDLgwd/qYQplYu8lGvuXPpsAPLvn+NEIdMLzetIp3L1Wnf9Ymq+Q0LF0=
X-Received: by 2002:ab0:3898:: with SMTP id z24mr11672656uav.26.1636474416650;
 Tue, 09 Nov 2021 08:13:36 -0800 (PST)
MIME-Version: 1.0
References: <20211109100203.c61007433ed6.I1dade57aba7de9c4f48d68249adbae62636fd98c@changeid>
In-Reply-To: <20211109100203.c61007433ed6.I1dade57aba7de9c4f48d68249adbae62636fd98c@changeid>
From:   Sid Hayn <sidhayn@gmail.com>
Date:   Tue, 9 Nov 2021 11:13:26 -0500
Message-ID: <CAM0KTbAHBkpdfK2DxnhbxvaqQYHJEF-iY7Nnt1___PUHk8y0Lg@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix radiotap header generation
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please add my tested-by as well.  I tested with and without this patch
on multiple chipsets and everything appears functional now.  Thanks
for the quick fix!

Tested-by: Sid Hayn <sidhayn@gmail.com>

On Tue, Nov 9, 2021 at 4:02 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> From: Johannes Berg <johannes.berg@intel.com>
>
> In commit 8c89f7b3d3f2 ("mac80211: Use flex-array for radiotap header
> bitmap") we accidentally pointed the position to the wrong place, so
> we overwrite a present bitmap, and thus cause all kinds of trouble.
>
> To see the issue, note that the previous code read:
>
>   pos = (void *)(it_present + 1);
>
> The requirement now is that we need to calculate pos via it_optional,
> to not trigger the compiler hardening checks, as:
>
>   pos = (void *)&rthdr->it_optional[...];
>
> Rewriting the original expression, we get (obviously, since that just
> adds "+ x - x" terms):
>
>   pos = (void *)(it_present + 1 + rthdr->it_optional - rthdr->it_optional)
>
> and moving the "+ rthdr->it_optional" outside to be used as an array:
>
>   pos = (void *)&rthdr->it_optional[it_present + 1 - rthdr->it_optional];
>
> The original is off by one, fix it.
>
> Cc: stable@vger.kernel.org
> Fixes: 8c89f7b3d3f2 ("mac80211: Use flex-array for radiotap header bitmap")
> Reported-by: Sid Hayn <sidhayn@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index fc5c608d02e2..3562730ea0f8 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -364,7 +364,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
>          * the compiler to think we have walked past the end of the
>          * struct member.
>          */
> -       pos = (void *)&rthdr->it_optional[it_present - rthdr->it_optional];
> +       pos = (void *)&rthdr->it_optional[it_present + 1 - rthdr->it_optional];
>
>         /* the order of the following fields is important */
>
> --
> 2.31.1
>
