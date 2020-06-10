Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359B11F5BD1
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 21:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgFJTKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 15:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgFJTKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 15:10:46 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912E3C03E96B;
        Wed, 10 Jun 2020 12:10:46 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p21so1377436pgm.13;
        Wed, 10 Jun 2020 12:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7pQgHYK3bQ3hABm/VtfBQLa7u4+jOHdhkA+vfPGMPw8=;
        b=mfNu6K0FibUi2mLf96F9HlaHVIuHlsYh/sF99QoL8DQy4niSdfhULdoTUdqNvreOgO
         H6K6dXviModx6qKkMLrBPjOxSJRAnt9oEr3Qr8u1UaYnmR0RzUeXxecs7jDX+wTnbMqa
         bPKT2fISXVbWflu1lkCjLsNvXU9UH7HO2GYk+pM64g16hEnKLYAnK/8mx2QDuAO+49oP
         5ScDB+d4uii5pUqEk/pjAqxMx5ih5ubY/7EfkZ9atxc3OgpA3+K5H4zjasIW4UIiXtYO
         VjumfPTUYLvnKpcyXaLq7iu/v2S7/mJf+Aie62Z0/hZMDxXpg8MahtW6K0bIlDFc0ypZ
         qgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7pQgHYK3bQ3hABm/VtfBQLa7u4+jOHdhkA+vfPGMPw8=;
        b=ecG+i7TwxsA5pYSAc4ssxwVk+cR8HsXUiHKhSua28eyKHHjYCs9QFaJra9EOp8aMG8
         +Qc5bdnbVHXd0zHz0gnt+HiFSWU1CtB4RBmJy4AphO/lyoAk5CZcr1OV9IQ5yS/vVZDh
         xb4PZiDfCdA63bnGLIcdHnJ7qN98P3wVV9M+9RMmojfh6jJ48VRkL/YepO30qkXLZO98
         Y0riq1Un4IZdA+Mwp+qEjS9OiMTivdK9OpHb2AV81gnuiuLb9LWMo9QU86C+X13sTTET
         TODm3X+Kr5TzXlTTvsLEplf3zbHLg83osiG4ZMvamfaMVUFaUAlfd1PTCqIUw+2WUApv
         5xOQ==
X-Gm-Message-State: AOAM533RL71CyEhNX2ERLOzJ925sx24q1V7iZd0iKcjDQ93rDk+b8qPp
        M/6Vsy1qhrF3Z4HLmVGBMng=
X-Google-Smtp-Source: ABdhPJwTtrm/KGTWjN4JV85uyKUKMwU7JrvFidlcQibyzT9yu7ZbH+1d5V7aEVoaxy5wv1gDQ96LBQ==
X-Received: by 2002:a63:1b20:: with SMTP id b32mr3808930pgb.39.1591816246224;
        Wed, 10 Jun 2020 12:10:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b10sm531888pgk.50.2020.06.10.12.10.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 12:10:45 -0700 (PDT)
Date:   Wed, 10 Jun 2020 12:10:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/34] 5.4.46-rc1 review
Message-ID: <20200610191044.GF232340@roeck-us.net>
References: <20200609174052.628006868@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609174052.628006868@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 07:44:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.46 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 17:40:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
