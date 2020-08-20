Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178AE24C685
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgHTUEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgHTUEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:04:49 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504F2C061385;
        Thu, 20 Aug 2020 13:04:49 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 17so1570498pfw.9;
        Thu, 20 Aug 2020 13:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kUGE7TQ9uOCSiNLwnxswm+9FeOqxb2CHpP7RyQnTg8s=;
        b=IDdj+Z9zj5sNQEDp8q/L8I1d5b9W7Px8ESwPCdc+IjN3z4je6FXibxamBLlT81YfFh
         CqNguj4lJoulQ7TxpfQdmBdBhGVkRSFwcdaO5bsgKMb0K+Fx5lBxD9VACYg7Ou2Nkztx
         69jBeLwzzkBWY/J1fPYfZtoEmyLlvSAdZVTaICVSu1hjRDzxP2ZBBLnTmgKd720C5H/g
         xWBYMWa5DysuX5G967pC3CbkQARAxkQrcMq4EyWnJ1gPU9ud2Qr+qU9kNKU5bAC4Uer9
         e+TZxQjuV2pLTkXG3BOlF/buTsk4/lgwHC3XJuK36KVxfhv+f8j6QNrqgiwA2f59Nje+
         oqFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=kUGE7TQ9uOCSiNLwnxswm+9FeOqxb2CHpP7RyQnTg8s=;
        b=fbmwxoWh9LcJheY+rDBYFsMN3OzIEF1KW6H+muykTgnxfqPzIqKepkDJj624bKqPzL
         pe74ARSfYmPesR+J1FVXNgrzCC4+on2EwfrRXxMobZKB9ClVVfayu6BA1yO/g+L790Nc
         N/LFmn7bOaZdxoOCzczupgogwvVwvZpAO8UI1Xq57IpOKSH8JgPgnFxIxix4eF44aXMJ
         6UsvVIQiyuiL5JvoaMdDygpPXxgucg17psry5cTa7tYHAQs/UYB5Ll7Mrjq17u6tUc8a
         t8CGQXNLZ+a807NpiuuABIzJCEF1elieCPF7ta2sfAgc8CLPX7g2FH4kOaHM1lVDZA/6
         La6w==
X-Gm-Message-State: AOAM533BZdDx3eycBwjl5JuLoqcBj88kAlCFfuAcHbA5EsyKWI4rXL9A
        ylc9l3wUMOOaiTtrYHj1plgvnQ9NjrM=
X-Google-Smtp-Source: ABdhPJxzctyzq9dbDvLL05HvgIMQ59hdr4KldPbkEtBvitW8+aorx63QNjPx9cUlzb5i6IwaXAfwLQ==
X-Received: by 2002:a63:7e5b:: with SMTP id o27mr307979pgn.38.1597953888894;
        Thu, 20 Aug 2020 13:04:48 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gm9sm2914695pjb.12.2020.08.20.13.04.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Aug 2020 13:04:48 -0700 (PDT)
Date:   Thu, 20 Aug 2020 13:04:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/152] 5.4.60-rc1 review
Message-ID: <20200820200447.GE84616@roeck-us.net>
References: <20200820091553.615456912@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:19:27AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.60 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
