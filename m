Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3043DE02F
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 21:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhHBTlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 15:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229835AbhHBTlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 15:41:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3972260555;
        Mon,  2 Aug 2021 19:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627933264;
        bh=4rR8e4uEB7Tv54WnPbmI2g8q92ZOn1l9zZVNVR+Sots=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SvQ2xFxlqZd1C+ahToPz828u9fwbZE8SBIPsxWdjom3s181hEaT+qvSkeqVCia1dn
         eXJivfuECNDMOGeSyvPlQTEZ4b1ffnjWp5Mp/IhdTTf2shsSCLfGWYRzwSxI3Uwjjj
         Idn8UwaNAQAs0I/ici2EKMCynMoZjL6v+/zgDFq7EM1U+AvrRxlg/OrCyd33OurSv1
         5J8X8vaVa8uuEiveJw46PlGdnLl/ape6j2xtdjgyGXpsNQrmpGBpwWsn2IAPguT5jx
         KK1YAtnOgUlduIPc872u2GNRNt/gYwKwKtCHNECh4/z1NSYzXx/W0onykbAl1i7OAe
         Ts9UwMAW8Xc/w==
Date:   Mon, 2 Aug 2021 15:41:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        dsterba@suse.com
Subject: Re: [PATCH] btrfs: mark compressed range uptodate only if all bio
 succeed
Message-ID: <YQhKTy8cbcZLNDv8@sashalap>
References: <1627713208284@kroah.com>
 <20210802143206.bun3t2chwm7bghel@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210802143206.bun3t2chwm7bghel@fiona>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 09:32:06AM -0500, Goldwyn Rodrigues wrote:
>For: v4.19
>Git-commit: 240246f6b913b0c23733cfd2def1d283f8cc9bbe
>
>In compression write endio sequence, the range which the compressed_bio
>writes is marked as uptodate if the last bio of the compressed (sub)bios
>is completed successfully. There could be previous bio which may
>have failed which is recorded in cb->errors.
>
>Set the writeback range as uptodate only if cb->errors is zero, as opposed
>to checking only the last bio's status.
>
>Backporting notes: in all versions up to 4.4 the last argument is always
>replaced by "!cb->errors".
>
>Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

I've queued up this and the other backports, thanks!

-- 
Thanks,
Sasha
