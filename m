Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCCA2EB252
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 19:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbhAESRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 13:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbhAESRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 13:17:47 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC8EC061793;
        Tue,  5 Jan 2021 10:17:07 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id d20so588394otl.3;
        Tue, 05 Jan 2021 10:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ffR0jcxOFkGKgVwMPr2X4pdfqNKppH3lIthkRmLCk9k=;
        b=XL9vvoJbOnVMJBMebTJJUN70WEJPupEUq98JT2Mvoy2SezCqHD8B2W+wiQUvZQzvbQ
         UPqHvK1GCbb348uqL2m2MLg6ypOarMqOzPmRSfZyb+OJV9EyKzicbCQxXRUEjYBbfJpR
         dfU6lkwJQh9EtXyFl/g5MkYaMVobhm5ysPGBj7kqhw1y4M8qNapHl+jx5TOTPlQGCKyl
         Q3+fXw3EOcOg46lszEc/InbS3q/EFjfVsFU3IM/6Xdb/1ucSfPZS6iXwDMkIxv8TTzb/
         08gpERqegEUOcoxGuEpmmSJQPwl/IS1i8lru4krJVCBQXZwqOfsaQ9SBNMgArS/nxcpV
         hGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ffR0jcxOFkGKgVwMPr2X4pdfqNKppH3lIthkRmLCk9k=;
        b=eQnBHN5R6u41CHokjjaFaeKefQfDfY7jqGFBF9vEzc3IPWAul/qDDecoR4GXS0Tsg1
         rotSf+/RdC0CMmONNsutSwQTL2zSZmuNgl+FwlnQaxGMvLkivD985cFxnjNsNLMwftpm
         Ox9ffkovIGh5dKnkyuLHxja17d1mjLlYlqIpVmQBU7n8Huhwgd/8v7MOSGmOqYTUBbdp
         VW5LvqwPSB3e2YgXCt77swiJaPODr9WTiErO4v5hyVmNp8d6O1l2M0RCbcTv2MLUXEMT
         c28rm2vzTW9ZvcBcVuhzPyDx6rgqeBlqM8GC40mF80WGMwTarqodurmPKcq4ESU0WkLw
         SGmA==
X-Gm-Message-State: AOAM530DCDfXYJQKmgfzacAQLPxAQgL0ElKSDgloBxVWUxqgS72JkBb/
        pYsgPYkk2tpriRR+ge6algw=
X-Google-Smtp-Source: ABdhPJzl8dvO3OjffyzZUvj4957EeTQhKAIj50qkAt+Qj6yBNRv+AUlqsnMmmKZK5TWjhFTll9MhdA==
X-Received: by 2002:a9d:27ea:: with SMTP id c97mr506705otb.173.1609870626638;
        Tue, 05 Jan 2021 10:17:06 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 59sm60504oti.69.2021.01.05.10.17.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 10:17:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 5 Jan 2021 10:17:04 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/47] 5.4.87-rc1 review
Message-ID: <20210105181704.GB220537@roeck-us.net>
References: <20210104155705.740576914@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 04:56:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.87 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
