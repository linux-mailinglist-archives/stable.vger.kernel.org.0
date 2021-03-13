Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAEC339E4B
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhCMNb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:31:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233789AbhCMNbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Mar 2021 08:31:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B67FF64F0F;
        Sat, 13 Mar 2021 13:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615642261;
        bh=mWwMEZ/EGxLpiN0DAhUewVBX4/dkOaKBSBqo4d/BhVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZGZaf2mQgoFFG55S29gy2uXWQaHQNn6HzQtEe5HKBDWCL872FdtUfNdQdA0JAqsaN
         sSyK7fkSriyJJoi+heL7oCJDqWwh1eXf2wbnr0mADxWM8Kki7+OLELZpHJjbXz50Jw
         vTiOmXY2frRHMYST0rYT7aJAEQzTJF/V1IL8fBMg=
Date:   Sat, 13 Mar 2021 14:30:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     aaptel@suse.com, lsahlber@redhat.com, stable@vger.kernel.org,
        stfrench@microsoft.com
Subject: Re: FAILED: patch "[PATCH] cifs: do not send close in compound
 create+close requests" failed to apply to 5.10-stable tree
Message-ID: <YEy+kq2tGPqianwA@kroah.com>
References: <1615543505112255@kroah.com>
 <87tupglzc7.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tupglzc7.fsf@cjr.nz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 08:35:52PM -0300, Paulo Alcantara wrote:
> Hi Greg,
> 
> <gregkh@linuxfoundation.org> writes:
> 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I've attached the backport of
> 
>         04ad69c342fc ("cifs: do not send close in compound create+close requests")
> 
> for 5.10+ stable trees.


Now queued up, thanks.

greg k-h
