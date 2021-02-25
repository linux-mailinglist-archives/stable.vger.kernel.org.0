Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1300F325722
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbhBYTzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbhBYTxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 14:53:46 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FC9C06178B;
        Thu, 25 Feb 2021 11:52:37 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id f3so7264998oiw.13;
        Thu, 25 Feb 2021 11:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P3rv7HNEkHyR62toloS/tP0IqbMqbykhnp5GUhNxi5w=;
        b=RP2Koq3HZIAtnr6/KXs/wkf5jghuFv99qLS1/CEPW28hiB70l0J9mCacSuUiYdOKrh
         AkS+1GHCquCVZpEgCuNcXJFlfo1BM50s1JNBXa81eeomGY6fNlyWvojLEcYHryQ0egZJ
         GULpVTpIwcAp6IzQyE/B5tgu+fPZDV6r1eStWDZvKL6Xk7zFEjBoYdlQgi5IcSIko9hW
         ht5BAAunUn6pvtHhUGMakL/BRbf7s73EjGit3GVlWVx+G4plVOv08P9Utk1msn5NfKVT
         ewBBGFq+DLHi+IleudozlTq6mj8gbf8HJqCWd5vdq3ZGxms+60AsJDvAEb6QmvboC7BD
         y72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=P3rv7HNEkHyR62toloS/tP0IqbMqbykhnp5GUhNxi5w=;
        b=E0O2ngg4SD4/FrKI8PJwzcwRtnn2LqBrNZVt4UZgOk5gukeR657d+3v1YM/zBAgeix
         glOslgIEQtGw2dWZanAFFH8QmHQMKouSij0OI+8csyTPfXJgKSQKFcykEcSEiuQRnjMm
         U/JJC7/mTAjDdK4e4lFqr8LR3gM+MuWucAumuwad1rH5mdAdtJDvraGx2ZKD22wxizGx
         Exq5gLrleykSBzbjXPJBi6xnbJS1eqKWwGSksk/Ywh7UCNrSmnpjog+usmdXULyKGzcf
         eUAETNgSSud3BO+dj3jXB/gMdbdCao6KvmA3ypkizE3qgb0uC3MREtZokt+LQnjtmIdI
         PnYQ==
X-Gm-Message-State: AOAM532EAsR21GxOFVmSWrQKcGYy7aFquGYJbIpR/K8IodutUMD4ICWb
        qgORmGG1EQ5cUoX4OE9XPJk4Abcd+p4=
X-Google-Smtp-Source: ABdhPJxXD2dYWCuV2mEap5MGTkQKjt211mrABDn6Fq4xv9Mf2orUrnuuGCBxynwB1xNtzOx3sEXXbg==
X-Received: by 2002:a05:6808:14ce:: with SMTP id f14mr6403oiw.59.1614282756495;
        Thu, 25 Feb 2021 11:52:36 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k18sm1336134ots.24.2021.02.25.11.52.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Feb 2021 11:52:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 25 Feb 2021 11:52:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/12] 5.11.2-rc1 review
Message-ID: <20210225195234.GC107964@roeck-us.net>
References: <20210225092515.015261674@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225092515.015261674@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 10:53:34AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.2 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 435 pass: 435 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
