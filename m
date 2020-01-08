Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F93134688
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 16:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgAHPoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 10:44:21 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33286 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgAHPoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 10:44:20 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so1785090pgk.0;
        Wed, 08 Jan 2020 07:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GJIUFZ+IRbGLtnqTgbLaM/lLGOdp/TzPHfM+NWXgIB4=;
        b=PoGThj/M8e0D220466gOL8uaJLCWsDgZJ4z9NWUS+hmVG5RRFBYVv+Z/ZW346/VDcs
         6yUrGeVV+9tJfjs8I9PaDyzZF8HQ25P/GsjWA1r84AR831HQ9vpX+kY2iCM1oByGT54P
         zChMcaS04GgcsccTQt6h67APhPlGJjJI9j9q5OydmTLFhHmWmgZIGHpVpJHCEj4TTS7G
         v+747D8JP6u+QVyiTKANpMxVzRl4lpNlM8n3mH8W39W7c9Bt3eHgPxYLdp7jZ/tzGbbE
         Eifq/oNkan21Gn71XyZcdpJfMQlUia0aQFuScm36ktwQeWatJ/omrCZgx0qKmh/agDfn
         VqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=GJIUFZ+IRbGLtnqTgbLaM/lLGOdp/TzPHfM+NWXgIB4=;
        b=Rn7nMFHbiiL0zCQ3YEQM9khSPaR7z73nJJa0GEFd8o/nm/DkB+OkDZopzKUMX53JE2
         MCIXJDqHK1JxOBVDgZu8pYMkC987k10skmobEH6kGH4X1fxza+xg0zsIqw97n2jy9h+S
         yHwhWTSiuuEfyq02AnYa1azDXuRtvaZbyWapIZiDUMRu6W2zk2DbfKrHgzOxIG0HxPx5
         s58Y5BRjlax6vD0PhXzQk2wiyu4NhNQw3rJLQeikDDBX3GRvtlCboP9Wmi5OpA3FcVcy
         7OcQ6s5a7RoB+m1rPx8o8/TSYiEFQ1LS8UgN1phuVclQ5VEzWKCjFvzkanwF/xUz7UNw
         Pnhw==
X-Gm-Message-State: APjAAAX2W/NeHwzpEqzmffsLQ1FRMpXnvpNu/UFsBTheomV+EQuYXDHS
        cuhL9/IERWWHtHhN1X+OCtcVXWY6
X-Google-Smtp-Source: APXvYqyBe5QZczPDXdFMiiD33WOGJgqlWk9R9U7xRWHCoEeIxPMhmdiV/0SFlc1QfXy2vFscjT0EVw==
X-Received: by 2002:aa7:9af1:: with SMTP id y17mr5670137pfp.21.1578498260196;
        Wed, 08 Jan 2020 07:44:20 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 200sm4165387pfz.121.2020.01.08.07.44.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jan 2020 07:44:19 -0800 (PST)
Date:   Wed, 8 Jan 2020 07:44:18 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/191] 5.4.9-stable review
Message-ID: <20200108154418.GC28993@roeck-us.net>
References: <20200107205332.984228665@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 09:52:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.9 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
> Anything received after that time might be too late.
> 

For v5.4.8-191-gdd269ce619cb:

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 385 pass: 385 fail: 0

Guenter
