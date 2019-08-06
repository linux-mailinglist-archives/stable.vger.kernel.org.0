Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7641835AA
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 17:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbfHFPuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 11:50:23 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46669 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfHFPuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 11:50:23 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so38010644plz.13;
        Tue, 06 Aug 2019 08:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u6dMmkj149gP9miv8zHDNNMFxn9m6BrDvxKXAqMzwEI=;
        b=jhpBffvhPSCf3In/Wz50tsgAGUBC3BQ0Qlf7ouWoE5TXvjnd0Usp2S+XZQt0QZ/i22
         mAMLBxJs8Xv2L4vCPggXPK9U2DcY/ge+OzlOyxOlHLKzToI8sk9A02IHZHZaehVKqhk/
         1o52A6FYUnE0B9FMis8k62hNWY1b8IQzR/4zit67MLekuh+CPQX/J5Z4K4WX1MW2jHlt
         RUEz7y6PmUFwCkhRzj5lr/FeotQ3GRrfGFPFXaFk7jE6fTV0jpvOob1wsCVDI5eKr9an
         NcRp8Q+jJXpsaOEK+nRPCLdhByatAks64YCeXy/dbh9Lipw1fVL+rWM1czjUwXv5HxbE
         RUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=u6dMmkj149gP9miv8zHDNNMFxn9m6BrDvxKXAqMzwEI=;
        b=Yt0tSWkvakZBgpWxVvQtBChiQ5Med9yyfb2kGRg4JscRQWcyLDJzbBQQMpRtnS3yef
         Dd3BvbXgCZek3zThLUU0L2pB65mPeWHshhS34gNAZH6fP7Ys3UZ4Oh4GDQ+0kvHil9El
         t2pSh/590rHTPL9dYTzZFBSPbEK5+PlrrgRx90+EFdD5Th89kdSSjBDLZyp8rrkTSv9m
         SB2+tqeA/3Ls3WNpxA1F8thknj05yPxdZYtkPo7049NeAz66Xrd/ihJRk7EA0/mubb8T
         rezJr21BxxG3pNRGXTE04EubBmvE/YJHgX09WP9ycKMRIzNaeMgTP22VlkWga3nitZrL
         EKjQ==
X-Gm-Message-State: APjAAAXaIN62hg0frW55NoYBqCUsdipWGref5qFoUGmbDHMzHdgE3xHe
        f/I+Uurk1AL3cx9qTylSNW8=
X-Google-Smtp-Source: APXvYqwXTfTWcMTHnb8iFDeDq6YX5vcra5uOdK9UmjmFGKkzVuPr4IzB9htp53hUE6hZf+lvY+DdnQ==
X-Received: by 2002:a17:902:2ec5:: with SMTP id r63mr3800478plb.21.1565106622445;
        Tue, 06 Aug 2019 08:50:22 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 67sm65790348pfd.177.2019.08.06.08.50.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 08:50:21 -0700 (PDT)
Date:   Tue, 6 Aug 2019 08:50:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/131] 5.2.7-stable review
Message-ID: <20190806155020.GE12156@roeck-us.net>
References: <20190805124951.453337465@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 03:01:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.7 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
