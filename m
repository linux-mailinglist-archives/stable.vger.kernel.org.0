Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3244776E
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 01:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfFPX6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 19:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbfFPX6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 Jun 2019 19:58:01 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 425F920818;
        Sun, 16 Jun 2019 23:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560729480;
        bh=cHNxvIRxlvAU4gIUpeSeC7yOO23JD08MUbqzWbKc62M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JbY6T0tYa7GS/QgTebatIMbUl7K0CPFFLZFIwZ09kxDqWdiIkh/2WuE2TO3KAarUm
         Knlvim0KllnjmeRRY5LC0tRCJZ01K2FBBy1TQdgerh0IlgKiUM+KSRupGf5ef7qX6h
         HQ00RtrORG7zqKdRjKH+JIvfovORnjY/QAW2DaOU=
Date:   Sun, 16 Jun 2019 19:57:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Murray McAllister <murray.mcallister@gmail.com>
Cc:     stable@vger.kernel.org, linux-graphics-maintainer@vmware.com,
        thellstrom@vmware.com
Subject: Re: [PATCH] Backport commit 5ed7f4b5eca1 ("drm/vmwgfx: integer
 underflow in vmw_cmd_dx_set_shader() leading to an invalid read") to
 linux-5.1-stable
Message-ID: <20190616235757.GA2226@sasha-vm>
References: <20190616055740.4055-1-murray.mcallister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190616055740.4055-1-murray.mcallister@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 16, 2019 at 05:57:40PM +1200, Murray McAllister wrote:
>Commit 5ed7f4b5eca1 ("drm/vmwgfx: integer underflow in
>vmw_cmd_dx_set_shader() leading to an invalid read") upstream.
>
>Commit 5ed7f4b5eca1 ("drm/vmwgfx: integer underflow in
>vmw_cmd_dx_set_shader() leading to an invalid read") resolved
>an integer underflow when SVGA_3D_CMD_DX_SET_SHADER was called
>with a shader ID of SVGA3D_INVALID_ID, and a shader type of
>SVGA3D_SHADERTYPE_INVALID.
>
>(The original patch failed to apply cleanly in 5.1-stable
>as VMW_DEBUG_USER does not exist here.)

What about 4.19 and 4.14?

Also, don't modify the commit message/subject, just add your backporting
notes to the original commit message.

--
Thanks,
Sasha
