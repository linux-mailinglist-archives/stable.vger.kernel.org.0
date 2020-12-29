Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473892E71D1
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 16:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgL2P0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 10:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgL2P0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 10:26:24 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D73C0613D6;
        Tue, 29 Dec 2020 07:25:27 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id q25so12051740otn.10;
        Tue, 29 Dec 2020 07:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wp95xn6bWLWiQPeFhAiO4UPvYEASlop/01yQ3VCyGaM=;
        b=OD0uLxYHR6cqU93uITUGE5yrtKu97pDd8waH8uFPe4HaQ1BrchyuwwgbxiCAa44Bxt
         x5Rmc3oURt6SNeQ1WRSjvg6w1E/GDi1rfNq4QJjKTdEa9rb0yNHBMSABI7fIdi5668AF
         sW3QUy+utuhe9jYZ3+A93YmnBIqLk6hNd+pXh2h8Ic5Ye0jX08KV4xu1pkqMixvA/LNh
         nZ4IK+DDt2TmyeYLvrtpikxzKNz4k0dWk804N3DMc8a3TNFH5UHk+ldZNmVc67AXlW0t
         xNIHeij+MyuLd33NwpBOcThyr54dVd6GWFGUZL9tqeJDXzuqU5+SuT6/aeWA+Ajv+z94
         GyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wp95xn6bWLWiQPeFhAiO4UPvYEASlop/01yQ3VCyGaM=;
        b=Cs/mGws0a04QeXPPXAeF1V0PVWHDm18sbOuRJMN6EPf/xsb3jiSN3EwjdyOH7vR3Lg
         KurRskdoq7Jw1LUmvDvFoLYTLOmNYYa5nTfJYhWPoxhNVfI9/cvd8Hh1vmKtTSj9Ew4u
         dKAt0zX4YzEUrqtg+kqAMc7YagV49Pbk+iXBavQDKbsl9veyNC8PvGUJwfKTb8N+yXiE
         oibrCgreVt+aGbqoI55X2vfsD40rfiIx6nxNl9wQ45VKpmW0sxK4mKRVTshyPzxgLqe5
         MMyzPHLfKEm5IhIDg5euTfEy02hXaNZtL9rFKCU7zTOB0nHxeOvgx96ibv4ncOWYHP/r
         y5lQ==
X-Gm-Message-State: AOAM530z7NWAbhSbKKqZILzZnFzYXEf8G6Pu/a0Qeo/SpyF0FXPDva5B
        coq3D0JuUnycI4XZzORYyu0=
X-Google-Smtp-Source: ABdhPJwiu0Oy9zNX7tgghYHN8XIUgnmneBhFkURdp1nM0KBPPhnXGwiVUrfrlUqBDW/LWs7U5Z6Tfg==
X-Received: by 2002:a9d:6642:: with SMTP id q2mr36320198otm.172.1609255527001;
        Tue, 29 Dec 2020 07:25:27 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t186sm9753877oif.1.2020.12.29.07.25.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Dec 2020 07:25:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Dec 2020 07:25:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/716] 5.10.4-rc2 review
Message-ID: <20201229152525.GB49720@roeck-us.net>
References: <20201229103832.108495696@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201229103832.108495696@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 11:52:58AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.4 release.
> There are 716 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 31 Dec 2020 10:36:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
