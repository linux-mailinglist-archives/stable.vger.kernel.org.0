Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32C935A7B7
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbhDIUOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbhDIUOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:14:41 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57879C061762;
        Fri,  9 Apr 2021 13:14:25 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id h2-20020a4ad7420000b02901e5901169a5so1387374oot.8;
        Fri, 09 Apr 2021 13:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/djKXlGqeV6MxNUVwQCJx/Y+UJFxUxkJAER0F3LZi9Y=;
        b=DJW/ykH9+WOBMho5FnbvneqjFTsgZh50IdTkW4vM8FtW7OV2eHm6CSm55noe+BXeig
         a9OOED0rCkRm5y2dlJgoftrH1+U5wYAs720m4fMSlR3RvX2GcDIjg4oZfY4iWnA50YUR
         7Wc7eGDjfxDfkNaN/79SC4FC7VCmFKn4t4bp6fQj7lhBzqxuHx9eNcFh1wWW79TGOF3d
         3C7Ie/5uiSNe+4r0fqVQYcXQEiICzeCI5/WTr7Lb7wn2rIi0cAIgITdxS4JqY+EhSX4z
         qDWxX+Cp/179Jf4aaSm0C1qLxqzYzY729+JZt3WXb4zfTi42EKbg3kRwTcKhUqZd0Zlw
         4i+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=/djKXlGqeV6MxNUVwQCJx/Y+UJFxUxkJAER0F3LZi9Y=;
        b=GqccCzUiza91fQo4tSnDKBCIR0Kr5wRrz9kDZyoEXQviILDjjhcoDAvwUuPBBYm08a
         KMF3isCSM8WHFEAAR9LauGXTgj5tM2K6F0OUn2ytJmQ2jh6Tg/y2pYjCKZfdEErb5pWi
         lixaiSu27myXeQ6VWqHz4ec9wF9AeRmwhUWiN0OYqUXUwqxEYH38QjgSG15NEfW/MNEZ
         ONCFvk2nd0Kux/IFSofPOqXzNKP79SChyZH1kPEsN5HgQeltn095N9rSgCEYW7d7oBhX
         ZXeL+KfXsORah1minfQybcBTG7YLU6IOUo6jXJqhw/BeAqX4Xqp3z6iisK969J+ZsSTo
         MDrQ==
X-Gm-Message-State: AOAM533rgZmLqO9RXTi1dpfhSdpxWr80ds2yrYucSzS9HEl6tbZ/XoBd
        l7pAfdeRuyb0cLfPsHFjOCdRfY1dFns=
X-Google-Smtp-Source: ABdhPJx+DlQQ2szJDr8cLVe15DpXGJnUUCJEngIbMiK431eip/kCsiirHVXfck2TuhqjweSuKgWodg==
X-Received: by 2002:a4a:b085:: with SMTP id k5mr1021734oon.20.1617999264783;
        Fri, 09 Apr 2021 13:14:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u23sm696884oof.17.2021.04.09.13.14.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Apr 2021 13:14:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 9 Apr 2021 13:14:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/41] 5.10.29-rc1 review
Message-ID: <20210409201423.GF227412@roeck-us.net>
References: <20210409095304.818847860@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 11:53:22AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.29 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 454 pass: 454 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
