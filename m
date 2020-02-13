Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D8F15C0CC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 15:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgBMO6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 09:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgBMO6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 09:58:55 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99D8A2073C;
        Thu, 13 Feb 2020 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581605934;
        bh=c/UGbqFFCn/7brybfXlTgXh4VgijZQ9FTc4nctlHysU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0nHe+hXacUneHCPninMbqWjd58mR9VWYTpk1hnENbnk7dYKtVxFroxGxMxsR0sER5
         c9DxdWaQ8IPHDfOpkWtSy1Fq8B/OfkvVWOmsKJoJX4GNWJMPlFdJ4tXGq3X643UHPF
         60kzCtcM7TiLr0U9uCX8w01ZtxiKFO4klhgErfGE=
Date:   Thu, 13 Feb 2020 06:58:54 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anand Lodnoor <anand.lodnoor@broadcom.com>
Cc:     stable@vger.kernel.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, kiran-kumar.kasturi@broadcom.com,
        sankar.patra@broadcom.com, sasikumar.pc@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4.19] scsi: megaraid_sas: Do not initiate OCR if
 controller is not in ready state
Message-ID: <20200213145854.GB3409676@kroah.com>
References: <1581590578-19615-1-git-send-email-anand.lodnoor@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581590578-19615-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 04:12:58PM +0530, Anand Lodnoor wrote:
> commit 6d7537270e3283b92f9b327da9d58a4de40fe8d0 upstream.
> 
> Driver initiates OCR if a DCMD command times out. But there is a
> deadlock if the driver attempts to invoke another OCR before the
> mutex lock (reset_mutex) is released from the previous session of OCR.
> 
> This patch takes care of the above scenario using new flag
> MEGASAS_FUSION_OCR_NOT_POSSIBLE to indicate if OCR is possible.
> 
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/1579000882-20246-9-git-send-email-anand.lodnoor@broadcom.com
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

All 3 of these now applied, thanks!

greg k-h
