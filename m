Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06117732F1
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 17:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfGXPkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 11:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfGXPkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 11:40:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1A8A206B8;
        Wed, 24 Jul 2019 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563982842;
        bh=w2LnAVJmVjzwvphWXyBoHWLWJnJJ96AhTPsV+lxjzck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d1A6aNAggPaAaqfp+gVo03YYWQj/5iZiw5JbqpsGOUVWEN6KCDQ2HGofwrJ3mEoQj
         4MrTh5mMxgP7brJYNkizAeu7lIQCGSdwrRKPdP9ZY1izvIrcwvDzQN/wvfPXwTFexq
         UExhuGn5RndPKGZOmkUYMFbrVuJRogLb8x4T4vCU=
Date:   Wed, 24 Jul 2019 17:40:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: btrfs related build failures in stable queues
Message-ID: <20190724154039.GB3050@kroah.com>
References: <d32a9740-c5cf-8c91-fd39-ba8f0499541d@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d32a9740-c5cf-8c91-fd39-ba8f0499541d@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 08:07:50AM -0700, Guenter Roeck wrote:
> v4.9.y to v5.1.y:
> 
> fs/btrfs/file.c: In function 'btrfs_punch_hole':
> fs/btrfs/file.c:2787:27: error: invalid initializer
>    struct timespec64 now = current_time(inode);
>                            ^~~~~~~~~~~~
> fs/btrfs/file.c:2790:18: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'

Oops, no, this looks like a 32bit issue, let me dig into that...
