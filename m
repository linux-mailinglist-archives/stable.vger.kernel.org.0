Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001A52EC2F9
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 19:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbhAFSIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 13:08:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbhAFSIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 13:08:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8621E23130;
        Wed,  6 Jan 2021 18:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609956471;
        bh=QLVGM+c+i30uk6Vw3Qq+VDDASLEBhRWK8PFwyTKRT4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FniQHU+ZDsQz2wozZTjXPDohX15sJk617NdwmGwo08jynY4op6Rmyq3ntakbL3qRc
         p+Z/RXX21YqtwGjE8cijxilnWafp7MMiBG3YisqQlDb3hSE+COhoRAIl1iUks+xW/v
         rZ7icnLPwmEOIhoN6EP64dll7zDL9Md2SnI4Upuo=
Date:   Wed, 6 Jan 2021 19:09:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        doebel@amazon.de, aams@amazon.de, mku@amazon.de, jgross@suse.com,
        julien@xen.org, wipawel@amazon.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Backport of patch series for stable 4.9 branch
Message-ID: <X/X8wP9A8OvCXPuz@kroah.com>
References: <20210105110142.1810-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105110142.1810-1-sjpark@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 12:01:37PM +0100, SeongJae Park wrote:
> From: SeongJae Park <sjpark@amazon.de>
> 
> SeongJae Park (5):
>   xen/xenbus: Allow watches discard events before queueing
>   xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
>   xen/xenbus/xen_bus_type: Support will_handle watch callback
>   xen/xenbus: Count pending messages for each watch
>   xenbus/xenbus_backend: Disallow pending watch messages

Now queued up, thanks.

greg k-h
