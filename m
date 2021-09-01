Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9283FD5C7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 10:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbhIAIma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 04:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241473AbhIAIm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 04:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6548C6103D;
        Wed,  1 Sep 2021 08:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630485690;
        bh=mOTN7T5g1qwPclcn4aUs33/Eaifp2gCvv9+Ju8xKkd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GSLPtFuwWE1J4KmvAHJq7N0FrZ2W2keeT7XVf7ex3VmOAldVEJTgt29/1NF5hb0+6
         tlnYOzbd1ia3CB9viGwSTrKN2lK8Zs2nezckGwdMjVVY0pYaO78tbQkqK1Y11kiNMM
         JfyrmSDm/EKxgBhHukuBwtBpEdkvIk1NoKtrtra8=
Date:   Wed, 1 Sep 2021 10:41:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rafael David Tinoco <rafaeldtinoco@gmail.com>
Cc:     stable@vger.kernel.org, andriin@fb.com, daniel@iogearbox.net,
        yanivagman@gmail.com
Subject: Re: [PATCH] bpf: Track contents of read-only maps as scalars
Message-ID: <YS88uFRrXFW4DOen@kroah.com>
References: <20210821203108.215937-1-rafaeldtinoco@gmail.com>
 <20210821203108.215937-2-rafaeldtinoco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210821203108.215937-2-rafaeldtinoco@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 21, 2021 at 05:31:08PM -0300, Rafael David Tinoco wrote:
> commit a23740ec43ba022dbfd139d0fe3eff193216272b upstream.
> 
> Maps that are read-only both from BPF program side and user space side
> have their contents constant, so verifier can track referenced values
> precisely and use that knowledge for dead code elimination, branch
> pruning, etc. This patch teaches BPF verifier how to do this.
> 
>   [Backport]
>   Already includes further build fix made at commit 2dedd7d21655 ("bpf:
>   Fix cast to pointer from integer of different size warning").

Do not do that, let us queue up the original commits instead please.

thanks,

greg k-h
