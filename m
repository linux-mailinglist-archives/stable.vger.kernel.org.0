Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B02814922F
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 00:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbgAXXzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 18:55:40 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:40753 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729367AbgAXXzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 18:55:40 -0500
Received: by mail-yw1-f68.google.com with SMTP id i126so1730150ywe.7;
        Fri, 24 Jan 2020 15:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nmXVBHsSAuKA0DE5h+zeILqyd9fbsx8jPseIz3t7Z8g=;
        b=VzR7w1sv2SYfIc3B2dX+w8+vt+Z2ZUofzJ7BytwZ8u+BkJcrpHR97wEtYRyymO66bS
         W8DJYA5HmnUZ6V9k3gC2YYj24jUQpRYUYRdFyFqKm4g3P6aUXTOdHFXYZ+F6+HnKGley
         3wvwKscnMpqmSd779avTIgBUYjdwbQodlxzxLiAwJkmPPRTLaiQrjSLMgqpjx7PGgF2F
         8BpEP91Pdm/I5OI4UdzHg07he+4keVTxcc7LbY7nS5Xw74M6JG+RvwYZVBvD2PygCGDJ
         f3RMjkHXz03/94ZIrwaFq7ByLrtNdZGv11joyKZgcrk5DHDEBnoYC6GzWykDr3HNsT/Y
         gCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=nmXVBHsSAuKA0DE5h+zeILqyd9fbsx8jPseIz3t7Z8g=;
        b=cOMGQhJV5gEoxabTDTfT/LzOacOjIdT5jur4PZRtp776Fapz4sNmhiBsxQ0AVqNaoP
         hjjFUoC/xFrxhx/xbkLuoY9iABnGgasNb+iep+shawgYj1JChQA1aw+BSYdJrhNaY2cY
         QW8AOJ/fFs09BIJKOkmxYALuYYOeFf78ju0PybHJ6EzuOkSgkMln2CfOfdnJLtpJa+by
         US+Z3dBl//Cc5Fbn9DtABMEZ2u1aVUMey0nb05vUHMLspq6TPl9DtXvK64GsGBZbNXam
         tD+uuduWICdAYUTCivjUQbnBtxz6CPGmFpuJvv23QldaRO2IyUn0nmMKOfDHKBRke3lv
         pnwA==
X-Gm-Message-State: APjAAAUnLVlxk00zCnHN0thrjdrIz8EPCGN6lfhzZXD7UrDUN2er3ZYe
        0/ieGNCNbkYAnx4yraxmERN0tr2G
X-Google-Smtp-Source: APXvYqwTj+Ws6ROgb0ZnxsDBY78Rm/tt9aXG+GpIOFb4SKVrMw3f8QS6xpYpfffdzm5Hdcwqo1mNEw==
X-Received: by 2002:a81:4844:: with SMTP id v65mr4331080ywa.23.1579910139168;
        Fri, 24 Jan 2020 15:55:39 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h23sm2967478ywc.105.2020.01.24.15.55.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 Jan 2020 15:55:38 -0800 (PST)
Date:   Fri, 24 Jan 2020 15:55:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
Message-ID: <20200124235537.GB3467@roeck-us.net>
References: <20200124093047.008739095@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 10:22:50AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.99 release.
> There are 639 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
> Anything received after that time might be too late.
> 

For v4.19.98-638-g24832ad2c623:

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Guenter
