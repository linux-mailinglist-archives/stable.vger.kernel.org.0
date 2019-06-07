Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDD6391F9
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbfFGQ1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 12:27:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33689 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbfFGQ1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 12:27:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so1500988pfq.0;
        Fri, 07 Jun 2019 09:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XeJqlljc/DcLq2LdbRfl+U/1KHhpI1pBfv141U86JNE=;
        b=Qhq/mLyLAI7Qa/kMeTNNjcQ72HN58L7rQT+3pEMsGf8qr7lbiVkMDxcOlOwsStT3xO
         64KGhtkoeSzULWWdF3jK5PyizRW2chVl8nJMYGm7F/oYJbjzgHsXKTDFGkOwZFmXJnv/
         rID8nW7NexiZ2capUgEyOgcykdsnBJY4ykx02XWkFVvugaXQ+dUmOW/fY1PJy/kmeBmi
         XzJSPiqrtWI0sZ7s0SnKnRSnM60t0FLRlEXFY1c6ElvEsX5M0R/+zTqGzUAVx/4Rx7Pp
         7jiseyNbGSG+kGmfB+5aKDn5/ZdRcQCzIdrrJHKP0TCgWqU/fT7KkoGSXi73bmx8SIli
         VuNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=XeJqlljc/DcLq2LdbRfl+U/1KHhpI1pBfv141U86JNE=;
        b=MClbN61NC5PkfOtmi/+mKYj2RUtHqfo5MSIjCjEZfXU1arlj4SZQN5J82PtUqD5AR0
         UwceuNDkZRgvva+vaAkMNgmrLzZjGlR0sYCMYYZV7ha1SVNTbPHJhSlxngWY7TsWISXr
         Sp/sqVf1jnNmA4uQKK2pZ86MBV1r02915mfHqLlLfxAsilZz8gqusFH9KWyvQDHteKS3
         1DQHVmgdafbug8wb4rUD8PpqOGlFDmgB7554L7mNbpBBuJixY4jruJW/0fFUd4ZbxzI1
         DMfcCSj/9NiqqCOAQnAHmEDJsbwg05ZW3idXsqLEQSqkMRp+5YTu93JIglacDGGFtLgI
         u7tA==
X-Gm-Message-State: APjAAAUDr3A8RRjUo7gWYsi7YEOqQ800B9WoSyF+Ayrw3A77mIgP+xHb
        0+bgeHzOvyiAzwyZSpr5Tqk=
X-Google-Smtp-Source: APXvYqxdYUr51nh4UeWcmVb6oKc95oIfUDQiXlMIvmhxL2RNewwBvTldXS38KcN5oRHmID4SatYnKA==
X-Received: by 2002:a63:fb01:: with SMTP id o1mr3659036pgh.410.1559924844088;
        Fri, 07 Jun 2019 09:27:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e26sm2796782pfn.94.2019.06.07.09.27.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 09:27:23 -0700 (PDT)
Date:   Fri, 7 Jun 2019 09:27:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/69] 4.14.124-stable review
Message-ID: <20190607162722.GA21998@roeck-us.net>
References: <20190607153848.271562617@linuxfoundation.org>
 <20190607161102.GA19615@roeck-us.net>
 <20190607161627.GA9920@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607161627.GA9920@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 06:16:27PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jun 07, 2019 at 09:11:02AM -0700, Guenter Roeck wrote:
> > On Fri, Jun 07, 2019 at 05:38:41PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.14.124 release.
> > > There are 69 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun 09 Jun 2019 03:37:08 PM UTC.
> > > Anything received after that time might be too late.
> > >
> > 
> > fs/btrfs/inode.c: In function 'btrfs_add_link':
> > fs/btrfs/inode.c:6590:27: error: invalid initializer
> >    struct timespec64 now = current_time(&parent_inode->vfs_inode);
> >                            ^~~~~~~~~~~~
> > fs/btrfs/inode.c:6592:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> >    parent_inode->vfs_inode.i_mtime = now;
> >                                    ^
> > fs/btrfs/inode.c:6593:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> >    parent_inode->vfs_inode.i_ctime = now;
> >                                    ^
> 
> What arch?  This builds for me here.  odd...
> 

arm, i386, m68k, mips, parisc, xtensa, ppc, sh4

It was originally seen with v4.14.123-69-gcc46c1204f89 last night,
but I confirmed that v4.14.123-70-g94c5316fb246 is still affected.

Guenter
