Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEDC75D94A
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfGCAkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:40:04 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35613 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfGCAkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:40:04 -0400
Received: by mail-io1-f65.google.com with SMTP id m24so748874ioo.2;
        Tue, 02 Jul 2019 17:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gxgpqisjxGX1NQhc+oEHzkp0Zrr5sdSyWxeNq8ViN3Q=;
        b=brvYuF6336+MvV6Rl+OgHj6qWWi1HZ87beirMYQkIt4k6U7HTER6QLORVWLOdYTNA4
         ZDxfZ9KNdeojeDX8XDaDvS2S48nCuPOUF/f3j0Z2eMKOWDqb2umejDty9Jdk3kJQpxq6
         GfROBqles/joqch/zNUZ51XSpkgeEOrSZssBWksZP5Ai65Ng4KDgR3zqcUQC6SQhuENa
         +i/Bv4mlWU7hv9EYl1NK9RXsQ0BIU12RgCPR/nI+s9xYiVIUGMJ2nbmiW2vpXk1P5fGB
         GRBwO3npLYEK0DGSYAJkdb/IMCfY/1ZcIMOmP+8nCAP46S2/MEXFbamg72B2e370HZfT
         Tgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gxgpqisjxGX1NQhc+oEHzkp0Zrr5sdSyWxeNq8ViN3Q=;
        b=oCeFH2IMYtE+E1IMRLaKO15BcK6VPl/T8na0Mqgvs1GFMJtvAGn+r4EcpWYrOBgF5p
         qIk/ynLn/psG5fdoNomFQqKqjXY5RJwzbADGRvDZWjztqMlvbc4jR0b/CzVKxuf7lwrM
         OmBFH9zeBQ2MeZmdKZEKgWnRCvXpOdpzpw0GODK1tX1+7Eu9CAnktGTTe50IYATSMTqD
         8jsMnYUXowUf2snAdFHn125VsmesucOe61fZzlA6oehHYtBIIvKmLlGfnB/kib625G9+
         rp53N092f2A9Y4EFSYs/yocFQwg6//x36ipSfdoAsv2j67IJJKNq+2GodNsR6uHScdPV
         UtzQ==
X-Gm-Message-State: APjAAAW/AIvN5TSww4GK7KtpTpeUckdCRxO7dSMRf57gDzE7pEnEfcG/
        u2e78J6TWUFwajNaOlVhdKAV2aUz5jzAvQ==
X-Google-Smtp-Source: APXvYqz3qNjH/vYRE4IZRh/zTsFYAjRbz7EXQDFLoHotD4f1bS+zWsmRZIBWdwsBwUpG5lnIPKRPdA==
X-Received: by 2002:a5e:9308:: with SMTP id k8mr35030511iom.143.1562101718512;
        Tue, 02 Jul 2019 14:08:38 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id f20sm108363ioh.17.2019.07.02.14.08.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 14:08:37 -0700 (PDT)
Date:   Tue, 2 Jul 2019 15:08:36 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/72] 4.19.57-stable review
Message-ID: <20190702210834.GA2368@JATN>
References: <20190702080124.564652899@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 10:01:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.57 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.57-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Compiled, booted, and no regressions on my system.

-Kelsey
