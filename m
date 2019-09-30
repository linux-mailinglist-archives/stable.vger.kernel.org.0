Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1CDC2859
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 23:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbfI3VMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 17:12:40 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39523 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3VMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 17:12:40 -0400
Received: by mail-qt1-f194.google.com with SMTP id n7so18909836qtb.6;
        Mon, 30 Sep 2019 14:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ggkj4UPTjC/OAa05ryIbgY4jWP/2oS605APpq+Z8rs8=;
        b=gteQl+dVBPchhw/Dv3Oh4U115N/iT5KSkQMlSKDvoVZ13t7ZoHBMbJyrwkzgLS3qwk
         /gMjF93yuhx38n2nj5cfMNA1dGayTKt2udOTJFtzQWxRzN1KiEs76rqPhDn/jL4K7SsC
         LarHKU8MhKEAth55Es5qRfjfusC95bZ69eCD7iud/BJyEjLbd1lY3mbnvuQk73lsGf57
         ZQnDk7XtB0Q95EIF6gMBuLXaEFc17cyqpQtI8Je9Ze0gBXT4f/T/SId8zdKzMVgVnqZ2
         vGPbw2wJzXOeAMt6v36OxCc2tFatS2ripA7nZY/84sr2I1YIGbeFVVqz+Wzn5rNCck0R
         jc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ggkj4UPTjC/OAa05ryIbgY4jWP/2oS605APpq+Z8rs8=;
        b=Co69ioqbZwNWrSmB1O/y3NqXZib5GHbxXXm3tZGH7c6RLKOd7kdQaLooSb4qQlSAqz
         guN1ITBP+p/AtaT6bWPp6HmMGEi2/i8QolaF41WJlQLKkgQ/stmdz7iLeORRbZdlEcbY
         shyVxSlaFKT+8amE5PFS4DM3nlCeFOihInxd0wPS0PPBdqjlvuhZhEX62XGaq2HzWl3/
         TF+usnwbYwdFyG0j2BgVfgedy0+nPgwpe6K2/WCVT5YOjAfgsjuPa18aIfO5k+ZsjTJn
         4dZ1/ZxhXYjOBljuew/IvNBI/w3coT4wrtgndqIBDqwQINZ4hSA9QJQqipnRgqzaRyqM
         3GQw==
X-Gm-Message-State: APjAAAWCQgaNwOydO3akQefXis/fWOiLCnY+87GS9jMIYXdDi4+nZXmu
        qHBmoaenswlfVwCQ45OblTx5aCux
X-Google-Smtp-Source: APXvYqyFKyt2A44FViBd+1yTlDIB7kXRU3nUGEXQNKVfgNwsO/QAXlQT8LMDYvPebIrYvvsGGOLBEA==
X-Received: by 2002:a65:5802:: with SMTP id g2mr20020028pgr.333.1569868255622;
        Mon, 30 Sep 2019 11:30:55 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s3sm193931pjq.32.2019.09.30.11.30.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Sep 2019 11:30:55 -0700 (PDT)
Date:   Mon, 30 Sep 2019 11:30:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/63] 4.19.76-stable review
Message-ID: <20190930183054.GD22096@roeck-us.net>
References: <20190929135031.382429403@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 03:53:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.76 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
