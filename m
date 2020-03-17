Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664D2189171
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 23:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgCQWa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 18:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgCQWaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 18:30:24 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBD7520409;
        Tue, 17 Mar 2020 22:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584484224;
        bh=ibQhvw8+gfnMlgmHVmrmN2H4AxHbCAV5MSdDDFt53zk=;
        h=Date:From:To:To:To:CC:Cc:Cc:Subject:In-Reply-To:References:From;
        b=a9PNS6nlbKgpaHuC5RfpLw3sAEeNLrEhjhpOItMZWGo+iaPD236eRdoHKU+z1jbsG
         7sorpyJk9tcPyUyUOKRk91cs/4huvU/I/Jtca1lJcw5O7Qs+RW+mjJowXTFEWHIKyH
         yQIkSbv9M7HAByrvYMxzS6d25XedsqKeyegjeClU=
Date:   Tue, 17 Mar 2020 22:30:23 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
To:     Steve Longerbeam <slongerbeam@gmail.com>
CC:     Tomi Valkeinen <tomi.valkeinen@ti.com>, <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] media: ov5640: fix use of destroyed mutex
In-Reply-To: <20200313131948.13803-1-tomi.valkeinen@ti.com>
References: <20200313131948.13803-1-tomi.valkeinen@ti.com>
Message-Id: <20200317223023.BBD7520409@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.109, v4.14.173, v4.9.216, v4.4.216.

v5.5.9: Build OK!
v5.4.25: Build OK!
v4.19.109: Build OK!
v4.14.173: Build OK!
v4.9.216: Failed to apply! Possible dependencies:
    19a81c1426c1 ("[media] add Omnivision OV5640 sensor driver")
    34aa88790bad ("[media] ov2640: convert from soc-camera to a standard subdev sensor driver")
    6713c88fd047 ("[media] media: i2c: soc_camera: constify v4l2_subdev_* structures")
    9823f003b96c ("[media] ov2640: fix colorspace handling")
    9cae97221aab ("[media] media: Add a driver for the ov5645 camera sensor")

v4.4.216: Failed to apply! Possible dependencies:
    10d5509c8d50 ("[media] v4l2: remove g/s_crop from video ops")
    163c9bca101c ("[media] tuner.h: rename TUNER_PAD_IF_OUTPUT to TUNER_PAD_OUTPUT")
    19a81c1426c1 ("[media] add Omnivision OV5640 sensor driver")
    21c29de1d090 ("[media] v4l2-subdev.h: Improve documentation")
    32fdc0e1a87c ("[media] uapi/media.h: Fix entity namespace")
    34aa88790bad ("[media] ov2640: convert from soc-camera to a standard subdev sensor driver")
    684ffa2d5538 ("[media] doc-rst: split media_drivers.rst into one file per API type")
    6aad127d37b6 ("[media] v4l2-mc.h: move tuner PAD definitions to this new header")
    8211b187ec64 ("[media] dvbdev: add support for interfaces")
    89cb3ddbe7cc ("[media] doc-rst: Fix conversion for v4l2 core functions")
    8df00a15817e ("[media] media: rename the function that create pad links")
    9823f003b96c ("[media] ov2640: fix colorspace handling")
    9cae97221aab ("[media] media: Add a driver for the ov5645 camera sensor")
    a0cce2a05756 ("[media] dvbdev: create links on devices with multiple frontends")
    d26a5d4350fd ("[media] doc-rst: Convert media API to rst")
    dd3a46bbbe1d ("[media] tvp5150: Add g_mbus_config subdev operation support")
    df2f94e563ed ("[media] dvb: modify core to implement interfaces/entities at MC new gen")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
