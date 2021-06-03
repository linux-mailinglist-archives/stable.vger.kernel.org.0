Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF2639A9E8
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 20:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhFCSWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 14:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCSWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 14:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F012A61358;
        Thu,  3 Jun 2021 18:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622744438;
        bh=+GrwKFdUEsGpkZcaf6kKz/KwLaeOIHO4YcUr5jRFybc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mBjjvE5XDpQcg3QKItoo8C7urobYtw81MEPmwkf0jaMwfvRikumyU5Lj3BpHKGPjW
         tTjtuNe4boVSPuTdifcOiWFaU5e/u0mO0t9vMEcOW0zBZPQCyShTicYzgjcBWncCMB
         eaDsRSUyw1zOzF0zIbjHJf8Wq/HsSubRuLHuB9Al9CSsgsMBHzdiaA1d5B8KxlvZuK
         YyKQzxxDtOEMukm6QeidUfR68H9uHlqeUJthSlNStAx8K0mAVPXHVcfEXeesOi0DRp
         J2z+0fNUS0rN9GyUq9UCQswpcKc2U4lZwq40DUBwScMZnmbawmWpJQAZdJMm873UAs
         DyyqqnzTdV9fQ==
Date:   Thu, 3 Jun 2021 11:20:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Daniel Rosenberg <drosen@google.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] f2fs: Show casefolding support only when supported
Message-ID: <YLkddHRPyugDUB99@sol.localdomain>
References: <20210603095038.314949-1-drosen@google.com>
 <20210603095038.314949-2-drosen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603095038.314949-2-drosen@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 09:50:37AM +0000, Daniel Rosenberg wrote:
> The casefolding feature is only supported when CONFIG_UNICODE is set.
> This modifies the feature list f2fs presents under sysfs accordingly.
> 
> Fixes: 5aba54302a46 ("f2fs: include charset encoding information in the superblock")
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Daniel Rosenberg <drosen@google.com>
> ---
>  fs/f2fs/sysfs.c | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Eric Biggers <ebiggers@google.com>
