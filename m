Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7B534D99E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 23:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhC2Vel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 17:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbhC2VeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 17:34:21 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336D9C061574;
        Mon, 29 Mar 2021 14:34:21 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so13671637otk.5;
        Mon, 29 Mar 2021 14:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Jqc0nn3C5HN414fbutGkcYIk1w5E8eJToH1/V1xUZiw=;
        b=LR5rZmmwTZCLsRZ4XeHH4V/vaVOf0fQBi2cQxhW1vjnkFHLW7uOh6Y0XpWi6yel8w0
         Y7RzvebOQWaqbh/Bh6EmapGOdISTMqDtxMcYqfz4YgIYERAXB02D5HPOinGMUMGQSUKS
         29Bbc1xxEwQDcz7vsMZKo/iJissAh4Dnap97DD44ReUB8pPSj3Hpplw6t3ZJCjXOcjtl
         JFPgpKdFEEjQ+P/ytyzJtLIUw6HyIUODnQApcj8QgkKtbBExeGQ282a7UXkwK02empMt
         OEDc8G2uFyh+KTLy4jdqlVVw3GXacUq393A+lKUc5Zb2ewEs1pWOHZbcwuWEf7s6H51q
         Z2+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Jqc0nn3C5HN414fbutGkcYIk1w5E8eJToH1/V1xUZiw=;
        b=oa3zZT8RJrvlZc+HWZ2NRjBDbIezdL958dTIRfuGEWDg8+7p/5uaiWgY7OwFOyPJka
         a22DNzNvXWFe0VBFpbJZQ/PpZje+CbSGEOwh/AgFg3dEwHtQxZA4FUSfayElo4mmhZKz
         9mLGKYp5rppHdBKS5jkQCkkZ2vaY2aEiKgSeemZMQunnxdKzWewGIHbq3ASVb6R4Ldm3
         KWF0P4LtR7N41GAX8jplzjPxOOB9TwYpEzV0YBLIadR8Kdr+F4FmExH9CSlFYMNj2yRE
         thmW8FX0UdCwqQykYBV7Mru56krx0g7128HEaBRvbuLIdm34qsFYGRv8pmvUUtsi75H0
         oQ8A==
X-Gm-Message-State: AOAM532GMIa2XfNLaJ3tH1rkjfdspx5CEIjDckXImzS51vEhYJxymhPq
        DtSmmgF4xvZnnpBvcACSUWw=
X-Google-Smtp-Source: ABdhPJweKUZSbAqbyogiTWLgw/9vsMDkShzy5nV5ZlJxWt1Qy7HpBaTcl2TqNqlN/HwYzZ78DL1M5Q==
X-Received: by 2002:a9d:6e87:: with SMTP id a7mr23812499otr.298.1617053660697;
        Mon, 29 Mar 2021 14:34:20 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z14sm3768484oid.12.2021.03.29.14.34.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 14:34:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 29 Mar 2021 14:34:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/219] 5.10.27-rc2 review
Message-ID: <20210329213419.GF220164@roeck-us.net>
References: <20210329101340.196712908@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329101340.196712908@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 12:14:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.27 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 10:13:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 452 pass: 452 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
