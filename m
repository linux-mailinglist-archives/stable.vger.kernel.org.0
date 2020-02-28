Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223C9173653
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 12:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgB1LqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 06:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgB1LqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 06:46:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76579246AF;
        Fri, 28 Feb 2020 11:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582890380;
        bh=IqWORuvjShs52812sa/y8+8yU05fXm8CGxo3EhMGqy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zfE1XvtP4n0ILzEARIXXGrlw0pMXuh8UlBeVhy1RUVU7GoyfhjCldwuiFOWIo8g65
         llhHq+1CD+F8m6a6JQjor9eVlj47LNZQz+z72XlZx/nH4HKt3QxzBQVn4AlmUN+6G4
         ZwkpNlGpowCr02lf3X0iIGFTD9e+bTesk54iRwRQ=
Date:   Fri, 28 Feb 2020 12:46:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+59997e8d5cbdc486e6f6@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.5 027/150] vt: selection, close sel_buffer race
Message-ID: <20200228114618.GA2918666@kroah.com>
References: <20200227132232.815448360@linuxfoundation.org>
 <20200227132236.840520753@linuxfoundation.org>
 <a9f43287-d504-170b-4444-503e4b0d59d5@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9f43287-d504-170b-4444-503e4b0d59d5@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 07:54:35AM +0100, Jiri Slaby wrote:
> On 27. 02. 20, 14:36, Greg Kroah-Hartman wrote:
> > From: Jiri Slaby <jslaby@suse.cz>
> > 
> > commit 07e6124a1a46b4b5a9b3cacc0c306b50da87abf5 upstream.
> > 
> > syzkaller reported this UAF:
> 
> With this patch, syzkaller reports possible circular locking dependency:
> https://lore.kernel.org/lkml/000000000000be57bf059f8aa7b9@google.com/
> 
> Could you drop the patch from stable until this is resolved?

Good idea, now dropped from 4.19.y, 5.4.y, and 5.5.y, thanks.

greg k-h
