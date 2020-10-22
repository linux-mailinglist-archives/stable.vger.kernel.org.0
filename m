Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBD829625B
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 18:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895446AbgJVQJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 12:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895440AbgJVQJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Oct 2020 12:09:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F28324182;
        Thu, 22 Oct 2020 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603382991;
        bh=TmqdKEDpzokkSYBf6Olofb6ooIl6uJH+k5K1oSNqZM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HIOV8EvPe2pW2/o3i3ejjqBhurg00S5aYWhvZGtMiF5NFfGSZRLpxAO1UZ5uVRYpw
         rD+qYb9o3RX1ZBOcNiT7cY8FPobLmy6gWSR931g9f239/iKOmrIs8gzEXlC0tyWsL/
         p3wEZNxxZ9phcMbxHMOeX/QWrIYM5IR8sZHs4cgQ=
Date:   Thu, 22 Oct 2020 18:10:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "Wentland, Harry" <harry.wentland@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Marek Olsak <maraeo@gmail.com>,
        "Kazlauskas, Nicholas" <nicholas.kazlauskas@amd.com>,
        "Leo (Sunpeng) Li" <sunpeng.li@amd.com>,
        "for 3.8" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 03/11] drm/amd/display: Honor the offset for plane 0.
Message-ID: <20201022161029.GA1979067@kroah.com>
References: <20201021233130.874615-1-bas@basnieuwenhuizen.nl>
 <20201021233130.874615-4-bas@basnieuwenhuizen.nl>
 <CADnq5_OuXhN-2Raie9V452KrG4ChaguY1q6+Gk19mR86A=Fkog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_OuXhN-2Raie9V452KrG4ChaguY1q6+Gk19mR86A=Fkog@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 22, 2020 at 11:36:12AM -0400, Alex Deucher wrote:
> On Wed, Oct 21, 2020 at 7:31 PM Bas Nieuwenhuizen
> <bas@basnieuwenhuizen.nl> wrote:
> >
> > With modifiers I'd like to support non-dedicated buffers for
> > images.
> >
> > Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> > Cc: stable@vger.kernel.org # 5.1.0
> 
> I think you need # 5.1.x- for it to be applied to all stable kernels
> since 5.1 otherwise it will just apply to 5.1.x

Not true, I will try from the number up to the latest version.  So all
should be fine here.

thanks,

greg k-h
