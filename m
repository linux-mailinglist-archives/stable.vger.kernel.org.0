Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0E030E455
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 21:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhBCUyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 15:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhBCUnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 15:43:17 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E02AC061573;
        Wed,  3 Feb 2021 12:42:37 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id a77so1322899oii.4;
        Wed, 03 Feb 2021 12:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C5kh99mQCO5n+WecEo1voSPGPqllJQFlU5mG+OQ9Qe4=;
        b=d07uMppdMiqBB5NxBMK9mfZT+dMpunSjVufV1COKPvAWGXTYQkf08i9gVViG4oIAp6
         nz+fc5NnBPW0xqpn5R2aqUXIHYYSRRg09lE1S9B2AtJcwm8kpUrUYGOcasvJ0/RKdla6
         X71QNNnDQS/q+BN/jCqrlm68NgFBct/v4rALGlG3FfqL22vofTI39z0Kh/74ZXg3wJS0
         Sm1YAHN5uDuTFij4QdIjlUDZ3RgHC0LXO595Y7dAwlv2G3uBkew2xlOO7swqwOx6SNZi
         8lOdM4IdZs9vZnwMAiEfBI42O0t/S3pAMkBkECTtDp3a3MNIoBqO/s05EBPVSJyngz9k
         Rq9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=C5kh99mQCO5n+WecEo1voSPGPqllJQFlU5mG+OQ9Qe4=;
        b=LXkR2A6840A+WKCTklKqlpz+csdZnaF62AbwYQuND0go6XEjGmRwBqB/3c71rwT6re
         +LlSsnlC8P5ikYelhPj32atIjxNlEXi0NshOCDZRSLc2p6XY4SUed1gFV92n2caWIhLh
         D71BEC5krwvjUxQEmxaVQw+fAPlpwZggiXe3SWEMPfDn8bTlUdvA0pczexhuBy7WX6wI
         6XcoEWZGAZGFWGxdeZik7BaMKi62zNeWMJ5BaFnUWkj6n83KkZRgaTSjGxja4LiBwcjx
         SqwkcbTgh7JN/o9Ho0ytuU4Og6Oqb62H8iPRdnlGXQ9wuU77r0U9Hu7fK+vG7ISqWUGe
         vo0w==
X-Gm-Message-State: AOAM533UBuzZxTEbfbHddm0AHKa1EZF98vTy8jUjP2dBPJwX1+xBPsje
        SFgMmE73icdTr3t2c7OG9FWYOUQTMTs=
X-Google-Smtp-Source: ABdhPJwfPVhL7zWApaVpxn2ljkIzEipC6rivUpsIr6XKzbEOx2ODoHV3uEfrYGpm4moTElJNTLAe2w==
X-Received: by 2002:aca:fd0d:: with SMTP id b13mr3108333oii.64.1612384956874;
        Wed, 03 Feb 2021 12:42:36 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a188sm684380oif.11.2021.02.03.12.42.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Feb 2021 12:42:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Feb 2021 12:42:35 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/61] 5.4.95-rc1 review
Message-ID: <20210203204235.GE106766@roeck-us.net>
References: <20210202132946.480479453@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 02:37:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.95 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
