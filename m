Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C133755B3
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 16:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbhEFOdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 10:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbhEFOdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 10:33:13 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259C1C061574;
        Thu,  6 May 2021 07:32:14 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t21so3500366plo.2;
        Thu, 06 May 2021 07:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WVfr4odGyjYCFkn+cWmYchYIKtyNAZgTplQ3rJaoLBg=;
        b=PoMoohbt54IW/RSLkF/VgsYbGNEz9AdeKHoKagbdpK+qrg8xBgUZZg/tS1lvc83PT1
         xXmDrYFJZBiGPzhoJoRJoZBK1jkomGsdkqfVeWmYt70DKrkCsYOnmFPaUZysv+ORiS9+
         4i+z+4CjKSgiSblR+HGe6cQH6+KicaVHMbqRgfKEDhkdodfkzvO3XtxtekEzxvb+3Tfi
         rVm+OgZIVjOBtrT8F3rPnW/JWeD0gKmIyWT2TmAjimytdrwXL14zqFQcVB+oZJlnxKPk
         XXvHT1Lo5sL/psBbGxI385K9P6nKbENjj4VlMNl39Nnkg+GC0n/8qMorsFF3xoqvfsoY
         b2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WVfr4odGyjYCFkn+cWmYchYIKtyNAZgTplQ3rJaoLBg=;
        b=cm90RTyu6m8FQG64X2VMoUhsS6yeWr0TF8+VHeeHkFihRxZ+giU0zK2NnoXuxN8S9o
         Js54aIie8VmWV/kcA8lX6i3MbKksuYbUuRP4PBCC9anky5tc4Kbz30BhlKnZDsWhpe5t
         eE+GrylKtszThiMmpzL/CpIiqHOvA8S25+KlsUD1EyKuFmEowbCjFuvcB/OtqfyuiUNU
         663P6s6ShLnLnIFWsvgwGcNXVeXVvffIbwz36p8/TIUrnXDK2v/LxF3VjjVVsv96uTti
         SvbTJ9VHkL3DeM88U83ZOu0JDfVQbMQUqvI8JOmJKXsFqN/AEba4PVvtqGFcg7lZG4Mc
         PPDw==
X-Gm-Message-State: AOAM532gQrKtguyPwdCLCUg9WwBhQlFXwuFeZAS3zgKof65RzphxBomR
        dDZt1kqC8Wr6xjxR2hi6wDv0HcPt7Qg=
X-Google-Smtp-Source: ABdhPJz22zMcfrUvRfstit40VF01ft/4yUsm3/j7/2G86ipdCBi+pkixmCvKDPoVmwW1x3NCQQDJgw==
X-Received: by 2002:a17:90a:de17:: with SMTP id m23mr5043492pjv.16.1620311533579;
        Thu, 06 May 2021 07:32:13 -0700 (PDT)
Received: from atulu-nitro ([122.178.201.168])
        by smtp.gmail.com with ESMTPSA id u1sm2462759pfb.97.2021.05.06.07.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 07:32:12 -0700 (PDT)
Date:   Thu, 6 May 2021 20:02:08 +0530
From:   Atul Gopinathan <atulgopinathan@gmail.com>
To:     Peter Rosin <peda@axentia.se>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 27/69] cdrom: gdrom: deallocate struct gdrom_unit fields
 in remove_gdrom
Message-ID: <20210506143208.GA7971@atulu-nitro>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
 <20210503115736.2104747-28-gregkh@linuxfoundation.org>
 <223d5bda-bf02-a4a8-ab1d-de25e32b8d47@axentia.se>
 <YJPDzqAAnP0jDRDF@kroah.com>
 <dd716d04-b9fa-986a-50dd-5c385ea745b2@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd716d04-b9fa-986a-50dd-5c385ea745b2@axentia.se>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 06, 2021 at 03:08:08PM +0200, Peter Rosin wrote:
