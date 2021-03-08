Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1269F331A2B
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 23:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhCHW3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 17:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhCHW3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 17:29:12 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10355C06174A;
        Mon,  8 Mar 2021 14:29:12 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id r24so2763151otp.12;
        Mon, 08 Mar 2021 14:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AP7lZqQU8S6DZ5kxmozYbFAu8agMMHz3nu2SKQ9+NrQ=;
        b=kgOf0tDD9hyQ9VihPch84MXLW1c1cFDd9IhepIjQieSkLiE/csGSYTOQLCcUq0zg46
         7TXUjCtAgBUSWsh1pIaS/duUBkKyTQdtB1AqmEWR/yX8RGgpukLx0njyLa6QRgvyTrBw
         J4e78pqb4OKu8Rh89wFzWZ+yen0VAp+vI/SU74k3BGHXtRtbkT3BWj2fHxEjpET6g7C9
         U5Zcz3FJXg4yZBG+UsC7DDS364CpuL19Q9RYVB8rmOQhr/t7bcBRRVPKFSU4fCDshnZy
         KnnHe4Js0XBghhws0PSmR/hFCgebhj7yD73JlET6514O+OlPrn2y5aNX0WN3CD2Ei6TD
         5jAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=AP7lZqQU8S6DZ5kxmozYbFAu8agMMHz3nu2SKQ9+NrQ=;
        b=iXU4BuzV5yKTEvJ7vtzsqOZ8+Gi9TENIKEDultv3hQveXuVTQeOOUJBr8bB8Y2z+e5
         7c3Hny5/W5d/LHD6WCmzGEld3BJV+k3YhG28MDSdIfHhOnsFt0fL1L+HVGHFNDFW54ro
         8xNN6i7xS3fLaWvmaAT0SHWZJX1sRty/HcIY17E/O54wGYHwDyXl5Afp2nsWx4adAgHN
         RU+dSwOzvxxktJ9GYxUOZAImQR1zTtkGZoTYgMsVcHGafGVdMc7I7OwNGlsSw/y/i4jx
         vi5N6qtOJvw+0lYBWBOTqTxzi/LWqWZsnvfC/ranCzV2GbNBvQshtDp73UAI6aq9YtxL
         rXXg==
X-Gm-Message-State: AOAM530cawJWL4mlCcdcMrQy3UbUNzxLZlmdDLPy1knO5Veiu0L9ygZ5
        mOaoW1oG4rHnsfUzcBz0Rb8=
X-Google-Smtp-Source: ABdhPJwR84GkMTQ31wGQWURPM3SuN1uhWalcQUd1itEmG5JBpVve7XRayIhXCfqwek3Xbo6RLiNubw==
X-Received: by 2002:aca:d442:: with SMTP id l63mr799589oig.49.1615242551538;
        Mon, 08 Mar 2021 14:29:11 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 7sm2979205otd.46.2021.03.08.14.29.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Mar 2021 14:29:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 8 Mar 2021 14:29:09 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/22] 5.4.104-rc1 review
Message-ID: <20210308222909.GA185990@roeck-us.net>
References: <20210308122714.391917404@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 01:30:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.104 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 429 pass: 429 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
