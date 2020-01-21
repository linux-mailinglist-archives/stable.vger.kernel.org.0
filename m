Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50339144091
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 16:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAUPfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 10:35:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbgAUPfI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 10:35:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36A8620882;
        Tue, 21 Jan 2020 15:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579620907;
        bh=E8Ne3cpUONHzBRTClLDo+p4jQEELLgdoT002YmWvHcY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gNsVTfAuFsI+Qqdf6ih7b6ja1Zn9TUhfXRbdX0e1rPmXs/ojl+P/fK1uEZMpZlqL9
         Ec26cMExZ/ecajcfRnTkHgvOWexR1eGnukgWnYPn5lHVo0BgsLbXrgiho3uCRy5A8f
         Gr8r3qYI55d3WCFi3N/a3QQKIVSdbXz/bR2IkMkE=
Date:   Tue, 21 Jan 2020 16:35:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     stable@vger.kernel.org, changzhu <Changfeng.Zhu@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH] drm/amdgpu: allow direct upload save restore list for
 raven2
Message-ID: <20200121153505.GA587490@kroah.com>
References: <20200120182439.602448-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120182439.602448-1-alexander.deucher@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 20, 2020 at 01:24:39PM -0500, Alex Deucher wrote:
> From: changzhu <Changfeng.Zhu@amd.com>
> 
> It will cause modprobe atombios stuck problem in raven2 if it doesn't
> allow direct upload save restore list from gfx driver.
> So it needs to allow direct upload save restore list for raven2
> temporarily.
> 
> Bug: https://gitlab.freedesktop.org/drm/amd/issues/1013
> Signed-off-by: changzhu <Changfeng.Zhu@amd.com>
> Reviewed-by: Huang Rui <ray.huang@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit eebc7f4d7ffa09f2a620bd1e2c67ddd579118af9)
> Cc: <stable@vger.kernel.org> # 5.4.x
> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Now backported, thanks.

greg k-h
