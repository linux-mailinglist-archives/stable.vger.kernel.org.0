Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1403CA8310
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 14:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbfIDMfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 08:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729727AbfIDMff (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 08:35:35 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED0DD23402;
        Wed,  4 Sep 2019 12:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567600535;
        bh=tPUbwpTSV2h9QUZkQKDoPP8mk4/cEB+ba4F4eQQvKIo=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=qbjUis1sW00d/fzu5weVbWWHby7E7MMDlUC6It0itDeaSMnB7gZl7rU1n+Ua1E0mv
         VyC1iZKJjFBrygRNuqi3sk06i7XZvc3gnKcl14GfyfuqxMoMlhl2TEf+jwuvcrZswR
         tbECvVd3otfhfKtVdXCklQnOj4L3GphPn8crRzB8=
Date:   Wed, 04 Sep 2019 12:35:34 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda/realtek - Fix the problem of two front mics on a ThinkCentre
In-Reply-To: <20190904055327.9883-1-hui.wang@canonical.com>
References: <20190904055327.9883-1-hui.wang@canonical.com>
Message-Id: <20190904123534.ED0DD23402@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.2.11, v4.19.69, v4.14.141, v4.9.190, v4.4.190.

v5.2.11: Build OK!
v4.19.69: Build OK!
v4.14.141: Build OK!
v4.9.190: Failed to apply! Possible dependencies:
    216d7aebbfbe ("ALSA: hda/realtek - Fix headset mic and speaker on Asus X441SA/X441UV")
    5824ce8de7b1 ("ALSA: hda/realtek - Add support for Acer Aspire E5-475 headset mic")
    615966adc4b6 ("ALSA: hda/realtek - Fix headset mic on several Asus laptops with ALC255")
    823ff161fe51 ("ALSA: hda - Fix click noises on Samsung Ativ Book 8")
    8da5bbfc7cbb ("ALSA: hda - change the location for one mic on a Lenovo machine")
    9eb5d0e635eb ("ALSA: hda/realtek - Add support headphone Mic for ALC221 of HP platform")
    c1732ede5e80 ("ALSA: hda/realtek - Fix headset and mic on several Asus laptops with ALC256")
    c6790c8e770c ("ALSA: hda/realtek - Add support for headset MIC for ALC622")
    ca169cc2f9e1 ("ALSA: hda/realtek - Add Dual Codecs support for Lenovo P520/420")
    f33f79f3d0e5 ("ALSA: hda/realtek - change the location for one of two front microphones")

v4.4.190: Failed to apply! Possible dependencies:
    1a3f099101b8 ("ALSA: hda - Fix surround output pins for ASRock B150M mobo")
    216d7aebbfbe ("ALSA: hda/realtek - Fix headset mic and speaker on Asus X441SA/X441UV")
    5824ce8de7b1 ("ALSA: hda/realtek - Add support for Acer Aspire E5-475 headset mic")
    615966adc4b6 ("ALSA: hda/realtek - Fix headset mic on several Asus laptops with ALC255")
    78f4f7c2341f ("ALSA: hda/realtek - ALC891 headset mode for Dell")
    823ff161fe51 ("ALSA: hda - Fix click noises on Samsung Ativ Book 8")
    8da5bbfc7cbb ("ALSA: hda - change the location for one mic on a Lenovo machine")
    9b51fe3efe4c ("ALSA: hda - On-board speaker fixup on ACER Veriton")
    9eb5d0e635eb ("ALSA: hda/realtek - Add support headphone Mic for ALC221 of HP platform")
    abaa2274811d ("ALSA: hda/realtek - fix headset mic detection for MSI MS-B120")
    c1732ede5e80 ("ALSA: hda/realtek - Fix headset and mic on several Asus laptops with ALC256")
    c6790c8e770c ("ALSA: hda/realtek - Add support for headset MIC for ALC622")
    ca169cc2f9e1 ("ALSA: hda/realtek - Add Dual Codecs support for Lenovo P520/420")
    f33f79f3d0e5 ("ALSA: hda/realtek - change the location for one of two front microphones")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
