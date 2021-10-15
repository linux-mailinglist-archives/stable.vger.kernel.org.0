Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844B842FDD0
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 00:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbhJOWIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 18:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238804AbhJOWIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 18:08:40 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CF7C061570;
        Fri, 15 Oct 2021 15:06:33 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id r4-20020a4aa2c4000000b002b6f374cac9so3438525ool.6;
        Fri, 15 Oct 2021 15:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/oaU908hhc7U6BBlkmnzGRWurUNJSAN4tyFvibsz6qw=;
        b=eOXv2pfNecTdThd/7kyiCYiTS5CPCAW+6J1/HzZmeplpQDpfQSo34JbV4dlUKlMGO8
         CwFUfppAF4bRLKzbkyBTpRKFsSWV2V+0nTd5TKNih8E06t7MYvANFh1gkiuAT+mclLyv
         +uzs94RmeQoOMvGcxd3plTkf0KfFxYDZmnHpSfDiL7jLz6zzcF3aC8S6EHhPh+gXRRO7
         eDXYoygw8cIPsQ9V2hiWg7P4Ck7JXriF3yorj7f6nhHq1ebo/iFVBDsdb5EBBpb0763d
         UUyAxFYFoaDUt9CiZsxvemfo8vIE9DFUkUMnscElnxEPJmsqmsw/ZurxxEWTXM3Fyyr7
         9mjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/oaU908hhc7U6BBlkmnzGRWurUNJSAN4tyFvibsz6qw=;
        b=3S/YZGgoiwxmzn1kb/dPKK4+Bj9eVKMOsALDokRNvQwPymXCfMXHu/Sbl/FEpCHdNu
         6LJ31kfqcAyzT0l6Jneu1X5VsDm6QflLTq0sSCKa11mkRgVbX8+OGV3hfi2Qa3wcOFp6
         5SRFDnRUsmhcOeUDydTYzUs3n5xIiM8ZQEX0UMKVwFD9SveoZSA69euyozjI0a0HNkva
         EpA1+7XS1TNkEJ6oXkbjhDpDo3Zslo3sEJlGkjnfblQG/W1l21nUdG88UuqN+Y2QQsbI
         mtQxW8FIXx9M0fDik5C8snAeqn5QOXoHP8gnRwnZH5qbb7w4JXgU9aAwp+DwjesRlg04
         Mw5g==
X-Gm-Message-State: AOAM532AwvIopWAw/4b4dZm97eIpqPUxjrdYpgEGKR9sJRcAfmPM6G1K
        NVESBlE9b7Ex1wBh1o0bN9A=
X-Google-Smtp-Source: ABdhPJyvPHTf/IPNZP5ke8czAq4lkAjaRE+S8oUiR0ttg4nydX1dcESxwBMqkNXalQZ7Xw3JAnswWg==
X-Received: by 2002:a4a:c883:: with SMTP id t3mr11096278ooq.58.1634335592321;
        Fri, 15 Oct 2021 15:06:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z83sm1494148oiz.41.2021.10.15.15.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 15:06:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Oct 2021 15:06:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/12] 4.19.212-rc1 review
Message-ID: <20211015220630.GC1480361@roeck-us.net>
References: <20211014145206.566123760@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014145206.566123760@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 14, 2021 at 04:54:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.212 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
