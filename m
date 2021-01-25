Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B7D302C68
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 21:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731999AbhAYUUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 15:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732157AbhAYUUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 15:20:21 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3E6C061573;
        Mon, 25 Jan 2021 12:19:41 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id q3so3581292oog.4;
        Mon, 25 Jan 2021 12:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=TOMpPd11zmzVUjqkEO7S2YQ3HvOrNWk6xiDVCpWtcCM=;
        b=ojQTPATwo/zsVBVmOfPpvXAEpoWR6rsubog+KAHbgcY8dm/Q4N76i4y2ZrmipUqE55
         5epAZldjBRqdT/ycugDyNPjuPC6pDlL17XNZKg0ldvdkJF/HA0VLhYjahvY7IiUOpIBa
         Zoe0KewuDcVdW4o++6QEZelnhKqsk2/4m3L7u2P4kB7jeEc1pFefcqna5B8Bq6WdMOnH
         CDaPsHdzu5FS5teBBV3EqeYL24fV217L8EtfXKNMOKwF4sSS4/l9HNwHYG1QCbQjEGBN
         HbdURM3DlYIg+NXfHU0REv+Z/KSKQmVTxArvGYSGI4BMF8moD2YSnCxVwGGYHXN/SlQc
         Pp/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=TOMpPd11zmzVUjqkEO7S2YQ3HvOrNWk6xiDVCpWtcCM=;
        b=CMg2dvrv2Iw7HZ80Fzului67xyq6r9vzEJ2uiJXA0uS7bYf3OZGwXXMB+fQqoM1Gzo
         Gb5vpqb2FIXqXD6EhuojdpESgFVRle1kVPTESMzjrc97dJSE7OiT1wL0ZIzf/Ncu6HSi
         MC8Rh97g62Pe2DbYcSX2IAKGTZzwCroHPZDzDJWVZFMMh7xjRelmVAUPOF9GIoD+sQMz
         YHqxGordFjHW5Cut3rqxdUEfuMD0ZDam8+wYep1qs5TRTBzspav3A0rhMZSpummKp2hK
         GyCixhD5u/kOCBoKWQ5h9zEfwAvDVxHnNL/2b4wA6Ay9WQEc7nelHdqCSOHbBIOUGOdJ
         jMLg==
X-Gm-Message-State: AOAM531X6OOGq3ZBY7JKjXIFjyuKCwUNjpO9AvGCKckJHoHioFxJweMK
        C8d+Zi05xy4FCFjLjmyWwZ1QjsUxjhw=
X-Google-Smtp-Source: ABdhPJytxl014k0jsWt6Dm8vCwO+1EQFH2+gPnz592HDCkpJ6txGWEFdYoCZp7VsBiGTmDWL0NLyUg==
X-Received: by 2002:a4a:58d6:: with SMTP id f205mr1599140oob.38.1611605980572;
        Mon, 25 Jan 2021 12:19:40 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k65sm3694559oia.19.2021.01.25.12.19.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Jan 2021 12:19:39 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 25 Jan 2021 12:19:38 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Thomas Hebb <tommyhebb@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bob Hepple <bob.hepple@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control
 blacklist
Message-ID: <20210125201938.GB78651@roeck-us.net>
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
 <20210125100540.55wbgdsem3htplx3@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210125100540.55wbgdsem3htplx3@pali>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 11:05:40AM +0100, Pali Rohár wrote:
> On Saturday 23 January 2021 18:46:08 Thomas Hebb wrote:
> > It has been reported[0] that the Dell XPS 15 L502X exhibits similar
> > freezing behavior to the other systems[1] on this blacklist. The issue
> > was exposed by a prior change of mine to automatically load
> > dell_smm_hwmon on a wider set of XPS models. To fix the regression, add
> > this model to the blacklist.
> > 
> > [0] https://bugzilla.kernel.org/show_bug.cgi?id=211081
> > [1] https://bugzilla.kernel.org/show_bug.cgi?id=195751
> > 
> > Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all XPS models")
> > Cc: stable@vger.kernel.org
> > Reported-by: Bob Hepple <bob.hepple@gmail.com>
> > Tested-by: Bob Hepple <bob.hepple@gmail.com>
> > Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> > ---
> > 
> >  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
> > index ec448f5f2dc3..73b9db9e3aab 100644
> > --- a/drivers/hwmon/dell-smm-hwmon.c
> > +++ b/drivers/hwmon/dell-smm-hwmon.c
> > @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklist_fan_support_dmi_table[] __initdata = {
> >  			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
> >  		},
> >  	},
> > +	{
> > +		.ident = "Dell XPS 15 L502X",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L502X"),
> 
> Hello! Are you sure that it is required to completely disable fan
> support? And not only access to fan type label for which is different
> blaclist i8k_blacklist_fan_type_dmi_table?
> 

I'll drop this patch from my branch. Please send a Reviewed-by: or Acked-by: tag
if/when I should apply it.

Thanks,
Guenter
