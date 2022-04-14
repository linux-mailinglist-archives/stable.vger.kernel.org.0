Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C585500B69
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbiDNKsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 06:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242626AbiDNKsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 06:48:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A908F18367
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 03:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 14A02CE294A
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEB0C385A1;
        Thu, 14 Apr 2022 10:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649933139;
        bh=MeV2mmZwfChhn44PR++Fo3PPFqGtnFvzYThGrijuJpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rpbjeZFPpzc1UzCXklTh2F9hlsNEzJaXcncTBawkdYITYvyS52kk42Ms2tgJANGBl
         aiN8cW7FD4gzZ3cSq/eSRC2YiUmQKkJp5ojDTEGoJKhVa92Fqu0cxzDlqr5BcSCQZK
         NX/XsweqHiSbFtgVoRqqtlzgyh1FsdsfEh3/Znns=
Date:   Thu, 14 Apr 2022 12:45:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>,
        Harry Wentland <harry.wentland@amd.com>, richard.gong@amd.com
Subject: Re: [PATCH 1/2] drm/amd/display: Add pstate verification and
 recovery for DCN31
Message-ID: <Ylf7UEKnjHW6p7Em@kroah.com>
References: <20220413153339.1436168-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413153339.1436168-1-alexander.deucher@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 13, 2022 at 11:33:38AM -0400, Alex Deucher wrote:
> From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> 
> [Why]
> To debug when p-state is being blocked and avoid PMFW hangs when
> it does occur.
> 
> [How]
> Re-use the DCN10 hardware sequencer by adding a new interface for
> verifying p-state high on the hubbub. The interface is mostly the
> same as the DCN10 interface, but the bit definitions have changed for
> the debug bus.
> 
> Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
> Reviewed-by: Harry Wentland <harry.wentland@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit e7031d8258f1b4d6d50e5e5b5d92ba16f66eb8b4)
> Cc: richard.gong@amd.com
> Cc: nicholas.kazlauskas@amd.com
> Cc: stable@vger.kernel.org # 3.15.x

This does not apply to all of those kernels.  Please provide backports
for the ones you want it applied to older than 5.15.y

thanks,

greg k-h
