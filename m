Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9C03E2F7D
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 20:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhHFSyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 14:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243429AbhHFSy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 14:54:29 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA7DC0613CF;
        Fri,  6 Aug 2021 11:54:12 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id az7so10949680qkb.5;
        Fri, 06 Aug 2021 11:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ukOHyjXaZwRM7DApW60zHscwgybdaHrIkrvrkuNcGnw=;
        b=DugJcaj0yP1tAvYcQOIoXE9IyRuPV4wqsfIoErzO8+KSRWd9bmabIAODM6+lxfCrRM
         4rN2O4mZewqIc+5jyH/U3Ux2ywnL9Hr2iCqil0JT9DyCGR6x2p4eNr3LHBEqJSMbLxvq
         KwrE7rEDLnYtIzz7Vi2sVRYPA1vUB1kE5svHf2esL0988N09MX2ES5gvkQuLjKZxemO2
         Jb4geJdh5Y/VuZ54NgK5BoypGvsgmcXwb5q2ylXa+DtnvcYh77mYdCj542EZEj1aJVBQ
         MtPWdWQx2zdSekxE7TL1oFWvnea5KISarkKsQUFaSVfB1tuwIHR5kFOGh8xzjw6Dgn7+
         /KjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ukOHyjXaZwRM7DApW60zHscwgybdaHrIkrvrkuNcGnw=;
        b=oj8ZM59/YlfYyvrDHTvs5Y80z7VXOJ5CL3He0ZgtOJDdCUv1ffYlsAcKae1q0noxUz
         bZqi8XY3jjp1RdhWmTn4XqgztugfxNhgVT0pM47Abo7MYDrP9afgf6S1YA/BEcbKp3QI
         EtnSZ35Sn8tVTsX2EI/tsFIhXwWxcX8EdCuH9UlsNcPb30Nrn5PtJ/w88gv3zGXvmSjZ
         2J1n91nZAA/AUq4DeclK6iWPY0gjMWfz4CAwYn316JMRZ/mDzuv9Q6SOMje+lhgMayHA
         Y6hapZ2+t+/m4aX4iON15xq89eTO+R3NzI8UMIZmlMH8iYiopD36fwX8BRzJiKjMgwu7
         PuiA==
X-Gm-Message-State: AOAM530C+jmY9/6Ne50F2Jt5wNNBxgBhTCMXerTZTMhc4bJKLeN64yqP
        e/TkQIvowg1FRqOICWRMGtU=
X-Google-Smtp-Source: ABdhPJxhS4lIwNvHN7DPB1kygf/LhPlurkdKREGECoP+gWsigcmAt3rHji2pxXTn4009b5l6PBEaWA==
X-Received: by 2002:a05:620a:448c:: with SMTP id x12mr11391509qkp.39.1628276051272;
        Fri, 06 Aug 2021 11:54:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t124sm5061621qke.16.2021.08.06.11.54.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 11:54:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.13 32/35] Revert "spi: mediatek: fix fifo rx mode"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Peter Hess <peter.hess@ph-home.de>,
        Frank Wunderlich <frank-w@public-files.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20210806081113.718626745@linuxfoundation.org>
 <20210806081114.781183194@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1be93ec0-43cd-f86b-aeb8-64971b4fcedd@roeck-us.net>
Date:   Fri, 6 Aug 2021 11:54:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806081114.781183194@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/6/21 1:17 AM, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This reverts commit 09b8cc7810587257e5f82080884001301e1a1ba9 which is
> commit 3a70dd2d050331ee4cf5ad9d5c0a32d83ead9a43 upstream.
> 
> It has been found to have problems.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Cc: Peter Hess <peter.hess@ph-home.de>
> Cc: Frank Wunderlich <frank-w@public-files.de>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Link: https://lore.kernel.org/r/efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The problem with the reverted patch has now been fixed in the mainline
kernel with commit 0d5c3954b35e ("spi: mediatek: Fix fifo transfer").
So an alternative to this revert might be to apply commit 0d5c3954b35e
instead.

Thanks,
Guenter
