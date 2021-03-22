Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BE8345218
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 22:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhCVVxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 17:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhCVVxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 17:53:45 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734EAC061574;
        Mon, 22 Mar 2021 14:53:44 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id s11-20020a056830124bb029021bb3524ebeso754250otp.0;
        Mon, 22 Mar 2021 14:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8GGfvJufko1zuQVH+/+JV2Ep5rc5B4lCaCZSmg6ZdgE=;
        b=JMhW4rydzZSEAQj8XwLfWpzhBseO76NgAsUa3OKnzVhJTOoYbDOqp2W4jAmO60A6aZ
         aC/ReY31iNHPWwAsj9Rdmd3rzqDonoqXT9adRalXYsnU0VFmb/Fj8udEmOAgxEojHX/2
         xrNeuBT6tyjYd/R9xMxa4h0/dlXMtj4DfMWTtedLIYIfdd0bFD1KwPCrllw1QH2B+ih8
         d6wc6GDNM+Ya2kVh/BIMAfZ/cx0lKhFRoLP8nHH0nQn1W5uBoHiyoK/BTRg4GgYePh0w
         qv1jjerfxl1C3llpREAx6jRhjd8/+hGMXNy88KELNbjWiM4LZ2n+hlfu9vQdF0SJqDSH
         KUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8GGfvJufko1zuQVH+/+JV2Ep5rc5B4lCaCZSmg6ZdgE=;
        b=BDr1MeMCqUtjrVgT+CN60GkaxfsljiAmlG3DIK1Y+d8S8kxlrbqOQcbMufqSN9XPrA
         itxX4bTHmL3e6qFhJpJ6HEYZGzggyQgveATBn7saHiTViVstzQv6BuX0krPrOuac/4/B
         /PTlqBqwrGPA+NYxZrHg1NZ1BZCsBNWVwTqV1YsGC3HyK/bbRIinGl3mnLI0fnk+xEkx
         JD6I3gIXi82fXPEJqPjjIvLybfUq0QKECVBhzrNJxpDEbzWfIRjwfp3qUgUJkg/HECcA
         2p5l28VAYo3rpBKZMnzMkg1wcR/HjKhUVI6KBZgt5k3Ibe5DXfbgF3oWUG/anIK3PbtP
         XuyQ==
X-Gm-Message-State: AOAM531a3BfUKr9RurgnBnvVrGXgvcl7nJqA8lIKWXaZ15OaTqy+Bw7l
        j/UpqkJhORnUu3y3nxChy5o=
X-Google-Smtp-Source: ABdhPJyJmzXyeb1PRLBsuOE5I6hlPsZJHGrToHj1Hs5HsUX4Bjm3Xy9jVfrRhKsMhblDh0jbW1nXsw==
X-Received: by 2002:a9d:648e:: with SMTP id g14mr1515249otl.173.1616450023934;
        Mon, 22 Mar 2021 14:53:43 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w16sm3723460otq.15.2021.03.22.14.53.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Mar 2021 14:53:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Mar 2021 14:53:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/43] 4.19.183-rc1 review
Message-ID: <20210322215342.GD51597@roeck-us.net>
References: <20210322121919.936671417@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 01:28:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.183 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
