Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20E722FB4B
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgG0VYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgG0VYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 17:24:42 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B47CE20809;
        Mon, 27 Jul 2020 21:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595885081;
        bh=sKT9dOZLdTtnGzBRMm9NIlmWlhGrnDruKWwTGc0i87g=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=TrfApfyDkawTo5JDjIIS7XtMYH/XAsW66iLEldPQ1Xn8c3+hKCAzN8lYRbIax3X4Q
         eiFL9Oiq7+2pVrbQ0FRxmmsagRCaaJgBcxJ5p24WoCSEnRpu6gVH3pZnrByLzftTqG
         mNRalbwKMy+yRgPbOHeuQkMX4Qlb3MREDnhbXZZQ=
Date:   Mon, 27 Jul 2020 21:24:40 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] media: uvcvideo: Fix uvc_ctrl_fixup_xu_info() not having any effect
In-Reply-To: <20200724114823.108237-1-hdegoede@redhat.com>
References: <20200724114823.108237-1-hdegoede@redhat.com>
Message-Id: <20200727212441.B47CE20809@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.10, v5.4.53, v4.19.134, v4.14.189, v4.9.231, v4.4.231.

v5.7.10: Build OK!
v5.4.53: Build OK!
v4.19.134: Build OK!
v4.14.189: Failed to apply! Possible dependencies:
    859086ae3636 ("media: uvcvideo: Apply flags from device to actual properties")

v4.9.231: Failed to apply! Possible dependencies:
    859086ae3636 ("media: uvcvideo: Apply flags from device to actual properties")

v4.4.231: Failed to apply! Possible dependencies:
    859086ae3636 ("media: uvcvideo: Apply flags from device to actual properties")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
