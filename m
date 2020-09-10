Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C55E2649EC
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 18:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgIJQf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 12:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbgIJQed (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 12:34:33 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E45221E7;
        Thu, 10 Sep 2020 16:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599755662;
        bh=AVr+KGSCdzQ6xTrmfRGUpuSjtsa56NMukFTGjePtzIo=;
        h=Date:From:To:To:To:CC:Cc:Cc:Subject:In-Reply-To:References:From;
        b=FhbQ6LDq+orsxc51/ttPZOUzDgglwdDLQgg2NsVsK+KDnV640orkKGsqeQPeORaua
         HoPkGkDXV9Xn2yT334FlL7bxJCLLn+UcBoWoLTFMm98bzIOwSDCP95azaov8E01B+o
         61HQpO3Gmdiqlknm8bzmUnDv/0GPkNpr1UpYJt/A=
Date:   Thu, 10 Sep 2020 16:34:21 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <alsa-devel@alsa-project.org>
CC:     Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ALSA: usb-audio: Add delay quirk for H570e USB headsets
In-Reply-To: <20200910085328.19188-1-joakim.tjernlund@infinera.com>
References: <20200910085328.19188-1-joakim.tjernlund@infinera.com>
Message-Id: <20200910163421.C2E45221E7@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.7: Build OK!
v5.4.63: Build OK!
v4.19.143: Build OK!
v4.14.196: Build OK!
v4.9.235: Build OK!
v4.4.235: Failed to apply! Possible dependencies:
    71426535f49f ("ALSA: usb-audio: Add native DSD support for Luxman DA-06")
    74dc71f83e50 ("ALSA: usb-audio: FIX native DSD support for TEAC UD-501 DAC")
    79289e24194a ("ALSA: usb-audio: Refer to chip->usb_id for quirks and MIDI creation")
    7f38ca047b0c ("ALSA: usb-audio: Add native DSD support for TEAC 501/503 DAC")
    866f7ed7d679 ("ALSA: usb-audio: Add native DSD support for Esoteric D-05X")
    b00214865d65 ("ALSA: usb-audio: Add native DSD support for TEAC UD-301")
    df3f0347fd85 ("ALSA: usb-audio: quirks: Replace mdelay() with msleep() and usleep_range()")
    f3b906d720e4 ("ALSA: usb-audio: Integrate native DSD support for ITF-USB based DACs.")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
