Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF34391A9
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbfFGQLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 12:11:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44592 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbfFGQLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 12:11:04 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so1442592pfe.11;
        Fri, 07 Jun 2019 09:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gOcAoOgUJ8ToP+KuOkuSoSykBN8JQpaW2IEBwzocWiA=;
        b=rLr2K5DiMojbzEaa5Ywy9k6urJhtkEtxIf/Qb6eFY1P3LqQ9Qh8Yv4gF7IopVlNtx4
         EKs9LbyvNh/YH6Ip8Nz2tcEUYljmsuEuNNZAML33Kl3Bdh3cRpZjHPWpmSKR2N84SGZO
         8XNyN0/ofl9BoedI+3OymYbvpAUVY71j3BZ42t4ybwcdXphUOci+QY5CXcADqFykqW2Y
         6JsD8A2QRbAlRxQWJO67AHbHSRllv2q2nbaLB1VIS677IbeMj9s4YJae4M6yMAawiHbo
         C1VPnvbogyAR0mObFI8PpPVUujfDejOsTUGgTEQB2PD4W8/BEKyy8SjdGdvQ/Lgr4wLa
         5EYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=gOcAoOgUJ8ToP+KuOkuSoSykBN8JQpaW2IEBwzocWiA=;
        b=ak2j0KkanEHRbINCG/bDAbS8p4Ey53Ng1lSQ/7cceFmxKJQGpzYV9f+fzBOHvekMpb
         i6+3rAULV7DQIlfjWZFJHF7eaJ/wRo2TCZs41J7k3LrfF6/UDrgmIPJX9xXs4IGVPvoB
         SP/XV2WdxuWO854f+Wu5/N22KdB2T0EG/kvUH8UbDjMHzK6zW37bDfkTiGFaA/MkHU1o
         lWrs/PFDCOLxMlEX1pqa/dZRswB5mBDAKZrbhYXQdCtzGT1Z8GAHdsEEWF7OwlUhE8va
         6SZDGvpQ7j9nIYJfl24WwyZuhfNdx9FgPRxvloNjg6C9W9H5z+lc9GZZLrjydGDmqEiq
         2UUw==
X-Gm-Message-State: APjAAAUT0fWYDE/XTwSdo0Z8mge3pkdVaKJYdw8cTXN8low9uQgGQ3gT
        pUNUeSNv+JkoSEOYd/W/VOU=
X-Google-Smtp-Source: APXvYqxOm0VlI3dITuIPgYNDymmbq9I5So9h/kTANxxFE3KmXn4DO43Jzc03+CMy8gxb+ixZaWIn2Q==
X-Received: by 2002:a17:90a:b115:: with SMTP id z21mr6339628pjq.64.1559923864406;
        Fri, 07 Jun 2019 09:11:04 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o6sm2831948pfo.164.2019.06.07.09.11.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 09:11:03 -0700 (PDT)
Date:   Fri, 7 Jun 2019 09:11:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/69] 4.14.124-stable review
Message-ID: <20190607161102.GA19615@roeck-us.net>
References: <20190607153848.271562617@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 05:38:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.124 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 09 Jun 2019 03:37:08 PM UTC.
> Anything received after that time might be too late.
>

fs/btrfs/inode.c: In function 'btrfs_add_link':
fs/btrfs/inode.c:6590:27: error: invalid initializer
   struct timespec64 now = current_time(&parent_inode->vfs_inode);
                           ^~~~~~~~~~~~
fs/btrfs/inode.c:6592:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
   parent_inode->vfs_inode.i_mtime = now;
                                   ^
fs/btrfs/inode.c:6593:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
   parent_inode->vfs_inode.i_ctime = now;
                                   ^

Guenter