> Hi!
> 
> On 2021-05-06 12:24, Greg Kroah-Hartman wrote:
> > On Mon, May 03, 2021 at 04:13:18PM +0200, Peter Rosin wrote:
> >> Hi!
> >>
> >> On 2021-05-03 13:56, Greg Kroah-Hartman wrote:
> >>> From: Atul Gopinathan <atulgopinathan@gmail.com>
> >>>
> >>> The fields, "toc" and "cd_info", of "struct gdrom_unit gd" are allocated
> >>> in "probe_gdrom()". Prevent a memory leak by making sure "gd.cd_info" is
> >>> deallocated in the "remove_gdrom()" function.
> >>>
> >>> Also prevent double free of the field "gd.toc" by moving it from the
> >>> module's exit function to "remove_gdrom()". This is because, in
> >>> "probe_gdrom()", the function makes sure to deallocate "gd.toc" in case
> >>> of any errors, so the exit function invoked later would again free
> >>> "gd.toc".
> >>>
> >>> The patch also maintains consistency by deallocating the above mentioned
> >>> fields in "remove_gdrom()" along with another memory allocated field
> >>> "gd.disk".
> >>>
> >>> Suggested-by: Jens Axboe <axboe@kernel.dk>
> >>> Cc: Peter Rosin <peda@axentia.se>
> >>> Cc: stable <stable@vger.kernel.org>
> >>> Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
> >>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>> ---
> >>>  drivers/cdrom/gdrom.c | 3 ++-
> >>>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
> >>> index 7f681320c7d3..6c4f6139f853 100644
> >>> --- a/drivers/cdrom/gdrom.c
> >>> +++ b/drivers/cdrom/gdrom.c
> >>> @@ -830,6 +830,8 @@ static int remove_gdrom(struct platform_device *devptr)
> >>>  	if (gdrom_major)
> >>>  		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
> >>>  	unregister_cdrom(gd.cd_info);
> >>> +	kfree(gd.cd_info);
> >>> +	kfree(gd.toc);
> >>>  
> >>>  	return 0;
> >>>  }
> >>> @@ -861,7 +863,6 @@ static void __exit exit_gdrom(void)
> >>>  {
> >>>  	platform_device_unregister(pd);
> >>>  	platform_driver_unregister(&gdrom_driver);
> >>> -	kfree(gd.toc);
> >>>  }
> >>>  
> >>>  module_init(init_gdrom);
> >>>
> >>
> >> I worry about the gd.toc = NULL; statement in init_gdrom(). It sets off
> >> all kinds of warnings with me. It looks completely bogus, but the fact
> >> that it's there at all makes me go hmmmm.
> > 
> > Yeah, that's bogus.
> > 
> >> probe_gdrom_setupcd() will arrange for gdrom_ops to be used, including
> >> .get_last_session pointing to gdrom_get_last_session() 
> >>
> >> gdrom_get_last_session() will use gd.toc, if it is non-NULL.
> >>
> >> The above will all be registered externally to the driver with the call
> >> to register_cdrom() in probe_gdrom(), before a possible stale gd.toc is
> >> overwritten with a new one at the end of probe_gdrom().
> > 
> > But can that really happen given that it hasn't ever happened before in
> > a real system?  :)
> > 
> >> Side note, .get_last_session is an interesting name in this context, but
> >> I have no idea if it might be called in the "bad" window (but relying on
> >> that to not be the case would be ... subtle).
> >>
> >> So, by simply freeing gd.toc in remove_gdrom() without also setting
> >> it to NULL, it looks like a potential use after free of gd.toc is
> >> introduced, replacing a potential leak. Not good.
> > 
> > So should we set it to NULL after freeing it?  Is that really going to
> > help here given that the probe failed?  Nothing can use it after
> > remove_gdrom() is called because unregiser_* is called already.
> > 
> > I don't see the race here, sorry.
> > 
> >> The same is not true for gd.cd_info as far as I can tell, but it's a bit
> >> subtle. gdrom_probe() calls gdrom_execute_diagnostics() before the stale
> >> gd.cd_info is overwritten, and gdrom_execute_diagnostic() passes the
> >> stale pointer to gdrom_hardreset(), which luckily doesn't use it. But
> >> this is - as hinted - a bit too subtle for me. I would prefer to have
> >> remove_gdrom() also clear out the gd.cd_info pointer.
> > 
> > Ok, but again, how can that be used after remove_gdrom() is called?
> > 
> >> In addition to adding these clears of gd.toc and gd.cd_info to
> >> remove_gdrom(), they also need to be cleared in case probe fails.
> >>
> >> Or instead, maybe add a big fat
> >> 	memset(&gd, 0, sizeof(gd));
> >> at the top of probe?
> > 
> > Really, that's what is happening today as there is only 1 device here,
> > and the whole structure was zeroed out already.  So that would be a
> > no-op.
> > 
> >> Or maybe the struct gdrom_unit should simply be kzalloc:ed? But that
> >> triggers some . to -> churn...
> > 
> > Yes, ideally that would be the correct change, but given that you can
> > only have 1 device in the system at a time of this type, it's not going
> > to make much difference at all here.
> > 
> >> Anyway, the patch as proposed gets a NACK from me.
> > 
> > Why?  It fixes the obvious memory leak, right?  Worst case you are
> > saying we should also set to NULL these pointers, but I can not see how
> > they are accessed as we have already torn everything down.
> 
> I'm thinking this:
> 
> 1. init_gdrom() is called. gd.toc is NULL and is bogusly re-set to NULL.
> 2. probe_gdrom() is called and succeeds. gd.toc is allocted.
> 3. device is used, etc etc, whatever
> 4. remove_gdrom() is called. gd.toc is freed (but not set to NULL).
> 5. probe_gdrom() is called again. Boom.
> 
> In 5, gd.toc is not NULL, and is pointing to whatever. It is
> potentially used by probe_gdrom() before it is (re-)allocated.

I guess I'm late and it seems like a conclusion has already been
reached, so this mail doesn't really add up to anything. I just had a
doubt in my mind which I wanted to clarify:

as Peter said, probe_gdrom() calls "probe_gdrom_setupcd()" which defines
the ops, this includes "gdrom_get_last_session()" which is the only
function that uses the data of "gd.toc".

It then calls "register_cdrom()", I went through the function definition
of this and found only one line which has anything to do with
".get_last_session":

	int register_cdrom(struct gendisk *disk, struct cdrom_device_info *cdi)
	{
		static char banner_printed;
		const struct cdrom_device_ops *cdo = cdi->ops;
		.
		.<snipped>
		.
----->		ENSURE(cdo, get_last_session, CDC_MULTI_SESSION);
		.
	}

The defintion of the ENSURE macro is this:

	#define ENSURE(cdo, call, bits)					\
	do {								\
		if (cdo->call == NULL)					\
			WARN_ON_ONCE((cdo)->capability & (bits));	\
	} while (0)

So here it is only checking if .get_last_session field is null or not,
and not calling it.

Apart from this, I don't see gdrom_get_last_session() being called
anywhere. But I could be missing something obvious too. 

If you don't mind, could you point out where gd.toc is being used in
probe_gdrom() before it is kzalloc-ed in the same function.


Thanks for the review!
Atul
