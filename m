Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8672BFB9
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 08:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfE1Gwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 02:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbfE1Gwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 02:52:40 -0400
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0499A2075B;
        Tue, 28 May 2019 06:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559026359;
        bh=QBucn7fRyCmbzLa+nB7tgEJj13YVylvYvgpO98APiGM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=knSGEBFVwTB/DMgj3Xjd1Asm0TGv45W4A2Foek+rA9LFxfxpWMwcTnYQUD5wEoDop
         v4IdXGV3T0YcwpsimGjCo1dMod1aeHOzHW9k9h2pOPjy3uNpTwXRIO+ee3Wf1QSqar
         i/2i5+c7A2ijseXZqAC1YLYZEQxiU01HjsGkspt8=
Date:   Tue, 28 May 2019 08:52:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [stable] bpf: add bpf_jit_limit knob to restrict unpriv
 allocations
Message-ID: <20190528065237.GB2623@kroah.com>
References: <1558994144.2631.14.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1558994144.2631.14.camel@codethink.co.uk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 27, 2019 at 10:55:44PM +0100, Ben Hutchings wrote:
> Please consider backporting this commit to 4.19-stable:
> 
> commit ede95a63b5e84ddeea6b0c473b36ab8bfd8c6ce3
> Author: Daniel Borkmann <daniel@iogearbox.net>
> Date:   Tue Oct 23 01:11:04 2018 +0200
> 
>     bpf: add bpf_jit_limit knob to restrict unpriv allocations
> 
> No other stable branches are affected by the issue.

Now queued up, thanks.

greg k-h
