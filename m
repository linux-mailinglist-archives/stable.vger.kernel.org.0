Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5173E1A90
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 19:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbhHERjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 13:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240362AbhHERjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 13:39:39 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7364C06179C
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 10:39:24 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 13-20020a4ae1ad0000b029024b19a4d98eso1526276ooy.5
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 10:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IqGgYBMNpNT1DdCbjXthB9OTaG+Xk6tkCmQF824Essk=;
        b=L51hoAWwUgwn2V6nX30QPrDPROKg0C0z4Kk2NRvmNRNigYs7PQo5/RbFSHiz/h/uNK
         sJ+uhsWV2LrMCZo663qNpZ0pa5TQIHuD7aIKEYM/B7it9nX1FwOOHkhg+PHQGccRSxYT
         MUmPHChcB7yuZdCQlcHTi6ZCuj+f8WVdub12ObTv3HhKEbYER6snd2ES5K7tjTwXRhsH
         HeQ3UCAEqvI/lCmooYXE/A33ZKPrEeZdp6yQdVO2/VilWGUE5v/h1Yz4lW/Ay4PDxZxA
         HhQBaFxA2LxJJ7+4I3kQTEPhSHDgNCcNRj0qwJpehP0ulNt14mSBXBRhfwQapYvsSXUC
         U1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=IqGgYBMNpNT1DdCbjXthB9OTaG+Xk6tkCmQF824Essk=;
        b=JJN/ETsIcXBR0bOAt1zzp/k1yopuTV6jONjDJVujlRLTkdGkH+tItfzyF13tHVl8SO
         gXDBT1EkrOahmDvvSW2zIEY1C5q0WyQM9369s6A6CAELqtaEX+EXYLEM0bgw27IydmEE
         mnGSWZTeyObcnd/0bYt0NL9wP+uUTbcoechp38KF0uO/Xc+CSJ5qifD2Q6tW8gsUE6jG
         WZe3gqpvN/PPQZInXp8x61xmPLquPNyO9cDFAdgY06K077KJmaQD/ZGiR4PRBRggJAs/
         W2dAJtRiUZnAEejITELWwo4rFkY2G7Ns4l/KjG+EQoN5nKvjlG3lDuSMqIE2Kr23b7Hs
         6xyA==
X-Gm-Message-State: AOAM530K1I5R6PuSiY4Q0qPgFSHLim/xLTeu1fyj9IhxGObxV2HrL2id
        vIjVSrQF2mUNQEwi7x4Qie4=
X-Google-Smtp-Source: ABdhPJxH2gBHqiUoZ+lU7XSlSsfqrO+s4EPE1uoYGLYMmbKnUqFqQTp1XYg54jWrd4aOav2UDaV/uA==
X-Received: by 2002:a4a:306:: with SMTP id 6mr4049143ooi.49.1628185163989;
        Thu, 05 Aug 2021 10:39:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o13sm1039633otl.58.2021.08.05.10.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 10:39:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 5 Aug 2021 10:39:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: Regressions in stable releases
Message-ID: <20210805173922.GB3691426@roeck-us.net>
References: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
 <YQwPg1VQZTyPSkXe@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQwPg1VQZTyPSkXe@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 05, 2021 at 06:19:15PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 05, 2021 at 09:11:02AM -0700, Guenter Roeck wrote:
> > Hi folks,
> > 
> > we have (at least) two severe regressions in stable releases right now.
> > 
> > [SHAs are from linux-5.10.y]
> > 
> > 2435dcfd16ac spi: mediatek: fix fifo rx mode
> > 	Breaks SPI access on all Mediatek devices for small transactions
> > 	(including all Mediatek based Chromebooks since they use small SPI
> > 	 transactions for EC communication)
> > 
> > 60789afc02f5 Bluetooth: Shutdown controller after workqueues are flushed or cancelled
> > 	Breaks Bluetooth on various devices (Mediatek and possibly others)
> > 	Discussion: https://lkml.org/lkml/2021/7/28/569
> 
> Are either of these being tracked on the regressions list?  I have not
> noticed them being reported there, or on the stable list :(
> 

I wasn't aware of regressions@lists.linux.dev. Clueless me. And this is the
report on the stable list, or at least that was the idea. Should I send separate
emails to regressions@ with details ?

> > Unfortunately, it appears that all our testing doesn't cover SPI and Bluetooth.
> > 
> > I understand that upstream is just as broken until fixes are applied there.
> > Still, it shows that our test coverage is far from where it needs to be,
> > and/or that we may be too aggressive with backporting patches to stable
> > releases.
> > 
> > If you have an idea how to improve the situation, please let me know.
> 
> We need to get tests running in kernelci on real hardware, that's going
> to be much more helpful here.
> 

Yes, I know. Of course it didn't help that our internal testing didn't catch
the problem until after the fact either.

Guenter
