Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C012A15D50
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfEGGZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfEGGZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 02:25:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA3A6206A3;
        Tue,  7 May 2019 06:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557210337;
        bh=Lm+3NIFYAha+3pRon6rJxHuJRotFY+6JAjwRZn/1j2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a1CxuUp8f3Eb9XFMg4LHFkuVPgLYqgNMUrftyZGfPAhjjhT8egbO4a7wQsHBjdrTk
         qoVLrb6Qcn5hnUqCvWxMeWIgC0wTaacuzkQ56QdW3b27500SoEI1gsrXXqcadzQ1Vq
         TS5wMHVVBuZx70lwgQKTKFAftUVFVZNUS/oF0yn4=
Date:   Tue, 7 May 2019 08:25:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     stable kernel team <stable@vger.kernel.org>
Subject: Re: [PATCH] genirq: Prevent use-after-free and work list corruption]
Message-ID: <20190507062535.GA21061@kroah.com>
References: <20190507060708.GA75860@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507060708.GA75860@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 08:07:08AM +0200, Ingo Molnar wrote:
> 
> Hi Greg,
> 
> We forgot to mark 59c39840f5abf4a71e1 for -stable, please apply. It 
> should apply cleanly all the way back to v3.0.

Thanks, will do for the next round of releases after this one.

greg k-h
