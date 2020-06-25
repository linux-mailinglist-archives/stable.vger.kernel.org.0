Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282CF20A01E
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 15:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405012AbgFYNiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 09:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404996AbgFYNit (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 09:38:49 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37D3C08C5DB
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 06:38:48 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l17so5615393wmj.0
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 06:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=sChA7GHV4hlkfpK+ozmJjB10++7TNo/bmR1QteXGK7Y=;
        b=VE1H4cUGZxywExFFi62qrPnBOZqKjdb+jDa5svgWaNo5vczGVwC+hGVzms75r9EN99
         ynBiDKp6F3K2woAR15eWxxr15ZF4xdwwEPfWFym2I9DYpqJMSRDdlJrwQBX40V5l9/sL
         flAa+jjvwqAVo6XI0piFN35fypGzChA1muKJAe6FPRiDXu887m2RCtrqeBr9WHsHd1Cy
         FiJ+TqRXn27CTzQ/X796jPWTUk6NHVjBNuNspEzZBLz2qc9hKqj+5K7v2L5/B/4s5kzp
         /YMUVNCytsS49H1vFyOy4yXT5ogSKEjAbGv8glKbUpAh6IE8YIbm5n6O8qdk+p2zxJlM
         fRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sChA7GHV4hlkfpK+ozmJjB10++7TNo/bmR1QteXGK7Y=;
        b=q7pwVITp1hVGTf+mtQWpYkZFf2ILq5L6pzw5iAbK+p5JABFcCd2au4wM+k8OFw0XNM
         t9UF7sPGldUhNdY0OBlMkOY0JwqGC83J0r92MHwm8jYxXU7Ugn949Ph2w5CkjQ+YI31L
         8Xw+iWdJ8WE1dZzOOwAsY2NKfjLYlIl+j4XaK7aY8LzV09Ftai5+oCsXMx07NSFn9e8M
         LQcD2cze86B08ZwdjDZdn5Bonho1m97cyaNfzE+SDQgGb0MwyEgu6DXA+A2n8ZrFpDHz
         hT6xDHkTQS0qZ67hPsfl3IpZbeXSwC4O1C99HVPA9/doyNscIEEwrGLrWl0m42WUWrQt
         NA+w==
X-Gm-Message-State: AOAM530TIt8mbFf/+3rHpJ11JUYS94hpI8gg21YWR+REqOG9Pe5caSvH
        DBl5RI8y9gQp1EOf2zZTERMr0w==
X-Google-Smtp-Source: ABdhPJzFZQWGTBTBa4T/1hxiqe1NJvboVg4FHe1xLQbOxZguhizJ0+w360c0uCvspO0ywn5TRE8fXw==
X-Received: by 2002:a1c:3dc3:: with SMTP id k186mr3610133wma.66.1593092327610;
        Thu, 25 Jun 2020 06:38:47 -0700 (PDT)
Received: from dell ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id l14sm15255159wrn.18.2020.06.25.06.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 06:38:46 -0700 (PDT)
Date:   Thu, 25 Jun 2020 14:38:45 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, patches@opensource.cirrus.com
Subject: Re: [PATCH 01/10] mfd: wm8350-core: Supply description
 wm8350_reg_{un}lock args
Message-ID: <20200625133845.GQ954398@dell>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
 <20200625064619.2775707-2-lee.jones@linaro.org>
 <20200625065608.GB2789306@kroah.com>
 <20200625071313.GM954398@dell>
 <20200625072449.4d3e3fca@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200625072449.4d3e3fca@lwn.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Jun 2020, Jonathan Corbet wrote:
> On Thu, 25 Jun 2020 08:13:13 +0100
> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > > Why are all of these documentation fixes for stable?  
> > 
> > Because they fix compiler warnings.
> > 
> > Not correct?
> 
> I am overjoyed to see people fixing docs build warnings, it is work that
> is desperately needed.

I'll do what I can with the time that I have.

The plan is to keep plodding on and seeing how far I can take it.  A
clean W=1 build sounds like rainbows and unicorns presently, but Rome
wasn't built in a day.

Tell you the truth, drafting patches (again, after a break) is a
welcome change/release from digging around and reviewing Android
Stable patches.  It's the only thing keeping me sane. :)

> That said, these warning fixes are probably not
> stable material; the problem is bigger and longer-term than that.

Fair enough.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
