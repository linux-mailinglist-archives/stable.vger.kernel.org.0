Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F9730FFD
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 16:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfEaOS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 10:18:27 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:36353 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfEaOS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 10:18:27 -0400
Received: by mail-it1-f193.google.com with SMTP id e184so15498735ite.1
        for <stable@vger.kernel.org>; Fri, 31 May 2019 07:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=MqKLt/WpCLzDnR6KC2LbU71uyrGieaHBnTcbdQaj2rs=;
        b=JBsBQDHM/x967z4xbhmkenpWqpse6l3Q82blssloI9kSJK9dVwLAqu7PPCul+RhDyD
         XCkwXdEkas3GwDPLsyKEE4dHF/keiU6eTfjONXxlrD179eh6yFmVt8bXqZQAENkBnZdp
         BNSSd5YtOLA9E9A3mpDcECYFCyBuW8AyJKaA9xFyTXykloNvfzpi3CVFaKTzm59dVVpr
         Oe6J4W0opsoup05QbikGRDhvr61zpO9qlg2OLoFtAbPh4FFQvjWgD9RBeQ5gmYDZx8SX
         zT+kdy/omDe1r6fB7EaVpeDiXJLd1ZfZeTcNH/CxLnnPJed/cgYSsPwEh+WIUNIXfOqh
         rW8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=MqKLt/WpCLzDnR6KC2LbU71uyrGieaHBnTcbdQaj2rs=;
        b=FQs44YqZygWBwtsPFpHb+krOC66fKqV0tEgl/qdhGYRPUMJREJlr83SLOrglN2irnN
         MnjlWOpqZf6b3SRUz17NGuzodHGl8xWCChz1PbeXb8vfu20o2IbG5+3iwViR6fFdwpBr
         hhXj5Pu4fIFCc/m8JnxRL25UFMsyw0NORNs91jgyr9UprDiUnzoEY/zVRDse6urtbHBq
         L7NB4/OwiyS3cspPfQOCdzL0EbGGwerbRPtbZncy5eBCu/ufUkeumrJDzxxrCbn73LgO
         ExB34jNUS0R32nrrsK+2nDzNd47pL3zYd+oRM83fkOLTZhZcepj3Xrhl9dEFIJ2H1Ng6
         yM1Q==
X-Gm-Message-State: APjAAAVAqGSrHKI7n5Tk7JIXKn1VVx++HfANjNT5ebQhCYasOZ6CYRiw
        74Lme0rS/+oqRvtrMF5gWXQzMw==
X-Google-Smtp-Source: APXvYqzEQm57Jjt+GxYIloa90ycsvWyHobiGaLJGaDMP/qZ0HuWYZoFbPIjUNoe1PwRHtYrgxpB3aA==
X-Received: by 2002:a05:660c:191:: with SMTP id v17mr7282964itj.6.1559312306623;
        Fri, 31 May 2019 07:18:26 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id r6sm1892523iog.38.2019.05.31.07.18.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 07:18:25 -0700 (PDT)
Date:   Fri, 31 May 2019 09:18:25 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.0 000/346] 5.0.20-stable review
Message-ID: <20190531141825.vv4ii22am7i2p5pg@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
References: <20190530030540.363386121@linuxfoundation.org>
 <CA+G9fYtW1E+jOKaU3qnhdwa63r1t7i04uMAcigWAUjVmDss6Pg@mail.gmail.com>
 <20190531132043.GA5211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190531132043.GA5211@kroah.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 31, 2019 at 06:20:43AM -0700, Greg Kroah-Hartman wrote:
> On Thu, May 30, 2019 at 09:53:33PM +0530, Naresh Kamboju wrote:
> > On Thu, 30 May 2019 at 08:48, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.0.20 release.
> > > There are 346 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat 01 Jun 2019 03:02:10 AM UTC.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.20-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Results from Linaro’s test farm.
> > No regressions on arm64, arm, x86_64, and i386.
> 
> Thanks for testing 4 of these and letting me know.

5.1 sent out now. We were just waiting for the remaining test jobs to
finish before sending it.

Dan

> 
> greg k-h

-- 
Linaro - Kernel Validation
