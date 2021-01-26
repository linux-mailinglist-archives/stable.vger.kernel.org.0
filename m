Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E74304C0B
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbhAZWAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395492AbhAZT2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 14:28:17 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E0EC061574;
        Tue, 26 Jan 2021 11:27:37 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id u7so3815572ooq.0;
        Tue, 26 Jan 2021 11:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/CL1XgQx/2ML5DPW5Q9WaUAe5RAZ9TTZioMgHF4rj0A=;
        b=YyhANdVB/4BTWj/PgIKQwYOACCmPSedsHoHhfW7fUBM8svPsw9JReeW/17ApI9DbuX
         QpvOJw81GwD0CQMKZOX0Fqf0L0WcXdjrjCrCc2rRb7P+XIeaO5G0E5zhTa6FPRTCN/tq
         gWlVTxo82crpHM1wQxVgWBirHubCZIzmLyXX5hptlWyK3GuECvcbuVoO7YuD27tsbEzn
         sfO2feVPn5dt2im+xJNfKUEqxs6GaPQT5vVabLglAJyXQL3C7Og2qQKO1Xi/hAPrybM+
         IkrIu937H1w/H2z0rdccQYqviVzfgpgE28E39yL8U0X2dN1DU41Aw7E/ipN04yvyrNh7
         xlBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=/CL1XgQx/2ML5DPW5Q9WaUAe5RAZ9TTZioMgHF4rj0A=;
        b=BsU/HOmW7CPaB8ar5NDhW1LYwlTf8n4wyxKZmVUYBnJY/60ZsmYNSHDPkd1rpmRuw1
         HjYnO8oJxX/W11x75A2v7B52UGA8QF1/zfAiVWt8ySm7O6sH94JDNXOaJIiIoeq25U/N
         zy5BLMgnCejs0aCSD2qjBlq83I5YgQc58/aQsrosUMkle9t710HU97F5PuG4k8XYuDx3
         pD/jxvB6iuCrCb19GcKdfcqCiKTpYw3bPIIRgxWipbbp1dApYpnGIaJ69B1GCgMTioDe
         lDiZRI0oXs0mUzlh9w82TcRoBUa7Ubb9Sfvp35Iek3owTDs/FT2ln5wmmsyzX5iHm4ct
         xxuA==
X-Gm-Message-State: AOAM533Pdxf5/fyPG54aTdIw72d2ySG92W5tlGd5lIxQbHKYigc7Kzz7
        IUUYX6tZF9Ek86thchKoODM=
X-Google-Smtp-Source: ABdhPJy8rJhER4VwSCugHESUnT63j7NKam5gDDZrhBriVaUHlEhyJ89u7BoGJgw039Gfo30ENeZsSQ==
X-Received: by 2002:a4a:d384:: with SMTP id i4mr5099234oos.14.1611689256728;
        Tue, 26 Jan 2021 11:27:36 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9sm4269604otb.65.2021.01.26.11.27.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Jan 2021 11:27:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Jan 2021 11:27:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/58] 4.19.171-rc1 review
Message-ID: <20210126192734.GD31936@roeck-us.net>
References: <20210125183156.702907356@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 07:39:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.171 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Jan 2021 18:31:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
