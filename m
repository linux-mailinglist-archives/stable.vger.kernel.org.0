Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B4020A15B
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 16:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405577AbgFYOyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 10:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405651AbgFYOyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 10:54:02 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7347F20823;
        Thu, 25 Jun 2020 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593096841;
        bh=iP34x0/dzDt35QnLn+fJhL9nLn7ClGgA/LTF/NcqM58=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=EV1VdAt+DK3hse5WGBvufvZIpPSh88NTG+0d6MVK5OPeWP+PgwMYptzchqeAs3nvE
         Q+UBAvTg27xAB4q4iMWt0s5hVCYO2OZjY0c5Jz/DP6CSkHEVGkspqSZzbKV2nnZxsj
         inS3kOHc1m4Y849mtkjVG+uyERE0GATFY4umP0WE=
Date:   Thu, 25 Jun 2020 14:54:00 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To:     mchehab@kernel.org
Cc:     laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] media: media-request: Fix crash if memory allocation fails
In-Reply-To: <20200621113040.3540-1-tuomas.tynkkynen@iki.fi>
References: <20200621113040.3540-1-tuomas.tynkkynen@iki.fi>
Message-Id: <20200625145401.7347F20823@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.5, v5.4.48, v4.19.129, v4.14.185, v4.9.228, v4.4.228.

v5.7.5: Build OK!
v5.4.48: Build OK!
v4.19.129: Failed to apply! Possible dependencies:
    10905d70d7884 ("media: media-request: implement media requests")

v4.14.185: Failed to apply! Possible dependencies:
    10905d70d7884 ("media: media-request: implement media requests")

v4.9.228: Failed to apply! Possible dependencies:
    10905d70d7884 ("media: media-request: implement media requests")

v4.4.228: Failed to apply! Possible dependencies:
    0e576b76f5470 ("[media] media-entity.h: rename entity.type to entity.function")
    10905d70d7884 ("media: media-request: implement media requests")
    32fdc0e1a87c1 ("[media] uapi/media.h: Fix entity namespace")
    8211b187ec646 ("[media] dvbdev: add support for interfaces")
    8309f47c32c04 ("[media] media-device: add support for MEDIA_IOC_G_TOPOLOGY ioctl")
    8df00a15817e3 ("[media] media: rename the function that create pad links")
    bb07bd6b68511 ("[media] allow overriding the driver name")
    bcd5081b05367 ("[media] media: Refactor copying IOCTL arguments from and to user space")
    bed6919665072 ("[media] au0828: Add support for media controller")
    df2f94e563edc ("[media] dvb: modify core to implement interfaces/entities at MC new gen")
    df9ecb0cad14b ("[media] vb2: drop v4l2_format argument from queue_setup")
    fa762394fd85c ("[media] media: create a macro to get entity ID")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
