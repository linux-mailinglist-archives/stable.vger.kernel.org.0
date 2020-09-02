Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C540125B1EC
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 18:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgIBQpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 12:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgIBQpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 12:45:34 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD82C061244;
        Wed,  2 Sep 2020 09:45:33 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 17so3143427pfw.9;
        Wed, 02 Sep 2020 09:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0UDEVAHajfbqypCXRgF4PLGaRT1iGfKnGyOygyMVhqM=;
        b=fsDekpw2L0HR4O9D/tVKWBfauK6eluZbwDEz2NV3HYEqF9LuO2A7Hr8zkpeAGuHo9r
         B+5tKNzWA1DxG6kNkJK49gugayN36/x7CJhHMDEX0yVL9uLGimQekXDfMeyUe9lSKs3o
         s77H6y03yQm+vl6X5pbM5AyVXAdxMoQ/9Qa8AftUZEwut92SGrH8t082Gadrlx1bobx3
         0faeDzckb9hO29v+qcZZis4PYBu6b9KNSAkfxFpLcggyAIPS49AcQWn5fuUMmk39eGVP
         ipegYhPzIEVmz9ejvu2tGMrSkUeOxDkeJ0Trai0VJDI6TX26ConUdiZcHGb5M4dpLor6
         SvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0UDEVAHajfbqypCXRgF4PLGaRT1iGfKnGyOygyMVhqM=;
        b=kWHXa7oY44fQRDdGSmLHU87+K/4Aq1d423Jy4TJR/GU+nT8ihyHC3anMe8W5pQIjtv
         FrH92J6zy9lLlU7GUWJRDvOLAByXrj+Agas2cLzZSYGqozZn6ukY2nHtYl01AgpIBBHe
         r1DbBRqfsJT5K4xshN9rDXpg67yw0qeq/X2whCdsqjEz7q6FTnbagAJzhuKNFLjd39xe
         N2fzZn4xLwYuV8uc2Nuwzacl0YJRttukKh9vL5pkWf1I3MvNkJNTp0PaETqVq5EBvSZm
         zqDK/hP2OuyutZBy1ACamLXHJWWdLEGYSlAmSPmPkfi3okBaQzMSnwvKXw/s77UBZwe1
         4M0Q==
X-Gm-Message-State: AOAM531kkKjw5y84Jkud/8EFopxlh4r+vaKIqVG+Yh3oT6i+65cY5eTz
        KEM+yvjy+q+fiGYRGE53FqY=
X-Google-Smtp-Source: ABdhPJyRGQuWtK05ewIakPQU7ULhLE5j9sbkQvs274KSV8pEY/FQlJOlTYHk0JhuS/ASq4MsFV2wiw==
X-Received: by 2002:a65:49c7:: with SMTP id t7mr2611449pgs.131.1599065133334;
        Wed, 02 Sep 2020 09:45:33 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j10sm6014345pff.171.2020.09.02.09.45.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 02 Sep 2020 09:45:32 -0700 (PDT)
Date:   Wed, 2 Sep 2020 09:45:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/61] 4.4.235-rc2 review
Message-ID: <20200902164531.GA56237@roeck-us.net>
References: <20200902074814.459749499@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902074814.459749499@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 09:48:35AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.235 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Sep 2020 07:47:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 169 pass: 169 fail: 0
Qemu test results:
	total: 332 pass: 332 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
