Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66572377213
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 15:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhEHNXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 09:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhEHNXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 09:23:33 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3160BC061574;
        Sat,  8 May 2021 06:22:32 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id b25so17748506eju.5;
        Sat, 08 May 2021 06:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GewIamaMqSPnEQ94R9yqQ256UFeqBfn95eCJeSJOSTE=;
        b=SUVzhNNs8n3In0bQfCsWSLzbNX1gSZMIsNKuXYCQEed6jIgbPxzNXr2YSXwdpxMK+M
         +erYBhicRpouVyUVvokaAH6Ij7MK4QbMd/oHnX0vHKmVgtNXG2R679qKczA1JwmeNkH0
         Mu31yA5sB8HT9FojCdU47SWxZxBsg12igC0Ay2tP96POhIw8+DbIdQjH8iji/SsU1T+n
         sYx2oqKnGwgeyW2LaffefwKBvdmknF0lTJeSnY0mIgsZLStdKGyqvCJtsE4JvWZ79uiE
         qf8fDx5y4OaDcGro06kyCoUZHAZYtKELRzbUtwl+XrYB9t5ww8VZ2FPQlaCy+NoUo499
         G+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GewIamaMqSPnEQ94R9yqQ256UFeqBfn95eCJeSJOSTE=;
        b=gnKkXQhWE7DNkdifZJe3qsutL3z4VQ5FpuwJ6ymhOVtcrsQVcadx5pBw3FbYrGVndP
         zuA4n1qqoFmDA79YJNxbQhwz/8fprTRdMH4aCx67YN13gr7kUkpkIP149/Y0Gr3MbwmH
         z7hVe8BaxeAcTzwYD0tDSGMXK6MqQfiSx80lZpjaOvhlOlndVnUA83XPEVZGZR5gzzZ/
         qcAEz677iW1OJzNa/o9Z6/Rnp/Ak24ZnyZKZ+0v3WFIaEgRpeiIHL9Cq2Fh6CBpS2Ztw
         6t6ksHR25+q2V19IfJe9DM2+tvfi0EtuJuSt+znWkH58Z6EkeObTmQmiT7Q+b15wFY1M
         cHuA==
X-Gm-Message-State: AOAM530IE9xDmBX7tSZkfw1aOuf6EXPuGoE1aUahuLF1ZICXRYdz9kAk
        EvHwL5FzSB2tEnqh4c4mPNp0VGtp8b0eyY36i1U=
X-Google-Smtp-Source: ABdhPJw3zK4T0OYOhF5RkAlh7wkqxABFQkyn3pfznWO3hmZZJIR8aKRBHlBs/+KgK38d+phAeOxRXQ==
X-Received: by 2002:a17:906:2c16:: with SMTP id e22mr15483145ejh.395.1620480150957;
        Sat, 08 May 2021 06:22:30 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id e19sm6189924edv.10.2021.05.08.06.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 06:22:29 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 8 May 2021 15:22:29 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Shyam Prasad <Shyam.Prasad@microsoft.com>, pc <pc@cjr.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Message-ID: <YJaQlVyFoUHyxHM/@eldamar.lan>
References: <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan>
 <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com>
 <YHwo5prs4MbXEzER@eldamar.lan>
 <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YH25PZn5Eb3qC6JA@eldamar.lan>
 <PSAP153MB04225D77E22AFC17C4AEA52E94469@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YIJ6a77TVaZGzQIg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIJ6a77TVaZGzQIg@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Shyam, Paulo,

On Fri, Apr 23, 2021 at 09:42:35AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 22, 2021 at 03:36:07PM +0000, Shyam Prasad wrote:
> > Hi Salvatore and Santiago,
> > 
> > Thanks for testing this out.
> > 
> > @Greg Kroah-Hartman: The reverted patch used in combination with Paulo's fix seems to fix both use cases. 
> > Can we have both these taken in on stable kernels? Paulo's patch is needed only for kernels 5.10 and older.
> 
> I do not know what "both" is here at all.
> 
> Please resubmit all of the needed commits in a format that I can apply
> them in, and I will be glad to review them and queue them up.
> 
> Note, patches that are not in Linus's tree better be documented really
> really really really well for why that is not so...

Did you saw the ping from Greg? Otherwise I think the situation as it
is now for the older stable series is probably just as fine as it is
now with the repsective original commit reverted.

Regards,
Salvatore
