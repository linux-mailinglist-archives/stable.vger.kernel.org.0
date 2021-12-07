Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAB846C4C9
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 21:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbhLGUpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 15:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhLGUo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 15:44:59 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C34C061574;
        Tue,  7 Dec 2021 12:41:29 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so418597otu.10;
        Tue, 07 Dec 2021 12:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eBH16aOO9PED+7tw3D6qnA3PdsMfd4o9EAZx4umk5jQ=;
        b=ByIzBwm6UeVp6ca0ZrPJ3n1ndYPW8ngNDdoSRYD1KAatq229ZxdeGOjOQ/p/MJNlQo
         sD4MlyumYtOYrITvNgkdS4ROxt/K/JMGjncGiMuawpulUvH+TnXK2ODpv5/EqrpNpI93
         IGLo7IOBnkgbxkBzjLTRGYNfm6StGrs+4fCzKbZPCt8eX1JEoIxZs85G+H6q8Dk5/kXz
         j7R+3Ol9rxMYf25UjzWhumPm9nF/EL7Z5U026aMMY7+OGFCbRANToUhWMPrqXa1WnbBB
         VGq2GDm270sCgaKujl0CZykSkXzpcrJLw4HsiTXnQ+GGoQ0N+7PLzmRsAyxXmbzvLbuh
         wFVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=eBH16aOO9PED+7tw3D6qnA3PdsMfd4o9EAZx4umk5jQ=;
        b=qoAtWsBMdEfH2FUsWiMToeqqCKx/0axljrt2TPA8du0je2tg3C9uy7q5caK4ZbG1iH
         7bW0cNrBoDDwMwz0rKgi1BXzrC+nz7MhNURFKhaOY8uBFdSm7q4pl4TQDSlr8g+DeiJd
         mlT0jhCBHHW3uXf5eXDprkKOB9U6lNw4iTAArZ6tgJNKUey/MVg87nVhKePfrtFWh7Zs
         dmBLLwImtgI6dsZKIKt4ca3+DVp8GLd666YpaPad69+P6ExeRnl4vOuUnOjRgkK/imd6
         DFWCu/cOUvihLTABJoRsQc3gzYPG9OoMy1xXvTHgn1ahvqkPztN7MUFMoF/d7nnW2HMQ
         cJgg==
X-Gm-Message-State: AOAM533T+2IimC3ciTvsy66gmpZOIMetbKl5pf+6WLzwvScMdzxn11MX
        FlZvKMOoRJGlLK+lSiZhdf7ke7g+nhY=
X-Google-Smtp-Source: ABdhPJxBZWMVVOjTgSyAs/iyHppvfJ8WBTKb2HdMiZgmIHxs7Bc6bVmtfW+cOjrmyqLG9my8f7IzZw==
X-Received: by 2002:a05:6830:3094:: with SMTP id f20mr37994031ots.201.1638909688585;
        Tue, 07 Dec 2021 12:41:28 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g2sm137956oic.35.2021.12.07.12.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 12:41:28 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Dec 2021 12:41:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/70] 5.4.164-rc1 review
Message-ID: <20211207204126.GE2091648@roeck-us.net>
References: <20211206145551.909846023@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 03:56:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.164 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 446 pass: 446 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
