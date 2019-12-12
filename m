Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C132611D56A
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 19:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbfLLSZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 13:25:22 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36847 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730343AbfLLSZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 13:25:19 -0500
Received: by mail-pf1-f195.google.com with SMTP id x184so1207622pfb.3;
        Thu, 12 Dec 2019 10:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hhwDWcIgdctr3rjiuUu6kq62PV3/oAVNTk2uLpC4Kc4=;
        b=B1awoG3mwdqyhy4ufoMsUYOIyi4u54v8RcyuEKxhLAGmLPPta5wpKDiMY+7LlAvFAi
         leqyMWOkDXylvJoP69M/1PiGv2kfB3/i56Nrs5mgD8813xGMpv674Btb5vxQ28PTyEWd
         1i0pNQ3RasQOw+ptHIwGfVDDCpWncDHCoPg2iqkT+vNftrZjczjel3/a58G8WxjzF1sr
         ZsGHD9AwYC8PahIup/tzi67/37NG/rAJPvC1GkyfwQcZdKr+x2QLuyoPZ4U2fOAddA/z
         BzYqadxuLVrCqW9zNJ1LNXy0KKrt6J39uEaYr+WliaMC9vNke3FqswL100G6fnXzyGk1
         xWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hhwDWcIgdctr3rjiuUu6kq62PV3/oAVNTk2uLpC4Kc4=;
        b=SrfKprDxyYBeRNR+rxCMNlVbpCqjpb/6RkIsx/GC9r+lHtgJsHF4PlqUngD3pQU//a
         Oek8il5QGXFPnWp6Y0HKKc2A/AQIQlYC5p37sz39V/wBlhXMHg8yrAAs/HVW3yXxT2J6
         x1N+A65mA3H6UTfi3mdNX4i38MoJsaBJlNWhBYXhtNsjYgSWe+IfydsTQNgG9foInvJF
         QyIxvnLfi8N2yfML5rfxDktDqRoIeubXoEIPmkdHpCDnaZHBeqyDPnVwvr2OOM/21AGF
         8ft39hm5Kpy4ZRb0nf3yGCBNA2EHJ1wbI6sbvgfszj8MQ9506oQldfLQ8BrW/kjSQnVp
         GW8Q==
X-Gm-Message-State: APjAAAUru07xluiJp+I65xDQP3x97aQm4HCq8eTk9OMUzyMcWfhWdyzr
        scKWDasy63w9qPlW/CTMeX0pYipe
X-Google-Smtp-Source: APXvYqyEIStgF8cSp4NVbFsrC5Ygeh5nFUBdBIsQMWBTfhKAg6n8uTk9V6zbtmmjxTZUJap24kI48w==
X-Received: by 2002:aa7:82c9:: with SMTP id f9mr11437729pfn.168.1576175119295;
        Thu, 12 Dec 2019 10:25:19 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p186sm8004188pfp.56.2019.12.12.10.25.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Dec 2019 10:25:18 -0800 (PST)
Date:   Thu, 12 Dec 2019 10:25:18 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/92] 5.4.3-stable review
Message-ID: <20191212182518.GC26863@roeck-us.net>
References: <20191211150221.977775294@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 04:04:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.3 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
> 

For v5.4.2-102-g2d52a20a4c40:

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Guenter
