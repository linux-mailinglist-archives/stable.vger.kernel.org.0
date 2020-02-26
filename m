Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 351D7170551
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 18:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgBZRCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 12:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbgBZRCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 12:02:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5346E20637;
        Wed, 26 Feb 2020 17:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582736562;
        bh=pXnGYOWXs3Za98yjkf7zIPmoJrw5pbFg+0tUjwiz+KM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XRxB0+JN8zPru/fbBkpQsZAkGgLrIszvXbu7lXqd6YIZLYQQiJb/QI8kw9lbkH8Yg
         bsg0M6QKfK5ux2DlbiOLlqLgP9+EqX7oQq2UahdtpU0bfx631/SrJYlGRd3HlFVoph
         ly+ehK5lMfiU2XLnWxlza2YVTEvytJzntPtNE/m0=
Date:   Wed, 26 Feb 2020 18:02:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] xhci: apply XHCI_PME_STUCK_QUIRK to Intel Comet Lake
 platforms
Message-ID: <20200226170238.GD262937@kroah.com>
References: <20200226150848.28162-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226150848.28162-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 05:08:48PM +0200, Mathias Nyman wrote:
> [ Upstream commit a3ae87dce3a5abe0b57c811bab02b2564b574106 ]
> 
> Backport for 4.4, 4.9, 4.14, and 4.19 stable

Thanks for the backport, now queued up.

greg k-h
