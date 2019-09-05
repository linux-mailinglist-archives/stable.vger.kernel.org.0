Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB55AAC64
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 21:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403993AbfIETus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 15:50:48 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42668 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403984AbfIETup (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 15:50:45 -0400
Received: by mail-io1-f66.google.com with SMTP id n197so7503628iod.9;
        Thu, 05 Sep 2019 12:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RY0IVmabHqrZUhvYIrOUchijkEXhUN6S0BVnB3nN1sQ=;
        b=DUiKreVfuOV475ZxGFJN2JFNJiBsNri4krWr6FMvc5AcC4ey0ESU5iAX98Eff2iZ5X
         hqchgShz3GwUO0kVW8QXyGVD2YpkIdncs3EGfzmBI0ov4pgrwYJ9V7PN9T31XSJp+i4I
         sJm2ohmAseBgqpCDNl7EiqeFSiOcO8YEszF0bjV11vxsCdDIszKcvQehl0Kr3OuvO1CA
         fXUdHfQVVzQBUmTH88aGrugzLoT6KmfxftA6yY8tcnKAQXBj7HssTzSvYWWXepghq1nS
         UfiaJa/PBP1JIkbstkq3KDqz3bT8wYnxHawWjoAzmARIslWGoteFidcEsJ2Tmz5y6KU5
         +G2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RY0IVmabHqrZUhvYIrOUchijkEXhUN6S0BVnB3nN1sQ=;
        b=MaaeUsBP7MNGyTmW+NkimRZTrz5kRaGYNUyzZyeQVsf7ZdP+OXjXlGhUxZATyjSK2f
         +hDSOkA/nbpCxN8YsbGlJ89/yhubRylOkgJpZLRDLFNcen52KK8TbJ20A0112TnOzZ+2
         UXbIeShXlUCaHihYnDmnRWQAHUqQ4pt1KmMtflLjRh9THspVKUCAdAGVwV7W6lNjbYH6
         7z8mBHtdTHKb9oB0+vsVmRAarUqq0ajJxpj/cAYxc723t+9lSst2pQqUv6dEULQQ1lH8
         6JIHyh+cY0Y54i0/ecu4xklE1Kx61+2zoULjUK/i98QghVcr2R894G8aJOehfkg8FljT
         9cvg==
X-Gm-Message-State: APjAAAWkn9XZjlSRZR2Ea/0zmt4qG6e+j8gNl3QjpKKZP/CF1U4LWUNh
        HXIXAnRFBDaaibY6ZgUm5KQ=
X-Google-Smtp-Source: APXvYqzTQ/yyq4A2eMjlr/Q6BN142SJXbMPhGOKpK3YCK+kayVaV6/mb2DrZ4Mi3APEYB/be94rV3Q==
X-Received: by 2002:a6b:5a09:: with SMTP id o9mr6335168iob.45.1567713044723;
        Thu, 05 Sep 2019 12:50:44 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id q17sm2062794ioh.75.2019.09.05.12.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 12:50:44 -0700 (PDT)
Date:   Thu, 5 Sep 2019 13:50:42 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/143] 5.2.12-stable review
Message-ID: <20190905195042.GB3397@JATN>
References: <20190904175314.206239922@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:52:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.12 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled, booted, and no regressions on my system.

-Kelsey

