Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96BDA4A719
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 18:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfFRQhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 12:37:21 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36102 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729327AbfFRQhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 12:37:20 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so7980697pfl.3;
        Tue, 18 Jun 2019 09:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LoZXdKl2ZPQX9tqpcBDQyfYSEa9pJ4C8X2I1zGq15V4=;
        b=Ui9bGCqOBdwv8kLPjHSIH7yYQe5FoY7pnWfjoUKdvr8O+u58Mv+FowTaxBoZRx0KxP
         h7rWuystssbE5iwW+ygcjmk0A5+UoTiIChXynqvAvdQF5j8jruff4mdiq+A8S0dNStD+
         kSkT3zpcnP4gamU/ELgJvEEQvoRN+pdGLNORqsOQ7RVj0lfJFznyj0gFn3qW14QKXq30
         nVICTxHO1zihccN/diiform61TRhhdEFXd/hdOfdWUwPJFuutY/13K4XOf3u2WCoR8g7
         +BCO3v+88xMB9IKDmePgjR3FzvBjC+K9cyFueeXWTztD1pMat/sMUC7JD5nT4n1WBjDS
         H75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=LoZXdKl2ZPQX9tqpcBDQyfYSEa9pJ4C8X2I1zGq15V4=;
        b=kK1VEps0xGZ/hBeJeJd9hOshMZQeLzrQJeioA2ESGWjiJXYW+Cj5izjGMiRjOBDPhx
         7btUQMALoJ7w+yW3uKrxsI4oS1dziV7mxj1hEVt3LxkT+LksIC/SxQ09cHCb/+kfVkZC
         3EYJMKQt4hH0FSzStoeROC4535P4s4y8TGoabb0nX880YEszMz0T80SJTW4uutJhCSEP
         GBz8r1avjq8jjH6MpmWkQehMaGJ6er0M9rzmSGSjHNxbBU0dQ4n6iFCXYEQ9NRB1vcKy
         3V5D7gvHRUGtq4fim8gFmjtXoWWQkAm85Sr4l+VV8va//b6fRnbyX9PcIOIsS/2WwGpH
         Ngjg==
X-Gm-Message-State: APjAAAWePy3YGOZLkdP3RqnVr6PWusy5qpYjA3argLpLYi63wMd43KWh
        KwDrdWAwue/AybG0bRM0srY=
X-Google-Smtp-Source: APXvYqwdJX5B3ykM7QtH1dueV+gmYd0gbAfeNw5ni5qEZHHTY+l1CL51AyBpLWfMv7VCzj8u9OgCEg==
X-Received: by 2002:a62:e511:: with SMTP id n17mr111127105pff.181.1560875840335;
        Tue, 18 Jun 2019 09:37:20 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 30sm5170171pjk.17.2019.06.18.09.37.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 09:37:19 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:37:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/53] 4.14.128-stable review
Message-ID: <20190618163718.GA1718@roeck-us.net>
References: <20190617210745.104187490@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 11:09:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.128 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 348 pass: 348 fail: 0

Guenter
