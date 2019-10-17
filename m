Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4D0DB572
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 20:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438184AbfJQSEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 14:04:12 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33676 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438178AbfJQSEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 14:04:12 -0400
Received: by mail-pg1-f196.google.com with SMTP id i76so1810398pgc.0;
        Thu, 17 Oct 2019 11:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ANNSC3qB4tgeOuxEpT4tR0Gx+yCz3edM8g4jmRTLjso=;
        b=dMkJk1upAl1hv2btNG/fbGvrCuEAPMmR6NDg0xN5RSIbjsZ9Q2L/65z8ugkEUVByUH
         V1SMMPT4pEiExchOhz+YInTMhSPeqBRsY6GBYuxKtJ2a6luDGQ09FOqqJdV/fO0ncceL
         0y2tS6UgwPcWMiDfyry1aUV0qb+ncoXY5CyUerD6WAaHzh6iD5NDNo7e4Oh1vGATEpbv
         Qyw5FeVq4gOEwXWTwG55mz6BHHP3+63AWop/9hx6W3I4Hu0uCerVSVfzRtMTTxyCQ4Fm
         6P1jF/dfF2XeqmPFjHu86olsIyxbfVGeGS01nlGGBLY3MiVIDo2+S8qvT75M6KSwFZR3
         EX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ANNSC3qB4tgeOuxEpT4tR0Gx+yCz3edM8g4jmRTLjso=;
        b=B27RNW6BH0udGNlMP7XP3ZB0uPP+yQpgbvAK2udPeqRELzCpSt75Ou2EYU3NCkWHBj
         1667XXUtiT+/etqIyDrBygxHo7rPSPgTGVI1Z2S28zNxORXr0pHCFfHL0WemfLsZQnb+
         Fdkf2Yep4h6w/O4eSvfxMs+ryj7TEsoNfkmLoAWRtJgnz0iVE4VkSi1BvPQQe+0CuPqw
         8vP31PNGAsWwc62/3o8tmSUNWBEH4UO6IVjyeuiT6MchdmQFXA4ky1u/HW00vs2FxMig
         89aoWhaYmfm4Rbi07pdlZeDHJ86uK02z5qVSvT5FXBJVV8OczplZUsElEsBbQUDw01Vv
         CHLA==
X-Gm-Message-State: APjAAAVf1E1c7/yaWugrSPxo7U8Ze3HZZlkZn3b3582V3ITOi2Ils4aR
        P1yXAvlFklSshxTkDGP7iMYB2pFh
X-Google-Smtp-Source: APXvYqwHAD33Au0sskchhOd+NBv9M6RDOZAiM7McL0cAzf5lZylIYg9MDkQArSwjRFOkxQ9fcOY/Ig==
X-Received: by 2002:a63:eb47:: with SMTP id b7mr5450634pgk.179.1571335451335;
        Thu, 17 Oct 2019 11:04:11 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i74sm4765072pfe.28.2019.10.17.11.04.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Oct 2019 11:04:10 -0700 (PDT)
Date:   Thu, 17 Oct 2019 11:04:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/81] 4.19.80-stable review
Message-ID: <20191017180409.GD29239@roeck-us.net>
References: <20191016214805.727399379@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 02:50:11PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.80 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
