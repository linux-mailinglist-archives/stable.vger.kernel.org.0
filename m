Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B08F50D6
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 17:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfKHQRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 11:17:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfKHQRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 11:17:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD8221882;
        Fri,  8 Nov 2019 16:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573229863;
        bh=NbTDBoQsWKuVv0roowgOARg28VXuGj5HD9QgJyfbpCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mST5ke8Pl7swPav8DrLI+otj6hGR/73m7cRXimAWeFHZw3hboatj7DG5itjUB+Cr8
         XvUiGdC6HD+GgcYtfs0ABDaPNHcyPOA29DQ7C5+i/op4kEjKq7/r7Kag02XdQhklYK
         hn6KqR+DrEu3e9tIIyLoP/mz8GE7yBOz0Bkq5BQw=
Date:   Fri, 8 Nov 2019 17:17:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fabrice Gasnier <fabrice.gasnier@st.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Jonathan.Cameron@huawei.com
Subject: Re: [PATCH 4.14 0/2] backport iio: stm32-adc: fix a race with dma
 and irq
Message-ID: <20191108161740.GF761587@kroah.com>
References: <1571233495-6065-1-git-send-email-fabrice.gasnier@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571233495-6065-1-git-send-email-fabrice.gasnier@st.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 03:44:53PM +0200, Fabrice Gasnier wrote:
> This is a backport of "iio: stm32-adc: fix a race with dma and irq" series
> on top of v4.14.148 at the time of writing. The original series doesn't
> apply cleanly on v4.14.x: the precursor patch needed a slight update.
> 
> Original series can be found in [1].
> [1] https://www.lkml.org/lkml/2019/9/17/394

Now queued up,t hanks.

greg k-h
