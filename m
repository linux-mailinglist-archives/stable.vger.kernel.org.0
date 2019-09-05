Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF032AA96D
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbfIEQzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:55:44 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43157 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbfIEQzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:55:44 -0400
Received: by mail-pg1-f195.google.com with SMTP id u72so1719359pgb.10;
        Thu, 05 Sep 2019 09:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7B/jEZPrvDCjbzk0NdOmvn16eq+aWuucnmVftgQmoWU=;
        b=V2mVXyhHWmHG7t+sLRmle99G1cH7kKFbdoe5os++Y3I1JuXuuTaRR9yyNqjcHVhFoQ
         ZquhXEzGV8lwDP162JGxBVdM3FKUZ4vNbjn1S1AKia2gre/VYNgYHG/ldkHmbYlG3aer
         /sCVZic6n4pleOksjWL6TvUJCw7KRWoBxS2UsDzNzlP2hu4DsI+lKTMmwt+6eXWjDYHC
         8iSv2YNH8bcpVGtaUpWxlU3MEYkvcM3K7ncj92qmUkedmGITKYXoTNTRxm5DQ2Crgwzl
         P2XnMMxcRB/e7ua0yzrjjUJpfjfn9Caueupx/jcTv7BIp3z6SBIlOAPTM41JxGltuiSL
         LYuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7B/jEZPrvDCjbzk0NdOmvn16eq+aWuucnmVftgQmoWU=;
        b=ZwBgAr6zX3/x09cxrE8kWY5E3gaK/tcRy2+0dR4oM0suFAzOA3H/D4Q4o1raunqHHe
         lYemwIN22wueZ7qZCLrc6ytJLqG16dobpVYqLoxS3t1fzvTMAnfsQFny2J8owMEGkqO+
         knzd9ktdQ744ZmwRGfi3jSpl6qfLVVpZ700VphHfYXOpH9qjQWDWFYMRQ+1OnYfircE5
         ZqDFUNJxcJ1GLh9pclssxHh/KJp7FG7ltrzNsAfOxloW8Fuj8s8rA47gn8Zq08rdA6Z4
         K0xzUtNOD5ZocQHxzDyFG+KcOa6AcGyO5/yhBHVdiToic8dnRud7CX0q3u6CZ62F2QGZ
         5hAg==
X-Gm-Message-State: APjAAAUZ1fjPuXBJy8e/2tYs7A6iNAS8wgawO35rcq85pbv4fBtFeuMg
        PkG894j2M1ht+zjorU98qdg=
X-Google-Smtp-Source: APXvYqwupZ34DOXx2bxViTGhcjvAcNKFhWNfIB6b8qVzulo7IFV9a3nG8ILDui5oE8/+qpu9gianeQ==
X-Received: by 2002:a17:90a:ba06:: with SMTP id s6mr4753402pjr.69.1567702544056;
        Thu, 05 Sep 2019 09:55:44 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g14sm3120204pfb.150.2019.09.05.09.55.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 09:55:43 -0700 (PDT)
Date:   Thu, 5 Sep 2019 09:55:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/57] 4.14.142-stable review
Message-ID: <20190905165542.GD23158@roeck-us.net>
References: <20190904175301.777414715@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:53:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.142 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
