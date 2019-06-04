Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D8A35179
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 22:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFDU5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 16:57:44 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45700 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfFDU5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 16:57:44 -0400
Received: by mail-lf1-f65.google.com with SMTP id u10so10451077lfm.12
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 13:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bML0yxEZ55a3hV+DSfUrlsRp9njWmbey5g4KNB1QRmU=;
        b=m8JrSPi2NL+Zc5vsMANgT2U/1SZgCD8B0/lscDLgOEQXwpC6wvsfjxRPp4e1byjP50
         95u8vYyxQDNXIdanbRzc/UTb3TzQ9lnqIt2q+x4wzh9u3yZoVdjc5XjDLjyeXgpF/6DT
         LpszLlezTnx1BEmJGSc87Q0yjP7GWglc+/0cU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bML0yxEZ55a3hV+DSfUrlsRp9njWmbey5g4KNB1QRmU=;
        b=e8QstopRgbsfjnwYz/UrmJ/DnMHVWAUZF7d/JnWxJjRSs4IPK7AI9jlNJ+V/BiVaJO
         6mCMs6irHZJKsRevBF+cx/ZIqrhlYv0WYFat+ugt5vGomBU+CG7zEu/4hwKaOOB2CCc/
         XAIopCe4aT6dX2nsuR+XXSzWY20W6u3qgoCraMy65/cpj1Dtth1S7hscKjLPXufNxAH2
         JuSDDjo1WjPMai82FxU+iV0564vWcfu6v19i+KsNporGhF2c0DkD1qepMU+Qfp9NmPax
         zdd8Qohxn0wcpazkGffL47pU/WkOOduENjihfxowyQSJTbgDrx8K5Ja6bhJeDTMCTdXy
         Mnkw==
X-Gm-Message-State: APjAAAV5YdmNCXD6CnQxGUnez8aVh348156T9gTCUmmiH6wsZQbfU6wC
        e36ApPVTg0OMe1KKdK8XB5/1x07OYiU=
X-Google-Smtp-Source: APXvYqzGqv42kw5Ie/dIJmLdwhErRIs1dI9dolwEqVmAuhYIyC5vsW3v9FJ7AddwyLNloIr3T6Aquw==
X-Received: by 2002:ac2:4899:: with SMTP id x25mr15450101lfc.44.1559681861316;
        Tue, 04 Jun 2019 13:57:41 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id p27sm412313lfo.16.2019.06.04.13.57.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 13:57:40 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id l26so17462111lfh.13
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 13:57:39 -0700 (PDT)
X-Received: by 2002:a19:6e41:: with SMTP id q1mr10011222lfk.20.1559681859360;
 Tue, 04 Jun 2019 13:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20181130175957.167031-1-briannorris@chromium.org>
 <20190308023401.GA121759@google.com> <MN2PR18MB26376D3A660956396D0E60AFA0150@MN2PR18MB2637.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB26376D3A660956396D0E60AFA0150@MN2PR18MB2637.namprd18.prod.outlook.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 4 Jun 2019 13:57:27 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOe8t9b4vwv6_r9B+3MJ8gKZ_6NN8x6mA5X5scWDt7Xzw@mail.gmail.com>
Message-ID: <CA+ASDXOe8t9b4vwv6_r9B+3MJ8gKZ_6NN8x6mA5X5scWDt7Xzw@mail.gmail.com>
Subject: Re: [EXT] Re: [4.20 PATCH] Revert "mwifiex: restructure
 rx_reorder_tbl_lock usage"
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ganapathi,

On Mon, Jun 3, 2019 at 8:04 PM Ganapathi Bhat <gbhat@marvell.com> wrote:
> > There are a few possible ways to handle this:
> > (a) prevent processing softirqs in that context; e.g., with
> >     local_bh_disable(). This seems somewhat of a hack.
> >     (Side note: I think most of the locks in this driver really could be
> >     spin_lock_bh(), not spin_lock_irqsave() -- we don't really care
> >     about hardirq context for 99% of these locks.)
> > (b) restructure so that packet processing (e.g., netif_rx_ni()) is done
> >     outside of the spinlock.
> >
> > It's actually not that hard to do (b). You can just queue your skb's up in a
> > temporary sk_buff_head list and process them all at once after you've
> > finished processing the reorder table. I have a local patch to do this, and I
> > might send it your way if I can give it a bit more testing.
>
> OK; That will be good; We will run a complete test after the patch; (OR we can work on this, share for review);

I gave my work another round of testing and submitted it here:

https://patchwork.kernel.org/cover/10976089/
[PATCH 0/2] mwifiex: spinlock usage improvements

Feel free to give it a spin. It doesn't completely resolve everything
you were trying to fix, but I believe it helps nudge things in the
right direction.

Brian
