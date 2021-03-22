Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104F53448DA
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 16:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCVPLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 11:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230056AbhCVPKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 11:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90CB06198D;
        Mon, 22 Mar 2021 15:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616425832;
        bh=SgfLmYDSTol9PH1VeYiGX7gYkcwx8cAKAndfMp7DyPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M3ZsD/8833piIeIB1JN3GuIhJjrOHOzKm9o+7MhnA0eYEOSL3qp5LgD7SSwLJQAS0
         h844ytObMhXOjaMiyjHKz7L7Bz61xhVJU9ivEZwGY5MyLoIu+bnUB+qQeyo6yGM+o5
         XAQ113U6J4lqUL1l4OvIkiRPiN212pCGzpNu6F68=
Date:   Mon, 22 Mar 2021 16:10:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     vincent.whitchurch@axis.com, stable@vger.kernel.org,
        stfrench@microsoft.com
Subject: Re: FAILED: patch "[PATCH] cifs: Fix preauth hash corruption" failed
 to apply to 5.11-stable tree
Message-ID: <YFizZeQCezJw0XsD@kroah.com>
References: <1616328254225233@kroah.com>
 <87y2efqrrf.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y2efqrrf.fsf@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 01:47:48PM +0100, Aurélien Aptel wrote:
> Hi Greg,
> 
> <gregkh@linuxfoundation.org> writes:
> > The patch below does not apply to the 5.11-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This should apply to 5.11, 5.10 and 5.4. 
> 
> > From 05946d4b7a7349ae58bfa2d51ae832e64a394c2d Mon Sep 17 00:00:00 2001

Thanks for the backports, now queued up.

greg k-h
