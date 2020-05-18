Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7692F1D7B67
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 16:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgEROjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 10:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgEROjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 10:39:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26A36206D4;
        Mon, 18 May 2020 14:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589812743;
        bh=6dUiRncfEsOvPT4mAUwsymP9c0KT/ymtvJlRXPitx5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pki1pT+eetXAsyRWWX24xgopDVYi6pgvhZyBAFCxQzKF2IsiKurHnPYoTe8IVqEdR
         HOfvbgc1dpebdEtz5MSJjEnahCI19jDgJDJBxh06fOC85uuxae6qYqK8pwv7IYGbBU
         1gj+VBF4jIZhmxl9vG0zljS6QVpkEMamY6BuVYsg=
Date:   Mon, 18 May 2020 16:39:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     stable@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: another gcc-10 fix for stable kernels
Message-ID: <20200518143901.GB1757573@kroah.com>
References: <a22fabc5-22d6-8278-34a8-f93f2412ba0d@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a22fabc5-22d6-8278-34a8-f93f2412ba0d@mageia.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 05:32:25PM +0300, Thomas Backlund wrote:
> Hi,
> 
> this one should be added to -stable trees too:
> 
> commit b1112139a103b4b1101d0d2d72931f2d33d8c978
> Author: Sergei Trofimovich <slyfox@gentoo.org>
> Date:   Tue Mar 17 00:07:18 2020 +0000
> 
>     Makefile: disallow data races on gcc-10 as well
> 

Now queued up, thanks.

greg k-h
