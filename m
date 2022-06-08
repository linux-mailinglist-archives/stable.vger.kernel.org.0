Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26745437E8
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 17:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244599AbiFHPrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 11:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244807AbiFHPrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 11:47:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A125457AD
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 08:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78063B8261C
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 15:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9360C3411E;
        Wed,  8 Jun 2022 15:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654703230;
        bh=tjzTswwnrHhL6b9lQGL1L6tReDW4FTuPyQOv3mONa9k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k2H7wZGAthB9nK5vcxX0wwh68dx52SZtilqh/N4VwH0O0U6nllFeRPFqtbmJYdqEx
         CtBgMvg1ekZz2OjqHyOf1ZGprGHn+r5yIijCkVbU7z57h+xKBSFRj/2VfpWuirBWpp
         yVbsAdQQBYahu+2Wx/nnFeiswgGTUPC5/aH2jx7U=
Date:   Wed, 8 Jun 2022 17:47:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>
Subject: Re: [PATCH] drm/amd/pm: correct the metrics version for SMU
 11.0.11/12/13
Message-ID: <YqDEe0shEmrRR+Sc@kroah.com>
References: <20220608145150.3536211-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608145150.3536211-1-alexander.deucher@amd.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 10:51:50AM -0400, Alex Deucher wrote:
> From: Evan Quan <evan.quan@amd.com>
> 
> Correct the metrics version used for SMU 11.0.11/12/13.
> Fixes misreported GPU metrics (e.g., fan speed, etc.) depending
> on which version of SMU firmware is loaded.
> 
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1925
> Signed-off-by: Evan Quan <evan.quan@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit 396beb91a9eb86cbfa404e4220cca8f3ada70777)
> Cc: stable@vger.kernel.org
> ---
>  .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   | 57 ++++++++++++++-----
>  1 file changed, 44 insertions(+), 13 deletions(-)

What stable tree(s) are you wanting this backported to?

thanks,

greg k-h
