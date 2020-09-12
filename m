Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1CA267734
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 04:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgILCSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 22:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgILCS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 22:18:27 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD77C061573;
        Fri, 11 Sep 2020 19:18:27 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id m7so9952327oie.0;
        Fri, 11 Sep 2020 19:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g1rpro6Guurnjv1/qA2cuByEH6uwrEsWofCSBhmacnc=;
        b=kve6WalY6lFoLIxJwh6HeD2fnqhykafgc6t8LbDh2vB0+zrcaWSNzG/7m/YSRky5ss
         j5q/NL5PaBeDu6+mtRsceRhAx+O+ylv/QmadzmJXVzapyx8ED+kHvyH/VKwRmrpsGrZo
         xEQS73GXOQxQuPPAz+gr2pTkYwM+sio4jvdwMHAYmgUIbu28yNUtOs5No+aiW9lMVTnd
         Kz4i+SGPp46ayox2SJfuTSzZg72LqS5SnAaA5WFp9a3DW1h3+QisUdNZY47q0YTIA7fI
         ObOlzORystnNfPtsZKNDip9/rxWfZUD34djQTp4ynlYzk/O9gV2ZzTVfKfRDq8rxmEa7
         NLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=g1rpro6Guurnjv1/qA2cuByEH6uwrEsWofCSBhmacnc=;
        b=ox2eSBvKu5Zn28tvPy8bDoZuog/4JecTz5p5Qimlvm9TSmh/sdC+Qnf9+Q8XuM4god
         1tGnGjloJLC6uSNBLqHf7JDrZgibid+HFq7Zczrq39pbqHPQDoURKXq4NG8bVGrmfLW8
         +nrPyyMbid/IXLI+5YJdQN8qAEjx0pQcHtKu0WG9JKLir3/6A0QZj5eU6sodpqPhLQCS
         JiSCg/GfqIk0dDLZoekzIUbsfe9xiGADrnJnhGnZuP6hx9v56lIZ7xw659j/XQNH1PLy
         UZ1zzgXNbuE7/dS8DdGn+iEQR+GNVD5rhP5hO0nXKS+myPek/sP3QLB8aVcfjot6lB/W
         Ud1w==
X-Gm-Message-State: AOAM530Z24fJoLUSgdpt3mVyW4qbN+HBUsJYFWOj6WEXJ/n3lozN4uzF
        ucNFaHRXhVeKEjACwdsgnU+KABELQkU=
X-Google-Smtp-Source: ABdhPJxoJI/UHoMi6QYJvkMSX4ubOknrzhwp9Mvi3v18RGyKDywriLm0S/gUGBGet29yqHKNIFcUSg==
X-Received: by 2002:aca:51cf:: with SMTP id f198mr3051604oib.107.1599877106530;
        Fri, 11 Sep 2020 19:18:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c15sm608822oiy.13.2020.09.11.19.18.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Sep 2020 19:18:26 -0700 (PDT)
Date:   Fri, 11 Sep 2020 19:18:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/12] 4.14.198-rc1 review
Message-ID: <20200912021825.GC50655@roeck-us.net>
References: <20200911122458.413137406@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911122458.413137406@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 11, 2020 at 02:46:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.198 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Oh, and I keep forgetting the formal:

Tested-by: Guenter Roeck <linux@roeck-us.net>

Please consider that to be given for all test reports even
if not explicit.

Thanks,
Guenter
