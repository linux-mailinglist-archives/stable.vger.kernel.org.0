Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4C175EED
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 08:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfGZGUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 02:20:30 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46845 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfGZGU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 02:20:29 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so102436920iol.13;
        Thu, 25 Jul 2019 23:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kFzQMA0mDROxu3WWjjr+hWMrQnQOlqpH6UFVO6OFrf4=;
        b=pbqij5o//r/okuSVI3ASnyDGovftQwBxFVVHYHDVQ9ZyovzjwpHe7ZEGX3SfThVJcK
         MUGYk0Yu8isC3dPJKx7lzM5eMMhfkZw6x44fqhObkDdm/m/nYNp5QBloGmIXBLha3wNN
         ZMWUmycYgGbLtKnEy45TxSbZLkrb+IZ9joEnxX4w6hhm4q4nHdONIzYWkH7RWzzi6FQe
         VvW4Y7WFbfLQQp1OCyjILDj9+sjJ+koB62ABxjSr5O6IIpHfP8tU0UG87qNu2lxNddgC
         1mqNnEUsxOkveUAoJTu0QaMpuu8A6TcSxcFWyjkmrQWilioxSHOVAaMW2dSJMdrYM9fz
         s3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kFzQMA0mDROxu3WWjjr+hWMrQnQOlqpH6UFVO6OFrf4=;
        b=DQjJfipgl0y+wnKXqVEUCbmkEfX/t5ZYbphr6GMWWL4Zf3/RNPqDypX9RLpd4KmAi+
         zZm9SplgZd+NOnr6JLoz7weubsSD1/bjlRyETC/o4ff7bJoJXU1HIofvRMT15fsDPYV2
         9OfdYQWVqM2n1Etxr1i7KHsThqRBfVLmTbZZzKqrUArpkEsgDeDabZUh8iVKtAVkkkcz
         KqwTFLqIZrraAbGaKt9ilq884iHeViRAFEBICcQY6BvqnhwdBSqSqIUxfGC+dHA9gvQh
         Du7vQKfou9ELU1aqnISxkAVty0pMcbUanwM7oSq+m2wbXQ4ZPKcvtwlyWQCtm9eSY5xY
         lSfQ==
X-Gm-Message-State: APjAAAW9iwSuf+hM07BASQLS8dCTN938mv6o/Arzw6afbwiUu6XGCM7z
        gI1IZTSERkyAfuq/5pfxvQDaK4YVl1OK+g==
X-Google-Smtp-Source: APXvYqxd0gp1Yyi4cwYVIbeJQ8KoObTNpH1N+WwJNjYsLq2kzEaNasa5l8JL9VM1xkYPKs1W/wZMUQ==
X-Received: by 2002:a5e:d615:: with SMTP id w21mr17280975iom.0.1564122028902;
        Thu, 25 Jul 2019 23:20:28 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id i23sm37001593ioj.24.2019.07.25.23.20.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 23:20:28 -0700 (PDT)
Date:   Fri, 26 Jul 2019 00:20:26 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/371] 5.1.20-stable review
Message-ID: <20190726062026.GC4075@JATN>
References: <20190724191724.382593077@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted with no regressions on my system.

Cheers,
Kelsey
 
