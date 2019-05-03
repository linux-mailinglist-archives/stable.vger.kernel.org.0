Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5B3132F9
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 19:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbfECRPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 13:15:34 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44598 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfECRPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 13:15:33 -0400
Received: by mail-pl1-f196.google.com with SMTP id l2so2980454plt.11;
        Fri, 03 May 2019 10:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5HNfIk6EjcWYuLHlRX+K5zGKJ5kkDg1scSL9qhXH644=;
        b=Qr/gy8XMgl0FVwwbSIyQkkfLlI6IU0yaLiqb7NdYTabE5Ye4BbzmX3fvvcRoy/njO6
         3ER6tpByo6Tz3bbbjeEelJfU1vifh85mLoypp0b/exXMhTuvSMBWXKq8SF4h5IKeo40y
         QnP35/T+mnp2A6I45eSeILB7Gj/0CGhtiG2t6Jc0+w51Id8lZxSFBM9R1Kgkheowm6Io
         kgwgOcx93LG502xtMKwi1f9bSXwzE41+/vtfj+4c42D4kLRFHfU0z8DBSPlP0K2CU7v8
         0y0DbI9d8oZO6KktDql/C0X0m/2BjBYQlkEmwobdsYrFBKtb92fciR+gZNXiQoDNHWf6
         R9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=5HNfIk6EjcWYuLHlRX+K5zGKJ5kkDg1scSL9qhXH644=;
        b=cic7e2Y751qtHVqNFuyEU2T3uimYyGaLkJwinhFK1GeWUxeVWBfSvP3bgLZnZ9pnsE
         AMJZFnvh2i6/ZLJwXSPM4uOrruDIXOp4GZSLDWbzuP2RjPLrJzgQPnfPqcAPc8Qw2MgR
         KGkK45C0LSLR6BR1wgZzz0bDtm6zDWWktR2ubRmMrJiO7EPiq8meKphK4LGtXq6yqAEj
         /JzEHi1YoIPfmVTGIWSOel8WddJRsgz0Qgc7YXvFRLU0WrcfxOTzmsZvPPPgYzTJ84Bf
         HxLpYCMSXrADvEE9KTERn7BnX/boOz/OVqQDiW1aHkPjI2jNNw1QFPfW5McoyY7PwuKa
         56Vw==
X-Gm-Message-State: APjAAAX+mlW3nqZIBArZK56ddAcgr07iLtNimvx5lodX14rMLE708xD7
        3PpM+JKZamCGP1CFj0lIrRnOG5m+
X-Google-Smtp-Source: APXvYqwqm9XpPo1qeBeN1I3gmcnCb45yRVEPk2QBPNzuZla3/IIsxdkXl7S110/rLSFFKH2gGTldZw==
X-Received: by 2002:a17:902:b206:: with SMTP id t6mr12000113plr.130.1556903733186;
        Fri, 03 May 2019 10:15:33 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l15sm3223149pgb.71.2019.05.03.10.15.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:15:32 -0700 (PDT)
Date:   Fri, 3 May 2019 10:15:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/32] 4.9.173-stable review
Message-ID: <20190503171531.GA2359@roeck-us.net>
References: <20190502143314.649935114@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502143314.649935114@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 05:20:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.173 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 04 May 2019 02:32:02 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 320 pass: 320 fail: 0

Guenter
