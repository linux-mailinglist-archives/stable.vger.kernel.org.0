Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0370218F3A
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 19:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgGHRwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 13:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgGHRwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 13:52:01 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88006C061A0B;
        Wed,  8 Jul 2020 10:52:01 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k71so1548086pje.0;
        Wed, 08 Jul 2020 10:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EGttaUopGULCvijVfYoEZrzaHoKVeb7+nx/rSoepyBw=;
        b=VVExGdTDx/1JIEaXnufd2e5S2fWpTFQPlkMHvYIbk6Zog6gUl+Lm4SDPdxjtFTY+YF
         SlXLAt5nLFYlffgJXSq749zWGC5DC1IA/ErVxxFXtpNfHpAnVtZRYuoeF8eritTO3Edg
         y6LqVj/pcLG7mLZ7Q7b1HdlV0CzrqTQRYo4hEvoM2I7fxn9YrZ2ShGLJ3aeyy/Zp7mde
         Fac/cp64IBKVpxTznqxPDsHXFbCzXeRFMVZHNpIkc8D6yyNxSRyOB/2nGdW89xqjwGNC
         IipQEz9RbXwNSLN9gkrhC6lW8FOAVBKEGwmmjRX6gZr29CBwEbZUPC5db7SC6o/xq3nV
         dv8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=EGttaUopGULCvijVfYoEZrzaHoKVeb7+nx/rSoepyBw=;
        b=e2xDxJjworZqM/BlMjML3KCemU/aXQ3BH0Ai2FloRzeVkedDf19Tq0phcwvvur+qeU
         wBucuM23BADBAAA9WyKhPvcsrUj7cM87qOkl78J0IQ9ra4EaBNCAgiJxvkSblQuvbUN0
         CXfYjMvzPcB7BfEsek3/Hx4nh+8Cv10DgSfrQjgKeulUESHmokf5KPwFj00wq3jamJTr
         W0zQurO3HZhoWEFg5AcAPX95484QqQkffsF6iij9ruKeR4aWOXsJIzo/hVwJqXVwLXt+
         +WjlE9nq5YyYZTnqjtvlQoWW7WD0oyr2CJ8g6Y0iXCKJM7uWWuJ2kN7six9J4vaal/+Y
         xNmQ==
X-Gm-Message-State: AOAM532tnwzLzfkbe/rzGqI2c7VGymTWS27EjAVq/g1dg9nbkoTvtmAe
        1hHLORBYeWYJG1gpjHGQFKk=
X-Google-Smtp-Source: ABdhPJytiT8GkEgmxZtSt80+yi9F/JaJtyVO/B1ltCG4DO9SN4TobXaSbaTTdSMwrBQfovzYtBIhYg==
X-Received: by 2002:a17:90a:2a02:: with SMTP id i2mr10764927pjd.157.1594230721178;
        Wed, 08 Jul 2020 10:52:01 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x22sm445959pfr.11.2020.07.08.10.52.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jul 2020 10:52:00 -0700 (PDT)
Date:   Wed, 8 Jul 2020 10:51:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/24] 4.9.230-rc1 review
Message-ID: <20200708175159.GB224053@roeck-us.net>
References: <20200707145748.952502272@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707145748.952502272@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 05:13:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.230 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Guenter
