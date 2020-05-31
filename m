Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB911E974B
	for <lists+stable@lfdr.de>; Sun, 31 May 2020 13:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgEaLev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 May 2020 07:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgEaLev (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 May 2020 07:34:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73A04206F1;
        Sun, 31 May 2020 11:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590924891;
        bh=kk+bZ+LQu4IxjOdl2CMQfy9drLeBWgP+dLocEhRPu6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D4dLzL82FEI3fneiC4h2VFSIxfnkugp4PssGUf+wy8BodbYCPoB9AXXL0oM81sR0i
         BHzRhdfKoqTn/gvzkKdcSOPkgGFOeAFqkqUHU01hqU38KguDcUDocGWgCB/lC0tcav
         DKEJK0o5onyk0rnmB1tJhEmsC6zsBtfFPB1JD8zU=
Date:   Sun, 31 May 2020 13:34:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.6 086/126] virtio-balloon: Revert "virtio-balloon:
 Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM"
Message-ID: <20200531113448.GB1237439@kroah.com>
References: <20200526183937.471379031@linuxfoundation.org>
 <20200526183945.237904570@linuxfoundation.org>
 <20200531051724-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200531051724-mutt-send-email-mst@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 31, 2020 at 05:18:06AM -0400, Michael S. Tsirkin wrote:
> On Tue, May 26, 2020 at 08:53:43PM +0200, Greg Kroah-Hartman wrote:
> > From: Michael S. Tsirkin <mst@redhat.com>
> > 
> > [ Upstream commit 835a6a649d0dd1b1f46759eb60fff2f63ed253a7 ]
> > 
> > This reverts commit 5a6b4cc5b7a1892a8d7f63d6cbac6e0ae2a9d031.
> > 
> > It has been queued properly in the akpm tree, this version is just
> > creating conflicts.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I don't understand. How does this make sense in stable?
> stable does not merge akpm does it?

It does not make sense, and is queued up to be reverted in the next
release.

thanks,

greg k-h
