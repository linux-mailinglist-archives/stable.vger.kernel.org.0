Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A34218F4D
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 19:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgGHRxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 13:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgGHRxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 13:53:42 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D102C061A0B;
        Wed,  8 Jul 2020 10:53:42 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cv18so2323710pjb.1;
        Wed, 08 Jul 2020 10:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5PnJRy12sYG1935a9Xo5XgkcRrnZk2UsCYpoTGCVm7A=;
        b=MEyU8QuVtVQD8KEW91Yu6YVDK/7wMpa3Wltz9ed/UsuS8h+4FwhP+YI9EBJpnIJqa3
         gMsd+eZNhqv02qT5oD8lRb64hbBNq1d2j+xqAE380jyWa7OTo2DcyvpFgje7l0BcvwPg
         aql6fEFXogzZlaJvnCe/JPUzO4YRfIxgA0AlPJIdSlrj6cQtWT/spkDdL+S/dtUv2eDE
         YV/FhjwpE8P4ZR7KfssZ23QPbytpSFNi8WG6WNf68Gufd5cgdcxVtic0a7oSeJl+8qhE
         jflvvDYWbIkt1VnPEzMA3wifIcr/2jjeZUYyanMrADdrzBEMWFPCiq9cJq651M0IgbGK
         IHmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=5PnJRy12sYG1935a9Xo5XgkcRrnZk2UsCYpoTGCVm7A=;
        b=pbm4rKg9HQMvTkx73wJ7NmwAXsOvRzI9ZHvKUuD+fpb5ihDNYkJUZvTIvXIsNvaaCg
         PS2bJSbd3hJjCYTMBlInZy+SjXPYeAsWIoKl9EgC61N0+Hm/iBcmUD+jr7rjIcSnQ1zs
         Ib/f/AIDsZyuOdgr2gWTfPO+EXze01sYnPa13IgqFy/KNBR2uh1fEljso7a+j2xctV3w
         HGHN8tYrzzM3g1xRqSnodxWn/pUpCl3zY3eqct5yLYpXPB3SjC8fEsMYXpf0qgs3oWOP
         jhcc6MHst5HzYHpmRliA/H8CyR7kbGvr8naB99C9vqBaRihmW/zDsWpk/x8DZfmx8uQN
         Hwnw==
X-Gm-Message-State: AOAM530fRWxVSINaNj989U8ttioIWLzsHn5vKGlp2yr6yscVvjxQt5qq
        0WcoK9HYupiXwnXqEGxzJKE=
X-Google-Smtp-Source: ABdhPJyFsEPhEFahajCWfMIBLVKO9KjmW6cw7KRePy98gMiMOuhJxM+ongFD/8qzcXpNcusyQhULSQ==
X-Received: by 2002:a17:90a:148:: with SMTP id z8mr11430534pje.197.1594230821946;
        Wed, 08 Jul 2020 10:53:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w11sm427778pfc.79.2020.07.08.10.53.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jul 2020 10:53:41 -0700 (PDT)
Date:   Wed, 8 Jul 2020 10:53:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/112] 5.7.8-rc1 review
Message-ID: <20200708175339.GF224053@roeck-us.net>
References: <20200707145800.925304888@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 05:16:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.8 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
