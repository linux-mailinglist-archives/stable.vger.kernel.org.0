Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048952A6C2C
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 18:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgKDRtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 12:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKDRtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 12:49:22 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123D9C0613D3;
        Wed,  4 Nov 2020 09:49:22 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id n15so20072669otl.8;
        Wed, 04 Nov 2020 09:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rnq05rPzyS+FrDW9dnPKa2W4sBF7Ibqj1v5vP7nhfwY=;
        b=adyRNdu92iBiE3ojIb/Z3B9hgxhFr2G3/wrLZb/m51eWfezyhtOrdjP20YBlEy6jhX
         8nal8i5GJp74115Ozk+ZFQcDbO8RSccKwyt+t52685NkOgeqZ5WSF3kCtYr+qEnoqZ4H
         LSKY/SouRO7SHvRKban5OupoCMdnC9welungVxb3DkCEl7G1Y8DFIMIbg73ApVlE1wAh
         gzMVp3KnCxX+20+gP0JEozhTOw5mZhog48SvaPjJV//6jixNYUKcSiz6pd+1BNLxFuPE
         ASQg9C4S5VUBNGmgrRx5FGe6iGp/CHL/pD3kbJVJLtyeJhMwdH/r8BedCg/oCULmAC9q
         zgjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=rnq05rPzyS+FrDW9dnPKa2W4sBF7Ibqj1v5vP7nhfwY=;
        b=aQsTTnD/KnfkXSsTgIuVLAsWmthtZTN9qGgpgOVrgc5DqCfYEhU+oCeI8gwnl8jXch
         eEBmbzZbEWeLexFzcQLWvOf+m7bkXCL+Yaj6sisCwNqD++Oo3zMdd5YPfN1H72LRbwQK
         1Npiv6bN3y6F09hBev7fRYGfx3JI4Cmr+fVL0uYT0kmd2URsoSZAW3zUqxP05LbUNR5x
         k++eIQeYYL9LAANqyZE7ypmUm2yciOAcsveHHX8DKzlAxUNXbHFOkVuKfcnvPZhFK/r7
         ntD+EzSvPj3WEGsYNG8rkccxGvszxEQkau8w4Tsxo+2nydXblQiJqfFOFNSmg7QPI+W8
         qemA==
X-Gm-Message-State: AOAM530SuCIyqTPXx6QYvCZKlTLfBcpCLavqSP6x5pTeT+14EW5iHm2j
        nNuB4nCbWxFcJwMhjQhAX9cSMgPByJc=
X-Google-Smtp-Source: ABdhPJw/zAz4icEdqg5LSgeKKMLXhu6vXh/WAHSJG5CeDLYNfnsEbWRPJybXiAXv8Hn0Bz3JLbEJ7A==
X-Received: by 2002:a9d:6052:: with SMTP id v18mr19538821otj.33.1604512161439;
        Wed, 04 Nov 2020 09:49:21 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i12sm720536oon.26.2020.11.04.09.49.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Nov 2020 09:49:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 4 Nov 2020 09:49:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/125] 4.14.204-rc1 review
Message-ID: <20201104174919.GA225910@roeck-us.net>
References: <20201103203156.372184213@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 09:36:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.204 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 168 pass: 165 fail: 3
Failed builds:
	sparc32:defconfig
	sparc32:allnoconfig
	sparc32:tinyconfig
Qemu test results:
	total: 404 pass: 389 fail: 15
Failed tests:
	<all sparc32>

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
