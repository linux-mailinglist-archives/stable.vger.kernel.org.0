Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58AD3F9812
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 12:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbhH0KWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 06:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233204AbhH0KWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 06:22:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 145E760E93;
        Fri, 27 Aug 2021 10:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630059718;
        bh=PtyNkkJeLHBN5XClTUkDoXWHiuUmpYFD7RG8Cp8CMFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MdrnCPTQXxNn/qWnpmrxFGgsjhp8GIo22VCcJGCdVqSFdgmm6j9bW6d1eH+POWmzn
         cA3UzxqAMheJ40vj08qpNYSOLtoIBDn6RqmO0sCYTP69fjo/z0BUONfCt+Zls+ITkW
         caTf6MIJc7oo+3YK/u27nDF9gGwlMt1OB2offGdk=
Date:   Fri, 27 Aug 2021 12:21:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Please add beadb3347de2 to 5.4 and 5.10
Message-ID: <YSi8w7mhx2rfsVdM@kroah.com>
References: <20210827091500.GT3379@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827091500.GT3379@twin.jikos.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 27, 2021 at 11:15:00AM +0200, David Sterba wrote:
> Hi,
> 
> please add commit
> 
> beadb3347de27890  btrfs: fix NULL pointer dereference when deleting device by invalid id
> 
> to stable trees 5.4 and 5.10 (applies cleanly on both).

This commit id is not in Linus's tree :(
