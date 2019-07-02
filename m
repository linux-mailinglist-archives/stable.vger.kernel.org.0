Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E62E15D5E4
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 20:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfGBSGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 14:06:53 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38242 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBSGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 14:06:52 -0400
Received: by mail-oi1-f193.google.com with SMTP id v186so13850270oie.5;
        Tue, 02 Jul 2019 11:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nYVejsXnc43966TYt7KG3LYUifcJTI4MOCi0e5/9fGE=;
        b=iv42nGLe5raqTeIrY1m73Ru4Xf/TMZcjdURBsuElLCqgoCFviR+hbCXwwNvj3Z6PSB
         sVNz0/amQBbnXHUlJxNa0zg5+MbMg96cZGkVb8XBJsl2tLrFbE/XeHZwZjHPTzzn8vw7
         UGvfDVi2zBFWDwOINHM3Zly8ny+LxftGfoMhLx7a8zN4MDgpgqihepu15Pju5pTVR6XQ
         U4Jg4xvFbEQg4xWxkIdx6dkHadBFTgiZRd81AG1RxB8i/ImozvgF3W/Er4KWH5j5K62m
         r22y78reMjCEVu07ZxHFFiLn7sSJsBytqfAjYJWWsLYnf5eINVY/YZ0JYVa5MhmhKvAX
         7okQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nYVejsXnc43966TYt7KG3LYUifcJTI4MOCi0e5/9fGE=;
        b=P8NrqFOH7hWvBNk6NTy3WW/KaicandXZdNvIc+9u2kSR2ov1GFMzzLzdS9MEKaHyaP
         1lbMDc51ARZaVcTlkcPVgUOY3vkrTx2GCPxcIUCmt3SF1dHYYxwExZoKMemcBOjegg88
         qO1OaNKi1yZRywO27QU054Fma5vFdBpRacln8PaD8r340GxXBcmJFjZr28cQ5hOlZEh5
         TVlBjXuqM2WEAHSWNt5RRc55GnZ9lB0sXUKLoWAnmmz9TnH4hk0z2/MKdSpkSl8jAPBt
         XgS9Vd9nWTB6d1OTeJ3eVWw7zZ8ILzpgIirSeuo/YbeHOgIFbKU7SNt2pf917fofJXrB
         dOFA==
X-Gm-Message-State: APjAAAWwQ93roTyLO7q+QXqXs6D1xgBFClmVgchbXiZ9fZPBsqGapPq0
        knfrUWacuNbTVjpo8md+pEU=
X-Google-Smtp-Source: APXvYqzrf0Mu42+f0PDhd77W6c+3NdwbHrFJSyU/0riIXQkTAei/P5AOvDvWnyDQLlov8t76ZwVxnw==
X-Received: by 2002:aca:bd43:: with SMTP id n64mr524373oif.148.1562090811249;
        Tue, 02 Jul 2019 11:06:51 -0700 (PDT)
Received: from rYz3n ([2600:1700:210:3790::48])
        by smtp.gmail.com with ESMTPSA id q82sm5301380oif.30.2019.07.02.11.06.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 11:06:50 -0700 (PDT)
Date:   Tue, 2 Jul 2019 13:06:50 -0500
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/55] 5.1.16-stable review
Message-ID: <20190702180649.swyk7tm47zr2znxa@rYz3n>
References: <20190702080124.103022729@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 10:01:08AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.16 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

Hello,

Compiled and booted.  No regressions on x86_64.

THX,

Jiunn
