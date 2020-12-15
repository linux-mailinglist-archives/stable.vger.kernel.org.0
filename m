Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED262DB540
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 21:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgLOUdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 15:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbgLOUdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 15:33:09 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DADC0617A7;
        Tue, 15 Dec 2020 12:32:29 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id j20so16247321otq.5;
        Tue, 15 Dec 2020 12:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o+v89JGGhlvqA9wa+E0Hda0WsmZ5Ppq6XKpO4sojmPs=;
        b=MuWijT/n+YlvF1vqbP+phEkZ2oS0ZmnmyQyBtyuJ3xbzY4geoaZKA550SwXH7eYldI
         PRa4EFXR5D3tMqjjGOoUICAu5WZYhgqyB2nb8FuYY7wF9Ivc1pTuY6XQ7FCwaZxIzgOy
         wTmkhy4C1AORV2SiVw5ME1Qfwe2/NN+WF9/P0xVGggCII01O3B983IOkViztKc81EJ0y
         j9a1lumIYMVIv+tvoFXchH+w2/FEWeES8uUTgyvbCLANOHDXz6QEshcq7ZU7mXPYJEGD
         512LyIzj4ewirLhE+00KmLLO7vX/51RBNEKvTf/+YjTCjtbf7OBprmsHkGq176QlNJ0b
         ivFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=o+v89JGGhlvqA9wa+E0Hda0WsmZ5Ppq6XKpO4sojmPs=;
        b=E8sa5bbr0orfrAThX5d8AIU1DdT2Qtz3Xp4mLz5ebsv/3LdjqBeVkxqBFS5yrQJcRa
         9RmM5yjT/1jaJk0horFNb+HOHBwSnOFGr2sABNMrTY6vEYRestPB3+6uKGl7g14SQtnC
         RtZnvEBi6O3i0PRQo+8QV9LiiZOCyn6U3SFEEjJq9yIJ9F1FNyB8fMb1LP+dAhcOnVt7
         6T45trkRTRsAbxDnfVpFPXLdX345NwT7UgacyT6oVtTV3EhHfN/gTIHuB4NU3PGStn3a
         odIC6F6KAgZR2vcEjJmoG2THOr2FISALQ6I6SKJYxZn6s5VPfuQxC8b2zOmcmRbXADUq
         uMEw==
X-Gm-Message-State: AOAM533hNIcm5AEE68V8NMn9Kb6Hg6edsJtpcStYjJoJkd8T5Mp18WGX
        jzqR/cVxNs1u5+oDEKPiqjQ=
X-Google-Smtp-Source: ABdhPJwvDZdVslicWgDRg4MHdoJQN1B/aOtdJQLhnQEGynOrYfGTHNHPHmshfUYdAtsJWmvV99PoUw==
X-Received: by 2002:a9d:7851:: with SMTP id c17mr24871134otm.255.1608064348643;
        Tue, 15 Dec 2020 12:32:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f25sm2312979oou.39.2020.12.15.12.32.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Dec 2020 12:32:28 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 15 Dec 2020 12:32:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] 5.10.1-rc1 review
Message-ID: <20201215203226.GC188376@roeck-us.net>
References: <20201214170452.563016590@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214170452.563016590@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 06:06:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.1 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Monday, 14 Dec 2020 18:04:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
