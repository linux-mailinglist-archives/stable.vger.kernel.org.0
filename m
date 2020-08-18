Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB9C2488C2
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 17:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHRPKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 11:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgHRPKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 11:10:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E95082054F;
        Tue, 18 Aug 2020 15:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597763436;
        bh=ZOow0+cWPFiK7axgyXoFUv+2IXU185o7iF99pN1T8hw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BUkg4fW85fQwCT2Hnho4bcHBfssxM7vE+U7k3F++6iOVWxhbZrFs9r8mK9/qLJbh+
         A0MEg9eMd0VZxhpaIb9Bhe2CxDS5wlWo5vcfRNoZeMFfSC4lQaJQzj+J8raPuQKBXC
         idX12Vhl1WnyBOlZFHArZwjn2dUF0wu6TRtrcRK4=
Date:   Tue, 18 Aug 2020 17:10:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Build failure in v4.4.232-120-g11806ba5e43a (v4.4.y-queue)
Message-ID: <20200818151059.GA689005@kroah.com>
References: <463ae6ac-b8e4-c447-814e-89ef7bdf1078@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <463ae6ac-b8e4-c447-814e-89ef7bdf1078@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 08:01:48AM -0700, Guenter Roeck wrote:
> Seen with v4.4.232-120-g11806ba5e43a:
> 
> Building powerpc:defconfig ... failed
> drivers/misc/cxl/sysfs.c: In function ‘cxl_sysfs_afu_new_cr’:
> drivers/misc/cxl/sysfs.c:558:1: error: label ‘err’ defined but not used [-Werror=unused-label]

Build warning stops the build?

Anyway, I've fixed it up now, thanks!

greg k-h
