Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998AA1093C1
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 19:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfKYSwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 13:52:16 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:44342 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKYSwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 13:52:16 -0500
Received: by mail-pj1-f65.google.com with SMTP id w8so6990849pjh.11;
        Mon, 25 Nov 2019 10:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JEuDBuIbsPCbqhT1+qaFvO9JHqg2+xT1GFhiQC+2+xc=;
        b=JEe/TGJJlEHUn9idyG7t66OXmw9QvEUOS1J/rnBzoDIcvcaeqwYgAMl0ivexsBYKSY
         wGFpgZVhe5eRv4sEzbkHHL1IbvkHsYnQGvf8FcAV8crC7GhTPPMQ3ZbBLpyqkz7Bz1K6
         svHZgcN9X3kosAS7DwoO2Z6oUd2u4+0ImpAhD3mo0Yu+taouax3+Rimcu8wM0RWS4V1M
         J2F2gjQOP0Fmd460A1E03i/KADeRkWZWbTxFHmgMFDhjxQijyRyS2AIgc714RpMq4PCR
         he5TgwUgUZs95l9pqtd9RWVBOaOlcNoO/v6fNz+IwdmBNUdd8FzyyfTO0OXv4NJ960Uo
         YE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JEuDBuIbsPCbqhT1+qaFvO9JHqg2+xT1GFhiQC+2+xc=;
        b=p+3FB7tacsr2NncDRw54aUSL2MAApODwPif/KALgv6jCykVQJNLIkQXrIT2sgrK1/X
         LejamCZxbwbLxqO14nKfb2shULdm8hhfEMR5hQiU2KI/KwEoBiEMTICtgOpPaxgjv4qz
         /Y5rTKqhOg3JZDYBbtNqz5+x1SBGCzoXNhQxqTtA3ZTvW2892I96CHByFJbvQQ/R+TxN
         f9JWRLfYkR8mMdWHd2DIqqW13/hI8w4NEApMJPskJZwlMCVsRKwFWaPhdBgpbCbPQl07
         Wy2Y+0xC/dFENtDsPX8gRFFd3LRJLzsE/FzrAot7S5h8u3FjdKMeDhsyabbF9tKpuc6x
         Yy7Q==
X-Gm-Message-State: APjAAAXMmUJMMf8CnQzwwCfjiuRp56IWNXuzYhQauGJAWdoi59dXcqCM
        K7UERd5UYxrDGASIsRJSJIc=
X-Google-Smtp-Source: APXvYqxQXj5RSszdRYxGJ7EgTM9XnsG+4Kf7wc8guAWagKfgL63JUiHs9jX9jHcRAgkAEC/QL163fg==
X-Received: by 2002:a17:902:9a87:: with SMTP id w7mr13859312plp.120.1574707934861;
        Mon, 25 Nov 2019 10:52:14 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id v14sm96558pja.22.2019.11.25.10.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 10:52:14 -0800 (PST)
Date:   Mon, 25 Nov 2019 10:52:11 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        Nick Black <dankamongmen@gmail.com>,
        Yussuf Khalil <dev@pp3345.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexander Mikhaylenko <exalm7659@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "Input: synaptics - enable RMI mode for X1
 Extreme 2nd Generation"
Message-ID: <20191125185211.GJ248138@dtor-ws>
References: <20191119234534.10725-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119234534.10725-1-lyude@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 06:45:33PM -0500, Lyude Paul wrote:
> This reverts commit 68b9c5066e39af41d3448abfc887c77ce22dd64d.
> 
> Ugh, I really dropped the ball on this one :\. So as it turns out RMI4
> works perfectly fine on the X1 Extreme Gen 2 except for one thing I
> didn't notice because I usually use the trackpoint: clicking with the
> touchpad. Somehow this is broken, in fact we don't even seem to indicate
> BTN_LEFT as a valid event type for the RMI4 touchpad. And, I don't even
> see any RMI4 events coming from the touchpad when I press down on it.
> This only seems to work for PS/2 mode.
> 
> Since that means we have a regression, and PS/2 mode seems to work fine
> for the time being - revert this for now. We'll have to do a more
> thorough investigation on this.
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Cc: stable@vger.kernel.org

This has been applied, thank you.

-- 
Dmitry
