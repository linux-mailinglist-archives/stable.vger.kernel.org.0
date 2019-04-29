Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF12DFE1
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 11:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfD2JxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 05:53:25 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34849 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfD2JxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 05:53:25 -0400
Received: by mail-pg1-f194.google.com with SMTP id h1so4914924pgs.2
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 02:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c+0MXpZEek4P+VCfEH1xx9Ru4uabXwTDh/y+GUG7DhQ=;
        b=jtSNtzktrkH7xfB30YOoP4C+YhI+nR0BqlrWf1DAPXsYgcDHgsyx1CBmT5s2AaiyIc
         yCATqRCaak+MtuRfbNxbXiip4l/aHxh69nizYBndpaW4ggbIA46mGFkhJ83bfa9p2w0I
         JwQwHr7+RzbVg7ZLAKJ70bfAvNXcyKZYjHqbEw5kmP/anEDdl2X4w57N9o+SfQ7eIQAz
         xrJkUJH12bI7y+SelMwJ37P4qaTDbA+YZ0X2KX/NwKUtapF+TIWr+VpcZd7gtxrg2HS2
         x5Bdw76XQrR/5RnQau1jD3YvMCGBYe41L5A+08fur9LN/TQvt4xHCejoOu+98RUVe1/j
         eyQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c+0MXpZEek4P+VCfEH1xx9Ru4uabXwTDh/y+GUG7DhQ=;
        b=e18PDwJkcKpp/7f+bvE4+bTkjB+wT1yyb/XE+yspbowFe0dYwJCjtJ2uRFocpgaHSh
         cgvN6pmM0dXo2Um8UeizW2srwBJM1ZHeOFBg5b4b54BnImjEidA6Jy0uLhVu1coM5A5H
         B60PQ0cD3II55rUFNTBx8XSTTubV/J+ldHq1L4q//JDahmXeYzBw1JX+grtyCt3b5bFw
         cJe+AHlWUR0rTzFCYJ93n8G6avkgFI1jTJG9W9Ylvt/GZkKW3FVQuRJ3Gx6k4iSk5Ptk
         FPuQy76rv7VkEurnBVi5lQKt0DBRFJ/7nylNOjxezrkgryq7KOlLcFLYNiy+u9WNeqE/
         J2VQ==
X-Gm-Message-State: APjAAAURGvD1km/UfYVBszw0mpxN8XWaVv/3jJ3cvq+36Ett31LWqeyu
        xrsRrn9+IQ6xn0Ww8g9jTYYkFQ==
X-Google-Smtp-Source: APXvYqxDqNTUAsQbPtgk+kVimoeL8h4ytSY5Oyrs0qJiWDcUQKBAF1tB6BP0WKarza1ht/h+HbJHlA==
X-Received: by 2002:a63:da51:: with SMTP id l17mr16291377pgj.115.1556531604046;
        Mon, 29 Apr 2019 02:53:24 -0700 (PDT)
Received: from localhost ([122.166.139.136])
        by smtp.gmail.com with ESMTPSA id z127sm8195540pfb.53.2019.04.29.02.53.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 02:53:22 -0700 (PDT)
Date:   Mon, 29 Apr 2019 15:23:21 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Gregory CLEMENT <gregory.clement@bootlin.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Christian Neubert <christian.neubert.86@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: armada-37xx: fix frequency calculation for
 opp
Message-ID: <20190429095321.ah5taomlznghsxu5@vireshk-i7>
References: <20190308164710.10597-1-gregory.clement@bootlin.com>
 <20190308164710.10597-3-gregory.clement@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190308164710.10597-3-gregory.clement@bootlin.com>
User-Agent: NeoMutt/20180323-120-3dd1ac
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08-03-19, 17:47, Gregory CLEMENT wrote:
> The frequency calculation was based on the current(max) frequency of the
> CPU. However for low frequency, the value used was already the parent
> frequency divided by a factor of 2.
> 
> Instead of using this frequency, this fix directly get the frequency from
> the parent clock.
> 
> Fixes: 92ce45fb875d ("cpufreq: Add DVFS support for Armada 37xx")
> Cc: <stable@vger.kernel.org>
> Reported-by: Christian Neubert <christian.neubert.86@gmail.com>
> Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
> ---
>  drivers/cpufreq/armada-37xx-cpufreq.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)

Applied this one.

-- 
viresh
