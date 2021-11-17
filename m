Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A2C454952
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhKQO5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhKQO5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 09:57:20 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D56C061570;
        Wed, 17 Nov 2021 06:54:22 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso5154630ots.6;
        Wed, 17 Nov 2021 06:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mRIERqiL2aQ0BoDY3j7j+k2cL8eLVgdknTW4xHUEnr0=;
        b=Rl9BjezFX12nDSvg2bkfLnCeXHPBEAPUn9WxUHFo0nRh6SGni1K5qiyr99QIrs1bpe
         62aTpfICjg8Zsy5H5suUAXLWE75zJuO9A0wdIJcQTIKS1mLrv1V8Lb5Pvph4lukM2tuW
         stIGposKu27fTj7KF1LFqc9fl8AUKDczr3lnJiylKhWI4eu6ITs0ZHTWrojVBZzZ703A
         fyYqv7QqQ7IXATM2gD0EYM5CewndvPZk4pgjWwRwm40Zgx6uMBJBKHx5iDW1EK1dmEsk
         4OGN6tOoGul+wS6IaV9nFOaxpOFO0kvMm7cPa5sjtmCyhIs3bkmks+iH79SSiphuU+NI
         Aciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=mRIERqiL2aQ0BoDY3j7j+k2cL8eLVgdknTW4xHUEnr0=;
        b=lcXggMXd1o7uFHWKhw7er0qsieyedmvVXznqbzMOwrnadvyNfaMozY4eAOCgqxwv7v
         kypPGs9Fxg6kG1N/vdNBvFzDP8Ny3lfibzpN92rGju+nWuluiqT/pJiS/oILsXy9BIra
         GtCn2QQyohDHAcYXr8FzsULAmLGsuskoxtPJdc+T93ybOMADEnAC5188a9DiSwjtBVUp
         YITg2X61rFaqnTtkRW5rWTGjNYNx+LnEqdA4D2iHTtHztLRHZpHEhnAP2j+YLYvwEG3w
         5MFY/UugdYhMcSsyxYQJoWaUaJ60QFS7DXyltETXptmC5ubnSmwFegxOym5Gh8c8qAKU
         8E/Q==
X-Gm-Message-State: AOAM532mRfGscpIBNbE4Li4b4LJH0GRdmmU8XtH1xGFNYdt1l9telrBG
        5RwIOeZQgP9FGG10A8MkWMlpTlbScaE=
X-Google-Smtp-Source: ABdhPJxos1r2c7kQ8c2sS0mxFVpaldjdGE5gduJRoQP8vchF15SfaN3/MRPiPT+pg75C1rJWMycU8g==
X-Received: by 2002:a9d:7a8c:: with SMTP id l12mr13790271otn.84.1637160861487;
        Wed, 17 Nov 2021 06:54:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bl33sm1889210oib.47.2021.11.17.06.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 06:54:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 17 Nov 2021 06:54:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <20211117145419.GA189081@roeck-us.net>
References: <20211117101657.463560063@linuxfoundation.org>
 <81192f2a-afe7-1eee-847a-f8103a6d7cd1@roeck-us.net>
 <YZUVKX0KraPWiXx1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZUVKX0KraPWiXx1@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 03:43:53PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 17, 2021 at 06:13:47AM -0800, Guenter Roeck wrote:
> > On 11/17/21 2:19 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.3 release.
> > > There are 923 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build is still broken for m68k.
> > 
> > drivers/block/ataflop.c: In function 'atari_cleanup_floppy_disk':
> > drivers/block/ataflop.c:2050:17: error: implicit declaration of function 'blk_cleanup_disk'
> > drivers/block/ataflop.c: In function 'atari_floppy_init':
> > drivers/block/ataflop.c:2065:15: error: implicit declaration of function '__register_blkdev'
> > 
> > Are you sure you want to carry that patch series into v5.10.y ? I had to revert
> > pretty much everything to get it to compile. It seems to me that someone should
> > provide a working backport if the series is needed/wanted in v5.10.y.
> 
> Wow, I dropped the wrong patch :(
> 
... and I replied to the wrong announcement. Yes, this was for 5.10.y.
Sorry, and thanks for catching.

Guenter

> No, I don't want to carry that series, let me go rip out everything for
> ataflop.c now.  If someone cares about this for 5.10.y, I'll take a
> backport series, but really, they should just go use 5.15.y instead.
> 
> I'll push out a -rc4 now.
> 
> thanks,
> 
> greg k-h
