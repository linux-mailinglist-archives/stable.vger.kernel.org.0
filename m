Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1CB6D621
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 22:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfGRU6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 16:58:21 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36625 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfGRU6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 16:58:21 -0400
Received: by mail-io1-f68.google.com with SMTP id o9so53968178iom.3;
        Thu, 18 Jul 2019 13:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3zp4RNANaMTZ10GeeEola9FIkkSB+bIwHK5UlG2BuIE=;
        b=nljsxTTOx7ajpb6mdjSH46UDVHARoGLgpZbs9Opvccyfg4B79oyiNKtCsLcTB+rB2c
         mPRrhLcIIbZj0x7BGIpI5q+mkgp6gDtNPaFHqE3E9OiC50UzoYBoyYq/C8sz3nMSkONE
         5LWs+J9Om8dcLLOIRUTSEqcacvKx5j3gDTLcBNWiT28neKJWfIF3cvEYfH1PDX4n4j93
         8GH+DKJuBhGzlgUXT92Gp2tyowLctKSt9jBg1gvGqxSQtE7cWTqOIY0vWLTkUqPa3EhX
         XUcXYmOTc0+FJTvevZNED8XwK3B2kSb719a4NlTtUfu8WRPSHPgHMiLRd770omG3vK2n
         QcvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3zp4RNANaMTZ10GeeEola9FIkkSB+bIwHK5UlG2BuIE=;
        b=ogaBw1Q/i0wNB6578Iuo7mt3/eLJmRbfiZIwj3GRiWUnQFEM6DgUBWJifbtU7ybsl2
         Zie33+T7BBmLJFy+FU4Kc/cytaoB8LXq49vrzKxaYG0+ds9P4c5/3bv+9klsW15MGgCz
         rzBq9r7PdggeKQr59hLTzVgPmiUZCtizwpGV34OwQj22Br9oLl0emq4ZJP4gOL6dHD3A
         enqvzmsanEoumg8nnMRcVhxRNQ4pRnxLdIRpZ+EQheZSeHNgFJTEP8Q9gIpG7aoSBwT4
         liV4ZS2l3i+u+qt+XyfueNVUD46uDVgv+a6cchJDbkNE6WaPAU/bNqZjdS9IbjsIC8yh
         JAXw==
X-Gm-Message-State: APjAAAX6rT5TkvFDhGL2n76/56JIR60Vd1jTOHtf5X4ESsZZ9hkKbclI
        zfHPK+f9S0/fSB5IQPj4TgMM6dUC5I4Wew==
X-Google-Smtp-Source: APXvYqwX54KtQByhwo7fYzNQ2/vsdG9wsyh1ixfK/TuSUEIygTjLztMtI5g5BVGsMQDHAg5wX/BAEQ==
X-Received: by 2002:a02:5a02:: with SMTP id v2mr49637067jaa.124.1563483500505;
        Thu, 18 Jul 2019 13:58:20 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id y5sm31010248ioc.86.2019.07.18.13.58.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 13:58:19 -0700 (PDT)
Date:   Thu, 18 Jul 2019 14:58:18 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/21] 5.2.2-stable review
Message-ID: <20190718205818.GF6020@JATN>
References: <20190718030030.456918453@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:01:18PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted with no regressions on my system.

-Kelsey
 
