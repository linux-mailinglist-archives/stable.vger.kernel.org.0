Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683A228FF83
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 09:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404831AbgJPHyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 03:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404817AbgJPHyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 03:54:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4979207F7;
        Fri, 16 Oct 2020 07:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602834864;
        bh=4Tt1hU0RTh/kMWQUK/UyNfqxN6pHPmTZpdL5lRvFEY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OJBNMgsE0bBCE+voYak+yYSYWyc5MAOQ45zVU6D6iLM6Jb3aps6aawjxpqtpDeqrp
         KE3EK/5BmvfI3hjdOy5ZKV/CVygK4p4rKtgYczsnGsRsXJZp/Ni96MjnJ97ENNW5kB
         iqShatRICG9bmt1FMdr/ewlS11BG5/pOJbK5NzFY=
Date:   Fri, 16 Oct 2020 09:54:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [v4.4/bluetooth PATCH 1/3] Bluetooth: Consolidate encryption
 handling in hci_encrypt_cfm
Message-ID: <20201016075455.GA1354412@kroah.com>
References: <20201015211225.1188104-1-hegtvedt@cisco.com>
 <20201016073234.GB578349@kroah.com>
 <41626257-e150-e2dd-c6f2-ad586ec94c14@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41626257-e150-e2dd-c6f2-ad586ec94c14@cisco.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 07:46:39AM +0000, Hans-Christian Egtvedt (hegtvedt) wrote:
> On 16/10/2020 09:32, Greg KH wrote:
> > On Thu, Oct 15, 2020 at 11:12:23PM +0200, Hans-Christian Noren Egtvedt wrote:
> >> From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> >>
> >> This makes hci_encrypt_cfm calls hci_connect_cfm in case the connection
> >> state is BT_CONFIG so callers don't have to check the state.
> >>
> >> Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> >> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> >> (cherry picked from commit 3ca44c16b0dcc764b641ee4ac226909f5c421aa3)
> >> Cc: stable@vger.kernel.org # 4.4
> >> ---
> >>  include/net/bluetooth/hci_core.h | 20 ++++++++++++++++++--
> >>  net/bluetooth/hci_event.c        | 28 +++-------------------------
> >>  2 files changed, 21 insertions(+), 27 deletions(-)
> > 
> > What differs here from the other patch series you sent?  Looks the same
> > to me...
> 
> Patch 1 and 2 in this series is identical, patch 3/3 is adjusted to
> resolve a conflict. Sorry I did not make that clearer.

No problem, thanks for confirming this, that makes me feel better that I
didn't miss anything.

greg k-h
