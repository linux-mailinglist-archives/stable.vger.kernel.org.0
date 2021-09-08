Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58704403222
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 03:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345213AbhIHBVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 21:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhIHBVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 21:21:36 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73232C061575;
        Tue,  7 Sep 2021 18:20:29 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id q39so934987oiw.12;
        Tue, 07 Sep 2021 18:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/rZ4nnKkZgCgbDc43Bio1ZW69ZAqGdUK21F+/D3NTzU=;
        b=AIJdkr0oicrGkTGXphy/Ng7FXpM1QptqZJ9bc/kQnsu4YLBh5hs62LugISSBJYoqKm
         rd8q1kUSw1rO0DCjULP4BtJodJUYxyfD2xCopA5p1PjRg0fBrbylUIadMQc1BovPqKh/
         cxFT8BynG1Ix5bcLl9yKTEFfct4cLbEUEsQrBauDAf3jBl8Je7eEOx2satSWONDbAAEa
         1F98rPIZymxuwRlhxDYgolBe/TbnmEiFRsxVlLjqaE6AoUiX7LhYF6kc64kU21Hv/Wb3
         IwT/RM9v7gJzo+uYY1CcNI0YJB2m0NMjVo0lt6V0QMwiD4+lW2Aas6Bnwf4WYTGCrm+b
         IOtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/rZ4nnKkZgCgbDc43Bio1ZW69ZAqGdUK21F+/D3NTzU=;
        b=Vwny4RLs3K+KENdkSEE5qEXzQ9B6ojI+kaxhnx4WQI61mQxx5kBIUmp5KThfGeBcjV
         dgazNSW8r3QX5rH0b2lvGnJ7J8f1zweeMHYKw5OP1VyYw0vu2K+2a/3GxzDAnNnchRa7
         O6Gsog6s0A8qQ3o1gjJifZp6+orz+t0dDWkIX5pUmtBCmDhg8Ne6OZIOhCTQmK6tmBc9
         5fbQf4xiRPVSeyJmMN0AKRCy5X8Dfw/pULUGPRmteuLMMJJ/N92vfCNtF6XmKuLU/DuZ
         4/bVnDcarkxgMaL/u6h8ljq3o4mmzD4AOt3GIuQYyeZa3OVIcrYvuLmFiBwqt66Hwcqk
         VdkQ==
X-Gm-Message-State: AOAM532v6u+2NUVQAC9LRPowOGQRjfyBPjxZ0jIfMYV0Y3f12NQtI0un
        dGYvBakTsLtCM9jidGo9rRM=
X-Google-Smtp-Source: ABdhPJw3rSZDWP/XfPAYFabefoET+kkfq/KaX16JVB+AAoFr6mVS9ocNWDeYRercW5tS5WVcV1ljqA==
X-Received: by 2002:a05:6808:cf:: with SMTP id t15mr739636oic.108.1631064028825;
        Tue, 07 Sep 2021 18:20:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s198sm162745oie.47.2021.09.07.18.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 18:20:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Sep 2021 18:20:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/14] 5.14.2-rc1 review
Message-ID: <20210908012027.GC2310006@roeck-us.net>
References: <20210906125448.160263393@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 02:55:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.2 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 479 pass: 479 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
