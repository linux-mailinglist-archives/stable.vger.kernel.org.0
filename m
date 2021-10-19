Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EA4433FC3
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 22:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhJSU2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 16:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhJSU2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 16:28:09 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B11C06161C;
        Tue, 19 Oct 2021 13:25:56 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id x33-20020a9d37a4000000b0054733a85462so4535265otb.10;
        Tue, 19 Oct 2021 13:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VhHg/zystaxqO7ZQN9/1loEzoj9H+qXHQ99OtTl3xYM=;
        b=ZRn2qES35l7hFJ9KVWAwdicDYLnBDf5sZLXiZxyyGRciiOBOSqJm/jlrZAlz9i7vNV
         lzK9+CCzZWrV1uVCdNLtW/1dQx6fiZvcnAXMbTUQz3UBFXm3v8Ng4Q6WeuqrLSd2CXij
         oItwZIo9JcDcp1uYxe/xHpbv9AjRcW/ZPokGQJeRbpyPXLZ67vrVyC+DrPCChq4Foz9y
         Q3daHBIRBQNP49bgP7B3lzLY8tkMY5PIGkIZ5J7IKb6c4B9KUHFXj3jI7acMyExYWOkm
         GYX3Zud3QTti9hscdRCjLhtfsXH1LtNAZySG1d220lrdJClYsuolMtsH0Rc0pis/SsVj
         s8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=VhHg/zystaxqO7ZQN9/1loEzoj9H+qXHQ99OtTl3xYM=;
        b=o/4SOh8gxJwf/VMONDATn+YcISr5F1JimJKI+kypD1tErGbFViAcU28bQ19u7UaWJP
         sfoJjxYv7aLW0WIZ2ZDTFOJk43krKcLVN7oFC1TZMt7BWzov++Vs9ha65xjguVSYop0W
         /xRGbHU/D+oCKHEX95yzKY9FwOjP0fGPmJO0msL/uf5yTv8CFZt1ATdoVM7KzGM8QcAO
         jQkdnzatkyY1JGW+YKFkVg/BZPhh4TKEAgd+3/93/sxhzQwQiaLB1wuYmzTShhoqz7mv
         Nl9NUdevZDLGdUS0vsHgWkR+miObbgCtQEq4AyQV97JbW1iJ3FzcwjEskBMv54uxiTqQ
         sImw==
X-Gm-Message-State: AOAM531LSk0j94eA7tBhOLat6S5y5eImUlAaDOTivvMp8NW62m7mMzki
        zv8hyMHXfLmVRyupSBZOwdk=
X-Google-Smtp-Source: ABdhPJzZGNqdmQSSSs7HB+g9eJDdOaZjdx/Y4wYI1igPngqflJRpWjFNnjmnfGRoGcnkJv/ONBIMyQ==
X-Received: by 2002:a05:6830:1ad5:: with SMTP id r21mr7022193otc.98.1634675155699;
        Tue, 19 Oct 2021 13:25:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s206sm14580oia.33.2021.10.19.13.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 13:25:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Oct 2021 13:25:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/49] 4.19.213-rc2 review
Message-ID: <20211019202553.GB748554@roeck-us.net>
References: <20211018143033.725101193@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018143033.725101193@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 04:30:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.213 release.  There
> are 49 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 14:30:23 +0000.  Anything
> received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
