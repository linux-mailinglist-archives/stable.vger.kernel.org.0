Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A295F14025C
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 04:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgAQDhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 22:37:48 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42122 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgAQDhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 22:37:47 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so11269110pfz.9;
        Thu, 16 Jan 2020 19:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IOMBiPn5diyVcn37zND9XcdLr5eqb4ZCuFIh7nwBBvI=;
        b=h3BN7sJiAE71AxB3UoxhzZdoMzvAZJwC0PFKI2+vsrsqS7BPzxkwyUoh+GsIetXH4k
         bA820vMnySBgqNkMFJ9f+9HZ2K18puWc3Ap60u2cCslyU9bQiQxA+3d2LQKlfpmjl2CD
         IgBsqKvaMPMahjbxek0H1r4I7NfHCZ8A5A1VxkZ5euAXNcd+mfF6PPwEAqaD9alEDUHA
         zu6/x5nztIbewk6FLUsIP+JUhk4YkOONgK9SyU4DDvLw8YdsHIgh5qTkNiuSiE/3Xole
         m4QcRBXqQaYN9mEe4VI4NXRjO676FePdptdFmNjexyN0d9ol8hyl+L20dTDu35H38V5s
         xO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IOMBiPn5diyVcn37zND9XcdLr5eqb4ZCuFIh7nwBBvI=;
        b=eaVNiD2r6k6A07u7DdYZeRB83ujqvc9mKxG3GsF0bPikyaROQmWH+/FOt1CpasqXOn
         AdHnPiCuhS0HRvJRhXzsCJJXdhuN5UM+6Z5EAYGdYgNprNHuRHvxHqWgRr0/ebTk241c
         NECjAw/kTouVakTJS6nbhXlMn9zV69IFhZsFrK5iTUfjobyO5kws2s2NyrUxDoplzohB
         yiiqtq4EZXcX9SroSLx5i/f2cYlcHXPQl+Z70hnHbgVbiDV5DKyw20qKyFT9GjGLu5px
         8RY8l+2P/5xikvl1idSRBRr1bgmQcCNWOH5WXnODUFQDSuVjTycB6GL7JZ/g00jJVx6t
         u14g==
X-Gm-Message-State: APjAAAXECQY7rh+wxr2uny1Zb+Fyan/KMdRj+n7zF9wEAzCvrecTPsmJ
        +9z3+inrpGKgKsYCxs/gBK8=
X-Google-Smtp-Source: APXvYqzNpGV8dUq0SsgrafcwveW1nffkJMFmfmvtFYbyhs7gM/GD6KknMvGcyVkhEDmaMvjMvXjw6w==
X-Received: by 2002:a65:68d4:: with SMTP id k20mr43739997pgt.142.1579232266878;
        Thu, 16 Jan 2020 19:37:46 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id k3sm26460240pgc.3.2020.01.16.19.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 19:37:46 -0800 (PST)
Date:   Thu, 16 Jan 2020 19:37:44 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        Timo Kaufmann <timokau@zoho.com>, stable@vger.kernel.org
Subject: Re: [PATCH for v5.5 1/2] Revert "Input: synaptics-rmi4 - don't
 increment rmiaddr for SMBus transfers"
Message-ID: <20200117033744.GC47797@dtor-ws>
References: <20200115124819.3191024-1-hverkuil-cisco@xs4all.nl>
 <20200115124819.3191024-2-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115124819.3191024-2-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 01:48:18PM +0100, Hans Verkuil wrote:
> This reverts commit a284e11c371e446371675668d8c8120a27227339.
> 
> This causes problems (drifting cursor) with at least the F11 function that
> reads more than 32 bytes.
> 
> The real issue is in the F54 driver, and so this should be fixed there, and
> not in rmi_smbus.c.
> 
> So first revert this bad commit, then fix the real problem in F54 in another
> patch.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Reported-by: Timo Kaufmann <timokau@zoho.com>
> Fixes: a284e11c371e ("Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers")
> Cc: stable@vger.kernel.org

Applied, thank you.

> ---
>  drivers/input/rmi4/rmi_smbus.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/input/rmi4/rmi_smbus.c b/drivers/input/rmi4/rmi_smbus.c
> index b313c579914f..2407ea43de59 100644
> --- a/drivers/input/rmi4/rmi_smbus.c
> +++ b/drivers/input/rmi4/rmi_smbus.c
> @@ -163,6 +163,7 @@ static int rmi_smb_write_block(struct rmi_transport_dev *xport, u16 rmiaddr,
>  		/* prepare to write next block of bytes */
>  		cur_len -= SMB_MAX_COUNT;
>  		databuff += SMB_MAX_COUNT;
> +		rmiaddr += SMB_MAX_COUNT;
>  	}
>  exit:
>  	mutex_unlock(&rmi_smb->page_mutex);
> @@ -214,6 +215,7 @@ static int rmi_smb_read_block(struct rmi_transport_dev *xport, u16 rmiaddr,
>  		/* prepare to read next block of bytes */
>  		cur_len -= SMB_MAX_COUNT;
>  		databuff += SMB_MAX_COUNT;
> +		rmiaddr += SMB_MAX_COUNT;
>  	}
>  
>  	retval = 0;
> -- 
> 2.24.0
> 

-- 
Dmitry
