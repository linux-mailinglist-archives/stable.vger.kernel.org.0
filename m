Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721E9327A7B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhCAJJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:09:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233372AbhCAJJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 04:09:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE98A64E04;
        Mon,  1 Mar 2021 09:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614589753;
        bh=cWxdKqt2+NPSLGbZEsoYm3/hKAY685hWO1NrXZ6nOCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kq7hGS6FMBkfy7E1SCifio5KpC9f2zbD1fcAcKiXWZaQ/aROAlBr2GIbZp1yWVpkD
         jbaoL2jLpVlU+tL7+U0+mOJ1F6w2cmfuZIPMOkjbDGYF1oqPssNX/26SxIsRFw4mHE
         oNXiNuXydQDHW/6ykYQlbwaDcz3PgvElJi/p4J5c=
Date:   Mon, 1 Mar 2021 10:09:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Diego Calleja <diegocg@gmail.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: -stable regression in Intel graphics, introduced in Linux 5.10.9
Message-ID: <YDyvNoiRAQwT4boR@kroah.com>
References: <3423617.kz1aARBMGD@archlinux>
 <YDuzbvIjMO5mFcYm@kroah.com>
 <1911334.sV3ZJath2r@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1911334.sV3ZJath2r@archlinux>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 28, 2021 at 09:05:45PM +0100, Diego Calleja wrote:
> El domingo, 28 de febrero de 2021 16:14:54 (CET) Greg KH escribió:
> > Is this the same issue reported here:
> > 	https://lore.kernel.org/r/f1070486-891a-8ec0-0390-b9aeb03178ce@redhat.com
> > ?
> 
> I just tested current mainline (which already contains the three commits mentioned in the bugzilla),
> and the problems have disappeared.

I do not see all 3 commits in Linus's tree already, am I missing
something?

What are the git ids that you are looking at?

thanks,

greg k-h
