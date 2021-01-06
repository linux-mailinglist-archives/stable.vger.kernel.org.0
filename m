Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55AE2EC359
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 19:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbhAFSop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 13:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbhAFSop (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 13:44:45 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB9EC061359
        for <stable@vger.kernel.org>; Wed,  6 Jan 2021 10:43:51 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x126so2214002pfc.7
        for <stable@vger.kernel.org>; Wed, 06 Jan 2021 10:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=1zJ5y/Lxq0EVpDOsMrpM69cZtaU8T1CSRudliHWz1KE=;
        b=VAalUHb3pkTIPHF1uzh+SlhmvnarPXfgccSraBg1HQPIpWfFOKpVtdiAb2XSKpyw6l
         jreUBuST3vJGPQVXYj/fgwt5bf8x/9DMUP/vHx4apryB8ow2C4FRciLl9evG4iM5DCNu
         9jM4ootOqDeCDZeyrcjupo7Pl24wi0B8aNplMSwR0Ef/12zGRxp6H20rsqTOMoavx9ve
         dkxtj3rPlG4wwWHjjEy9HOP07x7mV11bz5gAMrlDTfRacxIu+p2hznLcma01LlOPkhoT
         eQNHizaB/nf7YTWHfAEQ8bnUeQX7odOr5MqBLw34m/rOXyBgNCIpLbw5SUxhqetFPIbE
         Q1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1zJ5y/Lxq0EVpDOsMrpM69cZtaU8T1CSRudliHWz1KE=;
        b=Fx2VFMtXaa3dk+BHNLx4Wi86nJwO0TNSWCmXFukvNrhdCvlTMaIdAHNHfvnRc2DJRc
         ZIwTM5cLfQxNMUf2zSy93oy+f7iDcJd/7wyECTjubTfDiMGi5gbgHoAN+0U/MykMYUWT
         zaRvnfAPTR8FsyMOyzKpD6uJMY6JE4mjfmWhIX8kclBeKMrFb/3uJG27F5AEyvJXMPd2
         YZtF+OgLeSXBvfNXDZrfAGYkOPoq+OXgYTdh/7nmXBPHgeFiymIZ2TsuRVRzpxJ5viKU
         5+Kt/l1SGbPus0FDumAg7xiDpWhCJiJ2Q9Gh1ScGITKhe2ha5VNR406ZUty7dtHUHWa6
         fA+w==
X-Gm-Message-State: AOAM533rowJSoGAQRg7aKhxnxtHmNggWQgT/KF5XQf9U/fUxXvVnt1bo
        PQOhGyaXfLdBV2djYoujODtRTg==
X-Google-Smtp-Source: ABdhPJyPDmOl+9xnz2BF1T0VppdWfDpvv0Cq/roFnYj//nagM8Tm8p+JnL5n9QpTidjXCOpZr2vfxA==
X-Received: by 2002:a63:da4f:: with SMTP id l15mr5843836pgj.22.1609958631280;
        Wed, 06 Jan 2021 10:43:51 -0800 (PST)
Received: from [192.168.0.4] ([122.164.82.190])
        by smtp.gmail.com with ESMTPSA id gb9sm2837560pjb.40.2021.01.06.10.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 10:43:50 -0800 (PST)
Message-ID: <f9d1bd04239bc86d00e1874ed91a89e0524a0ba2.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.10 00/63] 5.10.5-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Date:   Thu, 07 Jan 2021 00:13:46 +0530
In-Reply-To: <X/RkN6xJGasmekr4@kroah.com>
References: <20210104155708.800470590@linuxfoundation.org>
         <69f585d13328c51811441c967243f4918f6a3c84.camel@rajagiritech.edu.in>
         <X/RkN6xJGasmekr4@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-01-05 at 14:05 +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 05, 2021 at 06:25:14PM +0530, Jeffrin Jose T wrote:
> > On Mon, 2021-01-04 at 16:56 +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.5
> > > release.
> > > There are 63 patches in this series, all will be posted as a
> > > response
> > > to this one.  If anyone has any issues with these being applied,
> > > please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.5-rc1.gz
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
> > hello,
> > 
> > Compiled  and  booted  5.10.5-rc1+ . dmesg  related shows 
> > no new errors  and  may be no major warning. 
> > 
> > Having said that, "dmesg -l warn"  show  a BUG related stuff.
> > 
> > warning-5.10.5-rc1+.txt file is attached.
> 
> Is this new?  If so, can you bisect it?
> 
> thanks,
> 
> greg k-h

hello,
it seems to be new and i will  try to bisect it.

-- 
software engineer
rajagiri school of engineering and technology - autonomous

