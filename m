Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7581010A216
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 17:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfKZQ25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 11:28:57 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52909 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfKZQ25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 11:28:57 -0500
Received: by mail-wm1-f66.google.com with SMTP id l1so3893970wme.2
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 08:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=68KQCaosWeDo+hQhdYuCzvCTI2yuojVXzy5tuG8R55o=;
        b=ygVjXhQ/4XFONa8lQ8DB5rL+SmDIjgsb/NWD9Pg2aL1rmGTWBH5BuLHb1DRmAr8M0C
         vbshC3jXyDu5QbQxYClLsrvMK1tYyViVG5DW0VDCEiw9Gm0LQ8wRjGs9sKRlCBcoj8ah
         XCMl0SW+Ji17oLlMlfsjrcG9VqTeaCMZUH3t61/p7vH/RTK+SPT3dKO4yI80yMopzuQd
         bkNBniGa75YxLvqXThj5Q6icTVvk2+USH8z9GJ2TXOEfhmTR8uw9JLVEI3nXHi79Y3k7
         DJDdSaW1K7u/tDpacEpNTSba+Gn6F3slWnj2Ko69wne+2sGSCunfJCz0P0WyCxWi+05q
         bi5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=68KQCaosWeDo+hQhdYuCzvCTI2yuojVXzy5tuG8R55o=;
        b=DUOhkblDsZUvZQn2GGE4XnKSvwDGcvjCGrPh5Q1Q/oCRRf7RCO0b+yUFk9dSkykrdu
         /sUEYMHDUfNAM4QKJBJITGly9196rK989EOwfG2T+5iaGGQ+gKAii+23eY1+RTyzd6OW
         iJ99IKlVfOAJjGOj2dpX0GGoy1hUt99XVcIpskxsurF78aBZF0mhnM8oONkSPW68/UZR
         qw4XThHCupUQvCfsGmP7PI5wDR54/I4puZ7Ye0j444tQ5d+kNjvlQJT9S0u58TVYbAb9
         VJQt2fGnoOZ2OBKOyyf4tFssvDBbP+wbaZAAhNyzAn0vzQr1thlnrRb0oGmx8Qlm8nbK
         8nAg==
X-Gm-Message-State: APjAAAX4+t5B43dx3GrJwBffUgaCMtR0ihh4uRjbhI0VAUbM+G9/9QXc
        pOZVjFiRaS6mmhF1iFMaoHOh6oa3BrE=
X-Google-Smtp-Source: APXvYqzBx6K4EetpeCR4ass7xQUmXNEL+s+vxvMP9KaKGikgL95AvG8SLif0FmIGalxelEisXRmiHQ==
X-Received: by 2002:a1c:9c54:: with SMTP id f81mr5190647wme.89.1574785733947;
        Tue, 26 Nov 2019 08:28:53 -0800 (PST)
Received: from dell ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id r15sm16077075wrc.5.2019.11.26.08.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 08:28:53 -0800 (PST)
Date:   Tue, 26 Nov 2019 16:28:40 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 3/3] ocfs2: remove ocfs2_is_o2cb_active()
Message-ID: <20191126162840.GK3296@dell>
References: <20191126134741.12629-1-lee.jones@linaro.org>
 <20191126134741.12629-3-lee.jones@linaro.org>
 <20191126162416.GA1657337@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191126162416.GA1657337@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Nov 2019, Greg KH wrote:

> On Tue, Nov 26, 2019 at 01:47:41PM +0000, Lee Jones wrote:
> > From: Gang He <ghe@suse.com>
> > 
> > [ Upstream commit 9d452c602f0558ec3b0aeab1040bdf4dfbc590eb ]
> 
> That's not a valid git commit id in Linus's tree :(

That's odd. I'll check my scripts.

They are new and you are the victim of the first run!

> These series are a mess.  Can you redo them all and resend them so that
> I can apply them, and so I know what branch to apply them to?  :)

I can do that.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
