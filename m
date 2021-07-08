Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EF43C192B
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 20:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhGHSaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 14:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhGHSaE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 14:30:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F252761624;
        Thu,  8 Jul 2021 18:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625768842;
        bh=HLLd3yEwXW77mwQmJLlWxcwIg2HQCrgxTc0Cq671Rdc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ISvWTBqXNhkL5ubz3r4XbJLMQ+yC3qpd5DsGTvRh/ckjkwP0BF1LziVzEvFqLO9VI
         cMEn5oBLMPQ4aAo1HMgXzqxVGKc2zI8tYNqHmTeWc2RC3Gw4uWvXqVcisP1BHGSVnp
         bx+E3PYQBVz2dii2IdbAyeweqhVgbodTI68CZ2yY=
Date:   Thu, 8 Jul 2021 20:27:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ross Lagerwall <ross.lagerwall@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: Backport of commit 3de218ff39b9e3f0d4
Message-ID: <YOdDh1I8bGqY7ded@kroah.com>
References: <194665ee-3a94-3c1a-23ca-f71c007c74a5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <194665ee-3a94-3c1a-23ca-f71c007c74a5@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 01:58:09PM +0200, Juergen Gross wrote:
> Hi Greg,
> 
> the attached patch is a backport of upstream commit 3de218ff39b9e3f0d4
> for Linux 5.10 and older (I've checked it to apply down to 4.4).

Now applied, thanks.

greg k-h
