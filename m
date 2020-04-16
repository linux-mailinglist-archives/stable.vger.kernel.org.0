Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6591AB601
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 04:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389035AbgDPCm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 22:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732153AbgDPCm4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 22:42:56 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D344206F9;
        Thu, 16 Apr 2020 02:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587004975;
        bh=hrHnrM428jXmylq2w+iiUO2REOqJI4DpnqaDRs64tAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ydaz4LCFCjAu3e2mIwPdBIXeU+bEjpJDWPs6m3fIR0uQhwOWvYZsuJyIQePoysaOg
         Hf2s0FRNJsdyl4/H9X6md8dBYkaHYlgRAS0dhWQaQfubpHGmx+HvueHIJaFdWkle6G
         p7hkugwq6cYnfdp2MBMyuj5NFOGJrjlXQMzXYpcU=
Date:   Wed, 15 Apr 2020 22:42:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     imre.deak@intel.com, jose.souza@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/i915/icl+: Don't enable DDI IO power
 on a TypeC port in" failed to apply to 5.5-stable tree
Message-ID: <20200416024254.GA1068@sasha-vm>
References: <158695052111011@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <158695052111011@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:35:21PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
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
>From 6e8a36c13382b7165d23928caee8d91c1b301142 Mon Sep 17 00:00:00 2001
>From: Imre Deak <imre.deak@intel.com>
>Date: Mon, 30 Mar 2020 18:22:44 +0300
>Subject: [PATCH] drm/i915/icl+: Don't enable DDI IO power on a TypeC port in
> TBT mode
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>The DDI IO power well must not be enabled for a TypeC port in TBT mode,
>ensure this during driver loading/system resume.
>
>This gets rid of error messages like
>[drm] *ERROR* power well DDI E TC2 IO state mismatch (refcount 1/enabled 0)
>
>and avoids leaking the power ref when disabling the output.
>
>Cc: <stable@vger.kernel.org> # v5.4+
>Signed-off-by: Imre Deak <imre.deak@intel.com>
>Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
>Link: https://patchwork.freedesktop.org/patch/msgid/20200330152244.11316-1-imre.deak@intel.com
>(cherry picked from commit f77a2db27f26c3ccba0681f7e89fef083718f07f)
>Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

Conflict because we didn't have b7d02c3a124d ("drm/i915: Pass
intel_encoder to enc_to_*()"). Fixed and queued up.

-- 
Thanks,
Sasha
