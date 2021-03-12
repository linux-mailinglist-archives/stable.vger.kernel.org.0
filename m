Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051D5338F7B
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 15:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhCLOJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 09:09:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229728AbhCLOJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 09:09:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE47B64FC9;
        Fri, 12 Mar 2021 14:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615558180;
        bh=myLkcxSDdu/BJyHXxoTxu1VFaqACYp7h/QmxGHOePOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T0leCHNuUAnrrvpnGCan0fgmjgmAAeiGWV2bnZYzPxRKCaNVTWWAY936vbkezhBYU
         8GtagtSKMqcgpWQUckhdqS9NDE00NIIF3Wsp5eSrpUBHrZNI4JPBXXT+k0OZKWDipk
         D22A9cfGx7Qa3xl1T7H5Rw5jj+HKXHIaglaESz08=
Date:   Fri, 12 Mar 2021 15:09:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     sprasad@microsoft.com, stable@vger.kernel.org,
        stfrench@microsoft.com
Subject: Re: FAILED: patch "[PATCH] cifs: fix credit accounting for extra
 channel" failed to apply to 5.10-stable tree
Message-ID: <YEt2IWyvasHOR0tM@kroah.com>
References: <161554344221530@kroah.com>
 <87y2essc4w.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y2essc4w.fsf@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 03:02:55PM +0100, Aurélien Aptel wrote:
> Hi Greg,
> 
> I've attached the backport for
> 
>  a249cc8bc2e2fed680047 ("cifs: fix credit accounting for extra channel")

Thanks, now queued up.

greg k-h
