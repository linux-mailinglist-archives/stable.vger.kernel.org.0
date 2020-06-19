Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D213820179E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395456AbgFSQlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395247AbgFSQk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 12:40:58 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942A1C0613EE;
        Fri, 19 Jun 2020 09:40:57 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a127so4634207pfa.12;
        Fri, 19 Jun 2020 09:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=tK9/l5H5I2sTPevnihsYJcZkrv1LSOpcELI/uX/XwnM=;
        b=Gn+Wk7/5sTWAqofkCiPolMYZnBQZifwoKtcHe2UC2scyMeIXm+YWmMrqpUDBDqFPM1
         xzDt9IcRE5lQfW84J6ulLB6TnyTbp9FHJRDgjuI6cl9W0t74Am6zQ7XTf6tzjqqi2rS8
         ytyZs2EtA43939hhnhXKpHIwJncgqaJj6SkSStuc5ZtH9Cy53zmC9bK6RhTR/AovJwO9
         sAS7o8M5GjlFyfCF5LKrY2qcAVEAlaDR8HJlDcNfJyiGjfTi3oBBXXup5VQEUeEpo5NW
         wK8buIXjjdx5Bi6caSg8kIZ2oUVRRM67qJ22fS7pB+zSXXTTBzr0MV73/G3PG0k3SM5j
         i1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=tK9/l5H5I2sTPevnihsYJcZkrv1LSOpcELI/uX/XwnM=;
        b=luRDzdKr2GrEx4vPKHNLJk6USn0Z505pTa3ZHUXsLzGoKS6uUIi/Gu9p7k8oP0CJCK
         c0o83rNtqkMFKSYlE4b8P9FH5vIOCbNdxOORsugB/39n7O7TtJyrlo+kbpQgTG9cPszA
         XdtjxeuxuHJ81EcHnYM0c6wZR7OcSFcmXDhh2RGnlfLMX8goYDyuuvMTxm20+f66BYau
         Ce8MIuJXpMyTHPjDpe5SsqkIyTGVmaVulL5B2RFzfCAWa5Y2M8lakAHvHkDnJQYuqPyd
         IaeDuQklqtGC5tTD4KybMUkt/OqzP7iiGYIydPnjUJU2MFmOHZdcXtwKtlKkQoZ+76ZD
         SQkA==
X-Gm-Message-State: AOAM5307Cgetu5WJNm0+MJlRljBBTXiBD9suXYp/sw4O0nfoTUKXJ0SB
        IimR/GlZ+dvvi09IeKiKDfo=
X-Google-Smtp-Source: ABdhPJySYS6ppZ6SN/Log6IuGG9g198ColUeqelRPBwAVsrus3az7JAO+uah0Pq1wfGMMLSMb0P8fw==
X-Received: by 2002:a63:d40c:: with SMTP id a12mr3767238pgh.124.1592584857179;
        Fri, 19 Jun 2020 09:40:57 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9sm5568325pgg.74.2020.06.19.09.40.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2020 09:40:56 -0700 (PDT)
Date:   Fri, 19 Jun 2020 09:40:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/101] 4.4.228-rc1 review
Message-ID: <20200619164055.GA258515@roeck-us.net>
References: <20200619141614.001544111@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 04:31:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.228 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 

Building powerpc:defconfig ... failed
--------------
Error log:

drivers/macintosh/windfarm_pm112.c: In function ‘create_cpu_loop’:
drivers/macintosh/windfarm_pm112.c:148:2: error: implicit declaration of function ‘kfree’

Affects v4.4.y.queue and v4.9.y.queue.

Guenter
