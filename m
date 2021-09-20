Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E514E41199F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242912AbhITQUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233378AbhITQTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9BC860F58;
        Mon, 20 Sep 2021 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632154694;
        bh=pR4rJuI/EtJtDfqUb8LCi+OX+03VuFS0rM7/tFthvuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VfUmek/fh6oMBJ41fIOHqsGXMUFlFQJKr9M6LUnUeh75N3ggQ02iVzFZn+D2gqBDN
         2/CZpzHm9UgGOSo6OgtJIQ3mBGf3LdzAVUL31mk4FhCCtLhlKOkLvj/9nGQSBGwv5Z
         A49AHnj7wcCKL0UT8SCt86l4wDlHK0cioSe8GZm4=
Date:   Mon, 20 Sep 2021 18:18:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     bp@suse.de, stable@vger.kernel.org
Subject: Re: [PATCH v5.10.67] x86/mce: Avoid infinite loop for copy from user
 recovery
Message-ID: <YUi0Q9nVxL+2NgCW@kroah.com>
References: <163212173281150@kroah.com>
 <YUirguJmYnlxQ63R@agluck-desk2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUirguJmYnlxQ63R@agluck-desk2.amr.corp.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 08:40:50AM -0700, Luck, Tony wrote:
> Upstream commit 81065b35e2486c024c7aa86caed452e1f01a59d4
> 
> There are two cases for machine check recovery:

Now queued up, thanks.

greg k-h
