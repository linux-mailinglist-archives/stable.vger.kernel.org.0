Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA8E21D5F4
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 14:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgGMM3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 08:29:17 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35044 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729784AbgGMM3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 08:29:16 -0400
Received: by mail-lf1-f65.google.com with SMTP id t74so8910067lff.2;
        Mon, 13 Jul 2020 05:29:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dhIY20ho0NyzjICXykt017g/FaoWbi9kWPyYXgPrdZY=;
        b=CLEenFtkFMLTRBv+giflikTX/3yJGCir+x/0ZxjDvtjPoAiPVBsSupCGkJJiNLqhoB
         bOfRgJCsiBCam9cj1HP4DOEgKW7QRNY3O1QheZCdXWMB2z+YPBHtj+wwC8ZxnzPEuSwD
         +jssv2kAZsRnmAivmEZD8XLl7IaxHJ3kZ/+UtvKlqoDqT8RfDMOuYZi/BBzyh6cj4MSm
         AC/Qq40uk24uDSzjAv9vn3EiS9X0NeX2ER44I+L7AZOur5AWg5ZQMrK40VWrSZ+53BI0
         8djoQeLPed81Dih+nA7LP1BE/8PYsa10nT/8/qUCUAVJol282wr6vtA0QZsItVzxxxYT
         ssmQ==
X-Gm-Message-State: AOAM533R5PEq5OyacfRjZPrBMK+SOrfuGoGdfs0oOy2qI2zNQzhpO4of
        QoQN6cCoT4a0TtU8/pLxbFA=
X-Google-Smtp-Source: ABdhPJwYlVrH6gr8/S2+H9BY8I+hXS7wRvvlgcW4OVMQbtXCY6Edcnmo/1UZDk9Nlvl5DygiyQ1kiw==
X-Received: by 2002:a19:2209:: with SMTP id i9mr52520721lfi.46.1594643353693;
        Mon, 13 Jul 2020 05:29:13 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id m25sm4058307ljj.128.2020.07.13.05.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 05:29:12 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1juxaC-0007eJ-MS; Mon, 13 Jul 2020 14:29:21 +0200
Date:   Mon, 13 Jul 2020 14:29:20 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "johan@kernel.org" <johan@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Message-ID: <20200713122920.GX3453@localhost>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
 <20200710103459.GA1203263@kroah.com>
 <428dc1e66dfa5fb604233046013f9fe35c4d9b5e.camel@infinera.com>
 <20200710124103.GU3453@localhost>
 <4bf0e060e72c4f1c7c53da6bbd5aa883028d1bc3.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bf0e060e72c4f1c7c53da6bbd5aa883028d1bc3.camel@infinera.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 04:05:29PM +0000, Joakim Tjernlund wrote:
> On Fri, 2020-07-10 at 14:41 +0200, Johan Hovold wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.
> > 
> > 
> > On Fri, Jul 10, 2020 at 10:46:19AM +0000, Joakim Tjernlund wrote:
> > > On Fri, 2020-07-10 at 12:34 +0200, Greg KH wrote:
> > > > 
> > > > On Fri, Jul 10, 2020 at 11:35:18AM +0200, Joakim Tjernlund wrote:
> > 
> > > > >       tty_set_operations(acm_tty_driver, &acm_ops);
> > > > > 
> > > > > -     retval = tty_register_driver(acm_tty_driver);
> > > > > +     retval = usb_register(&acm_driver);
> > > > >       if (retval) {
> > > > >               put_tty_driver(acm_tty_driver);
> > > > >               return retval;
> > > > >       }
> > > > > 
> > > > > -     retval = usb_register(&acm_driver);
> > > > > +     retval = tty_register_driver(acm_tty_driver);
> > > > >       if (retval) {
> > > > > -             tty_unregister_driver(acm_tty_driver);
> > > > > +             usb_deregister(&acm_driver);
> > > > 
> > > > Why are you switching these around?  I think I know, but you don't
> > > > really say...
> > > 
> > > I wrote:
> > >    For initial termios to reach USB core, USB driver has to be
> > >    registered before TTY driver.
> > > Found out that by trial and error. Isn't that clear enough?
> > 
> > No, that makes no sense at all since USB core does not care about
> > init_termios.
> 
> But you install acm_ops into tty:
> 	tty_set_operations(acm_tty_driver, &acm_ops);
> Perhaps there is a call into acm_ops?

No, not until the tty device has been registered by the USB driver.

> Anyhow, does it not make sense to have usb before tty as tty uses usb?

Nope, it's the other way round, and your change is therefore broken.

> Can I ask this too:
>  what is the difference between acm_tty_install and acm_tty_open ?
>  Both seems to be called at open(2)
> seems to me that install could be folded into open ?

No, their purposes are distinct and they cannot be merged.

Johan
