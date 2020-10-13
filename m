Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7BF28D272
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 18:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgJMQle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 12:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbgJMQle (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 12:41:34 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9866C0613D0;
        Tue, 13 Oct 2020 09:41:33 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id d28so645405ote.1;
        Tue, 13 Oct 2020 09:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uVnUPjf6UDmTMbA38iBDaXkpX5nU/iLbKZkL+pZkbSo=;
        b=DGPzH955WfvrbjYpMZJQQ9Sh+IRT0DFvjHx0nwOjGnneTww+kdMz/YK3xquauVJ75V
         kQoQTBQzAxbclWAZa7G5owTYu9xBtemGN9HNvNL79gPrRy+TtPQgzEpSCeN3h2kDM7X9
         vNxaINGCrW075YJ6npbfq+ICm1HB6a5PrPCnBBpp6JH0wLpUBE0R4OXhTM49X533/S7s
         vbMctZg7M3P1rS3AY1qhwoBuBvN4hioVQafd/ct80Z1xCb3+lB1IZUfc119rc/S+VmEw
         qu7MWjQLAvUSzdQgMsmnMvEoZ2U71Q2QEADAYZyv+x0z2fcWvlpXjRjz9P/v0KsD5MT7
         Ukhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=uVnUPjf6UDmTMbA38iBDaXkpX5nU/iLbKZkL+pZkbSo=;
        b=d/xjvWT0M0Ofroe4dBUZ8oxKo7KhWRSAegI0zJx2b1Tl++571fOgykudXft1HdJWug
         hXaAbzbXP0lSWMfDMivYOiyHZ5b55GPrlbT3/m6jDcFQKHF8TGsR3i5jVsBBS2RCnPIA
         5kt3raviWBW2FCutddeVyBJrFB2CB2CQ7tX6RQC6Vc6Xho6Lc+KkTPRihdqS4+VzMqd+
         2B9VS3YlUbdOl55c9edZTjl8GrwvAlmtP/tobPA/3tL1wmhVfE8fniGxEWDPBDPR03Do
         99B0DCUyZuWQskbdNrZdhYM2IPKWo+JFeXsZCyz/Y0otcxFU1iADfzLBECwpQk7fNxwn
         G4VA==
X-Gm-Message-State: AOAM533QC4sDkcRUiD4dM9Wwx9U6b3kjswVgo0guBtjzZBZJKO8kPh2q
        1rWHPuf5NxoK2/Ma7ClaC+w=
X-Google-Smtp-Source: ABdhPJyUOkIsnlqvZpr++AbjzCP5gpYyDLtSnDslaGlmwJrQhbVWp4TKTyBMSgNWxoa+1ZpZaS8gvQ==
X-Received: by 2002:a05:6830:14d0:: with SMTP id t16mr364219otq.362.1602607293355;
        Tue, 13 Oct 2020 09:41:33 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c18sm95590oib.34.2020.10.13.09.41.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Oct 2020 09:41:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 13 Oct 2020 09:41:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/124] 5.8.15-rc1 review
Message-ID: <20201013164131.GF251780@roeck-us.net>
References: <20201012133146.834528783@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 03:30:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.15 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:31:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
