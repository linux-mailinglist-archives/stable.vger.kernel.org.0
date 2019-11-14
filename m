Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B28CDFD112
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 23:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKNWnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 17:43:45 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43930 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfKNWnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 17:43:45 -0500
Received: by mail-wr1-f68.google.com with SMTP id n1so8693524wra.10
        for <stable@vger.kernel.org>; Thu, 14 Nov 2019 14:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UDHR/+KevxJlFcmst+Pmd+nQiCGSFhO8L4Lzn91tvGg=;
        b=bn+ZUJ5GmPLiPQggNIIqXnhPeXj4mVf9SAjKkPoTt+r7Ar3YwGQuksZUNajmA+E1Xy
         fUWqKI+uH8uVIwCRUyCdypvJzCUGQquy3jzlrr7j5xDcHvRKI4y3QKq+cqwteRKkvHz0
         cbI1NCi2amNscfMql+pN1n6OR3mSFKqsxLPVSe7+xG40y64XLuSlrM/YMGtSkFvrQKFO
         DK4F8yJsrDM35pcxf/nBCVg6Q4BnxbeOf2sPN9/0tzvIe2jGxjU8g+eafqygY0XbJ6zr
         T9WYN1RDljhJHqFVZaGnCPqtp8ONjPkDL30ylBbXkE2RkcKVDTYapwcbnjWg2EtRSQ8P
         Fsqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UDHR/+KevxJlFcmst+Pmd+nQiCGSFhO8L4Lzn91tvGg=;
        b=dhGqv94CDaQ7pCkUAFLjFt5Cx4fxJtLeA+3NGaKS4C48KJHzB34QSLMqZ4fwoeABYC
         0sI8StKO+dCR765gMtav+UnnfPF/io/guSZaunUR7RvFQ0paex8X1lpy0AZpfssKL/Ub
         sLvbUOC6Ii0C16+woNa12fglhiSLVL36RIOBeyc08nRLP6HWOAqEQtivQNkHNY3DHL3i
         QXQAm2jzGh+ti4Z9M9n3OVA9iOipRSKITCRbMTa93OM8W366Ww6sYOgI+v2Mse2/M4vz
         NVRyhLwG2BIKE7hmHs44JamFI9gmBD6ez0ZmIWz7j3cQgdSxJJSbdPmPXUz6/p5IOCdE
         UZDw==
X-Gm-Message-State: APjAAAWGvk5cAm+/ltWn03TvJ08K0aKXXJvp2ZloBnfUqCbviJ3a1Apn
        Yno2rtzcS5F46N345ruwdXVpdJemNU+PWTRwXZW7ig==
X-Google-Smtp-Source: APXvYqzwZih4JKmBS4N9a+zK31EzesAhn/+42beU2GBDQKw1b3VfwZNdbrasCFJQCrDah7nbIbzzOW+cNuwL+u8kQDA=
X-Received: by 2002:adf:db92:: with SMTP id u18mr11041793wri.1.1573771423328;
 Thu, 14 Nov 2019 14:43:43 -0800 (PST)
MIME-Version: 1.0
References: <20191114190844.42484-1-jacobraz@google.com> <20191114214301.GA159315@google.com>
In-Reply-To: <20191114214301.GA159315@google.com>
From:   Jacob Rasmussen <jacobraz@google.com>
Date:   Thu, 14 Nov 2019 15:43:32 -0700
Message-ID: <CAPZ+yN+EP=ffzWDz4hWZ3W=usDoYt7VFKaoMAgzvjo7WL_jW=g@mail.gmail.com>
Subject: Re: [PATCH] ASoC: rt5645: Fixed typo for buddy jack support.
To:     Ross Zwisler <zwisler@google.com>
Cc:     Jacob Rasmussen <jacobraz@chromium.org>,
        linux-kernel@vger.kernel.org, Bard Liao <bardliao@realtek.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Oder Chiou <oder_chiou@realtek.com>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 14, 2019 at 2:43 PM Ross Zwisler <zwisler@google.com> wrote:
>
> On Thu, Nov 14, 2019 at 12:08:44PM -0700, Jacob Rasmussen wrote:
> > Had a typo in e7cfd867fd98 that resulted in buddy jack support not being
> > fixed.
> >
> > Fixes: e7cfd867fd98 ("ASoC: rt5645: Fixed buddy jack support.")
> > Cc: <zwisler@google.com>
> > Cc: <jacobraz@google.com>
> > CC: stable@vger.kernel.org
>
> Need to add your signed-off-by.  With that added you can add:
>
> Reviewed-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Jacob Rasmussen <jacobraz@google.com>
