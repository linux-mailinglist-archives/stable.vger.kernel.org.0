Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6E9AA974
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfIEQ4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:56:04 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32837 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbfIEQ4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:56:04 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so1750645pgn.0;
        Thu, 05 Sep 2019 09:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0R4bH0Domxm7RyoOUe1UbR5mE5t6LGyr8F7+lDPk65E=;
        b=YMqszTN9KKnTMCUuvttg/iS7tT/5oYXerT1f4cPOyN42R5yJjjag2VWpSazlO9e/RO
         c//SImcMsElIftdtzUIqehc7MTKW334SZamcBU1GKCGY9UZQeMwhRt1WZdz4CUE2H1et
         p7YTAj4w7dxNagq9VKGFxKYYplB59/SRZB0czevAUpX5GBgjPjjH8E0eeI5LPOdtQNIs
         p+G936IlDj7QiyJZC8FcVofHFMeFdZC+ZH36tB3aYnAEDkpz909MvEftL0Nu/ukZ40i2
         QeuM/mhLZ5s8h0LkZlR/U69NzpvWzZ0Sdp3bG6GDWtPr9SrRv4rZIqVFzykd2q+nHgxr
         WnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0R4bH0Domxm7RyoOUe1UbR5mE5t6LGyr8F7+lDPk65E=;
        b=gfQbWgb6nZg+N/N5A+gQl/HZPsGjZTRpla2pwkLjp+8R222z1ltsJLUECwJazleUav
         lkgX1Dl5LMUSXDTmVH7vLeGd5rC1Cz79t5myqpdrlljTkNWxYqqvM63sY8hC6ngxW3mM
         yHGgShH8YWLgfPUjmXKml+Ztdx20QkrUPp0oqLsXxHPHpTgWl6kY7JY5jn1F8dUiNF7k
         I1Qq1Ivar5fKh+14uyNEwm3kSHxszRjs8pvL7+ZILJMobFH63Cl2+dmp4cnWsiMcrRxF
         QHvmLYh1tQgIOUbuuGFT8/rG6dfH6s113a2qxZth4MnVj8RaU7tJ+b53lMwe3rZCUmr/
         Hl/w==
X-Gm-Message-State: APjAAAW4Xyxnl4BuZTeTbckOrgJdZKI8BrUOm1sri1UB83V1GyuYzgV5
        bjrlKVKje4+YEwAwB9iijGw=
X-Google-Smtp-Source: APXvYqzBqGarzHN+6NUMcgw/UHDN6HeWDhp9FvLk8aDrQxlezQZlKEFN/irDEw4mkCeHX0II4hCKWQ==
X-Received: by 2002:a62:8344:: with SMTP id h65mr5077843pfe.85.1567702563969;
        Thu, 05 Sep 2019 09:56:03 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 74sm4047505pfy.78.2019.09.05.09.56.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 09:56:03 -0700 (PDT)
Date:   Thu, 5 Sep 2019 09:56:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/93] 4.19.70-stable review
Message-ID: <20190905165602.GE23158@roeck-us.net>
References: <20190904175302.845828956@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:53:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.70 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
