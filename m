Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869EC10340A
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 06:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfKTF6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 00:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfKTF6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 00:58:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 414B0205C9;
        Wed, 20 Nov 2019 05:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574229525;
        bh=p0H6HwLa45oCbagaqqjdkdF/Wd5VpVqr3Nn+QZyA4c8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fW+YefVTZqzJYrUOK+NT0ti/4O2Y4GZUF3pevZh44xhbvuwlX/85UeTGRbROJJlmt
         gGfQqOOlpSOHcltjGArVwZDI3q76L9rXqeXMdG+eEGkarXkOnif6X/hxKZQrtHSoTp
         j6tmJsoRTdpHz35sMgEcFsZI9F8cElXKY4W4YdII=
Date:   Wed, 20 Nov 2019 06:58:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/422] 4.19.85-stable review
Message-ID: <20191120055842.GA2853442@kroah.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <TYAPR01MB22854E4F20C28F3A10DA65E3B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119122909.GC1913916@kroah.com>
 <TYAPR01MB228560FC98FFD1D449FA4EC2B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119154839.GB1982025@kroah.com>
 <TYAPR01MB2285698B8E0F38B9EEF47128B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119165207.GA2071545@kroah.com>
 <20191119180002.GA17608@roeck-us.net>
 <20191119181619.GB2283647@kroah.com>
 <TYAPR01MB22851F2F6D26C0971588DD92B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB22851F2F6D26C0971588DD92B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 08:00:59PM +0000, Chris Paterson wrote:
> > Ok, I've now done just that, and pushed out a -rc4.
> 
> Thanks Greg.
> 
> Linux 4.19.85-rc4 (824c9ada & d0112da1) works for me.

Wonderful, thanks for testing all of this.

greg k-h
