Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5CFE72293
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 00:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731824AbfGWWqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 18:46:52 -0400
Received: from mx2.yrkesakademin.fi ([85.134.45.195]:63202 "EHLO
        mx2.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731702AbfGWWqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 18:46:52 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2019 18:46:51 EDT
Subject: Re: FAILED: patch "[PATCH] btrfs: correctly validate compression
 type" failed to apply to 5.1-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
CC:     <dsterba@suse.com>, <nborisov@suse.com>, <stable@vger.kernel.org>
References: <156388330112473@kroah.com>
 <20190723121955.GE3997@x250.microfocus.com>
 <20190723122817.GB11835@kroah.com>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <7b2be0ce-1dbf-3579-0d6c-764c6c6da7fe@mageia.org>
Date:   Wed, 24 Jul 2019 01:31:46 +0300
MIME-Version: 1.0
In-Reply-To: <20190723122817.GB11835@kroah.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C0209.5D378E5B.003C,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.195
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 23-07-2019 kl. 15:28, skrev Greg KH:
> On Tue, Jul 23, 2019 at 02:19:55PM +0200, Johannes Thumshirn wrote:
>> Hi Greg,
>>
>> please try the following:
>>
>> >From 9afa2d46ecb511259130eb51b4ab1feb1055d961 Mon Sep 17 00:00:00 2001
>> From: Johannes Thumshirn <jthumshirn@suse.de>
>> Date: Thu, 6 Jun 2019 12:07:15 +0200
>> Subject: [PATCH] btrfs: correctly validate compression type
>>
>> (commit aa53e3bfac7205fb3a8815ac1c937fd6ed01b41e upstream)
> 
> Worked for 5.1.y and 4.19.y, but not for the older ones.
> 

It applies to 5.1 but it does not build:

+ /usr/bin/make -O -j12 ARCH=x86_64 -s all
fs/btrfs/props.c: In function 'prop_compression_validate':
fs/btrfs/props.c:369:6: error: implicit declaration of function 
'btrfs_compression_is_valid_type'; did you mean 
'btrfs_compress_is_valid_type'? [-Werror=implicit-function-declaration]
   if (btrfs_compression_is_valid_type(value, len))
       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       btrfs_compress_is_valid_type
cc1: some warnings being treated as errors


--

Thomas

