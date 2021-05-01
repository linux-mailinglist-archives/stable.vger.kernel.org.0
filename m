Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5177370758
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 15:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhEANOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 09:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhEANOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 09:14:43 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15C4C06174A;
        Sat,  1 May 2021 06:13:52 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id v24so925837oiv.9;
        Sat, 01 May 2021 06:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WE2LZk88g7cAjNRmdFqSXmvtS0EVPIx7W0c6FWNGtdc=;
        b=aYct0YV16DHT7m+hqVEjVqk4fn/3EbsecIEJDwAYcexDLMGzTr4/feVXW9nEtJYwWR
         mTuZIH6I/aS2Ke2x00fLRiv+8xBuEFUql6dFJ4BJg8fJAf4jxJhvG2nxAtIfQ2Zt189i
         dYSWZgJaiSRFuVkhnga651/CVI+1z+IEzZhS3KTcJc3K8oL6CbTu/P8qGIOSy4KJ526n
         JKVgHeMqjCjoHWf7qdHO/qUx3XpsMJCyHWH07ZQUK6q87XrWm5aCX04bJgLpur/aLZ2p
         d0e++EOUiBnQW0688xh5ACHTtM/IK1/nfXkeXFj9HVFxzNYWyvCKi3+StoPmXsubHVeU
         BK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=WE2LZk88g7cAjNRmdFqSXmvtS0EVPIx7W0c6FWNGtdc=;
        b=su62z4VeWApexC2s0QRKOxVIEug67hjBxfy9L585cvvbfLMD5f7mGHCcm28phciEks
         7E6aLOiruwNMgebQpF6e8/0Crzk5MQ3xWOrAP5thbNo4jwKqmKhc9xYkaM5Kg+rXf4EJ
         MCRe2k+PgVjooNcGbnGtJAXp/NOFCcOb0V3Oc8os62JYKQcyu3F39GgcbB5VR5OcpqWb
         76FhXaKsxKDrwZ/4dHh7p3WmV3ohslpfpfsjCJ7uXIeAQymp0vOmy/Hs0+PmcopIUVaC
         gLEE5V2Ch8+oXfGerzqpkFupsVu0Hr5DuBbOXOQLiJ14k9qDbIFcOr9mQNDiL4ABss97
         z9lQ==
X-Gm-Message-State: AOAM530OO4vnbfuhD3G1BhKQTRgKeCFlfrb6NDD6wFbNiIsWvS71h1/W
        e7KojOVfhDIUTokVr+gWF10=
X-Google-Smtp-Source: ABdhPJxkGeWUYtEsv94btkmlKTOkvDCMnWUhxwLJRdBuI64/BtAYhSMdd4tS5J04EqXvBAx8t74dyw==
X-Received: by 2002:aca:c30f:: with SMTP id t15mr1296670oif.145.1619874832288;
        Sat, 01 May 2021 06:13:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m13sm1413120otp.71.2021.05.01.06.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 May 2021 06:13:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 1 May 2021 06:13:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] 5.10.34-rc1 review
Message-ID: <20210501131350.GB1774517@roeck-us.net>
References: <20210430141910.473289618@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430141910.473289618@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 04:20:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.34 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
