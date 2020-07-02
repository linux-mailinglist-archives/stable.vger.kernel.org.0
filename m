Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32DA212BBC
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 19:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgGBR7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 13:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbgGBR7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 13:59:07 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC7920760;
        Thu,  2 Jul 2020 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593712746;
        bh=eh4Fp0bh8AxElOsxWgAEVayHYjgJPhAdvGEgznM/jQM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oibj5Vb8A14kzOrGT3E3inN3tkufdcIuF8MapJZZk8MNinChxXtYBSFRtyM3E1qIX
         1E6C3wwS+33N5vDXQBsq4CQYWxHa2eVtw5epVirvQIhMxM+v6/Le9mURckACfR5Kal
         Tvouw/7ZXbNlQfnt9UQzM20WGhCogDVpKMvjnfnk=
Date:   Thu, 2 Jul 2020 13:59:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stylon.wang@amd.com, Nicholas.Kazlauskas@amd.com,
        Rodrigo.Siqueira@amd.com, alexander.deucher@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amd/display: Fix ineffective setting
 of max bpc property" failed to apply to 5.7-stable tree
Message-ID: <20200702175905.GE2722994@sasha-vm>
References: <159343042310143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159343042310143@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 01:33:43PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.7-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From fa7041d9d2fc7401cece43f305eb5b87b7017fc4 Mon Sep 17 00:00:00 2001
>From: Stylon Wang <stylon.wang@amd.com>
>Date: Fri, 12 Jun 2020 19:04:18 +0800
>Subject: [PATCH] drm/amd/display: Fix ineffective setting of max bpc property
>
>[Why]
>Regression was introduced where setting max bpc property has no effect
>on the atomic check and final commit. It has the same effect as max bpc
>being stuck at 8.
>
>[How]
>Correctly propagate max bpc with the new connector state.
>
>Signed-off-by: Stylon Wang <stylon.wang@amd.com>
>Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
>Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
>Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>Cc: stable@vger.kernel.org

I've grabbed this patch as a dependency and queued both for 5.7:
cbd14ae7ea93 ("drm/amd/display: Fix incorrectly pruned modes with deep
color").

-- 
Thanks,
Sasha
