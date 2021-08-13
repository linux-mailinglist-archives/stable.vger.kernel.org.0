Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD1F3EB2C0
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239263AbhHMImM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239163AbhHMImL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 04:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC2C36104F;
        Fri, 13 Aug 2021 08:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628844105;
        bh=fpYfuW+uPMeEuv1lgpSbjd0MulBHu01VgHVXRIOz57k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZVX5XlBtr2kF2scKxUqA5D0oX/S/bMoyO3LbXUzzLMfhDA3lOIg1Hw5N+z2mQkOFF
         7+ImtiBeN4EWoQf5nWs8tL+l5jyQM4uM0lODIBxbYVWmWVWfiwfp41vFW812y0dUdC
         rnlT9CcmZVBCoNxCrx7+guRQZ2C4OpYxqz6eNXw0=
Date:   Fri, 13 Aug 2021 10:41:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     stable@vger.kernel.org, fenghua.yu@intel.com,
        skhan@linuxfoundation.org, sashal@kernel.org,
        xiaochen.shen@intel.com, tony.luck@intel.com
Subject: Re: [PATCH 5.10] Revert "selftests/resctrl: Use resctrl/info for
 feature detection"
Message-ID: <YRYwRhQ7fP9ec2VI@kroah.com>
References: <dde8f92f6ea1c12b3d0f1c1d83a195e0dea781d1.1628725515.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dde8f92f6ea1c12b3d0f1c1d83a195e0dea781d1.1628725515.git.reinette.chatre@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 11, 2021 at 04:54:21PM -0700, Reinette Chatre wrote:
> This reverts commit 19eaad1400eab34e97ec4467cd2ab694d1caf20c which is
> ee0415681eb661efa1eb2db7acc263f2c7df1e23 upstream.
> 
> This commit is not a stable candidate and was backported without needed
> dependencies that results in the resctrl tests unable to compile.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> 
> The same commit is present in v5.12.y where it also causes the
> resctrl tests to fail to compile. I did not submit a revert against v5.12.y
> because it is EOL.

Now queued up, thanks!

greg k-h
