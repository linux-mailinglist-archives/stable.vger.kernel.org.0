Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E00DE156BFE
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 19:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgBISPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 13:15:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbgBISPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 13:15:17 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F18CD20733;
        Sun,  9 Feb 2020 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581272117;
        bh=HTxGajO8RFT7CS0Qds/QD+Tau4uLSDe/7051v8JR3pg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eCUhQuyI8gk3JcSf0SJPLrSyLicQHcxrdy4lcHItxHH1Bj5kH6+r/uzKI0biwX8Jb
         CLBXew5hhzpAAfC5m9YnvYpnUeJGZwM5lj02LJUHky0H0D1AMWnRTlENIBZ0WBTdwI
         mHumgyL/4LykYv3yWlWObSW84ejbkQRdWB+IDJG4=
Date:   Sun, 9 Feb 2020 13:15:15 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] media: cec: avoid decrementing
 transmit_queue_sz if it is 0" failed to apply to 5.5-stable tree
Message-ID: <20200209181515.GM3584@sasha-vm>
References: <15812488366474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15812488366474@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:47:16PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 4be77174c3fafc450527a0c383bb2034d2db6a2d Mon Sep 17 00:00:00 2001
>From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>Date: Sat, 7 Dec 2019 23:48:09 +0100
>Subject: [PATCH] media: cec: avoid decrementing transmit_queue_sz if it is 0
>
>WARN if transmit_queue_sz is 0 but do not decrement it.
>The CEC adapter will become unresponsive if it goes below
>0 since then it thinks there are 4 billion messages in the
>queue.
>
>Obviously this should not happen, but a driver bug could
>cause this.
>
>Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>Cc: <stable@vger.kernel.org>      # for v4.12 and up
>Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Another duplicate commit:

4be77174c3fa ("media: cec: avoid decrementing transmit_queue_sz if it is 0")
95c29d46ab2a ("media: cec: avoid decrementing transmit_queue_sz if it is 0")

-- 
Thanks,
Sasha
