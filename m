Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71F9742BE
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 03:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfGYBFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 21:05:00 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44455 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfGYBFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 21:05:00 -0400
Received: by mail-oi1-f194.google.com with SMTP id e189so36331939oib.11;
        Wed, 24 Jul 2019 18:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MGhC6NZhOcJQTc6Z3cGfpdRL2TRfqyy0teXVcrSw7IE=;
        b=oUVUoRjnZ1rgv56iP4UaAuxbEeOUpXlSQk5y+mGbudilenj33di8mVPd9HjqCXYwlr
         BxvaNqpdLD+wHcDolTe2p47Kge8ZIVPaG/uxsCu9NeUD0K94p8KTgqxPHHXqkoaQAeTt
         zVjAmKSzGmOsjmjtW6c+BAP8UU+m0Z+BXepqJEb4UDlKPiDN2UZhajl/RNk8PUWRHqaJ
         mGbJAnop5HwRThUaIYs00OWL8Batt4bw4XSpCCm480nO85xvTbqfTcSLy7iUXUAlnglC
         gwBq8bWNQlEgoYCUhgACYferc1H/CCefC3ZDhsu+0JDgaCQbRdQ+hY7/x2QegDoHxNRx
         6D+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MGhC6NZhOcJQTc6Z3cGfpdRL2TRfqyy0teXVcrSw7IE=;
        b=H9t6kF5TJp/xyBM+95McZZNkF0P+SzmqnpzvGjWQrgBl16KkCAbqXtItUzeF7UtuBX
         6RKxiLU7MTEEWA5Oz9cQlET2pVwg0RfFOGb/s8QH0A0W/p2R9VZEOqt+R2xmglZGuG1C
         BrU4LqEdkHssQ/MKd+ECRcHaB6R2nLY1cok5LjLULskDkvu1IoimP7pOeMn9vceSbH4V
         9zUNZKbUySXacfjfGrjxQcgGZlCJhRFJoxAoiVWsmJKzRZRmV96NT8/lURycMCtjyNMP
         d6y5QnWu7r0/BbPwl1yYSVVDVRvbfPJ+61yEC1kTzh3heJUhnOuF6f+1j5hsaQF6KpSm
         njfg==
X-Gm-Message-State: APjAAAXYGHW1X4ZA5aWJXtPdR5Gv/NM1zNu/0OyxCtz6EvZVmSV+op7p
        oGhJtdZLCgmJFv/+aT/FX0k=
X-Google-Smtp-Source: APXvYqwIYVsVsc/tlDJ+zFrTSRRpIZI6ROoGTG6oXu07Frd1LqpAWczvtTwsPH6whMr5wnwWTtJhlQ==
X-Received: by 2002:aca:ab57:: with SMTP id u84mr40928096oie.61.1564016699117;
        Wed, 24 Jul 2019 18:04:59 -0700 (PDT)
Received: from rYz3n ([2600:1700:210:3790::18])
        by smtp.gmail.com with ESMTPSA id 11sm17314621otc.45.2019.07.24.18.04.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 18:04:58 -0700 (PDT)
Date:   Wed, 24 Jul 2019 20:04:57 -0500
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/371] 5.1.20-stable review
Message-ID: <20190725010455.w6houpa5i725fujz@rYz3n>
References: <20190724191724.382593077@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 09:15:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.20 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.20-rc1.gz
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
