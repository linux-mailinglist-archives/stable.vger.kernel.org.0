Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BFC23371A
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 18:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgG3Qra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 12:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3Qra (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 12:47:30 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A682C061574;
        Thu, 30 Jul 2020 09:47:30 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q17so14656543pls.9;
        Thu, 30 Jul 2020 09:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sICAntI9ruLNYmi1CB3WZLGBH9JUeW1nH/tUxpE3DqU=;
        b=r3KE4gK94lpUCY9n3ol7GqGlD9af69BOIegWUl4ZLSEv+5xISSYo/b1l2kPko7TOCW
         IfqoAZZXXWq+CoBGp7/GyxgN7sbAFQprAhnCVyH49RRP0FA3i1niT+CEisnfA1AJqrx2
         gY2ld6fDNNJLvhEqi8i0SjXSEdV9E6W62XUW/c1F7spRdiPHm12thRgpA7wzkZWUrfSp
         rOQ0iLGcC3Fs9ZwZn/MAfwm76UbpNVsnF73lHDYp++1qD//LLmG6BzeKNFK4K67QQoY7
         vzzGb7q1i3HGsvMQqBQQFtxpk3yi7J6H5ibxsgEEdwiTT2WSh2WWE8Rf9B9IjKaOJC7C
         Y1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=sICAntI9ruLNYmi1CB3WZLGBH9JUeW1nH/tUxpE3DqU=;
        b=QaHElZ7MOLYBmyWGLVUdfoSrU+VKvksYeJ/E52P6/CBQnD6XS/omwGRplNNwRr7Y04
         AFcBeZESLjortqM/qHEc2kU2FABFLYh12RkPcsBfsp4/V+qol5IKOkWfRzXuHbbKuMq+
         wMo2ABN5vTuHelOlY/KJUcmtNNxx6E/wAsr6k1OGO2fh5oVt6It6pHhAE9aMxwzsw+Am
         Pk9USnULaTrQRZHOoOBt7kkaps3L4bftKRRqEB/xwrBDvtRNAlbLmpRaQ7of77ecfZAu
         EuZyOGBLnJ4RTKNzHGFoNoopRJZDLM32CoFH4WNakS9bOgUZyqJWJBbJLiWxeOOAf5xz
         E2Bg==
X-Gm-Message-State: AOAM533lmwz/DLNBJo9NTT1iWV72Uho1L54Rc/jRpU2WUqg83I7uR3k2
        +eBjDkG/VUeAKrTxuvFXkVU=
X-Google-Smtp-Source: ABdhPJyoueYRFWrVP1PEGvA9v8nM/I/kFoQVkVJC5MnIag5umw2DNlNaJasQMwYXk2OiV7VCuMw+HA==
X-Received: by 2002:a62:1d0a:: with SMTP id d10mr4151311pfd.270.1596127649657;
        Thu, 30 Jul 2020 09:47:29 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d128sm6595578pfa.24.2020.07.30.09.47.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Jul 2020 09:47:29 -0700 (PDT)
Date:   Thu, 30 Jul 2020 09:47:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/17] 4.19.136-rc1 review
Message-ID: <20200730164728.GD57647@roeck-us.net>
References: <20200730074420.449233408@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730074420.449233408@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 10:04:26AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.136 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Guenter
