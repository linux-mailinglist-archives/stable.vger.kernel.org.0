Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C3311D54E
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 19:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbfLLSYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 13:24:12 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40324 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730295AbfLLSYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 13:24:12 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so950481plp.7;
        Thu, 12 Dec 2019 10:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8V0MqislrgIEPXg03AiDA31mmNiTOWAAHSaZkXEsPkI=;
        b=BEALUpUEueQS9sUqxtzOM8IrQz4kkHHKej2n+zdnPjAKIet6L8tTuKJgF/+BYDDbTJ
         /+DH5Vj150vRxe5excS+Sa2g56wjwE74XRmOl2LJdGbQ/Oj7fpq8cMHJQ5lUaAgFuBEv
         kbBsMaGydKn1DI8ueGoUAZL9IcDfYVUhtRJZhdEI+5GqIiAbLC8f7nRC48G+FAGMvt1q
         OxYS6445mneP/hbPyrwJbTi55udKhxGrUQ5rSGY6ZqbY51Vm9+b0erj5/hY6VSGPh2/j
         h2QXR3kC5GLLWSgITZ0WqFxbGDXXOK7KmQAdzhXT6VeqAywDTAIyk1tQEsPnBjE409c1
         wrrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8V0MqislrgIEPXg03AiDA31mmNiTOWAAHSaZkXEsPkI=;
        b=RtvpFW504ieR+XVI19z99irAaKzaoFQmX5sK7SF6vJG61dF14NDjMJOa147I8NG6I3
         EpjbRc7q4+fksAiLCmAEorzb/HyIXHsxSOSgDLvhRH1QfRonS0yrKt9Mi2cgsLv3xJkz
         aymeaoLboaZycak4wTM06U+1sKyUq3RCFvi44p8nX7JJ78MS46NR8/SZgV+qzmqEohhB
         j2NdIfhBjv/ZT3pbmupbbkDbwj3AZdUJd8E9vcdPt4ChwAhVphl3zrqBixaKs0ZCXyuT
         heYnjwK+vlKBrXYK2jK2DjAG/qLU3P5gGi8yqNmwovbZRkuqZXe5PK7mUPcTfL8RgW+Y
         aByw==
X-Gm-Message-State: APjAAAVyeHQ2GkJ+vmHOcCPMXe+UykzLeHd7PDYjOektvkpxAkYQlwFX
        ONdlmSdD+ka7C6+tqoxGQ74=
X-Google-Smtp-Source: APXvYqx2sh3pcI+eVL+/fi/yTNG8iWYBADNU0Rkkd8zkVvmrs6QWFROF71tK5gHBXMRYGuuJiHW3EA==
X-Received: by 2002:a17:902:7287:: with SMTP id d7mr10905458pll.17.1576175051957;
        Thu, 12 Dec 2019 10:24:11 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p68sm8155914pfp.149.2019.12.12.10.24.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Dec 2019 10:24:11 -0800 (PST)
Date:   Thu, 12 Dec 2019 10:24:10 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/243] 4.19.89-stable review
Message-ID: <20191212182410.GA26863@roeck-us.net>
References: <20191211150339.185439726@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 04:02:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.89 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
> 

For v4.19.88-255-gb71ac9dfc6f0:

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 393 pass: 393 fail: 0

Guenter
