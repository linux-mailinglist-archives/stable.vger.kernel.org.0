Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C095D96645
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 18:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbfHTQZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 12:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbfHTQZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 12:25:40 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD7F022CE3;
        Tue, 20 Aug 2019 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566318340;
        bh=bwLqSxSYkPKWxQHKP2C6VqBAl8edq9G5uOuYmfqFNOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ivqtotmklg5QjMdzwK9sTB6gLQj929Gj48wHTG+8Qit97v9V7t+PdP5w/YD8CNoe8
         f7guUii7WWspLAPmOAR3LZGOQNtX+fhF5Rq+Z5dvOFDgxmJDx8Yoc+bFNY9nu6KiXO
         GAa0gr5zhZ9RP2mSFXajl6hhM9yeqIiYIrrm/RKU=
Date:   Tue, 20 Aug 2019 09:25:39 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: compat: Allow single-byte
 watchpoints on all addresses" failed to apply to 4.4-stable tree
Message-ID: <20190820162539.GC8214@kroah.com>
References: <1564983146189130@kroah.com>
 <20190805130017.zxm7ky6fuwgwmifs@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805130017.zxm7ky6fuwgwmifs@willie-the-truck>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 02:00:18PM +0100, Will Deacon wrote:
> On Mon, Aug 05, 2019 at 07:32:26AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Backport for 4.4, 4.9 and 4.14 below.

Now applied, thanks.

greg k-h
