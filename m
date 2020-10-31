Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4EF2A1A78
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 21:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgJaUIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 16:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728491AbgJaUIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 16:08:17 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8E5C0617A6;
        Sat, 31 Oct 2020 13:08:17 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id f37so8866083otf.12;
        Sat, 31 Oct 2020 13:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=So3E8dIRiuDDMUviKu0CqvLh17JaxXQXkl2u5PUoXCs=;
        b=VMYHvOl7EicOkHtKyXxAKb8jUK4gFJpr4z78sBKUZ+q6STkJznsW251OhG9B1EwCae
         TKJ2pvO9x85SO95kzh3l1WFQ+CnvSl1+Q7F6Ef4XF8/1K5MnEdz4DJn3iKMstoPouSAH
         ieqhhmMsnIXiO0KZ3lYQra6wx+9z5zlQnR9hKLMZWG7nyEgCoRrfeplGoP7R0s0/acZ7
         9I7I+3hg83ix4LCCo9X/B5ahv0FCn3tiI6QDWihQTsm7kwGxCjffwdUaB8sKT8JMgn/E
         gJcnzTjiODPs78wfb1+VdN1RZpX/YcoK7XNSBzm/HgYEdKyOMmpuu5jWZJuCRLsKNWRU
         I+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=So3E8dIRiuDDMUviKu0CqvLh17JaxXQXkl2u5PUoXCs=;
        b=X/bXFrTRjPUnbn1a3rqqm+QeN8sI2hixn9oMrs0Hh65UfcqxVYDWQShWfwBEY4XSNE
         SxOys5Hz1+OEthiKjdNlF0BYSrkyUTaFrJqMnZJOqtAu0o3or3wUYX35Z3m0Z7r9Xg0U
         gSJP4+Ds43nWhMrNuosbZrBduStv46BZyoOnKNoVqeIKVnzrZw6lsJ0PRPAfUQxuEg4i
         DlCrDR/BBNaeHfEhoWTVb+j+fkpBpjvNcGC9pI+tLtrr7EVyVLGa7FdMm6RQwlsqYS31
         x+TwkH6M0NzroGczKego2WYKye2mCPRzyeweK+EaPFahVWXmgaWWM9zNOiZYg0vSN5b8
         S1HQ==
X-Gm-Message-State: AOAM533Lzh08ivOw1I9+IcMPdXP1+HT0UoswNm/Q6J4LtLfAre8f4UW/
        EM40IcfMLWaFyrwL4hGW/GI=
X-Google-Smtp-Source: ABdhPJykROCqvqqCBty8BSdo4SN2tETj7QviOW7x5Q4nWSLB2RK9e+bDK7ZzNpkhY73Ezw0Mrv5u4Q==
X-Received: by 2002:a9d:4d83:: with SMTP id u3mr1776730otk.283.1604174896328;
        Sat, 31 Oct 2020 13:08:16 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k51sm2392683otc.46.2020.10.31.13.08.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 31 Oct 2020 13:08:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 31 Oct 2020 13:08:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/48] 5.4.74-rc2 review
Message-ID: <20201031200814.GA45965@roeck-us.net>
References: <20201031114242.348422479@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031114242.348422479@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 12:51:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.74 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 02 Nov 2020 11:42:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
