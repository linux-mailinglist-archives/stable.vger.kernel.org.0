Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C945155561
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 11:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgBGKNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 05:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726816AbgBGKNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 05:13:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0BA820838;
        Fri,  7 Feb 2020 10:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581070391;
        bh=aymen6h+oW13mB51w2muor2ByjcdV9gYJhBBx+DOBsk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UOwkWt+YrSgBCQyFZwlGofhya/RiacLWlKRO2/7tFAP3I+8pCiedF53Sx3ma8hTVa
         oDYMWDzgRjD5aH9mll6LLHHhGvH8T7oH7CkTEpbEXKHB8BKz6xlvnZwnUm8Dt4dGB5
         71eSi7mUAgsMezpCwGqVZc3b2JWpRhc/J1D4/PUY=
Date:   Fri, 7 Feb 2020 11:13:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Cc:     ioanna.alifieraki@gmail.com, jay.vosburgh@canonical.com,
        miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        srivatsa@csail.mit.edu
Subject: Re: [4.4.y PATCH] Revert "ovl: modify ovl_permission() to do checks
 on two inodes"
Message-ID: <20200207101308.GA629374@kroah.com>
References: <20200204184958.6586-1-ioanna-maria.alifieraki@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204184958.6586-1-ioanna-maria.alifieraki@canonical.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 06:49:58PM +0000, Ioanna Alifieraki wrote:
> This reverts commit b24be4acd17a8963a29b2a92e1d80b9ddf759c95.
> 
> Commit b24be4acd17a ("ovl: modify ovl_permission() to do checks on two
> inodes") (stable kernel  id) breaks r/w access in overlayfs when setting
> ACL to files, in 4.4 stable kernel. There is an available reproducer in
> [1].

Thanks, now reverted.

greg k-h
