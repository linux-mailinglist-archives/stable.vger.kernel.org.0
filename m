Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2644184BC
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 23:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhIYVsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 17:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIYVsc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 17:48:32 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DFEC061570;
        Sat, 25 Sep 2021 14:46:56 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id g62-20020a9d2dc4000000b0054752cfbc59so12763742otb.1;
        Sat, 25 Sep 2021 14:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uNx5dLqg/NbXrSXhidOCW+nWjW1fompaVWxSd9Ll2SM=;
        b=nTUqUJg+l1W5ofh4sO5kzlWxL+o3zHSC/QTwt09O5mABWbpO71oonQ41TgmDQ8bUGz
         Ux9jLBvm2FK0wREXXUkyviNDKA4OLkXVj3KzG3S/obWo4J6c8ly/7blKSht5bkPvvyGD
         zb+kn3ds0Ntfw7P6KWgkB03gmJ07FJwuQbT86EtyYtCOv80NaIGje6cpv3xauVbgZOfj
         bY+6NSlFAWi1srrUQnnDCyKiU4KbG9F79ZzNV7zaBG8VBCCrlGAPNVUslDdZ31JMeglO
         PZrsLzPvQpRbxfG3LCfSPp5Y88JN5mhQNmhsYp/QXT5PEOg+gJ+BBJk4nx7WBJeg1DtZ
         Lybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=uNx5dLqg/NbXrSXhidOCW+nWjW1fompaVWxSd9Ll2SM=;
        b=qZrfbBROAocg0H6wg2cpiD71aqk/ttmZ7fhm7E+o931C3DXWUBHt/4NwAa1qGh7T5k
         +BSpEzCJPogqPumc7Vh0vGMEV6lggIgdYuMfuUnbu0ogClvxmSHW6BZjbjjacioxf406
         0UD05ps0cFhgWYIr49fzkbpsHb1Zl7lSd/VDHfE1uEk7BC7dAnajJfCjyBtqiIdBSfAI
         +GBN4if9owENH0kDncCdJpJiINP/IZ4t6YBd3Dfe7sise2gwklVGiVCduxUmOFFxp1Iu
         8wGoTTbIxKTtKi7L3z54ecAFSLqYFEhnJwyHLzcfQ1DNOR46fYSsE23PJQHEjZmWRG0B
         50zg==
X-Gm-Message-State: AOAM532TLQTTvZMMaEscxbXi+utT0EkqIQvrHbJjGLWW8fd/518Jtzck
        kw2mhCTnZPg9f8jluR1sgwJMAaXCqcM=
X-Google-Smtp-Source: ABdhPJxf5CAnAiuQF1eIAwXh7y6eZFkpn8ZoKg+hQqKoZ1kKo0ASxmruEl+zezTenIcO2YUbUXP8hQ==
X-Received: by 2002:a05:6830:703:: with SMTP id y3mr10912201ots.109.1632606416215;
        Sat, 25 Sep 2021 14:46:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w1sm3025314ote.41.2021.09.25.14.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 14:46:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 25 Sep 2021 14:46:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/22] 4.4.285-rc2 review
Message-ID: <20210925214653.GA563939@roeck-us.net>
References: <20210925120743.574120997@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925120743.574120997@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 25, 2021 at 02:13:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.285 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
