Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537353C1FC
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 06:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfFKEGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 00:06:09 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:32900 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfFKEGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 00:06:09 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id E8E8322A5E;
        Tue, 11 Jun 2019 00:06:06 -0400 (EDT)
Date:   Tue, 11 Jun 2019 14:06:11 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Sasha Levin <sashal@kernel.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/7] scsi: NCR5380: Always re-enable reselection
 interrupt
In-Reply-To: <20190610151841.20FDB20862@mail.kernel.org>
Message-ID: <alpine.LNX.2.21.1906111310010.202@nippy.intranet>
References: <61f0c0f6aaf8fa96bf3dade5475615b2cfbc8846.1560043151.git.fthain@telegraphics.com.au> <20190610151841.20FDB20862@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jun 2019, Sasha Levin wrote:

> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 8b00c3d5d40d ncr5380: Implement new eh_abort_handler.
> 
> The bot has tested the following trees: v5.1.7, v4.19.48, v4.14.123, v4.9.180.
> 
> v5.1.7: Build OK!
> v4.19.48: Failed to apply! Possible dependencies:
>     6a162836997c ("scsi: NCR5380: Reduce goto statements in NCR5380_select()")
> 
> v4.14.123: Failed to apply! Possible dependencies:
>     6a162836997c ("scsi: NCR5380: Reduce goto statements in NCR5380_select()")
> 
> v4.9.180: Failed to apply! Possible dependencies:
>     6a162836997c ("scsi: NCR5380: Reduce goto statements in NCR5380_select()")
> 
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha
> 

Please cherry-pick the dependency, 6a162836997c. It does not alter any 
functionality.

-- 
