Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7967B90C
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 07:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfGaFai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 01:30:38 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41695 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfGaFai (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 01:30:38 -0400
Received: by mail-io1-f65.google.com with SMTP id j5so129461792ioj.8;
        Tue, 30 Jul 2019 22:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9h9qr21ovd1ZdAAZ7ugBWS01jiT70M6epB/80fiZnRM=;
        b=BctEL2ZX/qlkuyBDKV4KKMSzdruNUwdhlZIU5da+cgi4b4OKgLZdKsLtTgx/BolYpC
         W1fOmj9xcJo/dnoWjNn8zPCc0N0MJFVlj7MJ84o4TY44L6A1kqchv0mHByuoCl2OYkwL
         3VUMNUFzEhut3m194WXmNW8kVg7S9DMqef8q5B5awRDn1Gdv0SCdiaMo84842fDBz7+F
         oCY/LcTIgQN1nPDUQPebZzASqm24iCScNW3G6SLGYuJ+tGP9jDw/up5KPMlBRjNrYRQK
         PVNaglULSPAH7Mk5HM8WrWjtuZOXgMnQvdmZ6lrKyeiy1edATYFXIUWGgLChV8X+QiaB
         pvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9h9qr21ovd1ZdAAZ7ugBWS01jiT70M6epB/80fiZnRM=;
        b=Xi+rHe1JLtcuTsUN+pByoL/nIG1AB0uzd7/RaAVXbZXo+n+rkY3gsdeIV5KrV7d8F7
         3z/IsU39GLVCiBaW6W4fUh/EtGUvVdCiwbPKhLegoGUxPDkpFlOUMu6dC56satUusqA9
         dAEI4F3gcFawi9osZuAnCU32Pd+8njTQ48cUotY+ImBYJfpKRO445ZxWiv426Pa3DoyJ
         /WSyHo52FHsZOt0PRlEjTvA9D9JuYTO7U7iTbej4sXfI2liZ0BG3oGIh/1c0N7aDnZuU
         JG+Dg18iqP6zJ1BsebmYbjsvO4X/YdDPMXPbwISzLAMgGjgGhxfvWm1NDrkHOBoFaL04
         xS7w==
X-Gm-Message-State: APjAAAVmQYG9Jv+hw5DQWa+PzRqj+qmCGjWps3XqNwMcxX+hAQ7yADVS
        RPwojylzI8K2URWYlhniDWM=
X-Google-Smtp-Source: APXvYqyIbkvEtg+JH5XCPFWVQrkeTrmjm1G0S/YaXIq6yyYC+zwIy1WHWa2hdsT7QNr7cUDyVM7h8w==
X-Received: by 2002:a5d:87da:: with SMTP id q26mr102037166ios.193.1564551037453;
        Tue, 30 Jul 2019 22:30:37 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id y18sm63731859iob.64.2019.07.30.22.30.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 22:30:36 -0700 (PDT)
Date:   Tue, 30 Jul 2019 23:30:35 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/113] 4.19.63-stable review
Message-ID: <20190731053035.GB4326@JATN>
References: <20190729190655.455345569@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 09:21:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.63 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.63-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted with no regressions on my system.

Cheers,
Kelsey 
