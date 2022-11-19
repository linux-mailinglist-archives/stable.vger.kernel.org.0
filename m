Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E829630CF1
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 08:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiKSHZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 02:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbiKSHZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 02:25:25 -0500
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A114B97ED;
        Fri, 18 Nov 2022 23:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v+TMF0GoA12PKZwucJCzZsmn+Fpr6Lb0dJsJFpaSjz8=; b=Mo4CcAFlo05KzZxw3DDzGY45u5
        zzuw94a3Z1kAqqFmtCJKVxkGONaXJVZA88E0Ww6xcjiWlblogUrCR8M+CIIATCqnbkHBc4VWORz9a
        n5steYdp4rvstRk6eTMJNkRWMtMYyGQdw2d6KbjtPvn4Nt6gMx3jH0FmmN70Bzv4a8TzuY6YlEugX
        VA8tdcU5fSWKMWRmVyOPXAl+DyoZXGhKVi+ZVpPZtqX3nSkBybsQIWYjX3vuqc8BXs+A0jjRw2g1c
        5ln6nzT0TeW3mzLPa9OlolyhM6f1JwwFPHQ57Yd58kkSASoiQoPuxdam3ooFkLhjvpo5pPP531Me4
        2E1CKsfQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1owIE5-0050bd-0l;
        Sat, 19 Nov 2022 07:25:21 +0000
Date:   Sat, 19 Nov 2022 07:25:21 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Peter Griffin <peter.griffin@linaro.org>
Cc:     Miklos Szeredi <mszeredi@redhat.com>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will McVicker <willmcvicker@google.com>,
        Peter Griffin <gpeter@google.com>
Subject: Re: [PATCH] vfs: vfs_tmpfile: ensure O_EXCL flag is enforced
Message-ID: <Y3iE4WjBfqmFJb/h@ZenIV>
References: <20221103170210.464155-1-peter.griffin@linaro.org>
 <CAJfpeguUEb++huEOdtVMgC2hbqh4f5+7iOomJ=fin-RE=pu8jQ@mail.gmail.com>
 <CADrjBPotAaBMpPjaVZ_aXQMt-RF6wiYpeYZT=5dZS_E=vGv2eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrjBPotAaBMpPjaVZ_aXQMt-RF6wiYpeYZT=5dZS_E=vGv2eg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 02:38:15PM +0000, Peter Griffin wrote:

> commit that reworked the tmpfile vfs logic and introduced the
> regression. Can you pick up this commit and send it onto Linus
> for inclusion into the next v6.1-rc release?
> 
> Note, it fixes a regression for userspace introduced in this merge
> window so I was hoping to get the fix into the next -rc so that the
> v6.1 release does not contain this bug.

Applied to #fixes and pushed out; will send a pull request to Linus
tomorrow...
