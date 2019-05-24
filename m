Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C91290F8
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 08:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388927AbfEXG1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 02:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388141AbfEXG1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 02:27:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5DA220862;
        Fri, 24 May 2019 06:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558679249;
        bh=Rf9MEAiNFzIrk54c3KssKKXXxxR6TcH/kLImGLhiAek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AXjLd/8iKnGzWKohgk0/XIa3l7ZkShjfAUN32CCuhIE87kj3JDosk3NHzC/xwAGpZ
         mm7nYHfH7GeCXCZUrf2S9VyW+KuKI3q7pPUzBwbIxSbWYstFgC4YcGLFcBllf9oTdv
         V7vmDieWO1q4CtScy0ivP/+EPzM7DNDRLTG2tMW4=
Date:   Fri, 24 May 2019 08:27:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Salyzyn <salyzyn@android.com>
Cc:     stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please cherrypick 592acbf1682128 to 3.18.y and 4.4.y
Message-ID: <20190524062726.GA32660@kroah.com>
References: <6f545e7c-fda8-4bec-33fc-283ebf492372@android.com>
 <20190524055409.GE31664@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524055409.GE31664@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 07:54:09AM +0200, Greg KH wrote:
> On Thu, May 23, 2019 at 01:49:27PM -0700, Mark Salyzyn wrote:
> > Cherry pick security-related fix 592acbf16821288ecdc4192c47e3774a4c48bb64
> > ("ext4: zero out the unused memory region in the extent tree block") to
> > 3.18.y and 4.4.y
> > 
> > The cherry-pick is clean and requires no back-porting. Is already present in
> > 4.9.y+
> > 
> > Signed-off-by: Mark Salyzyn<salyzyn@android.com>
> > 
> > To: stable <stable@vger.kernel.org> # 3.18.y 4.4.y
> > 
> > Cc: LKML <linux-kernel@vger.kernel.org>
> 
> It's already in the 4.4 queue.  And in my internal 3.18 queue as well.
> Need to put that somewhere public soon...

It's here now:
	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/queue-3.18.git/

