Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B736E2E31B7
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 16:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgL0Pu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 10:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgL0Pu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 10:50:59 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21CDC061795
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 07:50:18 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id t8so5021522pfg.8
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 07:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=0mygQIb/CfIynYY3ZWV/YpnOSwPUZeOkV6VE4IaAWtw=;
        b=HIfgErhyIBsCpUiI0OAUFbKcSORFGmtaULPu6KSOXg3bG40cjKSqjnmyugKunxM8/5
         NxRgIBCi7XY3+SkDtHxYyOrOMuorgzl499B50gVXuMSETU4JPb35EohUJsvvPQCiRL/+
         /SIjMzxK4mXnf28oZX4yV1+BzoHZd6WAB7v0KPIEx94BtzDcnFqM/rBLNXy2O2+LXP+p
         pO4CQcheQTjzBtsv0Y9A9CdH8OsdnOkgVP5QtHNi9tTR0z+ugsrJBeRFzAS4MN1rdCyN
         Ei35lT5LZoRB9J/9NK3omEaI0mAKmomcl8X9VV8Cg8cOsXeIQdKt5z8jzAWmhtUQJeaR
         iGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=0mygQIb/CfIynYY3ZWV/YpnOSwPUZeOkV6VE4IaAWtw=;
        b=f9N4TsTM8kTL6KLlJ+cZbzOH9QstLl700WSBPLWD/fFF4dTdqE52sUN7EL4nxJRezt
         T8OP5zPfS5aaWMFojkX7GFWn2La+bb91l62JFLumsZr9ZkxS+MsFgUetc7jcwp/Czf/O
         dMPj4iTZv6XECBtIg2AC+/DPy2oSrsyUH7est2Shtv3SO6VeuQSlp4pHcs5uXEPoFvUH
         mcgISqfhYZnv/HCi1j1EtKdwiDa46bOoDZwC98XzdQt5zdxRpFy7RDy8vfwd1fuzOTHQ
         0QIXszIzdurk3ZB5VZWiUeznGa2Mxyp+JOI6E7rLc6dJhOb9nV5aayR6GorWdjxhHJyS
         F60A==
X-Gm-Message-State: AOAM532yCXaDNJnWJPSXYKepFBj4DcFrfZYARbyoxPYW9h/Yj7eBafm/
        scUyJSx1AQoZjvfbRSHkrhMjrg==
X-Google-Smtp-Source: ABdhPJxkorx467jL5Mh5Ag6b86dgBOuK0ZiYnCvH1nsW90ZGVF+S8l+AeKr4vNIkCFaVTNdR/V0zyw==
X-Received: by 2002:a63:574c:: with SMTP id h12mr36420214pgm.79.1609084218005;
        Sun, 27 Dec 2020 07:50:18 -0800 (PST)
Received: from [192.168.1.9] ([171.49.218.48])
        by smtp.gmail.com with ESMTPSA id b18sm34427961pfi.173.2020.12.27.07.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 07:50:17 -0800 (PST)
Message-ID: <58d01e9ee69b4fe51d75bcecdf12db219d261ff1.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Date:   Sun, 27 Dec 2020 21:20:07 +0530
In-Reply-To: <X+dRkTq+T+A6nWPz@kroah.com>
References: <20201223150515.553836647@linuxfoundation.org>
         <1b12b1311e5f0ff7e96d444bf258facc6b0c6ae4.camel@rajagiritech.edu.in>
         <X+dRkTq+T+A6nWPz@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2020-12-26 at 16:06 +0100, Greg Kroah-Hartman wrote:
> On Thu, Dec 24, 2020 at 03:13:38PM +0530, Jeffrin Jose T wrote:
> > On Wed, 2020-12-23 at 16:33 +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.3
> > > release.
> > > There are 40 patches in this series, all will be posted as a
> > > response
> > > to this one.  If anyone has any issues with these being applied,
> > > please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 25 Dec 2020 15:05:02 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >         
> > > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.3-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linu
> > > x-
> > > stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > hello ,
> > Compiled and booted 5.10.3-rc1+.
> > 
> > dmesg -l err gives...
> > --------------x-------------x------------------->
> >    43.190922] Bluetooth: hci0: don't support firmware rome
> > 0x31010100
> > --------------x---------------x----------------->
> > 
> > My Bluetooth is Off.
> 
> Is this a new warning?  Does it show up on 5.10.2?
> 
> > Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> 
> thanks for testing?
> 
> greg k-h

this does not show up in 5.10.2-rc1+

-- 
software engineer
rajagiri school of engineering and technology - autonomous

