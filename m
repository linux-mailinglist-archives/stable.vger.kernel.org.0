Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D415413B5F
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 22:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhIUUc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 16:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbhIUUcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 16:32:25 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01B0C061574;
        Tue, 21 Sep 2021 13:30:56 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id h9-20020a9d2f09000000b005453f95356cso196166otb.11;
        Tue, 21 Sep 2021 13:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EOMsRLdmoMaeDR6S/ee7HhNCT9A3nkqMSet3H6BfwIU=;
        b=gNRJKr1QUvsEYEKpR2zpKskgLATjVWdeOjqi89bi88YNfrI+t4vmk6WZ0qO45aTPZZ
         YjfQRblHduJAlEq+AZwek97gqoE6N+GrcEebAPj7KmQLi5R/H85IqzUWQ62jZd3k3uUq
         QF6cn/SyNCEIoabCW+SGa7VbvR4lbSuVhqJ4P3cDFpGgrDwosA9onYz5VfWXveFLbCsn
         qypweYRuqydc/2ye2cf9az9hkRLZIbjYoEl9H6Wqodb+SJ76qL92MUPT93hq6vZlGBxF
         M15jYwJDwpKsSHLCZQ91FEbEl5dRLFZ3eK/8CwahwrN8KIX1voWAjf1ogM2xETaqbYyN
         I05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=EOMsRLdmoMaeDR6S/ee7HhNCT9A3nkqMSet3H6BfwIU=;
        b=TsobN8rivbfhzn0LbnHJSQyqIae37EPF2M+aRzBYthm/MFKryWChJPY/Dc9YVnOK75
         V1hqIBdggrr96RFGvz2mJFxkS7qPYCwxta0DLMVDklicbPOGexO+qVftebsFal05hNCu
         cd1nLL5oezB8hBKQUVUz+i980ckjSoX/j/4QisjBsR5VKZNIYhWIW7oPYMfEUteftcar
         2cMsnZxh+3b/ZMWGcn9wTBEDYdTwDPUpNk2W9EgWiuPTsO4OvoQdFZWoug2Hqm1d+UOc
         NVOmTmKgASh+qziaLyYBXVRi2BBKwwoR5J58XKDJwtOyImNRZyWa8nsdl6O78A+0rJmf
         i2DA==
X-Gm-Message-State: AOAM532xjrmg2oZ21EluzrcRgeMOiUdo3x2sPbP7Cnh2XfjSUxZZqSlb
        z0jrIXWrYT6AehoPIEDzMjA=
X-Google-Smtp-Source: ABdhPJzOxVAWomQrvj1TDL0o+voxYCA31gPVeUog9fx3mJniULGwDWmaCpNua0N1FSTeX5QCr6Z+pQ==
X-Received: by 2002:a05:6830:359:: with SMTP id h25mr6412899ote.48.1632256256181;
        Tue, 21 Sep 2021 13:30:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d21sm22406ooh.43.2021.09.21.13.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 13:30:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Sep 2021 13:30:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/133] 4.4.284-rc1 review
Message-ID: <20210921203054.GA2363301@roeck-us.net>
References: <20210920163912.603434365@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 06:41:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.284 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
