Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47AB472CD9
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 13:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfGXLHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 07:07:19 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48307 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbfGXLHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 07:07:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CC28A220AA;
        Wed, 24 Jul 2019 07:07:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 24 Jul 2019 07:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=yvRWUuW4BAPFem/HTvS1v/2xXr4
        wswa2KxSyPKG8p3s=; b=Dt/pUCfTdHP7NG9NS8IFwuWG7WcAXV1HS++0qYyWZ8H
        sGdtJ1REif6DkoX7MxyWECD27B7qIJ1Olc6NNw+bleOR0tTVWPZeYPaHVOo+KgYT
        YB/kyjs9Ag5K1hw9RB2++gAutScH//3hbyt9eNv18uS0wdIZ1WWKLMtxThZSqls9
        qkmwis4DlDFfRpKCOZcilelij807S55UJswFkzoMVBRK9MOiV9Nl96O8wNtCLDMr
        9ihBkcjBtYjPtcUX+4YS4q3L3l8xG9AosI2MFFl+WPszfRcZmLr1cIBdyXy5JJzA
        8XFs07yE91+Ax1zTdgrw6Vv/kzBEd6dNKP+/1BGQhgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yvRWUu
        W4BAPFem/HTvS1v/2xXr4wswa2KxSyPKG8p3s=; b=IW2fscQF9cmLGNJ5zOM9fS
        RrZpnmWz1BHJny1x/QUBH6v87+x+CTpXlr0ISmD6puXetkVBP60RmYYNHnYPCD2p
        RTP8KRwbnfPGU4ER7YjRnkeLydakin2qDTUpyAVA6qY3AdeLLryhUk1b5HGbdnSW
        avNeb8P3HG3zYvoPcjYyjJqdttthoCc1F8rLe91I7tUtUszqEnpwpk0GVtymF+8h
        dvf2Z8ejhdYASfiHrjBIqCho0a1Jcv7wY3tnaW/lTFIsiL73XZcTxw3H1Nr4Bcey
        BM5mg8sY1M9I2OmNEf0WUDTfNnAmGIYtvemi/jNfbMUGDFZh1etGXm15F7FfbRBw
        ==
X-ME-Sender: <xms:4zs4Xbrfu0g1bqxZ3D5nsPmr8iK42ZsZ6zHugz9KObs0rNHA9CEuww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkedtgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:4zs4XRf-Pfu_mrd9F4qSD4_P0Sf_86lHXUduh9M1NFuuMKMw8bjcQA>
    <xmx:4zs4Xer9SPan1ImMwwDN3e3fB0JI74IcLz9x5-6m2M_dduJdFKjWFg>
    <xmx:4zs4XbldFwXLGG6fWS6Nxq4usGMqcG-q5HsCJl9A2BqB2QBADbHTxQ>
    <xmx:4zs4XcZGBAjjB7wfFHdV8ORU4DnTk81scMXkY3rRuxXj9_6tcZNo3g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF23F380075;
        Wed, 24 Jul 2019 07:07:14 -0400 (EDT)
Date:   Wed, 24 Jul 2019 13:07:12 +0200
From:   Greg KH <greg@kroah.com>
To:     Jan Harkes <jaharkes@cs.cmu.edu>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] coda: pass the host file in vma->vm_file on mmap
Message-ID: <20190724110712.GB4472@kroah.com>
References: <20190723201701.19236-1-jaharkes@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723201701.19236-1-jaharkes@cs.cmu.edu>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23, 2019 at 04:17:01PM -0400, Jan Harkes wrote:
> commit 7fa0a1da3dadfd9216df7745a1331fdaa0940d1c upstream.
> 
> Various file systems expect that vma->vm_file points at their own file
> handle, several use file_inode(vma->vm_file) to get at their inode or
> use vma->vm_file->private_data. However the way Coda wrapped mmap on a
> host file broke this assumption, vm_file was still pointing at the Coda
> file and the host file systems would scribble over Coda's inode and
> private file data.
> 
> This patch fixes the incorrect expectation and wraps vm_ops->open and
> vm_ops->close to allow Coda to track when the vm_area_struct is
> destroyed so we still release the reference on the Coda file handle at
> the right time.
> 
> This patch differs from the original upstream patch because older stable
> kernels do not have the call_mmap vfs helper so we call f_ops->mmap
> directly.
> 
> Cc: stable@vger.kernel.org # 4.9.x
> Cc: stable@vger.kernel.org # 4.4.x

Now queued up, thanks!

greg k-h
