Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2736C28DE00
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgJNJue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgJNJue (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 05:50:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B63B20757;
        Wed, 14 Oct 2020 09:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602669033;
        bh=PWMcktYWGX5cirr1SZGffRJadQvVe1x5PJA4l+afSK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0nHxwWMVfbrHZ79+HJQglRiAtS/NLV9kTOptBom/pTg2Wh/+yL8f8iU/JgeWF/Ygs
         pB19uiky4hZyuT/8LHZ16Jmga/3yXA+CJ50/ZSzpLsg9/BrJwtgmQ/64ragvEa6Wfy
         7I/L7CD8/T0IuRmDcTHcF1gmRb0Bo7SX9VOQaJx0=
Date:   Wed, 14 Oct 2020 11:51:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     stable@vger.kernel.org, Stefan Bader <stefan.bader@canonical.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] xen/events: don't use chip_data for legacy IRQs
Message-ID: <20201014095108.GB3597464@kroah.com>
References: <20201005061957.13509-1-jgross@suse.com>
 <f0b0b56e-512a-84ed-f03f-86ef54c10e96@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0b0b56e-512a-84ed-f03f-86ef54c10e96@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 11:31:33AM +0200, Jürgen Groß wrote:
> Any reason this has not made it into 5.4.y and older by now?
> 
> This patch is fixing a real problem...

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
