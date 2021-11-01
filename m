Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535E044242D
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 00:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhKAXju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 19:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhKAXjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 19:39:49 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0321DC061714;
        Mon,  1 Nov 2021 16:37:16 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id g125so27317417oif.9;
        Mon, 01 Nov 2021 16:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fweaWFBcgA8o1Xsio8zIWfnp4OpIkpGjJ/EQf4nRnLw=;
        b=Tk93+zEuaJq0Cb3WxHfkSQs7pMnWVC86RCxFx9FOx370IqwiVsqdjMJRG7QwrRoLhl
         OGkL7RxQdBIQJJCRlZlP0i+eOzDLZDr+2wpcIhJZIopfmwxtc5QH/03mDS46BsUKT40Z
         kY3N3f6PDmfflUOji1zGPaLg3Hx/freX/iBI2q/ndKgiyKcb9ZXBHMi/KvUZl9cFQkEJ
         d1vKX/PL8LVgn20Wq1mEg7wpNvqCvTGSbWjYDnf78AB+xA/d46aQiGvhUcBLeAZ7KVjx
         BGnx/Do6gTTt4LVHzGCyghGAe0G1O/6zF6jrZcpcljtnJKL83P1EnmanlE+F9EjIbQSF
         v25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=fweaWFBcgA8o1Xsio8zIWfnp4OpIkpGjJ/EQf4nRnLw=;
        b=dJM0TM9CQp5wBnalxhArwxxViWE9xMLsnh2w/GtZs4eL5hSurGLCylVmP6ekBhg6UA
         YpjRTzINmB/tdXppnW6ETC5BHuWyZT7NRyjr21xX0ibCCOVmeH6VQ74IBQ/3ONfgWGha
         g5nsStaErUgW5Zjn3Mc9HH5Gf260W2Zgksjg1j/yOQ3T0E7BTnW0eThNf8FF3UImjhm5
         eVY5cFHOTh+3G29Db8kiHMp76RGyr7E6GoFU6Aens7ot7XfiqwLm/dQUXoU8G9Z7OVZP
         bXdo9pc3MXwbGX4vImlh7sC8/FCD0hnJOFEGlTLZVQ+RxVwaDjHT0+1qatCQkoNvZz1a
         H4bw==
X-Gm-Message-State: AOAM530AXYLagyV64CGsMNpXBiyislY3OuBj+8Ik5EKrTYUfA+AZFdEw
        l03T1+0hTPRbNQ4G42cqDoM=
X-Google-Smtp-Source: ABdhPJxEjREarbx2NLPfZ27OsYC3v9Jy7WrBwvCoeN2CAWdUHiRnaqj7prx50U6otBuD92dQHagTUA==
X-Received: by 2002:aca:1c0c:: with SMTP id c12mr1948145oic.58.1635809835475;
        Mon, 01 Nov 2021 16:37:15 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c38sm873798otu.52.2021.11.01.16.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 16:36:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 1 Nov 2021 16:36:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/35] 4.19.215-rc2 review
Message-ID: <20211101233650.GD415203@roeck-us.net>
References: <20211101114224.924071362@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101114224.924071362@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 12:43:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.215 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 11:41:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
