Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669AB2FFE29
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 09:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbhAVI2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 03:28:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbhAVI2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 03:28:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CC4023381;
        Fri, 22 Jan 2021 08:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611304084;
        bh=QMDR7dDNiKtKNKXUYcWVY3pPfNkcjEQ8id9ein3pJoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=goynelLzpiV9pXkqW/kliLrEByGRsFNgk9Bt0qz8zYUsN5Up72/8z4m0NidLROWV0
         njRJ74yTxCltsqcN/RM7Rg/ssLy/6/3vfzrn1s/2Vgi1N2op0zivSa0JZ/K/5qeqsI
         xIi/riMWyqUnN4rUBvB3FF7pne9xa2LrkwUeaWXA=
Date:   Fri, 22 Jan 2021 09:28:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ricky_wu@realtek.com
Cc:     arnd@arndb.de, bhelgaas@google.com, vaibhavgupta40@gmail.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] Fixes: misc: rtsx: init value of aspm_enabled
Message-ID: <YAqMkU4fR5z6aG1Z@kroah.com>
References: <20210122081906.19100-1-ricky_wu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122081906.19100-1-ricky_wu@realtek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 04:19:06PM +0800, ricky_wu@realtek.com wrote:
> From: Ricky Wu <ricky_wu@realtek.com>
> 
> make sure ASPM state sync with pcr->aspm_enabled
> init value pcr->aspm_enabled
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
> ---
> 
> v2: fixed conditions in v1 if-statement
> v3: give description for v1 and v2
> v4: move version change below ---

What commit id does this fix?  How far back should the stable
backporting go?  That's what we use the Fixes: line for.

thanks,

greg k-h
