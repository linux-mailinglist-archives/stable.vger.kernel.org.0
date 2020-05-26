Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8601E2031
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 12:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388651AbgEZKyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 06:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388501AbgEZKyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 06:54:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 782E92084C;
        Tue, 26 May 2020 10:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590490446;
        bh=EnW0RzrrrcO452ar6lDfOlldXnTl5N5j+jTiZcUD3KU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W4EEvgvAc0Jw59j6oJ6IY9Kb5dv+/4CvjU7idR3fxtSRm9JSRM6VDkVi5hy4/5Zo8
         rLXAP1fCaUOmlfq2T1BlJFF2+6SSEvY73JFDGQKENyr8TfKQndOI6uADEZCb/C1zyO
         GEldLlNYbcLBW3NhyfQal61C23mDEIsw2X02A2FU=
Date:   Tue, 26 May 2020 12:54:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 00/27] more l2tp locking and ordering fixes
Message-ID: <20200526105403.GA2838783@kroah.com>
References: <20200521235740.191338-1-gprocida@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 22, 2020 at 12:57:13AM +0100, Giuliano Procida wrote:
> Hi Greg.
> 
> This is for 4.4.
> 
> This is a follow-up to "l2tp locking and ordering fixes" for 4.9.

All now queued up, thanks.

greg k-h
