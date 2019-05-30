Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EF030117
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 19:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfE3RbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 13:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3RbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 13:31:01 -0400
Received: from localhost (unknown [207.225.69.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72BD525E83;
        Thu, 30 May 2019 17:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559237460;
        bh=uJ05PYAHKs/Pry+XB+BlyBAE0t4HVAyNtW7R0W82kmM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QCu1te9YwHFqUwhSV5sg+fcQYKkNi7SMeXh4T4PO1nSfHLBu2g0tzzRqaKgMRZTO1
         vhkz+louaperAMk3U6ZUfiVkUtjZYDaEDkhnwcFk9SWJvcdd+n/pAH/KhUkknrazh3
         vosS6uWeBbYKxNneUL9wggskPi3ONrT7KlkMNjYY=
Date:   Thu, 30 May 2019 10:31:00 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [stable] bpf: add bpf_jit_limit knob to restrict unpriv
 allocations
Message-ID: <20190530173100.GA23688@kroah.com>
References: <1558994144.2631.14.camel@codethink.co.uk>
 <1559236680.24330.5.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1559236680.24330.5.camel@codethink.co.uk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 06:18:00PM +0100, Ben Hutchings wrote:
> On Mon, 2019-05-27 at 22:55 +0100, Ben Hutchings wrote:
> > Please consider backporting this commit to 4.19-stable:
> > 
> > commit ede95a63b5e84ddeea6b0c473b36ab8bfd8c6ce3
> > Author: Daniel Borkmann <daniel@iogearbox.net>
> > Date:   Tue Oct 23 01:11:04 2018 +0200
> > 
> >     bpf: add bpf_jit_limit knob to restrict unpriv allocations
> > 
> > No other stable branches are affected by the issue.
> 
> Actually that's wrong; the commit introducing this was backported to
> 4.4, 4.9, and 4.14.  I haven't yet checked whether this fix applies
> cleanly to them.

It doesn't apply cleanly to those trees :(

thanks,

greg k-h
