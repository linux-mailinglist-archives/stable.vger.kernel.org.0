Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314126023B1
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 07:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJRFUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 01:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiJRFUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 01:20:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E418A1F4
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 22:20:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9117AB81A0C
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 05:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACC6C433C1;
        Tue, 18 Oct 2022 05:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666070446;
        bh=kwWBH/nif8QxqkwcKqTC4kftjp46RnJBMj8AFMegplE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h2PIPZel+KW3LmhVvdMuYlExIgpTS2yTEJs1kO+vX/zQmUc1IQj/NxpDsTG4282P1
         iS+Vhr6sAKuihAdoQB0x2hDCmwXeCOKdGN+5uuE4+LE5ocgl7QfmdjvTWyupHhVy7A
         +K2ueq/IPIZO5g4UZ8Q6aIuz6RjvE7deY0krGizc=
Date:   Tue, 18 Oct 2022 07:21:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lijo Lazar <lijo.lazar@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Hawking.Zhang@amd.com,
        Alexander.Deucher@amd.com, helgaas@kernel.org, Guchun.Chen@amd.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x
Message-ID: <Y0433bWlP9OE/Hm1@kroah.com>
References: <20221018044724.86179-1-lijo.lazar@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018044724.86179-1-lijo.lazar@amd.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 18, 2022 at 10:17:24AM +0530, Lijo Lazar wrote:
> MMHUB 2.1.x versions don't have ATCL2. Remove accesses to ATCL2 registers.
> 
> Since they are non-existing registers, read access will cause a
> 'Completer Abort' and gets reported when AER is enabled with the below patch.
> Tagging with the patch so that this is backported along with it.
> 
> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
> 
> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c | 28 +++++++------------------
>  1 file changed, 8 insertions(+), 20 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
