Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F05533F648
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 18:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhCQRKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 13:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhCQRJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 13:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EECD464EB6;
        Wed, 17 Mar 2021 17:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616000993;
        bh=9lhypiLjEMQcs6dvovUxSBeeY7rqlBOdewSVJr4bQN8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AC2w6qZihNL7u96FMH0WTuq3k19VEuZacaOCLks7A1oIqhmGNiHL8RKWbJ8rTAYN8
         OQwI8WcA+E2y5OHPTWS8mhoAhuWFp17N/LpcB89+8VI0fxPp954XFg/CbQ0eyKXu0b
         TkQ163q9TfWM2Npl/wULP0qB+Kfo7J5EmigfHsQY=
Date:   Wed, 17 Mar 2021 18:09:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jan Kara <jack@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 4.14.y 0/3] ext4: Avoid crash when journal inode
 extents are corrupted
Message-ID: <YFI330tRTbchkCoA@kroah.com>
References: <20210317164414.17364-1-jack@suse.cz>
 <20210317165533.GF2541@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317165533.GF2541@quack2.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 05:55:33PM +0100, Jan Kara wrote:
> On Wed 17-03-21 17:44:11, Jan Kara wrote:
> > Hello,
> > 
> > this is a backport of ext4 patches to avoid crashes when ext4 journal inode
> > extents are corrupted to 4.14.y kernel.
> 
> BTW, these patches apply just fine to 4.9.y and 4.4.y stable kernels as well.

Many thanks for these backports, all now queued up to all 3 branches.

greg k-h
