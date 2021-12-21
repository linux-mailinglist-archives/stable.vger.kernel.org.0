Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BF947C991
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 00:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbhLUXOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 18:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbhLUXOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 18:14:22 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39903C061574;
        Tue, 21 Dec 2021 15:14:22 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id x3-20020a05683000c300b0057a5318c517so395566oto.13;
        Tue, 21 Dec 2021 15:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j2kKq0AV4l0jdzSvmcag2a2tsP7sY649HKNpkoZY7KQ=;
        b=Msf852yviX3rtRMNC7wzjzwnQbc0UJm5/1MY7P5UbPt9kqaxvJGn19H7a1udw8c96D
         PJePZg4X5Z5ddGf3X5nE37hcK0NyLjZqEW/WVh//BEkz9s3TGIvKyLdrIXamZvQ6kaCc
         4Erqknlh+vcajRGCgtVBOasYao036x5CEJHp2L9EjSep9WEiV3KmTfUMGkW+VzmhdXW7
         swmltrCLS0siYUWIk7mpfH3DgvihOgF7EZP0hkwhZzNpQphnbk/wyfXPGBqsRStMxgAY
         YShGXoNL0pWTTRbnW0UHnv/5OjI1vtvWKuweao+y/CTe+fUxlXiryGkcn09tPJGAiAMR
         KJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=j2kKq0AV4l0jdzSvmcag2a2tsP7sY649HKNpkoZY7KQ=;
        b=f6HhsBSGv5lZQOSrJpKZYqV2Aei3iqNxIwWK2RsyTz0nwOSHvpaY4Xl4A4BafLw5LA
         h8hMfTH1axy2snaivh+9tKzcM2O8FIruKqdhAEj2RHw/BOrgRIpLaSJp3dB8Jjm380tZ
         e7fsdrdY/7j8Q556IaKkByMISHbbj7P2cS5aoJU7VUmgbxdYYTeNSrOAObzNfElMZi10
         qZCCpecpqQ1CiPjW/Hc3FRo8LcN5cnuOTWdHK0BLwl5aI5+VWFggBB9p44BS+t1VXOnL
         cpK1yTTdU7g7TBW50GW5CDYaQmCoFweP4xOhJSo8w78BYI4DK7ZE9FzOmJlESHftqk/r
         o3Nw==
X-Gm-Message-State: AOAM530N9+pqJtoyzzawJlEjU7CxzFDU90aNDUONoCX5nbbU0dlBDqMP
        aokEEYlnrxnizSWOzgi1SOo=
X-Google-Smtp-Source: ABdhPJwOY9dIIMPi2E7r3hIJMjn5g9PjN++XbvgU2B2OVacyHNDTXz3dtoCo14q7ThqxTtHDU38AaA==
X-Received: by 2002:a9d:12f2:: with SMTP id g105mr376510otg.301.1640128461686;
        Tue, 21 Dec 2021 15:14:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 184sm70346oih.58.2021.12.21.15.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 15:14:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Dec 2021 15:14:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/177] 5.15.11-rc1 review
Message-ID: <20211221231420.GG2536230@roeck-us.net>
References: <20211220143040.058287525@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 03:32:30PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.11 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
