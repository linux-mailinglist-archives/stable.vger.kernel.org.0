Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CB2363545
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhDRMln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhDRMln (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:41:43 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E41C06174A;
        Sun, 18 Apr 2021 05:41:13 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w18so37526144edc.0;
        Sun, 18 Apr 2021 05:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9l49uFbLkgIik9usiP43+fyhXLP8o1RWVYKlZbXWjbg=;
        b=p45jUPjo+MHkKGTXCxdIdOQrfIkVXWZOcTRxXWD94RDRkG56XFojDcwK9h5YxB5kpI
         fy7YGRhk0P9nk6VJ62orBuhEyDUCa2IikLJCaSILAdTzeSX2YUiQprQG/7CWBiJblV6d
         udNFKE0UuJi80kj4VETQicZM0NOgRYkztHWQdTdCjiyxYFmDHKEThLnj9Tvs5T/TjF6T
         5Qxg2lXkEBZ7EU6w8baLFtatYC51KNJLmx3Y0WF3dTVx11FBRNTG8GoJobDuTytdoBey
         r6uCv9CwBleLIN+7T2c3ew1SD7BYO7L2P59kdcrzHs84OYD98NCS+W7H+EKGvJmVP5j4
         OF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9l49uFbLkgIik9usiP43+fyhXLP8o1RWVYKlZbXWjbg=;
        b=Hg8E1QRMlYL/q/yi7ufwp4pUfPfqFOlptjoojBb6yP07Mw1IN5E6yfWgCPx15e+FAj
         7KZ1ZSQMVSrAWhhpAavTwmSunmCITVUtTTtu9lmLO5Is5vIv0WTdDNKf2WthwmnOWmR8
         AGqC/Qbs413ttGhh6pYwq9w/FOdJuulRFSOpmKNyORzSTp/XX0RmEiIfOA47C+aHbhz/
         FaUspzwlEMiteolH0L7D7GrDdklOTj9xaQsrhPAsU/2WPbdoOTo+W9QEf+Fz1ytieyL2
         qMJZJqZcBoML0f4zYheTaMfzXkfpEcHoxorG9qHfk0qxanyIRymqfiMi9whneF/DhLeq
         jvMQ==
X-Gm-Message-State: AOAM532yi0uzFtbXBWbhj/HEBdc8gdbEHNDaxjgqUTBQ6avzLTklBr61
        wDuAFmrC/LF2rqPzgsO9ZKE=
X-Google-Smtp-Source: ABdhPJyMePlyGyjBqX2A9ADyUs3MPbmgwkrcUewxptg+iQFYWvYf7Epch2v7701f+2b2lSjTKzresw==
X-Received: by 2002:a05:6402:3ce:: with SMTP id t14mr3986843edw.142.1618749672167;
        Sun, 18 Apr 2021 05:41:12 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id m10sm8201553ejc.32.2021.04.18.05.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 05:41:11 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sun, 18 Apr 2021 14:41:10 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Shyam Prasad <Shyam.Prasad@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Message-ID: <YHwo5prs4MbXEzER@eldamar.lan>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org>
 <YGxIMCsclG4E1/ck@eldamar.lan>
 <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan>
 <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHP+XbVWfGv21EL1@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 12, 2021 at 10:01:33AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 08, 2021 at 01:41:05PM +0200, Salvatore Bonaccorso wrote:
> > Hi Shyam,
> > 
> > On Tue, Apr 06, 2021 at 05:01:17PM +0200, Salvatore Bonaccorso wrote:
> > > Hi,
> > > 
> > > On Tue, Apr 06, 2021 at 02:00:48PM +0000, Shyam Prasad wrote:
> > > > Hi Greg,
> > > > We'll need to debug this further to understand what's going on. 
> > > 
> > > Greg asked it the same happens with 5.4 as well, I do not know I was
> > > not able to test 5.4.y (yet) but only 5.10.y and 4.19.y.
> > > > 
> > > > Hi Salvatore,
> > > > Any chance that you'll be able to provide us the cifsFYI logs from the time of mount failure?
> > > > https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugging
> > > 
> > > Please find it attached. Is this enough information?
> > > 
> > > The mentioned home DFS link 'home' is a DFS link to
> > > msdfs:SECONDHOST\REDACTED on a Samba host.
> > > 
> > > The mount is triggered as
> > > 
> > > mount -t cifs //HOSTIP/REDACTED/home /mnt --verbose -o username='REDACTED,domain=DOMAIN'
> > 
> > So I can confirm the issue is both present in 4.19.185 and 5.4.110
> > upstream (without any Debian patches applied, we do not anyway apply
> > any cifs related one on top of the respetive upstream version).
> > 
> > The issue is not present in 5.10.28.
> > 
> > So I think there are commits as dependency of a738c93fb1c1 ("cifs: Set
> > CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.") which
> > are required and not applied in the released before 5.10.y which make
> > introducing the regression.
> 
> Ok, I've dropped this from 5.4 and older kernel trees now, thanks for
> the report.

Thanks Greg! Shyam, Steven, now the commit was reverted for the older
brnaches. But did you got a chance to find why it breaks for the older
series?

Regards,
Salvatore
