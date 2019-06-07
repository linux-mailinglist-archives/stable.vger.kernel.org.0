Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D603924E
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfFGQi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 12:38:26 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46322 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730405AbfFGQiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 12:38:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id 81so1479874pfy.13;
        Fri, 07 Jun 2019 09:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MQkj88cRS6AP6/tix2FC3GOvlZjHPO4dFfILhw3AJ+k=;
        b=CucTO6OUpir82hdgp6VjpNbYGiAkUHxDL66gpk8vf1h8O0TGtsLNdWqYZYMtHsYICS
         311j53pbwH39VCN4yupZB4PS2bLDcAdwCaeGjDPq48pKC76ydhv4p3Q9TUKfJH0mqkw7
         5eAqFykh09zYXzNHBzERZH+ZwBBIQNKrJeeODHY30gNtw6epHsjZiPUav/ERf6ulUOhY
         bm0ByOG8oTxiVr4k5RotVkeGMht1Q1LlrLetuP+v51AvHeT6eEmSCN2qHUPEUSkCDgDb
         mgkYm1kURcO1OJB1bLB1t39hNU13JIHELGQe57hCNzjSEJ4NZKl8uatDnmRN0VTJnYwX
         0YhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MQkj88cRS6AP6/tix2FC3GOvlZjHPO4dFfILhw3AJ+k=;
        b=jBMcxa09qU9wLQFoExFARhEIjhBOrEeZPCU7+UFX6xEhycC6PY+MgYmhMcpw8Qid3n
         fF++/16WUVNXFLZtkMIu7lreyX7W6liBqmqwUlDSJ57y1xZLLelabbVAa4s+laKmr5NU
         HiIc9cucVfD2lws139eFlmsWsfPawHHbVemmVbIdqLfQTOH8negrdsbhw4rETrB8qtUy
         ZTmmMM8Gf6d4tf4ZdtxX0CqtE5DO0RJWnxZPIVtvseKCq2xXoPJ/zqIc7hOb0GiKenvA
         l2yOc7GFcLse1SgxC6FPIVWBQlfnQIk6Jr2zeUt0Vwxr6aujvsu5OhAC3Mx8OW7/r/DU
         ZsBQ==
X-Gm-Message-State: APjAAAX4SmpZQWODFkASi/y1y2kIBooeWO8kNKOkIlE8s64l3tTl8YJB
        vtCSkZ90UaV7nRnmCEfHDxQ=
X-Google-Smtp-Source: APXvYqxhMpMSA3VcpiPnVYAOJlxmWp5SyuwHgtlRdUyVvE2WLevWQ1qs9AGgaVDQ1ONKWJAEg30cbg==
X-Received: by 2002:a17:90a:d587:: with SMTP id v7mr3794545pju.28.1559925505327;
        Fri, 07 Jun 2019 09:38:25 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p65sm6082894pfb.146.2019.06.07.09.38.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 09:38:24 -0700 (PDT)
Date:   Fri, 7 Jun 2019 09:38:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/69] 4.14.124-stable review
Message-ID: <20190607163823.GA3922@roeck-us.net>
References: <20190607153848.271562617@linuxfoundation.org>
 <20190607161102.GA19615@roeck-us.net>
 <20190607161627.GA9920@kroah.com>
 <20190607162722.GA21998@roeck-us.net>
 <20190607163203.GA14514@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607163203.GA14514@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 06:32:03PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jun 07, 2019 at 09:27:22AM -0700, Guenter Roeck wrote:
> > On Fri, Jun 07, 2019 at 06:16:27PM +0200, Greg Kroah-Hartman wrote:
> > > On Fri, Jun 07, 2019 at 09:11:02AM -0700, Guenter Roeck wrote:
> > > > On Fri, Jun 07, 2019 at 05:38:41PM +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 4.14.124 release.
> > > > > There are 69 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Sun 09 Jun 2019 03:37:08 PM UTC.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > 
> > > > fs/btrfs/inode.c: In function 'btrfs_add_link':
> > > > fs/btrfs/inode.c:6590:27: error: invalid initializer
> > > >    struct timespec64 now = current_time(&parent_inode->vfs_inode);
> > > >                            ^~~~~~~~~~~~
> > > > fs/btrfs/inode.c:6592:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> > > >    parent_inode->vfs_inode.i_mtime = now;
> > > >                                    ^
> > > > fs/btrfs/inode.c:6593:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> > > >    parent_inode->vfs_inode.i_ctime = now;
> > > >                                    ^
> > > 
> > > What arch?  This builds for me here.  odd...
> > > 
> > 
> > arm, i386, m68k, mips, parisc, xtensa, ppc, sh4
> > 
> > It was originally seen with v4.14.123-69-gcc46c1204f89 last night,
> > but I confirmed that v4.14.123-70-g94c5316fb246 is still affected.
> 
> Ok, let me dig into this after dinner, I think it's due to the
> timespec64 change that happened before 4.19 (where this error is not
> showing up...)
> 

Quite likely. Note that more architectures may be affected - I don't build
btrfs for each architecture, only for architectures where allmodconfig
is error-free and for architectures supported by qemu.

Guenter
