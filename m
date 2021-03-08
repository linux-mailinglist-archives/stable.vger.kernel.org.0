Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF048331A2D
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 23:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhCHW35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 17:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhCHW3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 17:29:32 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21796C06174A;
        Mon,  8 Mar 2021 14:29:32 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id v12so10854914ott.10;
        Mon, 08 Mar 2021 14:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yfbW3gZl/NEtnGDOPyXFgJYfVv4XzFzfqoLAh1GRhnk=;
        b=Z2Bd3UX+3N+oGR6xdMGZkDObn0mv/GRnvHIjl4u6AwXIalB9BNRqnJdJjwv948qdu5
         W28nARMzSHqcYFfjEgsDPl3N/mqqsrF7iv0dIndfbW+vI0la96FJ6ioxDwpbW8U1E/XY
         RhB/8xcz5xdQk+6qXFEFQ3VhU7aXxUa6spiZO/lR4WttbCz6ErptzIN8F4QvSO4G56dZ
         ymyZCpTOAF9Buy53fSv6mVNC5RE21fDpF0hD+g6eScDMiVi+NY6zSGecn+w/IYTHpXLp
         oQyo6pnPw3maBrmJVxEAvhoIFxd/1x/DHSSRCZ/Yerj3irunDCkWGg/w70FQhebjtf2M
         MovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=yfbW3gZl/NEtnGDOPyXFgJYfVv4XzFzfqoLAh1GRhnk=;
        b=VL2YYjYFUAmVQjIImC+6VI4cel78AiuQ02skueS7eaHZYmbdgphkJeWMgax1Sy+VqB
         htbxVVPpuR95sxEkJYcKu9CJQPgc3Wyr66EkZ0fxxyNRknfX1O2t3BrtyBkl5sVQnEzZ
         ppv8X3fL6NUSNHI0jEv0fB502xJdjWA4BMnc27I4RC+ITTa5r6sj2NLMGn60pQY+Ap7U
         KXE+FqBNm8LpteUZ/86yNgWkf/E2zh8MSZHVYhISrVW/ebEza3LEDZa7yh+Np5oH+VCu
         bY/Y/SmIyLFhXJ0xLE8xzRc0voxit5ynzjOt89hqy4SWyhy/GfQuuB2wdI9cHW2vmj6T
         MQwg==
X-Gm-Message-State: AOAM530oKO7a74ceQfLX1H3lAoadYi5eHbSJ8eYwoavglZIpiuve5jWT
        ZfrMXaENuq2GwMSpBQJJDA4=
X-Google-Smtp-Source: ABdhPJxUvpsjase80WEV5GsFja4T/VjlfrTZoU8lsTJOj2RdrEtY63Kqaqu7N7LVoXaNyanWO1QRmw==
X-Received: by 2002:a05:6830:4d3:: with SMTP id s19mr21347018otd.355.1615242571513;
        Mon, 08 Mar 2021 14:29:31 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v23sm2016003ots.63.2021.03.08.14.29.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Mar 2021 14:29:31 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 8 Mar 2021 14:29:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/42] 5.10.22-rc1 review
Message-ID: <20210308222929.GB185990@roeck-us.net>
References: <20210308122718.120213856@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 01:30:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.22 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
