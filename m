Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65890421C77
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 04:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhJECPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 22:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhJECPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 22:15:01 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F85C061745;
        Mon,  4 Oct 2021 19:13:11 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id e24so24167551oig.11;
        Mon, 04 Oct 2021 19:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QgQfMYRoZ7f69FSYHxWDOjLIJ7p0OfV7rP8xTNpGte0=;
        b=c5tWLsLYZa8ZuBqEY3gT1SwNgFrgebuFbGq5ee594ismgaC+hl7oFfibspG9eoJGSG
         Oz2wlwoufsS6hyaTRR8g2aabiFcN8gNJ9yAlCGHBE1/v3e1nruGDWy8VOql8PybeTYl+
         EAhnaVbiUc/TNbReWqn3KrMT/J/uwPNHctHUXAV6Z6hWRzt0lpyE/JizzsuGiqldaREI
         uD/5ce6/8Os+z9LsUpWTSzDzUWYYb6LpqglrX/GxlUAE8Be4DCf8eYH8FpIFvawoT32i
         eN/D4H30ZuPvtuHNMY7ZR5HZvW8K1Wims+Lnzoez1AwwCyDdQ75OvJKH2nclritWXd5k
         GNKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QgQfMYRoZ7f69FSYHxWDOjLIJ7p0OfV7rP8xTNpGte0=;
        b=LDqMW//fcuTXFtqvH916umZJJ74mArOBVU8FApNTUJ4t5ed5XMNg3uI+yqsaDPT3X7
         xKSo00Ahzf8cXkQh47hKpuE/REcu0c1UBj3ewMmh7AbGHjQHaB4ul2DFngGdgowq8K19
         fVe/Bc8QALPrQjB39Xkebl4bxl/H5KNBpT8Cpahe0x7JsEigXXendBkaqdUSamVhlGwn
         qN+6OKbzkIroVTnqSDMyH3rLMFOHxRCdGoO58qhU6U46nRDh92ii3hy+wAyCtPKiaASy
         sZo8mG9uYc4VAcdq50zgQBSKMmL9lM1prcQKYNsif3Gwh+CWQTIOxGWDXSZq8/b69tyU
         jcbA==
X-Gm-Message-State: AOAM533g4bu4OI4bBmaG5G7cSWhtrGcxntmqj6+dXP4i1oxBD+K91R+p
        Z8vcm7uR0xLTEHx/BoQOPs9AvIx+2t4=
X-Google-Smtp-Source: ABdhPJwPyWhgkb2VtCwz5KDs7wBqC1lCCscS4atZvqN9f63Y/b2q8DITWxhLclq/MWB32q8lBvI/Jw==
X-Received: by 2002:aca:c641:: with SMTP id w62mr403412oif.102.1633399991286;
        Mon, 04 Oct 2021 19:13:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z17sm3190275ooz.38.2021.10.04.19.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 19:13:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 4 Oct 2021 19:13:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/41] 4.4.286-rc1 review
Message-ID: <20211005021309.GA1388923@roeck-us.net>
References: <20211004125026.597501645@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004125026.597501645@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 02:51:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.286 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
