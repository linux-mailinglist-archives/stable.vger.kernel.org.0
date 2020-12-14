Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B622D9888
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 14:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407799AbgLNNHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 08:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407802AbgLNNHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 08:07:09 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130AAC061793
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 05:06:29 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id d14so14708013qkc.13
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 05:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=0WuvEppDleV+S7pcqpHxzCQflrbfbHnaCqqVzPSevY8=;
        b=WB4x6JSvNaAdYyu5uKrfp9edqClNEBHeo80crhHJgzMSX7V+9akduyKk+G6dctmVp+
         x9+JSCnFXt17Kea5ydmnhC/J8tM2e9zhPb+7i7UtRRQUikme8UaUdo9+OMBD0KiupAKB
         SJCMUIjMzlxjUgCgpMXeDLPTnRTsyqqgfSZYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=0WuvEppDleV+S7pcqpHxzCQflrbfbHnaCqqVzPSevY8=;
        b=UlWcOpSdFc0+cGpv249nc1bK+FYubI3eZwDBEVVW1Q5Jaaz9GAu30tYNWi6fhfLflt
         xbrzJaSzSiPJkySVEMCcV6Jh8kF3QQ7u3PqFKAWuzoXDVbgfepvJb/PI0hbGPOv33SIY
         MXZdjmhqp0RYQyXu251wMkkx4EHqqBpC/nbU1OEaxkLaVz7IfXybW2PsmRjMMoyXu88J
         ltaLNJLIxBJ19uELH8zBhF85BEhLxb/RNrBGdl+0YIIuv4TkBfpSEKW8nXGEo8yJhbO/
         79BAbuhFqUwA4JZNZgbadJtyg67SXUyRgGc/AzMI6faD3h9dPHYcU26FNkoNDwqmCoP2
         zO8A==
X-Gm-Message-State: AOAM531NeMJBjex0ne3M3ay/GG5/afx0en5BMkWi/9cs76D0CUVu0dbf
        aGox8orknBAST2xHsAnWMRWN0g==
X-Google-Smtp-Source: ABdhPJw94VHAaeYO/S57fRpgTfG5neMu6DcTMz24l3inWNQg2cpmf5vYTNLAlzT1E3QnXvk8n5wLdg==
X-Received: by 2002:a37:5242:: with SMTP id g63mr31559196qkb.317.1607951188064;
        Mon, 14 Dec 2020 05:06:28 -0800 (PST)
Received: from chatter.i7.local ([89.36.78.230])
        by smtp.gmail.com with ESMTPSA id x47sm14799292qtb.86.2020.12.14.05.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 05:06:26 -0800 (PST)
Date:   Mon, 14 Dec 2020 08:06:25 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrea Parri <parri.andrea@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        devel@linuxdriverproject.org,
        Saruhan Karademir <skarade@microsoft.com>
Subject: Re: [PATCH AUTOSEL 5.9 15/23] scsi: storvsc: Validate length of
 incoming packet in storvsc_on_channel_callback()
Message-ID: <20201214130625.x2v53xhx5xw6jp4o@chatter.i7.local>
Mail-Followup-To: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        devel@linuxdriverproject.org,
        Saruhan Karademir <skarade@microsoft.com>
References: <20201212160804.2334982-1-sashal@kernel.org>
 <20201212160804.2334982-15-sashal@kernel.org>
 <20201212180901.GA19225@andrea>
 <20201214110711.GB2831@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201214110711.GB2831@kadam>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 02:07:11PM +0300, Dan Carpenter wrote:
> On Sat, Dec 12, 2020 at 07:09:01PM +0100, Andrea Parri wrote:
> > Hi Sasha,
> > 
> > On Sat, Dec 12, 2020 at 11:07:56AM -0500, Sasha Levin wrote:
> > > From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
> > > 
> > > [ Upstream commit 3b8c72d076c42bf27284cda7b2b2b522810686f8 ]
> > 
> > FYI, we found that this commit introduced a regression and posted a
> > revert:
> > 
> >   https://lkml.kernel.org/r/20201211131404.21359-1-parri.andrea@gmail.com
> > 
> > Same comment for the AUTOSEL 5.4, 4.19 and 4.14 you've just posted.
> > 
> 
> Konstantin, is there anyway we could make searching lore.kernel.org
> search all the mailing lists?  Right now we can only search one mailing
> list at a time.

This functionality is coming in the next version of public-inbox and 
should be available on lore.kernel.org within the next little while.

https://lore.kernel.org/workflows/20201201184814.GA32272@dcvr/

-K
