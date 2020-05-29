Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1641E85CB
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 19:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgE2RwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 13:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgE2RwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 13:52:09 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A79C03E969
        for <stable@vger.kernel.org>; Fri, 29 May 2020 10:52:06 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z13so271313ljn.7
        for <stable@vger.kernel.org>; Fri, 29 May 2020 10:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ntdhQMUAy4DQOem5JgLjFT9DRzL5+1nnzO/JbHz+b/c=;
        b=E8AeR5PS6lWIkd39SSGB2eLb23e0FPMuOFStst5rG5liqeT1IRh9ymwcAXnnji3BbL
         pbcDbncbF0bK/cxe5BAnjIGv//oidDa7Uf6aNnki39WJKAnbHDSISUeZCE0crdqoC+CN
         uQtEwT7OImFVsT9dwQmmaIeaBH1yDFC0JEALk+i14CGBbuVaU5F+AvWRvHp+L4BJ7lav
         ZfMFn6ljH9XN7iDkDe0L6FU+63z2GMVHFte8i8JLr3molq0z1Xf8uxhU6UUukocRsCTO
         GJDrmlE43gAKMkhJB4H3lkZQMKG7LXxfNL6JsOwfLy7elvrs+Uf5+txv1hPDpOuGVNLH
         T83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ntdhQMUAy4DQOem5JgLjFT9DRzL5+1nnzO/JbHz+b/c=;
        b=Hy2QbTztoX0nKByvw5g4GPboRXvzwulbJ0THmwe/Ww7NvP932IpzO4jBpPAMN2ViVV
         qheDE4VJOFPuaw0RU7O6YBBtyhaLORAvMbCugEettAU82m+On1nmjA+NYbif8qMstjpZ
         2J5+qYZRgkrRIHUcac5DGIAcBVO41C5A+XUYk4gdOotXJY03XV3qJCFV+j82fLaVlEk9
         PZO+w4tYqAivS9OOABoIWuPMcRsIuRqDqQLp47KgGUqIddKL1/vaEv+SiZZ1dw2anzAX
         1eXzHvy3EQTMh5uE6rOJpiMmpCp7LQcemVMSFI1i5SswgcGU7Ve8l/leyInUHwVxeiEY
         5EsA==
X-Gm-Message-State: AOAM530HQd46T/jNfy2AUVQm75dICeLMB10tpM6gcFXpaFh1cK+iH4v4
        YRMz1jeWY0qAcAiL1jeZzVS/5j1SDWk=
X-Google-Smtp-Source: ABdhPJze4egkjbf1b9ks6m2pWKQfTrO2ftN7zeQv9oHkMv2t8ylAvrv1jsCr2RxOmSFHQAvIl2fkLw==
X-Received: by 2002:a2e:b178:: with SMTP id a24mr4754778ljm.268.1590774724665;
        Fri, 29 May 2020 10:52:04 -0700 (PDT)
Received: from buimax ([109.204.208.150])
        by smtp.gmail.com with ESMTPSA id 9sm2112400ljv.137.2020.05.29.10.52.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 10:52:04 -0700 (PDT)
Date:   Fri, 29 May 2020 20:52:02 +0300
From:   Henri Rosten <henri.rosten@unikie.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, lukas.bulwahn@gmail.com
Subject: Re: Patches potentially missing from stable releases
Message-ID: <20200529175202.GA10030@buimax>
References: <20200529122445.GA32214@buimax>
 <20200529124655.GA1714108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529124655.GA1714108@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 29, 2020 at 02:46:55PM +0200, Greg KH wrote:
> On Fri, May 29, 2020 at 03:24:47PM +0300, Henri Rosten wrote:
> > We did some work on analyzing patches potentially missing from stable 
> > releases based on the Fixes: and Revert references in the commit 
> > messages. Our script is based on similar idea as described by Guenter 
> > Roeck in this earlier mail: 
> > https://lore.kernel.org/stable/20190827171621.GA30360@roeck-us.net/.
> > 
> > Although the list is not comprehensive, we figured it makes sense to 
> > publish it in case the results are of interest to someone else also.
> > 
> > The below list of potentially missing commits is based on 4.19, but some 
> > of the commits might also apply to 5.4 and 5.6.
> > 
> > For each potentially missing commit flagged by the script, we read the 
> > commit message and had a short look at the change. We then added 
> > comments on our own judgement if it might be stable material or not. No 
> > comments simply means the potentially missing patch appears stable 
> > material. "Based on commit" is the mainline patch that has been 
> > backported to 4.19 and is referenced by the missing commit. We did not 
> > check if the patch applies without changes, nor did we build or execute 
> > any tests.
> 
> That last sentence should have been a huge red flag when writing it and
> sending out this email...

Thank you for your comments.

This list was a byproduct of other analysis we did, I did not intent to 
ask these patches for inclusion into stable. We simply wanted to report 
this list in case it includes some patches that might have dropped off 
your radar. We are aware that such information without further work, 
e.g. backporting and testing does not add much yet.

Thanks,
-- Henri

