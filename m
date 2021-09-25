Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108814184C4
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 23:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhIYVvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 17:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIYVvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 17:51:35 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A08C061570;
        Sat, 25 Sep 2021 14:50:00 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so18457164otq.7;
        Sat, 25 Sep 2021 14:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9R43sqKMqNArGPxo7GkFH99Iy2OkqRu5eIjWoUcTlMg=;
        b=CHheOQJnytgfB+tMXFIcDvk9MFlKZtl8Wc3UkjHKDfxB+14MyWgn/SrOoZiIkAqHAd
         RnEvrEALfSJDhXX9aVMfX8G8r/5PmoRvoLYRsB60B/fUSeOO6xB5n6FgbxtCVc1sx3cw
         rFWUZRfLMkP3gXaGpWl3vhvw6dkF40jBYgqKqDGLlaIOw/ithl7CROs+a1Qr49V7DLsT
         afz1GyVXitqnMYfnJcmmAA8f0CrHgBXaacjE016MKpID/X0qnyvwmzhlDEUjG5Pk8vJ3
         9heLMqzko6kh4+/XFbloxyvO2IEbIrP8BpEE3buSVuPzcQu8MoMS0oFrih1MdzH/pBFB
         BdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9R43sqKMqNArGPxo7GkFH99Iy2OkqRu5eIjWoUcTlMg=;
        b=XEUGNbgA9URfhC1OP5jHEuAZFcxQ6IBPtSUVO8kWJNekBOAWuuyJ3IeorK+VLLE42T
         FxmlI9OS+oOBTLtUFvDSWGPJV2g8vnLMMycerR1EtIlSroDcr6mA1SewJGieOzdXURs8
         XQ7tpsjo0689DABErc6JB6P0tigsErxSa+1RcK2VK6SKvR2lwxUNXbyT7xz0zs8o1y79
         bd0M4h2bKe3C+0so6m/nrA1m2oiH7OdQm7PLPqdrdgXSw4kapxo1JvExPTEGeIM7ZO0B
         gBwX4JenrAtnWuZx9pRQa+/h88KGSk/bpJKUcl5aDbggaOucs5q3fdTt+IVfl4x7cLyd
         pTYA==
X-Gm-Message-State: AOAM5313phny4aRuy3WDCWyLvYj6vuMReeQ1IY6I1o/dipwpGsj2milJ
        tb7uFwq1ig1G/F1ekd3h41A=
X-Google-Smtp-Source: ABdhPJw+3b8ocnTw1PapO8LupPQ5y6ruzBDfUXcEzFukbpc0ZbHK8e+yOF0cShMnTOxXyJu5dthWSg==
X-Received: by 2002:a05:6830:16cd:: with SMTP id l13mr10290117otr.2.1632606599980;
        Sat, 25 Sep 2021 14:49:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e11sm3086722oiw.18.2021.09.25.14.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 14:49:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 25 Sep 2021 14:49:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/49] 5.4.149-rc2 review
Message-ID: <20210925214958.GE563939@roeck-us.net>
References: <20210925120748.206179334@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925120748.206179334@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 25, 2021 at 02:13:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.149 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
