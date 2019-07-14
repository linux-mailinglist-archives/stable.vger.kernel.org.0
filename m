Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7307767D80
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 07:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfGNFeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 01:34:19 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34945 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfGNFeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jul 2019 01:34:19 -0400
Received: by mail-io1-f67.google.com with SMTP id m24so28911720ioo.2;
        Sat, 13 Jul 2019 22:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hXh5ozn74UN4XShEgpOQmsoJF+KG3lfR0vzGIYzOL6s=;
        b=pFO1zgjOmiZiFIfX4piXBvSxDJrFr5YafzNr5HTnZ+HdIgtNt4cIbQ4gdKwQNcHWsd
         Ok0iYCEiDxbaBqetJUHE26ewW+2PYGUm2ca8B8v4IDoiWmrBjIi8/v9YiP70T78rmM6d
         pAB8L59+ZORg160CFJ+X//2L7mmVaqKAlgNs3IRh9B9Cn/ybu2ZZUQe4xCu755HXVLen
         rd2pKsjeBz5SOaVkpT4TecB3m5PFyhGRuuJmlp2xvtxODP4uTNIlO+egr138cmKmldbU
         s/qoo5Dv/vCmC3zJ7BMOpJmLY1fKm3SKxNHtVGnUEF9x40xjlX70EQMEcysJyMkVb67j
         mmZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hXh5ozn74UN4XShEgpOQmsoJF+KG3lfR0vzGIYzOL6s=;
        b=G9AUcBEdo1bYczKIt6TZHVqtCfipAQwm12+AA7NrT2jclLIaAtr/c1eAQpqHxHaIsO
         U8ciiofH9DEWAym3/ocFfJJXmGSppQlt/f/6m2mx1qa5by2j2rZ4NEA7PGTggxh0FVgX
         GGzXfJQIibq+afcath5u4d9h/f5TzxPSSx8yMAT3Nll2GHO82+GpEOZ8VoZeqjjyDKNy
         KirxKVNsWjQbWd2uDOUX+GFL4nIKGY5kN7tjSZS1sZdmA/Q+0aF1yfsl0AxramzD+E7W
         MzyYu+ISloOfHalw+H2Lm0czF1/WtvHdJIRr96pQahcSLtsEb832v5r8egVffe7s88i3
         lCIA==
X-Gm-Message-State: APjAAAXrOEwi83w6gXX7IbejZKSyx6ljd8mmL9Id08+KcIoFLD4hEcyB
        unaTy8alt2Ze/+XTfRvhPtZXCC7sAbINzw==
X-Google-Smtp-Source: APXvYqyhODjDVvOHrF+myPaHIjjWaMJFt7PbHKAQh5Cgj2ZJ0cPYzxf0lOhaB5LmxFnlNs+CRF1khw==
X-Received: by 2002:a6b:7311:: with SMTP id e17mr19998203ioh.112.1563082458534;
        Sat, 13 Jul 2019 22:34:18 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id q13sm12271158ioh.36.2019.07.13.22.34.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 13 Jul 2019 22:34:17 -0700 (PDT)
Date:   Sat, 13 Jul 2019 23:34:16 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/91] 4.19.59-stable review
Message-ID: <20190714053416.GB2385@JATN>
References: <20190712121621.422224300@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 02:18:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.59 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.59-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 


Compiled and booted with no regressions on my system.

Cheers,
Kelsey
