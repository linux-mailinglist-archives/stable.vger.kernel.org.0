Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8684EAC24
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 13:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbiC2LYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 07:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiC2LYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 07:24:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B60182AC5
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 04:22:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F3ECACE16FB
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 11:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90E9C2BBE4;
        Tue, 29 Mar 2022 11:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648552966;
        bh=lMbweRsvMg6ke4fzVUbjtOnSRRdhCVmRO0irg9ROVbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p4Hc/G20De3AvvlXkyUGN3ngtlPgyWCueTEqHUcA4EODcOWx9bmDHiJ+G/xd2wvYz
         Vx8DYbOKyEKNpZ9Ge9pz/E5vyyp/nj4Z0a7avCsLp+6P3RZ+KoKVsYGrwtXnecNf3P
         TOx+oEPqCTH7RIGbGAdkufqfm0rSWJ22lWfyZGnY=
Date:   Tue, 29 Mar 2022 13:22:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mark Pearson <mpearson@lenovo.com>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: Re: _PR3 backports for amdgpu in 5.17
Message-ID: <YkLsAxY5iliMrE7L@kroah.com>
References: <BL1PR12MB51575E79E52C3C23B8413CA4E21E9@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB51575E79E52C3C23B8413CA4E21E9@BL1PR12MB5157.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29, 2022 at 01:50:02AM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> Some OEM platforms containing AMD APU + AMD dGPU contain ACPI _PR3 objects that are mistakenly activating the wrong power management features.
> This is fixed in mainline by the following commits that backport cleanly to 5.17.y:
> 
> commit 901e2be20dc5 ("drm/amdgpu: move PX checking into amdgpu_device_ip_early_init")
> commit 85ac2021fe3ac ("drm/amdgpu: only check for _PR3 on dGPUs")
> 
> Can you please bring these to 5.17.y?  They *do not* backport cleanly to earlier stable trees, and a separate backport will be submitted for those.

All now queued up, thanks.

greg k-h
