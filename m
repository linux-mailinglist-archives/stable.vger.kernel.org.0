Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFE52E6BFD
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbgL1Wzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729417AbgL1U0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:26:33 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F32CC061793;
        Mon, 28 Dec 2020 12:25:53 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id w124so12611026oia.6;
        Mon, 28 Dec 2020 12:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XYCPkRWSBq42czkNrmn0kx/eT3tmRP8j0M4D4vl+wYM=;
        b=J3hk1Zc6QsAVPV4uMNFcz+JN914H/eR9rQ7+mBMq5F4f3SkKRAkJMXZwslefKcSVjG
         IjhgibNKqGGnIdzKS67v422YAE/FHxmK/ABc7CK5Tov0jfgQTbjzbzizmyhiF131THQq
         8D3fobSje0QhMim3yPJm/MyCmDg1S/D43o5ThXQ9VOXKiP6GFl6ATbcVnJP0U3ld+IBq
         gpIHv64R5IGSoNr7Z40IRCSCHcXpUG3mig0JCjTTi2TX15zQl0Q1gTxgDwQIrMbMx2Q+
         YPkKF6NNAXlWkvwtZgRxlCW4trFTWz21atL0Ami27KKcmIlF4vrh/FJ4yR6PILnx3dDw
         IQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=XYCPkRWSBq42czkNrmn0kx/eT3tmRP8j0M4D4vl+wYM=;
        b=Ja9jSWn4G1+VxUGfXpRnvC4IxTM5rRKT+ZgjneVeDfaKSEWGpABmd7f2K1ZJ8FAVzL
         etMFg3T/fXr3XouEmq+btGy8o+7kHd+yTZr97tnA985mSEqkmRQjj2iDjRkRhhgVwd4Z
         GTkCm4sIq2xwhvnRjNY3tyfBlB8izwTqHLExcRU7BkNPneotq6ryCYOTXulx3GDb2xRJ
         2G4eeu0ScdOyOMLjQHKCeUVul7vuTkqNVZstL8GNy81zf8iVAInPHxdV/c3XoNMKFWgZ
         X2Kjd+UmG1eeNw/5rpxLv689KGV+eAJU7LT/83FemqmKTwVNSVgIV4KzSUGi3Z+CqYyz
         hK7w==
X-Gm-Message-State: AOAM531XoVnFNsgPk/iLc24GdxOF+tR3HfMPn9+1ExV5YHjUP62jmJNt
        fq3LFY741Tzz7hy3URhLm0U=
X-Google-Smtp-Source: ABdhPJx+gH0F4NcGM0rc/A/icts0gIdUXflyKH7juOIwnxwCDAHp1dWK1QkjbFKm0JYmvOrx4gacIw==
X-Received: by 2002:aca:3145:: with SMTP id x66mr420371oix.29.1609187152932;
        Mon, 28 Dec 2020 12:25:52 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 39sm9396371otu.6.2020.12.28.12.25.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Dec 2020 12:25:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 28 Dec 2020 12:25:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/346] 4.19.164-rc1 review
Message-ID: <20201228202551.GD9868@roeck-us.net>
References: <20201228124919.745526410@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 01:45:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.164 release.
> There are 346 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
