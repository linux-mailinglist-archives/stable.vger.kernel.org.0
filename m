Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDC9152859
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 10:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgBEJbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 04:31:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728035AbgBEJbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 04:31:08 -0500
Received: from localhost (unknown [212.187.182.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E18220661;
        Wed,  5 Feb 2020 09:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580895065;
        bh=WsCEpqXBRNYpDkZmwonyyJpU+LcvwiDhpxclSCWjXl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OJPqrG+KkodxzKYXVcFte6Z5a3yDghEQbynpF4evrCG4KF2gKHb7CscCuvFUmG2EG
         DpjOPMhFm77dO+leqAa5yqRD2bjsmGE2u1ivq0YmDnV4kNWiYuCpRJSX7XEf4BK1Ci
         TSBqY9pr2fXHkugx5WG+wIVErFarNV/fUQoslqIY=
Date:   Wed, 5 Feb 2020 09:31:02 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Moulding <dmoulding@me.com>
Cc:     stable@vger.kernel.org, stsp@stsp.name, sashal@kernel.org,
        luciano.coelho@intel.com
Subject: Re: [PATCH 5.4 61/90] iwlwifi: mvm: fix NVM check for 3168 devices
Message-ID: <20200205093102.GB1164405@kroah.com>
References: <20200203161917.612554987@linuxfoundation.org>
 <20200204210157.31658-1-dmoulding@me.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204210157.31658-1-dmoulding@me.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 02:01:57PM -0700, Dan Moulding wrote:
> I believe this commit (upstream commit
> b3f20e098293892388d6a0491d6bbb2efb46fbff) introduced a regression that
> causes the driver to fail to initialize for Intel 3168 devices. A
> patch for the regression has been submitted to the linux-wireless
> mailing list here:
> 
> https://patchwork.kernel.org/patch/11353871/
> 
> I would suggest either not including b3f20e0982 in the next v5.4.x
> stable release, or also applying the above patch, to avoid introducing
> a regression for users of the v5.4 series. The above patch is also
> needs inclusion in the v5.5.x series, as the regression is already
> present there.

Now dropped from all trees.  Can you send us an email with the git
commit id of the fix when it lands in Linus's tree so we remember to
pick both of these up?

thanks,

greg k-h
