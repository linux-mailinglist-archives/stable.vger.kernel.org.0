Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D7820A008
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 15:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405098AbgFYNeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 09:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404887AbgFYNeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 09:34:16 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CACC08C5DB
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 06:34:15 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r12so5821655wrj.13
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 06:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+en12hbajA2epjn74KKtvunas9oH7o8wq7HKdXNb8M0=;
        b=zbnXFjc/f3t0HXVoKImkdmg5QD+hfAo/wnHs68LQN6hK956Xp5jO4Zmjk8rLth24Ms
         D5WOsZFtBh/qkBtEBDygVtDg3e7B6OwSHztlJBclVtWh0qkbSEdG2IPFEEDuwMJ2V0fe
         EsqlzrSqH1vgbMFtAKRGt7csuDdXUuvPxWACVl4dyaKb2sKbSrRHvtH4IM1gXpX5DEwE
         ZixSdfhlet1m6v++dZGefh++3rR/ZPWnZspJnBoEyi+1vCo8H4YFpzreLS5YoJZ0rt7Q
         fLtLGMkIlPKFNcsId/Raezp2iTCENVvdyYaogvEYUoOQGxGVDzdJKH1hs6UdboSAgfsQ
         I+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+en12hbajA2epjn74KKtvunas9oH7o8wq7HKdXNb8M0=;
        b=mEj09D7Lzq2NZJFbJHsFbEFFMwKWn3C/D8pWvRiTZtynxye6vn+sJNOouzNzczPNHq
         k/QFbR4b7VWGnyMcZR90pj0PDb1VELaEgfp1huYzwM7ZLNdogTWEdDu3OeMl3r5xVX2Z
         CsSvFex2FbqJRPKFLYremDtU/h9u+Q+s6m6hyfiGslyLtaDsqt3DxmSCGRDsT5qfJJ2G
         ak6cA/OrqE8w85O+GX3UTXf4c3GT+6o+hQq9axDYDmwWr/+dX0oP78SltZoSPriRXtf3
         x+hU+KDXMKogo0cBHjD5g/X3LIFS72+CWzUATABEqJxxKVahqgFPe1vNfnZFQUj28lFM
         2z4A==
X-Gm-Message-State: AOAM531HH74wNwQaqE6sWvYcRRUr/rvIW75iU+RWBS+f+iuliQsFDAta
        2wsFuOVrzerZHwgGCwzOsjLLaw==
X-Google-Smtp-Source: ABdhPJyg90AdzA2eO9xnhupkOpjLo09dHDKK962lpGaGylf28QL380IteVaxf1VIra2P5HiM8rrNvw==
X-Received: by 2002:adf:f350:: with SMTP id e16mr34165014wrp.43.1593092053811;
        Thu, 25 Jun 2020 06:34:13 -0700 (PDT)
Received: from dell ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id f16sm12669678wmh.27.2020.06.25.06.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 06:34:13 -0700 (PDT)
Date:   Thu, 25 Jun 2020 14:34:11 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, patches@opensource.cirrus.com
Subject: Re: [PATCH 01/10] mfd: wm8350-core: Supply description
 wm8350_reg_{un}lock args
Message-ID: <20200625133411.GP954398@dell>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
 <20200625064619.2775707-2-lee.jones@linaro.org>
 <20200625065608.GB2789306@kroah.com>
 <20200625071313.GM954398@dell>
 <20200625094513.GC3299764@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200625094513.GC3299764@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Jun 2020, Greg KH wrote:

> On Thu, Jun 25, 2020 at 08:13:13AM +0100, Lee Jones wrote:
> > On Thu, 25 Jun 2020, Greg KH wrote:
> > 
> > > On Thu, Jun 25, 2020 at 07:46:10AM +0100, Lee Jones wrote:
> > > > Kerneldoc syntax is used, but not complete.  Descriptions required.
> > > > 
> > > > Prevents warnings like:
> > > > 
> > > >  drivers/mfd/wm8350-core.c:136: warning: Function parameter or member 'wm8350' not described in 'wm8350_reg_lock'
> > > >  drivers/mfd/wm8350-core.c:165: warning: Function parameter or member 'wm8350' not described in 'wm8350_reg_unlock'
> > > > 
> > > > Cc: <stable@vger.kernel.org>
> > > > Cc: patches@opensource.cirrus.com
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  drivers/mfd/wm8350-core.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > > > diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> > > > index 42b16503e6cd1..fbc77b218215c 100644
> > > > --- a/drivers/mfd/wm8350-core.c
> > > > +++ b/drivers/mfd/wm8350-core.c
> > > > @@ -131,6 +131,8 @@ EXPORT_SYMBOL_GPL(wm8350_block_write);
> > > >   * The WM8350 has a hardware lock which can be used to prevent writes to
> > > >   * some registers (generally those which can cause particularly serious
> > > >   * problems if misused).  This function enables that lock.
> > > > + *
> > > > + * @wm8350: pointer to local driver data structure
> > > >   */
> > > >  int wm8350_reg_lock(struct wm8350 *wm8350)
> > > >  {
> > > > @@ -160,6 +162,8 @@ EXPORT_SYMBOL_GPL(wm8350_reg_lock);
> > > >   * problems if misused).  This function disables that lock so updates
> > > >   * can be performed.  For maximum safety this should be done only when
> > > >   * required.
> > > > + *
> > > > + * @wm8350: pointer to local driver data structure
> > > >   */
> > > >  int wm8350_reg_unlock(struct wm8350 *wm8350)
> > > >  {
> > > 
> > > Why are all of these documentation fixes for stable?
> > 
> > Because they fix compiler warnings.
> 
> When you type 'make' these warnings show up?  We don't do documentation
> builds as part of a normal build...

'make W=1' yes. :)

> If for some reason we ever get rid of all of the thousands of current
> warnings, then yes, I will be glad to consider stuff like this then.

Workin' on it!

Sorry for the noise (for now).

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
