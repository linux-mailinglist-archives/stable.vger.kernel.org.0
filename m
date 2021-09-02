Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70923FF5DC
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347590AbhIBVw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347586AbhIBVwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 17:52:22 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0A6C061575;
        Thu,  2 Sep 2021 14:51:23 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id y128so4454880oie.4;
        Thu, 02 Sep 2021 14:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qneRj+Q38cUeXM8YvCQBfacr9QciRMic9R2VUDTSTxw=;
        b=eQrG+o97eJ6clUt+C7Df7hP27A9NKsbFB9Yc7ZxDYvcwebee3dUMrhNR1P9/dqVk5n
         LKYAh927mYVrKHw61OykGbMXXSf20h9vY5kokoKiC+/26L1nykKoRHZB1KkxEtPNzDIw
         +Sh/S0CEXm24MYnzSZm29soDsHArIpS1pL5+k1hZ3fr0XWjc+gjSFVTJf6mRUn9dVjiv
         TcdxvYmbAw2NbIUMPP1Q8ly1Lb4XBnBp9zX2pfqZJJuwjqwT6Kl+8kuUap0JObyfOLVK
         gG11U77c5JZTrNim3hzYsaAVN6qnFPidVNXUAFNe5HIjRhBG2ixcxxCA9KQM9YUgLPjf
         xRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=qneRj+Q38cUeXM8YvCQBfacr9QciRMic9R2VUDTSTxw=;
        b=hH7QcQRBldvj3egiX1NKGWl324cxCtdPLQd91N55hHihfvOsWD97+Kp7Y/JGinnvAN
         0OoaQSMRQRwy3OZJ+gnd0MSODW5Jv7Exv04yoiygMAsVj7a5aBKISpVnUxo89ccnEQCq
         GngRw41Snqt4EPvjTzxqF8V10ARfA/xkBKXe6nHzkHC5N6PdlrMG71502//i1cqo5MUc
         JUdp0KW8xKQm+4JCzOeA5YMrOYjZ8TGUUWZVknAf3LF8Kq1kak1sh761vlcz+zIty0S4
         klOeUbU0hnbfJgKUE4s1tnJ4zlvfvqbQZa5Y64sDqBcQ81vEC3an0h04dflum+k39tin
         g9aA==
X-Gm-Message-State: AOAM531IPbOhO/aPi6fLM3iPCZnhyZGlGAG9e6Xlq6jv2RuLWznTXgqy
        C8FT9P1yQ/xlszRwerT+SZU=
X-Google-Smtp-Source: ABdhPJzXtamVeSP4cPJtMNCIZ7wgfnmrWsK3iK4zXNrjVFaqUo1gg3+Z/6/MImpPCGCO6m7BuHwzGQ==
X-Received: by 2002:a05:6808:642:: with SMTP id z2mr315301oih.26.1630619482533;
        Thu, 02 Sep 2021 14:51:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m24sm627512oie.50.2021.09.02.14.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:51:22 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Sep 2021 14:51:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/113] 5.13.14-rc1 review
Message-ID: <20210902215120.GF4158230@roeck-us.net>
References: <20210901122301.984263453@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 02:27:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.14 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 479 pass: 479 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
