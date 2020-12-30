Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA492E7BD8
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 19:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgL3SLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 13:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgL3SLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 13:11:01 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB30DC061573;
        Wed, 30 Dec 2020 10:10:20 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id p22so16116553edu.11;
        Wed, 30 Dec 2020 10:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=hmmnGLgUTnb52xGTqXA8lM6ZKffdq4O8M3J3wRaF6ds=;
        b=PK+cuiW6hfKHWBpBcEwg/cr72OZkjoerweRGmdVWFZpmJ4C5cuhI/MRa2Nlnn4x/WL
         DTB92Khpc+XSSM2cd/8Rz+uOh7r+yJiIp1CaSP0LD5dFHlkL1y5aRiUQ5CSc+lPSpfbl
         7h1S5+EoiEOaHpDa2MyIG5Vk+oGnS0OIuuKqihiY2KO42wfjOgZeqy6sFQE4WNJ809dF
         ytSYykDHK3tGFbdRjw+rNBtF9uH67XPVWZjXMtu5UyqgK9UKKm7IRN/9H/db1YiRcKcY
         Ea5lPZ7vxe68KrIV1HgzdVwil3e3eDiplqOR7e0o/z89T0rsmIbot7OLRQVLYIkEpalq
         hfvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=hmmnGLgUTnb52xGTqXA8lM6ZKffdq4O8M3J3wRaF6ds=;
        b=iBvJdRfUA3JqjH3q9wEEEJxbtjPUYFXbhO05NY9rTHTs1tvjNKisc+znwps4bzfHPr
         udIdPIp+elAC8DVrHiZ7TYKMSY1yWtQHRQY8K41VnxisLPnJRk3e/cx8kGwT4eNHvcuX
         4+DHbN1BvI2ArqmuyixkkBtwyVHFA4vxN2C/6BPStbd6q4PRbWgyxrcU6FwJFcmu3xr8
         2wB92S1SIqkeax3/IfkUWoVA/xx42BI/4xVosk5hrWiWPVKvuaowLDL7TzUiVI8+gBVW
         PI5+VL1tjcJyfY12Bvx2RColsZ1hUCVteSkU2Dvk99UQADBSuDv/sn7tjG+tN3KSbs4F
         BnYA==
X-Gm-Message-State: AOAM531cjSblQc9HOjnyf8+hE2oVZKDF2IEXSwZJvaIWRweL4dzgFseN
        CAMISFLl1CuhuFBiW9V7i8VXUs7l0XdLZQ==
X-Google-Smtp-Source: ABdhPJyHQ2CbID3cO6Eoa7t9399ONKvst6/6KDmTmc/peqSSUw8tn7F9TQzRP1y9b7AQHiOsVlO/HQ==
X-Received: by 2002:aa7:da8f:: with SMTP id q15mr51290812eds.239.1609351819481;
        Wed, 30 Dec 2020 10:10:19 -0800 (PST)
Received: from cl-fw-1.fritz.box (p200300d86714d50000b12fbf0e2de53d.dip0.t-ipconnect.de. [2003:d8:6714:d500:b1:2fbf:e2d:e53d])
        by smtp.gmail.com with ESMTPSA id d14sm40800408edn.31.2020.12.30.10.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 10:10:18 -0800 (PST)
Message-ID: <efc6d5e8abc1da3cac754cb760fff08a1887013b.camel@gmail.com>
Subject: sound
From:   Christian Labisch <clnetbox@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Greg Kroah-Hartman <stable@vger.kernel.org>,
        Greg Kroah-Hartman <linux-kernel@vger.kernel.org>,
        Akemi Yagi <toracat@elrepo.org>,
        Justin Forbes <jforbes@redhat.com>
Date:   Wed, 30 Dec 2020 19:10:16 +0100
References: <2f0acfa1330ca6b40bff564fd317c8029eb23453.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Update :

I've just tested the kernel 5.10.4 from ELRepo.
Unfortunately nothing changed - still no sound.

Regards,
Christian

> Thank you Greg,
> 
> I am running Fedora 33 with kernel 5.9.16, which works correctly.
> All stable 5.10 versions up to 5.10.3 are having the sound issue.
> Once 5.10.4 will be available on koji I'm gonna test if it works.
> 
> Thanks again !
> 
> Regards,
> Christian
> 
> On Wed, 2020-12-30 at 16:36 +0100, Greg KH wrote:
> > On Wed, Dec 30, 2020 at 04:26:00PM +0100, Christian Labisch wrote:
> > > Hello !
> > > 
> > > I could need your help ... I have tested the new kernel 5.10.3 and sound doesn't work with
> > > this
> > > version.
> > > Seems the new Intel audio drivers are the main reason. What can be done ? Do you have any
> > > ideas
> > > ?
> > > 
> > > Intel Catpt driver support is new ... This deprecates the previous Haswell SoC audio driver
> > > code
> > > previously providing the audio capabilities.
> > > And I am having a Haswell CPU -> Audio device: Intel Corporation Xeon E3-1200 v3/4th Gen Core
> > > Processor HD Audio Controller (rev 06)
> > 
> > Can you try 5.10.4?  I think a fix for this is in there as was reported
> > by another user yesterday.
> > 
> > If not, can you run 'git bisect' on the kernels between the last good
> > one that worked for you, and the one that doesn't?
> > 
> > thanks,
> > 
> > greg k-h
> 

