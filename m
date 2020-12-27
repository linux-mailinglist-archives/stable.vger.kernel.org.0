Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7342E3300
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 22:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgL0Veo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 16:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgL0Veo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 16:34:44 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3181C061795
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 13:34:03 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id iq13so4977146pjb.3
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 13:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=mEKYM0mGIK8OdyHyJi4o0kAhykSxqXkdO2jJZI3YmeI=;
        b=RzWTVrR1F/Uq4mnvBkkfAK/vOGw1s0RBdLddWn6ZcJoCAMl900VlKRtgX+qdoTyqFo
         FAcRyW9Qkz6KEhoPLK5ZKU2115Gbc84IZdIUm4iQBwE5jcH6E8vB/SGzgJcH5AP4/Xw0
         1HROrjZirer2x/69DGLb8++lEIsish9s9nhttFtN3Md8tE9f72S9zhqACV+uw8ycCIN2
         MVUuDOI1bu5vFcRVInZX1ZAEmiCaqfLz4oQgAAN+Ah3E8uFzi+oVJ7zmNQ69jkFnmI42
         Y8cA5CC2c3oAVwATHhyOjwE2/Y9H6j+CT9yomaunqmzOVI+aM74cmviml+1nx0FUpGcC
         gVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mEKYM0mGIK8OdyHyJi4o0kAhykSxqXkdO2jJZI3YmeI=;
        b=N2qUDULqW22l5ui6hP+EUyjDeQ5Tsx3cp6WSAD+sEJhJ4AEaNgFKdjl2PvrlhJLjz2
         N+Vw5PYS4Y2vZupbaAJUlIl+Fae8dvmpZT07TzfiTJQtiWVKSzCYl4ybYE72I2na6M6G
         E3BCk3tal3p8N5VwyPbu2WdhJRpuwpRkzL/l6YGotqB/DaZKwSf+hYHW02yWQ6zYplTs
         BmPe4a6j1PnK224+iqKrt5z1ld0zmWDQIyBC1Os9ZWDBhTNsQD5khOrPUgs5zu2hj755
         nSFWZ+U/W3wZg5GEA/TCiYlGM+sC5cmuEd+oRJX7p0BQaBzFzobPnXmavFoPWGybm6uc
         TSGA==
X-Gm-Message-State: AOAM530bur4BhYOTaApDa50dUzbyngSovRcyRllYV261EaekbT5F27zM
        iXWFmNJOLk3SOFw+Mf6JrcxBc5dpyk3O2g==
X-Google-Smtp-Source: ABdhPJwghUHfMvHVqhJ1/2qjF0aRyvwUIPnbxmITBgJotoicfYfNJRZrgi0JFx+rmKMcrJ5qdUHKHA==
X-Received: by 2002:a17:902:d916:b029:da:3e9e:cd7c with SMTP id c22-20020a170902d916b02900da3e9ecd7cmr42292473plz.27.1609104843268;
        Sun, 27 Dec 2020 13:34:03 -0800 (PST)
Received: from [192.168.0.4] ([171.49.218.48])
        by smtp.gmail.com with ESMTPSA id a18sm33925985pfg.107.2020.12.27.13.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 13:34:02 -0800 (PST)
Message-ID: <c7688d9a00a510975f115305a9e8d245a4403773.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Date:   Mon, 28 Dec 2020 03:03:58 +0530
In-Reply-To: <X+iwvG2d0QfPl+mc@kroah.com>
References: <20201223150515.553836647@linuxfoundation.org>
         <1b12b1311e5f0ff7e96d444bf258facc6b0c6ae4.camel@rajagiritech.edu.in>
         <X+dRkTq+T+A6nWPz@kroah.com>
         <58d01e9ee69b4fe51d75bcecdf12db219d261ff1.camel@rajagiritech.edu.in>
         <X+iwvG2d0QfPl+mc@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2020-12-27 at 17:05 +0100, Greg Kroah-Hartman wrote:
> On Sun, Dec 27, 2020 at 09:20:07PM +0530, Jeffrin Jose T wrote:
> > On Sat, 2020-12-26 at 16:06 +0100, Greg Kroah-Hartman wrote:
> > > On Thu, Dec 24, 2020 at 03:13:38PM +0530, Jeffrin Jose T wrote:
> > > > On Wed, 2020-12-23 at 16:33 +0100, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 5.10.3
> > > > > release.
> > > > > There are 40 patches in this series, all will be posted as a
> > > > > response
> > > > > to this one.  If anyone has any issues with these being
> > > > > applied,
> > > > > please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Fri, 25 Dec 2020 15:05:02 +0000.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > > The whole patch series can be found in one patch at:
> > > > >         
> > > > > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.3-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/
> > > > > linu
> > > > > x-
> > > > > stable-rc.git linux-5.10.y
> > > > > and the diffstat can be found below.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > 
> > > > hello ,
> > > > Compiled and booted 5.10.3-rc1+.
> > > > 
> > > > dmesg -l err gives...
> > > > --------------x-------------x------------------->
> > > >    43.190922] Bluetooth: hci0: don't support firmware rome
> > > > 0x31010100
> > > > --------------x---------------x----------------->
> > > > 
> > > > My Bluetooth is Off.
> > > 
> > > Is this a new warning?  Does it show up on 5.10.2?
> > > 
> > > > Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> > > 
> > > thanks for testing?
> > > 
> > > greg k-h
> > 
> > this does not show up in 5.10.2-rc1+
> 
> Odd.  Can you run 'git bisect' to find the offending commit?
> 
> Does this same error message show up in Linus's git tree?
> 
> thanks,
> 
> greg k-h

i will try to do "git bisect" .  i saw this error in linus's  tree.

-- 
software engineer
rajagiri school of engineering and technology - autonomous

