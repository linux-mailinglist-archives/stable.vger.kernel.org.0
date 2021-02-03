Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF8230E427
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 21:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhBCUlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 15:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhBCUll (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 15:41:41 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585EEC061573;
        Wed,  3 Feb 2021 12:41:01 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id y11so1221137otq.1;
        Wed, 03 Feb 2021 12:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UNibgpzZ+wKYerZBUsbUOnMvTsohX21Q5tS+gbnhFhU=;
        b=aTw+d8DrLjvhNA7TORn7T+2/RCUq4c5E8sS1tDvvP8qYKXL6+K+5WQsipBNE/bADz6
         KoYsic/ynbJ8NP9TzfyvZ+fgcqlqLdT3EMyUIXAZfYMh4EomvtIIn5LBEZ0SYJt4DVXE
         DesN1i5v8xsgtEUTV+Rz1K1p8y2j3BY8MKkVz+KomYhGFk4BN5jBwzlWdzmV3gkr8h4v
         HZIqqpNRyCYH0qkLeO4re5WaX/ngrfMcg/DD2jO8m8fpSzr58ILxLKUjwOWQnYUofZP8
         K2GVi0aZmIidyLk8AStTGU/y5+ngHzAGK+R+8hMRsfCMe25RaWWUOTDOJx2B9+vj6ple
         0P9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=UNibgpzZ+wKYerZBUsbUOnMvTsohX21Q5tS+gbnhFhU=;
        b=GEoynndtpzGjy2w5dlrl+PRb1rVGASY6bpEaeO/8VyNuEQRCMXbdZgMjTPAp6nb5Vy
         AUqglrfGCxUu2CFGW1Qj+ui+LaoomrZGM2uPfAQwxTfVwDikNBhWb4Aet2dB8YSYiLYi
         J4L7XLJDtclDawrWiLeUZK7oorkAUq53anRf+yuPXfAZtdmXbb3f4aK9SvDepPCmirM9
         +PwO1z+BaqZfPByudjO/j6H3C4pbghTnzSzmCeCGnrjFFPfraPS3GLXsxfXDOKLR1Xno
         F+8BpS2IBQlWiVZblScu/5JBIPlwHLxzlNTuwqfvZ9JyucGibZBklbSgsK0VKyT/birt
         StZQ==
X-Gm-Message-State: AOAM530sO0/iMupgBlPiLhipu45cjIH7zm7yKL2ZoZgwr14Y5akYxSXH
        liy/b9RqLHr689dFTSJereoL73MXiKk=
X-Google-Smtp-Source: ABdhPJxMYC76dnTpsx4wapLKPw4PBihTx6DK4gLJH9UfBvhMYmB7Wxcpok8MNF7/A4lHIGsky+ndYw==
X-Received: by 2002:a05:6830:134d:: with SMTP id r13mr3336582otq.140.1612384860767;
        Wed, 03 Feb 2021 12:41:00 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j16sm671831oib.52.2021.02.03.12.40.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Feb 2021 12:40:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Feb 2021 12:40:58 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/28] 4.4.255-rc1 review
Message-ID: <20210203204058.GA106766@roeck-us.net>
References: <20210202132941.180062901@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202132941.180062901@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 02:38:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.255 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
