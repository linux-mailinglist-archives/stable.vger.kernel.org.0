Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB74B90D1
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 15:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfITNlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 09:41:39 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38113 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfITNli (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 09:41:38 -0400
Received: by mail-pl1-f196.google.com with SMTP id w10so3209297plq.5;
        Fri, 20 Sep 2019 06:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4mRpAGaa4LcvbSRRDkHhn9jzI5wKRFTGQvNhLkn8oxQ=;
        b=sruKvL4rJcvxHHqkn6oc5IA47qDfAr9cRo/rvJDpMHw6wlwB7mRXM50O8hZ9xc+10G
         9drCqn2AaKbX2EabYJRYASrYU1UlOLDbCsWqTyChdFapzbpLyQH5quwSs6orC8P4qnBr
         +n82MQq3/O71s0romefmddaLc+KGZzMix0Y1viKHPrh9U46jfPXV3sEE28hcsRhIntO8
         xvqm2+TWljdIxOMI4t4zpl9K7XwPZz3KJV0ZUehAA9ZmFL23bq8nS4TgiP7vjNAKwZtL
         cHCCgFA+szquX58fX71MUUfz3HdsasMpp0wM76nOFg7Wm3AZdqZjUedF2s+RLGaUVmRl
         al4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4mRpAGaa4LcvbSRRDkHhn9jzI5wKRFTGQvNhLkn8oxQ=;
        b=WkoKF2N4YWgY0gLuYZ4F5xPhsjjkyCmcXU6wE6iSDAM3tfKxSoUOfP8ZrZCmCWMcuS
         Up3xFzMO/7fFUPj8S/tFykZsNdn16mzHQr3E06X2ZBdfa4IFY9b0tGSSiTqih3ALJAuT
         m3pDZctbGqU0r/6Glrl20yEG0uxIf+22l7218JlyTh3X7RmcBSCeCVaL9lLP8xTiC78V
         IcLmttwNygAg4ADIp36PuKaGX9oWh7R3eecY3fxw6af4mZ0uTIPCcGCgEssM1028qY0m
         WmPLvkJ+tqbPFuStw3p23m5mlnjCT4Q2XG8HJU2HjgVvtddSvp9JKW20NGf66EkJycCh
         5gBQ==
X-Gm-Message-State: APjAAAVmTVIVl005cymq2Imuj+cUglhu0WS/Fgb7gXdveOOrWaf1IjYB
        ufF0R5P17zgPaARPUJZUazQ=
X-Google-Smtp-Source: APXvYqxtg++D+nmK0c8+qH6jsbE8m+ew1skiCF+c+fihjKFqSy53/jnXwtz2OPenwWpCWATfQHJO3A==
X-Received: by 2002:a17:902:7785:: with SMTP id o5mr17586247pll.30.1568986898227;
        Fri, 20 Sep 2019 06:41:38 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q71sm2441559pjb.26.2019.09.20.06.41.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Sep 2019 06:41:37 -0700 (PDT)
Date:   Fri, 20 Sep 2019 06:41:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/56] 4.4.194-stable review
Message-ID: <20190920134135.GA26460@roeck-us.net>
References: <20190919214742.483643642@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 12:03:41AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.194 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
