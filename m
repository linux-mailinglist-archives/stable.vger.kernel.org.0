Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5336D3AC76
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 00:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbfFIWhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 18:37:39 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35320 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbfFIWhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 18:37:39 -0400
Received: by mail-oi1-f196.google.com with SMTP id y6so4974112oix.2;
        Sun, 09 Jun 2019 15:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BkhyCm75Rb1MkcKMg3McqQXpRUNbixA7dTtK2Tolxzg=;
        b=tBIo3gOwa/FNPIMAtL1BcIk+oAc/qfTRMt2HsHpuRTHGwIsR0hTBx/Xlb/CJ8nlgFy
         o2sUVMx5U9hBZmwaFqyokKyxFQCeuJYQN2KFn8Z5ucn6ko98YdCqr8+p0zAxr5YvkcKp
         nt8pzVy42Ha/CxfWfuArn54/s5zpNZnYPIJ09gWwjeyB/MFek1e5Lkl2klg5Tf0I4FrB
         pspRqcaakruXGohXNAHjnp30EOzgkfjWYEBtPATfoqqbpDvV/2orj3215AaMSxsYLo4k
         H3zc1D50RbOS+2w9EChRMYf8b9ZR8yCJp8dnD+vRK5uZQSa9CjbX7ToIF5HC16AIYCD5
         odgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BkhyCm75Rb1MkcKMg3McqQXpRUNbixA7dTtK2Tolxzg=;
        b=lBCgUol4DEPqv2ufRO5zeZ0cxRBpob1bJmHDfDNIfGXuhCwBTt6Eyec9lo8q5iBpQ+
         XuSWmbVorTe+ht5S2nETAemONp8FynXwb0J+0g9I+9M/x0F3B48msLdf2ZmuETXuZYIM
         a45/lk9kqRSSyfmpWGFu/KieXTnX7eKynAgAWFZTKvPbU0zqk4FOIK6hlVwtz3YEbRTG
         JxmpYS/4t/GdBLVSM2AZlEwt/OXvl2xO5u1OZSoXPQ8f6HAg0+OOgyfvKFqCG5iUyGpw
         G1q9TxFsQh54QjlpNDyXh/8HeQchGQ26wYQsXnC6HpHTabaVtW+c8hyAZSjv9gGOoLcD
         lJpQ==
X-Gm-Message-State: APjAAAXZTA2NLathrVvT0VwZnfVdfVBsqNcHcOt1lYoaZPsDZB6xhZA6
        5YPcnCK3KKg03oVL2VWRinQ=
X-Google-Smtp-Source: APXvYqxRooxhVNRS6VDb/NLznkW1MoQM8eump2EsO7YBLAjMQj0JkYBghUv2U3P+eqzuWca5+lEAyQ==
X-Received: by 2002:aca:c584:: with SMTP id v126mr9318875oif.60.1560119858474;
        Sun, 09 Jun 2019 15:37:38 -0700 (PDT)
Received: from rYz3n ([2600:1700:210:3790::40])
        by smtp.gmail.com with ESMTPSA id s4sm3231514otp.3.2019.06.09.15.37.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 15:37:38 -0700 (PDT)
Date:   Sun, 9 Jun 2019 17:37:37 -0500
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/70] 5.1.9-stable review
Message-ID: <20190609223737.2gaz62e3q2yp2ruy@rYz3n>
References: <20190609164127.541128197@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 06:41:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.9 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:40:04 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

Compiled and booted.  No regressions on x86_64.

THX
