Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B58D2D9D38
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502092AbgLNRHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502088AbgLNRHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:07:05 -0500
Date:   Mon, 14 Dec 2020 18:07:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607965585;
        bh=sSpcFbdnzuvMTQ/lfXXV0/Wgp2EzCSsm/RmX6/KXQ2k=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=lJpwKD9bdcdQ9oHynst26e+ZjxF5SqCrlhvbpO1Kfkyj27sm5Zk77FinE9TueXvsC
         DcR8KvXDnlhrvZxNo/nGCrm8tsO1Q2xxNR1nPPp22vaVeBYWKQTBRM79wDnICfIiN3
         eD8VdPepKhkZavvML8tvME3u+xJXRpkigS16Kkao=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     ansuelsmth@gmail.com, lorenzo.pieralisi@arm.com,
        p.zabel@pengutronix.de, robh@kernel.org, smuthayy@codeaurora.org,
        svarbanov@mm-sol.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: qcom: Add missing reset for ipq806x"
 failed to apply to 4.19-stable tree
Message-ID: <X9eb0jCe+g/M8tuS@kroah.com>
References: <159783260710161@kroah.com>
 <20201214162615.pes4lzpib4et3544@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214162615.pes4lzpib4et3544@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 04:26:15PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Aug 19, 2020 at 12:23:27PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Both backports now queued up, thanks!

greg k-h
