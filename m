Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5158B12D317
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 19:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfL3SIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 13:08:52 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:33371 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfL3SIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 13:08:52 -0500
Received: by mail-yb1-f194.google.com with SMTP id n66so14407387ybg.0
        for <stable@vger.kernel.org>; Mon, 30 Dec 2019 10:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ygcEd+mjaSKrmBq/UwIfmJMGRSUP47afmC7rxQ+g8j4=;
        b=mjst4cLscGZODIE7UbwbgrzDoRxVSdO3I/bbcHFxXAQac+bF/lkEoQTB3tX8Oom7TA
         JvlghNn4OJZ6CS4bqaRb2yoH9ZIxNCdTPe5zlV9VaavRHmE25TZjvOKJ8zT96huqj1tV
         GP8/bMBQ2uEgIgjCdqaL7UUWo58SiYdJ8UaL+lwtTFiKXwf/aUa/uWgOUxyKQFDQIRYY
         GTPZLY9DurdLifuqeQ2rg/sD6ct7NUrKSM75KJJPaY/+m0lntc7dDtYSwt/jBs4a9Iz9
         PGRF8qucfm5hBbZ+TCHvmzu6gq0v50VonvotPCrYJCnX3qgYZYMGnB6GGGfEhOC+mmDN
         E/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=ygcEd+mjaSKrmBq/UwIfmJMGRSUP47afmC7rxQ+g8j4=;
        b=TTKgAqvOqNK82ojRyO8LC1PDcdM/wswhVEkYOd+pkwMZjo7gGlG3bTQU4CsVm4hZ9p
         WuZOKONQ6Fdk58qYAjKaqIYKtwwb3HNVTeVSlp2Nv+v9f+AYtcGmwIzzGR/MSyzFMPcJ
         OxuJqt5znqInyK/g2rCJVGhvMuTsJ+9ao4CnpT470SVb3sN6UjINkJ3cYrPgpI0SYLJ5
         lFY4RiZq3BHZKYfae9g487FVu5S3jSwILT6fnDY6ZeU3SlObP6bymaq3w94AxG1RipUh
         HoNhVS6gjsBKc4HUAaQEuWloQ8C0gabUkBAZV1Yl1cmMhrOiXCSdrYbbY7ljAAl4OHAc
         bnKA==
X-Gm-Message-State: APjAAAVHhJcRBP7cIP7umWsszDgjL0rpSDBugzFzreQnVrqzBLBg1J7b
        aHyFDlmcdEMslaa3ICLU6sZ/9vDxoQ8=
X-Google-Smtp-Source: APXvYqwxwYcMJXoYHEy/yMGknkS1/KFBVaRMibslurcfAySvGWHO2v2vgFSggO48BTEnfUYHoz3osw==
X-Received: by 2002:a25:774a:: with SMTP id s71mr32294631ybc.189.1577729331013;
        Mon, 30 Dec 2019 10:08:51 -0800 (PST)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id d143sm18132446ywb.51.2019.12.30.10.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 10:08:50 -0800 (PST)
Date:   Mon, 30 Dec 2019 12:08:49 -0600
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/434] 5.4.7-stable review
Message-ID: <20191230180849.222x3hg2tnpwz7dn@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20191229172702.393141737@linuxfoundation.org>
 <20191230163437.sz4mb5gh7ed2htfa@xps.therub.org>
 <20191230174522.GA1499079@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191230174522.GA1499079@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 06:45:22PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Dec 30, 2019 at 10:34:37AM -0600, Dan Rue wrote:
> > On Sun, Dec 29, 2019 at 06:20:53PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.7 release.
> > > There are 434 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > Results from Linaro’s test farm.
> > No regressions on arm64, arm, x86_64, and i386.
> 
> Thanks for testing all of these and letting me know.
> 
> But didn't you add perf build testing to your builds?  That should have
> broken things, so I am guessing not :(

We do build (and run) perf, and it worked for us. Which patch was the
problem? I can go look at why our config didn't hit the offending
code/build path.

Dan

-- 
Linaro LKFT
https://lkft.linaro.org
