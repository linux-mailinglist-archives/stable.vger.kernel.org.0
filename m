Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A827433FCB
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 22:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhJSU3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 16:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhJSU3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 16:29:50 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98985C06161C;
        Tue, 19 Oct 2021 13:27:37 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id z126so6740303oiz.12;
        Tue, 19 Oct 2021 13:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4gJiVod5N6BKX4OnC8ZdSE4FkABW/4VZ+M2Dy1zOycM=;
        b=a0mPQCw0ehQeCBC8qbGogm54/Tb9aF1N9pRZqzOKLDRjzkgXUKz37hAV4Tsw/eAmR8
         gMwA+LHqKRS9pSIetXJb+eXzTxMKyHyjg223E8ZTraBID35ua5UFHV+mDZQkqD5QcWyx
         7DxFSaZooili18tu+Zil3VGHBxk5+351u8K9+GK8VliGoe77XQIuO3cwsL59st44Clam
         G3ELX7Zcslds9kLhr3a4UlELy5DCpFNQs2Vwi8/RjVZwRISsflM6mmyvUPzAzd8NmKfE
         jhEKNB7ckkwiqX/HR9RfRws/kGWiWVbXKVSZtHWTLDtDfz+KYnz97toCHH+sX4QC9Ugy
         bNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=4gJiVod5N6BKX4OnC8ZdSE4FkABW/4VZ+M2Dy1zOycM=;
        b=ZVoDi/Ux7wNxMG+TLifRv66rrwZQYX7ayH/OQserL42f2ijkvZUj6G3WrB+9WKT/qa
         U19llVomr/kJ9Nl26UkntvCgcsNiLl6eBnvhL7QtS+ZOqVRHTdk3yle1oyY/EEag+WVJ
         TsuCRw9A1mOPG/9qak4/pzyXftTUKq94rKW79fHmXDUR6hOJgrQ9DiPHRN+oTqLXT0Hk
         Eu7N53tQP126XkQbhkG95jAp7rZbsxY3uF6QGUSZdzsO/k8PoMveKptXgJGwrn8NLp1v
         vPWG1EdmIvkyvvYrWMxW0iv6+TyZh6x2gOdBS1hJWOtWJ6AWkhBJ0Kj/MNyM5ao0AsDy
         807w==
X-Gm-Message-State: AOAM531IvOLPYNYsULY7xpGHDcOc6YKmY6tOOQZx6BvZmFSU78uXHoYi
        BtcIiNcdEzXa83CFybgMlKf7zUPBeLI=
X-Google-Smtp-Source: ABdhPJxoG0XcLYlnx7GD3uM6JjwUmuk/NN/ZCJ05vEsfrblu44uZ/SgPs22fxvF8wj3cepKY9iM7gw==
X-Received: by 2002:aca:ac0b:: with SMTP id v11mr5962742oie.155.1634675257077;
        Tue, 19 Oct 2021 13:27:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u15sm34867oon.35.2021.10.19.13.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 13:27:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Oct 2021 13:27:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc2 review
Message-ID: <20211019202735.GE748554@roeck-us.net>
References: <20211019061402.629202866@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019061402.629202866@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 19, 2021 at 08:28:35AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.14 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Oct 2021 06:13:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
