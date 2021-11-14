Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9632344F826
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 14:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhKNNse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 08:48:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235096AbhKNNsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 08:48:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95B9661026;
        Sun, 14 Nov 2021 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636897537;
        bh=AcXFNTLVtcxk1A/Oqbs3xzeKot3kVcIMbn+mzZt0G28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=modoq3Z0OgVk+ud3qecbWWKTiFyq7CQwhgEv5N5PjhbTtPF1yFlArMdBsldwHRHQE
         SHQDaLzQBzCZPHoabNkxipySHkF8++yobs2vx2vAXNj2yVojmQ1wDeigZqaTbGJpD9
         n6o7zraHq3uKZkll0wz1A9/xsgQwW5rE3O4Q6u3Y=
Date:   Sun, 14 Nov 2021 14:45:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     marcel@holtmann.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Bbluetooth: btusb: Add another Bluetooth
 part for Realtek" failed to apply to 5.15-stable tree
Message-ID: <YZES/qacW2gZSndg@kroah.com>
References: <1636807836194180@kroah.com>
 <a34b2eec-ce6d-de1d-7a2f-56a9fa9958be@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a34b2eec-ce6d-de1d-7a2f-56a9fa9958be@lwfinger.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 13, 2021 at 12:04:18PM -0600, Larry Finger wrote:
> On 11/13/21 06:50, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to<stable@vger.kernel.org>.
> 
> Greg,
> 
> The repaired patch is attached. Sorry for any inconvenience.

Still does not apply to the 5.15.y tree, odd.  What did you generate
this against?

thanks,

greg k-h
