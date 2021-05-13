Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F90A37F3E0
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 10:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhEMILD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 04:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhEMILC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 04:11:02 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14663C06174A
        for <stable@vger.kernel.org>; Thu, 13 May 2021 01:09:53 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id p12so32833346ljg.1
        for <stable@vger.kernel.org>; Thu, 13 May 2021 01:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codecoup-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VKWTUzghWqG73Yb4bsxyH4lL4CY73jE061Smyy3iO4I=;
        b=S8uw4xVC3wqxmVc+/BxuYOTb48CIlbujpoWzROCE1g60xEh9/4FU0DLYytrF6okOIY
         sEb+zHFKkipag6wAclYAy/3H1RLUI0HusgMA3m19bjnRcPzzL/1a33rg5/Fpz4H3yxbJ
         n4lDfGsYfjp4f4DGHr9tCSPX1CjuNJ110uFx89SPzK4qJygkl++B5ojqhZU0p/gTHX9d
         nsp2VmW3HKOBs8A9zGyB9RZtw55RsDT8bQnRwBxOriX/wfsySLbVUwZ1aPFWFAQIV+ka
         xkoBbNjL8ssw1JwTNgmQJYnBuYXNC9nuC0ETje/3Sl+LFsEsoBPXUn+vIERaZ1xzbtN8
         Cb9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=VKWTUzghWqG73Yb4bsxyH4lL4CY73jE061Smyy3iO4I=;
        b=YMGthrvPxdI6Uv/uhrGChhbhYhcFhydh07Iz3bt8hTZdUsAF08aHy/aIjKG/JhDJ/T
         0TtxNXiLFUCzekpuJdIuB8KkDQP7I7TEd3DZ0R3RKvwvn4DaRdvzT7iRWQ/yuQGWG/xX
         OXdS1qaYM2vaglnEqWumgXE0QOcLBPmrsaVjaKqnDg8fQZJOsdNOOmZvQi89Se9VqsfG
         xPOsx+iFZ3nO6D+VojA7Llu2O/00kTIkzoZ/ti0cIvWXlNfDFWbCm17enV9BjmdWiQhS
         vsbfnDlZa9ggRUjUToq3skessjCCEqMpQu24Qeb6tGYK9R/kOHkYQi2E9fFS6D9G1kJQ
         IZWg==
X-Gm-Message-State: AOAM530wMIFXtK6aqS0zH0d1cQQLLeWmE67MSwvxhlFinBvjUuXWGFAa
        OF+pVdf6qIzuVbEfde+4m72l/A==
X-Google-Smtp-Source: ABdhPJyeCg2RzxBXQp0AH4CyqOPe42FwmYIUF0RhVosdqTONIBF7a8OarEgdZzl2FdhrKmiiPHR1JQ==
X-Received: by 2002:a2e:591:: with SMTP id 139mr25382859ljf.207.1620893391522;
        Thu, 13 May 2021 01:09:51 -0700 (PDT)
Received: from ix.localnet ([95.143.243.62])
        by smtp.gmail.com with ESMTPSA id f14sm353754ljm.55.2021.05.13.01.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 01:09:51 -0700 (PDT)
From:   Szymon Janc <szymon.janc@codecoup.pl>
To:     Kai Krakow <kai@kaishome.de>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Remove spurious error message
Date:   Thu, 13 May 2021 10:09:49 +0200
Message-ID: <4321662.LvFx2qVVIh@ix>
Organization: CODECOUP
In-Reply-To: <CABBYNZKBW1wtTbkmcQbAybGm7zdcur16935yGNwid9oiGOxNFQ@mail.gmail.com>
References: <20210512133407.52330-1-szymon.janc@codecoup.pl> <CAC2ZOYvax0WGO7wMzbPXQMGb2NDouAF6XRgd5TH+h-f6uWvhtg@mail.gmail.com> <CABBYNZKBW1wtTbkmcQbAybGm7zdcur16935yGNwid9oiGOxNFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wednesday, 12 May 2021 20:13:19 CEST Luiz Augusto von Dentz wrote:
> Hi Kai,
> 
> On Wed, May 12, 2021 at 11:06 AM Kai Krakow <kai@kaishome.de> wrote:
> > Hi Szymon!
> > 
> > Am Mi., 12. Mai 2021 um 15:34 Uhr schrieb Szymon Janc 
<szymon.janc@codecoup.pl>:
> > > Even with rate limited reporting this is very spammy and since
> > > it is remote device that is providing bogus data there is no
> > > need to report this as error.
> > 
> > [...]
> > 
> > > [72464.546319] Bluetooth: hci0: advertising data len corrected
> > > [72464.857318] Bluetooth: hci0: advertising data len corrected
> > > [72465.163332] Bluetooth: hci0: advertising data len corrected
> > > [72465.278331] Bluetooth: hci0: advertising data len corrected
> > > [72465.432323] Bluetooth: hci0: advertising data len corrected
> > > [72465.891334] Bluetooth: hci0: advertising data len corrected
> > > [72466.045334] Bluetooth: hci0: advertising data len corrected
> > > [72466.197321] Bluetooth: hci0: advertising data len corrected
> > > [72466.340318] Bluetooth: hci0: advertising data len corrected
> > > [72466.498335] Bluetooth: hci0: advertising data len corrected
> > > [72469.803299] bt_err_ratelimited: 10 callbacks suppressed
> > > 
> > > Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
> > > Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=203753
> > > Cc: stable@vger.kernel.org
> > > ---
> > > 
> > >  net/bluetooth/hci_event.c | 2 --
> > >  1 file changed, 2 deletions(-)
> > > 
> > > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > > index 5e99968939ce..abdc44dc0b2f 100644
> > > --- a/net/bluetooth/hci_event.c
> > > +++ b/net/bluetooth/hci_event.c
> > > @@ -5476,8 +5476,6 @@ static void process_adv_report(struct hci_dev
> > > *hdev, u8 type, bdaddr_t *bdaddr,> > 
> > >         /* Adjust for actual length */
> > >         if (len != real_len) {
> > > 
> > > -               bt_dev_err_ratelimited(hdev, "advertising data len
> > > corrected %u -> %u", -                                      len,
> > > real_len);
> > > 
> > >                 len = real_len;
> > >         
> > >         }
> > 
> > This renders the "if" quite useless since it now always ensures len =
> > real_len and nothing else. At this point, the "if" can be removed, and
> > len can be set unconditionally. Depending on the further context of
> > the patch, destinction between real_len and len may not be needed at
> > all and real_len could be renamed to len, ditching the unused original
> > which is potentially bogus data anyways according to your commit
> > description.
> 
> That was introduced to truncate the len, the patch just removes the
> logging but it does keep this logic, if you want to understand the
> reason for it just use git blame and look at the history.

Actually, with no log there is no need for this "if" and real_len could be 
indeed avoided.

But I'd change this is subsequent patch which would not be tagged as stable 
candidate. Thoughts?


-- 
pozdrawiam
Szymon Janc


