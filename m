Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFCA3017BB
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 19:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbhAWSs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 13:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbhAWSs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 13:48:27 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78A8C06174A;
        Sat, 23 Jan 2021 10:47:46 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id k8so8600628otr.8;
        Sat, 23 Jan 2021 10:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XYNFh8HCy3HllFV5puNmV9b+Du9VX0jWelFOYgjhyu4=;
        b=JNDJ+zoyreSkx9DmVwvPepwdlPL7RBxVLBuGo+4cz8uddpDXexoNZij8EaRS876e2N
         /03dlr6FQtlWMpKE9mQGq//NYl4UyFqukfNc1HTXbIrneby9nRuzzP6qSJzzob9nTL65
         WrGrJbwPVa4CJSAITCx1uijyyLgTHuGMWAhln6uN9XiecZeeeGricEJ2BS3XcKS2DPmT
         m6oFU3rEzegzhyy2rruVSZGZRQw2sjvXJs34xsv9deRMGcS0oU5m2+wNXpI2wCUnQZvN
         8xXiHnuCZ8HoZ6KRfSTGbiG+w52b9VXvlkWcAchtaMK+qFLFzLfqA5wwRxWdUKrrUWkw
         KU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=XYNFh8HCy3HllFV5puNmV9b+Du9VX0jWelFOYgjhyu4=;
        b=YgLVuaXfv7i8k4mQygbDNnaKHzN8bGsWH1gum+rD+yqjLkvPZLdRuMrinHwp5sm4ic
         wJnPjaD/oxkS6tafDIUfLb8blRP/PlrDf1zK35s9IuwrA21lWzV3Gv+g97+4eOthLXHE
         L1br3HIivMva34/RXeFXNOa86W/sM8MttM4q3BY5GOaQEx+fQ3mO7MOvSga5srrhrmT7
         ckan5a86VYnX+TyCGjWzuga9u96vqojYJdc621H5n5dSMI2USOXHuMKL4IXHmib7DjYb
         uITedFxt6NfPYJSoPxgi+YbTB3JiYlEMtuNhXNHlfOiXiB6ABOcoqCNbnkN3U08XBDw9
         pEMw==
X-Gm-Message-State: AOAM533LVsxbqWuV3DcpBBvT7pcf84lLODg1eTdKxjx217SsytwayUWD
        IoKqUTS2c9r+6KetgwwQaFs=
X-Google-Smtp-Source: ABdhPJwASq22aT3L8x8V5ei3chGMAoyuxH/n+w+/6j49VjuAm8BGXKofDv23J+QK6qYxGgTwJCX54w==
X-Received: by 2002:a05:6830:3482:: with SMTP id c2mr7429160otu.59.1611427666419;
        Sat, 23 Jan 2021 10:47:46 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l10sm2449466otn.56.2021.01.23.10.47.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 10:47:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 23 Jan 2021 10:47:44 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Tomas Winkler <tomas.winkler@intel.com>
Cc:     Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        stable@vger.kernel.org
Subject: Re: [watchdog] watchdog: mei_wdt: request stop on unregister
Message-ID: <20210123184744.GA61339@roeck-us.net>
References: <20210107195730.1660449-1-tomas.winkler@intel.com>
 <20210108001215.GA58926@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108001215.GA58926@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tomas,

On Thu, Jan 07, 2021 at 04:12:15PM -0800, Guenter Roeck wrote:
> Hi,
> 
> On Thu, Jan 07, 2021 at 09:57:30PM +0200, Tomas Winkler wrote:
> > From: Alexander Usyskin <alexander.usyskin@intel.com>
> > 
> > Send the stop command to the firmware on watchdog unregister
> > to eleminate false event on suspend.
> > 
> 
> Normally the watchdog driver would not be expected to unregister
> during suspend, only when the driver is manually unloaded.
> To support suspend/resume, other watchdog drivers implement
> suspend/resume functions to stop the watchdog on suspend and
> to restart it on resume. Unloading a watchdog driver on suspend
> would also have odd implications for userspace watchdog daemons.
> 
> On top of that, it should not actually be possible to unregister
> a watchdog while it is in use (because it is open in that case
> and should be marked as busy). watchdog_stop_on_unregister()
> only serves as backup in case someone actually manages to unload
> the driver while the watchdog is running. The function was
> implemented to avoid calls to stop the watchdog in the remove
> function because I can not mathematically prove that there are
> no situations where the watchdog is unloaded while running.
> However, I have not actually been able to do that.
> 
> Are you sure this patch is doing what you expect it to do ?
> 

I have not heard anything back. I tried to understand how this
patch would resolve a problem during suspend/resume, but
I didn't find anything.

Can you maybe add a log message showing the false event that is
prevented with this patch, and some context explaining how the
patch fixes the problem ?

Thanks,
Guenter

> Thanks,
> Guenter
> 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > ---
> >  drivers/watchdog/mei_wdt.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/watchdog/mei_wdt.c b/drivers/watchdog/mei_wdt.c
> > index 5391bf3e6b11..c5967d8b4256 100644
> > --- a/drivers/watchdog/mei_wdt.c
> > +++ b/drivers/watchdog/mei_wdt.c
> > @@ -382,6 +382,7 @@ static int mei_wdt_register(struct mei_wdt *wdt)
> >  
> >  	watchdog_set_drvdata(&wdt->wdd, wdt);
> >  	watchdog_stop_on_reboot(&wdt->wdd);
> > +	watchdog_stop_on_unregister(&wdt->wdd);
> >  
> >  	ret = watchdog_register_device(&wdt->wdd);
> >  	if (ret)
> > -- 
> > 2.26.2
> > 
