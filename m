Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41951FE855
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfKOW5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:57:30 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37556 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfKOW5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:57:30 -0500
Received: by mail-pf1-f193.google.com with SMTP id p24so7362912pfn.4;
        Fri, 15 Nov 2019 14:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=enZ7Qi/SyTxVExugp5p095tNoDvQ3FGNLtSzXeoV+l0=;
        b=IseQopMywi72QKbY6yp0IHyT0I+JUBoyvgl8AZTQRv4I9Rxtpv763WWjrgWrwgPYHz
         d+/mh2Y+Cnbne3wW8DLJCD0hjJuiRK2rY7Nl46yK3EAKg5F9X9qYmATNwzce/aE4fK7d
         3MH/suadReznkLWUA5Wynd09oXF/r8cOm2CwshEec65J+0YbhdL55r2R/ue/9fCF3BIb
         MZGffPQWyyL7h7zUmbeuIXA4T6K79DS39M/QhM2rFFZkI1fnlEv/zD8f1DW4vFsz0LCH
         w7XJ3vED2ay5oQAMgY2YV1vA92yfdi/RoSIHp+gwnoe5RTSivCMRHwaqOXNV4fmJ9c6c
         B7AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=enZ7Qi/SyTxVExugp5p095tNoDvQ3FGNLtSzXeoV+l0=;
        b=aj0ZfBa6xK22OJ/vi2oxPXJGNAhJj/xyPItjSsGjv8LJc7TlHoBiiwH1QVaIrJQduD
         q71eoi+F8WTKYmYvYCWszouaXw6Mg7T0rtMTbVDRHybOroyAI1VvidoRa9Ffk7JPWobc
         UilWXkAutzyT/3zULIaGf13o8HDR6uEGZMyMgHHpMha34TyJ9G7heYu2BfnKz6yi6NZw
         2tnWhC+u+pNiZkrUPIixj1mVsqGPWooSC2FfUhSv6L8r1EvUrPC1bt6wqSWOu0+JyRKo
         QVxmoITMeC40omlwRB0awUSBfGJ1qwa4kfXm5sFhF63RrKO2Sp29MlbLL91qgDuDNqb+
         ZFIw==
X-Gm-Message-State: APjAAAUlKHVVzRfQ3auRlpIkBoW/X1J+nZGUm7Ttw5/ABXZMbLI6/fa1
        JZ3z4kXuBkj1pgf2xY70VDA=
X-Google-Smtp-Source: APXvYqzBHMokFgazeXvVhlIsGNQptxp7MlVQCOY71io8dzJfxvHYVNf76XwBhNKBAZIJc2efUzGahw==
X-Received: by 2002:a63:8a4a:: with SMTP id y71mr18680151pgd.396.1573858648980;
        Fri, 15 Nov 2019 14:57:28 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id v64sm11214629pgv.67.2019.11.15.14.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:57:27 -0800 (PST)
Date:   Fri, 15 Nov 2019 14:57:25 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cole Rogers <colerogers@disroot.org>,
        Joe Perches <joe@perches.com>, Teika Kazura <teika@gmx.com>,
        Alexander Mikhaylenko <exalm7659@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - enable RMI mode for X1 Extreme 2nd
 Generation
Message-ID: <20191115225725.GA251795@dtor-ws>
References: <20191115221814.31903-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115221814.31903-1-lyude@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 15, 2019 at 05:18:13PM -0500, Lyude Paul wrote:
> Just got one of these for debugging some unrelated issues, and noticed
> that Lenovo seems to have gone back to using RMI4 over smbus with
> Synaptics touchpads on some of their new systems, particularly this one.
> So, let's enable RMI mode for the X1 Extreme 2nd Generation.
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Cc: stable@vger.kernel.org

Applied, thank you.

> ---
>  drivers/input/mouse/synaptics.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 56fae3472114..704558d449a2 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -177,6 +177,7 @@ static const char * const smbus_pnp_ids[] = {
>  	"LEN0096", /* X280 */
>  	"LEN0097", /* X280 -> ALPS trackpoint */
>  	"LEN009b", /* T580 */
> +	"LEN0402", /* X1 Extreme 2nd Generation */
>  	"LEN200f", /* T450s */
>  	"LEN2054", /* E480 */
>  	"LEN2055", /* E580 */
> -- 
> 2.21.0
> 

-- 
Dmitry
