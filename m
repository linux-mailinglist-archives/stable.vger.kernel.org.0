Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5742D6D61B
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 22:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfGRU5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 16:57:17 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40434 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRU5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 16:57:17 -0400
Received: by mail-io1-f66.google.com with SMTP id h6so53858087iom.7;
        Thu, 18 Jul 2019 13:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4MmbYj1+/AMaj2GBR/VxsQbrWisP+II49im3hG9FHtE=;
        b=h7Ax0BbTmiMbBMQf1Smoejlgd98PXiVXF+sOLod9oTXvJuOtnUptkLSV45KTD0JGtn
         VxmMAAIc8eNvuzBwU2HIMOLmTfGYXDABWgfR9qYSvRRjDFHF0ADUaSTtxFxI9XSmqEaP
         fsraH5FzGvTxapwTcvlBkaLFqcucZqhk3PVC0MOP4olODdUJNiv4AIXK+t9M/tAojTP/
         srOkDORT9dDZWss9QgSXwO+pMXrSEiqoqu26ECmM3MrxCIu4COMwml1gZuWk1li3IZdC
         4nk9HN48GwVSQHO0rU5rBiD5lhrmroLQveXP0byQtCCB/0PwsMTKFp4Pq7C89G9CVjY4
         UJ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4MmbYj1+/AMaj2GBR/VxsQbrWisP+II49im3hG9FHtE=;
        b=ndK/9JDSokz2WkUeYIpvnRRDsEKKXLTd9JSZoDoRT9DVnb9b2TmkBe8AtfI8Dy9fSh
         IHP/OSfCeJ9MTVqiSG/oOd82p0/04EvtGcUSvHg5qpWSn9u/2/042ncmn5YMtnyyH0Ya
         OAu0OfLg70f098QkuU1IUztFaCGVECZyKqlOOxCDl7bVjJ6L3XpzMX10u3a72zmXGjt9
         TK04PdeX39uylk0Zu2gdbhSDD1quKgulHbvI1uprc0AId6kBRr+ehpVAhFnsrn0Ks4zN
         4TiycKdDLfYzI+JfqOZ32cux3vA8ljiYXL0JQ+8TnztWt/Ey14zzTOx7dZjZcBlLkR0M
         lNGg==
X-Gm-Message-State: APjAAAXTXoGERscEMclP6LaS/PLU474GGiPBwWEVRdjOLX36mCWNBIjz
        WTJzZDOcmCPzV8JlBtAhn4g=
X-Google-Smtp-Source: APXvYqxfeTarKoVh3bLB95jvR4avyQMXTIedophCzlmDowxUQ7bBTfFS3XHhqnAgFIwZXTxlYoOhlA==
X-Received: by 2002:a02:c519:: with SMTP id s25mr49170743jam.11.1563483436907;
        Thu, 18 Jul 2019 13:57:16 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id v10sm25700001iob.43.2019.07.18.13.57.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 13:57:16 -0700 (PDT)
Date:   Thu, 18 Jul 2019 14:57:14 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/47] 4.19.60-stable review
Message-ID: <20190718205714.GD6020@JATN>
References: <20190718030045.780672747@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:01:14PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.60 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.60-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted with no regressions on my system.

-Kelsey
 
