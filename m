Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1E07541C
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 18:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbfGYQdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 12:33:31 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38659 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729288AbfGYQdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 12:33:31 -0400
Received: by mail-pl1-f194.google.com with SMTP id az7so23600636plb.5;
        Thu, 25 Jul 2019 09:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=fWyae0jUTAF4x+yTTmMwdWy55jpYm4id2Z4h6uyhbMw=;
        b=SpsO+BbYEdwHYVZc1i1GI0ksxX4pfVrpjDdQeO48qo7O6BqqcIX3kL5Xv82/T4iVKf
         llk2JqaPSRzpRSq9B5f1m9rlkqvn7P+vQKDzqVY5NjxB6EQpZw9sb688ZS9gT8HxyhbF
         VJSDabUUafSGREfR+QYuAbgtV8Ytwdp1uj00YiXnS68yM23MDB7Zrb32ks+0w2P6deeT
         T1z8hwv2pLvcJH32nrSzBteRvXUwsTtqhu+MNH6qT9NJwpnVdBJ7tfZawJYyRbmGU1Yc
         Q0aZOzqnnr441ytU4wiMSrK9pwKotd80ibMjxm+DmmXUyFTf0OZ1v/5iab1Q7Qx5MRQd
         kkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=fWyae0jUTAF4x+yTTmMwdWy55jpYm4id2Z4h6uyhbMw=;
        b=YQt1FIy8z9WvgHDPu/IU1fXPlGqNse7ouX1jRHYlPH+tI4r8vAiz+GdO94chjXbZzl
         XDmyPoMWGlKoDKx8R8cqLsHLFBhMs7kLuAP5kAidlashj8j6o5RIZv1aiu2Ho2yrNcAt
         pDGjyGJ5R7vXjlo6SvJHxAUwyguNvpab78FhDHC0wft7cSNHcCTkdW+WcgKKkCs3xQnj
         yaAHo3PX07UflvjK0mUL9U6Z7A7OulMKcwOd1CZwQ8rABVSSmTc8kS9MiWG9wwZ8kZDc
         aKa/hQdQkwNtzzvWPSOxbaMqpFHdT4uyiF5kPiguEAJIcO4tAmjqo8vmqL/Dc+1CAlI+
         1IEw==
X-Gm-Message-State: APjAAAWojnlYmwNSCHlR8LQFlJBIG7zw0XOVpDjMjmdZc2GQUpVy4sjL
        bQtFz+t0RI+rCO7rBxI60+g=
X-Google-Smtp-Source: APXvYqzfVcMfDfERWDYvingdE+UxhlPApARaZyeBgAP9HeQ2JtHcCTKSSqpBq3wc0/MYmFpHeluJ7w==
X-Received: by 2002:a17:902:ac85:: with SMTP id h5mr92835129plr.198.1564072410911;
        Thu, 25 Jul 2019 09:33:30 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e189sm25305383pgc.15.2019.07.25.09.33.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 09:33:29 -0700 (PDT)
Date:   Thu, 25 Jul 2019 09:33:29 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/371] 5.1.20-stable review
Message-ID: <20190725163329.GA11220@roeck-us.net>
References: <20190724191724.382593077@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 09:15:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.20 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
> 

Building powerpc:defconfig ... failed
Building powerpc:allmodconfig ... failed

arch/powerpc/kernel/prom_init.c: In function ‘early_cmdline_parse’:
arch/powerpc/kernel/prom_init.c:689:8: error: implicit declaration of function ‘prom_strstr’

plus several qemu tests failing to build for the same reason.

Guenter
