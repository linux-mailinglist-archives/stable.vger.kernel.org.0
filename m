Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3591104A1
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 19:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfLCS6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 13:58:24 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:45351 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLCS6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 13:58:24 -0500
Received: by mail-pj1-f67.google.com with SMTP id r11so1861894pjp.12;
        Tue, 03 Dec 2019 10:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GQRxs4m4bTH97KHxz6wNsiOvmWYoDMW0dwbQDEY7hL8=;
        b=IPzouwEZEMsUvDRaFWc3D1oq2hlkTrkSVbgOE1TsxGnVv3/Kb9hGpv92cW5LdRBjQh
         olxwy9mDIjEvKfxvHU2MRP8agXb84UFgtAUv7vmPQ3V3yhWKy+NyAVjoU/W0YrkskZtG
         6CDXhWxiIZnmNSgRdRpXG1GJiahij3nlpgQ//G4zqb8dNLic3HtiATW1Be9cUBGaosLB
         8yNyb5v3ViXOCZGWwaALPMyCOOLRm4WXaNph0SV6KhWgo0KfrYin52tes0jUEUNy0BlS
         cuzrPArcKD0isdfK/Ja9fOGcz4jCVQzc1Ga3XFCIgrmC7ooP7CHdZlNcm9Vr0I1Elh3B
         p/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=GQRxs4m4bTH97KHxz6wNsiOvmWYoDMW0dwbQDEY7hL8=;
        b=Rp4orhbSpGBGrwN+haZ9EOVTUIOg/fo5kSyNnICfB4LvZjF+YwFgGlA8NZimVD0xXV
         jUFM0Y432eAMqBxp5lOjt7vSZJutg0+UUXunSgmvqcdz8N59RYutu4a75Edp9pGAiGqK
         VlKNoW/3o7vQreY+TMsirMPSC0G85+1hw3WJ4laI3LO0xC/oOjNcJUhr0cme3T6X/q+T
         W+P2UCQfKH570RGXYXp3ScZCdFCvOm47SURsXjEIYkv9Jb4/4QaiPcuEf18Z7kKNd9qt
         +OLoFwJCkSoum/hto+vRROrDywr2+dC/AzYCmHB2t5ykudqiFobWTCbHYp/jSJI5Zx3X
         Ke9g==
X-Gm-Message-State: APjAAAUmSQwnQ3pQKIf9Wp2Cv444hcsyCO4zbaVWsCu1OJwkGoRmSG9y
        DQDp303/gBkhXMhrqrpn6VI=
X-Google-Smtp-Source: APXvYqxDgNyJPje4n7fK9cP38WqfdhkkaMMqMMLaNIqvs9l6KHP4ce7quz7ybZnZgTqaDZH3BvV1kw==
X-Received: by 2002:a17:902:4e:: with SMTP id 72mr6405913pla.270.1575399503650;
        Tue, 03 Dec 2019 10:58:23 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l22sm4039794pjc.0.2019.12.03.10.58.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Dec 2019 10:58:22 -0800 (PST)
Date:   Tue, 3 Dec 2019 10:58:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/132] 4.4.204-stable review
Message-ID: <20191203185821.GA18554@roeck-us.net>
References: <20191127202857.270233486@linuxfoundation.org>
 <CA+G9fYs-ugvOrYBZbmieSK1rQrcRh6R9cL3Vz8xK59sB3aAqyg@mail.gmail.com>
 <20191129085350.GE3584430@kroah.com>
 <4808b398-aa8f-01a9-3783-a07344944944@roeck-us.net>
 <20191203063616.GB1771875@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203063616.GB1771875@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 07:36:16AM +0100, Greg Kroah-Hartman wrote:
[ ... ]

> > > 
> > > As you all are doing run-time tests, it would be interesting to see why
> > > I saw failures in the Android networking tests with this and the 4.9
> > > queue, but they did not show up in your testing :(
> > > 
> > 
> > Did you solve this problem, or am I going to get into trouble when I merge this
> > release ?
> 
> This was resolved with the 4.4.205 and 4.9.205 releases.
> 
Thanks!

Guenter
