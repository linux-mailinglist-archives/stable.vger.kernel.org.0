Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86D8132501
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 12:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgAGLgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 06:36:23 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37253 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbgAGLgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 06:36:23 -0500
Received: by mail-lj1-f196.google.com with SMTP id o13so42934906ljg.4
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 03:36:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vnEsV8FzLQSrbuYsfN0kuk83vqSw010xbnvF2/8+3xI=;
        b=LoTcavv8TuYNox3QdCqYPFzg3h/Q3Ew1NnP3hfOkboM3Y5eIyzazKEoMYJqdedj563
         CQvpn9hkL0tu1vxZIvUzwXr29o2ThDQ6G/de/Vb4qEab2JNWYOgRlh9ikYF/WX/nPomD
         H8DNlUvzxyoHnJbJk36XU5CqyACdDGuALj7scVhMFFbBP0EideXOPRG2qub0Y6BOYIdZ
         gbPu8oxbvj3BB663sxrgya5APjkJ5Krl3WHVEBv2xJw+uifHj+OkIBYknIwLIFf7KZbT
         NHO183MGqMrO53Kprj1NErNwr00KtqzyNI6XboMC14M7YDy1rIff4mJDo6NsBpGB77Jm
         WOoA==
X-Gm-Message-State: APjAAAUH7nm4l47qDAxJi5Dh7NJYRk+rt35RVraOgLjyRmLzUwrPCx2d
        /ES06sxPnlqsIqdfnfBBekw=
X-Google-Smtp-Source: APXvYqw8g+CwBlsG2Jt+xXnL+u8qjwAjA0S6BaN9EPxWrG8wADkyt0kjrM9Ieh3oI3YuuPpqNEb01g==
X-Received: by 2002:a2e:a168:: with SMTP id u8mr55055475ljl.5.1578396981644;
        Tue, 07 Jan 2020 03:36:21 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id q26sm30279323lfb.26.2020.01.07.03.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 03:36:20 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1ion9x-0005pT-0O; Tue, 07 Jan 2020 12:36:29 +0100
Date:   Tue, 7 Jan 2020 12:36:29 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        Oliver Neukum <oneukum@suse.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/6] media: flexcop-usb: fix endpoint sanity check
Message-ID: <20200107113629.GF30908@localhost>
References: <20200103163513.1229-2-johan@kernel.org>
 <20200104152131.E34BA21734@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200104152131.E34BA21734@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 04, 2020 at 03:21:31PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 1b976fc6d684 ("media: b2c2-flexcop-usb: add sanity checking").
> 
> The bot has tested the following trees: v5.4.7, v5.3.18, v4.19.92, v4.14.161, v4.9.207, v4.4.207.
> 
> v5.4.7: Build OK!
> v5.3.18: Failed to apply! Possible dependencies:
>     649cd16c438f ("media: flexcop-usb: fix NULL-ptr deref in flexcop_usb_transfer_init()")
> 
> v4.19.92: Build OK!
> v4.14.161: Build OK!
> v4.9.207: Failed to apply! Possible dependencies:
>     649cd16c438f ("media: flexcop-usb: fix NULL-ptr deref in flexcop_usb_transfer_init()")
> 
> v4.4.207: Failed to apply! Possible dependencies:
>     649cd16c438f ("media: flexcop-usb: fix NULL-ptr deref in flexcop_usb_transfer_init()")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Just fix the trivial context change when backporting.

Johan
