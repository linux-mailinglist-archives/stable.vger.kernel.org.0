Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA882EEB5B
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 03:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbhAHChg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 21:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbhAHChg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 21:37:36 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF69FC0612F4;
        Thu,  7 Jan 2021 18:36:55 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id t6so4918388plq.1;
        Thu, 07 Jan 2021 18:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2jWvMs7HNFgAsWyHmNDqd2Gz0J6BFz9KPE4hHrpib2U=;
        b=UvsSw171IQmkCp1jhJHvxmO2GnDN9+ENmEaO8y573NyUys3ADL7jqivOmQU6eOnhWN
         km3S545XcU8QPsS/BuW3Lcww6FEaJubaPHvIUzba0wn7RWNJspVTQbz9RUk5GXcjkbxa
         nebAEpRYy4YmmEf5mD4MxPBo6PrLdlgCpmK6quTIhETWIOQM6qtG8zTTvNd7UYG3fDC2
         vlhDqKgrZbn/eL5V1JXzMbmp7mXTqZyPOFrZyI0LMli26UCEp8sN5pgmMCnhTcCh4VBU
         X3QqqupsImNACUISrlPF7r8MiHiGvo38FR+YYWj4w8beCkGauoxpRozlYgsrp0vGnGSk
         KAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2jWvMs7HNFgAsWyHmNDqd2Gz0J6BFz9KPE4hHrpib2U=;
        b=gMuOQCBpRMTeqlU2M41q8UI2UXJgQ2jLX9YrfsAJgPlJB+3H6tY4Z/CWoBqKp/z/Fe
         3qGbrSxhhdPrEQhhv69l+ku8tEvgziyPA4muUY7n37ulHD7p1q0WOCa3wx+/rX/AH7/b
         jtf8MRPmDHO1yursuPlKaQ2akXSudVXLbeeuuXif+/0K3nZJbXDdIKGl5a6N7KGDFS7w
         VA3wDJ584/tovUhWFDJqhBd2G8wVwhkMbpeICxSIZ8IRm9aS3KviolaU+ZSXaLpKDu7i
         nxL3/uIdMYZYIGwc9+D7W6uGtvrb/aILfq8cUomoGGc7d+C/OMtmFe5M3/G2s5WuzKbM
         1v2w==
X-Gm-Message-State: AOAM530tg7WM+WIdp6rYF/T6suLkYtY3obFHa4AR0W/Z0Z0Ft0XNp3lI
        ox+mEq+wkopU8NUNxVsNPNI=
X-Google-Smtp-Source: ABdhPJyasOdYyIDErWAaInoO7fb2yolBJ7yy5zBrZaTUN9wI+W2cGLqEXFQBTJc4Uz70Pre+VY3tXw==
X-Received: by 2002:a17:90b:1a86:: with SMTP id ng6mr1481468pjb.12.1610073415325;
        Thu, 07 Jan 2021 18:36:55 -0800 (PST)
Received: from b29397-desktop ([194.5.48.251])
        by smtp.gmail.com with ESMTPSA id r20sm8070301pgb.3.2021.01.07.18.36.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Jan 2021 18:36:54 -0800 (PST)
Date:   Fri, 8 Jan 2021 10:36:46 +0800
From:   Peter Chen <hzpeterchen@gmail.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, John Youn <John.Youn@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/2] usb: dwc3: gadget: Check for multiple start/stop
Message-ID: <20210108023646.GB4672@b29397-desktop>
References: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-01-05 08:56:28, Thinh Nguyen wrote:
> Add some checks to avoid going through the start/stop sequence if the gadget
> had already started/stopped. This series base-commit is Greg's usb-linus
> branch.
> 

Hi Thinh,

What's the sequence your could reproduce it?

Peter
> 
> 
> Thinh Nguyen (2):
>   usb: dwc3: gadget: Check if the gadget had started
>   usb: dwc3: gadget: Check if the gadget had stopped
> 
>  drivers/usb/dwc3/gadget.c | 28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
> 
> 
> base-commit: 96ebc9c871d8a28fb22aa758dd9188a4732df482
> -- 
> 2.28.0
> 

-- 

Thanks,
Peter Chen

