Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A46AAC78
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 21:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732065AbfIETwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 15:52:34 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44469 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729151AbfIETwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 15:52:34 -0400
Received: by mail-io1-f66.google.com with SMTP id j4so7491068iog.11;
        Thu, 05 Sep 2019 12:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HKxHrILpeejopr4p7fNZFocU5yA8Ouwfo06xht5HsTY=;
        b=ll1Frs1KlChDcvhrebI9ruubvrouII0CNoMUPCJiw7vYs4mpSe9GMr2KU9XuiSlNr8
         kTLIqtCy3QWIYajSg0UsPL1RKez4MoN3i4Z8jR/wSjlYLZTY8lHU4UP8WVxT96rzos34
         kmf45OWhvnDRL6yeobW+czHqDI96zc2/RDGkLzg3Fkuvoww+bbkrFP79aKFluZam+5EU
         VxvitNPqykdIRGfyCo1I3xYFtBroluXO4H6X1ybJRzz9PBRgZR3tZJGR2TfrPXbvmzun
         w6Be8YICeNE3FXDHo5FNj+ngBhPVgyToRTI/2m1nwIvM2tajEi5MJ7QLmVTIBN+rN7W3
         KZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HKxHrILpeejopr4p7fNZFocU5yA8Ouwfo06xht5HsTY=;
        b=lIMqer119HCW3fVsAR+o6285fQEi5hTMzICAiYRjosXrI+6kNEGourGnnWcRw5yYAN
         VG8vgIjeahR19+Q8FDd7R4/UM2Du1N+N8jVN6VnrdXCSBlkYjTcV8dHSd6awRjgKcTfC
         U/OvOhAmx3BHsDOYYjVp8XsPSpH4WGDPWHeP4HBHfTXbovnqesVcBDfxVvMUjtrEOa5u
         42dvh2CT8PwdBbfxBk43i2q+cBSdW6oyYYeYVlou+W/FzZ4B9aBkbgqeaVoT2howNHdX
         iccfLONpmSZ2NR570Ya2aa7eA0HNLpBMngXDPDZGO3y+BGJSr+dTwAxyPAtJY3Ir69Pl
         NkZA==
X-Gm-Message-State: APjAAAUliWGpeZrR4LuPyaWZntZKmN9m8g21NSmZcOhFn1gcn6iC9gnU
        oXCJBphcnhXU8ABzFuZqufIs7TLUjUk=
X-Google-Smtp-Source: APXvYqyLgVGTcfPKXu42HXiDHbCZ4jPw+wQsvCPVuZwC+v4pPd2Y7yyynaWdUpZzjQ7kdetX1VDHKg==
X-Received: by 2002:a5d:9c4c:: with SMTP id 12mr5718879iof.5.1567713153234;
        Thu, 05 Sep 2019 12:52:33 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id q17sm2066929ioh.75.2019.09.05.12.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 12:52:32 -0700 (PDT)
Date:   Thu, 5 Sep 2019 13:52:31 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/57] 4.14.142-stable review
Message-ID: <20190905195231.GD3397@JATN>
References: <20190904175301.777414715@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:53:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.142 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.142-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled, booted, and no regressions on my system.

-Kelsey

