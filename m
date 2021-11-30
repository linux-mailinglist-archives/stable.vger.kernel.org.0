Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53934463D00
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 18:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhK3RoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 12:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238926AbhK3RoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 12:44:21 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9797CC061574;
        Tue, 30 Nov 2021 09:41:01 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id r26so42692673oiw.5;
        Tue, 30 Nov 2021 09:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zToj2Rjqq4S6f39WW7C0z5QcCMf0yz8gvkCFQu0Qxhk=;
        b=b8jKqy661WTC+hCaZW1euw+wfeV6j/8ygjykV28xDNf70xbphrBtM4acIRw+pBSYad
         DOlcwD8AHJyCZui8bg7icKPiIiHCsnQpqpRuUmtkRbgvTVscnvhWdOzhvZjcgsswvz0Z
         0lD3OojpBtDlKu81N90oicC+M8wsBl7hyNGW5vl+yNwXy3LYsk0HEpVpobVpxIDohKtU
         xLI9VN9MOpwiHMDmc3B+qQVIk5LrxwnmNORU3lZGNO9fiGzkDk0ke30Ugqq4KfTC5qAD
         cn7dzuFrHyY+Ne+XOt5fm5+C2XT481En3faxErE+45n0kt2ppAb7sFJ35AHB/q3Oo8kQ
         bdgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=zToj2Rjqq4S6f39WW7C0z5QcCMf0yz8gvkCFQu0Qxhk=;
        b=yMHaMpgjZ3oiUBrbn/AOjlu/oHi9KDgPB4YaWc41dlJgXfbbU43K+j1mgg9P4DM5UW
         /im85xCVlV565YiQyCX141FQbfQpIIqMk7S+rjvsX6/suhlrjQYFzRBGNUDXcix5Bmqw
         b567REnJVV5n4UatMoxdJra3eMmsOO2nYoe5gcVSISP2ZixrjY1db4g2PU4O+zMSFLce
         K8UadgN0Aat3k+44Qz41+YklxFPNDNt4doxPRf2XWSkX9A9Gy2PrtjR0j8QOBA9rznGu
         DHnsUAVM4Sr22ozToFmbLU5BKBzkgw/wce30/s9F+bfZ9l0f/gtTcWEUwMu6JdEv4C2R
         HCwg==
X-Gm-Message-State: AOAM532Nfr83nRlF6mPEkIWDD7HPR42ohAjdriEgQ4YN8RBq3imbt7b4
        p529XymXaZA0cdgfOb0sVp0=
X-Google-Smtp-Source: ABdhPJwKv5HxcMTc1mZDkrZuhdrL3f2ax411fc6Kk9DMmlyDRQd2B41Q2WF8GqZkRMFfSXUsOKYa4A==
X-Received: by 2002:a54:4819:: with SMTP id j25mr369414oij.66.1638294060965;
        Tue, 30 Nov 2021 09:41:00 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c4sm1568865ook.16.2021.11.30.09.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 09:41:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 30 Nov 2021 09:40:59 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/179] 5.15.6-rc1 review
Message-ID: <20211130174059.GA3226251@roeck-us.net>
References: <20211129181718.913038547@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 07:16:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.6 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
