Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354AE461CCF
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 18:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346043AbhK2RjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 12:39:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35584 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349796AbhK2RhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 12:37:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC555B80EB9
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1DAC53FAD;
        Mon, 29 Nov 2021 17:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638207232;
        bh=XCDtQPPr+bP2/rx5lDngPVwS5ksWh9b89FG6+/mjxqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VJa+s6GhnJo7+PJNfqOrSOnZiPe7cg/bXXG1PQx1P2pZny62ohjfM3fJUt6J6lf7s
         wtErktQxSEg3nbXU8UVQ7hFCGrI71qvC7s+qZl0qcQcbTtoQxlUgYTKYM1KgA0qvlS
         RZtX1RIb7IlXRIdRTPTQbfTdjMfhAi0I1mcE2x9Y=
Date:   Mon, 29 Nov 2021 18:33:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, Luben Tuikov <luben.tuikov@amd.com>
Subject: Re: [PATCH 1/2] drm/amdgpu/gfx10: add wraparound gpu counter check
 for APUs as well
Message-ID: <YaUO/mlVnK97/0YD@kroah.com>
References: <20211129171803.421378-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129171803.421378-1-alexander.deucher@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 12:18:02PM -0500, Alex Deucher wrote:
> Apply the same check we do for dGPUs for APUs as well.
> 
> Acked-by: Luben Tuikov <luben.tuikov@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit 244ee398855df2adc7d3ac5702b58424a5f684cc)
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)

Both now queued up, thanks.

greg k-h
