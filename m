Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A258E26B990
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 03:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgIPB67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 21:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgIPB64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 21:58:56 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B88C06174A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 18:58:56 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id x2so4999452ilm.0
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 18:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qhdr1lckxDn533Nbvbzkw4XrGXZUxIw8LF6F0EY8tyY=;
        b=YkmC6QVRo0nPdJH1AaYOoPFWydvpTMEdvLf+q8jsmW9nsVpGx1aFWSIlrf2pD5MVcN
         aWo4Jth5trT7krddc9ugKcfZmFGVQWY2kziRRE/bNKHM1gIvn9jPLbc8UUbyko9MaSWc
         LQrUM7oDpuihtJ3P9kaq/EpsZNlHlrimSjIEDkg/R2uH/kaJIZV+OGv/WJp++r1euavo
         CqBf47GEoHxI0jkt1pxUZvFhnZEMEgtGIm+qiR/zPiIzn1MnlG+WvKYOaRks6nurrfW/
         uPBlfMwtP4SjtJf62Wen9QANNVns5u4ukbbGvg78IM+h4SVzEpyMCS75Tupsf4TW4tnU
         OXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=qhdr1lckxDn533Nbvbzkw4XrGXZUxIw8LF6F0EY8tyY=;
        b=BbwhhtDYpTO+WLTUjlQnE+85pgOgr155wtSKcPZrpVeeL3ED5+6S5Njs4GVFB493zQ
         P8juKoKhQKA4e/J7LfYn2YotDUsVTwMaxNbnCNIJw5S9DiaBv1eSK5L4n4eNhAGKHArA
         j19B4TaWlUXY0Eg6/9lYgjgcbAwhP0AHYh5qRtZ/ar14UlYFACZB/MUSz4xqzj/bdZhW
         Zn5gn79TB5pd+/V7k9X2exFklw4N4lqR6qlFs5QoiQyoIlp4qeWm+nXIalWqxZtexmRz
         CsAWe44tYBdcOyGTWPhlFmgCBXULKCx+Mof8KEoANQfUF6Epa+gkvR9Eeati6rw/D+Qc
         Qz+Q==
X-Gm-Message-State: AOAM530uPcKmKFh/uPsRbZlC3JrtpYH1826DLpzi1qsDHd0uvCCAtyc0
        Xmm5jcIRnZJWB3hCJchbUZ/qKQ==
X-Google-Smtp-Source: ABdhPJxzHqGBDxam6nZhvVqazBmMirWqIwU79yfutltOAIF+rsmEcRZminlYdPfiT2my5YTCf//7/Q==
X-Received: by 2002:a92:58cf:: with SMTP id z76mr4368857ilf.87.1600221535254;
        Tue, 15 Sep 2020 18:58:55 -0700 (PDT)
Received: from localhost ([2601:441:27f:8f73:89be:770e:7358:ee10])
        by smtp.gmail.com with ESMTPSA id s6sm9503249ilp.4.2020.09.15.18.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 18:58:54 -0700 (PDT)
Date:   Tue, 15 Sep 2020 20:58:54 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        ben.hutchings@codethink.co.uk, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Jonathan Marek <jonathan@marek.ca>
Subject: Re: [PATCH 5.4 000/130] 5.4.66-rc2 review
Message-ID: <20200916015854.inqx3u2ovzhq45ou@nuc.therub.org>
Mail-Followup-To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        ben.hutchings@codethink.co.uk, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Jonathan Marek <jonathan@marek.ca>
References: <20200915164455.372746145@linuxfoundation.org>
 <20200915201732.4474qpgnxwshanpw@nuc.therub.org>
 <20200916003117.GF2431@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200916003117.GF2431@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 08:31:17PM -0400, Sasha Levin wrote:
> On Tue, Sep 15, 2020 at 03:17:32PM -0500, Dan Rue wrote:
> > On Tue, Sep 15, 2020 at 06:45:55PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.66 release.
> > > There are 130 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 17 Sep 2020 16:44:19 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.66-rc2.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > -------------
> > > Pseudo-Shortlog of commits:
> > > 
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >     Linux 5.4.66-rc2
> > > 
> > > Jordan Crouse <jcrouse@codeaurora.org>
> > >     drm/msm: Disable the RPTR shadow
> > > 
> > > Jonathan Marek <jonathan@marek.ca>
> > >     drm/msm/a6xx: update a6xx_hw_init for A640 and A650
> > 
> > This one ("drm/msm/a6xx: update a6xx_hw_init for A640 and A650") is
> > still causing builds to fail on arm and arm64.
> 
> I've dropped it, thanks!

Could you push it? 😊

Dan

-- 
Linaro LKFT
https://lkft.linaro.org
